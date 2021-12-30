/* CreateDate: 12/11/2012 14:57:18.937 , ModifyDate: 12/11/2012 14:57:18.937 */
GO
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

	SELECT @UTCDate =
		DATEADD(HOUR,
			CASE WHEN z.UsesDayLightSavingsFlag = 0 THEN ( z.[UTCOffset] )
				WHEN DATEPART(WK, @dDate) <= 10 OR DATEPART(WK, @dDate) >= 45 THEN ( z.[UTCOffset] )
				ELSE ( ( z.[UTCOffset] ) - 1 )
			END, @dDate
		)
	FROM HairClubCMS.dbo.cfgCenter c
		INNER JOIN [HairClubCMS].dbo.lkpTimeZone z
			ON c.TimeZoneID = z.TimeZoneID
    WHERE  c.CenterID = @CenterSSID

    RETURN @UTCDate


	--DECLARE @UsesDayLightSavingsFlag BIT
	--DECLARE @UTCOffset INT
	--DECLARE @DST BIT
	--DECLARE @sUTCOffset CHAR(6)
	--DECLARE @UTCDate DATETIME

	--DECLARE @DSTStartDate DATETIME
	--DECLARE @DSTEndDate DATETIME

	--SELECT @UsesDayLightSavingsFlag = UsesDayLightSavingsFlag, @UTCOffset = UTCOffset
	--FROM   bi_cms_stage.synHC_DDS_DimCenter c INNER JOIN
 --          bi_cms_stage.synHC_DDS_DimTimeZone z ON c.TimeZoneKey = z.TimeZoneKey
 --   WHERE  c.CenterSSID = @CenterSSID

	------We are trying to add hours not subtract them.
 ----   SET @UTCOffset = @UTCOffset * -1


	--IF DATEPART(YYYY,@dDate) >= 2007
	--  BEGIN
	--   --New DST Figure out 2nd Sunday in March and First Sunday in November
	--     SELECT @DSTStartDate = MIN(FullDate)
	--		FROM bi_cms_stage.synHC_DDS_DimDate
	--		where YearNumber = DatePart(YYYY,@dDate) and MonthNumber = 3 and DayOfWeekName = 'Sunday'
	--	 --Just got first Sunday, now add 7 days to it
	--	 SET @DSTStartDate = DATEADD(DD,7,@DSTStartDate)
	--     SELECT @DSTEndDate = MAX(FullDate)
	--		FROM bi_cms_stage.synHC_DDS_DimDate
	--		where YearNumber = DatePart(YYYY,@dDate) and MonthNumber = 11 and DayOfWeekName = 'Sunday'
	--   END
	--ELSE
	--  BEGIN
	--     --Old DST rules, so figure out 1st Sunday in April and Last Sunday in October
	--     SELECT @DSTStartDate = MIN(FullDate)
	--		FROM bi_cms_stage.synHC_DDS_DimDate
	--		where YearNumber = DatePart(YYYY,@dDate) and MonthNumber = 4 and DayOfWeekName = 'Sunday'
	--     SELECT @DSTEndDate = MAX(FullDate)
	--		FROM bi_cms_stage.synHC_DDS_DimDate
	--		where YearNumber = DatePart(YYYY,@dDate) and MonthNumber = 10 and DayOfWeekName = 'Sunday'
	--   END

	----DST Begins at 2AM
	-- SET @DSTStartDate = DATEADD(HH,2, @DSTStartDate)
	-- SET @DSTEndDate = DATEADD(HH,2, @DSTEndDate)

	-- --Convert to UTC
	-- SET @UTCDate = DATEADD(HH, @UTCOffset, @dDate)


	------If the center uses DST, need to see if DST was in
	--IF @UsesDayLightSavingsFlag = 1
	-- BEGIN
	--  IF @dDate BETWEEN  @DSTStartDate AND @dDate
	--    BEGIN  --Spring Ahead
	--      SET @UTCDate = DATEADD(HH, -1, @UTCDate)
	--    END
	--   ELSE
	--	BEGIN  --Fall Back
	--	  SET @UTCDate = DATEADD(HH, 1, @UTCDate)
	--	END
	-- END
	------ Return the result of the function
	--RETURN @UTCDate
	--RETURN @UTCDate -- temporary  EWK
END
GO
