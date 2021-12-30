/* CreateDate: 10/01/2012 15:33:39.483 , ModifyDate: 09/16/2019 09:33:49.880 */
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesConect]
AS
-------------------------------------------------------------------------
-- [vwFactSalesFirstSurgeryInfo] is used to retrieve a
-- list of Sales Transactions for First Surgery Net Dollars
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesConect] where CenterKey = 213 and [OrderDate]>= '1/10/2019'
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
-------------------------------------------------------------------------

	SELECT		DD.[FullDate] AS [PartitionDate]
		  ,		DD.[FullDate] AS [OrderDate]
		  ,		fst.[OrderDateKey]
		  ,		fst.[SalesOrderKey]
		  ,		fst.[SalesOrderDetailKey]
		  ,		fs.ClientHomeCenterKey
		  ,		fst.[SalesOrderTypeKey]
		  --,		fst.[CenterKey]
		  ,     DC.[CenterKey]
		  ,		fst.[ClientKey]
		  ,		fst.[MembershipKey]
		  ,		fst.[ClientMembershipKey]
		  ,		fst.[SalesCodeKey]
		  ,		ISNULL(DAA.[AccumulatorKey],-1) AS [AccumulatorKey]
		  ,		fst.[Employee1Key]
		  ,		fst.[Employee2Key]
		  ,		fst.[Employee3Key]
		  ,		fst.[Employee4Key]
		  ,		fst.[Quantity] AS 'SF-Quantity'
		  ,		fst.[Price] AS 'SF-Price'
		  ,		fst.[Discount] AS 'SF-Discount'
		  ,		fst.[ExtendedPrice] AS 'SF-ExtendedPrice'
		  ,		fst.[Tax1] AS 'SF-Tax1'
		  ,		fst.[Tax2] AS 'SF-Tax2'
		  ,		fst.[TaxRate1] AS 'SF-TaxRate1'
		  ,		fst.[TaxRate2] AS 'SF-TaxRate2'
		  ,		fst.[ExtendedPricePlusTax] AS 'SF-ExtendedPricePlusTax'
		  ,		fst.[TotalTaxAmount] AS 'SF-TotalTaxAmount'
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
		  ,		ISNULL(fst.NB_XTRCnt,0) AS 'NB_Xtr#'
		  ,		ISNULL(fst.NB_XTRAmt,0) AS 'NB_Xtr$'
		  ,		fst.NB_AppsCnt AS 'NB_Apps#'
		  ,		fst.NB_BIOConvCnt AS 'NB_BIOConv#'
		  ,		fst.NB_EXTConvCnt AS 'NB_EXTConv#'
		  ,		ISNULL(fst.NB_XTRConvCnt,0) AS 'NB_XTRConv#'
		  ,		ISNULL(fst.NB_RemCnt,0) AS 'NB_Rem#'
		  ,		fst.PCP_NB2Amt AS 'PCP_NB2$'
		  ,		fst.PCP_PCPAmt AS 'PCP_PCP$'
          ,		fst.PCP_BioAmt AS 'PCP_Bio$'
		  ,		fst.PCP_XtrAmt AS 'PCP_Xtr$' --Added RH 12/15/2014
		  ,		fst.PCP_ExtMemAmt AS 'PCP_ExtMem$'
		  ,		fst.PCPNonPgmAmt AS 'PCPNonPgm$'
		  ,		ISNULL(fst.PCP_UpgCnt,0) AS 'PCP_Upg#'
		  ,		ISNULL(fst.PCP_DwnCnt,0) AS 'PCP_Dwn#'
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

		  ,		ISNULL(CLI.contactkey, -1) AS contactkey
		  ,		CASE WHEN cli.genderssid = -2 THEN 1 ELSE ISNULL(cli.GenderSSID, -1) END AS GenderKey
		  --,		CASE WHEN cli.OccupationSSID = -2 THEN ISNULL(lead.OccupationKey,-1)
				--	WHEN cli.OccupationSSID <> -2 THEN ISNULL(DO.OccupationKey,-1)
				--	ELSE -1 END AS OccupationKey
		  ,     ISNULL(DO.OccupationKey,-1) AS OccupationKey
		  --,		CASE WHEN cli.EthinicitySSID = -2 THEN ISNULL(lead.EthnicityKey,-1)
				--	WHEN cli.EthinicitySSID <> -2 THEN ISNULL(DE.EthnicityKey,-1)
				--	ELSE -1 END AS EthnicityKey
		  ,		ISNULL(DE.EthnicityKey,-1) AS EthnicityKey
	    --  ,		CASE WHEN cli.MaritalStatusSSID = -2 THEN ISNULL(lead.MaritalStatusKey,-1)
					--WHEN cli.MaritalStatusSSID <> -2 THEN ISNULL(DMS.MaritalStatusKey,-1)
					--ELSE -1 END AS MaritalStatusKey
		  ,		ISNULL(DMS.MaritalStatusKey,-1) AS MaritalStatusKey
		  ,		ISNULL(lead.HairLossTypeKey, -1) AS HairLossTypeKey
		  ,		ISNULL( CASE WHEN cli.ClientDateOfBirth IS NULL AND lead.AgeRangeKey <> -1 THEN lead.AgeRangeKey
					ELSE ISNULL(DAR.AgeRangeKey,-1) END,-1) AS AgeRangeKey
		  ,		ISNULL(lead.PromotionCodeKey, -1) AS PromotionCodeKey
		  ,		ISNULL(lead.SourceKey, -1) AS SourceKey
		  ,		ISNULL(fst.accountid,-1) AS AccountID
		  ,		CASE WHEN (fst.NB_BIOConvCnt = 1 OR fst.NB_EXTConvCnt = 1 OR fst.NB_XTRConvCnt = 1) THEN 1 ELSE 0 END AS 'NB_TOTConv#'
		  ,		CASE WHEN (mem.BusinessSegmentSSID = 1
							AND mem.RevenueGroupSSID = 2
							AND dsc.SalesCodeSSID = 351) THEN 1 ELSE 0 END AS 'PCP_CXL'



	  FROM [bi_cms_dds].[FactSalesTransaction] fst
			INNER JOIN [bi_cms_dds].[DimSalesCode] dsc
				ON fst.[SalesCodeKey] = dsc.[SalesCodeKey]
			INNER JOIN bi_cms_dds.FactSales fs
				ON fst.salesorderkey = fs.salesorderkey
			INNER JOIN  [bi_cms_dds].[synHC_ENT_DDS_DimDate] DD
				ON fst.[OrderDateKey] = DD.[DateKey]
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON fst.ClientMembershipKey = cm.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MEM
				ON cm.MembershipKey = mem.MembershipKey
			INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON cm.CenterKey = DC.CenterKey						--KEEP join on ClientMembership.CenterKey - Home Center based
			--INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter RDC
			--	ON DC.ReportingCenterSSID = RDC.CenterSSID			--This was removing Colorado Springs RH 1/17/2019
			INNER JOIN [bi_cms_dds].[DimClient] CLI WITH (NOLOCK)
				ON fst.ClientKey = CLI.ClientKey
			LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead WITH (NOLOCK)
				ON CLI.contactkey=Lead.ContactKey
			LEFT OUTER JOIN bi_cms_dds.vwDimAccumulatorAdjustment AS DAA
				ON fst.SalesOrderDetailKey = DAA.SalesOrderDetailKey
					AND DAA.AccumulatorSSID IN (1)
						AND (daa.dateadjustment NOT IN ('2013-09-16','2013-08-19') AND mem.membershipssid IN (43,44))
			INNER JOIN bi_cms_dds.DimSalesOrder dso
				ON fst.SalesOrderKey = dso.SalesOrderKey
			LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity AS DE
				ON DE.EthnicitySSID = cli.EthinicitySSID
			LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation AS DO
				ON do.OccupationSSID = cli.OccupationSSID
			LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus AS DMS
				ON DMS.MaritalStatusSSID = cli.MaritalStatusSSID
			LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange DAR
				ON ISNULL( DATEDIFF(YEAR, cli.ClientDateOfBirth, GETDATE()),0) BETWEEN DAR.BeginAge AND DAR.EndAge

WHERE dsc.SalesCodeDescriptionShort NOT IN ('UPDMBR','TXFROUT')
	AND ISNULL(dso.IsSurgeryReversalFlag,0) <> 1
GO
