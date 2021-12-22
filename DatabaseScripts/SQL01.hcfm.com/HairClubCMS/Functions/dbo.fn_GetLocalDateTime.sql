/* CreateDate: 01/10/2012 08:49:31.443 , ModifyDate: 11/09/2016 12:20:25.410 */
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
CREATE FUNCTION [dbo].[fn_GetLocalDateTime]
(
	@Time DATETIME, @CenterID INT
)
RETURNS DATETIME
AS
BEGIN

DECLARE @UTCTime DATETIME

SELECT  @UTCTime = dbo.GetLocalFromUTC(@Time, z.UTCOffset, z.UsesDayLightSavingsFlag)
FROM    dbo.cfgCenter c
        INNER JOIN dbo.lkpTimeZone z
            ON z.TimeZoneID = c.TimeZoneID
WHERE   c.CenterID = @CenterID


RETURN @UTCTime

END
GO
