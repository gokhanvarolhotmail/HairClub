CREATE FUNCTION [dbo].[fn_GetSTDDateFromUTC] (@dDate as DATETIME, @CenterSSID as INT)
-----------------------------------------------------------------------
-- [fn_GetUTCDateTime] Takes in a date and a center and returns a
-- converted FROM UTC Date and Time
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  CFleming     Initial Creation
-- DayLightSavings Rules:
-- Currently begins at 2:00 a.m. on the second Sunday of March and
-- ends at 2:00 a.m. on the first Sunday of November
--
-- In 2011, DST is from 2:00 a.m. (local time) on March 13th until
-- 2:00 a.m. (local time) on November 6th.
--
-- From 1987 through 2006, DST was in effect the first Sunday in April
-- through the last Sunday in October
--
-- SELECT [dbo].[fn_GetSTDDateFromUTC]('2010-05-29 16:54:00',210)
-- SELECT TransactionView.dbo.[fn_GetUTCDateTime]('2010-05-29 16:54:00',210)
-----------------------------------------------------------------------
RETURNS DATETIME AS
BEGIN

DECLARE @UTCDate DATETIME

SELECT  @UTCDate = dbo.GetLocalFromUTC(@dDate, z.UTCOffset, z.UsesDayLightSavingsFlag)
FROM    dbo.cfgCenter c
        INNER JOIN dbo.lkpTimeZone z
            ON c.TimeZoneID = z.TimeZoneID
WHERE   c.CenterID = @CenterSSID

RETURN @UTCDate
END
