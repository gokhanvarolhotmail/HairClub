/* CreateDate: 05/03/2010 12:20:23.183 , ModifyDate: 05/17/2021 08:18:00.230 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransaction_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/19/2009  RLifke       Initial Creation
--			07/14/2011	KMurdoch	 Removed logic for IsClosed or IsVoided
--			03/07/2012	KMurdoch	 Added Isnull statement for ClientMembershipGUID
--			05/23/2012  KMurdoch/MBurrell Added Contact & Flash data
--			08/11/2012	Kmurdoch	 Modified Accumulator join
--			09/27/2012	MBurrell	 Added reference to new EXTENH9 program where applicable
--			10/01/2012  KMurdoch	 Modified SurCxl & S_SurCt calcs
--			10/02/2012  MBurrell	 Modified GrossNB1 counts to include PostEXT and Additional Surgery
--			10/18/2012  KMurdoch	 Modified GrossNB1 counts to not include POSTEXT Refunds
--			11/27/2012  KMurdoch	 Modified DCM to derive from datClientMembership
--          01/03/2013  EKnapp		 Add sales order detail lastupdate and createdate to where clause. Use UTC time for CET in where clause.
--			01/22/2013  KMurdoch     Add AccountID to FST table
--			02/22/2013  KMurdoch     Modified EXT to exclude PostEXT (HS) from EXT Counts
--			02/22/2013  KMurdoch	 Modified Gross numbers not to include ShowSale & ShowNoSale
--			04/18/2013  KMurdoch	 Changed Trad/Grad/Ext counts to handle new system
--			05/08/2013  KMurdoch	 Added in exclusion of SNSSURGOFF
--			05/13/2013  KMurdoch	 Modified extract to bring in PostEXT transactions
--			05/31/2013  KMurdoch	 Modified extract to correct PostEXT trx by date
--			06/06/2013  KMurdoch     Modified extract to properly handle membership counts for guarantees
--			06/10/2013	MBurrell	 Changed previous membership so that it ignores the "New Client" memberships and gets the current instead
--			06/13/2013  KMurdoch	 Added in Retail and Cancel to calculation of membership above
--			06/20/2013  KMurdoch     Modified PostEXT Write-offs to go to POSTEXT rather than NB1
--			07/11/2013  KMurdoch	 Added exclusion of RETAIL memberships from Gross Number
--          07/24/2013  EKnapp       Added Nolock hint on remainder of joins and removed check for LIKE '[1278]%' in Case statement.
--			09/05/2013  KMurdoch	 Modified prevmem to exclude add membership from one business segment to another
--			09/25/2013  DLeiba		 Added Upgrades, Downgrades & Removals
--			04/29/2014	DLeiba		 Removed the following memberships from the Net Gross # calculation ('HCFK','NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT')
--			05/10/2014	DLeiba		 Excluded POSTEXTPMT from the Net Gross # calculation
--			06/03/2014	RHut		 Added NB_XtrCnt and NB_XtrAmt for Xtrands membership
--			10/06/2014	RHut		 Added 5037 where the SalesCodeDepartmentSSID = 5035
--			10/21/2014  KMurdoch	 Added Xtrand6 to the XtrandCt and XtrandAmt
--			11/19/2014	KMurdoch	 Added XtrConv
--			12/15/2014	RHut 	     Added PCP_XtrAmt - NOT YET using new BusinessSegment for Xtrands - exclude it from PCP_BioAmt
--			01/16/2015	RHut		 Added 'SAPHOH','SAPHOHP' and SalesCodeDepartmentSSID = 7035 ('Hair Systems (ala carte)','HSALAC') to NONPGM
--			02/03/2015  KMurdoch	 Added business segment 6 - Xtrands to Extract
--			02/12/2015  RHut		 Changed code for PCP_PCPAmt to limit Xtrands revenue to where dsc.SalesCodeDepartmentSSID IN (2020)
--			03/02/2015  KMurdoch	 Modified extract to handle Xtrands converting between business segments
--			03/12/2015	RHut		 Added BusinessSegmentSSID = 6 for Xtrands to RetailAmt, ServiceAmt and ClientServicedCnt
--			04/20/2015  KMurdoch	 Fixed Cancel portion of Guarantee trx
--			07/01/2015  RHut		 (WO#116260) Changed logic for finding Conversions
--			07/21/2015  KMurdoch	 Added EXTINITIAL and EXTPREMMEN, EXTPREMWOM
--			10/08/2015	RHut		 Changed how S_PostEXTCnt cancels are set from THEN sod.[Quantity] to THEN 1
--			11/04/2015  KMurdoch     Added Membership Promotion
--			04/26/2016  KMurdoch     Added XTDMEM1000, XTDMSO1000 to PCP XTR
--			06/03/2016  RHut		 Added Xtrands12 to the list for NB_XtrCnt and NB_XtrAmt (#126842)
--          02/15/2017  KMurdoch     Added NetSalesAmt
--			05/01/2017  KMurdoch     Added Add-on Logic to PostEXT
--			09/20/2017	RHut		 Added dsc.SalesCodeDescriptionShort <> 'CANCELADDON' to S_SurCnt Cancel code (#142858)
--			06/14/2018	KMurdoch	 Added HW memberships to Trad/Grad
--			06/15/2018  RHut		 Added HW EXT NB, HW EXT RB, Added First Surgery - S1 and Additional - SA for Hans Wiemann
--			07/16/2018	KMurdoch	 Added LaserCnt & LaserAmt
--			07/26/2018  RHut		 Added SalesCodeDepartmentSSID IN(5062) AND dm.BusinessSegmentSSID IN (1,2,3,4,5,6) Micro Dermal Pigmentation to 'ServiceAmt'
--			08/13/2018  RHut		 Changed code for Xtrands to use RevenueGroupID and BusinessSegmentID instead of MembershipDescriptionShort in order to include ALL NB Xtrands memberships (CaseID 313)
--			09/27/2018  RHut		 Added code for new memberships GRAD12 and GRADSOL12
--			12/03/2018	KMurdoch     Added MDP Cnt & Amt
--			12/20/2018	RHut		 Added 'HMEDADDON','HMEDADDON3'to the S_PRPCnt (per Kevin and Rev)	-Med Add-on PRP, Med Add-on PRP 3 Pack (PRP is also included in PostEXT)
--			02/08/2019  KMurdoch	 Added POSTEXTPMTUS to extract query where appropriate
--			03/06/2019  KMurdoch     Fixed Laser count to include PMTs in Department 2020
--			03/18/2019  KMurdoch	 Added Breakdown of Laser between New & Recurring Memberships
--			06/06/2019  KMurdoch     Removed Laser from Retail in Fact Transaction
--		    06/13/2019  KMurdoch     Added MDP business segment to retail & service revenue
--			06/24/2019	DLeiba		 Removed Employee memberships from RetailAmt column and NB_LaserCnt, NB_LaserAmt, PCP_LaserCnt, PCP_LaserAmt columns
--			06/26/2019	DLeiba		 Added new columns for Employee RetailAmt, NB_LaserCnt, NB_LaserAmt, PCP_LaserCnt and PCP_LaserAmt columns
--			07/08/2019	RHut		 Added 'GRDSVEZ' Xtrands+ Initial 6 EZPAY
--			07/18/2019	DLeiba		 Changed the S_PostExtCnt code to look for department 1060 and sales code CANCELADDON as well as the Surgery business segment
--			08/02/2019	DLeiba		 Changed logic for Xtrands+ Initial 6 EZPAY. EFTFEE transactions were incorrectly being classified as PCP_PCPAmt, PCP_NB2Amt and not being counted as NB_GradAmt
--			09/18/2019  KMurdoch     Changed Membership REvenue to refer to Division 20 rather than department 2020
--			01/30/2020  RHut		 Added code to remove cancelled NB_MDPCnt
--			03/09/2020  RHut		 Changed code to populate S_PostEXTCnt and S_PostEXTAmt to remove S_PRPCnt and S_PRPAmt
--			04/30/2020	KMurdoch	 Added Laser82 to New Business EXT; Added HWANAGENRR to Recurring Revenue EXT; Micropoint handled by BizSeg & RevGrp
--			05/26/2020  KMurdoch	 Added new NW memberships into proper areas
--			06/01/2020	KMurdoch	 Added new Surgeries for Canada; added Restorink to Retail computation
--			07/27/2020  KMurdoch     Changed join to be on SalesforceID
--			08/07/2020  KMurdoch     Added EXTFlex & EXTFlexSol
--			08/12/2020  KMurdoch     Added Surgery for HW HT & AHT
--			08/17/2020  KMurdoch     Fixed Bosley SMP to show with Restorink; Fixed PRP to not be included in S1 & SA Surgery $
--			05/17/2021  KMurdoch     Added EXT 18 to query
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'


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


/***************************************Code to determine if the sales order is the latest Medical Add-On Order *********************************************/

IF OBJECT_ID('tempdb..#MEDADDON') IS NOT NULL
   DROP TABLE #MEDADDON



SELECT	ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier,sc.SalesCodeDescriptionShort ORDER BY so.OrderDate DESC) AS 'Ranking'
,		so.SalesOrderGUID
,		sod.SalesOrderDetailGUID
,		so.InvoiceNumber
,		clt.ClientIdentifier
,		clt.ClientFullNameAltCalc
,		m.MembershipDescription
,		cms.ClientMembershipStatusDescription
,		so.OrderDate
,		sc.SalesCodeDescriptionShort
,		sc.SalesCodeDescription
,		sod.ExtendedPriceCalc
INTO #MEDADDON
FROM	HairClubCMS.dbo.datSalesOrderDetail sod
		INNER JOIN HairClubCMS.dbo.datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr
			ON ctr.CenterID = so.CenterID
		INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
			ON tz.TimeZoneID = ctr.TimeZoneID
		INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientGUID = so.ClientGUID
		INNER JOIN HairClubCMS.dbo.datClientMembership cm
			ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
		INNER JOIN HairClubCMS.dbo.cfgMembership m
			ON m.MembershipID = cm.MembershipID
WHERE	(sc.[SalesCodeDescriptionShort] IN ( 'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3')OR sc.SalesCodeID IN(912,913,1653,1654,1655,1656,1661,1662,1664,1665) 	--Add-on Salescodes in Dept 2025 5/1/2017 km
				AND m.membershipid in ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
		OR(sc.[SalesCodeDepartmentID] IN ( 1060 )
															AND sc.[SalesCodeDescriptionShort] = 'CANCELADDON'
															AND m.BusinessSegmentID = 3)
		AND so.IsVoidedFlag = 0


/*
***************************************Code to determine if the sales order is the first MDP order**********************************************


*/
IF OBJECT_ID('tempdb..#Service') IS NOT NULL
   DROP TABLE #Service


SELECT	ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier ORDER BY so.OrderDate ) AS 'RowID'
,		so.SalesOrderGUID
,		sod.SalesOrderDetailGUID
,		so.InvoiceNumber
,		clt.ClientIdentifier
,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullNameAlt2Calc AS 'ClientName'
,		m.MembershipDescription AS 'Membership'
,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
,		HairClubCMS.dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'OrderDate'
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription AS 'Description'
,		sod.ExtendedPriceCalc AS 'Price'
INTO	#Service
FROM	HairClubCMS.dbo.datSalesOrderDetail sod
		INNER JOIN HairClubCMS.dbo.datSalesOrder so
			ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr
			ON ctr.CenterID = so.CenterID
		INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
			ON tz.TimeZoneID = ctr.TimeZoneID
		INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientGUID = so.ClientGUID
		INNER JOIN HairClubCMS.dbo.datClientMembership cm
			ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
		INNER JOIN HairClubCMS.dbo.cfgMembership m
			ON m.MembershipID = cm.MembershipID
WHERE	sc.SalesCodeDepartmentID = 5062
		AND sc.SalesCodeDescriptionShort NOT IN ( 'SVCSMP', 'ADDONMDP' )
		AND so.IsVoidedFlag = 0


/*----------------------------------------------------------------------------------------------------------------------------------------*/


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
							,   [NB_XTRConvCnt]
							,	[NB_RemCnt]
							,	[PCP_NB2Amt]
							,	[PCP_PCPAmt]
							,	[PCP_BioAmt]
							,	[PCP_XtrAmt] --Added RH 12/15/2014
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
							,   [LaserCnt]
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

							, [IsException]
							, [IsDelete]
							, [IsDuplicate]
							, [SourceSystemKey]

							)

					SELECT	  @DataPkgKey
							, 0 AS [OrderDateKey]
							--Converting OrderDate to UTC
							--, so.[OrderDate] AS [OrderDate]
							,[bief_stage].[fn_GetUTCDateTime](so.[OrderDate], so.[CenterID])
							, 0 AS [SalesOrderKey]
							, so.[SalesOrderGUID] AS [SalesOrderSSID]
							, 0 AS [SalesOrderDetailKey]
							, sod.[SalesOrderDetailGUID] AS [SalesOrderDetailSSID]
							, 0 AS [SalesOrderTypeKey]
							, COALESCE(so.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
							, 0 AS [CenterKey]
							, COALESCE(so.[CenterID],-2) AS [CenterSSID]
							, 0 AS [ClientKey]
							, so.[ClientGUID] AS [ClientSSID]
							, 0 AS [MembershipKey]
							, 0 AS [ClientMembershipKey]
							, CASE WHEN so.CENTERID LIKE '[1278]%'
								THEN
									CASE WHEN prevmem.MembershipSSID IN (42, 57, 58, 11, 14)
										OR (prevmem.businesssegmentssid IS NOT NULL
											AND prevmem.businesssegmentssid <> dm.businesssegmentssid
											AND dm.MembershipSSID NOT IN (71,76))
									THEN so.[ClientMembershipGUID]
									ELSE ISNULL(sod.[PreviousClientMembershipGUID], so.[ClientMembershipGUID]) END
								ELSE so.[ClientMembershipGUID]
								END AS [ClientMembershipSSID]
							--, so.[ClientMembershipGUID]  AS [ClientMembershipSSID]
							, 0 AS [SalesCodeKey]
							, COALESCE(sod.[SalesCodeID],-2) AS [SalesCodeSSID]
							, 0 AS [Employee1Key]
							, COALESCE( sod.[Employee1GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee1SSID]
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
							, CAST(so.IsClosedFlag AS TINYINT) AS [IsClosed]
							, CAST(so.IsVoidedFlag AS TINYINT) AS [IsVoided]
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
							--GET GL AccountID
							------------------------------------------------------------------------------------------
							, CASE	WHEN dm.BusinessSegmentSSID = 2 then glext.GeneralLedgerDescriptionShort
									WHEN dm.BusinessSegmentSSID = 3 then glsur.GeneralLedgerDescriptionShort
										ELSE glbio.GeneralLedgerDescriptionShort
							  END AS 'AccountID'
							------------------------------------------------------------------------------------------
							--GET FIRST AND ADDITIONAL SURGERY INFORMATION
							------------------------------------------------------------------------------------------
						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
								  AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316) THEN 1  ---- First Surgery (1stSURG)
									ELSE 0
								END AS 'S1_SaleCnt'

						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
								  AND dm.[MembershipSSID] in (43,259,260,261,262,263,264, 44,265,266,267,268,269,270,316,317) THEN 1 ---- First Surgery (1stSURG)
									ELSE 0
								END  AS 'S_CancelCnt'
						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
								  AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316) THEN 1  ---- First Surgery (1stSURG)
								 ELSE 0
								END
								-
   								CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
										  AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316)
										  THEN 1 ---- First Surgery (1stSURG)
									 ELSE 0
								END  AS 'S1_NetSalesCnt'


						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 ) -- Membership Revenue (MRRevenue)
										  AND dm.[MembershipSSID] IN (58,43,259,260,261,262,263,264,316)
										  AND sc.SalesCodeID NOt IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)   --Removing PRP from Addtl Surgery Amount
											THEN sod.[ExtendedPriceCalc] -- First Surgery (1stSURG)
									 ELSE 0
								END AS 'S1_NetSalesAmt'

						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
										  AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316) THEN daa1.[MoneyChange]
									 ELSE 0
								END AS 'S1_ContractAmountAmt'

						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
										  AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316) THEN daa12.[QuantityTotalChange]
									 ELSE 0
								END AS 'S1_EstGraftsCnt'

						  ,		CASE WHEN daa30.[moneyAdjustment] <> 0
										AND dm.[MembershipSSID] IN(43,259,260,261,262,263,264,316) THEN daa30.[moneyAdjustment]
									  ELSE 0
								END AS 'S1_EstPerGraftsAmt'

						  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
										  AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317) THEN 1
									 ELSE 0
								END
								-
								CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )  -- Cancellations (MMCancel)
										  AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317) THEN 1
									 ELSE 0
								END AS 'SA_NetSalesCnt'

						   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 )  -- Membership Revenue (MRRevenue)
										  AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317)
										  AND sc.SalesCodeID NOt IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665) --Removing PRP from Addtl Surgery Amount
											THEN sod.[ExtendedPriceCalc]
									 ELSE 0
								END AS 'SA_NetSalesAmt'

							,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075, 1030, 1040, 1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
											AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317) THEN daa1.[MoneyChange]
										ELSE 0
								END AS 'SA_ContractAmountAmt'

							,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
											AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317) THEN daa12.[QuantityTotalChange]
										ELSE 0
								END AS 'SA_EstGraftsCnt'

							,	CASE WHEN daa30.[moneyAdjustment] <> 0
										AND dm.[MembershipSSID] IN(44,265,266,267,268,269,270,317) THEN daa30.[moneyAdjustment]
										ELSE 0
								END AS 'SA_EstPerGraftAmt'

						   ,
								CASE	WHEN so.OrderDate < '05/10/2013' THEN
										CASE	WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 )
										--AND dm.BusinessSegmentSSID in ( 2,3 )
												THEN sod.[Quantity]   --  Post Extreme (MRPostExt)
													ELSE 0
												END

										WHEN so.OrderDate >= '05/10/2013' THEN
										CASE	WHEN CC.CenterBusinessTypeID = 1 THEN
												CASE	WHEN (dsc.[SalesCodeDepartmentSSID] IN ( 2025 )
															AND dm.BusinessSegmentSSID in ( 2,3 )
															AND dsc.SalesCodeSSID NOT IN(917,918,1230,1231) )		--'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3'
														THEN sod.[Quantity]   --  Post Extreme (MRPostExt)
															ELSE 0
														END
												WHEN CC.CenterBusinessTypeID IN (2,3) THEN
												CASE	WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010,1015 )
															AND dm.membershipssid = 13
																THEN sod.[Quantity]
														--WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1006 )			--Additional Medical Services
														--		THEN 1
															ELSE 0
														END
												-
												CASE	WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )
															AND dm.membershipssid = 13
																THEN 1
																ELSE 0
														END
												END
										END

								AS 'S_PostExtCnt'

						   ,	CASE WHEN (dsc.[SalesCodeDepartmentSSID] IN ( 2025 )								--Add-on Salescodes in Dept 2025 5/1/2017 km
												AND dm.BusinessSegmentSSID in ( 2,3 )
												AND dsc.[SalesCodeDescriptionShort] NOT IN ( 'BOSMEMADJTG','BOSMEMADJTGBPS','MEDADDONPMTTRI' ) )
										OR
											(dsc.salescodedepartmentssid IN (2020)
												AND dm.membershipSSID = 13)
										OR
											(dsc.salescodedescriptionshort IN ('NB1REVWO', 'EXTREVWO')
											AND dm.MembershipDescriptionShort IN ('POSTEXT'))

										THEN sod.[ExtendedPriceCalc]
									 ELSE 0
								END AS 'S_PostExtAmt'

							,	CASE WHEN (#MEDADDON.SalesOrderDetailGUID IS NOT NULL AND dsc.[SalesCodeDescriptionShort] IN ( 'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3')	--Add-on Salescodes in Dept 2025 5/1/2017 km
												AND dm.membershipssid in ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
										THEN 1
									 ELSE 0
								END
								- CASE WHEN (#MEDADDON.SalesOrderDetailGUID IS NOT NULL AND dsc.[SalesCodeDepartmentSSID] IN ( 1060 )
															AND dsc.[SalesCodeDescriptionShort] = 'CANCELADDON'
															AND dm.BusinessSegmentSSID = 3) --Surgery
																THEN 1
															ELSE 0
											END
									AS 'S_PRPCnt'

							,	CASE WHEN (sc.SalesCodeID IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
												AND dm.membershipssid in ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
										THEN sod.[ExtendedPriceCalc]
									 ELSE 0
								END AS 'S_PRPAmt'

							------------------------------------------------------------------------------------------
							--GET TOTAL SURGERIES PERFORMED DATA
							------------------------------------------------------------------------------------------
						   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN 1  -- Surgery (SVSurg)
									 ELSE 0
								END AS 'S_SurgeryPerformedCnt'

						   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN dcm.ContractPrice  -- Surgery (SVSurg)
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
							--,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010)
							--			and dm.BusinessSegmentSSID <> 3
							--			and dm.RevenueGroupSSID = 1
							--			and dm.MembershipDescriptionShort NOT IN ('SHOWSALE','SHOWNOSALE','SNSSURGOFF','RETAIL','HCFK','NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT')
							--			THEN sod.Quantity
							--		ELSE
							--			(CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010, 2025, 1075, 1090)
							--				and dsc.SalesCodeDescriptionShort NOT IN ( 'POSTEXTPMT' )
							--				and dm.MembershipDescriptionShort NOT IN ('SHOWSALE','SHOWNOSALE','SNSSURGOFF', 'RETAIL')
							--				and dm.BusinessSegmentSSID = 3
							--				and sod.quantity > 0 THEN 1
							--					ELSE 0 END )
							--		END AS 'NB_GrossNB1Cnt' -- OLD NB_GrossNB1Cnt Statement - Removed on 1/29/2019 - DSL

							,		ISNULL(( CASE WHEN DSC.SalesCodeDepartmentSSID IN ( 1010 )
												AND DM.BusinessSegmentSSID <> 3
												AND DM.RevenueGroupSSID = 1
												AND DM.MembershipDescriptionShort NOT IN ( 'SHOWSALE', 'SHOWNOSALE', 'SNSSURGOFF', 'RETAIL', 'HCFK', 'NONPGM', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT','EMPLOYEE6' )
												THEN SOD.Quantity
											 ELSE ( CASE WHEN DSC.SalesCodeDepartmentSSID IN ( 1010, 2025, 1075, 1090 )
														AND DSC.SalesCodeDescriptionShort NOT IN ( 'POSTEXTPMT','POSTEXTPMTUS' )
														AND DM.MembershipDescriptionShort NOT IN ( 'SHOWSALE', 'SHOWNOSALE', 'SNSSURGOFF', 'RETAIL' )
														AND DM.BusinessSegmentSSID = 3
														AND SOD.Quantity > 0 THEN 1
													ELSE 0
													END )
											 END ), 0)
											 + ISNULL(( CASE WHEN #Service.SalesOrderDetailGUID IS NOT NULL THEN 1 ELSE 0 END ), 0) AS 'NB_GrossNB1Cnt'

							,	CASE WHEN so.IsGuaranteeFlag = 1 then
								(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
										AND dm.MembershipDescriptionShort IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
										THEN 1
									ELSE 0
									END
									-
  									CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
										AND (dm.MembershipDescriptionShort IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO'))
										THEN 1
									ELSE 0
									END)
								ELSE
								(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010) AND dm.MembershipDescriptionShort IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
										THEN 1
									ELSE 0
									END
									-
  									CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099) AND (prevmem.MembershipDescriptionShort IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO') or
																							dm.MembershipDescriptionShort in ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO'))
										THEN 1
									ELSE 0
									END)
								END
									AS 'NB_TradCnt'
							,	CASE WHEN (
											( dsc.SalesCodeDepartmentSSID IN (2020) AND dm.RevenueGroupSSID = 1 ) --RevGrp (NewBus)
											AND dm.BusinessSegmentSSID = 1 --BusSeg (BIO)
											AND dm.MembershipDescriptionShort IN ( 'TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO' )
											)
											OR
												(
													dsc.salescodedescriptionshort IN ( 'NB1REVWO', 'EXTREVWO', 'SURCREDITPCP','SURCREDITNB1' )
													AND dm.MembershipDescriptionShort NOT IN ( 'EXT6','EXT12','EXT18','EXTENH6','EXTENH12', 'EXTENH9',
														'EXTMEM','EXTMEMSOL','EXTINITIAL','EXTPREMMEN', 'EXTPREMWOM', 'GRAD','GRDSVEZ','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
														'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
														'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
														'NPREM48','NPREM60','NPREM72','POSTEXT', 'EXTFLEX', 'EXTFLEXSOL' )
												)
											AND dsc.SalesCodeDepartmentSSID <> 3065 --Exclude Laser
									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'NB_TradAmt'
							,	CASE WHEN so.IsGuaranteeFlag = 1 then
								(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
												AND dm.MembershipDescriptionShort
													IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
															'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
															'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
									THEN 1
									ELSE 0
									END
									-
									CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
												AND (dm.MembershipDescriptionShort
														IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
															'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
															'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT'))
									THEN 1
									ELSE 0
									END)
								ELSE
								(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
												AND dm.MembershipDescriptionShort
													IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
															'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
															'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
									THEN 1
									ELSE 0
									END
									-
									CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
												AND (prevmem.MembershipDescriptionShort
														IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
															'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
															'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
												OR
													dm.MembershipDescriptionShort
														IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
															'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
															'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT'))
									THEN 1
									ELSE 0
									END)
								END
									AS 'NB_GradCnt'
							,	CASE WHEN (
								( ( dsc.SalesCodeDepartmentSSID IN ( 2020 ) OR dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%' )
									AND dm.MembershipDescriptionShort IN ( 'GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV',
																			'GRDSVSOL','ELITENB','ELITENBSOL','NSILVER', 'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM',
																			'NULTRAPREM','NPREM24','NPREM36', 'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT' )
									AND dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO')
									AND dsc.SalesCodeDepartmentSSID <> 3065 )

								OR ( dsc.SalesCodeDepartmentSSID IN ( 2020 )
									 AND dm.MembershipDescriptionShort IN ( 'GRDSVEZ' ) )
															)
									THEN
										sod.ExtendedPriceCalc
									ELSE 0
									END AS 'NB_GradAmt'
							,	CASE WHEN so.IsGuaranteeFlag = 1 then
								(		CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
											AND dm.RevenueGroupSSID = 1 --RevGrp (NewBus)
											AND dm.BusinessSegmentSSID = 2 --BusSeg (EXT)
											AND dm.MembershipDescriptionShort <> 'POSTEXT'
										THEN 1
										ELSE 0
										END
										-
										CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
											AND dm.MembershipDescriptionShort IN
											('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK','NRESTORE','LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')
										THEN 1
										ELSE 0 END)
								ELSE
								(		CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
											AND dm.RevenueGroupSSID = 1 --RevGrp (NewBus)
											AND dm.BusinessSegmentSSID = 2 --BusSeg (EXT)
											AND dm.MembershipDescriptionShort <> 'POSTEXT'
										THEN 1
										ELSE 0
										END
										-
										CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
											AND (prevmem.RevenueGroupSSID = 1 or dm.RevenueGroupSSID = 1) --RevGrp (NewBus)
											AND (prevmem.BusinessSegmentSSID = 2  or dm.BusinessSegmentSSID = 2)--BusSeg (EXT)
											AND (prevmem.MembershipDescriptionShort <> 'POSTEXT'
												OR dm.MembershipDescriptionShort <> 'POSTEXT')
										THEN 1
										ELSE 0 END)
								END
										AS 'NB_ExtCnt'
							,	CASE WHEN (
											( dsc.SalesCodeDepartmentSSID IN (2020) OR (dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%') )
											AND dm.MembershipDescriptionShort IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK',
																					'NRESTORE', 'LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')
											AND dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT')
											AND dsc.SalesCodeDepartmentSSID <> 3065 --Exclude Laser
											)
									THEN
											sod.ExtendedPriceCalc
									ELSE 0
									END AS 'NB_ExtAmt'

							,	CASE WHEN so.IsGuaranteeFlag = 1 THEN(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)

																					AND dm.RevenueGroupSSID = 1 AND dm.BusinessSegmentSSID = 6
												THEN 1
											ELSE 0
											END
											-
											CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
											--AND dm.MembershipDescriptionShort IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
											AND dm.RevenueGroupSSID = 1 AND dm.BusinessSegmentSSID = 6
												THEN 1
											ELSE 0
											END)
									ELSE
										(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
											--AND dm.MembershipDescriptionShort IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
											AND dm.RevenueGroupSSID = 1 AND dm.BusinessSegmentSSID = 6
												THEN 1
											ELSE 0
											END
											-
											CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
											--AND (prevmem.MembershipDescriptionShort IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
											--OR dm.MembershipDescriptionShort in ('Xtrand','Xtrand6', 'Xtrand12'))
											AND ((prevmem.RevenueGroupSSID = 1 AND prevmem.BusinessSegmentSSID = 6)
													OR (dm.RevenueGroupSSID = 1 AND dm.BusinessSegmentSSID = 6))
												THEN 1
											ELSE 0
											END)
									END
									AS 'NB_XtrCnt'
							,	CASE WHEN (
											dsc.SalesCodeDepartmentSSID IN (2020)
												AND dm.RevenueGroupSSID = 1
												AND dm.BusinessSegmentSSID = 6
												AND dsc.SalesCodeDepartmentSSID <> 3065 --Exclude Laser
												)
									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'NB_XtrAmt'

							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010)
									THEN sod.Quantity
									ELSE 0
									END AS 'NB_AppsCnt'

							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
										AND prevmem.RevenueGroupSSID = 1
										AND dm.RevenueGroupSSID = 2
										AND dm.BusinessSegmentSSID = 1
									THEN sod.Quantity
									ELSE 0
									END AS 'NB_BIOConvCnt'

							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
										AND prevmem.RevenueGroupSSID = 1
										AND dm.RevenueGroupSSID = 2
										AND dm.BusinessSegmentSSID = 2
									THEN sod.Quantity
									ELSE 0
									END AS 'NB_EXTConvCnt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
										AND prevmem.RevenueGroupSSID = 1
										AND dm.RevenueGroupSSID = 2
										AND dm.BusinessSegmentSSID = 6
									THEN sod.Quantity
									ELSE 0
									END AS 'NB_XTRConvCnt'
							,	CASE WHEN dsc.SalesCodeSSID IN (399) THEN 1 ELSE 0 END AS 'NB_RemCnt'
							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
												AND dm.BusinessSegmentSSID = 1 and dm.RevenueGroupSSID IN (2,3)
												AND dm.MembershipDescriptionShort NOT IN ('MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT','EMPLOYEE6')
												AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
											OR
												(dm.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL')
												AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
											OR
												(dsc.SalesCodeDepartmentSSID IN (2020) and
												 dm.MembershipDescriptionShort IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL'))
											OR
												(dsc.SalesCodeDepartmentSSID IN (2020)
												AND dm.BusinessSegmentSSID = 6 AND dm.RevenueGroupSSID = 2 )
											OR
												(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE')
												AND dm.MembershipDescriptionShort NOT IN  ('GRDSVEZ'))

									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCP_NB2Amt'  --OK

							,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020)
												AND dm.BusinessSegmentSSID = 1 AND dm.RevenueGroupSSID = 2
												AND dm.MembershipDescriptionShort NOT IN ('NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT',
													'EXT6', 'EXT12','EXT18', 'EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK','NRESTORE', 'LASER82')
												AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
											OR
												(dm.MembershipDescriptionShort IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL')
													AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
											--OR
											--	(dm.MembershipDescriptionShort IN ('XTDMEMSOL','XTRANDMEM'))   --Removed RH 02/12/2015 - it did not limit Xtrands revenue
											OR
												(dm.MembershipDescriptionShort IN ('NONPGM')
													AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT'))
											OR
												(dsc.SalesCodeDepartmentSSID IN (2020)
													AND dm.MembershipDescriptionShort IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL'))
											OR
												(dsc.SalesCodeDepartmentSSID IN (2020)
												--AND dm.MembershipDescriptionShort IN ('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000'))  --Added RH 02/12/2015 to limit Xtrands revenue to where dsc.SalesCodeDepartmentSSID IN (2020)
												AND dm.BusinessSegmentSSID = 6 AND dm.RevenueGroupSSID = 2 ) --RH 8/13/2018


											OR
												(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE')
													AND dm.MembershipDescriptionShort NOT IN ('NONPGM', 'GRDSVEZ')))

									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCP_PCPAmt'  ---OK

							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
											AND dm.BusinessSegmentSSID = 1 AND dm.RevenueGroupSSID = 2
											AND dm.MembershipDescriptionShort NOT IN ('NONPGM','XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')
											AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
										OR
											(dm.BusinessSegmentSSID = 1
											AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT','PCPREVWO'))
									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCP_BioAmt'

							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020) --Membership Revenue
											AND dm.BusinessSegmentSSID = 6 AND dm.RevenueGroupSSID = 2 )
											--AND dm.MembershipDescriptionShort IN('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')) --This is already in BusinessSegmentSSID = 6

										OR
											(dm.BusinessSegmentSSID = 6
											AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT','PCPREVWO')
											--AND dm.MembershipDescriptionShort IN('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')
											AND dm.RevenueGroupSSID = 2 )

									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCP_XtrAmt'

							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
											AND dm.BusinessSegmentSSID = 2 AND dm.RevenueGroupSSID = 2)
										OR
											(dm.MembershipDescriptionShort IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL')
											AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCP_ExtMemAmt'

							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020, 7035)  --Added RH 01/16/2015
											AND dm.MembershipDescriptionShort IN ('NONPGM','RETAIL','HCFK')
											AND dsc.SalesCodeDescriptionShort NOT IN ('PCPMBRPMT','EFTFEE'))
									THEN sod.ExtendedPriceCalc
									ELSE 0
									END AS 'PCPNonPgmAmt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END AS 'PCP_UpgCnt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END AS 'PCP_DwnCnt'
							,	CASE WHEN ( dsc.SalesCodeDepartmentSSID IN (5010,5020,5030,5035,5037,5040,5050,7035) AND dsc.SalesCodeDescriptionShort <> 'ADDONMDP' )
											AND dm.BusinessSegmentSSID IN (1,2,4,6)
										THEN sod.ExtendedPriceCalc
										ELSE 0
										END AS 'ServiceAmt'

							,	CASE WHEN ( dsc.SalesCodeDepartmentSSID = 3065 OR dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN 0
									ELSE CASE WHEN ( dscd.SalesCodeDivisionSSID = 30 AND dm.BusinessSegmentSSID IN ( 1, 2, 4, 6, 7 ) )
											THEN sod.ExtendedPriceCalc
											ELSE 0
										END
								END AS 'RetailAmt'

							,	CASE WHEN
									CASE WHEN ( dsc.SalesCodeDepartmentSSID IN (5010,5020,5030,5035,5037,5040,5050,7035) AND dsc.SalesCodeDescriptionShort <> 'ADDONMDP' )
											AND dm.BusinessSegmentSSID IN (1,2,4,6)
										THEN sod.Quantity
										ELSE 0
										END > 0
									THEN 1
									ELSE 0
									END AS 'ClientServicedCnt'

							,	CASE WHEN (dscd.SalesCodeDivisionSSID IN (20))
										THEN sod.ExtendedPriceCalc
										ELSE 0
										END AS 'NetMembershipAmt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID NOT IN (5060,5061,7010,7030,7050,7051)
											AND dscd.SalesCodeDivisionSSID NOT IN (10)
										THEN sod.ExtendedPriceCalc
										ELSE 0
										END AS 'NetSalesAmt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010, 1075, 1090, 2025)
												and dm.BusinessSegmentSSID = 3
												AND sod.IsRefundedFlag = 0
										THEN 1
										ELSE 0
										END AS 'S_GrossSurCnt'

							--,	CASE WHEN dsc.SalesCodeDescriptionShort IN ('INITASG','CONV','RENEW')
							--					AND dm.BusinessSegmentSSID = 3
							--					--AND daa1.AccumulatorKey IS NOT NULL
							--			THEN 1
							--			ELSE
							--				(CASE WHEN dsc.SalesCodeDepartmentssID IN (1099)
							--					AND dm.BusinessSegmentSSID = 3
							--					--AND daa1.AccumulatorKey IS NOT NULL
							--			THEN -1
							--			ELSE 0
							--			END) END AS 'S_SurCnt'
							,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
										  AND dm.[MembershipSSID] in (43,44,259,260,261,262,263,264,265,266,267,268,269,270, 317,316) THEN 1
									 ELSE 0
								END
								-
								CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )  -- Cancellations (MMCancel)
										  AND dm.[MembershipSSID] in (43,44,259,260,261,262,263,264,265,266,267,268,269,270,317,316)
										  AND dsc.SalesCodeDescriptionShort <> 'CANCELADDON'		--Add-on 9/20/2017 rh
										  THEN 1
									 ELSE 0
								END AS 'S_SurCnt'

							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (2020)
												AND sod.SalesCodeID NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
												AND dm.BusinessSegmentSSID = 3
										THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'S_SurAmt'
							,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065)) then sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020) THEN sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020) THEN sod.Quantity
										ELSE 0
								END AS 'LaserCnt'
							,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (3065)
										THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'LaserAmt'
							, CASE	WHEN #Service.SalesOrderDetailGUID IS NOT NULL THEN 1
									WHEN dsc.SalesCodeDepartmentSSID IN ( 1010 ) AND dm.MembershipDescriptionShort = 'MDP' THEN 1
									WHEN dsc.SalesCodeDepartmentSSID IN ( 1006 ) AND dsc.salescodedescriptionshort = 'ADDONSMP' THEN 1   --Added Bosley SMP
										ELSE 0
										END
										-
								CASE WHEN ( (dsc.[SalesCodeDepartmentSSID] = 1099 AND  #Service.SalesOrderDetailGUID IS NOT NULL)
										OR (dsc.[SalesCodeDepartmentSSID] = 1099  -- Cancellations (MMCancel)
												AND  dm.MembershipDescriptionShort = 'MDP'  ) )
									 THEN 1
									 ELSE 0
								END AS 'NB_MDPCnt'
							, CASE	WHEN dsc.[SalesCodeDepartmentSSID] = 5062 AND dsc.SalesCodeDescriptionShort NOT IN ( 'ADDONMDP', 'SVCSMP' ) THEN sod.ExtendedPriceCalc
									WHEN dsc.SalesCodeDepartmentSSID = 2020 AND dm.MembershipDescriptionShort = 'MDP' THEN sod.ExtendedPriceCalc
									WHEN dsc.SalesCodeDepartmentSSID IN ( 2030 ) AND dsc.salescodedescriptionshort = 'MEDADDONPMTSMP' THEN sod.ExtendedPriceCalc --Added Bosley SMP
										ELSE 0
							  END AS 'NB_MDPAmt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6') ) then sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										ELSE 0
								END AS 'NB_LaserCnt'
							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.ExtendedPriceCalc
									 WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
									 WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'NB_LaserAmt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
									 WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										ELSE 0
								END AS 'PCP_LaserCnt'
							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.ExtendedPriceCalc
									 WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
									 WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'PCP_LaserAmt'

							,	CASE WHEN ( dsc.SalesCodeDepartmentSSID = 3065 ) THEN 0
									ELSE CASE WHEN ( dscd.SalesCodeDivisionSSID = 30 AND dm.BusinessSegmentSSID IN ( 1, 2, 4, 6, 7 ) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
											ELSE 0
										END
								END AS 'EMP_RetailAmt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.Quantity
										WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										ELSE 0
								END AS 'EMP_NB_LaserCnt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.ExtendedPriceCalc
										WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID = 1 AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'EMP_NB_LaserAmt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.Quantity
										WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.Quantity
										ELSE 0
								END AS 'EMP_PCP_LaserCnt'

							, CASE WHEN (dsc.SalesCodeDepartmentSSID IN (3065) AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) then sod.ExtendedPriceCalc
										WHEN (dsc.SalesCodeDescription LIKE '%cap%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										WHEN (dsc.SalesCodeDescription LIKE '%laser%' AND dsc.SalesCodeDepartmentSSID = 2020 AND dm.RevenueGroupSSID IN (2,3,4,5) AND dm.MembershipDescriptionShort IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
											THEN sod.ExtendedPriceCalc
										ELSE 0
								END AS 'EMP_PCP_LaserAmt'

							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(sod.[SalesOrderDetailGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]

					FROM	[bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so with (nolock)
							INNER JOIN  [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod with (nolock)
								  ON so.[SalesOrderGUID] = sod.[SalesOrderGUID]
							INNER JOIN bi_cms_stage.synHC_DDS_DimSalesCode	dsc
								ON sod.SalesCodeID = dsc.SalesCodeSSID
							INNER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datClientMembership] dcm with (nolock)
								ON so.ClientMembershipGUID = dcm.ClientMembershipGUID
							INNER JOIN bi_cms_stage.synHC_DDS_DimMembership dm
								ON dcm.MembershipID = dm.MembershipSSID
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimAccumulatorAdjustment daa1  with (nolock)
								ON sod.SalesOrderDetailGUID = daa1.SalesOrderDetailSSID
										and daa1.AccumulatorSSID = 1
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimAccumulatorAdjustment daa12  with (nolock)
								ON sod.SalesOrderDetailGUID = daa12.SalesOrderDetailSSID
										and daa12.AccumulatorSSID = 12
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimAccumulatorAdjustment daa30  with (nolock)
								ON sod.SalesOrderDetailGUID = daa30.SalesOrderDetailSSID
										and daa30.AccumulatorSSID = 30
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimClientMembership prevdcm  with (nolock)
								ON sod.[PreviousClientMembershipGUID] = prevdcm.[ClientMembershipSSID]
								and sod.PreviousClientMembershipGUID <> '00000000-0000-0000-0000-000000000002'
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimMembership prevmem  with (nolock)
								ON prevdcm.MembershipSSID = prevmem.MembershipSSID
							LEFT OUTER JOIN bi_cms_stage.synHC_DDS_DimSalesCodeDepartment dscd  with (nolock)
								ON dsc.SalesCodeDepartmentKey = dscd.SalesCodeDepartmentKey
							INNER JOIN 	[bi_cms_stage].[synHC_SRC_TBL_CMS_datClient] cl with (nolock)
								ON so.ClientGUID = CL.ClientGUID
							LEFT OUTER JOIN [bi_cms_stage].[DimClientLeadJoin] clj  with (nolock)
								ON so.ClientGUID = clj.ClientSSID
							LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].DimContact dc  with (nolock)
								ON ISNULL(cl.SalesforceContactID, clj.SFDC_LeadID) = dc.SFDC_LeadID
							LEFT OUTER JOIN [HC_BI_MKTG_DDS].bi_mktg_dds.FactLead fl  with (nolock)
								ON dc.ContactKey = fl.ContactKey

							LEFT OUTER JOIN [HairclubCMS].dbo.cfgSalesCode sc
								ON sod.SalesCodeID = sc.SalesCodeID
							LEFT JOIN [HairclubCMS].dbo.lkpGeneralLedger glbio with (nolock)
								ON sc.BIOGeneralLedgerID = glbio.GeneralLedgerID
							LEFT JOIN [HairclubCMS].dbo.lkpGeneralLedger glext with (nolock)
								ON sc.EXTGeneralLedgerID = glext.GeneralLedgerID
							LEFT JOIN [HairclubCMS].dbo.lkpGeneralLedger glsur with (nolock)
								ON sc.SURGeneralLedgerID = glsur.GeneralLedgerID
  							LEFT JOIN HairClubCMS.dbo.cfgConfigurationCenter cc
								ON so.centerid = cc.CenterID
							LEFT JOIN #Service
								ON #Service.SalesOrderDetailGUID = sod.SalesOrderDetailGUID
									AND #Service.RowID = 1
							LEFT OUTER JOIN #MEDADDON
								ON #MEDADDON.SalesOrderDetailGUID = sod.SalesOrderDetailGUID
									AND #MEDADDON.Ranking = 1




				WHERE  ( (so.[CreateDate] >= @LSET AND so.[CreateDate] < @CET_UTC)
				   OR (so.[LastUpdate] >= @LSET AND so.[LastUpdate] < @CET_UTC)
				   OR (sod.[CreateDate] >= @LSET AND sod.[CreateDate] < @CET_UTC)
				   OR (sod.[LastUpdate] >= @LSET AND sod.[LastUpdate] < @CET_UTC) )
					AND (so.IsClosedFlag = 1 AND  so.IsVoidedFlag = 0)


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
