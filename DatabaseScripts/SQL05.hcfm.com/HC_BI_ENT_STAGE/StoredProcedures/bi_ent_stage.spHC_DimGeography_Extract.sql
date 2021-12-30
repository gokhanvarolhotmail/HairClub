/* CreateDate: 05/03/2010 12:09:53.463 , ModifyDate: 05/03/2010 12:09:53.463 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimGeography_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimGeography_Extract] is used to retrieve a
-- list Geographys
--
--   exec [bi_ent_stage].[spHC_DimGeography_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
 				, @return_value		int

	DECLARE		  @TableName			varchar(150)	-- Name of table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_ent_dds].[DimGeography]'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = @CET
						, [Status] = 'Extracting'
					WHERE [TableName] = @TableName


				INSERT INTO [bi_ent_stage].[DimGeography]
						   ( [DataPkgKey]
						   , [GeographyKey]
							, [PostalCode]
							, [CountryRegionDescription]
							, [CountryRegionDescriptionShort]
							, [StateProvinceDescription]
							, [StateProvinceDescriptionShort]
							, [City]
						   , [ModifiedDate]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
						   , [IsDelete]
						   , [IsDuplicate]
						   , [SourceSystemKey]
							)
				SELECT @DataPkgKey
						, NULL AS [GeographyKey]
						, CAST(ISNULL(LTRIM(RTRIM([zip_code])),'') AS nvarchar(15)) AS [PostalCode]
						, CAST(ISNULL(LTRIM(RTRIM([country_code])),'') AS nvarchar(50)) AS [CountryRegionDescription]
						, CAST(ISNULL(LTRIM(RTRIM([country_code])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([state_code])),'') AS nvarchar(50)) AS [StateProvinceDescription]
						, CAST(ISNULL(LTRIM(RTRIM([state_code])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([city])),'') AS nvarchar(50)) AS [City]
						, '' --[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([zip_code])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_ent_stage].[synHC_SRC_TBL_MKTG_onca_zip] bub WITH (NOLOCK)
				--WHERE ([cst_created_date] >= @LSET AND [cst_created_date] < @CET)
				--  OR ([cst_updated_date] >= @LSET AND [cst_updated_date] < @CET)

				SET @ExtractRowCnt = @@ROWCOUNT

				-- Set the Last Successful Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET LSET = @CET
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
		END

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF

		-- Cleanup temp tables

		-- Return success
		RETURN 0
	END TRY
    BEGIN CATCH
		-- Save original error number
		SET @intError = ERROR_NUMBER();

		-- Log the error
		EXECUTE [bief_stage].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
