/* CreateDate: 01/08/2021 15:21:54.520 , ModifyDate: 01/08/2021 15:21:54.520 */
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
