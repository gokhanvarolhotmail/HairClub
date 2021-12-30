/* CreateDate: 05/03/2010 12:08:49.280 , ModifyDate: 10/03/2019 21:37:25.077 */
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
