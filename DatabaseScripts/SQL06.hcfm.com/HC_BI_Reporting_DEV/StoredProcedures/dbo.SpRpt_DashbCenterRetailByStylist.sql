/* CreateDate: 03/02/2015 12:53:27.473 , ModifyDate: 07/29/2015 10:04:18.853 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenterRetailByStylist]
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              02/26/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash 90 Day Protocol for Today
================================================================================================
CHANGE HISTORY:
07/01/2015 - RH - Added WHERE RetailAmt <> 0; Changed CenterSSID join to the Employee table
07/29/2015 - RH - Added Ranking to eliminate duplicates when an employee has more than one employee position
================================================================================================
NOTES:

================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenterRetailByStylist] 218

================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenterRetailByStylist]
	@CenterSSID INT
AS
BEGIN

	DECLARE	@StartDate DATETIME
		,	@EndDate DATETIME

	SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month
	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) ))													--Today at 11:59PM

	--For Testing on the weekend

	--SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()-2),0)
	--SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()-1),0) ))

	PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))

	CREATE TABLE #retail(RetailID INT IDENTITY(1,1)
	,	EmployeeFirstName VARCHAR(50)
		,	EmployeeLastName  VARCHAR(50)
		,	EmployeeSSID UNIQUEIDENTIFIER
		,	EmployeeInitials  VARCHAR(5)
		,	RetailAmt MONEY
		,	StartDate DATETIME
		,	EndDate DATETIME
	)

	SELECT e.EmployeeFirstName
		,	e.EmployeeLastName
		,	e.EmployeeSSID
		,	e.EmployeeInitials
		,	ep.EmployeePositionDescription
		,	SUM(ISNULL(fst.RetailAmt,0)) AS 'RetailAmt'
		,	@StartDate AS 'StartDate'
		,	@EndDate AS 'EndDate'
		,	ROW_NUMBER() OVER(PARTITION BY EmployeeSSID ORDER BY EmployeePositionDescription DESC) AS 'Ranking'
	INTO #stylist
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON fst.OrderDateKey = dd.DateKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
			ON fst.Employee2Key = e.EmployeeKey
			INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePositionJoin epj
			ON e.EmployeeSSID = epj.EmployeeGUID
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON e.CenterSSID = ce.CenterSSID
	WHERE dd.FullDate BETWEEN @StartDate AND @EndDate
		AND e.IsActiveFlag = 1
		AND ce.CenterSSID = @CenterSSID
		AND ep.EmployeePositionDescription IN( 'Stylist','Franchise Stylist Supervisor','Stylist Supervisor')
	GROUP BY e.EmployeeFirstName
		,	e.EmployeeLastName
		,	e.EmployeeSSID
		,	e.EmployeeInitials
		,	ep.EmployeePositionDescription

	INSERT INTO #retail
	SELECT EmployeeFirstName
         , EmployeeLastName
         , EmployeeSSID
         , EmployeeInitials
         , SUM(RetailAmt) AS 'RetailAmt'
         , StartDate
         , EndDate
	FROM #stylist
	WHERE Ranking = 1
	GROUP BY EmployeeFirstName
         , EmployeeLastName
         , EmployeeSSID
         , EmployeeInitials
         , StartDate
         , EndDate
	ORDER BY RetailAmt DESC  --KEEP ORDER BY for ID column for the chart 50% - 50%

	SELECT * FROM #retail
	WHERE RetailAmt <> 0


END
GO
