CREATE VIEW [bi_cms_dds].[vwFactSalesTransactionTender] AS
-------------------------------------------------------------------------
-- [vwFactSalesTransactionTender] is used to retrieve a
-- list of Sales Transaction Tenders
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesTransactionTender]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--          04/10/2012  EKnapp		 Added join to Client and Lead
--			1/31/2021   KMurdoch     Restricted to 2017 forward
-------------------------------------------------------------------------

	SELECT DD.[FullDate] AS [PartitionDate]
		  ,[OrderDateKey]
		  ,fstt.[SalesOrderKey]
		  ,[SalesOrderTenderKey]
		  ,fstt.[SalesOrderTypeKey]
		  ,fstt.[CenterKey]
		  ,fstt.[ClientKey]
		  ,[MembershipKey]
		  ,fstt.[ClientMembershipKey]
		  ,[TenderTypeKey]
		  ,[TenderAmount]
		  , ISNULL(CLI.contactkey, -1) AS contactkey
		  , ISNULL(lead.GenderKey, -1) AS GenderKey
		  , ISNULL(lead.OccupationKey, -1) AS OccupationKey
		  , ISNULL(lead.EthnicityKey, -1) AS EthnicityKey
		  , ISNULL(lead.MaritalStatusKey, -1) AS MaritalStatusKey
		  , ISNULL(lead.HairLossTypeKey, -1) AS HairLossTypeKey
		  , ISNULL(lead.AgeRangeKey, -1) AS AgeRangeKey
		  , ISNULL(lead.PromotionCodeKey, -1) AS PromotionCodeKey
		  , ISNULL(AccountID, -1) AS 'AccountID'
	  FROM [bi_cms_dds].[FactSalesTransactionTender] fstt
	    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
            ON so.SalesOrderKey = fstt.SalesOrderKey
		LEFT OUTER JOIN  [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
			ON fstt.[OrderDateKey] = DD.[DateKey]
		LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI WITH (NOLOCK)
			ON fstt.ClientKey = CLI.ClientKey
		LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead WITH (NOLOCK)
			ON CLI.contactkey=Lead.ContactKey
	WHERE so.OrderDate >= '01/01/2017'
