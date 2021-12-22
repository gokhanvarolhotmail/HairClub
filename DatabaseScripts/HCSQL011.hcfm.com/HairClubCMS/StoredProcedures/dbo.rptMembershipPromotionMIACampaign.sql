/* CreateDate: 08/08/2017 13:56:09.360 , ModifyDate: 03/07/2019 13:36:55.630 */
GO
/*===============================================================================================
 Procedure Name:            [rptMembershipPromotionMIACampaign]
 Procedure Description:     This report is used for Membership Promotions of Type: $1200 Off - Women's 2017 MIA Campaign
 Created By:				Rachelen Hut
 Date Created:              07/24/2017
 Destination Server:        SQL01
 Destination Database:      HairclubCMS
 Related Application:       cONEct!
================================================================================================
**NOTES**
@CenterType - 'C' for Corporate, 'F' for Franchise
@Filter = 1 By Regions, 2 by Areas, 3 By Centers
================================================================================================
CHANGE HISTORY:
08/07/2018 - RHut - (#151793) Changed to this version for 2018
================================================================================================
Sample Execution:
EXEC [rptMembershipPromotionMIACampaign] '3 Months Free - 2018 MIA Campaign', '8/1/2018', '9/30/2018'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptMembershipPromotionMIACampaign]
(
	@MembershipPromotionDescription NVARCHAR(100)
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN



DECLARE	@CenterType NVARCHAR(1)
,	@Filter INT


SET @CenterType = 'C'
SET @Filter = 2


/********************************** Create temp table objects *************************************/
IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
BEGIN
	DROP TABLE #Centers
END
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder NVARCHAR(50)
,	CenterID INT
,	CenterNumber INT
,	CenterDescriptionFullCalc NVARCHAR(104)
)


IF OBJECT_ID('tempdb..#MembershipPromotion') IS NOT NULL
BEGIN
	DROP TABLE #MembershipPromotion
END
CREATE TABLE #MembershipPromotion (
	MembershipPromotionID INT
,	MembershipPromotionDescription NVARCHAR(100)
,	MembershipPromotionDescriptionShort NVARCHAR(10)
)


IF OBJECT_ID('tempdb..#Detail') IS NOT NULL
BEGIN
	DROP TABLE #Detail
END
CREATE TABLE #Detail(
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	CenterID INT
,	CenterNumber INT
,	CenterDescriptionFullCalc NVARCHAR(50)
,	ClientIdentifier INT
,	ClientFullNameCalc NVARCHAR(50)
,	EmployeeInitials NVARCHAR(50)
,	MembershipPromotionDescription NVARCHAR(50)
,	MembershipPromotionID INT
,	OrderDate DATETIME
,	MembershipID INT
,	MembershipDescription NVARCHAR(50)
,	MembershipStatusID INT
,	MembershipStatusDescription NVARCHAR(50)
,	BeginDate DATETIME
,	EndDate DATETIME
,	Ranking INT
	   )


/********************************** Get list of centers *************************************/
IF (@CenterType = 'C' AND @Filter = 2)  --By Areas
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CAST(CMA.CenterManagementAreaSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
			INNER JOIN dbo.cfgCenterManagementArea CMA
				ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
			INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE   C.IsActiveFlag = 1
			AND CT.CenterTypeDescriptionShort = 'C'
END
IF (@CenterType = 'C' AND @Filter = 3)  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  C.CenterID AS 'MainGroupID'
		,		C.CenterDescriptionFullCalc AS 'MainGroupDescription'
		,		CAST(CMA.CenterManagementAreaSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1
END


IF @CenterType = 'F'  --Always By Regions for Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		CAST(R.RegionSortOrder AS NVARCHAR(50)) AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1
END

--SELECT * FROM #Centers


-- Get Membership Promotions
INSERT	INTO #MembershipPromotion (
	MembershipPromotionID
,	MembershipPromotionDescription
,	MembershipPromotionDescriptionShort
)
SELECT	MP.MembershipPromotionID
,		MP.MembershipPromotionDescription
,		MP.MembershipPromotionDescriptionShort
FROM	cfgMembershipPromotion MP
WHERE	MP.MembershipPromotionDescription = @MembershipPromotionDescription


--SELECT * FROM #MembershipPromotion


/*********** Detail **********************************************************/

INSERT INTO #Detail
SELECT CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.MainGroupSortOrder
,	CTR.CenterID
,	CTR.CenterNumber
,	CTR.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	E.EmployeeInitials
,	MP.MembershipPromotionDescription
,	MP.MembershipPromotionID
,	CAST(SO.OrderDate AS DATE) AS 'OrderDate'
,	mem.MembershipID
,	M.MembershipDescription
,	mem.ClientMembershipStatusID
,	CMS.ClientMembershipStatusDescription
,	mem.BeginDate
,	mem.EndDate
,	mem.Ranking
FROM datSalesOrderDetail SOD
INNER JOIN cfgMembershipPromotion MP
	ON (MP.MembershipPromotionID = SOD.MembershipPromotionID
		OR MP.MembershipPromotionID = SOD.NCCMembershipPromotionID)
INNER JOIN #MembershipPromotion p
	ON p.MembershipPromotionID = MP.MembershipPromotionID
INNER JOIN dbo.datSalesOrder SO
	ON SO.SalesOrderGUID = SOD.SalesOrderGUID
LEFT JOIN dbo.datEmployee E
	ON E.EmployeeGUID = SOD.Employee1GUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = SO.ClientGUID
INNER JOIN #Centers CTR
	ON SO.CenterID = CTR.CenterID
LEFT JOIN (
			SELECT CM.ClientMembershipGUID
                ,	CM.ClientGUID
                ,	CLT2.CenterID
				,	CLT2.ClientIdentifier
                ,	CM.MembershipID
                ,	CM.ClientMembershipStatusID
                ,	CM.BeginDate
                ,	CM.EndDate
				,	ROW_NUMBER() OVER(PARTITION BY CLT2.ClientIdentifier ORDER BY CM.EndDate DESC) RANKING
			FROM dbo.datClientMembership CM
			INNER JOIN datClient CLT2
				ON (CLT2.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
				OR CLT2.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
				OR CLT2.CurrentSurgeryClientMembershipGUID = CM.ClientMembershipGUID
				OR CLT2.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID)
			) mem
				ON mem.ClientIdentifier = CLT.ClientIdentifier AND RANKING = 1
LEFT JOIN dbo.cfgMembership M
	ON M.MembershipID = mem.MembershipID
LEFT JOIN dbo.lkpClientMembershipStatus CMS
	ON CMS.ClientMembershipStatusID = mem.ClientMembershipStatusID
WHERE MP.IsActiveFlag = 1
	AND SO.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
	AND SO.IsVoidedFlag = 0
GROUP BY CTR.MainGroupID
,	CTR.MainGroupDescription
,	CTR.MainGroupSortOrder
,	CTR.CenterID
,	CTR.CenterNumber
,	CTR.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	E.EmployeeInitials
,	MP.MembershipPromotionDescription
,	MP.MembershipPromotionID
,	CAST(SO.OrderDate AS DATE)
,	mem.MembershipID
,	M.MembershipDescription
,	mem.ClientMembershipStatusID
,	CMS.ClientMembershipStatusDescription
,	mem.BeginDate
,	mem.EndDate
,	mem.Ranking


SELECT * FROM #Detail

END
GO
