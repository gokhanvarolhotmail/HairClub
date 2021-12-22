/* CreateDate: 07/24/2012 15:53:57.667 , ModifyDate: 06/18/2019 15:30:43.887 */
GO
/*===============================================================================================
-- Procedure Name:			rptAppliedHairSystemStatus
-- Procedure Description:
--
-- Created By:				HDu
-- Implemented By:			HDu
--
-- Date Created:			11/02/2011
-- Date Implemented:		11/02/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

=====================================================================================================
NOTES: 	@CenterIds 1 = Corporate, 2 = Franchise, 3 = Joint Venture, 4 = Area Managers ELSE CenterID

=====================================================================================================
CHANGE HISTORY:
07/11/2012 - HDu - Created new report stored proc
09/09/2013 - MB - Removed SurgeryHubCenter condition
05/20/2016 - RH - Rewrote the stored procedure for consistency and added Area Manager as Main Group choice (#121775)
11/28/2016 - RH - Added Priority Initial New Styles (#132269)
01/09/2017 - RH - Changed EmployeeKey to CenterManagementAreaID and CenterManagementAreaDescription as description (#132688)
11/02/2018 - RH - Changed code to populate the #Centers table since the drill-down from rptPriorityStatusChange report was not working (Case #5977)
=====================================================================================================
SAMPLE EXECUTION:

EXEC rptAppliedHairSystemStatus 1, '5/1/2019', '5/31/2019'
EXEC rptAppliedHairSystemStatus 2, '5/1/2019', '5/31/2019'
EXEC rptAppliedHairSystemStatus 4, '5/1/2019', '5/31/2019'
=====================================================================================================*/

CREATE PROCEDURE [dbo].[rptAppliedHairSystemStatus]
(
	 @CenterIds INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
,	CenterTypeDescriptionShort NVARCHAR(2)
,	CenterManagementAreaID INT
,	CenterManagementAreaDescription NVARCHAR(102)
)

CREATE TABLE #Initial(ClientGUID UNIQUEIDENTIFIER
     ,	ClientFullNameAltCalc NVARCHAR(105)
     ,	ClientHomeCenterID INT
     ,	HairSystemOrderGUID UNIQUEIDENTIFIER
     ,	AppliedDate DATETIME
     ,	ClientMembershipGUID UNIQUEIDENTIFIER
     ,	MembershipDescription NVARCHAR(50)
	 ,	SalesCodeID INT)

/********************************** Get list of centers *************************************/

IF @CenterIds = 1  --Corporate
BEGIN
INSERT  INTO #Centers
SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
,		C.CenterID
,		C.CenterDescription
,		C.CenterDescriptionFullCalc
,		CT.CenterTypeDescriptionShort
,		CMA.CenterManagementAreaID
,		CMA.CenterManagementAreaDescription
FROM    cfgCenter C
		INNER JOIN lkpCenterType CT
			ON C.CenterTypeID= CT.CenterTypeID
		INNER JOIN dbo.cfgCenterManagementArea CMA
			ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND C.IsActiveFlag = 1
END

IF @CenterIds = 2  --Franchise
BEGIN
INSERT  INTO #Centers
SELECT  R.RegionID AS 'MainGroupID'
,		R.RegionDescription AS 'MainGroupDescription'
,		C.CenterID
,		C.CenterDescription
,		C.CenterDescriptionFullCalc
,		CT.CenterTypeDescriptionShort
,		NULL AS CenterManagementAreaID
,		NULL AS CenterManagementAreaDescription
FROM    cfgCenter C
		INNER JOIN lkpCenterType CT
			ON C.CenterTypeID= CT.CenterTypeID
		INNER JOIN lkpRegion R
			ON C.RegionID = R.RegionID
WHERE   CT.CenterTypeDescriptionShort IN ('F','JV')
		AND C.IsActiveFlag = 1
END

IF @CenterIds = 4  --By Area Managers
BEGIN
INSERT  INTO #Centers
SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
,		C.CenterID
,		C.CenterDescription
,		C.CenterDescriptionFullCalc
,		CT.CenterTypeDescriptionShort
,		CMA.CenterManagementAreaID
,		CMA.CenterManagementAreaDescription
FROM    cfgCenter C
		INNER JOIN lkpCenterType CT
			ON C.CenterTypeID= CT.CenterTypeID
		INNER JOIN dbo.cfgCenterManagementArea CMA
			ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
WHERE  CT.CenterTypeDescriptionShort = 'C'
		AND C.IsActiveFlag = 1
END

/************************ Find Revenue Group, Priority and Application Type ********************************/

SELECT 	HSO.ClientGUID
,	CLT.ClientFullNameAltCalc
,	HSO.ClientHomeCenterID
,	HSO.HairSystemOrderDate
,	HSO.HairSystemOrderGUID
,	HSO.HairSystemOrderNumber
,	HSO.AppliedDate
,	HSO.HairSystemID
,	HSO.HairSystemDesignTemplateID
,	DT.HairSystemDesignTemplateDescription
,	DT.HairSystemDesignTemplateDescriptionShort
,	HSO.ClientMembershipGUID
,	M.MembershipDescription
,	M.RevenueGroupID
,	CASE WHEN M.RevenueGroupID = 1 THEN 'New Business'
		WHEN M.RevenueGroupID = 2 THEN 'Recurring Business'
		ELSE 'Recurring Business' END AS 'RevenueGroupDescription'
,	CASE WHEN prh.HairSystemOrderGUID IS NOT NULL THEN 1 ELSE 0 END AS 'Priority'
,	CASE WHEN DT.HairSystemDesignTemplateDescriptionShort NOT IN ('MAN','MEA') THEN 'Design'
			WHEN DT.HairSystemDesignTemplateDescriptionShort = 'MEA' THEN 'MEA'
			WHEN DT.HairSystemDesignTemplateDescriptionShort = 'MAN' THEN 'Manual'
	END AS 'ApplicationType'
INTO #System
FROM dbo.datHairSystemOrder HSO
INNER JOIN #Centers CTR ON HSO.ClientHomeCenterID = CTR.CenterID
LEFT JOIN dbo.lkpHairSystemDesignTemplate DT
	ON DT.HairSystemDesignTemplateID = HSO.HairSystemDesignTemplateID
LEFT JOIN (							--This will find hair systems that have at one time been in PRIORITY status
	SELECT HairSystemOrderGUID
	FROM datHairSystemOrderTransaction t
	WHERE t.NewHairSystemOrderStatusID = 6
	GROUP BY HairSystemOrderGUID
	) prh
		ON prh.HairSystemOrderGUID = HSO.HairSystemOrderGUID
INNER JOIN datClient CLT
	ON HSO.ClientGUID = CLT.ClientGUID
INNER JOIN dbo.datClientMembership CM
	ON HSO.ClientMembershipGUID = CM.ClientMembershipGUID
INNER JOIN dbo.cfgMembership M
	ON CM.MembershipID = M.MembershipID
WHERE HSO.HairSystemOrderStatusID = 2			--APPLIED
AND HSO.AppliedDate BETWEEN @StartDate AND @EndDate
AND M.RevenueGroupID IN (1,2)


/****************** Find INITIAL NEW STYLES from the New Business set ********************************************/
--SalesCodeID	SalesCodeDescription	SalesCodeDescriptionShort
--648			Initial New Style		NB1A

INSERT INTO #Initial
SELECT	S.ClientGUID
     ,	S.ClientFullNameAltCalc
     ,	S.ClientHomeCenterID
     ,	S.HairSystemOrderGUID
     ,	S.AppliedDate
     ,	S.ClientMembershipGUID
     ,	S.MembershipDescription
	 ,	SC.SalesCodeID
FROM #System S
INNER JOIN dbo.datSalesOrder SO
	ON S.ClientHomeCenterID = SO.ClientHomeCenterID AND S.ClientGUID = SO.ClientGUID
INNER JOIN dbo.datSalesOrderDetail SOD
	ON S.HairSystemOrderGUID = SOD.HairSystemOrderGUID
INNER JOIN cfgSalesCode SC
	ON SOD.SalesCodeID = SC.SalesCodeID
WHERE S.[Priority] = 1
AND SOD.SalesCodeID = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescription = 'Initial New Style')
AND S.AppliedDate BETWEEN @StartDate AND @EndDate
GROUP BY S.ClientGUID
       , S.ClientFullNameAltCalc
       , S.ClientHomeCenterID
       , S.HairSystemOrderGUID
       , S.AppliedDate
       , S.ClientMembershipGUID
       , S.MembershipDescription
       , SC.SalesCodeID

/************* Combine the sets *****************************************************************/

SELECT	CTR.MainGroupID
	,	CTR.MainGroupDescription
	,	SYST.ClientHomeCenterID AS 'CenterID'
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc AS 'Center'
	,	COUNT(SYST.HairSystemOrderGUID) AS 'Applications'
	,	SUM(CASE SYST.[Priority] WHEN 0 THEN 1 ELSE 0 END) AS 'CENT'
	,	SUM(CASE SYST.[Priority] WHEN 1 THEN 1 ELSE 0 END) AS 'Priority'
	,	SUM(CASE WHEN SYST.[Priority] IS NULL THEN 1 ELSE 0 END) AS 'NULL'
	,	COUNT(I.HairSystemOrderGUID) AS 'PriorityInitApps'
FROM #System SYST
INNER JOIN #Centers CTR
	ON CTR.CenterID = SYST.ClientHomeCenterID
INNER JOIN cfgCenter C
	ON CTR.CenterID = C.CenterID
LEFT JOIN #Initial I
	ON (I.ClientHomeCenterID = SYST.ClientHomeCenterID AND I.AppliedDate = SYST.AppliedDate)
GROUP BY CTR.MainGroupID
		,	CTR.MainGroupDescription
		,	SYST.ClientHomeCenterID
		,	CTR.CenterDescription
		,	CTR.CenterDescriptionFullCalc



END
GO
