/* CreateDate: 12/04/2015 15:36:11.577 , ModifyDate: 03/22/2016 10:58:43.943 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-11-18
-- Description:	Validate and Update importing Email data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExternalImportValidateAndUpdateEmail]
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

	DECLARE @status_message				nvarchar(4000)
	DECLARE @inactivating				bit

	SET @inactivating = 0

	SET @validationCode = 'IMPORTED' --Default value indicating successful import/update

	SELECT
		@import_type_code			= skip_trace_import_type_code,
		@import_vendor_code			= i.skip_trace_vendor_code,
		@row_vendor_code			= cstd_skip_trace_import_detail.skip_trace_vendor_code,
		@contact_id					= contact_id,
		@updated_email				= updated_email
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	WHERE skip_trace_import_detail_id = @import_detail_id


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


	--Don't update if no changes
	IF EXISTS (SELECT 1 FROM oncd_contact_email WITH (NOLOCK) WHERE contact_id = @contact_id AND email = @updated_email)
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
		DECLARE @maxPrimary nchar(1)
		DECLARE @maxSort int

		SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
			FROM oncd_contact_email WITH (NOLOCK) WHERE contact_id = @contact_id

		IF RTRIM(ISNULL(@contact_email_id,'')) = ''
		BEGIN
			--create_primary_key is time-dependent; don't do more than one in same millisecond
			--WAITFOR DELAY '00:00:00.005'
			EXEC pso_onc_create_primary_key 10,'oncd_contact_email','contact_email_id', @contact_email_id OUTPUT, NULL
		END

		BEGIN TRY
		INSERT INTO oncd_contact_email (contact_email_id, contact_id, email_type_code, email, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag, active, cst_skip_trace_vendor_code)
			VALUES (@contact_email_id, @contact_id, 'SKIP', @updated_email, @maxSort + 1, GETDATE(), 'SKIP', GETDATE(), 'SKIP', 'N', 'Y', 'Y', @row_vendor_code)
		END TRY
		BEGIN CATCH
			SET @validationCode = 'INVDATA'
			SET @status_message = ERROR_MESSAGE()
		END CATCH
	END

	--Final updates to cstd_skip_trace_import_detail
	IF RTRIM(ISNULL(@status_message,'')) <> ''
		UPDATE cstd_skip_trace_import_detail SET status_message = @status_message WHERE skip_trace_import_detail_id = @import_detail_id

	IF RTRIM(ISNULL(@contact_email_id,'')) = '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @contact_email_id WHERE skip_trace_import_detail_id = @import_detail_id


	RETURN 0

END




/****** Object:  StoredProcedure [dbo].[psoSkipTraceExternalImportValidateAndUpdatePhone]    Script Date: 1/4/2016 1:31:52 PM ******/
SET ANSI_NULLS ON
GO
