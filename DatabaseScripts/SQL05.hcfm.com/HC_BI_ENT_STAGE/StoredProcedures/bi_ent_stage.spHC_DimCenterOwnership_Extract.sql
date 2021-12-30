/* CreateDate: 05/03/2010 12:09:44.693 , ModifyDate: 05/03/2010 12:09:44.693 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenterOwnership_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimCenterOwnership_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_ent_stage].[spHC_DimCenterOwnership_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/12/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_ent_dds].[DimCenterOwnership]'


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


				INSERT INTO [bi_ent_stage].[DimCenterOwnership]
						   ( [DataPkgKey]
						   , [CenterOwnershipKey]
						   , [CenterOwnershipSSID]
						   , [CenterOwnershipDescription]
						   , [CenterOwnershipDescriptionShort]
						   , [OwnerLastName]
						   , [OwnerFirstName]
						   , [CorporateName]
						   , [CenterAddress1]
						   , [CenterAddress2]
						   , [CountryRegionDescription]
						   , [CountryRegionDescriptionShort]
						   , [StateProvinceDescription]
						   , [StateProvinceDescriptionShort]
						   , [City]
						   , [PostalCode]
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
						, NULL AS [CenterOwnershipKey]
						, [CenterOwnershipID] AS [CenterOwnershipSSID]
						, CAST(ISNULL(LTRIM(RTRIM([CenterOwnershipDescription])),'') AS nvarchar(50)) AS [CenterOwnershipDescription]
						, CAST(ISNULL(LTRIM(RTRIM([CenterOwnershipDescriptionShort])),'') AS nvarchar(10)) AS [CenterOwnershipDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([OwnerLastName])),'') AS nvarchar(50)) AS [OwnerLastName]
						, CAST(ISNULL(LTRIM(RTRIM([OwnerFirstName])),'') AS nvarchar(50)) AS [OwnerFirstName]
						, CAST(ISNULL(LTRIM(RTRIM([CorporateName])),'') AS nvarchar(50)) AS [CorporateName]
						, CAST(ISNULL(LTRIM(RTRIM([Address1])),'') AS nvarchar(50)) AS [CenterAddress1]
						, CAST(ISNULL(LTRIM(RTRIM([Address2])),'') AS nvarchar(50)) AS [CenterAddress2]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([City])),'') AS nvarchar(50)) AS [City]
						, CAST(ISNULL(LTRIM(RTRIM([PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
						, co.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([CenterOwnershipID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpCenterOwnership] co
					INNER JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpState] st
							ON co.[StateID] = st.[StateID]
					INNER JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
							ON co.[CountryID] = cn.[CountryID]
				WHERE (co.[CreateDate] >= @LSET AND co.[CreateDate] < @CET)
				   OR (co.[LastUpdate] >= @LSET AND co.[LastUpdate] < @CET)

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
