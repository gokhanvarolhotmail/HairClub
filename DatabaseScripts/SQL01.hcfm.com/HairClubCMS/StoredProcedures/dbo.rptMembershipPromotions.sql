/*===============================================================================================
 Procedure Name:            [rptMembershipPromotions]
 Procedure Description:     This report is used for Membership Promotions of Type: CENTER and ONCONTACT
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
09/27/2017 - RH - (142898) Added logic to find Manager Promo MPAmount and whether NCC Promo was @Dollar or @Percent
03/21/2019 - RH - (Case 211) Changed the 'No Promo' column to show any sale consultation where the NCC and Manager Promo entries are equal to $0.00
================================================================================================
Sample Execution:
EXEC [rptMembershipPromotions] 'C', 2, '3/1/2019', '3/26/2019'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptMembershipPromotions]
	@CenterType NVARCHAR(1)
,	@Filter INT
,	@StartDate DATETIME
,	@EndDate DATETIME

AS
BEGIN

/*********** Find if the Membership Promotion Adjustment Type is Dollar or Percent ***************/

DECLARE @Percent int
SELECT @Percent = MembershipPromotionAdjustmentTypeID FROM lkpMembershipPromotionAdjustmentType WHERE MembershipPromotionAdjustmentTypeDescriptionShort = 'Percent'
DECLARE @Dollar int
SELECT @Dollar = MembershipPromotionAdjustmentTypeID FROM lkpMembershipPromotionAdjustmentType WHERE MembershipPromotionAdjustmentTypeDescriptionShort = 'Dollar'


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(104)
)


CREATE TABLE #MPDetail( MPType NVARCHAR(25)
,	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(150)
,	SalesOrderGUID NVARCHAR(50)
,	SalesCodeID INT
,	ClientGUID NVARCHAR(50)
,	ClientIdentifier INT
,	ClientFullNameAltCalc NVARCHAR(250)
,	Employee1GUID NVARCHAR(50)
,	Employee NVARCHAR(50)
,	AppointmentDate DATE
,	AppointmentStartTime TIME
,	MPBeginDate DATETIME
,	MPEndDate DATETIME
,	MPAmount DECIMAL(18,4)
,	Price DECIMAL(18,4)
,	Discount DECIMAL(18,4)
,	RevenueGroupID INT
,	BusinessSegmentID INT
,	MembershipPromotionTypeID INT
,	MembershipPromotionTypeDescription NVARCHAR(50)
,	MembershipPromotionTypeDescriptionShort NVARCHAR(10)
,	MembershipPromotionID INT
,	MembershipPromotionDescription NVARCHAR(50)
,	MembershipPromotionGroupID INT
,	MembershipPromotionGroupDescription NVARCHAR(50)
,	MembershipPromotionAdjustmentTypeID INT
,	MembershipPromotionAdjustmentTypeDescription NVARCHAR(50)
,	OnContactActivityID NVARCHAR(50)
,	OnContactContactID NVARCHAR(50)
,	NCCMembershipPromotionID INT
)


CREATE TABLE #Promo(
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(104)
,	NCCPromo INT
,	NCCPromoAmt DECIMAL(18,4)
,	SpecialInterest INT
,	SpecialInterestAmt DECIMAL(18,4)
,	ManagerPromo INT
,	ManagerPromoAmt DECIMAL(18,4)
,	Referral INT
,	ReferralAmt DECIMAL(18,4)
,	NoPromo INT
)


CREATE TABLE #SUM_Promo(
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(104)
,	NCCPromo INT
,	NCCPromoAmt DECIMAL(18,4)
,	NCCPromoAvg DECIMAL(18,4)
,	SpecialInterest INT
,	SpecialInterestAmt DECIMAL(18,4)
,	SpecialInterestAvg  DECIMAL(18,4)
,	ManagerPromo INT
,	ManagerPromoAmt DECIMAL(18,4)
,	ManagerPromoAvg DECIMAL(18,4)
,	Referral INT
,	ReferralAmt DECIMAL(18,4)
,	ReferralAvg DECIMAL(18,4)
,	NoPromo INT
)


/********************************** Get list of centers *************************************/

IF (@CenterType = 'C' AND @Filter = 2)  --By Areas
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		FROM    dbo.cfgCenter C
			INNER JOIN dbo.cfgCenterManagementArea CMA
				ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
			INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND CMA.IsActiveFlag = 1
END
IF (@CenterType = 'C' AND @Filter = 3)  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  C.CenterID AS 'MainGroupID'
		,		C.CenterDescriptionFullCalc AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		FROM     dbo.cfgCenter C
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
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		FROM     dbo.cfgCenter C
				INNER JOIN  dbo.lkpRegion R
					ON C.RegionID = R.RegionID
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1
END



/**************** Select statement *****************************************************/

--DETAIL
INSERT INTO #MPDetail
SELECT 'Membership, Center' AS MPType
,	CTR.MainGroupID									--Membership, Center
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescription
,	CTR.CenterDescriptionFullCalc
,	SO.SalesOrderGUID
,	SOD.SalesCodeID
,	SO.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameAltCalc
,	SOD.Employee1GUID
,	E.UserLogin AS 'Employee'
,	CAST(APPT.AppointmentDate AS DATE) AS 'AppointmentDate'
,	CAST(APPT.StartTime AS TIME) AS 'AppointmentStartTime'
,	MP.BeginDate AS 'MPBeginDate'
,	MP.EndDate AS 'MPEndDate'
,	SOD.Discount  AS 'MPAmount'
,	SOD.Price
,	SOD.Discount
,	MP.RevenueGroupID
,	MP.BusinessSegmentID
,	MPT.MembershipPromotionTypeID
,	MPT.MembershipPromotionTypeDescription
,	MPT.MembershipPromotionTypeDescriptionShort
,	MP.MembershipPromotionID
,	MP.MembershipPromotionDescription
,	MPG.MembershipPromotionGroupID
,	MPG.MembershipPromotionGroupDescription
,	MPAT.MembershipPromotionAdjustmentTypeID
,	MPAT.MembershipPromotionAdjustmentTypeDescription
,	ISNULL(APPT.SalesforceTaskID,APPT.OnContactActivityID) AS 'OnContactActivityID'
,	ISNULL(APPT.SalesforceContactID,APPT.OnContactContactID) AS 'OnContactContactID'
,	SOD.NCCMembershipPromotionID
FROM dbo.datSalesOrderDetail SOD
INNER JOIN dbo.cfgMembershipPromotion MP								--links to MembershipPromotionTypeID
	ON MP.MembershipPromotionID = SOD.MembershipPromotionID
INNER JOIN dbo.datSalesOrder SO
	ON SO.SalesOrderGUID = SOD.SalesOrderGUID
INNER JOIN dbo.lkpMembershipPromotionType MPT
	ON MPT.MembershipPromotionTypeID = MP.MembershipPromotionTypeID
INNER JOIN dbo.lkpMembershipPromotionGroup MPG
	ON MPG.MembershipPromotionGroupID = MP.MembershipPromotionGroupID
INNER JOIN dbo.lkpMembershipPromotionAdjustmentType MPAT
	ON MPAT.MembershipPromotionAdjustmentTypeID = MP.MembershipPromotionAdjustmentTypeID
INNER JOIN dbo.datEmployee E
	ON E.EmployeeGUID = SOD.Employee1GUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = SO.ClientGUID
INNER JOIN dbo.datAppointment APPT
	ON SO.AppointmentGUID = APPT.AppointmentGUID
INNER JOIN #Centers CTR
	ON APPT.CenterID = CTR.CenterID
WHERE APPT.AppointmentDate BETWEEN @StartDate AND @EndDate
AND MP.IsActiveFlag = 1
AND SO.IsVoidedFlag = 0
AND MPT.MembershipPromotionTypeDescription IN('Membership','Center')
AND SOD.MembershipPromotionID IS NOT NULL
UNION
SELECT 'NCC' AS MPType
,	CTR.MainGroupID												--NCC
,	CTR.MainGroupDescription
,	CTR.CenterID
,	CTR.CenterDescription
,	CTR.CenterDescriptionFullCalc
,	SO.SalesOrderGUID
,	SOD.SalesCodeID
,	SO.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameAltCalc
,	SOD.Employee1GUID
,	E.UserLogin AS 'Employee'
,	CAST(APPT.AppointmentDate AS DATE) AS 'AppointmentDate'
,	CAST(APPT.StartTime AS TIME) AS 'AppointmentStartTime'
,	MP.BeginDate AS 'MPBeginDate'
,	MP.EndDate AS 'MPEndDate'
,	0 AS 'MPAmount'
,	SOD.Price
,	SOD.Discount
,	MP.RevenueGroupID
,	MP.BusinessSegmentID
,	MPT.MembershipPromotionTypeID
,	MPT.MembershipPromotionTypeDescription
,	MPT.MembershipPromotionTypeDescriptionShort
,	MP.MembershipPromotionID
,	MP.MembershipPromotionDescription
,	MPG.MembershipPromotionGroupID
,	MPG.MembershipPromotionGroupDescription
,	MPAT.MembershipPromotionAdjustmentTypeID
,	MPAT.MembershipPromotionAdjustmentTypeDescription
,	ISNULL(APPT.SalesforceTaskID,APPT.OnContactActivityID) AS 'OnContactActivityID'
,	ISNULL(APPT.SalesforceContactID,APPT.OnContactContactID) AS 'OnContactContactID'
,	SOD.NCCMembershipPromotionID
FROM dbo.datSalesOrderDetail SOD
INNER JOIN dbo.cfgMembershipPromotion MP
	ON MP.MembershipPromotionID = SOD.NCCMembershipPromotionID
INNER JOIN dbo.datSalesOrder SO
	ON SO.SalesOrderGUID = SOD.SalesOrderGUID
INNER JOIN dbo.lkpMembershipPromotionType MPT
	ON MPT.MembershipPromotionTypeID = MP.MembershipPromotionTypeID
LEFT JOIN dbo.lkpMembershipPromotionGroup MPG --This can be NULL
	ON MPG.MembershipPromotionGroupID = MP.MembershipPromotionGroupID
INNER JOIN dbo.lkpMembershipPromotionAdjustmentType MPAT
	ON MPAT.MembershipPromotionAdjustmentTypeID = MP.MembershipPromotionAdjustmentTypeID
INNER JOIN dbo.datEmployee E
	ON E.EmployeeGUID = SOD.Employee1GUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = SO.ClientGUID
INNER JOIN dbo.datAppointment APPT
	ON SO.AppointmentGUID = APPT.AppointmentGUID
INNER JOIN #Centers CTR
	ON APPT.CenterID = CTR.CenterID
WHERE APPT.AppointmentDate BETWEEN @StartDate AND @EndDate
AND MP.IsActiveFlag = 1
AND SO.IsVoidedFlag = 0
AND MPT.MembershipPromotionTypeDescription = 'NCC'
AND SOD.NCCMembershipPromotionID IS NOT NULL


/*********Changed the 'No Promo' column to show any sale consultation where the NCC and Manager Promo entries are equal to $0.00****/

UPDATE  #MPDetail
SET MembershipPromotionGroupDescription = 'NoPromo'
WHERE MembershipPromotionTypeDescription = 'NCC' AND Discount = 0

UPDATE  #MPDetail
SET MembershipPromotionGroupDescription = 'NoPromo'
WHERE MembershipPromotionID = 34 AND Discount = 0    --Manager Promo


/************** Find counts ************************************************************************************************************/

INSERT INTO #Promo
SELECT MainGroupID
,	MainGroupDescription
,	CenterID
,	CenterDescription
,	CenterDescriptionFullCalc
,	CASE WHEN MembershipPromotionTypeDescription = 'NCC' AND MembershipPromotionGroupDescription IS NULL THEN 1 ELSE 0 END AS 'NCCPromo'
,	CASE WHEN MembershipPromotionTypeDescription = 'NCC' AND MembershipPromotionGroupDescription IS NULL THEN Discount ELSE 0 END AS 'NCCPromoAmt'

,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionGroupID = 1) THEN 1 ELSE 0 END AS 'SpecialInterest'
,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionGroupID = 1) THEN MPAmount ELSE 0 END AS 'SpecialInterestAmt'

,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionID = 34 AND MembershipPromotionGroupDescription = 'Manager Promo') THEN 1 ELSE 0 END AS 'ManagerPromo'
,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionID = 34 AND MembershipPromotionGroupDescription = 'Manager Promo') THEN MPAmount ELSE 0 END AS 'ManagerPromoAmt'

,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionGroupID = 3) THEN 1 ELSE 0 END AS 'Referral'
,	CASE WHEN (MembershipPromotionTypeID = 2 AND MembershipPromotionGroupID = 3) THEN MPAmount ELSE 0 END AS 'ReferralAmt'

,	CASE WHEN MembershipPromotionGroupDescription = 'NoPromo' THEN 1 ELSE 0 END AS 'NoPromo'

FROM #MPDetail


/*************** Summary of Promotions *************************************************************************************************/

INSERT INTO #SUM_Promo

SELECT MainGroupID
,	MainGroupDescription
,	CenterID
,	CenterDescription
,	CenterDescriptionFullCalc
,	SUM(ISNULL(NCCPromo,0)) AS 'NCCPromo'
,	SUM(ISNULL(NCCPromoAmt,0)) AS 'NCCPromoAmt'
,	CASE WHEN SUM(ISNULL(NCCPromo,0)) = 0 THEN 0 ELSE (SUM(ISNULL(NCCPromoAmt,0))/SUM(ISNULL(NCCPromo,0))) END AS 'NCCPromoAvg'
,	SUM(ISNULL(SpecialInterest,0)) AS 'SpecialInterest'
,	SUM(ISNULL(SpecialInterestAmt,0)) AS 'SpecialInterestAmt'
,	CASE WHEN SUM(ISNULL(SpecialInterest,0)) = 0 THEN 0 ELSE (SUM(ISNULL(SpecialInterestAmt,0))/SUM(ISNULL(SpecialInterest,0))) END AS 'SpecialInterestAvg'
,	SUM(ISNULL(ManagerPromo,0)) AS 'ManagerPromo'
,	SUM(ISNULL(ManagerPromoAmt,0)) AS 'ManagerPromoAmt'
,	CASE WHEN SUM(ISNULL(ManagerPromo,0)) = 0 THEN 0 ELSE (SUM(ISNULL(ManagerPromoAmt,0))/SUM(ISNULL(ManagerPromo,0))) END AS 'ManagerPromoAvg'
,	SUM(ISNULL(Referral,0)) AS 'Referral'
,	SUM(ISNULL(ReferralAmt,0)) AS 'ReferralAmt'
,	CASE WHEN SUM(ISNULL(Referral,0)) = 0 THEN 0 ELSE (SUM(ISNULL(ReferralAmt,0))/SUM(ISNULL(Referral,0))) END AS 'ReferralAvg'
,	SUM(ISNULL(NoPromo,0)) AS 'NoPromo'
FROM #Promo
GROUP BY MainGroupID
       , MainGroupDescription
       , CenterID
       , CenterDescription
       , CenterDescriptionFullCalc

SELECT * FROM #SUM_Promo


END
