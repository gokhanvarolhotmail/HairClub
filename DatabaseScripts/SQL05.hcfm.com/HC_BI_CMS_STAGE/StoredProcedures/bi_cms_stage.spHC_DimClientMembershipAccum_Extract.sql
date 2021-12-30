/* CreateDate: 10/05/2010 14:04:33.987 , ModifyDate: 01/03/2013 14:46:27.830 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembershipAccum_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembershipAccum_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_cms_stage].[spHC_DimClientMembershipAccum_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
--			05/30/2012  KMurdoch	 NULL values are now being captured in Extract
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'


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

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [bi_cms_stage].[DimClientMembershipAccum]
						   ( [DataPkgKey]
							, [ClientMembershipAccumKey]
							, [ClientMembershipAccumSSID]
							, [ClientMembershipKey]
							, [ClientMembershipSSID]
							, [AccumulatorKey]
							, [AccumulatorSSID]
							, [AccumulatorDescription]
							, [AccumulatorDescriptionShort]
							, [UsedAccumQuantity]
							, [AccumMoney]
							, [AccumDate]
							, [TotalAccumQuantity]
							, [AccumQuantityRemaining]

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
						, NULL AS [ClientMembershipAccumKey]
						, cl.[ClientMembershipAccumGUID] AS [ClientMembershipAccumSSID]
						, NULL AS [ClientMembershipKey]
						, cl.[ClientMembershipGUID] AS [ClientMembershipSSID]
						, NULL AS [AccumulatorKey]
						, cl.[AccumulatorID] AS [AccumulatorSSID]
						, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescription])),'') AS varchar(50)) AS [AccumulatorDescription]
						, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescriptionShort])),'') AS varchar(10)) AS [AccumulatorDescriptionShort]
						, COALESCE(cl.[UsedAccumQuantity],0) AS [UsedAccumQuantity]
						, COALESCE(cl.[AccumMoney],0.0) AS [AccumMoney]
						, COALESCE(cl.[AccumDate],'1/1/1753') AS [AccumDate]
						, COALESCE(cl.[TotalAccumQuantity],0) AS [TotalAccumQuantity]
						, COALESCE(cl.[AccumQuantityRemainingCalc],0) AS [AccumQuantityRemaining]

						, cl.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([ClientMembershipAccumGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datClientMembershipAccum] cl
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgAccumulator] acd
							ON cl.[AccumulatorID] = acd.[AccumulatorID]

				WHERE (cl.[CreateDate] >= @LSET AND cl.[CreateDate] < @CET_UTC)
						OR (cl.[LastUpdate] >= @LSET AND cl.[LastUpdate] < @CET_UTC)
						OR (cl.[CreateDate] IS NULL)
						OR (cl.[LastUpdate] IS NULL)  -- Use on initial Load

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
