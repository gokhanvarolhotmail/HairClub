/* CreateDate: 08/11/2017 12:11:23.087 , ModifyDate: 08/20/2019 12:08:06.307 */
GO
/*===============================================================================================
 Procedure Name:            [rptActivityandResultUseAnalysisByCategory_CSS_All]
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use per Category/ Sub-Category
 Created By:				Rachelen Hut
 Date Created:              08/10/2017
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
NOTES:
THIS REPORT - ACTIVITY AND RESULT USE ANALYSIS - IS USED IN BOTH SHAREPOINT AND CONECT REPORTING

@ActivityStatusID = 1 for Not Closed; --Will NOT have a StartDate and EndDate (Open and Pending)
@ActivityStatusID = 2	Closed			--Will have a StartDate and EndDate (Closed only)

@DateType = 1 is CreateDate; 2 is DueDate; 3 is No Date

================================================================================================
CHANGE HISTORY:

================================================================================================
SAMPLE EXECUTION:

EXEC [rptActivityandResultUseAnalysisByCategory_CSS_All] 2, 2, '8/1/2017', '8/28/2017'

EXEC [rptActivityandResultUseAnalysisByCategory_CSS_All] 1, 3, NULL, NULL

================================================================================================*/
CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisByCategory_CSS_All](
	@ActivityStatusID INT
,	@DateType INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN

/******************  If @ActivityStatusID = 1 (Not Closed) then set the @DateType to 3 (No Date) ****/

IF @ActivityStatusID = 1
BEGIN
SET @DateType = 3
END


/************ SET @OverdueDate to today at 12:00 AM **********************************************/

DECLARE @OverdueDate DATETIME
SET @OverdueDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)					--Today at 12:00AM

/***************Find the EmployeeGUID for the Corporate Client Relations Specialist **************/

DECLARE @EmployeeGUID UNIQUEIDENTIFIER

SET @EmployeeGUID = (SELECT EmployeeGUID FROM [dbo].[datEmployee]
					  WHERE FirstName = 'Danny'
					  AND LastName = 'Lombana')

PRINT @EmployeeGUID


/***************Create temp tables ***************************************************************/

CREATE TABLE #Centers(
		RegionID INT
	,	RegionDescription NVARCHAR(103)
	,	CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(103)
)


CREATE TABLE #Activity(ActivityID INT
,	MasterActivityID INT
,	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER

,	ActivityCategoryID INT
,	ActivityCategoryDescription NVARCHAR(100)
,	ActivitySubCategoryID INT
,	ActivitySubCategoryDescription NVARCHAR(100)

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
,	ActivityStatusID INT
,	ActivityStatusDescription NVARCHAR(10)
)

/*************************** Find Centers *************************************************************************/


INSERT INTO #Centers
SELECT R.RegionID
	,	R.RegionDescription
	,	C.CenterID
	,	C.CenterDescriptionFullCalc
FROM dbo.cfgCenter C
INNER JOIN dbo.lkpRegion R
	ON C.RegionID = R.RegionID
WHERE C.CenterID LIKE '[278]%'
	AND C.IsActiveFlag = 1


/*************** Select according to the selected Date Type ********************************/

IF @DateType = 1  --By CreateDate
BEGIN
SELECT A.ActivityID
	,	A.MasterActivityID
	,	CLT.CenterID
	,	A.ClientGUID

	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription

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

	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	,	STAT.ActivityStatusDescription

FROM datActivity A
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
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
		AND CLT.CenterID LIKE '[278]%'
END
ELSE
IF @DateType = 2	--By DueDate
BEGIN
INSERT INTO #Activity
SELECT A.ActivityID
	,	A.MasterActivityID
	,	CLT.CenterID
	,	A.ClientGUID

	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription

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

	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	,	STAT.ActivityStatusDescription
FROM datActivity A
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
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
		AND CLT.CenterID LIKE '[278]%'
END
ELSE
IF @DateType = 3	--By No Date
BEGIN
INSERT INTO #Activity
SELECT A.ActivityID
	,	A.MasterActivityID
	,	CLT.CenterID
	,	A.ClientGUID

	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryID
	,	SUB.ActivitySubCategoryDescription

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

	,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
	,	STAT.ActivityStatusDescription
FROM datActivity A
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
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
		AND CLT.CenterID LIKE '[278]%'
END


/***** Find Overdue *****************************************************************************/


SELECT ActivityID
     , MasterActivityID
     , CenterID
     , ClientGUID
     , ActivityStatusID
     , DueDate
	 ,	CASE WHEN (ActivityStatusID IN (1,3) AND @OverdueDate > DueDate) THEN 1
		 ELSE 0
		 END AS  'Overdue'
INTO #Overdue
FROM #Activity

/****** JOIN Tables *****************************************************************************/

IF @ActivityStatusID = 1  --Not Closed
BEGIN
SELECT ACT.ActivityID
,	ACT.MasterActivityID
,	ACT.CenterID
,	ACT.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	ACT.ActivitySubCategoryID
,	ACT.ActivitySubCategoryDescription
,	ACT.ActivityCategoryID
,	ACT.ActivityCategoryDescription
,	ACT.ActivityActionID
,	ACT.ActivityActionDescription
,	ACT.ActivityResultID
,	ACT.ActivityResultDescription
,	ACT.DueDate
,	ACT.ActivityPriorityID
,	ACT.ActivityPriorityDescription
,	ACT.ActivityNote
,	ACT.CreatedByEmployeeGUID
,	ACT.CreatedByEmp
,	ACT.AssignedToEmployeeGUID
,	ACT.AssignedToEmp
,	ACT.CompletedByEmployeeGUID
,	ACT.CompletedByEmp
,	ACT.CompletedDate
,	ACT.CreateDate
,	ACT.ActivityStatusDescription
,	ACT.ActivityStatusID
,	CTR.RegionID
,	R.RegionDescription
,	CTR.CenterDescriptionFullCalc
,	#Overdue.DueDate AS 'OverdueDueDate'
,	Overdue
FROM #Activity ACT
INNER JOIN cfgCenter CTR
	ON ACT.CenterID = CTR.CenterID
INNER JOIN lkpRegion R
	ON R.RegionID = CTR.RegionID
INNER JOIN datClient CLT
	ON ACT.ClientGUID = CLT.ClientGUID
LEFT JOIN #Overdue
	ON ACT.ActivityID = #Overdue.ActivityID
WHERE ACT.ActivityStatusID IN (1,3)
END
ELSE
IF @ActivityStatusID = 2  --Closed
BEGIN
SELECT ACT.ActivityID
,	ACT.MasterActivityID
,	ACT.CenterID
,	ACT.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	ACT.ActivitySubCategoryID
,	ACT.ActivitySubCategoryDescription
,	ACT.ActivityCategoryID
,	ACT.ActivityCategoryDescription
,	ACT.ActivityActionID
,	ACT.ActivityActionDescription
,	ACT.ActivityResultID
,	ACT.ActivityResultDescription
,	ACT.DueDate
,	ACT.ActivityPriorityID
,	ACT.ActivityPriorityDescription
,	ACT.ActivityNote
,	ACT.CreatedByEmployeeGUID
,	ACT.CreatedByEmp
,	ACT.AssignedToEmployeeGUID
,	ACT.AssignedToEmp
,	ACT.CompletedByEmployeeGUID
,	ACT.CompletedByEmp
,	ACT.CompletedDate
,	ACT.CreateDate
,	ACT.ActivityStatusDescription
,	ACT.ActivityStatusID
,	CTR.RegionID
,	R.RegionDescription
,	CTR.CenterDescriptionFullCalc
,	#Overdue.DueDate AS 'OverdueDueDate'
,	Overdue
FROM #Activity ACT
INNER JOIN cfgCenter CTR
	ON ACT.CenterID = CTR.CenterID
INNER JOIN lkpRegion R
	ON R.RegionID = CTR.RegionID
INNER JOIN datClient CLT
	ON ACT.ClientGUID = CLT.ClientGUID
LEFT JOIN #Overdue
	ON ACT.ActivityID = #Overdue.ActivityID
WHERE ACT.ActivityStatusID = 2
END


END
GO
