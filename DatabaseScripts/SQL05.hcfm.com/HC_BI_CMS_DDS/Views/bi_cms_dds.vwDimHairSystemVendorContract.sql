/* CreateDate: 06/27/2011 16:35:33.930 , ModifyDate: 10/03/2019 22:52:22.527 */
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
