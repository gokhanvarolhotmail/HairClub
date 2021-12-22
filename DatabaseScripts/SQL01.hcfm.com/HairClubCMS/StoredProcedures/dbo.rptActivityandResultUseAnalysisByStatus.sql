/* CreateDate: 03/08/2016 12:27:36.993 , ModifyDate: 11/27/2019 08:59:14.957 */
GO
/*===============================================================================================
 Procedure Name:            rptActivityandResultUseAnalysisByStatus
 Procedure Description:     This stored procedure provides information about "Activity and Results" Use per Center
 Created By:				Rachelen Hut
 Date Created:              03/08/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint site for Regional Managers, available for all centers
================================================================================================
NOTES:
 @MainGroupID = 1 for "By Regions" (including Franchises as one region)
 @MainGroupID = 2 for "By Area Managers" (no Franchise centers)

 @ReportStatusID = 1	NotClosed	--Will not have a StartDate and EndDate (Open and Pending)
 @ReportStatusID = 2	Closed		--Will have a StartDate and EndDate (Closed only)

 @DateType = 1			CreateDate
 @DateType = 2			DueDate
 @DateType = 3			No Date

================================================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/09/2017 - RH - (#136702) Added Overdue as a status
11/27/2019 - RH - (TrackIT 2161) Removed MainGroupID as a parameter; changed query for Closed, No Date to match the detail
================================================================================================
SAMPLE EXECUTION:

[rptActivityandResultUseAnalysisByStatus]  1, 3, NULL, NULL

[rptActivityandResultUseAnalysisByStatus]  2, 3, NULL, NULL

================================================================================================*/

CREATE PROCEDURE [dbo].[rptActivityandResultUseAnalysisByStatus](
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

CREATE TABLE #Centers(
		MainGroupID INT
	,	MainGroupDescription NVARCHAR(103)
	,	CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(103)
	,	SortOrder INT
)

CREATE TABLE #Status(ActivityID INT
,	MasterActivityID INT
,	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	Pending INT
,	IsOpen INT
,	Closed INT
,	ActivityStatusID INT
,	DueDate	DATETIME
)

/*************************** Find Centers *************************************************************************/

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



/***************Select where ActivityStatusID = @ActivityStatusID *********************************/

IF (@ReportStatusID = 1	AND @DateType = 1)		--	NotClosed, CreateDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CREATED.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN #Centers CTR
	ON CREATED.CenterID = CTR.CenterID
WHERE A.ActivityStatusID IN(1,3)
AND A.CreateDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF (@ReportStatusID = 1	AND @DateType = 2)		--	NotClosed, DueDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CREATED.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN #Centers CTR
	ON CREATED.CenterID = CTR.CenterID
WHERE A.ActivityStatusID IN(1,3)
AND A.DueDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF (@ReportStatusID = 1	AND @DateType = 3)		--	NotClosed, No Date
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CREATED.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN #Centers CTR
	ON CREATED.CenterID = CTR.CenterID
WHERE A.ActivityStatusID IN(1,3)
END
IF (@ReportStatusID = 2	AND @DateType = 1)		--	Closed, CreateDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CREATED.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN #Centers CTR
	ON CREATED.CenterID = CTR.CenterID
WHERE A.ActivityStatusID IN(2)
AND A.CreateDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF (@ReportStatusID = 2	AND @DateType = 2)		--	Closed, DueDate
BEGIN
INSERT INTO #Status
SELECT A.ActivityID
,	A.MasterActivityID
,	CREATED.CenterID
,	A.ClientGUID
,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
,	A.DueDate
FROM datActivity A
INNER JOIN dbo.lkpActivityStatus STAT
	ON A.ActivityStatusID = STAT.ActivityStatusID
INNER JOIN dbo.datEmployee CREATED
	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
INNER JOIN #Centers CTR
	ON CREATED.CenterID = CTR.CenterID
WHERE A.ActivityStatusID IN(2)
AND A.DueDate BETWEEN @StartDate AND @EndDate
END
ELSE
IF (@ReportStatusID = 2	AND @DateType = 3)		--	Closed, No Date
BEGIN
INSERT INTO #Status
/*--SELECT A.ActivityID
--,	A.MasterActivityID
--,	CREATED.CenterID
--,	A.ClientGUID
--,	CASE WHEN STAT.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
--,	CASE WHEN STAT.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
--,	CASE WHEN STAT.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
--,	ISNULL(STAT.ActivityStatusID,0) AS 'ActivityStatusID'
--,	A.DueDate
--FROM datActivity A
--INNER JOIN dbo.lkpActivityStatus STAT
--	ON A.ActivityStatusID = STAT.ActivityStatusID
--INNER JOIN dbo.datEmployee CREATED
--	ON  A.CreatedByEmployeeGUID = CREATED.EmployeeGUID
--INNER JOIN #Centers CTR
--	ON CREATED.CenterID = CTR.CenterID
--WHERE A.ActivityStatusID IN(2)
*/
SELECT q.ActivityID
,	q.MasterActivityID
,	q.CenterID
,	ClientGUID
,	CASE WHEN q.ActivityStatusDescription = 'Pending' THEN 1 ELSE 0 END AS 'Pending'
,	CASE WHEN q.ActivityStatusDescription = 'Open' THEN 1 ELSE 0 END AS 'IsOpen'
,	CASE WHEN q.ActivityStatusDescription = 'Closed' THEN 1 ELSE 0 END AS 'Closed'
,	ISNULL(q.ActivityStatusID,0) AS 'ActivityStatusID'
,	q.DueDate
FROM	(SELECT CTR.CenterDescriptionFullCalc
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
			,	CLT.ClientGUID
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
			INNER JOIN #Centers CTR
				ON CREATED.CenterID = CTR.CenterID
		WHERE CM.EndDate > GETDATE()
			AND STAT.ActivityStatusDescription = 'Closed'
		)q
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

SELECT CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescriptionFullCalc
,	SUM(ISNULL(Pending,0)) AS 'Pending'
,	SUM(ISNULL(IsOpen,0)) AS 'IsOpen'
,	SUM(ISNULL(Closed,0)) AS 'Closed'
,	SUM(ISNULL(Overdue,0)) AS 'Overdue'
,	COUNT(STAT.ActivityID) AS TotalCreated
FROM #Status STAT
INNER JOIN #Centers CTR
	ON STAT.CenterID = CTR.CenterID
LEFT JOIN #Overdue
	ON STAT.ActivityID = #Overdue.ActivityID
GROUP BY CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescriptionFullCalc

END
GO
