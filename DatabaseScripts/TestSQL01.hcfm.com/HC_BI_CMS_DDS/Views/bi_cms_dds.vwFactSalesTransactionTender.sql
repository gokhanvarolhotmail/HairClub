/* CreateDate: 05/03/2010 12:17:24.603 , ModifyDate: 09/16/2019 09:33:49.870 */
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesTransactionTender]
AS
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
--
-------------------------------------------------------------------------

	SELECT DD.[FullDate] AS [PartitionDate]
		  ,[OrderDateKey]
		  ,[SalesOrderKey]
		  ,[SalesOrderTenderKey]
		  ,[SalesOrderTypeKey]
		  ,fstt.[CenterKey]
		  ,fstt.[ClientKey]
		  ,[MembershipKey]
		  ,[ClientMembershipKey]
		  ,[TenderTypeKey]
		  ,[TenderAmount]
		  , ISNULL(CLI.contactkey, -1) as contactkey
		  , ISNULL(lead.GenderKey, -1) as GenderKey
		  , ISNULL(lead.OccupationKey, -1) as OccupationKey
		  , ISNULL(lead.EthnicityKey, -1) as EthnicityKey
		  , ISNULL(lead.MaritalStatusKey, -1) as MaritalStatusKey
		  , ISNULL(lead.HairLossTypeKey, -1) as HairLossTypeKey
		  , ISNULL(lead.AgeRangeKey, -1) as AgeRangeKey
		  , ISNULL(lead.PromotionCodeKey, -1) as PromotionCodeKey
		  , ISNULL(AccountID, -1) AS 'AccountID'
	  FROM [bi_cms_dds].[FactSalesTransactionTender] fstt
		LEFT OUTER JOIN  [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
			ON fstt.[OrderDateKey] = DD.[DateKey]
		LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI with (nolock)
			ON fstt.ClientKey = CLI.ClientKey
		LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead with (nolock)
			ON CLI.contactkey=Lead.ContactKey
GO
