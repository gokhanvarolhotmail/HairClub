/* CreateDate: 05/03/2010 12:08:49.333 , ModifyDate: 10/03/2019 21:37:25.130 */
GO
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
GO
