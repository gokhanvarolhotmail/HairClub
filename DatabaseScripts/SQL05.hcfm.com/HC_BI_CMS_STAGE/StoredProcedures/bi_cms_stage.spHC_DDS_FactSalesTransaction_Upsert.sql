/* CreateDate: 05/03/2010 12:19:48.100 , ModifyDate: 06/26/2019 09:07:38.607 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_FactSalesTransaction_Upsert]
			   @DataPkgKey					int
			 , @IgnoreRowCnt				bigint output
			 , @InsertRowCnt				bigint output
			 , @UpdateRowCnt				bigint output
			 , @ExceptionRowCnt				bigint output
			 , @ExtractRowCnt				bigint output
			 , @InsertNewRowCnt				bigint output
			 , @InsertInferredRowCnt		bigint output
			 , @InsertSCD2RowCnt			bigint output
			 , @UpdateInferredRowCnt		bigint output
			 , @UpdateSCD1RowCnt			bigint output
			 , @UpdateSCD2RowCnt			bigint output
			 , @InitialRowCnt				bigint output
			 , @FinalRowCnt					bigint output

AS
-------------------------------------------------------------------------
-- [spHC_DDS_FactSalesTransaction_Upsert] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_cms_stage].[spHC_DDS_FactSalesTransaction_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/19/2009  RLifke       Initial Creation
--			05/23/2012	KMurdoch	 Added in data
--			01/22/2013  KMurdoch     Added in AccountID
--			03/21/2013	EKnapp		 Delete Extra rows
--			09/25/2013  DLeiba		 Added Upgrades, Downgrades & Removals
--          10/30/2013  EKnapp       Removed Nolock statement in delete sub select.
--			06/03/2014	RHut		 Added NB_XtrCnt and NB_XtrAmt for Xtrands membership
--			11/19/2014  KMurdoch     Added NB_XTRConvCnt
--			12/23/2014  RHut		 Added PCP_XtrAmt
--			02/15/2017  Kmurdoch     Added NetSaleAmt
--			01/29/2017	KMurdoch     Added PRPAmt & PRPCnt
--			07/16/2018	KMurdoch     Added LaserCnt & LaserAmt
--			12/03/2018	KMurdoch     Added MDP
--			03/18/2019  KMurdoch	 Added breakdown of Laser between New and Recurring memberships
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

	DECLARE		@TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'


	BEGIN TRY

		SET @IgnoreRowCnt = 0
		SET @InsertRowCnt = 0
		SET @UpdateRowCnt = 0
		SET @ExceptionRowCnt = 0
		SET @ExtractRowCnt = 0
		SET @InsertNewRowCnt = 0
		SET @InsertInferredRowCnt = 0
		SET @InsertSCD2RowCnt = 0
		SET @UpdateInferredRowCnt = 0
		SET @UpdateSCD1RowCnt = 0
		SET @UpdateSCD2RowCnt = 0
		SET @InitialRowCnt = 0
		SET @FinalRowCnt = 0
		SET @DeletedRowCnt = 0
		SET @DuplicateRowCnt = 0
		SET @HealthyRowCnt = 0
		SET @RejectedRowCnt = 0
		SET @AllowedRowCnt = 0
		SET @FixedRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactSalesTransaction]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

	-- Delete any rows which don't have the corresponding Dim anymore (the dim would have been deleted)
		DELETE FROM [bi_cms_stage].[synHC_DDS_FactSalesTransaction]
		where SalesOrderDetailKey NOT IN
		(select SalesOrderDetailKey
		FROM  [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail])

		SET @DeletedRowCnt = @@ROWCOUNT

		INSERT INTO [bi_cms_stage].[synHC_DDS_FactSalesTransaction](
					  [SalesOrderDetailKey]
					, [OrderDateKey]
					, [SalesOrderKey]
					, [SalesOrderTypeKey]
					, [CenterKey]
					, [ClientKey]
					, [MembershipKey]
					, [ClientMembershipKey]
					, [SalesCodeKey]
					, [Employee1Key]
					, [Employee2Key]
					, [Employee3Key]
					, [Employee4Key]
					, [Quantity]
					, [Price]
					, [Discount]
					, [Tax1]
					, [Tax2]
					, [TaxRate1]
					, [TaxRate2]

					, [ContactKey]
					, [SourceKey]
					, [GenderKey]
					, [OccupationKey]
					, [EthnicityKey]
					, [MaritalStatusKey]
					, [HairLossTypeKey]
					, [AgeRangeKey]
					, [PromotionCodeKey]

					, [AccountID]



					,	[S1_SaleCnt]
					,	[S_CancelCnt]
					,	[S1_NetSalesCnt]
					,	[S1_NetSalesAmt]
					,	[S1_ContractAmountAmt]
					,	[S1_EstGraftsCnt]
					,	[S1_EstPerGraftsAmt]
					,	[SA_NetSalesCnt]
					,	[SA_NetSalesAmt]
					,	[SA_ContractAmountAmt]
					,	[SA_EstGraftsCnt]
					,	[SA_EstPerGraftAmt]
					,	[S_PostExtCnt]
					,	[S_PostExtAmt]
					,   [S_PRPCnt]
					,	[S_PRPAmt]
					,	[S_SurgeryPerformedCnt]
					,	[S_SurgeryPerformedAmt]
					,	[S_SurgeryGraftsCnt]
					,	[S1_DepositsTakenCnt]
					,	[S1_DepositsTakenAmt]
					,	[NB_GrossNB1Cnt]
					,	[NB_TradCnt]
					,	[NB_TradAmt]
					,	[NB_GradCnt]
					,	[NB_GradAmt]
					,	[NB_ExtCnt]
					,	[NB_ExtAmt]
					,	[NB_XtrCnt]
					,	[NB_XtrAmt]
					,	[NB_AppsCnt]
					,	[NB_BIOConvCnt]
					,	[NB_EXTConvCnt]
					,	[NB_XTRConvCnt]
					,	[NB_RemCnt]
					,	[PCP_NB2Amt]
					,	[PCP_PCPAmt]
					,	[PCP_BioAmt]
					,	[PCP_XtrAmt]
					,	[PCP_ExtMemAmt]
					,	[PCPNonPgmAmt]
					,	[PCP_UpgCnt]
					,	[PCP_DwnCnt]
					,	[ServiceAmt]
					,	[RetailAmt]
					,	[ClientServicedCnt]
					,	[NetMembershipAmt]
					,   [NetSalesAmt]
					,	[S_GrossSurCnt]
					,	[S_SurCnt]
					,	[S_SurAmt]
					,	[LaserCnt]
					,	[LaserAmt]
					,	[NB_MDPCnt]
					,	[NB_MDPAmt]
					,	[NB_LaserCnt]
					,	[NB_LaserAmt]
					,	[PCP_LaserCnt]
					,	[PCP_LaserAmt]

					,	[EMP_RetailAmt]
					,	[EMP_NB_LaserCnt]
					,	[EMP_NB_LaserAmt]
					,	[EMP_PCP_LaserCnt]
					,	[EMP_PCP_LaserAmt]

					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT DISTINCT
					  STG.[SalesOrderDetailKey]
					, STG.[OrderDateKey]
					, STG.[SalesOrderKey]
					, STG.[SalesOrderTypeKey]
					, STG.[CenterKey]
					, STG.[ClientKey]
					, STG.[MembershipKey]
					, STG.[ClientMembershipKey]
					, STG.[SalesCodeKey]
					, STG.[Employee1Key]
					, STG.[Employee2Key]
					, STG.[Employee3Key]
					, STG.[Employee4Key]
					, STG.[Quantity]
					, STG.[Price]
					, STG.[Discount]
					, STG.[Tax1]
					, STG.[Tax2]
					, STG.[TaxRate1]
					, STG.[TaxRate2]

					, ISNULL(STG.[ContactKey],-1)
					, ISNULL(STG.[SourceKey],-1)
					, ISNULL(STG.[GenderKey],-1)
					, ISNULL(STG.[OccupationKey],-1)
					, ISNULL(STG.[EthnicityKey],-1)
					, ISNULL(STG.[MaritalStatusKey],-1)
					, ISNULL(STG.[HairLossTypeKey],-1)
					, ISNULL(STG.[AgeRangeKey],-1)
					, ISNULL(STG.[PromotionCodeKey],-1)

					, STG.[AccountID]

					,	STG.[S1_SaleCnt]
					,	STG.[S_CancelCnt]
					,	STG.[S1_NetSalesCnt]
					,	STG.[S1_NetSalesAmt]
					,	STG.[S1_ContractAmountAmt]
					,	STG.[S1_EstGraftsCnt]
					,	STG.[S1_EstPerGraftsAmt]
					,	STG.[SA_NetSalesCnt]
					,	STG.[SA_NetSalesAmt]
					,	STG.[SA_ContractAmountAmt]
					,	STG.[SA_EstGraftsCnt]
					,	STG.[SA_EstPerGraftAmt]
					,	STG.[S_PostExtCnt]
					,	STG.[S_PostExtAmt]
					,   STG.[S_PRPCnt]
					,	STG.[S_PRPAmt]
					,	STG.[S_SurgeryPerformedCnt]
					,	STG.[S_SurgeryPerformedAmt]
					,	STG.[S_SurgeryGraftsCnt]
					,	STG.[S1_DepositsTakenCnt]
					,	STG.[S1_DepositsTakenAmt]
					,	STG.[NB_GrossNB1Cnt]
					,	STG.[NB_TradCnt]
					,	STG.[NB_TradAmt]
					,	STG.[NB_GradCnt]
					,	STG.[NB_GradAmt]
					,	STG.[NB_ExtCnt]
					,	STG.[NB_ExtAmt]
					,	STG.[NB_XtrCnt]
					,	STG.[NB_XtrAmt]
					,	STG.[NB_AppsCnt]
					,	STG.[NB_BIOConvCnt]
					,	STG.[NB_EXTConvCnt]
					,   STG.[NB_XTRConvCnt]
					,	STG.[NB_RemCnt]
					,	STG.[PCP_NB2Amt]
					,	STG.[PCP_PCPAmt]
					,	STG.[PCP_BioAmt]
					,	STG.[PCP_XtrAmt]
					,	STG.[PCP_ExtMemAmt]
					,	STG.[PCPNonPgmAmt]
					,	STG.[PCP_UpgCnt]
					 ,	STG.[PCP_DwnCnt]
					,	STG.[ServiceAmt]
					,	STG.[RetailAmt]
					,	STG.[ClientServicedCnt]
					,	STG.[NetMembershipAmt]
					,   STG.[NetSalesAmt]
					,	STG.[S_GrossSurCnt]
					,	STG.[S_SurCnt]
					,	STG.[S_SurAmt]
					,	STG.[LaserCnt]
					,	STG.[LaserAmt]
					,	STG.[NB_MDPCnt]
					,	STG.[NB_MDPAmt]
					,	STG.[NB_LaserCnt]
					,	STG.[NB_LaserAmt]
					,	STG.[PCP_LaserCnt]
					,	STG.[PCP_LaserAmt]

					,	STG.[EMP_RetailAmt]
					,	STG.[EMP_NB_LaserCnt]
					,	STG.[EMP_NB_LaserAmt]
					,	STG.[EMP_PCP_LaserCnt]
					,	STG.[EMP_PCP_LaserAmt]

					, @DataPkgKey
					, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[FactSalesTransaction] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT


		------------------------
		-- Update Records
		------------------------
		-- Just update the record
		UPDATE DW SET
			  DW.[OrderDateKey] = STG.[OrderDateKey]
			, DW.[SalesOrderKey] = STG.[SalesOrderKey]
			, DW.[SalesOrderTypeKey] = STG.[SalesOrderTypeKey]
			, DW.[CenterKey] = STG.[CenterKey]
			, DW.[ClientKey] = STG.[ClientKey]
			, DW.[MembershipKey] = STG.[MembershipKey]
			, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
			, DW.[SalesCodeKey] = STG.[SalesCodeKey]
			, DW.[Employee1Key] = STG.[Employee1Key]
			, DW.[Employee2Key] = STG.[Employee2Key]
			, DW.[Employee3Key] = STG.[Employee3Key]
			, DW.[Employee4Key] = STG.[Employee4Key]
			, DW.[Quantity] = STG.[Quantity]
			, DW.[Price] = STG.[Price]
			, DW.[Discount] = STG.[Discount]
			, DW.[Tax1] = STG.[Tax1]
			, DW.[Tax2] = STG.[Tax2]
			, DW.[TaxRate1] = STG.[TaxRate1]
			, DW.[TaxRate2] = STG.[TaxRate2]

			, DW.[ContactKey] = ISNULL(STG.[ContactKey],-1)
			, DW.[SourceKey] = ISNULL(STG.[SourceKey],-1)
			, DW.[GenderKey] = ISNULL(STG.[GenderKey],-1)
			, DW.[OccupationKey] = ISNULL(STG.[OccupationKey],-1)
			, DW.[EthnicityKey] = ISNULL(STG.[EthnicityKey],-1)
			, DW.[MaritalStatusKey] = ISNULL(STG.[MaritalStatusKey],-1)
			, DW.[HairLossTypeKey] = ISNULL(STG.[HairLossTypeKey],-1)
			, DW.[AgeRangeKey] = ISNULL(STG.[AgeRangeKey],-1)
			, DW.[PromotionCodeKey] = ISNULL(STG.[PromotionCodeKey],-1)
			, DW.[AccountID] = STG.[AccountID]

			, DW.[S1_SaleCnt] = STG.[S1_SaleCnt]
			, DW.[S_CancelCnt] = STG.[S_CancelCnt]
			, DW.[S1_NetSalesCnt] = STG.[S1_NetSalesCnt]
			, DW.[S1_NetSalesAmt] = STG.[S1_NetSalesAmt]
			, DW.[S1_ContractAmountAmt] = STG.[S1_ContractAmountAmt]
			, DW.[S1_EstGraftsCnt] = STG.[S1_EstGraftsCnt]
			, DW.[S1_EstPerGraftsAmt] = STG.[S1_EstPerGraftsAmt]
			, DW.[SA_NetSalesCnt] = STG.[SA_NetSalesCnt]
			, DW.[SA_NetSalesAmt] = STG.[SA_NetSalesAmt]
			, DW.[SA_ContractAmountAmt] = STG.[SA_ContractAmountAmt]
			, DW.[SA_EstGraftsCnt] = STG.[SA_EstGraftsCnt]
			, DW.[SA_EstPerGraftAmt] = STG.[SA_EstPerGraftAmt]
			, DW.[S_PostExtCnt] = STG.[S_PostExtCnt]
			, DW.[S_PostExtAmt] = STG.[S_PostExtAmt]
			, DW.[S_PRPCnt] = STG.[S_PRPCnt]
			, DW.[S_PRPAmt] = STG.[S_PRPAmt]
			, DW.[S_SurgeryPerformedCnt] = STG.[S_SurgeryPerformedCnt]
			, DW.[S_SurgeryPerformedAmt] = STG.[S_SurgeryPerformedAmt]
			, DW.[S_SurgeryGraftsCnt] = STG.[S_SurgeryGraftsCnt]
			, DW.[S1_DepositsTakenCnt] = STG.[S1_DepositsTakenCnt]
			, DW.[S1_DepositsTakenAmt] = STG.[S1_DepositsTakenAmt]
			, DW.[NB_GrossNB1Cnt] = STG.[NB_GrossNB1Cnt]
			, DW.[NB_TradCnt] = STG.[NB_TradCnt]
			, DW.[NB_TradAmt] = STG.[NB_TradAmt]
			, DW.[NB_GradCnt] = STG.[NB_GradCnt]
			, DW.[NB_GradAmt] = STG.[NB_GradAmt]
			, DW.[NB_ExtCnt] = STG.[NB_ExtCnt]
			, DW.[NB_ExtAmt] = STG.[NB_ExtAmt]
			, DW.[NB_XtrCnt] = STG.[NB_XtrCnt]
			, DW.[NB_XtrAmt] = STG.[NB_XtrAmt]
			, DW.[NB_AppsCnt] = STG.[NB_AppsCnt]
			, DW.[NB_BIOConvCnt] = STG.[NB_BIOConvCnt]
			, DW.[NB_EXTConvCnt] = STG.[NB_EXTConvCnt]
			, DW.[NB_XTRConvCnt] = STG.[NB_XTRConvCnt]
			, DW.[NB_RemCnt] = STG.[NB_RemCnt]
			, DW.[PCP_NB2Amt] = STG.[PCP_NB2Amt]
			, DW.[PCP_PCPAmt] = STG.[PCP_PCPAmt]
			, DW.[PCP_BioAmt] = STG.[PCP_BioAmt]
			, DW.[PCP_XtrAmt] = STG.[PCP_XtrAmt]
			, DW.[PCP_ExtMemAmt] = STG.[PCP_ExtMemAmt]
			, DW.[PCPNonPgmAmt] = STG.[PCPNonPgmAmt]
			, DW.[PCP_UpgCnt] = STG.[PCP_UpgCnt]
			, DW.[PCP_DwnCnt] = STG.[PCP_DwnCnt]
			, DW.[ServiceAmt] = STG.[ServiceAmt]
			, DW.[RetailAmt] = STG.[RetailAmt]
			, DW.[ClientServicedCnt] = STG.[ClientServicedCnt]
			, DW.[NetMembershipAmt] = STG.[NetMembershipAmt]
			, DW.[NetSalesAmt] = STG.[NetSalesAmt]
			, DW.[S_GrossSurCnt] = STG.[S_GrossSurCnt]
			, DW.[S_SurCnt] = STG.[S_SurCnt]
			, DW.[S_SurAmt] = STG.[S_SurAmt]
			, DW.[LaserCnt] = STG.[LaserCnt]
			, DW.[LaserAmt] = STG.[LaserAmt]
			, DW.[NB_MDPCnt] = STG.[NB_MDPCnt]
			, DW.[NB_MDPAmt] = STG.[NB_MDPAmt]
			, DW.[NB_LaserCnt] = STG.[NB_LaserCnt]
			, DW.[NB_LaserAmt] = STG.[NB_LaserAmt]
			, DW.[PCP_LaserCnt] = STG.[PCP_LaserCnt]
			, DW.[PCP_LaserAmt] = STG.[PCP_LaserAmt]

			, DW.[EMP_RetailAmt] = STG.[EMP_RetailAmt]
			, DW.[EMP_NB_LaserCnt] = STG.[EMP_NB_LaserCnt]
			, DW.[EMP_NB_LaserAmt] = STG.[EMP_NB_LaserAmt]
			, DW.[EMP_PCP_LaserCnt] = STG.[EMP_PCP_LaserCnt]
			, DW.[EMP_PCP_LaserAmt] = STG.[EMP_PCP_LaserAmt]

			, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		JOIN [bi_cms_stage].[synHC_DDS_FactSalesTransaction] DW WITH (NOLOCK)
			ON DW.[SalesOrderDetailKey] = STG.[SalesOrderDetailKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactSalesTransaction]


		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		--SELECT @DeletedRowCnt = COUNT(1)
		--FROM [bi_cms_stage].[FactSalesTransaction] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--AND STG.[IsDelete] = 1

		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE DataPkgKey = @DataPkgKey
			AND	STG.[IsException] = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop] @DataPkgKey, @TableName
					, @IgnoreRowCnt, @InsertRowCnt, @UpdateRowCnt, @ExceptionRowCnt, @ExtractRowCnt
					, @InsertNewRowCnt, @InsertInferredRowCnt, @InsertSCD2RowCnt
					, @UpdateInferredRowCnt, @UpdateSCD1RowCnt, @UpdateSCD2RowCnt
					, @InitialRowCnt, @FinalRowCnt
					, @DeletedRowCnt, @DuplicateRowCnt, @HealthyRowCnt
					, @RejectedRowCnt, @AllowedRowCnt, @FixedRowCnt
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
