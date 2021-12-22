/* CreateDate: 05/03/2010 12:08:49.363 , ModifyDate: 09/16/2019 09:25:18.213 */
GO
CREATE VIEW [bi_ent_dds].[vwDimTimeOfDay]
AS
-------------------------------------------------------------------------
-- [vwDimTimeOfDay] is used to retrieve a
-- list of Times Of the Day
--
--   SELECT * FROM [bi_ent_dds].[vwDimTimeOfDay]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

SELECT	  [TimeOfDayKey]
		, [Time]
		, [Time24]
		, [Hour]
		, [HourName]
		, [Minute]
		, [MinuteKey]
		, [MinuteName]
		, [Second]
		, [Hour24]
		, [AM]
  FROM [bief_dds].[DimTimeOfDay]
GO
