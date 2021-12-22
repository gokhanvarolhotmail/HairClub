/* CreateDate: 11/02/2015 10:07:13.880 , ModifyDate: 01/05/2016 16:19:42.637 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Wegner - Workwise
-- Create date: 2015-05-19
-- Description:	Import Contact Address, Phone, Email data
--
-- Return values:
--		 0 - Processing occurred; row was established in cstd_import
--		-1 - error prevented new cstd_import row
--		-2 - @file_name not populated
--		-4 - @user_code not populated
--		-8 - @import target (ADDRESS, PHONE, EMAIL) not specified
--	   -16 - @import type (INTERNAL,EXTERNAL) not specified
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceImport]
	-- Add the parameters for the stored procedure here
	@import_id uniqueidentifier OUTPUT,
	@file_name nvarchar(100),
	@user_code nvarchar(20),
	@import_target_code nvarchar(10),
	@import_type_code nvarchar(10),
	@gvendor_code nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @returnValue int
	DECLARE @import_status_code nchar(10)

	SET @returnValue = 0
	SET @import_status_code = 'PASS'

	--Incoming parameter validation
	IF ISNULL(@file_name,'') = ''			SET @returnValue = @returnValue - 2
	IF ISNULL(@user_code,'') = ''			SET @returnValue = @returnValue - 4
	IF ISNULL(@import_target_code,'') = ''	SET @returnValue = @returnValue - 8
	IF ISNULL(@import_type_code,'') = ''	SET @returnValue = @returnValue - 16
	IF ISNULL(@gvendor_code,'') = ''		SET @returnValue = @returnValue - 32


	--Main Processing
	IF @returnValue = 0
	BEGIN
		--Establish initial cstd_skip_trace_import row
		SET @import_id = NEWID()
		IF (SELECT COUNT(*) FROM cstd_skip_trace_import WHERE skip_trace_import_file_name = @file_name AND skip_trace_import_type_code = @import_type_code) > 0
			SET @import_status_code = 'DUPLICATE'

		INSERT INTO cstd_skip_trace_import (skip_trace_import_id, skip_trace_import_date, skip_trace_import_file_name, skip_trace_import_target_code, skip_trace_import_type_code, skip_trace_import_status_code, skip_trace_import_user_code, skip_trace_vendor_code)
			VALUES
					(@import_id, GETDATE(), @file_name, @import_target_code, @import_type_code, @import_status_code, @user_code, @gvendor_code)
		IF @@ROWCOUNT = 0
			SET @returnValue = @returnValue - 1

		IF @returnValue = 0 AND @import_status_code = 'PASS'
		BEGIN
			--Process cstd_skip_trace_import_staging contents
			DECLARE @import_detail_id			uniqueidentifier
			DECLARE @import_target_table_id		nchar(20)
			DECLARE @vendor_code				nvarchar(20)
			DECLARE @contact_id					nchar(10)
			DECLARE @data_type					nvarchar(20)
			DECLARE @skip_sent_date				nvarchar(20)
			DECLARE @skip_request_id			nchar(10)
			DECLARE @skip_type_code				nchar(10)
			DECLARE @contact_address_id			nchar(10)
			DECLARE @append_address_type_code	nchar(10)
			DECLARE @append_address_1			nvarchar(60)
			DECLARE @append_address_2			nvarchar(60)
			DECLARE @append_address_3			nvarchar(60)
			DECLARE @append_city				nvarchar(60)
			DECLARE @append_state				nvarchar(20)
			DECLARE @append_zip_code			nvarchar(15)
			DECLARE @append_country_code		nvarchar(20)
			DECLARE @address_type_code			nchar(10)
			DECLARE @address_1					nvarchar(60)
			DECLARE @address_2					nvarchar(60)
			DECLARE @address_3					nvarchar(60)
			DECLARE @city						nvarchar(60)
			DECLARE @state						nvarchar(20)
			DECLARE @zip_code					nvarchar(15)
			DECLARE @country_code				nvarchar(20)
			DECLARE @contact_email_id			nchar(10)
			DECLARE @append_email_type_code		nchar(10)
			DECLARE @append_email				nvarchar(100)
			DECLARE @email_type_code			nchar(10)
			DECLARE @email						nvarchar(100)
			DECLARE @contact_phone_id			nchar(10)
			DECLARE @append_phone_type_code		nchar(10)
			DECLARE @append_country_prefix		nchar(10)
			DECLARE @append_area_code			nchar(10)
			DECLARE @append_phone				nvarchar(20)
			DECLARE @append_extension			nchar(10)
			DECLARE @phone_type_code			nchar(10)
			DECLARE @country_prefix				nchar(10)
			DECLARE @area_code					nchar(10)
			DECLARE @phone						nvarchar(20)
			DECLARE @extension					nchar(10)
			DECLARE @marketing_score			decimal(15,4)

			DECLARE @skip_sent_date_date		datetime
			DECLARE @row_number					int

			DECLARE importstaging CURSOR FOR
				SELECT
					vendor_code,
					contact_id,
					data_type,
					skip_sent_date,
					skip_request_id,
					skip_type_code,
					contact_address_id,
					append_address_type_code,
					append_address_1,
					append_address_2,
					append_address_3,
					append_city,
					append_state,
					append_zip_code,
					append_country_code,
					address_type_code,
					address_1,
					address_2,
					address_3,
					city,
					[state],
					zip_code,
					country_code,
					contact_email_id,
					append_email_type_code,
					append_email,
					email_type_code,
					email,
					contact_phone_id,
					append_phone_type_code,
					append_country_prefix,
					append_area_code,
					append_phone,
					append_extension,
					phone_type_code,
					country_prefix,
					area_code,
					phone,
					extension,
					marketing_score
				FROM cstd_skip_trace_import_staging

			OPEN importstaging
			FETCH importstaging INTO
				@vendor_code,
				@contact_id,
				@data_type,
				@skip_sent_date,
				@skip_request_id,
				@skip_type_code,
				@contact_address_id,
				@append_address_type_code,
				@append_address_1,
				@append_address_2,
				@append_address_3,
				@append_city,
				@append_state,
				@append_zip_code,
				@append_country_code,
				@address_type_code,
				@address_1,
				@address_2,
				@address_3,
				@city,
				@state,
				@zip_code,
				@country_code,
				@contact_email_id,
				@append_email_type_code,
				@append_email,
				@email_type_code,
				@email,
				@contact_phone_id,
				@append_phone_type_code,
				@append_country_prefix,
				@append_area_code,
				@append_phone,
				@append_extension,
				@phone_type_code,
				@country_prefix,
				@area_code,
				@phone,
				@extension,
				@marketing_score

			--cstd_skip_trace_import_staging loop
			SET @row_number = 0
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @import_detail_id = NEWID()
				IF @import_target_code = 'ADDRESS'
					SET @import_target_table_id = @contact_address_id
				IF @import_target_code = 'EMAIL'
					SET @import_target_table_id = @contact_email_id
				IF @import_target_code = 'PHONE'
					SET @import_target_table_id = @contact_phone_id

				--convert skip date string to datetime
				IF (ISNULL(@skip_sent_date, '') = '')
					SET @skip_sent_date_date = NULL
				ELSE
				BEGIN
					DECLARE @tempdate nvarchar(20)
					SET @tempdate = ''
					IF ISNUMERIC(SUBSTRING(@skip_sent_date,1,4)) = 1
						SET @tempdate = @tempdate + SUBSTRING(@skip_sent_date,1,4)
					ELSE
						SET @tempdate = @tempdate + '0000'

					IF ISNUMERIC(SUBSTRING(@skip_sent_date,5,2)) = 1
						SET @tempdate = @tempdate + '-' + SUBSTRING(@skip_sent_date,5,2)
					ELSE
						SET @tempdate = @tempdate + '-00'

					IF ISNUMERIC(SUBSTRING(@skip_sent_date,7,2)) = 1
						SET @tempdate = @tempdate + '-' + SUBSTRING(@skip_sent_date,7,2)
					ELSE
						SET @tempdate = @tempdate + '-00'

					IF ISNUMERIC(SUBSTRING(@skip_sent_date,9,2)) = 1
						SET @tempdate = @tempdate + ' ' + SUBSTRING(@skip_sent_date,9,2)
					ELSE
						SET @tempdate = @tempdate + ' 00'

					IF ISNUMERIC(SUBSTRING(@skip_sent_date,11,2)) = 1
						SET @tempdate = @tempdate + ':' + SUBSTRING(@skip_sent_date,11,2)
					ELSE
						SET @tempdate = @tempdate + ':00'

					IF ISDATE(@tempdate) = 1
						SET @skip_sent_date_date = CONVERT(datetime,@tempdate)
					ELSE
						SET @skip_sent_date_date = NULL
				END


				DECLARE @row_processing_status_code nchar(10)
				SET @row_processing_status_code = 'IMPORTED'
				SET @row_number = @row_number + 1

				--Establish intial cstd_skip_trace_import_detail row
				INSERT INTO cstd_skip_trace_import_detail (
					skip_trace_import_detail_id,
					skip_trace_import_id,
					[row_number],
					import_target_table_id_value,
					contact_id,
					data_type,
					skip_sent_date,
					skip_request_id,
					skip_type_code,
					skip_trace_import_row_processing_status_code,
					updated_address_type_code,
					updated_address_line_1,
					updated_address_line_2,
					updated_address_line_3,
					updated_city,
					updated_state_code,
					updated_zip_code,
					updated_country_code,
					original_address_line_1,
					original_address_line_2,
					original_address_line_3,
					original_city,
					original_state_code,
					original_zip_code,
					original_country_code,
					updated_phone_type_code,
					updated_country_code_prefix,
					updated_area_code,
					updated_phone_number,
					updated_extension,
					original_phone_type_code,
					original_country_code_prefix,
					original_area_code,
					original_phone_number,
					original_extension,
					updated_email_type_code,
					updated_email,
					original_email_type_code,
					original_email,
					skip_trace_vendor_code,
					marketing_score,
					creation_date
					)
				VALUES (
					@import_detail_id,
					@import_id,
					@row_number,
					@import_target_table_id,
					@contact_id,
					@data_type,
					@skip_sent_date_date,
					@skip_request_id,
					@skip_type_code,
					@row_processing_status_code,
					@append_address_type_code,
					@append_address_1,
					@append_address_2,
					@append_address_3,
					@append_city,
					@append_state,
					@append_zip_code,
					@append_country_code,
					@address_1,
					@address_2,
					@address_3,
					@city,
					@state,
					@zip_code,
					@country_code,
					@append_phone_type_code,
					@append_country_prefix,
					@append_area_code,
					@append_phone,
					@append_extension,
					@phone_type_code,
					@country_prefix,
					@area_code,
					@phone,
					@extension,
					@append_email_type_code,
					@append_email,
					@email_type_code,
					@email,
					@vendor_code,
					@marketing_score,
					GETDATE()
					)

				IF ISNULL(@contact_id,'') = ''
					SET @row_processing_status_code = 'IDNOTFOUND'
				ELSE IF (SELECT COUNT(*) FROM oncd_contact WHERE contact_id = @contact_id) = 0
					SET @row_processing_status_code = 'IDNOTFOUND'


				--update the row with the new data if there are no errors
				IF @row_processing_status_code = 'IMPORTED'
				BEGIN
					DECLARE @validationReturn nchar(10)
					IF @import_target_code = 'ADDRESS'
						EXEC psoSkipTraceImportValidateAndUpdateAddress @import_detail_id, @validationReturn OUTPUT
					IF @import_target_code = 'EMAIL'
						EXEC psoSkipTraceImportValidateAndUpdateEmail @import_detail_id, @validationReturn OUTPUT
					IF @import_target_code = 'PHONE'
						EXEC psoSkipTraceImportValidateAndUpdatePhone @import_detail_id, @validationReturn OUTPUT

					IF @validationReturn <> 'IMPORTED'
						UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @validationReturn WHERE skip_trace_import_detail_id = @import_detail_id
				END
				ELSE
					UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @row_processing_status_code WHERE skip_trace_import_detail_id = @import_detail_id



				FETCH importstaging INTO
					@vendor_code,
					@contact_id,
					@data_type,
					@skip_sent_date,
					@skip_request_id,
					@skip_type_code,
					@contact_address_id,
					@append_address_type_code,
					@append_address_1,
					@append_address_2,
					@append_address_3,
					@append_city,
					@append_state,
					@append_zip_code,
					@append_country_code,
					@address_type_code,
					@address_1,
					@address_2,
					@address_3,
					@city,
					@state,
					@zip_code,
					@country_code,
					@contact_email_id,
					@append_email_type_code,
					@append_email,
					@email_type_code,
					@email,
					@contact_phone_id,
					@append_phone_type_code,
					@append_country_prefix,
					@append_area_code,
					@append_phone,
					@append_extension,
					@phone_type_code,
					@country_prefix,
					@area_code,
					@phone,
					@extension,
					@marketing_score
			END

			CLOSE importstaging
			DEALLOCATE importstaging

			IF EXISTS (SELECT 1 FROM cstd_skip_trace_import_detail WHERE skip_trace_import_id = @import_id AND skip_trace_import_row_processing_status_code <> 'IMPORTED')
				UPDATE cstd_skip_trace_import SET skip_trace_import_status_code = 'ERROR' WHERE skip_trace_import_id = @import_id
		END
	END

	--TRUNCATE TABLE cstd_import_staging

	RETURN @returnValue
END
GO
