/* CreateDate: 12/04/2015 15:36:11.563 , ModifyDate: 03/22/2016 10:58:43.927 */
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-11-17
-- Description:	Validate and Update importing Address data
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExternalImportValidateAndUpdateAddress]
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
		@row_vendor_code			= cstd_skip_trace_import_detail.skip_trace_vendor_code,
		@updated_address_line_1		= updated_address_line_1,
		@updated_address_line_2		= updated_address_line_2,
		@updated_city				= updated_city,
		@updated_state_code			= updated_state_code,
		@updated_zip_code			= updated_zip_code,
		@updated_county_code		= z.county_code,
		@updated_country_code		= z.country_code,
		@updated_time_zone_code		= c.time_zone_code
	FROM cstd_skip_trace_import_detail
	INNER JOIN cstd_skip_trace_import i ON i.skip_trace_import_id = cstd_skip_trace_import_detail.skip_trace_import_id
	LEFT OUTER JOIN onca_zip z ON z.zip_code = SUBSTRING(ISNULL(updated_zip_code,''),1,5)
	LEFT OUTER JOIN onca_county c ON c.county_code = z.county_code
	WHERE skip_trace_import_detail_id = @import_detail_id

	--Override with Import level vendor if supplied
	IF @import_vendor_code <> 'ROWVALUE'
		SET @row_vendor_code = @import_vendor_code
	IF RTRIM(ISNULL(@row_vendor_code,'')) = ''
		SET @validationCode = 'VALUEMISSG'


	IF --certain fields are required
		RTRIM(ISNULL(@updated_address_line_1,'')) = '' OR
		RTRIM(ISNULL(@updated_city,'')) = '' OR
		RTRIM(ISNULL(@updated_state_code,'')) = '' OR
		RTRIM(ISNULL(@updated_zip_code,'')) = ''
	BEGIN
		SET @validationCode = 'VALUEMISSG'
		RETURN 0
	END

	--Relatedly, check ALL addresses to see if this one already exists, even invalids
	IF EXISTS (SELECT 1 FROM oncd_contact_address WITH (NOLOCK) WHERE
				contact_id = @contact_id AND
				ISNULL(address_line_1,'')	= ISNULL(@updated_address_line_1,'') AND
				ISNULL(address_line_2,'')	= ISNULL(@updated_address_line_2,'') AND
				ISNULL(city,'')				= ISNULL(@updated_city,'') AND
				ISNULL(state_code,'')		= ISNULL(@updated_state_code,'') AND
				ISNULL(zip_code,'')			= ISNULL(@updated_zip_code,'')
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
		DECLARE @maxPrimary nchar(1)
		DECLARE @maxSort int

		SELECT @maxPrimary = MAX(ISNULL(primary_flag,'N')), @maxSort = MAX(sort_order)
			FROM oncd_contact_address WITH (NOLOCK) WHERE contact_id = @contact_id

		IF RTRIM(ISNULL(@contact_address_id,'')) = ''
		BEGIN
			--create_primary_key is time-dependent; don't to more than one in same millisecond
			--WAITFOR DELAY '00:00:00.005'
			EXEC pso_onc_create_primary_key 10,'oncd_contact_address','contact_address_id', @current_contact_address_id OUTPUT, NULL
		END
		ELSE
			SET @current_contact_address_id = @contact_address_id

		BEGIN TRY
			--make the new insert the highest sort
			IF EXISTS (SELECT 1 FROM oncd_contact_address WHERE contact_id = @contact_id AND sort_order = 0)
				UPDATE oncd_contact_address SET sort_order = ISNULL(sort_order,0) + 1 WHERE contact_id = @contact_id

			INSERT INTO oncd_contact_address (contact_address_id, contact_id, address_type_code, address_line_1, address_line_2, address_line_3, address_line_4, address_line_1_soundex, address_line_2_soundex, city, city_soundex, state_code, zip_code, county_code, country_code, time_zone_code, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, company_address_id, cst_valid_flag, cst_active, cst_skip_trace_vendor_code)
				VALUES (@current_contact_address_id, @contact_id, 'SKIP', @updated_address_line_1, @updated_address_line_2, @updated_address_line_3, NULL, dbo.pso_Soundex_Calculate(@updated_address_line_1, 'ADDRESS', 5), dbo.pso_Soundex_Calculate(@updated_address_line_2, 'ADDRESS', 5), @updated_city, dbo.pso_Soundex_Calculate(@updated_city, 'CITY', 5), @updated_state_code, @updated_zip_code, @updated_county_code, @updated_country_code, @updated_time_zone_code, 0, GETDATE(), 'SKIP', GETDATE(), 'SKIP', 'N', NULL, 'Y', 'Y', @row_vendor_code)
		END TRY
		BEGIN CATCH
			SET @validationCode = 'INVDATA'
			SET @status_message = ERROR_MESSAGE()
		END CATCH
	END

	--Final updates to cstd_skip_trace_import_detail
	IF RTRIM(ISNULL(@status_message,'')) <> ''
		UPDATE cstd_skip_trace_import_detail SET status_message = @status_message WHERE skip_trace_import_detail_id = @import_detail_id

	IF RTRIM(ISNULL(@current_contact_address_id,'')) <> '' AND @validationCode = 'IMPORTED'
		UPDATE cstd_skip_trace_import_detail SET import_target_table_id_value = @current_contact_address_id WHERE skip_trace_import_detail_id = @import_detail_id

	RETURN 0
END
GO
