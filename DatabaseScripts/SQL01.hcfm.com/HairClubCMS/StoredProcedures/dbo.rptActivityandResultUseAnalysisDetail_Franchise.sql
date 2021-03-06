/* CreateDate: 07/05/2016 15:45:29.883 , ModifyDate: 03/10/2017 08:51:56.673 */
GO
/*===============================================================================================
 Procedure Name:            rptActivityandResultUseAnalysisDetail_Franchise
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use
								created by the Client Relations Specialist - for Franchise centers
 Created By:				Rachelen Hut
 Date Created:              07/05/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site
================================================================================================
NOTES:

 @DateType = 1			CreateDate
 @DateType = 2			DueDate
 @DateType = 3			No Date

================================================================================================
CHANGE HISTORY:
03/09/2017 - RH - (#136702) Added Overdue as a status
================================================================================================
SAMPLE EXECUTION:								Activities:				Dates:

[rptActivityandResultUseAnalysisDetail_Franchise] 	16,NULL, NULL, 	3, NULL, NULL

[rptActivityandResultUseAnalysisDetail_Franchise] 	6,NULL, NULL, 	3, NULL, NULL
[rptActivityandResultUseAnalysisDetail_Franchise] 	804, NULL, 1,		2, '1/1/2016', '1/31/2016'
[rptActivityandResultUseAnalysisDetail_Franchise] 	811, 1, NULL,		3, NULL, NULL

[rptActivityandResultUseAnalysisDetail_Franchise] 	16, 2, 2,		2, '4/1/2016', '4/26/2016'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisDetail_Franchise](
	@CenterID INT						--MainGroupID
,	@ActivityCategoryID INT				--1 for CustService, 2 for Technical, 3 for Financial
,	@ActivityStatusID INT				--1 for Open, 2 for Closed, 3 for Pending, 4 for Overdue
,	@DateType INT						--1 for CreateDate, 2 for DueDate, 3 for No Date
,	@StartDate DATETIME					--CAN BE NULL
,	@EndDate DATETIME					--CAN BE NULL
)

AS
BEGIN

--Set a NULL for @ActivityCategoryID to zero
IF @ActivityCategoryID IS NULL
BEGIN
SET @ActivityCategoryID = 0
END

--Set a NULL for @ActivityStatusID to zero
IF @ActivityStatusID IS NULL
BEGIN
SET @ActivityStatusID =  0
END

--Set a NULL for @DateType to 3 (No Date)
IF @DateType IS NULL
BEGIN
SET @DateType = 3
END

/************ SET @OverdueDate to today at 12:00 AM **************************************************************/

DECLARE @OverdueDate DATETIME
SET @OverdueDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)					--Today at 12:00AM


/***************Find the EmployeeGUID for the Corporate Client Relations Specialist *******************************/

DECLARE @EmployeeGUID UNIQUEIDENTIFIER

SET @EmployeeGUID = (SELECT EmployeeGUID FROM [dbo].[datEmployee]
					  WHERE FirstName = 'Danny'
					  AND LastName = 'Lombana')

--PRINT @EmployeeGUID

/***************Create temp tables ********************************************************************************/

CREATE TABLE #Centers (RegionID INT
,	RegionDescription VARCHAR(50)
,	CenterID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionFullCalc VARCHAR(104)
)

CREATE TABLE #Activity(	RegionID INT
,	RegionDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	ActivityID INT
,	MasterActivityID INT
,	ActivityCategoryID INT
,	ActivityCategoryDescription NVARCHAR(100)
,	ActivitySubCategoryDescription NVARCHAR(100)
,	ActivityStatusID INT
,	ActivityStatusDescription NVARCHAR(50)
,	ActivityPriorityDescription NVARCHAR(100)
,	DueDate DATETIME
,	ClientFullNameCalc NVARCHAR(100)
,	ActivityActionDescription NVARCHAR(100)
,	ActivityResultDescription NVARCHAR(100)
,	CreateDate DATETIME
,	CreatedByEmp NVARCHAR(102)
,	AssignedToEmp NVARCHAR(102)
,	ActivityNote  NVARCHAR(MAX)
)

CREATE TABLE #Detail(RegionID INT
,	RegionDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	ActivityID INT
,	MasterActivityID INT
,	ActivityCategoryID INT
,	ActivityCategoryDescription NVARCHAR(100)
,	ActivitySubCategoryDescription NVARCHAR(100)
,	ActivityStatusID INT
,	ActivityStatusDescription NVARCHAR(50)
,	ActivityPriorityDescription NVARCHAR(100)
,	DueDate DATETIME
,	ClientFullNameCalc NVARCHAR(100)
,	ActivityActionDescription NVARCHAR(100)
,	ActivityResultDescription NVARCHAR(100)
,	CreateDate DATETIME
,	CreatedByEmp NVARCHAR(102)
,	AssignedToEmp NVARCHAR(102)
,	ActivityNote  NVARCHAR(MAX)
)

/*********** Populate #Centers ******************************************************************************/

IF @CenterID  IN(6,7,8,9,10,11,12,13,14)			--Franchise Regions
BEGIN
INSERT INTO #Centers
SELECT CTR.RegionID
,	R.RegionDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
FROM  dbo.cfgCenter CTR
INNER JOIN lkpRegion R
	ON CTR.RegionID = R.RegionID
WHERE CTR.RegionID =  @CenterID
	AND CenterID LIKE '[78]%'
END
IF @CenterID = 16					--All Franchises
BEGIN
INSERT INTO #Centers
SELECT CTR.RegionID
,	R.RegionDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
FROM dbo.cfgCenter CTR
INNER JOIN lkpRegion R
	ON CTR.RegionID = R.RegionID
WHERE CTR.CenterTypeID IN(2,3)		--Franchise and JV
END
ELSE								--Center
BEGIN
INSERT INTO #Centers
SELECT CTR.CenterID AS 'RegionID'
	,	CTR.CenterDescriptionFullCalc AS 'RegionDescription'
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
FROM dbo.cfgCenter CTR
WHERE CTR.CenterID =  @CenterID
AND CenterID LIKE '[78]%'
END

--SELECT * FROM #Centers
/*************Select Statement ******************************************************************************/
IF ( @DateType = 1)  --( CreateDate)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.RegionID
	,	CTR.RegionDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryDescription
	,	STAT.ActivityStatusID
	,	STAT.ActivityStatusDescription
	,	AP.ActivityPriorityDescription
	,	A.DueDate
	,	CLT.ClientFullNameCalc
	,	AA.ActivityActionDescription
	,	AR.ActivityResultDescription
	,	A.CreateDate
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.ActivityNote
	FROM datActivity A
	LEFT OUTER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	LEFT OUTER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	LEFT OUTER JOIN dbo.lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	LEFT OUTER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	LEFT OUTER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN dbo.datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CLT.CenterID = CTR.CenterID
	WHERE A.CreateDate BETWEEN @StartDate AND @EndDate
			AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)

END
ELSE
IF (@DateType = 2)  --(DueDate)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.RegionID
	,	CTR.RegionDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryDescription
	,	STAT.ActivityStatusID
	,	STAT.ActivityStatusDescription
	,	AP.ActivityPriorityDescription
	,	A.DueDate
	,	CLT.ClientFullNameCalc
	,	AA.ActivityActionDescription
	,	AR.ActivityResultDescription
	,	A.CreateDate
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.ActivityNote
	FROM datActivity A
	LEFT OUTER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	LEFT OUTER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	LEFT OUTER JOIN dbo.lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	LEFT OUTER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	LEFT OUTER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CLT.CenterID = CTR.CenterID
	WHERE A.DueDate BETWEEN @StartDate AND @EndDate
		AND (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)

END
ELSE
IF (@DateType = 3) --(No Date)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.RegionID
	,	CTR.RegionDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	AC.ActivityCategoryID
	,	AC.ActivityCategoryDescription
	,	SUB.ActivitySubCategoryDescription
	,	STAT.ActivityStatusID
	,	STAT.ActivityStatusDescription
	,	AP.ActivityPriorityDescription
	,	A.DueDate
	,	CLT.ClientFullNameCalc
	,	AA.ActivityActionDescription
	,	AR.ActivityResultDescription
	,	A.CreateDate
	,	CREATED.EmployeeFullNameCalc AS 'CreatedByEmp'
	,	ASSIGN.EmployeeFullNameCalc AS 'AssignedToEmp'
	,	A.ActivityNote
	FROM datActivity A
	LEFT OUTER JOIN dbo.lkpActivitySubCategory SUB
		ON A.ActivitySubCategoryID = SUB.ActivitySubCategoryID
	LEFT OUTER JOIN dbo.lkpActivityCategory AC
		ON SUB.ActivityCategoryID = AC.ActivityCategoryID
	LEFT OUTER JOIN dbo.lkpActivityAction AA
		ON A.ActivityActionID = AA.ActivityActionID
	LEFT OUTER JOIN dbo.lkpActivityResult AR
		ON A.ActivityResultID = AR.ActivityResultID
	LEFT OUTER JOIN dbo.lkpActivityPriority AP
		ON A.ActivityPriorityID = AP.ActivityPriorityID
	LEFT OUTER JOIN dbo.lkpActivityStatus STAT
		ON A.ActivityStatusID = STAT.ActivityStatusID
	INNER JOIN datClient CLT
		ON A.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN #Centers CTR
		ON CLT.CenterID = CTR.CenterID
WHERE (CREATED.EmployeeGUID = @EmployeeGUID
				OR ASSIGN.EmployeeGUID = @EmployeeGUID)

END



/*********************** Find the results based on @ActivityCategoryID and @ActivityStatusID *********/
/***********************	except where @ActivityStausID = 4 (Overdue)   ****************************/

IF @ActivityCategoryID <> 0
BEGIN
	IF (@ActivityStatusID IN(1,2,3))
	BEGIN
	INSERT INTO #Detail
	SELECT *
	FROM #Activity
	WHERE ActivityCategoryID = @ActivityCategoryID
	AND ActivityStatusID = @ActivityStatusID
	END
	ELSE
	BEGIN
	INSERT INTO #Detail
	SELECT * FROM #Activity
	WHERE ActivityCategoryID = @ActivityCategoryID
	END

END
ELSE --If @ActivityCategoryID = 0
BEGIN
	IF (@ActivityStatusID IN(1,2,3))
	BEGIN
	INSERT INTO #Detail
	SELECT * FROM #Activity
	WHERE ActivityStatusID = @ActivityStatusID
	END
	ELSE
	BEGIN
	INSERT INTO #Detail
	SELECT * FROM #Activity
	END
END

/********************* Find the results where @ActivityStatusID = 4 (Overdue) *************************/

IF @ActivityStatusID = 4
BEGIN
SELECT * FROM #Detail
WHERE @OverdueDate > DueDate AND ActivityStatusDescription <> 'Closed'
END
ELSE  --IF @ActivityStatusID <> 4
BEGIN
SELECT * FROM #Detail
END



END
GO
