/* CreateDate: 01/08/2021 15:21:54.503 , ModifyDate: 01/08/2021 15:21:54.503 */
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
		, CASE WHEN time24 = 'Unknown' THEN 'UNK' ELSE LEFT([Time24],5) END AS 'Time24HM'
		, [Hour]
		, RIGHT('0' + CONVERT(VARCHAR(2), [hour]), 2) AS 'HourC'
		, [HourName]
		, [Minute]
		, RIGHT('0' + CONVERT(VARCHAR(2), [minute]), 2) AS 'MinuteC'
		, [MinuteKey]
		, [MinuteName]
		, [Second]
		, [Hour24]
		, [AM] AS 'Meridian'
		, CASE WHEN [Minute] BETWEEN 0 AND 29 THEN 0 ELSE 30 END AS '30MinuteInterval'
		, CASE	WHEN Time24 BETWEEN '00:00' AND '01:59:59' THEN 'Late Fringe'
				WHEN Time24 BETWEEN '02:00' AND '04:59:59' THEN 'Overnight'
				WHEN Time24 BETWEEN '05:00' AND '08:59:59' THEN 'Early Morning'
				WHEN Time24 BETWEEN '09:00' AND '14:59:59' THEN 'Day Time'
				WHEN Time24 BETWEEN '15:00' AND '16:59:59' THEN 'Early Fringe'
				WHEN Time24 BETWEEN '17:00' AND '18:59:59' THEN 'Early News'
				WHEN Time24 BETWEEN '19:00' AND '19:59:59' THEN 'Prime Access'
				WHEN Time24 BETWEEN '20:00' AND '22:59:59' THEN 'Prime Time'
				WHEN Time24 BETWEEN '23:00' AND '23:59:59' THEN 'Late News'
				WHEN TimeOfDayKey = -1 THEN 'Unknown'
				END AS 'DayPart'
		, CASE WHEN TimeOfDayKey <> -1 THEN LEFT(time24,2) + SUBSTRING(time24,4,2) + RIGHT(time24,2) ELSE 'Unknown' END AS 'TimeNumber'
  FROM [bief_dds].[DimTimeOfDay]
GO
