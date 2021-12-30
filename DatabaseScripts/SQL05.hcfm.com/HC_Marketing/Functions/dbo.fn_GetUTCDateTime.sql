/* CreateDate: 09/03/2020 14:59:46.490 , ModifyDate: 09/03/2020 15:05:42.190 */
GO
CREATE FUNCTION [dbo].[fn_GetUTCDateTime] (@dDate AS DATETIME, @CenterSSID AS INT)
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
-----------------------------------------------------------------------
RETURNS DATETIME AS
BEGIN

DECLARE @UTCDate DATETIME


SELECT  @UTCDate = dbo.GetLocalFromUTC(@dDate, z.UTCOffset, z.UsesDayLightSavingsFlag)
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimTimeZone z
            ON c.TimeZoneKey = z.TimeZoneKey
WHERE   c.CenterSSID = @CenterSSID


RETURN @UTCDate
END
GO
