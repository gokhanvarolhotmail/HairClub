/* CreateDate: 05/20/2015 08:49:24.790 , ModifyDate: 05/20/2015 08:50:41.027 */
GO
/*
==============================================================================

PROCEDURE:				selCommission_lkpPayPeriods

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

IMPLEMENTATION DATE:	05/20/2015

==============================================================================
DESCRIPTION:	Displays a list of PayPeriods for six months back and one additional PayPeriod
==============================================================================
NOTES:
==============================================================================
CHANGE HISTORY:

==============================================================================
SAMPLE EXECUTION:

EXEC [selCommission_lkpPayPeriods]
==============================================================================
*/

CREATE PROCEDURE [dbo].[selCommission_lkpPayPeriods]
AS

BEGIN
SET NOCOUNT ON

--Beginning of the month and six months ago

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginDate DATETIME

SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
SET @EndDate = (SELECT MIN(PayDate) FROM [dbo].[Commission_lkpPayPeriods_TABLE] WHERE PayDate > GETUTCDATE())
SET @BeginDate = DATEADD(MONTH,-6,@StartDate)					--Six months ago

PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))
PRINT '@BeginDate = ' + CAST(@BeginDate AS VARCHAR(100))


SELECT '1/1/1999' AS [value]
,	'All' AS [description]
UNION
SELECT PayDate AS [value]
,	CAST(PayDate AS NVARCHAR(12)) AS [description]
FROM [dbo].[Commission_lkpPayPeriods_TABLE]
WHERE PayDate BETWEEN @BeginDate AND @EndDate


END
GO
