/* CreateDate: 09/03/2021 09:37:07.907 , ModifyDate: 09/03/2021 09:37:07.907 */
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
