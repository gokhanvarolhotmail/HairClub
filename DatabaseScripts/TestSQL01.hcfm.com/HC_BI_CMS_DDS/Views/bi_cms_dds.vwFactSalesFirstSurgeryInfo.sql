/* CreateDate: 10/01/2012 15:54:35.890 , ModifyDate: 09/16/2019 09:33:49.883 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesFirstSurgeryInfo]
AS
-------------------------------------------------------------------------
-- [vwFactSalesFirstSurgeryInfo] is used to retrieve a
-- list of Sales Transactions for First Surgery Net Dollars
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesFirstSurgeryInfo]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/22/2010  RLifke       Initial Creation
--  v1.1    03/22/2011  CFleming     Changes to correct Surgery Flash
--  v1.2	05/27/2011	Kmurdoch	 Added Deposits
--	v1.3	03/19/2012  Kmurdoch	 Modified to only include Surgery Centers
--          04/10/2012  EKnapp		 Added join to Client and Lead
--			10/01/2012  KMurdoch	 Rewrite to derive directly from FactSalesTransaction
--
-------------------------------------------------------------------------

	SELECT	DD.[FullDate] AS [PartitionDate]
		  , DD.[FullDate] as [OrderDate]
		  , fst.[OrderDateKey]
		  , fst.[SalesOrderKey]
		  , fst.[SalesOrderDetailKey]
		  , fst.ClientHomeCenterKey
		  , fst.[SalesOrderTypeKey]
		  , fst.[CenterKey]
		  , fst.[ClientKey]
		  , fst.[MembershipKey]
		  , fst.[ClientMembershipKey]
		  , fst.[SalesCodeKey]
		  , fst.[AccumulatorKey]
		  , fst.[Employee1Key]
		  , fst.[Employee2Key]
		  , fst.[Employee3Key]
		  , fst.[Employee4Key]
		  , fst.[Quantity] AS [SF-Quantity]
		  , fst.[Price] AS [SF-Price]
		  , fst.[Discount] AS [SF-Discount]
		  , fst.[ExtendedPrice] AS [SF-ExtendedPrice]
		  , fst.[Tax1] AS [SF-Tax1]
		  , fst.[Tax2] AS [SF-Tax2]
		  , fst.[TaxRate1] AS [SF-TaxRate1]
		  , fst.[TaxRate2] AS [SF-TaxRate2]
		  , fst.[ExtendedPricePlusTax] AS [SF-ExtendedPricePlusTax]
		  , fst.[TotalTaxAmount] AS [SF-TotalTaxAmount]
	------------------------------------------------------------------------------------------
	--GET FIRST AND ADDITIONAL SURGERY INFORMATION
	------------------------------------------------------------------------------------------
		   , fst.S1_NetSalesCnt AS [SF-SaleCount]

		   , fst.S_CancelCnt  AS [SF-CancellationCount]

		   , fst.S1_NetSalesCnt AS [SF-First_Surgery_Net_Sales]

	 	   , fst.[S1_NetSalesAmt] AS [SF-First_Surgery_Net$]

		   , fst.S1_ContractAmountAmt AS [SF-First_Surgery_Contract_Amount]

		   , fst.S1_EstGraftsCnt AS [SF-First_Surgery_Est_Grafts]

		   , fst.S1_EstGraftsCnt AS [SF-First_Surgery_Est_Per_Grafts]

		   , fst.SA_NetSalesCnt AS [SF-Addtl_Surgery_Net_Sales]

		   , fst.SA_NetSalesAmt AS [SF-Addtl_Surgery_Net$]

		   , fst.SA_ContractAmountAmt AS [SF-Addtl_Surgery_Contract_Amount]

		   , fst.SA_EstGraftsCnt AS [SF-Addtl_Surgery_Est_Grafts]

		   , fst.SA_EstPerGraftAmt AS [SF-Addtl_Surgery_Est_Per_Grafts]

		   , fst.S_PostExtCnt AS [SF-Total_POSTEXTPMT_Count]

		   , fst.S_PostExtAmt AS [SF-Total_POSTEXTPMT]

	------------------------------------------------------------------------------------------
	--GET TOTAL SURGERIES PERFORMED DATA
	------------------------------------------------------------------------------------------
		   , fst.[S_SurgeryPerformedCnt] AS [SF-Total_Surgery_Performed]

		   , fst.[S_SurgeryPerformedAmt] AS [SF-Total_Net$]

		   , fst.[S_SurgeryGraftsCnt] AS [SF-Total_Grafts]
		   , fst.[S1_DepositsTakenCnt]AS [SF-DepositsTaken]
		   , fst.[S1_DepositsTakenAmt] AS [SF-DepositsTaken$]
		   , dsc.[SalesCodeDepartmentSSID]
			  , ISNULL(CLI.contactkey, -1) as contactkey
			  , ISNULL(lead.GenderKey, -1) as GenderKey
			  , ISNULL(lead.OccupationKey, -1) as OccupationKey
			  , ISNULL(lead.EthnicityKey, -1) as EthnicityKey
			  , ISNULL(lead.MaritalStatusKey, -1) as MaritalStatusKey
			  , ISNULL(lead.HairLossTypeKey, -1) as HairLossTypeKey
			  , ISNULL(lead.AgeRangeKey, -1) as AgeRangeKey
			  , ISNULL(lead.PromotionCodeKey, -1) as PromotionCodeKey
	  FROM [bi_cms_dds].[vwFactSalesTransaction_Flash] fst
			INNER JOIN [bi_cms_dds].[DimSalesCode] dsc
				ON dsc.[SalesCodeKey] = fst.[SalesCodeKey]
			INNER JOIN [bi_cms_dds].[DimMembership] dm
				ON dm.[MembershipKey] = fst.[MembershipKey]
			INNER JOIN [bi_cms_dds].[DimClientMembership]dcm
				ON dcm.[ClientMembershipKey] = fst.[ClientMembershipKey]
			LEFT OUTER JOIN  HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON fst.[OrderDateKey] = DD.[DateKey]
			LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI with (nolock)
				ON fst.ClientKey = CLI.ClientKey
			LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead with (nolock)
				ON CLI.contactkey=Lead.ContactKey
			INNER JOIN [bi_cms_dds].[synHC_ENT_DDS_DimCenter] c
				ON fst.CenterKey = c.centerkey
	 WHERE
		c.CenterSSID LIKE '[356]%'
GO
