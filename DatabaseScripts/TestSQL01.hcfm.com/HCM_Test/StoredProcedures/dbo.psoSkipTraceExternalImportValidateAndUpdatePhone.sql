/* CreateDate: 12/04/2015 15:36:11.590 , ModifyDate: 03/22/2016 10:58:43.957 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-06-02
-- Description:	Validate and Update importing Phone data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExternalImportValidateAndUpdatePhone]
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
	DECLARE @updated_country_code_prefix nchar(10)
	DECLARE @updated_area_code			nchar(10)
	DECLARE @updated_phone_number		nvarchar(20)

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
		@updated_area_code			= updated_area_code,
		@updated_phone_number		= updated_phone_number
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	WHERE skip_trace_import_detail_id = @import_detail_id

	--Override with Import level vendor if supplied
	IF @import_vendor_code <> 'ROWVALUE'
		SET @row_vendor_code = @import_vendor_code
	IF RTRIM(ISNULL(@row_vendor_code,'')) = ''
		SET @validationCode = 'VALUEMISSG'

	--if fields are empty and import is INTERNAL set inactive
	 IF --certain fields are required
		RTRIM(ISNULL(@updated_phone_number,'')) = '' OR
		RTRIM(ISNULL(@updated_area_code,'')) = ''
	BEGIN
		SET @validationCode = 'VALUEMISSG'
		RETURN 0
	END

	--Don't update if exists
	IF EXISTS (SELECT 1 FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = @contact_id AND ISNULL(area_code,'') = ISNULL(@updated_area_code,'') AND ISNULL(phone_number,'') = ISNULL(@updated_phone_number,''))
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

		DECLARE @maxPrimary nchar(1)
		DECLARE @maxSort int

		SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
			FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = @contact_id

		--create_primary_key is time-dependent; don't do more than one in same millisecond
--		WAITFOR DELAY '00:00:00.005'
		EXEC pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phone_id OUTPUT, NULL

		BEGIN TRY
			--make the new insert the highest sort
			IF EXISTS (SELECT 1 FROM oncd_contact_phone WHERE contact_id = @contact_id AND sort_order = 0)
				UPDATE oncd_contact_phone SET sort_order = ISNULL(sort_order,0) + 1 WHERE contact_id = @contact_id

			INSERT INTO oncd_contact_phone (contact_phone_id, contact_id, phone_type_code, cst_phone_type_updated_by_user_code, cst_phone_type_updated_date, area_code, phone_number, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag, active, cst_skip_trace_vendor_code)
				VALUES (@contact_phone_id, @contact_id, 'SKIP', 'SKIP', GETDATE(), @updated_area_code, @updated_phone_number, 0, GETDATE(), 'SKIP', GETDATE(), 'SKIP', 'N', 'Y', 'Y', @row_vendor_code)
		END TRY
		BEGIN CATCH
			SET @validationCode = 'INVDATA'
			SET @status_message = ERROR_MESSAGE()
		END CATCH

	END

	--Final updates to cstd_skip_trace_import_detail
	IF RTRIM(ISNULL(@status_message,'')) <> ''
		UPDATE cstd_skip_trace_import_detail SET status_message = @status_message WHERE skip_trace_import_detail_id = @import_detail_id

	IF RTRIM(ISNULL(@contact_phone_id,'')) <> '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @contact_phone_id WHERE skip_trace_import_detail_id = @import_detail_id

	RETURN 0

END





/****** Object:  StoredProcedure [dbo].[psoSkipTraceExportSetSkipTraceEventsForContact]    Script Date: 1/20/2016 4:49:31 PM ******/
SET ANSI_NULLS ON
GO
