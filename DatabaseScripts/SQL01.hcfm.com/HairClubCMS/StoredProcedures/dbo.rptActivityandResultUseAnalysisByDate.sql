/*===============================================================================================
 Procedure Name:            [rptActivityandResultUseAnalysisByDate]
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use per Center
 Created By:				Rachelen Hut
 Date Created:              02/26/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
NOTES:
 @MainGroupID = 1 for "By Regions" (including Franchises as one region)
 @MainGroupID = 2 for "By Area Managers" (no Franchise centers)

================================================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/09/2017 - RH - (#136702) Added Overdue as a status
11/22/2019 - RH - (TrackIT 2161) Removed MainGroupID as a parameter
================================================================================================
SAMPLE EXECUTION:

[rptActivityandResultUseAnalysisByDate]  1, '10/1/2019','10/31/2019'

[rptActivityandResultUseAnalysisByDate]  2, '10/1/2019','10/31/2019'

[rptActivityandResultUseAnalysisByDate]  3, NULL, NULL


================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisByDate](
		@DateType INT				--1 is CreateDate; 2 is DueDate; 3 is No Date
	,	@StartDate DATETIME
	,	@EndDate DATETIME

	)

AS
BEGIN

--SET @StartDate to '1/1/1990' if it is NULL

IF @StartDate = '1/1/1900'
BEGIN
SET @StartDate = NULL
END

--SET @EndDate to '1/1/1990' if it is NULL

IF @EndDate = '1/1/1900'
BEGIN
SET @EndDate = NULL
END

/************ SET @OverdueDate to today at 12:00 AM **********************************************/

DECLARE @OverdueDate DATETIME
SET @OverdueDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)					--Today at 12:00AM

/***************Create temp tables ***************************************************************/

CREATE TABLE #Centers(
		MainGroupID INT
	,	MainGroupDescription NVARCHAR(103)
	,	CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(103)
	,	SortOrder INT
)

CREATE TABLE #Activity(ActivityID INT
,	MasterActivityID INT
,	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ActivitySubCategoryID INT
,	ActivitySubCategoryDescription NVARCHAR(100)
,	ActivityCategoryID INT
,	ActivityCategoryDescription NVARCHAR(100)
,	ActivityActionID INT
,	ActivityActionDescription NVARCHAR(100)
,	ActivityResultID INT
,	ActivityResultDescription NVARCHAR(100)
,	DueDate DATETIME
,	ActivityPriorityID INT
,	ActivityPriorityDescription NVARCHAR(100)
,	ActivityNote  NVARCHAR(MAX)
,	CreatedByEmployeeGUID UNIQUEIDENTIFIER
,	CreatedByEmp NVARCHAR(102)
,	AssignedToEmployeeGUID UNIQUEIDENTIFIER
,	AssignedToEmp NVARCHAR(102)
,	CompletedByEmployeeGUID UNIQUEIDENTIFIER
,	CompletedByEmp NVARCHAR(102)
,	CompletedDate DATETIME
,	CreateDate DATETIME
,	Pending INT
,	IsOpen INT
,	Closed INT
,	ActivityStatusID INT
)

/*************************** Find Centers *************************************************************************/

			--By Area Managers
INSERT INTO #Centers
SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
	,	CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
	,	C.CenterID
	,	C.CenterDescriptionFullCalc
	,	CMA.CenterManagementAreaSortOrder AS 'SortOrder'
FROM dbo.cfgCenter C
INNER JOIN dbo.cfgCenterManagementArea CMA
	ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
INNER JOIN dbo.lkpCenterType CT
	ON CT.CenterTypeID = C.CenterTypeID
WHERE CT.CenterTypeDescriptionShort = 'C'
	AND C.IsActiveFlag = 1


/*************** Select according to the selected Date Type ********************************/

IF @DateType = 1  --By CreateDate
BEGIN
	INSERT INTO #Activity
	SELECT A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
	,	A.ClientGUID
	,	A.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription
	,	SUB.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	A.ActivityActionID
	,	AA.ActivityActionDescription
	,	A.ActivityResultID
	,	AR.ActivityResultDescription
	,	A.DueDate
	,	A.ActivityPriorityID
	,	AP.ActivityPriorityDescription
	,	A.ActivityNote
	,	A.CreatedByEmployeeGUID
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	A.AssignedToEmployeeGUID
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.CompletedByEmployeeGUID
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.CompletedDate
	,	A.CreateDate
	,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	FROM datActivity A
	INNER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	INNER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	INNER JOIN lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	INNER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	INNER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CREATED.CenterID = CTR.CenterID
	WHERE A.CreateDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF @DateType = 2	--By DueDate
BEGIN
	INSERT INTO #Activity
	SELECT A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
	,	A.ClientGUID
	,	A.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription
	,	SUB.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	A.ActivityActionID
	,	AA.ActivityActionDescription
	,	A.ActivityResultID
	,	AR.ActivityResultDescription
	,	A.DueDate
	,	A.ActivityPriorityID
	,	AP.ActivityPriorityDescription
	,	A.ActivityNote
	,	A.CreatedByEmployeeGUID
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	A.AssignedToEmployeeGUID
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.CompletedByEmployeeGUID
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.CompletedDate
	,	A.CreateDate
	,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	FROM datActivity A
	INNER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	INNER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	INNER JOIN lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	INNER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	INNER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CREATED.CenterID = CTR.CenterID
	WHERE A.DueDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF @DateType = 3	--By No Date
BEGIN
	INSERT INTO #Activity
	SELECT A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
	,	A.ClientGUID
	,	A.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription
	,	SUB.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	A.ActivityActionID
	,	AA.ActivityActionDescription
	,	A.ActivityResultID
	,	AR.ActivityResultDescription
	,	A.DueDate
	,	A.ActivityPriorityID
	,	AP.ActivityPriorityDescription
	,	A.ActivityNote
	,	A.CreatedByEmployeeGUID
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	A.AssignedToEmployeeGUID
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.CompletedByEmployeeGUID
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.CompletedDate
	,	A.CreateDate
	,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
	,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	FROM datActivity A
	INNER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	INNER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	INNER JOIN lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	INNER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	INNER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CREATED.CenterID = CTR.CenterID

END

/***** Find Overdue *****************************************************************************/

SELECT ActivityID
     , MasterActivityID
     , CenterID
     , ClientGUID
     , ActivityStatusID
     , DueDate
	 ,	CASE WHEN (Pending = 1 OR IsOpen = 1 AND @OverdueDate > DueDate) THEN 1
		 ELSE 0
		 END AS  'Overdue'
INTO #Overdue
FROM #Activity



/***** SUM the values for the Summary report *******************************************************/

SELECT CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescriptionFullCalc
,	COUNT(ACT.ActivityID) AS TotalCreated
,	SUM(CASE WHEN ActivityCategoryID = 1 THEN 1 ELSE 0 END) AS 'CustSvcQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 1 THEN 1 ELSE 0 END) AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'CustSvcQtyPercent'
,	SUM(CASE WHEN ActivityCategoryID = 2 THEN 1 ELSE 0 END)  AS 'TechnicalQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 2 THEN 1 ELSE 0 END)AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'TechnicalQtyPercent'
,	SUM(CASE WHEN ActivityCategoryID = 3 THEN 1 ELSE 0 END) AS 'FinancialQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 3 THEN 1 ELSE 0 END)AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'FinancialQtyPercent'
,	SUM(CASE WHEN ActivityCategoryID = 4 THEN 1 ELSE 0 END) AS 'SalesQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 4 THEN 1 ELSE 0 END)AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'SalesQtyPercent'

,	SUM(CASE WHEN ActivityCategoryID = 1 AND Pending = 1 THEN 1 ELSE 0 END ) AS 'CustSvcPending'
,	SUM(CASE WHEN ActivityCategoryID = 1 AND IsOpen = 1 THEN 1 ELSE 0 END ) AS 'CustSvcOpen'
,	SUM(CASE WHEN ActivityCategoryID = 1 AND Closed = 1 THEN 1 ELSE 0 END ) AS 'CustSvcClosed'
,	SUM(CASE WHEN (ActivityCategoryID = 1 AND (Pending = 1 OR IsOpen = 1) AND @OverdueDate > ACT.DueDate) THEN 1 ELSE 0 END ) AS 'CustSvcOverdue'

,	SUM(CASE WHEN ActivityCategoryID = 2 AND Pending = 1 THEN 1 ELSE 0 END ) AS 'TechnicalPending'
,	SUM(CASE WHEN ActivityCategoryID = 2 AND IsOpen = 1 THEN 1 ELSE 0 END ) AS 'TechnicalOpen'
,	SUM(CASE WHEN ActivityCategoryID = 2 AND Closed = 1 THEN 1 ELSE 0 END ) AS 'TechnicalClosed'
,	SUM(CASE WHEN (ActivityCategoryID = 2 AND (Pending = 1 OR IsOpen = 1) AND @OverdueDate > ACT.DueDate) THEN 1 ELSE 0 END ) AS 'TechnicalOverdue'

,	SUM(CASE WHEN ActivityCategoryID = 3 AND Pending = 1 THEN 1 ELSE 0 END ) AS 'FinancialPending'
,	SUM(CASE WHEN ActivityCategoryID = 3 AND IsOpen = 1 THEN 1 ELSE 0 END ) AS 'FinancialOpen'
,	SUM(CASE WHEN ActivityCategoryID = 3 AND Closed = 1 THEN 1 ELSE 0 END ) AS 'FinancialClosed'
,	SUM(CASE WHEN (ActivityCategoryID = 3 AND (Pending = 1 OR IsOpen = 1) AND @OverdueDate > ACT.DueDate) THEN 1 ELSE 0 END ) AS 'FinancialOverdue'

,	SUM(CASE WHEN ActivityCategoryID = 4 AND Pending = 1 THEN 1 ELSE 0 END ) AS 'SalesPending'
,	SUM(CASE WHEN ActivityCategoryID = 4 AND IsOpen = 1 THEN 1 ELSE 0 END ) AS 'SalesOpen'
,	SUM(CASE WHEN ActivityCategoryID = 4 AND Closed = 1 THEN 1 ELSE 0 END ) AS 'SalesClosed'
,	SUM(CASE WHEN (ActivityCategoryID = 4 AND (Pending = 1 OR IsOpen = 1) AND @OverdueDate > ACT.DueDate) THEN 1 ELSE 0 END ) AS 'SalesOverdue'
FROM #Activity ACT
INNER JOIN #Centers CTR
	ON ACT.CenterID = CTR.CenterID
LEFT JOIN #Overdue
	ON ACT.ActivityID = #Overdue.ActivityID
GROUP BY CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescriptionFullCalc

END
