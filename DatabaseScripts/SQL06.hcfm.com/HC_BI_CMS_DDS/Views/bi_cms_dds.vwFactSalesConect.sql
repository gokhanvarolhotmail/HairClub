CREATE VIEW [bi_cms_dds].[vwFactSalesConect] AS
-------------------------------------------------------------------------
--	[vwFactSalesConect] is used to retrieve a list of Sales Transactions for First Surgery Net Dollars
--
--	SELECT * FROM [bi_cms_dds].[vwFactSalesConect] where CenterKey = 213 and [OrderDate]>= '1/10/2019'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/22/2010  RLifke       Initial Creation
--  v1.1    03/22/2011  CFleming     Changes to correct Surgery Flash
--  v1.2	05/27/2011	Kmurdoch	 Added Deposits
--  V1.3	03/19/2012  Kmurdoch     Modified to derive ReportingCenterSSID
--          04/10/2012  EKnapp		 Added join to Client and Lead
--			10/01/2012  KMurdoch	 Rewrite to derive directly from FactSalesTransaction
--			10/02/2012  KMurdoch	 Modified Center derivation to be ClientHomeCenter
--			10/02/2012  KMurdoch     Added Exclusion of Surgery Reversal
--			10/04/2012  KMurdoch     Added ISNULL around Surgery Reversal
--			04/22/2013	MBurrell	 Changed center derivation to come from DimClientMembership (WO# 84277)
--			07/10/2013  KMurdoch	 Added Total Conversion#, PCP Cancels
--			09/25/2013  DLeiba		 Added Upgrades, Downgrades & Removals
--			05/05/2014  KMurdoch     Added in Source key
--			06/03/2014  KMurdoch	 Added in XTR Cnt & Amt
--			11/20/2014	KMurdoch     Added in NB_XTRConvCnt
--			12/15/2014	RHut		 Added in PCP_XtrAmt MONEY
--		    03/24/2017  KMurdoch     Added AgeRange from Birthdate
--			01/25/2018  KMurdoch     Added PRP $ & #
--			07/16/2018	KMurdoch     Added Laser Cnt & Amt
--			12/03/2018	KMurdoch	 Added MDP
--			01/17/2019	RHut		 Removed join on CenterSSID since it was removing Colorado Springs (1002)
--			03/18/2019  KMurdoch	 Added Cnt/Amt breakdown of laser between NB & PCP columns
--			09/21/2020  KMurdoch     Added LeadCreationTimeOfDay key to view.
--			10/02/2020  KMurdoch     Restricted to 2017 forward
--			02/23/2021  KMurdoch     Added LeadCreateDateKey
-------------------------------------------------------------------------

SELECT	d.FullDate AS 'PartitionDate'
,		d.FullDate AS 'OrderDate'
,		ISNULL(fl.LeadCreationDateKey,-1) AS 'LeadCreationDateKey'
,		fst.OrderDateKey
,		fst.SalesOrderKey
,		fst.SalesOrderDetailKey
,		fs.ClientHomeCenterKey
,		fst.SalesOrderTypeKey
,		fst.CenterKey AS 'TransactionCenterKey'
,		ctr.CenterKey
,		fst.ClientKey
,		fst.MembershipKey
,		fst.ClientMembershipKey
,		fst.SalesCodeKey
,		ISNULL(aa.AccumulatorKey,-1) AS 'AccumulatorKey'
,		fst.Employee1Key
,		fst.Employee2Key
,		fst.Employee3Key
,		fst.Employee4Key
,		fst.Quantity AS 'SF-Quantity'
,		fst.Price AS 'SF-Price'
,		fst.Discount AS 'SF-Discount'
,		fst.ExtendedPrice AS 'SF-ExtendedPrice'
,		fst.Tax1 AS 'SF-Tax1'
,		fst.Tax2 AS 'SF-Tax2'
,		fst.TaxRate1 AS 'SF-TaxRate1'
,		fst.TaxRate2 AS 'SF-TaxRate2'
,		fst.ExtendedPricePlusTax AS 'SF-ExtendedPricePlusTax'
,		fst.TotalTaxAmount AS 'SF-TotalTaxAmount'

------------------------------------------------------------------------------------------
--GET FIRST AND ADDITIONAL SURGERY INFORMATION
------------------------------------------------------------------------------------------
,		fst.S1_SaleCnt AS 'S1_Sale#'
,		fst.S_CancelCnt AS 'S-Cancel#'
,		fst.S1_NetSalesCnt AS 'S1_NetSales#'
,		fst.S1_NetSalesAmt AS 'S1_NetSales$'
,		fst.S1_ContractAmountAmt AS 'S1_ContractAmount$'
,		fst.S1_EstGraftsCnt AS 'S1_EstGrafts#'
,		fst.S1_EstPerGraftsAmt AS 'S1_EstPerGrafts$'
,		fst.SA_NetSalesCnt AS 'SA_NetSales#'
,		fst.SA_NetSalesAmt AS 'SA_NetSales$'
,		fst.SA_ContractAmountAmt AS 'SA_ContractAmount$'
,		fst.SA_EstGraftsCnt AS 'SA_EstGrafts#'
,		fst.SA_EstPerGraftAmt AS 'SA_EstPerGraft$'
,		fst.S_PostExtCnt AS 'S_PostExt#'
,		fst.S_PostExtAmt AS 'S_PostExt$'
,		fst.S_PRPCnt AS 'S_PRP#'
,		fst.S_PRPAmt AS 'S_PRP$'

------------------------------------------------------------------------------------------
--GET TOTAL SURGERIES PERFORMED DATA
------------------------------------------------------------------------------------------
,		fst.S_SurgeryPerformedCnt AS 'S_SurgeryPerformed#'
,		fst.S_SurgeryPerformedAmt AS 'S_SurgeryPerformed$'
,		fst.S_SurgeryGraftsCnt AS 'S_SurgeryGrafts#'
,		fst.S1_DepositsTakenCnt AS 'S1_DepositsTaken#'
,		fst.S1_DepositsTakenAmt AS 'S1_DepositsTaken$'

------------------------------------------------------------------------------------------
--GET NON SURGERY DATA
------------------------------------------------------------------------------------------
,		fst.NB_GrossNB1Cnt AS 'NB_GrossNB1#'
,		fst.NB_TradCnt AS 'NB_Trad#'
,		fst.NB_TradAmt AS 'NB_Trad$'
,		fst.NB_GradCnt AS 'NB_Grad#'
,		fst.NB_GradAmt AS 'NB_Grad$'
,		fst.NB_ExtCnt AS 'NB_Ext#'
,		fst.NB_ExtAmt AS 'NB_Ext$'
,		ISNULL(fst.NB_XTRCnt, 0) AS 'NB_Xtr#'
,		ISNULL(fst.NB_XTRAmt, 0) AS 'NB_Xtr$'
,		fst.NB_AppsCnt AS 'NB_Apps#'
,		fst.NB_BIOConvCnt AS 'NB_BIOConv#'
,		fst.NB_EXTConvCnt AS 'NB_EXTConv#'
,		ISNULL(fst.NB_XTRConvCnt, 0) AS 'NB_XTRConv#'
,		ISNULL(fst.NB_RemCnt, 0) AS 'NB_Rem#'
,		fst.PCP_NB2Amt AS 'PCP_NB2$'
,		fst.PCP_PCPAmt AS 'PCP_PCP$'
,		fst.PCP_BioAmt AS 'PCP_Bio$'
,		fst.PCP_XtrAmt AS 'PCP_Xtr$'
,		fst.PCP_ExtMemAmt AS 'PCP_ExtMem$'
,		fst.PCPNonPgmAmt AS 'PCPNonPgm$'
,		ISNULL(fst.PCP_UpgCnt, 0) AS 'PCP_Upg#'
,		ISNULL(fst.PCP_DwnCnt, 0) AS 'PCP_Dwn#'
,		fst.ServiceAmt AS 'Service$'
,		fst.RetailAmt AS 'Retail$'
,		fst.ClientServicedCnt AS 'ClientServiced#'
,		fst.NetMembershipAmt AS 'NetMembership$'
,		fst.NetSalesAmt AS 'NetSales$'
,		fst.S_GrossSurCnt AS 'S_GrossSur#'
,		fst.S_SurCnt AS 'S_Sur#'
,		fst.S_SurAmt AS 'S_Sur$'
,		fst.LaserCnt AS 'LaserCnt'
,		fst.LaserAmt AS 'LaserAmt'
,		fst.NB_MDPCnt AS 'NB_MDPCnt'
,		fst.NB_MDPAmt AS 'NB_MDPAmt'
,		fst.NB_LaserCnt AS 'NB_LaserCnt'
,		fst.NB_LaserAmt AS 'NB_LaserAmt'
,		fst.PCP_LaserCnt AS 'PCP_LaserCnt'
,		fst.PCP_LaserAmt AS 'PCP_LaserAmt'
,		ISNULL(clt.contactkey, -1) AS 'contactkey'
,		CASE WHEN clt.genderssid = -2 THEN 1 ELSE ISNULL(clt.GenderSSID, -1) END AS 'GenderKey'
,		ISNULL(o.OccupationKey, -1) AS 'OccupationKey'
,		ISNULL(e.EthnicityKey, -1) AS 'EthnicityKey'
,		ISNULL(ms.MaritalStatusKey, -1) AS 'MaritalStatusKey'
,		ISNULL(fl.HairLossTypeKey, -1) AS 'HairLossTypeKey'
,		ISNULL(CASE WHEN clt.ClientDateOfBirth IS NULL AND fl.AgeRangeKey <> -1 THEN fl.AgeRangeKey ELSE ISNULL(ar.AgeRangeKey, -1) END, -1) AS 'AgeRangeKey'
,		ISNULL(fl.PromotionCodeKey, -1) AS 'PromotionCodeKey'
,		ISNULL(fl.SourceKey, -1) AS 'SourceKey'
,		ISNULL(fst.accountid, -1) AS 'AccountID'
,		ISNULL(fl.LeadCreationTimeKey,-1) AS 'LeadCreationTimeKey'
,		CASE WHEN ( fst.NB_BIOConvCnt = 1 OR fst.NB_EXTConvCnt = 1 OR fst.NB_XTRConvCnt = 1 ) THEN 1 ELSE 0 END AS 'NB_TOTConv#'
,		CASE WHEN ( m.BusinessSegmentSSID = 1 AND m.RevenueGroupSSID = 2 AND sc.SalesCodeSSID = 351 ) THEN 1 ELSE 0 END AS 'PCP_CXL'

------------------------------------------------------------------------------------------
--GET A la Carte Data
------------------------------------------------------------------------------------------
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'ALCHOH', 'ALCHOH2' ) AND m.RevenueGroupSSID = 1 THEN fst.ExtendedPrice ELSE 0 END AS 'NB_ALCAmt'
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'ALCHOH', 'ALCHOH2' ) AND m.RevenueGroupSSID = 2 AND m.MembershipDescriptionShort = 'NONPGM' THEN fst.ExtendedPrice ELSE 0 END AS 'NB2_ALCAmt'
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'ALCHOH', 'ALCHOH2' ) AND m.RevenueGroupSSID = 2 AND m.MembershipDescriptionShort <> 'NONPGM' THEN fst.ExtendedPrice ELSE 0 END AS 'PCP_ALCAmt'

------------------------------------------------------------------------------------------
--GET Extension Data
------------------------------------------------------------------------------------------
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'TAPEPACK' ) THEN fst.RetailAmt ELSE 0 END AS 'Retail_ExtensionsAmt' -- TROUBLESHOOT
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'TAPESVC', 'TAPEINSTSVC', 'TAPEREINSTSVC' ) THEN fst.ServiceAmt ELSE 0 END AS 'Retail_ExtensionsSvcAmt'

------------------------------------------------------------------------------------------
--GET Halo Data
------------------------------------------------------------------------------------------
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( 'HALO2LINES', 'HALO5LINES', 'HALO20' ) THEN fst.RetailAmt ELSE 0 END AS 'Retail_HalosAmt' -- TROUBLESHOOT

------------------------------------------------------------------------------------------
--GET SPA Device Data
------------------------------------------------------------------------------------------
,		CASE WHEN sc.SalesCodeDescriptionShort IN ( '480-116' ) THEN fst.ExtendedPrice ELSE 0 END AS 'Retail_SPAAmt'

------------------------------------------------------------------------------------------
--GET Non-Program Data
------------------------------------------------------------------------------------------
,		( fst.PCP_NB2Amt  - fst.PCP_PCPAmt ) AS 'NonProgramAmt'

------------------------------------------------------------------------------------------
--GET Retail (Excl Extensions, Halos & Laser) Data
------------------------------------------------------------------------------------------
,		CASE WHEN ( sc.SalesCodeDepartmentSSID = 3065 OR sc.SalesCodeDescriptionShort IN ( 'TAPEPACK', 'HALO2LINES', 'HALO5LINES', 'HALO20' ) ) THEN 0 ELSE fst.RetailAmt END AS 'Retail_OtherAmt'

------------------------------------------------------------------------------------------
--GET NB Cancel Data
------------------------------------------------------------------------------------------
,		CASE WHEN sc.SalesCodeDepartmentSSID IN ( 1099 ) AND m.BusinessSegmentSSID = 1 AND m.RevenueGroupSSID = 1 THEN 1 ELSE 0 END AS 'NB_XTRP_CancelCnt'
,		CASE WHEN sc.SalesCodeDepartmentSSID IN ( 1099 ) AND m.BusinessSegmentSSID = 2 AND m.RevenueGroupSSID = 1 THEN 1 ELSE 0 END AS 'NB_EXT_CancelCnt'
,		CASE WHEN sc.SalesCodeDepartmentSSID IN ( 1099 ) AND m.BusinessSegmentSSID = 6 AND m.RevenueGroupSSID = 1 THEN 1 ELSE 0 END AS 'NB_XTR_CancelCnt'

FROM	bi_cms_dds.FactSalesTransaction fst
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
            ON d.DateKey = fst.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = fst.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
            ON sc.SalesCodeKey = fst.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
            ON so.SalesOrderKey = fst.SalesOrderKey
		INNER JOIN bi_cms_dds.FactSales fs
			ON fs.SalesOrderKey = fst.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
            ON cm.ClientMembershipKey = so.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
            ON m.MembershipKey = cm.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
            ON ctr.CenterKey = cm.CenterKey
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
			ON fl.ContactKey = clt.contactkey
		LEFT OUTER JOIN bi_cms_dds.vwDimAccumulatorAdjustment aa
			ON aa.SalesOrderDetailKey = fst.SalesOrderDetailKey
				AND aa.AccumulatorSSID = 1
					AND aa.DateAdjustment NOT IN ( '2013-09-16', '2013-08-19' ) AND m.MembershipSSID IN ( 43,44 )
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity e
			ON e.EthnicitySSID = clt.EthinicitySSID
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation o
			ON o.OccupationSSID = clt.OccupationSSID
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus ms
			ON ms.MaritalStatusSSID = clt.MaritalStatusSSID
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON ISNULL(DATEDIFF(YEAR, clt.ClientDateOfBirth, GETDATE()), 0) BETWEEN ar.BeginAge AND ar.EndAge
WHERE	sc.SalesCodeDescriptionShort NOT IN ( 'UPDMBR', 'TXFROUT' )
		AND ISNULL(so.IsSurgeryReversalFlag, 0) <> 1
		AND so.IsVoidedFlag = 0
		AND so.OrderDate >= '01/01/2017'
