/* CreateDate: 11/18/2016 13:25:04.873 , ModifyDate: 11/18/2016 13:25:04.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION itvf_GetLocalFromUTC
(
	@MyDate DATETIME,
	@CenterId INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT
		ctr.CenterId,
		tz.TimeZoneID,
		CASE
			WHEN tz.UsesDayLightSavingsFlag = 1 AND @MyDate >= ds.DSTStartDate AND @MyDate < ds.DSTEndDate THEN DATEADD(HOUR, (tz.UTCOffset + 1), @MyDate)
			ELSE DATEADD(HOUR, tz.UTCOffset, @MyDate)
		END AS LocalDate
	FROM
		cfgCenter ctr
	INNER JOIN
		lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
	JOIN
		dbo.lkpDaylightSavings ds ON ds.[Year] = DATEPART(YEAR, @MyDate)
	WHERE
		1=1
		AND ctr.CenterID = @CenterId
		AND ds.[Year] = DATEPART(YEAR, @MyDate)
)
GO
