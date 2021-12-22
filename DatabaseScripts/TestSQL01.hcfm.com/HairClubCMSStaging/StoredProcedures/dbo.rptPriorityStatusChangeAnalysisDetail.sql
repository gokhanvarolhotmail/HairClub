/* CreateDate: 04/11/2016 14:31:45.823 , ModifyDate: 11/05/2018 15:54:22.643 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
PROCEDURE:				[rptPriorityStatusChangeAnalysisDetail]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	Conect
AUTHOR: 				Rachelen Hut
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED: 		04/07/2016
================================================================================================
CHANGE HISTORY:
01/09/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description; Added @Filter
================================================================================================
SAMPLE EXECUTION:
EXEC [rptPriorityStatusChangeAnalysisDetail] '10/1/2018','10/15/2018','C',2,7,1
EXEC [rptPriorityStatusChangeAnalysisDetail] '10/1/2018','10/15/2018','C',3,260,1

EXEC [rptPriorityStatusChangeAnalysisDetail] '11/1/2018','11/5/2018','F',1,6,1
EXEC [rptPriorityStatusChangeAnalysisDetail] '11/1/2018','11/5/2018','F',3,805,1
================================================================================================***/

CREATE PROCEDURE [dbo].[rptPriorityStatusChangeAnalysisDetail](
	@StartDate DATETIME
,	@EndDate DATETIME
,	@sType NVARCHAR(1)			--'C' OR 'F'
,	@Filter INT					-- 1 = By Region, 2 = By Area, 3 = By Center
,	@MainGroup NVARCHAR(10)		--Either CenterID, RegionID or CenterManagementAreaID
,	@PriorityReason INT
)
AS
BEGIN

/*@PriorityReason
1 = 'ClientCancelled'
2 = 'SolutionChange'
3 = 'UpgradeMembership'
4 = 'DowngradeMembership'
5 = 'WorkOrderChange'
6 = 'FactoryDefect'
7 = 'ClientRefused'
8 = 'Other'
9 = "Total Reasons"
*/

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
)

/********************************** Get list of centers *************************************/

IF (@sType = 'C' AND @Filter = 2)  --By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
		WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1
				AND CMA.CenterManagementAreaID = @MainGroup
END
IF (@sType = 'C' AND @Filter = 3)  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
		WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1
				AND C.CenterID = @MainGroup
END


IF (@sType = 'F' AND @Filter = 1)
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1
				AND R.RegionID = @MainGroup
END
IF (@sType = 'F' AND @Filter = 3)
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    cfgCenter C
				INNER JOIN lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1
				AND C.CenterID = @MainGroup
END



/*************  Main select statement ************************************************************/

SELECT CTR.MainGroupID
,	CTR.MainGroupDescription
,	HSOT.CenterID
,	CTR.CenterDescription
,	CTR.CenterDescriptionFullCalc
,	PriorCLT.ClientFullNameCalc AS 'PriorHSOClient'
,	CurrentCLT.ClientFullNameCalc AS 'CurrentClient'
,	M.MembershipDescription + ' (' + CAST(CurrentCM.EndDate AS NVARCHAR(10)) + ')' AS 'MembershipDescription'
,	M.RevenueGroupID
,	HSOT.HairSystemOrderTransactionDate
,	HSOT.HairSystemOrderPriorityReasonID
,	HSOPR.HairSystemOrderPriorityReasonDescription
,	HSOT.HairSystemOrderGUID
,	AppliedHSO.AppliedDate
,	HSO.HairSystemOrderNumber
,	HSOT.PreviousHairSystemOrderStatusID
,	PrevHSOS.HairSystemOrderStatusDescription AS 'PreviousHairSystemOrderStatus'
,	HSOT.NewHairSystemOrderStatusID
,	NewHSOS.HairSystemOrderStatusDescription AS 'NewHairSystemOrderStatus'
,	CASE WHEN (AppliedHSO.AppliedDate > HSOT.HairSystemOrderTransactionDate AND DATEDIFF(d,HSOT.HairSystemOrderTransactionDate,AppliedHSO.AppliedDate)<=7) THEN 1 ELSE 0 END AS 'ColorRedFont'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 1 THEN 1 ELSE 0 END AS 'ClientCancelled'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 2 THEN 1 ELSE 0 END AS 'SolutionChange'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 3 THEN 1 ELSE 0 END AS 'UpgradeMembership'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 4 THEN 1 ELSE 0 END AS 'DowngradeMembership'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 5 THEN 1 ELSE 0 END AS 'WorkOrderChange'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 6 THEN 1 ELSE 0 END AS 'FactoryDefect'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 7 THEN 1 ELSE 0 END AS 'ClientRefused'
,CASE WHEN HSOT.HairSystemOrderPriorityReasonID = 8 THEN 1 ELSE 0 END AS 'Other'

INTO #Priority
FROM datHairSystemOrderTransaction HSOT
INNER JOIN #Centers CTR
	ON HSOT.CenterID = CTR.CenterID
INNER JOIN dbo.datClientMembership CurrentCM
	ON HSOT.ClientMembershipGUID = CurrentCM.ClientMembershipGUID
INNER JOIN datClient CurrentCLT
	ON CurrentCM.ClientGUID = CurrentCLT.ClientGUID
INNER JOIN dbo.cfgMembership M
	ON CurrentCM.MembershipID = M.MembershipID
INNER JOIN dbo.datClientMembership PriorCM
	ON HSOT.PreviousClientMembershipGUID = PriorCM.ClientMembershipGUID
INNER JOIN datClient PriorCLT
	ON PriorCM.ClientGUID = PriorCLT.ClientGUID
INNER JOIN dbo.lkpHairSystemOrderPriorityReason HSOPR
	ON HSOT.HairSystemOrderPriorityReasonID = HSOPR.HairSystemOrderPriorityReasonID
INNER JOIN datHairSystemOrder HSO
	ON HSOT.HairSystemOrderGUID = HSO.HairSystemOrderGUID
LEFT OUTER JOIN dbo.datHairSystemOrder AppliedHSO
	ON (HSOT.HairSystemOrderGUID = AppliedHSO.HairSystemOrderGUID AND AppliedHSO.AppliedDate IS NOT NULL)
LEFT OUTER  JOIN dbo.lkpHairSystemOrderStatus PrevHSOS
	ON PrevHSOS.HairSystemOrderStatusID = HSOT.PreviousHairSystemOrderStatusID
LEFT OUTER  JOIN dbo.lkpHairSystemOrderStatus NewHSOS
	ON NewHSOS.HairSystemOrderStatusID = HSOT.NewHairSystemOrderStatusID
WHERE HSOT.CreateDate BETWEEN @StartDate AND @EndDate
	AND HSOT.HairSystemOrderPriorityReasonID IS NOT NULL
	AND M.RevenueGroupID IN (1,2)
	AND M.RevenueGroupID NOT IN(3)

IF @PriorityReason = 9  --Total Reasons
BEGIN
SELECT *
FROM #Priority
END
ELSE
BEGIN
SELECT *
FROM #Priority
WHERE HairSystemOrderPriorityReasonID = @PriorityReason

END

END
GO
