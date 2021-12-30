/* CreateDate: 09/11/2012 14:00:20.083 , ModifyDate: 09/11/2012 14:00:20.083 */
GO
create PROCEDURE [bi_cms_stage].[xxxspHC_FactSalesTransaction_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransaction_Extract_CDC] is used to retrieve a
-- list SalesOrder
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--			07/14/2011	KMurdoch	 Removed logic for IsClosed or IsVoided
--			03/07/2012	KMurdoch	 Added Isnull statement for ClientMembershipGUID
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'
 	SET @CDCTableName = N'dbo_datSalesOrder'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName

							INSERT INTO [bi_cms_stage].[FactSalesTransaction]
									   ( [DataPkgKey]
										, [OrderDateKey]
										, [OrderDate]
										, [SalesOrderKey]
										, [SalesOrderSSID]
										, [SalesOrderDetailKey]
										, [SalesOrderDetailSSID]
										, [SalesOrderTypeKey]
										, [SalesOrderTypeSSID]
										, [CenterKey]
										, [CenterSSID]
										, [ClientKey]
										, [ClientSSID]
										, [MembershipKey]
										, [ClientMembershipKey]
										, [ClientMembershipSSID]
										, [SalesCodeKey]
										, [SalesCodeSSID]
										, [Employee1Key]
										, [Employee1SSID]
										, [Employee2Key]
										, [Employee2SSID]
										, [Employee3Key]
										, [Employee3SSID]
										, [Employee4Key]
										, [Employee4SSID]
										, [Quantity]
										, [Price]
										, [Discount]
										, [Tax1]
										, [Tax2]
										, [TaxRate1]
										, [TaxRate2]
										, [IsClosed]
										, [IsVoided]

										, [ContactKey]
										, [SourceKey]
										, [GenderKey]
										, [OccupationKey]
										, [EthnicityKey]
										, [MaritalStatusKey]
										, [HairLossTypeKey]
										, [AgeRangeKey]
										, [PromotionCodeKey]


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
										,	[NB_AppsCnt]
										,	[NB_BIOConvCnt]
										,	[NB_EXTConvCnt]
										,	[PCP_NB2Amt]
										,	[PCP_PCPAmt]
										,	[PCP_BioAmt]
										,	[PCP_ExtMemAmt]
										,	[PCPNonPgmAmt]
										,	[ServiceAmt]
										,	[RetailAmt]
										,	[ClientServicedCnt]
										,	[NetMembershipAmt]
										,	[S_GrossSurCnt]
										,	[S_SurCnt]
										,	[S_SurAmt]

										, [IsException]
										, [IsDelete]
										, [IsDuplicate]
										, [SourceSystemKey]
										)
							SELECT @DataPkgKey
										, 0 AS [OrderDateKey]
										--Converting OrderDate to UTC
										--, chg.[OrderDate] AS [OrderDate]
										,[bief_stage].[fn_GetUTCDateTime](chg.[OrderDate], chg.[CenterID])
										, 0 AS [SalesOrderKey]
										, chg.[SalesOrderGUID] AS [SalesOrderSSID]
										, 0 AS [SalesOrderDetailKey]
										, sod.[SalesOrderDetailGUID] AS [SalesOrderDetailSSID]
										, 0 AS [SalesOrderTypeKey]
										, COALESCE(chg.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
										, 0 AS [CenterKey]
										, COALESCE(chg.[CenterID],-2) AS [CenterSSID]
										, 0 AS [ClientKey]
										, chg.[ClientGUID] AS [ClientSSID]
										, 0 AS [MembershipKey]
										, 0 AS [ClientMembershipKey]
										, CASE WHEN chg.CENTERID LIKE '[1278]%' THEN
													ISNULL(sod.[PreviousClientMembershipGUID],chg.[ClientMembershipGUID])
												ELSE
													chg.[ClientMembershipGUID]
												END AS [ClientMembershipSSID]
										, 0 AS [SalesCodeKey]
										, COALESCE(sod.[SalesCodeID],-2) AS [SalesCodeSSID]
										, 0 AS [Employee1Key]
										,COALESCE( sod.[Employee1GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee1SSID]
										, 0 AS [Employee2Key]
										, COALESCE(sod.[Employee2GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee2SSID]
										, 0 AS [Employee3Key]
										, COALESCE(sod.[Employee3GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee3SSID]
										, 0 AS [Employee4Key]
										, COALESCE(sod.[Employee4GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee4SSID]
										, COALESCE(sod.[Quantity],0) AS [Quantity]
										, COALESCE(sod.[Price],0) AS [Price]
										, COALESCE(sod.[Discount],0) AS [Discount]
										, COALESCE(sod.[Tax1],0) AS [Tax1]
										, COALESCE(sod.[Tax2],0) AS [Tax2]
										, COALESCE(sod.[TaxRate1],0) AS [TaxRate1]
										, COALESCE(sod.[TaxRate2],0) AS [TaxRate2]
										, CAST(chg.IsClosedFlag AS TINYINT) AS [IsClosed]
										, CAST(chg.IsVoidedFlag AS TINYINT) AS [IsVoided]


										------------------------------------------------------------------------------------------
										--GET Contact Information
										------------------------------------------------------------------------------------------
										, dc.ContactKey as [ContactKey]
										, fl.SourceKey as [SourceKey]
										, fl.GenderKey as [GenderKey]
										, fl.OccupationKey as [OccupationKey]
										, fl.EthnicityKey as [EthnicityKey]
										, fl.MaritalStatusKey as [MaritalStatusKey]
										, fl.HairLossTypeKey as [HairLossTypeKey]
										, fl.AgeRangeKey as [AgeRangeKey]
										, fl.PromotionCodeKey as [PromotionCodeKey]

										------------------------------------------------------------------------------------------
										--GET FIRST AND ADDITIONAL SURGERY INFORMATION
										------------------------------------------------------------------------------------------
									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
											  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
												ELSE 0
											END AS 'S1_SaleCnt'

									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
											  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
												ELSE 0
											END  AS 'S_CancelCnt'
									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
											  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
											 ELSE 0
											END
											-
   											CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
													  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
												 ELSE 0
											END  AS 'S1_NetSalesCnt'


									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 ) -- Membership Revenue (MRRevenue)
													  AND dm.[MembershipSSID] = 43 THEN sod.[ExtendedPriceCalc] -- First Surgery (1stSURG)
												 ELSE 0
											END AS 'S1_NetSalesAmt'

									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
													  AND dm.[MembershipSSID] = 43 THEN daa.[MoneyChange]
												 ELSE 0
											END AS 'S1_ContractAmountAmt'

									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
													  AND dm.[MembershipSSID] = 43 THEN daa.[QuantityTotalChange]
												 ELSE 0
											END AS 'S1_EstGraftsCnt'

									  ,		[bief_stage].[fn_DivideByZeroCheck]
											(
											CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43
												THEN daa.[MoneyChange] ELSE 0 END,
											CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43
												THEN daa.[QuantityTotalChange] ELSE 0
												END) AS 'S1_EstPerGraftsAmt'

									  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
													  AND dm.[MembershipSSID] = 44 THEN 1
												 ELSE 0
											END
											-
											CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )  -- Cancellations (MMCancel)
													  AND dm.[MembershipSSID] = 44 THEN 1
												 ELSE 0
											END AS 'SA_NetSalesCnt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 )  -- Membership Revenue (MRRevenue)
													  AND dm.[MembershipSSID] = 44 THEN sod.[ExtendedPriceCalc]
												 ELSE 0
											END AS 'SA_NetSalesAmt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075, 1030, 1040, 1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
													  AND dm.[MembershipSSID] = 44 THEN daa.[MoneyChange]
												 ELSE 0
											END AS 'SA_ContractAmountAmt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
													  AND dm.[MembershipSSID] = 44 THEN daa.[QuantityTotalChange]
												 ELSE 0
											END AS 'SA_EstGraftsCnt'

									   ,	[bief_stage].[fn_DivideByZeroCheck]
												(
												CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44
													THEN daa.[MoneyChange] ELSE 0 END,
												CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44
													THEN daa.[QuantityTotalChange] ELSE 0
												END) AS 'SA_EstPerGraftAmt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN sod.[Quantity]   --  Post Extreme (MRPostExt)
												 ELSE 0
											END AS 'S_PostExtCnt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN sod.[ExtendedPriceCalc]
												 ELSE 0
											END AS 'S_PostExtAmt'

										------------------------------------------------------------------------------------------
										--GET TOTAL SURGERIES PERFORMED DATA
										------------------------------------------------------------------------------------------
									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN 1  -- Surgery (SVSurg)
												 ELSE 0
											END AS 'S_SurgeryPerformedCnt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN dcm.ClientMembershipContractPrice  -- Surgery (SVSurg)
												 ELSE 0
											END AS 'S_SurgeryPerformedAmt'

									   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN sod.[Quantity]  -- Surgery (SVSurg)
												 ELSE 0
												END AS 'S_SurgeryGraftsCnt'
										,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN sod.[Quantity]  -- Deposit Count
												ELSE 0
												END AS 'S1_DepositsTakenCnt'
										,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN sod.[ExtendedPriceCalc]  --Deposits Amt
												ELSE 0
												END AS 'S1_DepositsTakenAmt'
										------------------------------------------------------------------------------------------
										--GET NON SURGERY DATA
										------------------------------------------------------------------------------------------
										,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010) and dm.BusinessSegmentSSID <> 3
													THEN sod.Quantity
												ELSE
													(CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010) and dm.BusinessSegmentSSID = 3  THEN 1
															ELSE 0 END )
												END AS 'NB_GrossNB1Cnt'
										,	(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010) AND dm.MembershipDescriptionShort IN ('TRADITION')
													THEN sod.Quantity
												ELSE 0
												END
												-
  												CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099) AND prevmem.MembershipDescriptionShort IN ('TRADITION')
													THEN sod.Quantity
												ELSE 0
												END) AS 'NB_TradCnt'
										,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020)
															AND dm.RevenueGroupSSID = 1)			--RevGrp (NewBus)
															AND dm.BusinessSegmentSSID = 1					--BusSeg (BIO)
															AND dm.MembershipDescriptionShort IN ('TRADITION'))
														OR
															(dsc.salescodedescriptionshort IN ('NB1REVWO', 'EXTREVWO', 'SURCREDITPCP','SURCREDITNB1')
															AND dm.MembershipDescriptionShort NOT IN ('EXT6','EXT12','EXTENH6','EXTENH12',
																			'EXTMEM','EXTMEMSOL', 'GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
																			'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL'))
												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'NB_TradAmt'
										,	(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
															AND dm.MembershipDescriptionShort
																IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
												THEN sod.quantity
												ELSE 0
												END
												-
												CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
															AND prevmem.MembershipDescriptionShort
																	IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
																		'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
												THEN sod.quantity
												ELSE 0
												END) AS 'NB_GradCnt'
										,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020) OR (dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))
															AND dm.MembershipDescriptionShort
																IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
																	'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
															AND
																dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO'))
												THEN
													sod.ExtendedPriceCalc
												ELSE 0
												END AS 'NB_GradAmt'
										,	(		CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
														AND dm.RevenueGroupSSID = 1 --RevGrp (NewBus)
														AND dm.BusinessSegmentSSID = 2 --BusSeg (EXT)
													THEN sod.Quantity
													ELSE 0
													END
													-
													CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
														AND prevmem.RevenueGroupSSID = 1 --RevGrp (NewBus)
														AND prevmem.BusinessSegmentSSID = 2 --BusSeg (EXT)
													THEN sod.Quantity
													ELSE 0 END) AS 'NB_ExtCnt'
										,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020) OR (dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))
														AND dm.MembershipDescriptionShort IN ('EXT6','EXT12','EXTENH6','EXTENH12')
														AND dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT'))
												THEN
														sod.ExtendedPriceCalc
												ELSE 0
												END AS 'NB_ExtAmt'
										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010)
												THEN sod.Quantity
												ELSE 0
												END AS 'NB_AppsCnt'

										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
													AND prevmem.BusinessSegmentSSID not in (2,3)
												THEN sod.Quantity
												ELSE 0
												END AS 'NB_BIOConvCnt'

										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
													AND prevmem.BusinessSegmentSSID = 2
												THEN sod.Quantity
												ELSE 0
												END AS 'NB_EXTConvCnt'
										,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
															AND dm.BusinessSegmentSSID = 1 and dm.RevenueGroupSSID IN (2,3)
															AND dm.MembershipDescriptionShort NOT IN ('MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT',
																			'EXT6','EXT12','EXTENH6','EXTENH12')
															AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
														OR
															(dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
															AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
														OR
															(dsc.SalesCodeDepartmentSSID IN (2020) and
															 dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL'))
														OR
															(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE'))
																--OR
																	--(dm.MembershipDescriptionShort IN ('EXT')
																	--AND SC.SalesCodeDescriptionShort NOT IN ('EFTFEE'))

												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'PCP_NB2Amt'

										,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020)
															AND dm.BusinessSegmentSSID = 1 AND dm.RevenueGroupSSID = 2
															AND dm.MembershipDescriptionShort NOT IN ('NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT',
																'EXT6','EXT12','EXTENH6','EXTENH12')
															AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
														OR
															(dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
																AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
														OR
															(dm.MembershipDescriptionShort IN ('NONPGM')
																AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT'))
														OR
															(dsc.SalesCodeDepartmentSSID IN (2020)
																AND dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL'))
														OR
															(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE')
																AND dm.MembershipDescriptionShort NOT IN ('NONPGM')))

												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'PCP_PCPAmt'

										,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
														AND dm.BusinessSegmentSSID = 1 AND dm.RevenueGroupSSID = 2
														AND dm.MembershipDescriptionShort NOT IN ('NONPGM')
														AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
													OR
														(dm.BusinessSegmentSSID = 1
														AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT','PCPREVWO'))
												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'PCP_BioAmt'

										,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
														AND dm.BusinessSegmentSSID = 2 AND dm.RevenueGroupSSID = 2)
													OR
														(dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
														AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'PCP_ExtMemAmt'

										,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
														AND dm.MembershipDescriptionShort IN ('NONPGM','RETAIL','HCFK')
														AND dsc.SalesCodeDescriptionShort NOT IN ('PCPMBRPMT','EFTFEE'))
												THEN sod.ExtendedPriceCalc
												ELSE 0
												END AS 'PCPNonPgmAmt'

										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010,5020,5030,5040,5050)
														AND dm.BusinessSegmentSSID IN (1,2,4)
													THEN sod.ExtendedPriceCalc
													ELSE 0
													END AS 'ServiceAmt'

										,	CASE WHEN dscd.SalesCodeDivisionSSID = 30
														AND dm.BusinessSegmentSSID IN (1,2,4)
													THEN sod.ExtendedPriceCalc
													ELSE 0
													END AS 'RetailAmt'

										,	CASE WHEN
												CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010, 5020, 5030, 5040)
														AND dm.BusinessSegmentSSID IN (1,2,4)
													THEN sod.Quantity
													ELSE 0
													END > 0
												THEN 1
												ELSE 0
												END AS 'ClientServicedCnt'

										,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020))
													THEN sod.ExtendedPriceCalc
													ELSE 0
													END AS 'NetMembershipAmt'
										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010, 1075, 1090, 2025)
															and dm.BusinessSegmentSSID = 3
															AND sod.IsRefundedFlag = 0
													THEN 1
													ELSE 0
													END AS 'S_GrossSurCnt'

										,	CASE WHEN dsc.SalesCodeDescriptionShort IN ('INITASG','CONV','RENEW')
															AND dm.BusinessSegmentSSID = 3
															AND daa.AccumulatorKey = 37
													THEN 1
													ELSE
														(CASE WHEN dsc.SalesCodeDepartmentssID IN (1099)
															AND dm.BusinessSegmentSSID = 3
															AND daa.AccumulatorKey = 37
													THEN -1
													ELSE 0
													END) END AS 'S_SurCnt'

										,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (2020)
															AND dm.BusinessSegmentSSID = 3
													THEN ExtendedPriceCalc
													ELSE 0
													END AS 'S_SurAmt'

										, 0 AS [IsException]
										, 0 AS [IsDelete]
										, 0 AS [IsDuplicate]
										, CAST(ISNULL(LTRIM(RTRIM(sod.[SalesOrderDetailGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
							FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrder](@From_LSN, @To_LSN, @row_filter_option) chg
									INNER JOIN	  [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod
											  ON chg.[SalesOrderGUID] = sod.[SalesOrderGUID]
									INNER JOIN bi_cms_stage.synHC_DDS_DimSalesCode	dsc
										ON sod.SalesCodeID = dsc.SalesCodeSSID
									INNER JOIN bi_cms_stage.synHC_DDS_DimClientMembership dcm
										ON chg.ClientMembershipGUID = dcm.ClientMembershipSSID
									INNER JOIN bi_cms_stage.synHC_DDS_DimMembership dm
										ON dcm.MembershipSSID = dm.MembershipSSID
									LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimAccumulatorAdjustment daa
										ON sod.SalesOrderDetailGUID = daa.SalesOrderDetailSSID
									LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimClientMembership prevdcm
										ON sod.[PreviousClientMembershipGUID] = prevdcm.[ClientMembershipSSID]
										and sod.PreviousClientMembershipGUID <> '00000000-0000-0000-0000-000000000002'
									LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimMembership prevmem
										ON prevdcm.MembershipSSID = prevmem.MembershipSSID
									LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimSalesCodeDepartment dscd
										ON dsc.SalesCodeDepartmentKey = dscd.SalesCodeDepartmentKey
									INNER JOIN 	[bi_cms_stage].[synHC_SRC_TBL_CMS_datClient] cl
										ON chg.ClientGUID = CL.ClientGUID
									LEFT OUTER JOIN [bi_cms_stage].[DimClientLeadJoin] clj
										ON chg.ClientGUID = clj.ClientSSID
									LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].DimContact dc
										ON ISNULL(cl.ContactID, clj.contactSSID) = dc.ContactSSID
									LEFT OUTER JOIN [HC_BI_MKTG_DDS].bi_mktg_dds.FactLead fl
										ON dc.ContactKey = fl.ContactKey
							WHERE (chg.IsClosedFlag = 1 AND  chg.IsVoidedFlag = 0)

							SET @ExtractRowCnt = @@ROWCOUNT

							-- Set the Last Successful Extraction Time & Status
							UPDATE [bief_stage].[_DataFlow]
								SET LSET = @CET
									, [Status] = 'Extraction Completed'
								WHERE [TableName] = @TableName

					END
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
