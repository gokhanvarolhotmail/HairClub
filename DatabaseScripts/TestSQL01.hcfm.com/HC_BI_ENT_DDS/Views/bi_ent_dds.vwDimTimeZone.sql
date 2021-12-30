/* CreateDate: 05/03/2010 12:08:49.377 , ModifyDate: 09/16/2019 09:25:18.213 */
GO
CREATE VIEW [bi_ent_dds].[vwDimTimeZone]
AS
-------------------------------------------------------------------------
-- [vwDimTimeZone] is used to retrieve a
-- list of Time Zones
--
--   SELECT * FROM [bi_ent_dds].[vwDimTimeZone]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [TimeZoneKey]
			, [TimeZoneSSID]
			, [TimeZoneDescription]
			, [TimeZoneDescriptionShort]
			, [UTCOffset]
			, [UsesDayLightSavingsFlag]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	  FROM [bi_ent_dds].[DimTimeZone]
GO
