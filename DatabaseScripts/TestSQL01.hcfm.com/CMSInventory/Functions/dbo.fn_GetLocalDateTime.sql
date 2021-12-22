/* CreateDate: 01/10/2012 08:49:36.803 , ModifyDate: 01/10/2012 08:50:27.467 */
GO
/***********************************************************************
PROCEDURE: 				[fn_GetLocalDateTime]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	CMSInventory
AUTHOR:					Hung Du
DATE IMPLEMENTED:		2012-01-09
--------------------------------------------------------------------------------------------------------
NOTES: Converts UTC DateTime to Local Time for specific Center
--------------------------------------------------------------------------------------------------------
Sample Execution:
SELECT dbo.[fn_GetLocalDateTime] ('2011-12-24 23:55:22.000', '282')
***********************************************************************/
CREATE FUNCTION [fn_GetLocalDateTime]
(
	@Time DATETIME, @CenterID INT
)
RETURNS DATETIME
AS
BEGIN

	DECLARE @UTCTime DATETIME

	SELECT @UTCTime =
	DATEADD(Hour, CASE WHEN z.[UsesDayLightSavingsFlag] = 0 THEN ( z.[UTCOffset] )
	   WHEN DATEPART(WK, @Time) <= 10
			OR DATEPART(WK, @Time) >= 45 THEN ( z.[UTCOffset] )
	   ELSE ( ( z.[UTCOffset] ) + 1 )
	END, @Time)

	FROM HairClubCMS.dbo.cfgCenter c
	INNER JOIN HairClubCMS.dbo.lkpTimeZone z ON z.TimeZoneID = c.TimeZoneID
	WHERE c.CenterID = @CenterID


	RETURN @UTCTIME

END
GO
