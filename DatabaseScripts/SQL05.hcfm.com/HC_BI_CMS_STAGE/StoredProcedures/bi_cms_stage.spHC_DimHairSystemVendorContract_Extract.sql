/* CreateDate: 06/27/2011 17:23:31.817 , ModifyDate: 06/27/2011 17:23:31.817 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimHairSystemVendorContract_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimHairSystemVendorContract_Extract] is used to retrieve a
-- list of Hair System Densities
--
--   exec [bi_cms_stage].[spHC_DimHairSystemVendorContract_Extract] 1, '2011-01-01 01:00:00', '2011-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    6/9/2011	KMurdoch     Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemVendorContract]'


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


				INSERT INTO [bi_cms_stage].[DimHairSystemVendorContract]
						   ( [DataPkgKey]
						   , [HairSystemVendorContractKey]
						   , [HairSystemVendorContractSSID]
						   , [HairSystemVendorContractName]
						   , [HairSystemVendorDescription]
						   , [HairSystemVendorDescriptionShort]
						   , [HairSystemVendorContractBeginDate]
						   , [HairSystemVendorContractEndDate]
						   , [IsRepair]
						   , [IsActiveContract]
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
				SELECT
						@DataPkgKey
						, NULL AS [HairSystemVendorContractKey]
						, [HairSystemVendorContractID] AS [HairSystemVendorContractSSID]
						, RTRIM(LTRIM(ISNULL(VC.ContractName,''))) AS [HairSystemContractName]
						, RTRIM(LTRIM(ISNULL(VN.VendorDescription,''))) as 'HairSystemVendorDescription'
						, RTRIM(LTRIM(ISNULL(VN.VendorDescriptionShort,''))) as 'HairSystemVendorDescriptionShort'
						, VC.ContractBeginDate as 'HairSystemVendorContractBeginDate'
						, VC.ContractEndDate as 'HairSystemVendorContracEndDate'
						, case when isnull(VC.IsRepair,0)=1 then 'Y' else 'N' end  as 'IsRepair'
						, case when isnull(VC.[IsActiveContract],0)=1 then 'Y' else 'N' end as 'IsActiveContract'
						, VC.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([HairSystemVendorContractID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgHairSystemVendorContract] VC
					inner join [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgvendor] VN on
						VC.VendorID = VN.VendorID
				WHERE (VC.[CreateDate] >= @LSET AND VC.[CreateDate] < @CET)
				   OR (VC.[LastUpdate] >= @LSET AND VC.[LastUpdate] < @CET)

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
