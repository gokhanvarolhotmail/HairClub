/* CreateDate: 01/08/2021 15:21:54.410 , ModifyDate: 01/08/2021 15:21:54.410 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_ent_dds].[vwDimHairLossType]
AS
-------------------------------------------------------------------------
-- [vwDimHairLossType] is used to retrieve a
-- list of HairLossType
--
--   SELECT * FROM [bi_ent_dds].[vwDimHairLossType]
--
-------------------------------------------------------------------------
-- Change History

-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------


SELECT [HairLossTypeKey]
      ,[HairLossTypeSSID]
      ,[HairLossTypeDescription]
      ,[HairLossTypeDescriptionShort]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]
  FROM [bi_ent_dds].[DimHairLossType]
GO
