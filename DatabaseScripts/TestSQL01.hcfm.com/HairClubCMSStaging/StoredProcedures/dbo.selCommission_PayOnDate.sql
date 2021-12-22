/* CreateDate: 05/20/2015 11:07:23.040 , ModifyDate: 05/26/2015 13:54:40.640 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				selCommission_PayOnDate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

IMPLEMENTATION DATE:	05/20/2015

==============================================================================
DESCRIPTION:	Displays a list of PayOnDate(s) for six months back and one additional PayPeriod
==============================================================================
NOTES:
==============================================================================
CHANGE HISTORY:

==============================================================================
SAMPLE EXECUTION:

EXEC [selCommission_PayOnDate]
==============================================================================
*/

CREATE PROCEDURE [dbo].[selCommission_PayOnDate]
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

SELECT * FROM

	(SELECT '1/1/1999' AS [value]
	,	'All' AS [description]
	UNION
	SELECT CAST(PayDate AS DATE) AS [value]
	,	CAST(PayDate AS NVARCHAR(12)) AS [description]
	FROM [dbo].[Commission_lkpPayPeriods_TABLE]
	WHERE PayDate BETWEEN @BeginDate AND @EndDate) q

ORDER BY [value] DESC


END
GO
