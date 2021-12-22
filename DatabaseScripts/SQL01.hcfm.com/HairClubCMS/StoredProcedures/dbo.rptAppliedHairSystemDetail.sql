/*===============================================================================================
 Procedure Name:            [rptAppliedHairSystemDetail]
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              05/24/2016
 Destination Server:        HairclubCMS
 Related Application:       SharePoint
================================================================================================
**NOTES**
This is used for the detail of the Applied Hair System reports for Applications.
HSO.IsStockInventoryFlag is only for the current status of PRIORITY.
A LEFT JOIN on datHairSystemOrderTransaction is used to find all hair systems that were at one time in PRIORITY.
===============================================================================================
CHANGE HISTORY:
12/1/2016 - RH -Removed parameter @IsPriority since it is not being used
01/10/2017 - RH - Changed EmployeeKey to CenterManagementAreaID and CenterManagementAreaDescription as description; Added @Filter (#132688)
11/02/2018 - RH - Changed #Center code to include all
================================================================================================
SAMPLE EXECUTION:

EXEC [rptAppliedHairSystemDetail] 'C', '11/1/2018', '11/28/2018', 2, 2

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptAppliedHairSystemDetail](
	@sType NVARCHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@MainGroup NVARCHAR(10)
,	@Filter INT
)


AS
BEGIN

SET @EndDate = CONVERT(VARCHAR(10),@EndDate,120) + ' 23:59:59.999'

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

IF @MainGroup IS NULL AND @sType = 'C'
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
END
ELSE
IF @MainGroup IS NULL AND @sType = 'F'
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
END
ELSE
IF @Filter = 1								--By Region
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
				AND C.RegionID = @MainGroup
END
ELSE
IF  @Filter = 2								--By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    dbo.cfgCenter C
				INNER JOIN dbo.lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
		WHERE C.IsActiveFlag = 1
				AND  CMA.CenterManagementAreaID = @MainGroup
END
ELSE
IF @Filter = 3	AND @sType = 'C'
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CT.CenterTypeDescriptionShort
		FROM    dbo.cfgCenter C
				INNER JOIN dbo.lkpCenterType CT
					ON C.CenterTypeID= CT.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
		WHERE   C.CenterID = @MainGroup
				AND C.IsActiveFlag = 1
END
ELSE
IF @Filter = 3	AND @sType = 'F'
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



--SELECT * FROM #Centers
/********************* Main select statement ******************************************************/

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
,	0 AS IsInitialNewStyle
INTO #system
FROM dbo.datHairSystemOrder HSO
INNER JOIN #Centers CTR ON HSO.ClientHomeCenterID = CTR.CenterID
LEFT JOIN dbo.lkpHairSystemDesignTemplate DT
	ON DT.HairSystemDesignTemplateID = HSO.HairSystemDesignTemplateID
LEFT JOIN (										--This will find hair systems that have at one time been in PRIORITY status
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


/****************** Find # of hair systems that have been ordered per client *************************************/

SELECT HSO.ClientGUID
	,	COUNT(HSO.HairSystemOrderNumber) AS 'OnOrder'
INTO #OnOrder
FROM dbo.datHairSystemOrder HSO
INNER JOIN #system sys
	ON HSO.ClientGUID = sys.ClientGUID
WHERE HSO.DueDate > GETDATE()
AND HSO.HairSystemOrderStatusID IN(7,8) --'NewOrder', 'Ordered from Factory'
GROUP BY HSO.ClientGUID

/****************** Find INITIAL NEW STYLES from the New Business set ********************************************/
--SalesCodeID	SalesCodeDescription	SalesCodeDescriptionShort
--648			Initial New Style		NB1A

SELECT	S.ClientGUID
     ,	S.ClientFullNameAltCalc
     ,	S.ClientHomeCenterID
     ,	S.HairSystemOrderGUID
     ,	S.AppliedDate
     ,	S.ClientMembershipGUID
     ,	S.MembershipDescription
	 ,	SC.SalesCodeID
INTO #initial
FROM #system S
INNER JOIN dbo.datSalesOrder SO
	ON S.ClientHomeCenterID = SO.ClientHomeCenterID AND S.ClientGUID = SO.ClientGUID
INNER JOIN dbo.datSalesOrderDetail SOD
	ON S.HairSystemOrderGUID = SOD.HairSystemOrderGUID
INNER JOIN cfgSalesCode SC
	ON SOD.SalesCodeID = SC.SalesCodeID
WHERE S.RevenueGroupID = 1
AND SOD.SalesCodeID = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescription = 'Initial New Style')
GROUP BY S.ClientGUID
       , S.ClientFullNameAltCalc
       , S.ClientHomeCenterID
       , S.HairSystemOrderGUID
       , S.AppliedDate
       , S.ClientMembershipGUID
       , S.MembershipDescription
       , SC.SalesCodeID

/****************** Update the records in #system that are Initial New Styles *************************************/

UPDATE sys
SET sys.IsInitialNewStyle = 1, sys.RevenueGroupID = 4, sys.RevenueGroupDescription = 'Initial New Style'
FROM #system sys
INNER JOIN #initial ini
ON ini.HairSystemOrderGUID = sys.HairSystemOrderGUID
WHERE sys.IsInitialNewStyle = 0

/***************** Final select **********************************************************************************/

SELECT CTR.MainGroupID
,	CTR.MainGroupDescription
,	S.ClientHomeCenterID
,	CTR.CenterDescriptionFullCalc
,	S.ClientFullNameAltCalc
,	S.HairSystemOrderDate
,	S.HairSystemOrderGUID
,	S.HairSystemOrderNumber
,	S.AppliedDate
,	S.HairSystemID
,	S.HairSystemDesignTemplateID
,	S.HairSystemDesignTemplateDescription
,	S.HairSystemDesignTemplateDescriptionShort
,	S.ClientMembershipGUID
,	S.MembershipDescription
,	S.RevenueGroupID
,	S.RevenueGroupDescription
,	S.[Priority]
,	S.ApplicationType
,	ISNULL(OO.OnOrder ,0) AS 'OnOrder'
,	S.IsInitialNewStyle
FROM #system S
INNER JOIN #Centers CTR
	ON S.ClientHomeCenterID = CTR.CenterID
LEFT JOIN #OnOrder OO
	ON OO.ClientGUID = S.ClientGUID



END
