/* CreateDate: 11/02/2015 10:07:14.030 , ModifyDate: 11/02/2015 10:07:14.030 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-06-02
-- Description:	Validate and Update importing Email data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceImportValidateAndUpdateEmail]
	-- Add the parameters for the stored procedure here
	@import_detail_id	uniqueidentifier,
	@validationCode    nchar(10) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @validationCode = 'IMPORTED'

	IF @import_detail_id IS NULL
		RETURN -1

	DECLARE @import_type_code			nchar(10)
	DECLARE @import_vendor_code			nchar(20)
	DECLARE @row_vendor_code			nchar(20)
	DECLARE @contact_id					nchar(10)
	DECLARE @contact_email_id			nchar(10)
	DECLARE @updated_email_type_code	nchar(10)
	DECLARE @updated_email				nvarchar(100)
	DECLARE @original_email_type_code	nchar(10)
	DECLARE @original_email				nvarchar(100)

	DECLARE @current_contact_email_id	nchar(10)
	DECLARE @current_email_type_code	nchar(10)
	DECLARE @current_email				nvarchar(100)
	DECLARE @current_cst_valid_flag		nchar(1)
	DECLARE @current_primary_flag		nchar(1)

	DECLARE @status_message				nvarchar(4000)
	DECLARE @inactivating				bit

	SET @inactivating = 0

	SET @validationCode = 'IMPORTED' --Default value indicating successful import/update

	SELECT
		@import_type_code			= skip_trace_import_type_code,
		@import_vendor_code			= i.skip_trace_vendor_code,
		@row_vendor_code			= cstd_skip_trace_import_detail.skip_trace_vendor_code,
		@contact_id					= contact_id,
		@contact_email_id			= import_target_table_id_value,
		@updated_email_type_code	= updated_email_type_code,
		@updated_email				= updated_email,
		@original_email_type_code	= original_email_type_code,
		@original_email				= original_email
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	WHERE skip_trace_import_detail_id = @import_detail_id

	SET @current_contact_email_id	= NULL
	SET @current_email_type_code	= NULL
	SET @current_email				= NULL
	SET @current_cst_valid_flag		= NULL
	SET @current_primary_flag		= NULL

	IF (ISNULL(@contact_email_id,'') = '')
	BEGIN
		SELECT
			@current_contact_email_id	= contact_email_id,
			@current_email_type_code	= email_type_code,
			@current_email				= email,
			@current_cst_valid_flag		= cst_valid_flag,
			@current_primary_flag		= primary_flag
		FROM oncd_contact_email WHERE contact_id = @contact_id
			AND cst_valid_flag = 'Y' AND active = 'Y'
		ORDER BY primary_flag DESC, sort_order
	END
	ELSE
	BEGIN
		SELECT
			@current_contact_email_id	= contact_email_id,
			@current_email_type_code	= email_type_code,
			@current_email				= email,
			@current_cst_valid_flag		= cst_valid_flag,
			@current_primary_flag		= primary_flag
		FROM oncd_contact_email WHERE contact_email_id = @contact_email_id
	END

	--Override with Import level vendor if supplied
	IF @import_vendor_code <> 'ROWVALUE'
		SET @row_vendor_code = @import_vendor_code
	IF RTRIM(ISNULL(@row_vendor_code,'')) = ''
		SET @validationCode = 'VALUEMISSG'

	--certain fields are required
	IF
		RTRIM(ISNULL(@updated_email,'')) = ''
	BEGIN
		IF @import_type_code = 'INTERNAL'
			SET @inactivating = 1
		ELSE
		BEGIN
			SET @validationCode = 'VALUEMISSG'
			RETURN 0
		END
	END

	--Don't update if changed recently
	IF
		(@original_email			IS NOT NULL AND @original_email				<> @current_email)
	BEGIN
		SET @validationCode = 'RECENTCHG'
		RETURN 0
	END

	--Don't update if no changes
	IF
		(ISNULL(@updated_email,'')				= ISNULL(@current_email,''))
	BEGIN
		SET @validationCode = 'NOCHANGE'
		RETURN 0
	END

	--Don't change data if valid flag is set
	--IF @current_contact_email_id IS NOT NULL AND @current_cst_valid_flag = 'Y'
	--BEGIN
	--	SET @validationCode = 'VALIDEXIST'
	--	RETURN 0
	--END

	--Email format validation
	IF dbo.psoIsValidEmail(@updated_email) = 'N'
		SET @validationCode = 'INVFORMAT'

	--no errors; we're good to import
	IF @validationCode = 'IMPORTED'
	BEGIN
		IF RTRIM(ISNULL(@contact_email_id,'')) = '' OR RTRIM(ISNULL(@current_contact_email_id,'')) = ''--adding new row
		BEGIN
			IF @import_type_code = 'INTERNAL'
			BEGIN
				--Do not create entry for INTERNAL import
				SET @validationCode = 'NOPKINTERN'
				RETURN 0
			END

			DECLARE @maxPrimary nchar(1)
			DECLARE @maxSort int

			SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
				FROM oncd_contact_email WHERE contact_id = @contact_id

			IF RTRIM(ISNULL(@contact_email_id,'')) = ''
			BEGIN
				--create_primary_key is time-dependent; don't do more than one in same millisecond
				WAITFOR DELAY '00:00:00.005'
				EXEC onc_create_primary_key 10,'oncd_contact_email','contact_email_id', @current_contact_email_id OUTPUT, NULL
			END
			ELSE --contact_email_id used to exist and has been deleted
				SET @current_contact_email_id = @contact_email_id

			BEGIN TRY
			INSERT INTO oncd_contact_email (contact_email_id, contact_id, email_type_code, email, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag, active, cst_skip_trace_vendor_code)
				VALUES (@current_contact_email_id, @contact_id, 'SKIP', @updated_email, @maxSort + 1, GETDATE(), 'SKIP', GETDATE(), 'SKIP', CASE WHEN @maxPrimary = 'Y' THEN 'N' ELSE 'Y' END, 'Y', 'Y', @row_vendor_code)
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
					UPDATE oncd_contact_email SET
						active = 'N',
						primary_flag = 'N',
						updated_date			= GETDATE(),
						updated_by_user_code	= 'SKIP',
						cst_skip_trace_vendor_code = @row_vendor_code
					WHERE contact_email_id = @current_contact_email_id

					SET @status_message = 'Inactivated'

					--Set a new primary if possible
					IF @current_primary_flag = 'Y'
						UPDATE oncd_contact_email
							SET primary_flag = 'Y',
								updated_date			= GETDATE(),
								updated_by_user_code	= 'SKIP',
								cst_skip_trace_vendor_code = @row_vendor_code
							WHERE contact_email_id =
								(SELECT TOP 1 contact_email_id FROM oncd_contact_email WHERE contact_id = @contact_id AND active = 'Y' AND cst_valid_flag = 'Y' ORDER BY sort_order)
				END
			ELSE
			UPDATE oncd_contact_email SET
				email_type_code			= 'SKIP',
				email					= @updated_email,
				updated_date			= GETDATE(),
				updated_by_user_code	= 'SKIP',
				cst_valid_flag			= 'Y',
				cst_skip_trace_vendor_code = @row_vendor_code
			WHERE contact_email_id = @current_contact_email_id
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

	IF RTRIM(ISNULL(@contact_email_id,'')) = '' AND RTRIM(ISNULL(@current_contact_email_id,'')) <> '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @current_contact_email_id WHERE skip_trace_import_detail_id = @import_detail_id


	RETURN 0

END
GO
