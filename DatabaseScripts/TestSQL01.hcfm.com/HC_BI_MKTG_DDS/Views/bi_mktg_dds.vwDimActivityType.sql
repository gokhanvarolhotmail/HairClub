/* CreateDate: 05/03/2010 12:21:10.780 , ModifyDate: 01/27/2022 09:18:11.500 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimActivityType]
AS
-------------------------------------------------------------------------
-- [vwDimActivityType] is used to retrieve a
-- list of ActivityType
--
--   SELECT * FROM [bi_mktg_dds].[vwDimActivityType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [ActivityTypeKey]
			  ,[ActivityTypeSSID]
			  ,[ActivityTypeDescription]
			  ,[ActivityTypeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimActivityType]
GO
