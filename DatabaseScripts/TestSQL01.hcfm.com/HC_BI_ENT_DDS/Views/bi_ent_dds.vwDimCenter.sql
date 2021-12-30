/* CreateDate: 05/03/2010 12:08:49.153 , ModifyDate: 09/16/2019 09:25:18.200 */
GO
CREATE VIEW [bi_ent_dds].[vwDimCenter]
AS
-------------------------------------------------------------------------
-- [vwDimCenter] is used to retrieve a
-- list of Centers
--
--   SELECT REGIONOM,* FROM [bi_ent_dds].[vwDimCenter] WHERE CENTERSSID LIKE '[278]%'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--			07/22/2013	MBurrell	 Filtered out inactive centers
--			10/15/2013  KMurdoch     Added in Regional roll-up guids
--			02/21/2017	RHut		 Added AND c.CenterSSID LIKE '[78]%'to RegionOM statement; Changed RegionOM to RegionAM
--			02/22/2017  KMurdoch	 Added CenterNumber
-------------------------------------------------------------------------

	SELECT	  c.[CenterKey]
			, c.[CenterSSID]
			, c.[CenterNumber]
			, c.[RegionKey]
			, c.[RegionSSID]
			, c.[TimeZoneKey]
			, c.[TimeZoneSSID]
			, c.[CenterTypeKey]
			, c.[CenterTypeSSID]
			, c.[DoctorRegionKey]
			, c.[DoctorRegionSSID]
			, c.[CenterOwnershipKey]
			, c.[CenterOwnershipSSID]
			, c.[CenterDescription]
			, c.[CenterDescriptionNumber]
			, c.[CenterAddress1]
			, c.[CenterAddress2]
			, c.[CenterAddress3]
			, c.[CountryRegionDescription]
			, c.[CountryRegionDescriptionShort]
			, c.[StateProvinceDescription]
			, c.[StateProvinceDescriptionShort]
			, c.[City]
			, c.[PostalCode]
			, c.[CenterPhone1]
			, c.[Phone1TypeSSID]
			, c.[CenterPhone1TypeDescription]
			, c.[CenterPhone1TypeDescriptionShort]
			, c.[CenterPhone2]
			, c.[Phone2TypeSSID]
			, c.[CenterPhone2TypeDescription]
			, c.[CenterPhone2TypeDescriptionShort]
			, c.[CenterPhone3]
			, c.[Phone3TypeSSID]
			, c.[CenterPhone3TypeDescription]
			, c.[CenterPhone3TypeDescriptionShort]
			, c.[Active]
			, c.[RowIsCurrent]
			, c.[RowStartDate]
			, c.[RowEndDate]
			, c.[ReportingCenterSSID]
			, c.[ReportingCenterKey]
			, c.RegionRSMMembershipAdvisorSSID
			, 'Region-MA-'+ma.EmployeeLastName AS 'RegionMA'
			, c.RegionRSMNBConsultantSSID
			, 'Region-NB1-'+nb.EmployeeLastName AS 'RegionNB1'
			, c.RegionRTMTechnicalManagerSSID
			, 'Region-TM-'+tm.EmployeeLastName AS 'RegionTM'
			, c.RegionROMOperationsManagerSSID
			, 'Area-'+ CASE WHEN (CMA.CenterManagementAreaSSID IS NULL AND c.CenterSSID <> 100 AND c.CenterSSID LIKE '[78]%') THEN 'Franchise'
							WHEN C.CenterSSID = 100 THEN 'Corporate' ELSE CMA.CenterManagementAreaDescription END  AS 'RegionAM'
			, [c].[NewBusinessSize] AS 'NBSize'
			, [c].[RecurringBusinessSize] AS 'RRSize'
				FROM [bi_ent_dds].[DimCenter] c
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee ma
			ON c.[RegionRSMMembershipAdvisorSSID] = ma.EmployeeSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee nb
			ON c.RegionRSMNBConsultantSSID = nb.EmployeeSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee tm
			ON c.RegionRTMTechnicalManagerSSID = tm.EmployeeSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee om
			ON c.RegionROMOperationsManagerSSID = om.EmployeeSSID
		LEFT OUTER JOIN bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = c.CenterManagementAreaSSID
	--WHERE Active='Y'
GO
