/* CreateDate: 05/03/2010 12:17:24.593 , ModifyDate: 09/16/2019 09:33:49.870 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesTransaction]
AS
-------------------------------------------------------------------------
-- [vwFactSalesTransaction] is used to retrieve a
-- list of Sales Transactions
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesTransaction]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--			07/11/2011  KMurdoch	 Added Exclusion of SurgeryReversal Records
--          04/10/2012  EKnapp		 Added join to Client and Lead
--
-------------------------------------------------------------------------

	SELECT DD.[FullDate] AS [PartitionDate]
		  ,fst.[OrderDateKey]
		  ,fst.[SalesOrderKey]
		  ,[SalesOrderDetailKey]
		  ,fst.[SalesOrderTypeKey]
		  ,fst.[CenterKey]
		  ,fs.[ClientHomeCenterKey]
		  ,fst.[ClientKey]
		  ,fst.[MembershipKey]
		  ,fst.[ClientMembershipKey]
		  ,[SalesCodeKey]
		  ,[Employee1Key]
		  ,[Employee2Key]
		  ,[Employee3Key]
		  ,[Employee4Key]
		  ,[Quantity]
		  ,[Price]
		  ,[Discount]
		  ,[ExtendedPrice]
		  ,[Tax1]
		  ,[Tax2]
		  ,[TaxRate1]
		  ,[TaxRate2]
		  ,[ExtendedPricePlusTax]
		  ,[TotalTaxAmount]
		  , ISNULL(CLI.contactkey, -1) as contactkey
		  , ISNULL(lead.GenderKey, -1) as GenderKey
		  , ISNULL(lead.OccupationKey, -1) as OccupationKey
		  , ISNULL(lead.EthnicityKey, -1) as EthnicityKey
		  , ISNULL(lead.MaritalStatusKey, -1) as MaritalStatusKey
		  , ISNULL(lead.HairLossTypeKey, -1) as HairLossTypeKey
		  , ISNULL(lead.AgeRangeKey, -1) as AgeRangeKey
		  , ISNULL(lead.PromotionCodeKey, -1) as PromotionCodeKey
	  FROM [bi_cms_dds].[FactSalesTransaction] fst
		LEFT OUTER JOIN  [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
			ON fst.[OrderDateKey] = DD.[DateKey]
		LEFT OUTER JOIN [bi_cms_dds].[FactSales] fs
			on fs.SalesOrderKey = fst.SalesOrderKey
		LEFT OUTER JOIN [bi_cms_dds].[DimSalesOrder] so
			on fs.SalesOrderKey = so.SalesOrderKey
		LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI with (nolock)
			ON fst.ClientKey = CLI.ClientKey
		LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead with (nolock)
			ON CLI.contactkey=Lead.ContactKey
	  WHERE ISNULL(IsSurgeryReversalFlag,0) <> 1
GO
