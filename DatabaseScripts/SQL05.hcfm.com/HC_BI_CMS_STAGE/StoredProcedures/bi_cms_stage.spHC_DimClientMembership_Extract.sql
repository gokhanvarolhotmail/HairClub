/* CreateDate: 05/03/2010 12:19:52.450 , ModifyDate: 02/12/2019 09:52:25.723 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembership_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembership_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_cms_stage].[spHC_DimClientMembership_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/12/2009  RLifke       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
--			06/18/2013  KMurdoch	 Added [ClientMembershipIdentifier]
--			12/18/2018	KMurdoch	 Added National Monthly Fee
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembership]'


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

				INSERT INTO [bi_cms_stage].[DimClientMembership]
						   ( [DataPkgKey]
							, [ClientMembershipKey]
							, [ClientMembershipSSID]
							, [Member1_ID_Temp]
							, [ClientKey]
							, [ClientSSID]
							, [CenterKey]
							, [CenterSSID]
							, [MembershipKey]
							, [MembershipSSID]
							, [ClientMembershipStatusSSID]
							, [ClientMembershipStatusDescription]
							, [ClientMembershipStatusDescriptionShort]
							, [ClientMembershipContractPrice]
							, [ClientMembershipContractPaidAmount]
							, [ClientMembershipMonthlyFee]
							, [ClientMembershipBeginDate]
							, [ClientMembershipEndDate]
							, [ClientMembershipCancelDate]
							, [ClientMembershipIdentifier]
							, [NationalMonthlyFee]
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
						, NULL AS [ClientMembershipKey]
						, [ClientMembershipGUID] AS [ClientMembershipSSID]
						, [Member1_ID_Temp] AS [Member1_ID_Temp]
						, NULL AS [ClientKey]
						, [ClientGUID] AS [ClientSSID]
						, NULL AS [CenterKey]
						, [CenterID] AS [CenterSSID]
						, NULL AS [MembershipKey]
						, [MembershipID] AS [MembershipSSID]
						, cl.[ClientMembershipStatusID] AS [ClientMembershipStatusSSID]
						, CAST(ISNULL(LTRIM(RTRIM(clms.[ClientMembershipStatusDescription])),'') AS nvarchar(50)) AS [ClientMembershipStatusDescription]
						, CAST(ISNULL(LTRIM(RTRIM(clms.[ClientMembershipStatusDescriptionShort])),'') AS nvarchar(10)) AS [ClientMembershipStatusDescriptionShort]

						, COALESCE([ContractPrice],0.0) AS [ClientMembershipContractPrice]
						, COALESCE([ContractPaidAmount],0.0) AS [ClientMembershipContractPaidAmount]
						, COALESCE([MonthlyFee],0.0) AS [ClientMembershipMonthlyFee]
						, COALESCE([BeginDate],'1/1/1753') AS [ClientMembershipBeginDate]
						, COALESCE([EndDate],'12/31/9999') AS [ClientMembershipEndDate]
						, COALESCE([CancelDate],'12/31/9999') AS [ClientMembershipCancelDate]
						, [ClientMembershipIdentifier]
						, [NationalMonthlyFee]

						, cl.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([ClientMembershipGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datClientMembership] cl
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpClientMembershipStatus] clms
							ON cl.[ClientMembershipStatusID] = clms.[ClientMembershipStatusID]

				WHERE (cl.[CreateDate] >= @LSET AND cl.[CreateDate] < @CET_UTC)
				   OR (cl.[LastUpdate] >= @LSET AND cl.[LastUpdate] < @CET_UTC)

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
