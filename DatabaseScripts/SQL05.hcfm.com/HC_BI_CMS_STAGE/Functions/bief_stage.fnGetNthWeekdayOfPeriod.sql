/* CreateDate: 04/13/2011 07:45:06.543 , ModifyDate: 04/13/2011 07:45:06.543 */
GO
CREATE FUNCTION [bief_stage].[fnGetNthWeekdayOfPeriod]
 (
 @theDate DATETIME,
 @theWeekday TINYINT,
 @theNth SMALLINT,
 @theType CHAR(1)
 )

-----------------------------------------------------------------------
-- [fnGetNthWeekdayOfPeriod]
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  CFleming     Initial Creation
-----------------------------------------------------------------------

 RETURNS DATETIME

 BEGIN
 RETURN (
 SELECT theDate
 FROM (
 SELECT DATEADD(DAY, theDelta +(@theWeekday + 6 - DATEDIFF(DAY, '17530101', theFirst) % 7) % 7, theFirst) AS theDate
 FROM (
 SELECT CASE UPPER(@theType)
 WHEN 'M' THEN DATEADD(MONTH, DATEDIFF(MONTH, @theNth, @theDate), '19000101')
 WHEN 'Q' THEN DATEADD(QUARTER, DATEDIFF(QUARTER, @theNth, @theDate), '19000101')
 WHEN 'Y' THEN DATEADD(YEAR, DATEDIFF(YEAR, @theNth, @theDate), '19000101')
 END AS theFirst,
 CASE SIGN(@theNth)
 WHEN -1 THEN 7 * @theNth
 WHEN 1 THEN 7 * @theNth - 7
 END AS theDelta
 WHERE @theWeekday BETWEEN 1 AND 7
 AND (
 @theNth BETWEEN -5 AND 5
 AND UPPER(@theType) = 'M'
 OR
 @theNth BETWEEN -14 AND 14
 AND UPPER(@theType) = 'Q'
 OR
 @theNth BETWEEN -53 AND 53
 AND UPPER(@theType) = 'Y'
 )
 AND @theNth <> 0
 ) AS d
 ) AS d
 WHERE CASE UPPER(@theType)
 WHEN 'M' THEN DATEDIFF(MONTH, theDate, @theDate)
WHEN 'Q' THEN DATEDIFF(QUARTER, theDate, @theDate)
WHEN 'Y' THEN DATEDIFF(YEAR, theDate, @theDate)
END = 0
 )
 END
GO
