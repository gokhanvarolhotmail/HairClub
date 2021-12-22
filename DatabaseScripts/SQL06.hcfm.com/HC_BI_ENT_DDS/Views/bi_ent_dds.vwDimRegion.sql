CREATE VIEW [bi_ent_dds].[vwDimRegion]
AS
-------------------------------------------------------------------------
-- [vwDimRegion] is used to retrieve a
-- list of Regions
--
--   SELECT * FROM [bi_ent_dds].[vwDimRegion]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

SELECT [RegionKey]
      ,[RegionSSID]
      ,[RegionDescription]
      ,[RegionDescriptionShort]
      ,[RegionSortOrder]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]
      ,[RowChangeReason]
      ,[RowIsInferred]
      ,[InsertAuditKey]
      ,[UpdateAuditKey]
      ,[RowTimeStamp]
      ,[msrepl_tran_version]
  FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion]
