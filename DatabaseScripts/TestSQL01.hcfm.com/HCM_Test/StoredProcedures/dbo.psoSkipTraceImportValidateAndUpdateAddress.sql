/* CreateDate: 11/02/2015 10:07:13.983 , ModifyDate: 11/11/2015 11:36:22.153 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-06-02
-- Description:	Validate and Update importing Address data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceImportValidateAndUpdateAddress]
	-- Add the parameters for the stored procedure here
	@import_detail_id	uniqueidentifier,
	@validationCode    nchar(10) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @import_detail_id IS NULL
		RETURN -1

	DECLARE @import_type_code			nchar(10)
	DECLARE @import_vendor_code			nchar(20)
	DECLARE @row_vendor_code			nchar(20)
	DECLARE @contact_id					nchar(10)
	DECLARE @data_type					nvarchar(20)
	DECLARE @contact_address_id			nchar(10)
	DECLARE @updated_address_type_code	nchar(10)
	DECLARE @updated_address_line_1		nvarchar(60)
	DECLARE @updated_address_line_2		nvarchar(60)
	DECLARE @updated_address_line_3		nvarchar(60)
	DECLARE @updated_city				nvarchar(60)
	DECLARE @updated_state_code			nvarchar(20)
	DECLARE @updated_zip_code			nvarchar(15)
	DECLARE @updated_country_code		nvarchar(20)
	DECLARE @updated_county_code		nvarchar(10)
	DECLARE @updated_time_zone_code		nvarchar(10)
	DECLARE @original_address_type_code	nchar(10)
	DECLARE @original_address_line_1	nvarchar(60)
	DECLARE @original_address_line_2	nvarchar(60)
	DECLARE @original_address_line_3	nvarchar(60)
	DECLARE @original_city				nvarchar(60)
	DECLARE @original_state_code		nvarchar(20)
	DECLARE @original_zip_code			nvarchar(15)
	DECLARE @original_country_code		nvarchar(20)
	DECLARE @marketing_score			decimal(15,4)

	DECLARE @current_contact_id			nchar(10)
	DECLARE @current_contact_address_id	nchar(10)
	DECLARE @current_address_type_code	nchar(10)
	DECLARE @current_address_line_1		nvarchar(60)
	DECLARE @current_address_line_2		nvarchar(60)
	DECLARE @current_address_line_3		nvarchar(60)
	DECLARE @current_city				nvarchar(60)
	DECLARE @current_state_code			nvarchar(20)
	DECLARE @current_zip_code			nvarchar(15)
	DECLARE @current_country_code		nvarchar(20)
	DECLARE @current_cst_valid_flag		nchar(1)
	DECLARE @current_primary_flag		nchar(1)

	DECLARE @status_message				nvarchar(4000)
	DECLARE @inactivating				bit

	SET @inactivating = 0

	SET @validationCode = 'IMPORTED' --Default value indicating successful import/update

	SELECT TOP 1
		@import_type_code			= skip_trace_import_type_code,
		@import_vendor_code			= i.skip_trace_vendor_code,
		@import_detail_id			= skip_trace_import_detail_id,
		@contact_id					= contact_id,
		@data_type					= data_type,
		@contact_address_id			= import_target_table_id_value,
		@updated_address_type_code	= updated_address_type_code,
		@updated_address_line_1		= updated_address_line_1,
		@updated_address_line_2		= updated_address_line_2,
		@updated_address_line_3		= updated_address_line_3,
		@updated_city				= updated_city,
		@updated_state_code			= updated_state_code,
		@updated_zip_code			= updated_zip_code,
		@updated_country_code		= CASE WHEN RTRIM(ISNULL(updated_country_code,'')) = '' THEN z.country_code ELSE updated_country_code END,
		@updated_time_zone_code		= c.time_zone_code,
		@updated_county_code		= c.county_code,
		@original_address_type_code = original_address_type_code,
		@original_address_line_1	= original_address_line_1,
		@original_address_line_2	= original_address_line_2,
		@original_address_line_3	= original_address_line_3,
		@original_city				= original_city,
		@original_state_code		= original_state_code,
		@original_zip_code			= original_zip_code,
		@original_country_code		= original_country_code,
		@row_vendor_code			= cstd_skip_trace_import_detail.skip_trace_vendor_code,
		@marketing_score			= marketing_score
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	LEFT OUTER JOIN onca_zip z ON z.zip_code = SUBSTRING(ISNULL(updated_zip_code,''),1,5)
	LEFT OUTER JOIN onca_county c ON c.county_code = z.county_code
	WHERE skip_trace_import_detail_id = @import_detail_id

	IF RTRIM(@updated_country_code) = ''
		SET @updated_country_code = NULL
	IF RTRIM(@original_country_code) = ''
		SET @original_country_code = NULL


	SET @current_contact_id			= NULL
	SET @current_contact_address_id = NULL
	SET @current_address_type_code  = NULL
	SET @current_address_line_1		= NULL
	SET @current_address_line_2		= NULL
	SET @current_address_line_3		= NULL
	SET @current_city				= NULL
	SET @current_state_code			= NULL
	SET @current_zip_code			= NULL
	SET @current_country_code		= NULL
	SET @current_cst_valid_flag		= NULL
	SET @current_primary_flag		= NULL

	IF (ISNULL(@contact_address_id,'') <> '')
	BEGIN
		SELECT
			@current_contact_id			= contact_id,
			@current_contact_address_id = contact_address_id,
			@current_address_type_code  = address_type_code,
			@current_address_line_1		= address_line_1,
			@current_address_line_2		= address_line_2,
			@current_address_line_3		= address_line_3,
			@current_city				= city,
			@current_state_code			= state_code,
			@current_zip_code			= zip_code,
			@current_country_code		= country_code,
			@current_cst_valid_flag		= cst_valid_flag,
			@current_primary_flag		= primary_flag
		FROM oncd_contact_address WHERE contact_address_id = @contact_address_id
			AND cst_valid_flag = 'Y' --if provided address id is invalid, use primary instead
	END

	IF @current_contact_address_id IS NULL
		SELECT TOP 1
			@current_contact_id			= contact_id,
			@current_contact_address_id = contact_address_id,
			@current_address_type_code  = address_type_code,
			@current_address_line_1		= address_line_1,
			@current_address_line_2		= address_line_2,
			@current_address_line_3		= address_line_3,
			@current_city				= city,
			@current_state_code			= state_code,
			@current_zip_code			= zip_code,
			@current_country_code		= country_code,
			@current_cst_valid_flag		= cst_valid_flag,
			@current_primary_flag		= primary_flag
		FROM oncd_contact_address WHERE contact_id = @contact_id
			AND cst_valid_flag = 'Y' AND cst_active = 'Y'
		ORDER BY primary_flag DESC, sort_order

	--Override with Import level vendor if supplied
	IF @import_vendor_code <> 'ROWVALUE'
		SET @row_vendor_code = @import_vendor_code
	IF RTRIM(ISNULL(@row_vendor_code,'')) = ''
		SET @validationCode = 'VALUEMISSG'

	--Check if contact_address_id goes with provided contact; if not there has been some manipulation: reject
	IF (SELECT contact_id FROM oncd_contact_address WHERE contact_address_id = @contact_address_id) <> @contact_id
	BEGIN
		SET @validationCode = 'IDNOTFOUND'
		UPDATE cstd_skip_trace_import_detail SET status_message = 'Contact for Address does not match Contact in Import row' WHERE skip_trace_import_detail_id = @import_detail_id

		RETURN 0
	END

	--if data_type = 'BADD/NOT CASSed' invalidate address
	IF @data_type = 'BADD' OR @data_type = 'NOT CASSed'
	BEGIN
		IF NOT (ISNULL(@contact_address_id,'') = '')
		BEGIN
			IF @current_contact_id = @contact_id OR @current_contact_address_id IS NULL
			BEGIN
				IF (SELECT ISNULL(cst_valid_flag,'Y') FROM oncd_contact_address WHERE contact_address_id = @contact_address_id) = 'Y'
				BEGIN
					UPDATE oncd_contact_address SET
						primary_flag = 'N',
						cst_active = 'N',
						cst_valid_flag = 'N',
						updated_date = GETDATE(),
						updated_by_user_code = 'SKIP',
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_address_id = @contact_address_id

					--Set a new primary if possible
					IF @current_primary_flag = 'Y'
						UPDATE oncd_contact_address
							SET primary_flag = 'Y',
								updated_date			= GETDATE(),
								updated_by_user_code	= 'SKIP',
								cst_skip_trace_vendor_code = @row_vendor_code
							WHERE contact_address_id =
								(SELECT TOP 1 contact_address_id FROM oncd_contact_address WHERE contact_id = @contact_id AND cst_active = 'Y' AND cst_valid_flag = 'Y' ORDER BY sort_order)

					UPDATE cstd_skip_trace_import_detail SET status_message = 'Address row invalidated due to BADD/NOT CASSed Data Type value' WHERE skip_trace_import_detail_id = @import_detail_id

					RETURN 0
				END
				ELSE
					SET @validationCode = 'NOCHANGE'
					RETURN 0
			END
		END
	END

	--if data_type = 'DUPE' Skip record
	IF @data_type = 'DUPE' OR @data_type = 'GOOD'
	BEGIN
			SET @validationCode = 'DUPEDATA'

			IF @data_type = 'GOOD'
			BEGIN
				EXEC psoSetContactMarketingScore @contact_id, @marketing_score,'ADDRESS','SKIP'
			END

			RETURN 0
	END


	--if fields are empty and INTERNAL import, then set inactive
	IF
		RTRIM(ISNULL(@updated_address_line_1,'')) = '' AND
		RTRIM(ISNULL(@updated_city,'')) = '' AND
		RTRIM(ISNULL(@updated_state_code,'')) = '' AND
		RTRIM(ISNULL(@updated_zip_code,'')) = '' AND
		@import_type_code = 'INTERNAL'
	BEGIN
		SET @inactivating = 1
	END
	ELSE IF --certain fields are required
		RTRIM(ISNULL(@updated_address_line_1,'')) = '' OR
		RTRIM(ISNULL(@updated_city,'')) = '' OR
		RTRIM(ISNULL(@updated_state_code,'')) = '' OR
		RTRIM(ISNULL(@updated_zip_code,'')) = ''
	BEGIN
		SET @validationCode = 'VALUEMISSG'
		RETURN 0
	END

	--Don't update if changed recently
	IF
		(@original_address_line_1	IS NOT NULL AND @original_address_line_1	<> @current_address_line_1) OR
		(@original_address_line_2	IS NOT NULL AND @original_address_line_2	<> @current_address_line_2) OR
		(@original_city				IS NOT NULL AND @original_city				<> @current_city)			OR
		(@original_state_code		IS NOT NULL AND @original_state_code		<> @current_state_code)		OR
		(@original_zip_code			IS NOT NULL AND @original_zip_code			<> @current_zip_code)
	BEGIN
		SET @validationCode = 'RECENTCHG'
		RETURN 0
	END

	--Don't update if no changes
	IF
		(ISNULL(@updated_address_line_1,'')	= ISNULL(@current_address_line_1,''))  AND
		(ISNULL(@updated_address_line_2,'')	= ISNULL(@current_address_line_2,''))  AND
		(ISNULL(@updated_city,'')			= ISNULL(@current_city,''))			AND
		(ISNULL(@updated_state_code,'')		= ISNULL(@current_state_code,''))		AND
		(ISNULL(@updated_zip_code,'')		= ISNULL(@current_zip_code,''))
		--AND (ISNULL(@updated_country_code,'')	= ISNULL(@current_country_code,''))
	BEGIN
		SET @validationCode = 'NOCHANGE'
		RETURN 0
	END

	--Relatedly, check ALL addresses to see if this one already exists, even invalids
	IF EXISTS (SELECT 1 FROM oncd_contact_address WHERE
				contact_id = @contact_id AND
				address_line_1  = @updated_address_line_1 AND
				address_line_2  = @updated_address_line_2 AND
				city			= @updated_city AND
				state_code		= @updated_state_code AND
				zip_code		= @updated_zip_code
				)
	BEGIN
		SET @validationCode = 'NOCHANGE'
		RETURN 0
	END


	--Don't change data if valid flag is set
	--IF @current_contact_address_id IS NOT NULL AND @current_cst_valid_flag = 'Y'
	--BEGIN
	--	SET @validationCode = 'VALIDEXIST'
	--	RETURN 0
	--END

	--no errors; we're good to import
	IF @validationCode = 'IMPORTED'
	BEGIN
		IF RTRIM(ISNULL(@contact_address_id,'')) = '' OR RTRIM(ISNULL(@current_contact_address_id,'')) = ''  --adding new row
			OR @data_type = 'NCOA'
		BEGIN
			IF @import_type_code = 'INTERNAL' AND @data_type <> 'NCOA'
			BEGIN
				--Do not add new for INTERNAL import
				SET @validationCode = 'NOPKINTERN'
				RETURN 0
			END

			DECLARE @maxPrimary nchar(1)
			DECLARE @maxSort int

			SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
				FROM oncd_contact_address WHERE contact_id = @contact_id

			IF RTRIM(ISNULL(@contact_address_id,'')) = '' OR @data_type = 'NCOA'
			BEGIN
				--create_primary_key is time-dependent; don't to more than one in same millisecond
				WAITFOR DELAY '00:00:00.005'
				EXEC onc_create_primary_key 10,'oncd_contact_address','contact_address_id', @current_contact_address_id OUTPUT, NULL
			END
			ELSE
				SET @current_contact_address_id = @contact_address_id

			BEGIN TRY
				INSERT INTO oncd_contact_address (contact_address_id, contact_id, address_type_code, address_line_1, address_line_2, address_line_3, address_line_4, address_line_1_soundex, address_line_2_soundex, city, city_soundex, state_code, zip_code, county_code, country_code, time_zone_code, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, company_address_id, cst_valid_flag, cst_active, cst_skip_trace_vendor_code)
					VALUES (@current_contact_address_id, @contact_id, 'SKIP', @updated_address_line_1, @updated_address_line_2, @updated_address_line_3, NULL, dbo.pso_Soundex_Calculate(@updated_address_line_1, 'ADDRESS', 5), dbo.pso_Soundex_Calculate(@updated_address_line_2, 'ADDRESS', 5), @updated_city, dbo.pso_Soundex_Calculate(@updated_city, 'CITY', 5), @updated_state_code, @updated_zip_code, @updated_county_code, @updated_country_code, @updated_time_zone_code, @maxSort + 1, GETDATE(), 'SKIP', GETDATE(), 'SKIP', CASE WHEN @maxPrimary = 'Y' THEN 'N' ELSE 'Y' END, NULL, 'Y', 'Y', @row_vendor_code)

				IF @data_type = 'NCOA' --make new insert primary and invalidate all others
				BEGIN
					UPDATE oncd_contact_address SET
						primary_flag = 'N',
						updated_date = GETDATE(),
						updated_by_user_code = 'SKIP',
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_id = @contact_id
						AND contact_address_id <> @current_contact_address_id
						AND primary_flag = 'Y'

					UPDATE oncd_contact_address SET
						cst_active = 'N',
						updated_date = GETDATE(),
						updated_by_user_code = 'SKIP' ,
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_id = @contact_id
						AND contact_address_id <> @current_contact_address_id
						AND cst_active = 'Y'

					UPDATE oncd_contact_address SET
						cst_valid_flag = 'N',
						updated_date = GETDATE(),
						updated_by_user_code = 'SKIP' ,
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_id = @contact_id
						AND contact_address_id <> @current_contact_address_id
						AND cst_valid_flag = 'Y'

					UPDATE oncd_contact_address SET primary_flag = 'Y', cst_skip_trace_vendor_code = @row_vendor_code WHERE contact_address_id = @current_contact_address_id

				END
			END TRY
			BEGIN CATCH
				SET @validationCode = 'INVDATA'
				SET @status_message = ERROR_MESSAGE()
			END CATCH
		END
		ELSE --updating row
		BEGIN
			BEGIN TRY
			IF @inactivating = 1
				BEGIN
					UPDATE oncd_contact_address SET
						cst_active = 'N',
						primary_flag = 'N',
						updated_date			= GETDATE(),
						updated_by_user_code	= 'SKIP',
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_address_id = @current_contact_address_id

					SET @status_message = 'Inactivated'

					--Set a new primary if possible
					IF @current_primary_flag = 'Y'
						UPDATE oncd_contact_address
							SET primary_flag = 'Y',
								updated_date			= GETDATE(),
								updated_by_user_code	= 'SKIP',
								cst_skip_trace_vendor_code = @row_vendor_code
							WHERE contact_address_id =
								(SELECT TOP 1 contact_address_id FROM oncd_contact_address WHERE contact_id = @contact_id AND cst_active = 'Y' AND cst_valid_flag = 'Y' ORDER BY sort_order)
				END
			ELSE
			UPDATE oncd_contact_address SET
				address_type_code		= 'SKIP',
				address_line_1			= @updated_address_line_1,
				address_line_2			= @updated_address_line_2,
				address_line_3			= @updated_address_line_3,
				address_line_1_soundex	= dbo.pso_Soundex_Calculate(@updated_address_line_1, 'ADDRESS', 5),
				address_line_2_soundex  = dbo.pso_Soundex_Calculate(@updated_address_line_2, 'ADDRESS', 5),
				city					= @updated_city,
				city_soundex			= dbo.pso_Soundex_Calculate(@updated_city, 'CITY', 5),
				state_code				= @updated_state_code,
				zip_code				= @updated_zip_code,
				country_code			= @updated_country_code,
				time_zone_code			= @updated_time_zone_code,
				county_code				= @updated_county_code,
				updated_date			= GETDATE(),
				updated_by_user_code	= 'SKIP',
				cst_valid_flag			= 'Y',
				cst_skip_trace_vendor_code = @row_vendor_code
			WHERE contact_address_id = @current_contact_address_id
			END TRY
			BEGIN CATCH
				SET @validationCode = 'INVDATA'
				SET @status_message = ERROR_MESSAGE()
			END CATCH
		END
	END

	--Final updates to cstd_skip_trace_import_detail
	IF RTRIM(ISNULL(@status_message,'')) <> ''
		UPDATE cstd_skip_trace_import_detail SET status_message = @status_message WHERE skip_trace_import_detail_id = @import_detail_id

	IF RTRIM(ISNULL(@contact_address_id,'')) = '' AND RTRIM(ISNULL(@current_contact_address_id,'')) <> '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @current_contact_address_id WHERE skip_trace_import_detail_id = @import_detail_id

	RETURN 0
END
GO
