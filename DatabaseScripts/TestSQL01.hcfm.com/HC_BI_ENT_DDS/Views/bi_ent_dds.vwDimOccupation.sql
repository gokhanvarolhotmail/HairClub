/* CreateDate: 05/03/2010 12:08:49.320 , ModifyDate: 09/16/2019 09:25:18.210 */
GO
CREATE VIEW [bi_ent_dds].[vwDimOccupation]
AS
-------------------------------------------------------------------------
-- [vwDimOccupation] is used to retrieve a
-- list of Occupation
--
--   SELECT * FROM [bi_ent_dds].[vwDimOccupation]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [OccupationKey]
			  ,[OccupationSSID]
			  ,[OccupationDescription]
			  ,[OccupationDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimOccupation]
GO
