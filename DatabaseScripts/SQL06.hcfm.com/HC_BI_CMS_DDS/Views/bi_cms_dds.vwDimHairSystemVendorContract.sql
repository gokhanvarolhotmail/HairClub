/* CreateDate: 10/03/2019 23:03:43.847 , ModifyDate: 10/03/2019 23:03:43.847 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemVendorContract]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemVendorContract] is used to retrieve a
-- list of Hair System Vendor Contract records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemVendorContract]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------
SELECT [HairSystemVendorContractKey]
      ,[HairSystemVendorContractSSID]
      ,[HairSystemVendorContractName]
      ,[HairSystemVendorDescription]
      ,[HairSystemVendorDescriptionShort]
      ,[HairSystemVendorDescriptionShort] + ' - ' + [HairSystemVendorDescription]
			as 'HairSystemVendorDescriptionCalc'
      ,[HairSystemVendorContractBeginDate]
      ,[HairSystemVendorContractEndDate]
      ,[IsRepair]
      ,[IsActiveContract]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemVendorContract]
GO
