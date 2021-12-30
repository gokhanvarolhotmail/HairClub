/* CreateDate: 05/03/2010 12:19:59.087 , ModifyDate: 12/04/2012 10:01:00.580 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimMembership_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimMembership_Extract] is used to retrieve a
-- list Business Units
--
--   exec [bi_cms_stage].[spHC_DimMembership_Extract]  22, '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			04/10/2012	KMurdoch	 Added MembershipSortOrder
--			12/04/2012  KMurdoch	 Added BusinessSegmentDescription
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

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'


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


				INSERT INTO [bi_cms_stage].[DimMembership]
						   ( [DataPkgKey]
						   , [MembershipKey]
						   , [MembershipSSID]
						   , [MembershipDescription]
						   , [MembershipDescriptionShort]
						   , [RevenueGroupSSID]
						   , [RevenueGroupDescription]
						   , [RevenueGroupDescriptionShort]
						   , [GenderSSID]
						   , [GenderDescription]
						   , [GenderDescriptionShort]
						   , [BusinessSegmentKey]
						   , [BusinessSegmentSSID]
						   , [BusinessSegmentDescription]
						   , [BusinessSegmentDescriptionShort]
						   , [MembershipDurationMonths]
						   , [MembershipContractPrice]
						   , [MembershipMonthlyFee]
						   , [MembershipSortOrder]
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
						, NULL AS [MembershipKey]
						, COALESCE(mem.[MembershipID], -2) AS [MembershipSSID]
						, CAST(ISNULL(LTRIM(RTRIM(mem.[MembershipDescription])),'') AS nvarchar(50)) AS [MembershipDescription]
						, CAST(ISNULL(LTRIM(RTRIM(mem.[MembershipDescriptionShort])),'') AS nvarchar(10)) AS [MembershipDescriptionShort]
						, COALESCE(mem.[RevenueGroupID], -2) AS [RevenueGroupSSID]
						, CAST(ISNULL(LTRIM(RTRIM(rg.[RevenueGroupDescription])),'') AS nvarchar(50)) AS [RevenueGroupDescription]
						, CAST(ISNULL(LTRIM(RTRIM(rg.[RevenueGroupDescriptionShort])),'') AS nvarchar(10)) AS [RevenueGroupDescriptionShort]
						, COALESCE(mem.[GenderID], -2) AS [GenderSSID]
						, CAST(ISNULL(LTRIM(RTRIM(gen.[GenderDescription])),'') AS nvarchar(50)) AS [GenderDescription]
						, CAST(ISNULL(LTRIM(RTRIM(gen.[GenderDescriptionShort])),'') AS nvarchar(10)) AS [GenderDescriptionShort]
						, NULL AS [BusinessSegmentKey]
						, COALESCE(mem.[BusinessSegmentID], -2) AS [BusinessSegmentSSID]
						, CAST(ISNULL(LTRIM(RTRIM(bs.[BusinessSegmentDescription])),'') AS nvarchar(50)) AS [BusinessSegmentDescription]
						, CAST(ISNULL(LTRIM(RTRIM(bs.[BusinessSegmentDescriptionShort])),'') AS nvarchar(10)) AS [BusinessSegmentDescriptionShort]
						, COALESCE(mem.[DurationMonths],0) AS [MembershipDurationMonths]
						, COALESCE(mem.[ContractPrice],0) AS [MembershipContractPrice]
						, COALESCE(mem.[MonthlyFee],0) AS [MembershipMonthlyFee]
						, COALESCE(mem.[MembershipSortOrder],0) AS [MembershipSortOrder]
						, mem.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([MembershipID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgMembership] mem
					INNER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpRevenueGroup] rg ON
							mem.[RevenueGroupID] = rg.[RevenueGroupID]
					INNER JOIN [HairclubCMS].dbo.lkpBusinessSegment bs ON
							mem.[BusinessSegmentID] = bs.[BusinessSegmentID]
					LEFT JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpGender] gen ON
							mem.[GenderID] = gen.[GenderID]
				WHERE (mem.[CreateDate] >= @LSET AND mem.[CreateDate] < @CET)
				   OR (mem.[LastUpdate] >= @LSET AND mem.[LastUpdate] < @CET)

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
