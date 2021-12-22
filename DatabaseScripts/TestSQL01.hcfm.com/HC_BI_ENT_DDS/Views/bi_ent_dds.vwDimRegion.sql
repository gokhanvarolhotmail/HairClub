/* CreateDate: 05/03/2010 12:08:49.333 , ModifyDate: 09/16/2019 09:25:18.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
