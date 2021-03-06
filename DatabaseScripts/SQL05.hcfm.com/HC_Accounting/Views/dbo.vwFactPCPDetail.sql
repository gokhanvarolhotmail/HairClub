/* CreateDate: 03/26/2013 13:31:20.940 , ModifyDate: 03/24/2017 12:29:20.537 */
GO
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/22/2010  RLifke       Initial Creation
--  v1.2	06/03/2014	Kmurdoch	 Added Demographics
--  v1.3    07/10/2015  KMurdoch     Added XTR
--  v1.4    12/10/2015  RHut		 Added ISNULL(p.[XTR],0) (#121340)
--			03/24/2017  KMurdoch     Amended AgeRangeKey

CREATE VIEW [dbo].[vwFactPCPDetail]
AS
SELECT [ID]
      ,p.[CenterKey]
      ,p.[ClientKey]
      ,ISNULL(p.[GenderKey],1) AS 'GenderKey'
      ,ISNULL(p.[MembershipKey],-1) AS 'MembershipKey'
      ,p.[DateKey]
      ,p.[PCP] AS 'ActivePCP'
      ,p.[EXT] AS 'ActiveEXT'
	  ,p.[PCP] - p.[EXT]  - ISNULL(p.[XTR],0) AS 'ActiveBIO'
	  ,ISNULL(p.[XTR],0) AS 'ActiveXTR'
      ,p.[Timestamp]
	  ,ISNULL(l.[SourceKey],-1) AS SourceKey
	  ,ISNULL(do.[OccupationKey],-1) AS OccupationKey
	  ,ISNULL(de.[EthnicityKey],-1) AS EthnicityKey
	  ,ISNULL(dms.[MaritalStatusKey],-1) AS MaritalStatusKey
	  ,ISNULL( CASE WHEN c.ClientDateOfBirth IS NULL AND l.AgeRangeKey <> -1 THEN l.AgeRangeKey
				ELSE ISNULL(DAR.AgeRangeKey,-1) END,-1) AS AgeRangeKey
  FROM [dbo].[FactPCPDetail] p
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient c
		ON c.ClientKey = p.ClientKey
	LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead l
		ON l.ContactKey = c.contactkey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity AS DE
		ON DE.EthnicitySSID = c.EthinicitySSID
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation AS DO
		ON do.OccupationSSID = c.OccupationSSID
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus AS DMS
		ON DMS.MaritalStatusSSID = c.MaritalStatusSSID
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange DAR
		ON ISNULL( DATEDIFF(YEAR, c.ClientDateOfBirth, GETDATE()),0) BETWEEN DAR.BeginAge AND DAR.EndAge
GO
