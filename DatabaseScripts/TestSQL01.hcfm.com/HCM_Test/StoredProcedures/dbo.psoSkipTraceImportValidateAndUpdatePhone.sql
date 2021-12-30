/* CreateDate: 11/02/2015 10:07:14.080 , ModifyDate: 11/02/2015 10:07:14.080 */
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-06-02
-- Description:	Validate and Update importing Phone data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceImportValidateAndUpdatePhone]
	-- Add the parameters for the stored procedure here
	@import_detail_id	uniqueidentifier,
	@validationCode    nchar(10) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @import_type_code			nchar(10)
	DECLARE @import_vendor_code			nchar(20)
	DECLARE @row_vendor_code			nchar(20)
	DECLARE @contact_id					nchar(10)
	DECLARE @contact_phone_id			nchar(10)
	DECLARE @updated_phone_type_code	nchar(10)
	DECLARE @updated_country_code_prefix nchar(10)
	DECLARE @updated_area_code			nchar(10)
	DECLARE @updated_phone_number		nvarchar(20)
	DECLARE @updated_extension			nchar(10)
	DECLARE @original_phone_type_code	nchar(10)
	DECLARE @originaL_country_code_prefix nchar(10)
	DECLARE @original_area_code			nchar(10)
	DECLARE @original_phone_number		nvarchar(20)
	DECLARE @original_extension			nchar(10)

	DECLARE @current_contact_phone_id	nchar(10)
	DECLARE @current_phone_type_code	nchar(10)
	DECLARE @current_country_code_prefix nchar(10)
	DECLARE @current_area_code			nchar(10)
	DECLARE @current_phone_number		nvarchar(20)
	DECLARE @current_extension			nchar(10)
	DECLARE @current_cst_valid_flag		nchar(1)
	DECLARE @current_primary_flag		nchar(1)

	DECLARE @status_message				nvarchar(4000)
	DECLARE @inactivating				bit

	SET @inactivating = 0

	SET @validationCode = 'IMPORTED'

	IF @import_detail_id IS NULL
		RETURN -1

	SELECT
		@import_type_code			= skip_trace_import_type_code,
		@import_vendor_code			= i.skip_trace_vendor_code,
		@row_vendor_code				= cstd_skip_trace_import_detail.skip_trace_vendor_code,
		@contact_id					= contact_id,
		@contact_phone_id			= import_target_table_id_value,
		@updated_phone_type_code	= updated_phone_type_code,
		@updated_country_code_prefix = updated_country_code_prefix,
		@updated_area_code			= updated_area_code,
		@updated_phone_number		= updated_phone_number,
		@updated_extension			= updated_extension,
		@original_phone_type_code	= original_phone_type_code,
		@original_country_code_prefix = original_country_code_prefix,
		@original_area_code			= original_area_code,
		@original_phone_number		= original_phone_number,
		@original_extension			= original_extension
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	WHERE skip_trace_import_detail_id = @import_detail_id

	SET @current_contact_phone_id	= NULL
	SET @current_phone_type_code	= NULL
	SET @current_country_code_prefix = NULL
	SET @current_area_code			= NULL
	SET @current_phone_number		= NULL
	SET @current_extension			= NULL
	SET @current_cst_valid_flag		= NULL
	SET @current_primary_flag		= NULL

	IF (ISNULL(@contact_phone_id,'') = '')
	BEGIN
		SELECT
			@current_contact_phone_id	= contact_phone_id,
			@current_phone_type_code	= phone_type_code,
			@current_country_code_prefix = country_code_prefix,
			@current_area_code			= area_code,
			@current_phone_number		= phone_number,
			@current_extension			= extension,
			@current_cst_valid_flag		= cst_valid_flag
		FROM oncd_contact_phone WHERE contact_id = @contact_id
			AND cst_valid_flag = 'Y' AND active = 'Y'
		ORDER BY primary_flag DESC, sort_order
	END
	ELSE
	BEGIN
		SELECT
			@current_contact_phone_id	= contact_phone_id,
			@current_phone_type_code	= phone_type_code,
			@current_country_code_prefix = country_code_prefix,
			@current_area_code			= area_code,
			@current_phone_number		= phone_number,
			@current_extension			= extension,
			@current_cst_valid_flag		= cst_valid_flag
		FROM oncd_contact_phone WHERE contact_phone_id = @contact_phone_id
	END

	--Override with Import level vendor if supplied
	IF @import_vendor_code <> 'ROWVALUE'
		SET @row_vendor_code = @import_vendor_code
	IF RTRIM(ISNULL(@row_vendor_code,'')) = ''
		SET @validationCode = 'VALUEMISSG'

	--if fields are empty and import is INTERNAL set inactive
	IF
		RTRIM(ISNULL(@updated_phone_number,'')) = '' AND
		RTRIM(ISNULL(@updated_area_code,'')) = '' AND
		@import_type_code = 'INTERNAL'
	BEGIN
		SET @inactivating = 1
	END
	ELSE IF --certain fields are required
		RTRIM(ISNULL(@updated_phone_number,'')) = '' OR
		RTRIM(ISNULL(@updated_area_code,'')) = ''
	BEGIN
		SET @validationCode = 'VALUEMISSG'
		RETURN 0
	END

	--Don't update if changed recently
	IF
		(@original_area_code			IS NOT NULL AND @original_area_code					<> @current_area_code) OR
		(@original_phone_number			IS NOT NULL AND @original_phone_number				<> @current_phone_number)
	BEGIN
		SET @validationCode = 'RECENTCHG'
		RETURN 0
	END

	--Don't update if no changes
	IF
		(ISNULL(@updated_area_code,'')				= ISNULL(@current_area_code,'')) AND
		(ISNULL(@updated_phone_number,'')			= ISNULL(@current_phone_number,''))
	BEGIN
		SET @validationCode = 'NOCHANGE'
		RETURN 0
	END

	--Don't change data if valid flag is set
	--IF @current_contact_phone_id IS NOT NULL AND @current_cst_valid_flag = 'Y'
	--BEGIN
	--	SET @validationCode = 'VALIDEXIST'
	--	RETURN 0
	--END

	--Phone format validation
	IF dbo.psoIsValidPhone(@updated_area_code, @updated_phone_number) = 'N'
		SET @validationCode = 'INVFORMAT'

	--no errors; we're good to import
	IF @validationCode = 'IMPORTED'
	BEGIN
		IF RTRIM(ISNULL(@contact_phone_id,'')) = '' OR RTRIM(ISNULL(@current_contact_phone_id,'')) = '' --adding new row
		BEGIN
			IF @import_type_code = 'INTERNAL'
			BEGIN
				--Internal import, do not create a row
				SET @validationCode = 'NOPKINTERN'
				RETURN 0
			END

			DECLARE @maxPrimary nchar(1)
			DECLARE @maxSort int

			SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
				FROM oncd_contact_phone WHERE contact_id = @contact_id

			IF RTRIM(ISNULL(@contact_phone_id,'')) = ''
			BEGIN
				--create_primary_key is time-dependent; don't do more than one in same millisecond
				WAITFOR DELAY '00:00:00.005'
				EXEC onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @current_contact_phone_id OUTPUT, NULL
			END
			ELSE
				SET @current_contact_phone_id = @contact_phone_id

			BEGIN TRY
			INSERT INTO oncd_contact_phone (contact_phone_id, contact_id, phone_type_code, cst_phone_type_updated_by_user_code, cst_phone_type_updated_date, country_code_prefix, area_code, phone_number, extension, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag, active, cst_skip_trace_vendor_code)
				VALUES (@current_contact_phone_id, @contact_id, 'SKIP', 'SKIP', GETDATE(), @updated_country_code_prefix, @updated_area_code, @updated_phone_number, @updated_extension, @maxSort + 1, GETDATE(), 'SKIP', GETDATE(), 'SKIP', CASE WHEN @maxPrimary = 'Y' THEN 'N' ELSE 'Y' END, 'Y', 'Y', @row_vendor_code)
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
				UPDATE oncd_contact_phone SET
					active = 'N',
					primary_flag = 'N',
					updated_date			= GETDATE(),
					updated_by_user_code	= 'SKIP',
					cst_skip_trace_vendor_code = @row_vendor_code
				WHERE contact_phone_id = @current_contact_phone_id

				SET @status_message = 'Inactivated'

				--Set a new primary if possible
				IF @current_primary_flag = 'Y'
					UPDATE oncd_contact_phone
						SET primary_flag = 'Y',
							updated_date			= GETDATE(),
							updated_by_user_code	= 'SKIP',
							cst_skip_trace_vendor_code = @row_vendor_code
						WHERE contact_phone_id =
							(SELECT TOP 1 contact_phone_id FROM oncd_contact_phone WHERE contact_id = @contact_id AND active = 'Y' AND cst_valid_flag = 'Y' ORDER BY sort_order)

			END
			ELSE
			UPDATE oncd_contact_phone SET
				phone_type_code			= 'SKIP',
				cst_phone_type_updated_by_user_code = 'SKIP',
				cst_phone_type_updated_date = GETDATE(),
				country_code_prefix		= @updated_country_code_prefix,
				area_code				= @updated_area_code,
				phone_number			= @updated_phone_number,
				updated_date			= GETDATE(),
				updated_by_user_code	= 'SKIP',
				cst_valid_flag			= 'Y',
				cst_skip_trace_vendor_code = @row_vendor_code
			WHERE contact_phone_id = @current_contact_phone_id
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

	IF RTRIM(ISNULL(@contact_phone_id,'')) = '' AND RTRIM(ISNULL(@current_contact_phone_id,'')) <> '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @current_contact_phone_id WHERE skip_trace_import_detail_id = @import_detail_id

	RETURN 0

END
GO
