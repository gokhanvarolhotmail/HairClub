/* CreateDate: 03/23/2016 15:56:00.587 , ModifyDate: 08/20/2019 12:08:24.933 */
GO
/*===============================================================================================
 Procedure Name:            rptActivityandResultUseAnalysisByStatus_Corporate
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use
								created by the Corporate Client Relations Specialist
 Created By:				Rachelen Hut
 Date Created:              03/23/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
NOTES:
 @ReportStatusID = 1	NotClosed	--Will not have a StartDate and EndDate (Open and Pending)
 @ReportStatusID = 2	Closed		--Will have a StartDate and EndDate (Closed only)

 @DateType = 1			CreateDate
 @DateType = 2			DueDate
 @DateType = 3			No Date

================================================================================================
CHANGE HISTORY:
04/25/2016 - RH - (#124783) Added Area Managers; removed Sales
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/09/2017 - RH - (#136702) Added Overdue as a status
================================================================================================
SAMPLE EXECUTION:

[rptActivityandResultUseAnalysisByStatus_Corporate] 1, 3, NULL, NULL

[rptActivityandResultUseAnalysisByStatus_Corporate] 1, 2, '1/1/2016','1/31/2016'

[rptActivityandResultUseAnalysisByStatus_Corporate] 2, 3, NULL, NULL

================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisByStatus_Corporate](
	@ReportStatusID INT			--1 is Not Closed; 2 is Closed
	,	@DateType INT				--1 for CreateDate, 2 for DueDate, 3 for No Date
	,	@StartDate DATETIME			--CAN BE NULL
	,	@EndDate DATETIME			--CAN BE NULL
	)

AS
BEGIN


/************ SET @OverdueDate to today at 12:00 AM **********************************************/

DECLARE @OverdueDate DATETIME
SET @OverdueDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)					--Today at 12:00AM

/***************Create temp tables ***************************************************************/

CREATE TABLE #Status(ActivityID INT
,	MasterActivityID INT
,	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	Pending INT
,	IsOpen INT
,	Closed INT
,	ActivityStatusID INT
,	DueDate DATETIME
)

/***************Find the EmployeeGUID for the Corporate Client Relations Specialist *******************************/

DECLARE @EmployeeGUID UNIQUEIDENTIFIER

SET @EmployeeGUID = (SELECT EmployeeGUID FROM [dbo].[datEmployee]
					  WHERE FirstName = 'Danny'
					  AND LastName = 'Lombana')

PRINT @EmployeeGUID

/***************Select where ActivityStatusID = @ActivityStatusID *********************************/

IF (@ReportStatusID = 1	AND @DateType = 1)		--	NotClosed, CreateDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(1,3)
AND A.CreateDate BETWEEN @StartDate AND @EndDate
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
END
ELSE
IF (@ReportStatusID = 1	AND @DateType = 2)		--	NotClosed, DueDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(1,3)
AND A.DueDate BETWEEN @StartDate AND @EndDate
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
END
ELSE
IF (@ReportStatusID = 1	AND @DateType = 3)		--	NotClosed, No Date
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(1,3)
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
END
IF (@ReportStatusID = 2	AND @DateType = 1)		--	Closed, CreateDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(2)
AND A.CreateDate BETWEEN @StartDate AND @EndDate
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
END
ELSE
IF (@ReportStatusID = 2	AND @DateType = 2)		--	Closed, DueDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(2)
AND A.DueDate BETWEEN @StartDate AND @EndDate
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
END
ELSE
IF (@ReportStatusID = 2	AND @DateType = 3)		--	Closed, No Date
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CLT.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN datClient CLT
	ON A.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN dbo.datEmployee ASSIGN
	ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
WHERE A.ActivityStatusID IN(2)
AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
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
FROM #Status


/***** SUM the values for the Summary report *******************************************************/

SELECT	STAT.CenterID
,	CTR.CenterDescriptionFullCalc
,	CASE WHEN R.RegionID >= 6 THEN 16 ELSE R.RegionID END AS 'RegionID'
,	CASE WHEN R.RegionID >= 6 THEN 'Franchise' ELSE R.RegionDescription END AS 'RegionDescription'
,	CMA.CenterManagementAreaID
,	CMA.CenterManagementAreaDescription
,	SUM(ISNULL(Pending,0)) AS 'Pending'
,	SUM(ISNULL(IsOpen,0)) AS 'IsOpen'
,	SUM(ISNULL(Closed,0)) AS 'Closed'
,	SUM(ISNULL(Overdue,0)) AS 'Overdue'
,	COUNT(STAT.ActivityID) AS TotalCreated
FROM #Status STAT
INNER JOIN cfgCenter CTR
	ON STAT.CenterID = CTR.CenterID
INNER JOIN dbo.lkpRegion R
	ON CTR.RegionID = R.RegionID
INNER JOIN dbo.cfgCenterManagementArea CMA
	ON CTR.CenterManagementAreaID = CMA.CenterManagementAreaID
LEFT JOIN #Overdue
	ON STAT.ActivityID = #Overdue.ActivityID
GROUP BY STAT.CenterID
,	CTR.CenterDescriptionFullCalc
,	R.RegionID
,	R.RegionDescription
,	CMA.CenterManagementAreaID
,	CMA.CenterManagementAreaDescription

END
GO
