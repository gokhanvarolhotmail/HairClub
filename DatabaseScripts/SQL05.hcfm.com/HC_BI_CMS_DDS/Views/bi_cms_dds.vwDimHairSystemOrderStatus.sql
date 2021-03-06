/* CreateDate: 06/27/2011 16:35:34.013 , ModifyDate: 10/03/2019 22:52:22.383 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemOrderStatus]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Order Statuses
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemOrderStatus]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemOrderStatusKey]
      ,[HairSystemOrderStatusSSID]
      ,[HairSystemOrderStatusSortOrder]
      ,[HairSystemOrderStatusDescription]
      ,[HairSystemOrderStatusDescriptionShort]
      ,[HairSystemOrderStatusDescriptionShort] + ' - ' + [HairSystemOrderStatusDescription]
			as 'HairSystemOrderStatusDescriptionCalc'
      ,[CanApplyFlag]
      ,[CanTransferFlag]
      ,[CanEditFlag]
      ,[IsActiveFlag]
      ,[CanCancelFlag]
      ,[IsPreallocationFlag]
      ,[CanRedoFlag]
      ,[CanRepairFlag]
      ,[ShowInHistoryFlag]
      ,[CanAddToStockFlag]
      ,[IncludeInMembershipCountFlag]
      ,[CanRequestCreditFlag]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemOrderStatus]
GO
