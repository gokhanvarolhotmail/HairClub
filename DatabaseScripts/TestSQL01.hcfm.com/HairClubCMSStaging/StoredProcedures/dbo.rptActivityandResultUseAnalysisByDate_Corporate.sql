/* CreateDate: 03/23/2016 15:56:36.360 , ModifyDate: 08/20/2019 13:58:42.100 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [rptActivityandResultUseAnalysisByDate_Corporate]
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use
								created by the Corporate Client Relations Specialist
 Created By:				Rachelen Hut
 Date Created:              03/23/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
NOTES:

================================================================================================
CHANGE HISTORY:
04/21/2016 - RH - (#124783) Added Area Managers; removed Sales
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/09/2017 - RH - (#136702) Added Overdue as a status
06/21/2019 - RH - (Case 7979) Removed regions; Created a temp table for Corporate centers
08/20/2019 - RH - Changed to join on CenterType for CenterTypeDescriptionShort IN('F','JV','C')
================================================================================================
SAMPLE EXECUTION:

[rptActivityandResultUseAnalysisByDate_Corporate]  1, '4/1/2019','4/26/2019'

[rptActivityandResultUseAnalysisByDate_Corporate]  2, '4/1/2019','4/26/2019'

[rptActivityandResultUseAnalysisByDate_Corporate]  3, '1/1/1900','1/1/1900'


================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisByDate_Corporate](
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

/***************Find the EmployeeGUID for the Corporate Client Relations Specialist *******************************/

DECLARE @EmployeeGUID UNIQUEIDENTIFIER

SET @EmployeeGUID = (SELECT EmployeeGUID FROM [dbo].[datEmployee]
					  WHERE FirstName = 'Danny'
					  AND LastName = 'Lombana')

PRINT @EmployeeGUID


/***************Create temp tables ***************************************************************/

CREATE TABLE #Centers(
	CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(150)
)

CREATE TABLE #Activity(CenterID INT
,	ActivityID INT
,	MasterActivityID INT
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

/*************** Add Centers  **************************************************************/

INSERT INTO #Centers
SELECT CenterID
,	CenterDescriptionFullCalc
FROM dbo.cfgCenter CTR
INNER JOIN dbo.lkpCenterType CT
	ON CT.CenterTypeID = CTR.CenterTypeID
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CT.IsActiveFlag = 1


/*************** Select according to the selected Date Type ********************************/

IF @DateType = 1  --By CreateDate
BEGIN
	INSERT INTO #Activity
	SELECT CLT.CenterID
	,	A.ActivityID
	,	A.MasterActivityID
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
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN #Centers C
		ON C.CenterID = CLT.CenterID
	INNER JOIN dbo.cfgCenter CTR
		ON CTR.CenterID = CLT.CenterID
	INNER JOIN dbo.lkpCenterType CT
		ON CT.CenterTypeID = CTR.CenterTypeID
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
	WHERE A.CreateDate BETWEEN @StartDate AND @EndDate
		AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
		AND CT.CenterTypeDescriptionShort IN('F','JV','C')
END
ELSE
IF @DateType = 2	--By DueDate
BEGIN
	INSERT INTO #Activity
	SELECT CLT.CenterID
	,	A.ActivityID
	,	A.MasterActivityID
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
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN #Centers C
		ON C.CenterID = CLT.CenterID
	INNER JOIN dbo.cfgCenter CTR
		ON CTR.CenterID = CLT.CenterID
	INNER JOIN dbo.lkpCenterType CT
		ON CT.CenterTypeID = CTR.CenterTypeID
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
	WHERE A.DueDate BETWEEN @StartDate AND @EndDate
		AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)
		AND CT.CenterTypeDescriptionShort IN('F','JV','C')
END
ELSE
IF @DateType = 3	--By No Date
BEGIN
	INSERT INTO #Activity
	SELECT CLT.CenterID
	,	A.ActivityID
	,	A.MasterActivityID
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
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN #Centers C
		ON C.CenterID = CLT.CenterID
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
WHERE (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)


END

/***** Find Overdue *****************************************************************************/

SELECT ActivityID
     , MasterActivityID
     , C.CenterID
     , ClientGUID
     , ActivityStatusID
     , DueDate
	 ,	CASE WHEN (Pending = 1 OR IsOpen = 1 AND @OverdueDate > DueDate) THEN 1
		 ELSE 0
		 END AS  'Overdue'
INTO #Overdue
FROM #Activity A
INNER JOIN #Centers C
	ON C.CenterID = A.CenterID

/***** SUM the values for the Summary report *******************************************************/

SELECT ACT.CenterID
,	CTR.CenterDescriptionFullCalc
,	CMA.CenterManagementAreaID
,	CMA.CenterManagementAreaDescription
,	COUNT(ACT.ActivityID) AS TotalCreated
,	SUM(CASE WHEN ActivityCategoryID = 1 THEN 1 ELSE 0 END) AS 'CustSvcQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 1 THEN 1 ELSE 0 END) AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'CustSvcQtyPercent'
,	SUM(CASE WHEN ActivityCategoryID = 2 THEN 1 ELSE 0 END)  AS 'TechnicalQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 2 THEN 1 ELSE 0 END)AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'TechnicalQtyPercent'
,	SUM(CASE WHEN ActivityCategoryID = 3 THEN 1 ELSE 0 END) AS 'FinancialQty'
,	CASE WHEN COUNT(ACT.ActivityID) = 0 THEN 0 ELSE (CAST(SUM(CASE WHEN ActivityCategoryID = 3 THEN 1 ELSE 0 END)AS DECIMAL(18,4))/CAST(COUNT(ACT.ActivityID) AS DECIMAL(18,4))) END AS 'FinancialQtyPercent'

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


FROM #Activity ACT
INNER JOIN cfgCenter CTR
	ON ACT.CenterID = CTR.CenterID
INNER JOIN #Centers C
		ON C.CenterID = CTR.CenterID
LEFT JOIN dbo.cfgCenterManagementArea CMA
	ON CMA.CenterManagementAreaID = CTR.CenterManagementAreaID
LEFT JOIN #Overdue
	ON ACT.ActivityID = #Overdue.ActivityID
GROUP BY ACT.CenterID
,	CTR.CenterDescriptionFullCalc
,	CTR.RegionID
,	CMA.CenterManagementAreaID
,	CMA.CenterManagementAreaDescription


END
GO
