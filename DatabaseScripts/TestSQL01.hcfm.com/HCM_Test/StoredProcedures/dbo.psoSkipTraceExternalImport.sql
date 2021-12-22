/* CreateDate: 12/04/2015 15:38:36.207 , ModifyDate: 03/22/2016 10:58:43.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Wegner - Workwise
-- Create date: 2015-11-17
-- Description:	Import Contact Address, Phone, Email data from External Vendor
--
-- Return values:
--		 0 - Processing occurred; row was established in cstd_import
--		-1 - error prevented new cstd_import row
--		-2 - @file_name not populated
--		-4 - @user_code not populated
--	   -16 - @import type (INTERNAL,EXTERNAL) not specified
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExternalImport]
	-- Add the parameters for the stored procedure here
	@import_id uniqueidentifier OUTPUT,
	@file_name nvarchar(100),
	@user_code nvarchar(20),
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
					(@import_id, GETDATE(), @file_name, NULL, @import_type_code, @import_status_code, @user_code, @gvendor_code)
		IF @@ROWCOUNT = 0
			SET @returnValue = @returnValue - 1

		IF @returnValue = 0 AND @import_status_code = 'PASS'
		BEGIN
			--Process cstd_skip_trace_external_import_staging contents
			DECLARE @import_detail_id			uniqueidentifier
			DECLARE @import_target_table_id		nchar(20)
			DECLARE @vendor_code				nvarchar(20)
			DECLARE @contact_id					nchar(10)
			DECLARE @skip_trace_export_id		uniqueidentifier

			DECLARE @updated_address_line_1		nvarchar(60)
			DECLARE @updated_address_line_2		nvarchar(60)
			DECLARE @updated_city				nvarchar(60)
			DECLARE @updated_state_code			nvarchar(20)
			DECLARE @updated_zip_code			nvarchar(15)
			DECLARE @updated_area_code			nchar(10)
			DECLARE @updated_phone_number		nvarchar(20)
			DECLARE @updated_email				nvarchar(100)

			DECLARE @address1_line_1			nvarchar(60)
			DECLARE @address1_line_2			nvarchar(60)
			DECLARE @address1_city				nvarchar(60)
			DECLARE @address1_state_code		nvarchar(20)
			DECLARE @address1_zip_code			nvarchar(15)
			DECLARE @address2_line_1			nvarchar(60)
			DECLARE @address2_line_2			nvarchar(60)
			DECLARE @address2_city				nvarchar(60)
			DECLARE @address2_state_code		nvarchar(20)
			DECLARE @address2_zip_code			nvarchar(15)
			DECLARE @address3_line_1			nvarchar(60)
			DECLARE @address3_line_2			nvarchar(60)
			DECLARE @address3_city				nvarchar(60)
			DECLARE @address3_state_code		nvarchar(20)
			DECLARE @address3_zip_code			nvarchar(15)
			DECLARE @address4_line_1			nvarchar(60)
			DECLARE @address4_line_2			nvarchar(60)
			DECLARE @address4_city				nvarchar(60)
			DECLARE @address4_state_code		nvarchar(20)
			DECLARE @address4_zip_code			nvarchar(15)
			DECLARE @address5_line_1			nvarchar(60)
			DECLARE @address5_line_2			nvarchar(60)
			DECLARE @address5_city				nvarchar(60)
			DECLARE @address5_state_code		nvarchar(20)
			DECLARE @address5_zip_code			nvarchar(15)
			DECLARE @address6_line_1			nvarchar(60)
			DECLARE @address6_line_2			nvarchar(60)
			DECLARE @address6_city				nvarchar(60)
			DECLARE @address6_state_code		nvarchar(20)
			DECLARE @address6_zip_code			nvarchar(15)
			DECLARE @address7_line_1			nvarchar(60)
			DECLARE @address7_line_2			nvarchar(60)
			DECLARE @address7_city				nvarchar(60)
			DECLARE @address7_state_code		nvarchar(20)
			DECLARE @address7_zip_code			nvarchar(15)
			DECLARE @address8_line_1			nvarchar(60)
			DECLARE @address8_line_2			nvarchar(60)
			DECLARE @address8_city				nvarchar(60)
			DECLARE @address8_state_code		nvarchar(20)
			DECLARE @address8_zip_code			nvarchar(15)
			DECLARE @address9_line_1			nvarchar(60)
			DECLARE @address9_line_2			nvarchar(60)
			DECLARE @address9_city				nvarchar(60)
			DECLARE @address9_state_code		nvarchar(20)
			DECLARE @address9_zip_code			nvarchar(15)
			DECLARE @address10_line_1			nvarchar(60)
			DECLARE @address10_line_2			nvarchar(60)
			DECLARE @address10_city				nvarchar(60)
			DECLARE @address10_state_code		nvarchar(20)
			DECLARE @address10_zip_code			nvarchar(15)
			DECLARE @phone1_area_code			nchar(10)
			DECLARE @phone1_phone_number		nvarchar(20)
			DECLARE @phone2_area_code			nchar(10)
			DECLARE @phone2_phone_number		nvarchar(20)
			DECLARE @phone3_area_code			nchar(10)
			DECLARE @phone3_phone_number		nvarchar(20)
			DECLARE @phone4_area_code			nchar(10)
			DECLARE @phone4_phone_number		nvarchar(20)
			DECLARE @phone5_area_code			nchar(10)
			DECLARE @phone5_phone_number		nvarchar(20)
			DECLARE @phone6_area_code			nchar(10)
			DECLARE @phone6_phone_number		nvarchar(20)
			DECLARE @phone7_area_code			nchar(10)
			DECLARE @phone7_phone_number		nvarchar(20)
			DECLARE @phone8_area_code			nchar(10)
			DECLARE @phone8_phone_number		nvarchar(20)
			DECLARE @phone9_area_code			nchar(10)
			DECLARE @phone9_phone_number		nvarchar(20)
			DECLARE @phone10_area_code			nchar(10)
			DECLARE @phone10_phone_number		nvarchar(20)
			DECLARE @email1						nvarchar(100)
			DECLARE @email2						nvarchar(100)
			DECLARE @email3						nvarchar(100)
			DECLARE @email4						nvarchar(100)
			DECLARE @email5						nvarchar(100)
			DECLARE @email6						nvarchar(100)
			DECLARE @email7						nvarchar(100)
			DECLARE @email8						nvarchar(100)
			DECLARE @email9						nvarchar(100)
			DECLARE @email10					nvarchar(100)

			DECLARE @row_number					int

			DECLARE importstaging CURSOR FAST_FORWARD FOR
				SELECT
					vendor_code,
					contact_id,
					skip_trace_export_id,
					address1_line_1,
					address1_line_2,
					address1_city,
					address1_state_code,
					address1_zip_code,
					address2_line_1,
					address2_line_2,
					address2_city,
					address2_state_code,
					address2_zip_code,
					address3_line_1,
					address3_line_2,
					address3_city,
					address3_state_code,
					address3_zip_code,
					address4_line_1,
					address4_line_2,
					address4_city,
					address4_state_code,
					address4_zip_code,
					address5_line_1,
					address5_line_2,
					address5_city,
					address5_state_code,
					address5_zip_code,
					address6_line_1,
					address6_line_2,
					address6_city,
					address6_state_code,
					address6_zip_code,
					address7_line_1,
					address7_line_2,
					address7_city,
					address7_state_code,
					address7_zip_code,
					address8_line_1,
					address8_line_2,
					address8_city,
					address8_state_code,
					address8_zip_code,
					address9_line_1,
					address9_line_2,
					address9_city,
					address9_state_code,
					address9_zip_code,
					address10_line_1,
					address10_line_2,
					address10_city,
					address10_state_code,
					address10_zip_code,
					phone1_area_code,
					phone1_phone_number,
					phone2_area_code,
					phone2_phone_number,
					phone3_area_code,
					phone3_phone_number,
					phone4_area_code,
					phone4_phone_number,
					phone5_area_code,
					phone5_phone_number,
					phone6_area_code,
					phone6_phone_number,
					phone7_area_code,
					phone7_phone_number,
					phone8_area_code,
					phone8_phone_number,
					phone9_area_code,
					phone9_phone_number,
					phone10_area_code,
					phone10_phone_number,
					email1,
					email2,
					email3,
					email4,
					email5,
					email6,
					email7,
					email8,
					email9,
					email10
				FROM cstd_skip_trace_external_import_staging


			OPEN importstaging
			FETCH importstaging INTO
				@vendor_code,
				@contact_id,
				@skip_trace_export_id,
				@address1_line_1,
				@address1_line_2,
				@address1_city,
				@address1_state_code,
				@address1_zip_code,
				@address2_line_1,
				@address2_line_2,
				@address2_city,
				@address2_state_code,
				@address2_zip_code,
				@address3_line_1,
				@address3_line_2,
				@address3_city,
				@address3_state_code,
				@address3_zip_code,
				@address4_line_1,
				@address4_line_2,
				@address4_city,
				@address4_state_code,
				@address4_zip_code,
				@address5_line_1,
				@address5_line_2,
				@address5_city,
				@address5_state_code,
				@address5_zip_code,
				@address6_line_1,
				@address6_line_2,
				@address6_city,
				@address6_state_code,
				@address6_zip_code,
				@address7_line_1,
				@address7_line_2,
				@address7_city,
				@address7_state_code,
				@address7_zip_code,
				@address8_line_1,
				@address8_line_2,
				@address8_city,
				@address8_state_code,
				@address8_zip_code,
				@address9_line_1,
				@address9_line_2,
				@address9_city,
				@address9_state_code,
				@address9_zip_code,
				@address10_line_1,
				@address10_line_2,
				@address10_city,
				@address10_state_code,
				@address10_zip_code,
				@phone1_area_code,
				@phone1_phone_number,
				@phone2_area_code,
				@phone2_phone_number,
				@phone3_area_code,
				@phone3_phone_number,
				@phone4_area_code,
				@phone4_phone_number,
				@phone5_area_code,
				@phone5_phone_number,
				@phone6_area_code,
				@phone6_phone_number,
				@phone7_area_code,
				@phone7_phone_number,
				@phone8_area_code,
				@phone8_phone_number,
				@phone9_area_code,
				@phone9_phone_number,
				@phone10_area_code,
				@phone10_phone_number,
				@email1,
				@email2,
				@email3,
				@email4,
				@email5,
				@email6,
				@email7,
				@email8,
				@email9,
				@email10

			--cstd_skip_trace_import_staging loop
			SET @row_number = 0
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--convert skip date string to datetime
				--IF (ISNULL(@skip_sent_date, '') = '')
				--	SET @skip_sent_date_date = NULL
				--ELSE
				--BEGIN
				--	DECLARE @tempdate nvarchar(20)
				--	SET @tempdate = ''
				--	IF ISNUMERIC(SUBSTRING(@skip_sent_date,1,4)) = 1
				--		SET @tempdate = @tempdate + SUBSTRING(@skip_sent_date,1,4)
				--	ELSE
				--		SET @tempdate = @tempdate + '0000'

				--	IF ISNUMERIC(SUBSTRING(@skip_sent_date,5,2)) = 1
				--		SET @tempdate = @tempdate + '-' + SUBSTRING(@skip_sent_date,5,2)
				--	ELSE
				--		SET @tempdate = @tempdate + '-00'

				--	IF ISNUMERIC(SUBSTRING(@skip_sent_date,7,2)) = 1
				--		SET @tempdate = @tempdate + '-' + SUBSTRING(@skip_sent_date,7,2)
				--	ELSE
				--		SET @tempdate = @tempdate + '-00'

				--	IF ISNUMERIC(SUBSTRING(@skip_sent_date,9,2)) = 1
				--		SET @tempdate = @tempdate + ' ' + SUBSTRING(@skip_sent_date,9,2)
				--	ELSE
				--		SET @tempdate = @tempdate + ' 00'

				--	IF ISNUMERIC(SUBSTRING(@skip_sent_date,11,2)) = 1
				--		SET @tempdate = @tempdate + ':' + SUBSTRING(@skip_sent_date,11,2)
				--	ELSE
				--		SET @tempdate = @tempdate + ':00'

				--	IF ISDATE(@tempdate) = 1
				--		SET @skip_sent_date_date = CONVERT(datetime,@tempdate)
				--	ELSE
				--		SET @skip_sent_date_date = NULL
				--END

				SET @row_number = @row_number + 1

				DECLARE @fieldcounter int
				SET @fieldcounter = 10

				DECLARE @address_exists_in_row nchar(1)
				DECLARE @phone_exists_in_row nchar(1)
				DECLARE @email_exists_in_row nchar(1)
				SET @address_exists_in_row = 'N'
				SET @phone_exists_in_row = 'N'
				SET @email_exists_in_row = 'N'

				--Loop through all 10 fields for each type
				--Go backward to get the sort orders right
				WHILE @fieldcounter >= 1
				BEGIN
					DECLARE @row_processing_status_code nchar(10)
					SET @row_processing_status_code = 'IMPORTED'

					--begin address
					SET @updated_address_line_1 = CASE
													WHEN @fieldcounter = 1 THEN @address1_line_1
													WHEN @fieldcounter = 2 THEN @address2_line_1
													WHEN @fieldcounter = 3 THEN @address3_line_1
													WHEN @fieldcounter = 4 THEN @address4_line_1
													WHEN @fieldcounter = 5 THEN @address5_line_1
													WHEN @fieldcounter = 6 THEN @address6_line_1
													WHEN @fieldcounter = 7 THEN @address7_line_1
													WHEN @fieldcounter = 8 THEN @address8_line_1
													WHEN @fieldcounter = 9 THEN @address9_line_1
													WHEN @fieldcounter = 10 THEN @address10_line_1
													END
					SET @updated_address_line_2 = CASE
													WHEN @fieldcounter = 1 THEN @address1_line_2
													WHEN @fieldcounter = 2 THEN @address2_line_2
													WHEN @fieldcounter = 3 THEN @address3_line_2
													WHEN @fieldcounter = 4 THEN @address4_line_2
													WHEN @fieldcounter = 5 THEN @address5_line_2
													WHEN @fieldcounter = 6 THEN @address6_line_2
													WHEN @fieldcounter = 7 THEN @address7_line_2
													WHEN @fieldcounter = 8 THEN @address8_line_2
													WHEN @fieldcounter = 9 THEN @address9_line_2
													WHEN @fieldcounter = 10 THEN @address10_line_2
													END
					SET @updated_city			= CASE
													WHEN @fieldcounter = 1 THEN @address1_city
													WHEN @fieldcounter = 2 THEN @address2_city
													WHEN @fieldcounter = 3 THEN @address3_city
													WHEN @fieldcounter = 4 THEN @address4_city
													WHEN @fieldcounter = 5 THEN @address5_city
													WHEN @fieldcounter = 6 THEN @address6_city
													WHEN @fieldcounter = 7 THEN @address7_city
													WHEN @fieldcounter = 8 THEN @address8_city
													WHEN @fieldcounter = 9 THEN @address9_city
													WHEN @fieldcounter = 10 THEN @address10_city
													END
					SET @updated_state_code		= CASE
													WHEN @fieldcounter = 1 THEN @address1_state_code
													WHEN @fieldcounter = 2 THEN @address2_state_code
													WHEN @fieldcounter = 3 THEN @address3_state_code
													WHEN @fieldcounter = 4 THEN @address4_state_code
													WHEN @fieldcounter = 5 THEN @address5_state_code
													WHEN @fieldcounter = 6 THEN @address6_state_code
													WHEN @fieldcounter = 7 THEN @address7_state_code
													WHEN @fieldcounter = 8 THEN @address8_state_code
													WHEN @fieldcounter = 9 THEN @address9_state_code
													WHEN @fieldcounter = 10 THEN @address10_state_code
													END
					SET @updated_zip_code		= CASE
													WHEN @fieldcounter = 1 THEN @address1_zip_code
													WHEN @fieldcounter = 2 THEN @address2_zip_code
													WHEN @fieldcounter = 3 THEN @address3_zip_code
													WHEN @fieldcounter = 4 THEN @address4_zip_code
													WHEN @fieldcounter = 5 THEN @address5_zip_code
													WHEN @fieldcounter = 6 THEN @address6_zip_code
													WHEN @fieldcounter = 7 THEN @address7_zip_code
													WHEN @fieldcounter = 8 THEN @address8_zip_code
													WHEN @fieldcounter = 9 THEN @address9_zip_code
													WHEN @fieldcounter = 10 THEN @address10_zip_code
													END

					IF (ISNULL(@updated_address_line_1,'') <>'' OR ISNULL(@updated_city,'') <> '' OR ISNULL(@updated_state_code,'') <> '' OR ISNULL(@updated_zip_code,'') <> '')
					BEGIN
						SET @address_exists_in_row = 'Y'

						--Establish intial cstd_skip_trace_import_detail row
						SET @import_detail_id = NEWID()

						INSERT INTO cstd_skip_trace_import_detail (
							skip_trace_import_detail_id,
							skip_trace_import_id,
							[row_number],
							import_target_table_id_value,
							contact_id,
							skip_trace_vendor_code,
							skip_trace_import_row_processing_status_code,
							updated_address_line_1,
							updated_address_line_2,
							updated_city,
							updated_state_code,
							updated_zip_code,
							data_block_number,
							skip_trace_export_id,
							skip_trace_import_target_code,
							creation_date
							)
						VALUES (
							@import_detail_id,
							@import_id,
							@row_number,
							@import_target_table_id,
							@contact_id,
							@vendor_code,
							@row_processing_status_code,
							@updated_address_line_1,
							@updated_address_line_2,
							@updated_city,
							@updated_state_code,
							@updated_zip_code,
							@fieldcounter,
							@skip_trace_export_id,
							'ADDRESS',
							GETDATE()
							)

						IF ISNULL(@contact_id,'') = ''
							SET @row_processing_status_code = 'IDNOTFOUND'
						ELSE IF (SELECT COUNT(*) FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id) = 0
							SET @row_processing_status_code = 'IDNOTFOUND'


						--update the row with the new data if there are no errors
						IF @row_processing_status_code = 'IMPORTED'
						BEGIN
							DECLARE @validationReturn nchar(10)
							EXEC psoSkipTraceExternalImportValidateAndUpdateAddress @import_detail_id, @validationReturn OUTPUT

							IF @validationReturn <> 'IMPORTED'
								UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @validationReturn WHERE skip_trace_import_detail_id = @import_detail_id
						END
						ELSE
							UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @row_processing_status_code WHERE skip_trace_import_detail_id = @import_detail_id
					END
					--end address

					--start phone
					SET @updated_area_code = CASE
													WHEN @fieldcounter = 1 THEN @phone1_area_code
													WHEN @fieldcounter = 2 THEN @phone2_area_code
													WHEN @fieldcounter = 3 THEN @phone3_area_code
													WHEN @fieldcounter = 4 THEN @phone4_area_code
													WHEN @fieldcounter = 5 THEN @phone5_area_code
													WHEN @fieldcounter = 6 THEN @phone6_area_code
													WHEN @fieldcounter = 7 THEN @phone7_area_code
													WHEN @fieldcounter = 8 THEN @phone8_area_code
													WHEN @fieldcounter = 9 THEN @phone9_area_code
													WHEN @fieldcounter = 10 THEN @phone10_area_code
													END
					SET @updated_phone_number = CASE
													WHEN @fieldcounter = 1 THEN @phone1_phone_number
													WHEN @fieldcounter = 2 THEN @phone2_phone_number
													WHEN @fieldcounter = 3 THEN @phone3_phone_number
													WHEN @fieldcounter = 4 THEN @phone4_phone_number
													WHEN @fieldcounter = 5 THEN @phone5_phone_number
													WHEN @fieldcounter = 6 THEN @phone6_phone_number
													WHEN @fieldcounter = 7 THEN @phone7_phone_number
													WHEN @fieldcounter = 8 THEN @phone8_phone_number
													WHEN @fieldcounter = 9 THEN @phone9_phone_number
													WHEN @fieldcounter = 10 THEN @phone10_phone_number
													END

					IF ISNULL(@updated_area_code,'') = '' AND LEN(ISNULL(@updated_phone_number,'')) = 10
					BEGIN
						SET @updated_area_code = SUBSTRING(@updated_phone_number,1,3)
						SET @updated_phone_number = SUBSTRING(@updated_phone_number, 4,7)
					END


					IF ISNULL(@updated_phone_number,'') <>''
					BEGIN
						SET @phone_exists_in_row = 'Y'

						--Establish intial cstd_skip_trace_import_detail row
						SET @import_detail_id = NEWID()

						INSERT INTO cstd_skip_trace_import_detail (
							skip_trace_import_detail_id,
							skip_trace_import_id,
							[row_number],
							import_target_table_id_value,
							contact_id,
							skip_trace_vendor_code,
							skip_trace_import_row_processing_status_code,
							updated_area_code,
							updated_phone_number,
							data_block_number,
							skip_trace_export_id,
							skip_trace_import_target_code,
							creation_date
							)
						VALUES (
							@import_detail_id,
							@import_id,
							@row_number,
							@import_target_table_id,
							@contact_id,
							@vendor_code,
							@row_processing_status_code,
							@updated_area_code,
							@updated_phone_number,
							@fieldcounter,
							@skip_trace_export_id,
							'PHONE',
							GETDATE()
							)

						IF ISNULL(@contact_id,'') = ''
							SET @row_processing_status_code = 'IDNOTFOUND'
						ELSE IF (SELECT COUNT(*) FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id) = 0
							SET @row_processing_status_code = 'IDNOTFOUND'


						--update the row with the new data if there are no errors
						IF @row_processing_status_code = 'IMPORTED'
						BEGIN
							EXEC psoSkipTraceExternalImportValidateAndUpdatePhone @import_detail_id, @validationReturn OUTPUT

							IF @validationReturn <> 'IMPORTED'
								UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @validationReturn WHERE skip_trace_import_detail_id = @import_detail_id
						END
						ELSE
							UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @row_processing_status_code WHERE skip_trace_import_detail_id = @import_detail_id
					END
					--end phone


					--start email
					SET @updated_email = CASE
													WHEN @fieldcounter = 1 THEN @email1
													WHEN @fieldcounter = 2 THEN @email2
													WHEN @fieldcounter = 3 THEN @email3
													WHEN @fieldcounter = 4 THEN @email4
													WHEN @fieldcounter = 5 THEN @email5
													WHEN @fieldcounter = 6 THEN @email6
													WHEN @fieldcounter = 7 THEN @email7
													WHEN @fieldcounter = 8 THEN @email8
													WHEN @fieldcounter = 9 THEN @email9
													WHEN @fieldcounter = 10 THEN @email10
													END


					IF ISNULL(@updated_email,'') <>''
					BEGIN
						SET @email_exists_in_row = 'Y'

						--Establish intial cstd_skip_trace_import_detail row
						SET @import_detail_id = NEWID()

						INSERT INTO cstd_skip_trace_import_detail (
							skip_trace_import_detail_id,
							skip_trace_import_id,
							[row_number],
							import_target_table_id_value,
							contact_id,
							skip_trace_vendor_code,
							skip_trace_import_row_processing_status_code,
							updated_email,
							data_block_number,
							skip_trace_export_id,
							skip_trace_import_target_code,
							creation_date
							)
						VALUES (
							@import_detail_id,
							@import_id,
							@row_number,
							@import_target_table_id,
							@contact_id,
							@vendor_code,
							@row_processing_status_code,
							@updated_email,
							@fieldcounter,
							@skip_trace_export_id,
							'EMAIL',
							GETDATE()
							)

						IF ISNULL(@contact_id,'') = ''
							SET @row_processing_status_code = 'IDNOTFOUND'
						ELSE IF (SELECT COUNT(*) FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id) = 0
							SET @row_processing_status_code = 'IDNOTFOUND'


						--update the row with the new data if there are no errors
						IF @row_processing_status_code = 'IMPORTED'
						BEGIN
							EXEC psoSkipTraceExternalImportValidateAndUpdateEmail @import_detail_id, @validationReturn OUTPUT

							IF @validationReturn <> 'IMPORTED'
								UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @validationReturn WHERE skip_trace_import_detail_id = @import_detail_id
						END
						ELSE
							UPDATE cstd_skip_trace_import_detail SET skip_trace_import_row_processing_status_code = @row_processing_status_code WHERE skip_trace_import_detail_id = @import_detail_id
					END
					--end email

					SET @fieldcounter = @fieldcounter - 1
				END

				IF NOT EXISTS (SELECT 1 FROM oncd_contact_address WITH (NOLOCK) WHERE primary_flag = 'Y' AND contact_id = @contact_id)
					UPDATE oncd_contact_address SET primary_flag = 'Y' WHERE contact_address_id = (SELECT TOP 1 contact_address_id FROM oncd_contact_address WITH (NOLOCK) WHERE contact_id = @contact_id AND cst_valid_flag = 'Y' AND cst_active = 'Y' ORDER BY sort_order)
				IF NOT EXISTS (SELECT 1 FROM oncd_contact_phone WITH (NOLOCK) WHERE primary_flag = 'Y' AND contact_id = @contact_id)
					UPDATE oncd_contact_phone SET primary_flag = 'Y' WHERE contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = @contact_id AND cst_valid_flag = 'Y' AND active = 'Y' ORDER BY sort_order)
				IF NOT EXISTS (SELECT 1 FROM oncd_contact_email WITH (NOLOCK) WHERE primary_flag = 'Y' AND contact_id = @contact_id)
					UPDATE oncd_contact_email SET primary_flag = 'Y' WHERE contact_email_id = (SELECT TOP 1 contact_email_id FROM oncd_contact_email WITH (NOLOCK) WHERE contact_id = @contact_id AND cst_valid_flag = 'Y' AND active = 'Y' ORDER BY sort_order)

				--Update next vendor info for current contact
				DECLARE @process_address_flag nchar(1)
				DECLARE @process_phone_flag nchar(1)
				DECLARE @process_email_flag nchar(1)

				SELECT
					@process_address_flag = process_address_flag,
					@process_phone_flag = process_phone_flag,
					@process_email_flag = process_email_flag
				FROM cstd_skip_trace_export_detail
				WHERE entity_id = @contact_id AND entity_table_name = 'oncd_contact' AND skip_trace_export_id = @skip_trace_export_id

				EXEC psoSkipTraceImportSetSkipTraceEventsForContact @contact_id, @process_address_flag, @process_phone_flag, @process_email_flag, @vendor_code


				--if a process flag is set but no data was returned for that Type
				--insert a 'dummy' import detail row saying so
				IF @process_address_flag = 'Y' AND @address_exists_in_row = 'N'
				BEGIN
					SET @import_detail_id = NEWID()

					INSERT INTO cstd_skip_trace_import_detail (
						skip_trace_import_detail_id,
						skip_trace_import_id,
						[row_number],
						import_target_table_id_value,
						contact_id,
						skip_trace_vendor_code,
						skip_trace_import_row_processing_status_code,
						status_message,
						creation_date
						)
					VALUES (
						@import_detail_id,
						@import_id,
						@row_number,
						@import_target_table_id,
						@contact_id,
						@vendor_code,
						'VALUEMISSG',
						'Address was sent for processing but no values returned from Vendor',
						GETDATE()
						)
				END
				IF @process_phone_flag = 'Y' AND @phone_exists_in_row = 'N'
				BEGIN
					SET @import_detail_id = NEWID()

					INSERT INTO cstd_skip_trace_import_detail (
						skip_trace_import_detail_id,
						skip_trace_import_id,
						[row_number],
						import_target_table_id_value,
						contact_id,
						skip_trace_vendor_code,
						skip_trace_import_row_processing_status_code,
						status_message,
						creation_date
						)
					VALUES (
						@import_detail_id,
						@import_id,
						@row_number,
						@import_target_table_id,
						@contact_id,
						@vendor_code,
						'VALUEMISSG',
						'Phone was sent for processing but no values returned from Vendor',
						GETDATE()
						)
				END
				IF @process_email_flag = 'Y' AND @email_exists_in_row = 'N'
				BEGIN
					SET @import_detail_id = NEWID()

					INSERT INTO cstd_skip_trace_import_detail (
						skip_trace_import_detail_id,
						skip_trace_import_id,
						[row_number],
						import_target_table_id_value,
						contact_id,
						skip_trace_vendor_code,
						skip_trace_import_row_processing_status_code,
						status_message,
						creation_date
						)
					VALUES (
						@import_detail_id,
						@import_id,
						@row_number,
						@import_target_table_id,
						@contact_id,
						@vendor_code,
						'VALUEMISSG',
						'Email was sent for processing but no values returned from Vendor',
						GETDATE()
						)
				END

				--if phone was processed create OUTBOUND activity if none present
				IF @process_phone_flag = 'Y'
					AND EXISTS (SELECT 1 FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = @contact_id AND cst_valid_flag = 'Y')
					AND (SELECT contact_status_code FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id) = 'LEAD'
					AND (SELECT ISNULL(cst_do_not_call,'N') FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id) = 'N'
				BEGIN
					IF NOT EXISTS (SELECT 1 FROM oncd_activity a WITH (NOLOCK) INNER JOIN oncd_activity_contact ca WITH (NOLOCK) ON ca.activity_id = a.activity_id AND ca.contact_id = @contact_id AND result_code IS NULL INNER JOIN onca_action ac ON ac.action_code = a.action_code AND ac.cst_category_code = 'OUTBOUND')
					BEGIN
						--No currently open outbound call.  Copy from a previous if exists
						DECLARE @pk nchar(10)
						DECLARE @pk_activity_id nchar(10)
						DECLARE @o_activity_id nchar(10)
						DECLARE @o_action_code nchar(10)
						DECLARE @o_description nchar(50)
						DECLARE @o_source_code nchar(20)
						DECLARE @o_cst_activity_type_code nchar(10)
						DECLARE @o_cst_time_zone_code nchar(10)

						SELECT TOP 1 @o_activity_id = a.activity_id,
							@o_action_code = a.action_code,
							@o_description = a.description,
							@o_source_code = a.source_code,
							@o_cst_activity_type_code = a.cst_activity_type_code,
							@o_cst_time_zone_code = a.cst_time_zone_code
							FROM oncd_activity a WITH (NOLOCK)
							INNER JOIN oncd_activity_contact ca WITH (NOLOCK) ON ca.activity_id = a.activity_id AND ca.contact_id = @contact_id AND a.result_code IS NOT NULL
							INNER JOIN onca_action ac ON ac.action_code = a.action_code AND ac.cst_category_code = 'OUTBOUND' ORDER BY a.completion_date DESC

						IF @o_activity_id IS NOT NULL
						BEGIN
							--create_primary_key is time-dependent; don't to more than one in same millisecond
							--WAITFOR DELAY '00:00:00.005'
							EXEC pso_onc_create_primary_key 10,'oncd_activity','activity_id', @pk_activity_id OUTPUT, NULL

							INSERT INTO oncd_activity (activity_id, action_code, [description], due_date, start_time, creation_date, created_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code)
								VALUES	(@pk_activity_id, @o_action_code, @o_description, CONVERT(datetime, CONVERT(nchar(10), GETDATE(),121)), '1/1/1900 00:00:00', GETDATE(), 'SKIP', GETDATE(), 'SKIP', @o_source_code, @o_cst_activity_type_code, @o_cst_time_zone_code)

							--oncd_activity_contact
							EXEC pso_onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @pk OUTPUT, NULL

							INSERT INTO oncd_activity_contact (activity_contact_id, activity_id, contact_id, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, assignment_date, attendance, sort_order)
								VALUES (@pk, @pk_activity_id, @contact_id, GETDATE(), 'SKIP', GETDATE(), 'SKIP', 'Y', GETDATE(), 'Y', 1)

							--oncd_activity_user
							DECLARE @u_user_code nchar(20)
							DECLARE @u_attendance nchar(1)
							DECLARE @u_sort_order int
							DECLARE @u_primary_flag nchar(1)

							DECLARE activityusers CURSOR FAST_FORWARD FOR
								SELECT user_code, attendance, sort_order, primary_flag FROM oncd_activity_user WHERE activity_id = @o_activity_id

							OPEN activityusers
							FETCH activityusers INTO @u_user_code, @u_attendance, @u_sort_order, @u_primary_flag
							WHILE @@FETCH_STATUS = 0
							BEGIN
								--WAITFOR DELAY '00:00:00.005'
								EXEC pso_onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @pk OUTPUT, NULL

								INSERT INTO oncd_activity_user (activity_user_id, activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
									VALUES (@pk, @pk_activity_id, @u_user_code, GETDATE(), @u_attendance, @u_sort_order, GETDATE(), 'SKIP', GETDATE(), 'SKIP', @u_primary_flag)

								FETCH activityusers INTO @u_user_code, @u_attendance, @u_sort_order, @u_primary_flag
							END

							CLOSE activityusers
							DEALLOCATE activityusers

							--oncd_activity_company
							--Set contacts primary Center
							DECLARE @c_company_id nchar(10)
							SET @c_company_id = (SELECT company_id FROM oncd_contact_company WHERE contact_id = @contact_id AND primary_flag = 'Y')

							IF @c_company_id IS NOT NULL
							BEGIN
								EXEC pso_onc_create_primary_key 10, 'oncd_activity_company','activity_company_id', @pk OUTPUT
								INSERT INTO oncd_activity_company (activity_company_id, activity_id, company_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
									VALUES (@pk, @pk_activity_id, @c_company_id, GETDATE(), 'N', 1, GETDATE(), 'SKIP', GETDATE(), 'SKIP', 'Y')
							END

						END
					END
				END --create OUTBOUND activity


				FETCH importstaging INTO
					@vendor_code,
					@contact_id,
					@skip_trace_export_id,
					@address1_line_1,
					@address1_line_2,
					@address1_city,
					@address1_state_code,
					@address1_zip_code,
					@address2_line_1,
					@address2_line_2,
					@address2_city,
					@address2_state_code,
					@address2_zip_code,
					@address3_line_1,
					@address3_line_2,
					@address3_city,
					@address3_state_code,
					@address3_zip_code,
					@address4_line_1,
					@address4_line_2,
					@address4_city,
					@address4_state_code,
					@address4_zip_code,
					@address5_line_1,
					@address5_line_2,
					@address5_city,
					@address5_state_code,
					@address5_zip_code,
					@address6_line_1,
					@address6_line_2,
					@address6_city,
					@address6_state_code,
					@address6_zip_code,
					@address7_line_1,
					@address7_line_2,
					@address7_city,
					@address7_state_code,
					@address7_zip_code,
					@address8_line_1,
					@address8_line_2,
					@address8_city,
					@address8_state_code,
					@address8_zip_code,
					@address9_line_1,
					@address9_line_2,
					@address9_city,
					@address9_state_code,
					@address9_zip_code,
					@address10_line_1,
					@address10_line_2,
					@address10_city,
					@address10_state_code,
					@address10_zip_code,
					@phone1_area_code,
					@phone1_phone_number,
					@phone2_area_code,
					@phone2_phone_number,
					@phone3_area_code,
					@phone3_phone_number,
					@phone4_area_code,
					@phone4_phone_number,
					@phone5_area_code,
					@phone5_phone_number,
					@phone6_area_code,
					@phone6_phone_number,
					@phone7_area_code,
					@phone7_phone_number,
					@phone8_area_code,
					@phone8_phone_number,
					@phone9_area_code,
					@phone9_phone_number,
					@phone10_area_code,
					@phone10_phone_number,
					@email1,
					@email2,
					@email3,
					@email4,
					@email5,
					@email6,
					@email7,
					@email8,
					@email9,
					@email10
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




/****** Object:  StoredProcedure [dbo].[psoSkipTraceExternalImportValidateAndUpdateAddress]    Script Date: 1/20/2016 4:47:49 PM ******/
SET ANSI_NULLS ON
GO
