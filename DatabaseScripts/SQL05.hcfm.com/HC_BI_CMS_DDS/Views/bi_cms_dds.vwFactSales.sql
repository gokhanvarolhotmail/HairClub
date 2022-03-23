/* CreateDate: 05/03/2010 12:17:24.560 , ModifyDate: 03/15/2022 14:30:31.190 */
GO
CREATE VIEW [bi_cms_dds].[vwFactSales]
AS
-------------------------------------------------------------------------
-- [vwFactSales] is used to retrieve a
-- list of Sales Orders
--
--   SELECT * FROM [bi_cms_dds].[vwFactSales]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			07/11/2011  KMurdoch	 Added Exclusion of SurgeryReversal Records
--          04/10/2012  EKnapp		 Added join to Client and Lead
--			10/02/2020  KMurdoch     Restricted to 2017 forward
--
-------------------------------------------------------------------------

	SELECT		DD.[FullDate] AS [PartitionDate]
			  , [OrderDateKey]
			  , FS.[SalesOrderKey]
			  , FS.[SalesOrderTypeKey]
			  , FS.[CenterKey]
			  , FS.[ClientHomeCenterKey]
			  , FS.[ClientKey]
			  , [MembershipKey]
			  , FS.[ClientMembershipKey]
			  , FS.[EmployeeKey]
			  , [IsRefunded]
			  , [IsTaxExempt]
			  , [IsWrittenOff]
			  , [TotalDiscount]
			  , [TotalTax]
			  , [TotalExtendedPrice]
			  , [TotalExtendedPricePlusTax]
			  , [TotalTender]
			  , [TenderVariance]
			  , [ISSURGERYREVERSALFLAG]
			  , ISNULL(CLI.contactkey, -1) AS contactkey
			  , ISNULL(lead.GenderKey, -1) AS GenderKey
			  , ISNULL(lead.OccupationKey, -1) AS OccupationKey
			  , ISNULL(lead.EthnicityKey, -1) AS EthnicityKey
			  , ISNULL(lead.MaritalStatusKey, -1) AS MaritalStatusKey
			  , ISNULL(lead.HairLossTypeKey, -1) AS HairLossTypeKey
			  , ISNULL(lead.AgeRangeKey, -1) AS AgeRangeKey
			  , ISNULL(lead.PromotionCodeKey, -1) AS PromotionCodeKey
	  FROM [bi_cms_dds].[FactSales] FS
		LEFT OUTER JOIN  [HC_BI_ENT_DDS].bief_dds.DimDate DD
			ON FS.[OrderDateKey] = DD.[DateKey]
		LEFT OUTER JOIN [bi_cms_dds].[DimSalesOrder] SO
			ON FS.SalesOrderKey = SO.SalesOrderKey
		LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI WITH (NOLOCK)
			ON FS.ClientKey = CLI.ClientKey
		LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead WITH (NOLOCK)
			ON CLI.contactkey=Lead.ContactKey
	  WHERE ISNULL(IsSurgeryReversalFlag,0) <> 1
	  AND so.OrderDate >= '01/01/2017'
GO
