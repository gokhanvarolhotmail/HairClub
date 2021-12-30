/* CreateDate: 04/13/2011 05:41:06.427 , ModifyDate: 09/03/2020 14:58:10.350 */
GO
CREATE FUNCTION [bief_stage].[fn_GetUTCDateTime] (@dDate AS DATETIME, @CenterSSID AS INT)
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


SELECT  @UTCDate = bief_stage.GetLocalFromUTC(@dDate, z.UTCOffset, z.UsesDayLightSavingsFlag)
FROM    bi_cms_stage.synHC_DDS_DimCenter c
        INNER JOIN bi_cms_stage.synHC_DDS_DimTimeZone z
            ON c.TimeZoneKey = z.TimeZoneKey
WHERE   c.CenterSSID = @CenterSSID


RETURN @UTCDate
END
GO
