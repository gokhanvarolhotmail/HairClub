/* CreateDate: 03/09/2016 15:31:33.983 , ModifyDate: 11/27/2019 09:02:58.580 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptActivityandResultUseAnalysisDetail
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use per Center
 Created By:				Rachelen Hut
 Date Created:              03/08/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Area Direcctors, available for all centers
================================================================================================
NOTES:

================================================================================================
CHANGE HISTORY:
03/09/2017 - RH - (#136702) Added Overdue as a status
01/26/2018 - RH - (#145957) Added CenterNumber to the final select
11/22/2019 - RH - (TrackIT 2161) Added Membership, Monthly Fee, National Rate, CompletedByEmp
================================================================================================
SAMPLE EXECUTION:						Centers:	Activities:				Dates:

[rptActivityandResultUseAnalysisDetail] 201,			1, 1, 			1, '10/1/2019', '10/31/2019'
[rptActivityandResultUseAnalysisDetail] 201,			4, 1, 			2, '10/1/2019', '10/31/2019'
[rptActivityandResultUseAnalysisDetail] 201,			3, 1, 			3, NULL, NULL

[rptActivityandResultUseAnalysisDetail] 201,			1, 2, 			1, '10/1/2019', '10/31/2019'
[rptActivityandResultUseAnalysisDetail] 201,			1, 2, 			2, '10/1/2019', '10/31/2019'
[rptActivityandResultUseAnalysisDetail] 201,			1, 2, 			3, NULL, NULL

================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisDetail](
	@CenterID INT
,	@ActivityCategoryID INT				--1 for CustService, 2 for Technical, 3 for Financial, 4 for Sales
,	@ActivityStatusID INT				--1 for Open, 2 for Closed, 3 for Pending, 4 for Overdue
,	@DateType INT						--1 for CreateDate, 2 for DueDate, 3 for No Date
,	@StartDate DATETIME					--CAN BE NULL
,	@EndDate DATETIME					--CAN BE NULL
)

AS
BEGIN

IF @ActivityCategoryID IS NULL
BEGIN
SET @ActivityCategoryID = 0
END

IF @ActivityStatusID IS NULL
BEGIN
SET @ActivityStatusID = 0
END

IF @DateType IS NULL
BEGIN
SET @DateType = 3						-- No Date
END

/************ SET @OverdueDate to today at 12:00 AM ***************************************************************/

DECLARE @OverdueDate DATETIME
SET @OverdueDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)					--Today at 12:00AM

/***************Create temp tables ********************************************************************************/
	/*
	DROP TABLE #Activity
	DROP TABLE #Detail
	DROP TABLE #Final
	*/
CREATE TABLE #Activity(CenterDescriptionFullCalc NVARCHAR(103)
,	ActivityID INT
,	MasterActivityID INT
,	CenterID INT
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
,	CompletedByEmp NVARCHAR(102)
,	ActivityNote  NVARCHAR(MAX)
,	MembershipDescription NVARCHAR(100)
,	MonthlyFee DECIMAL(18,4)
,	NationalMonthlyFee DECIMAL(18,4)
)

CREATE TABLE #Detail(CenterDescriptionFullCalc NVARCHAR(103)
,	ActivityID INT
,	MasterActivityID INT
,	CenterID INT
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
,	CompletedByEmp NVARCHAR(102)
,	ActivityNote  NVARCHAR(MAX)
,	MembershipDescription NVARCHAR(100)
,	MonthlyFee DECIMAL(18,4)
,	NationalMonthlyFee DECIMAL(18,4)
)

CREATE TABLE #Final(CenterDescriptionFullCalc NVARCHAR(103)
,	ActivityID INT
,	MasterActivityID INT
,	CenterID INT
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
,	CompletedByEmp NVARCHAR(102)
,	ActivityNote  NVARCHAR(MAX)
,	MembershipDescription NVARCHAR(100)
,	MonthlyFee DECIMAL(18,4)
,	NationalMonthlyFee DECIMAL(18,4)
)



/*************Select Statement ******************************************************************************/
IF ( @DateType = 1)  --( CreateDate)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
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
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.ActivityNote
	,	M.MembershipDescription
	,	CM.MonthlyFee
	,	CM.NationalMonthlyFee
	FROM dbo.datActivity A
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
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentMDPClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON M.MembershipID = CM.MembershipID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN dbo.cfgCenter CTR
		ON CREATED.CenterID = CTR.CenterID
	WHERE A.CreateDate BETWEEN @StartDate AND @EndDate
			AND CREATED.CenterID = @CenterID
			AND CM.EndDate > GETDATE()
END
ELSE
IF (@DateType = 2)  --(DueDate)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
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
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.ActivityNote
	,	M.MembershipDescription
	,	CM.MonthlyFee
	,	CM.NationalMonthlyFee
	FROM dbo.datActivity A
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
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentMDPClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON M.MembershipID = CM.MembershipID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN dbo.cfgCenter CTR
		ON CREATED.CenterID = CTR.CenterID
	WHERE A.DueDate BETWEEN @StartDate AND @EndDate
		AND CREATED.CenterID = @CenterID
		AND CM.IsActiveFlag = 1
		AND CM.EndDate > GETDATE()
END
ELSE
IF (@DateType = 3) --(No Date)
BEGIN
	INSERT INTO #Activity
	SELECT CTR.CenterDescriptionFullCalc
	,	A.ActivityID
	,	A.MasterActivityID
	,	CREATED.CenterID
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
	,	COMPLETED.EmployeeFullNameCalc AS 'CompletedByEmp'
	,	A.ActivityNote
	,	M.MembershipDescription
	,	CM.MonthlyFee
	,	CM.NationalMonthlyFee
	FROM dbo.datActivity A
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
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentMDPClientMembershipGUID
		OR	CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON M.MembershipID = CM.MembershipID
	INNER JOIN dbo.datEmployee CREATED
		ON A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
	INNER JOIN dbo.datEmployee ASSIGN
		ON A.AssignedToEmployeeGUID = ASSIGN.EmployeeGUID
	LEFT OUTER JOIN dbo.datEmployee COMPLETED
		ON A.CompletedByEmployeeGUID = COMPLETED.EmployeeGUID
	INNER JOIN dbo.cfgCenter CTR
		ON CREATED.CenterID = CTR.CenterID
WHERE CREATED.CenterID = @CenterID
	AND CM.EndDate > GETDATE()
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

IF @ActivityStatusID = 4  --Overdue
BEGIN
INSERT INTO #Final
SELECT C.CenterDescriptionFullCalc
     ,	ActivityID
     ,	MasterActivityID
     ,	C.CenterNumber AS 'CenterID'
     ,	ActivityCategoryID
     ,	ActivityCategoryDescription
     ,	ActivitySubCategoryDescription
     ,	ActivityStatusID
     ,	ActivityStatusDescription
     ,	ActivityPriorityDescription
     ,	DueDate
     ,	ClientFullNameCalc
     ,	ActivityActionDescription
     ,	ActivityResultDescription
     ,	#Detail.CreateDate
     ,	CreatedByEmp
     ,	AssignedToEmp
	 ,	CompletedByEmp
     ,	ActivityNote
	 ,	MembershipDescription
	 ,	MonthlyFee
	 ,	NationalMonthlyFee

FROM #Detail
INNER JOIN dbo.cfgCenter C
	ON C.CenterID = #Detail.CenterID
WHERE @OverdueDate > DueDate AND ActivityStatusDescription <> 'Closed'
END
ELSE  --IF @ActivityStatusID <> 4
BEGIN
INSERT INTO #Final
SELECT C.CenterDescriptionFullCalc
     ,	ActivityID
     ,	MasterActivityID
     ,	C.CenterNumber AS 'CenterID'
     ,	ActivityCategoryID
     ,	ActivityCategoryDescription
     ,	ActivitySubCategoryDescription
     ,	ActivityStatusID
     ,	ActivityStatusDescription
     ,	ActivityPriorityDescription
     ,	DueDate
     ,	ClientFullNameCalc
     ,	ActivityActionDescription
     ,	ActivityResultDescription
     ,	#Detail.CreateDate
     ,	CreatedByEmp
     ,	AssignedToEmp
	 ,	CompletedByEmp
     ,	ActivityNote
	,	MembershipDescription
	 ,	MonthlyFee
	 ,	NationalMonthlyFee
FROM #Detail
INNER JOIN dbo.cfgCenter C
	ON C.CenterID = #Detail.CenterID
END

SELECT * FROM #Final


END
GO
