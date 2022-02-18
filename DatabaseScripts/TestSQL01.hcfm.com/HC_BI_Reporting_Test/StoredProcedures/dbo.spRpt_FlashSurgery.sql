/* CreateDate: 09/19/2013 16:32:48.250 , ModifyDate: 01/29/2021 13:21:22.653 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_FlashSurgery]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reportint]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	This procedure is the new Surgery Flash report
==============================================================================
NOTES:

10/09/2013 - MB - Changed the Procedure Done revenue amount to come from surgery perform transaction
02/20/2014 - DL - Joined on DimSalesOrder instead of on FactSalesTransactions for the ClientMembershipKey
10/14/2016 - RH - (#130381) Changed @Filter from 2 = "By RSM" to "By Area Manager"
01/05/2017 - RH - (#132688) Changed EmployeeFullName to CenterManagementAreaDescription
10/16/2017 - RH - (#143906) Changed logic for Area Manager; Added CenterSSID for the drill-down; Added Active = 'Y' for Center
04/09/2018 - RH - (#148857) Removed Regions, Added CenterType, Removed Hans Weimann
04/09/2018 - RH - (#148857) Added Add-Ons
02/27/2019 - RH - Case #7979 Added CT.CenterTypeDescriptionShort = 'C';
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_FlashSurgery] '4/1/2018', '4/15/2018', 2
EXEC [spRpt_FlashSurgery] '4/1/2018', '4/15/2018', 3
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_FlashSurgery] (
	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
) AS
BEGIN
SET NOCOUNT ON

/*
	@Filter
	-------
	2 = By Area Manager
	3 = By BOS Office
*/

/************ Create temp tables ***************************************************/

CREATE TABLE #Centers (
	MainGroup VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	SortOrder INT
)


CREATE TABLE #Final(
	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	FirstSurgerySold INT
,	FirstSurgeryProjectedRevenue MONEY
,	AdditionalSurgerySold INT
,	AdditionalSurgeryProjectedRevenue MONEY
,	PostEXTSold INT
,	PostEXTProjectedRevenue MONEY
,	ProceduresDone INT
,	Revenue MONEY
,	RPP MONEY
,	Grafts INT
,	PerGraft DECIMAL(13,2)
,	AddOnSold INT
,	AddOnProjectedRevenue MONEY
)

/***************** Find the centers *********************************************************************************************/


IF @Filter = 2										--By Area Managers
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CMA.CenterManagementAreaDescription AS 'MainGroup'
			,	C.CenterDescriptionNumber
			,	C.CenterKey
			,	C.CenterNumber
			,	C.CenterSSID
			,	CMA.CenterManagementAreaSortOrder AS 'SortOrder'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON C.CenterTypeKey = CT.CenterTypeKey
		WHERE	CMA.Active = 'Y'
		AND CT.CenterTypeDescriptionShort = 'C'
			AND C.CenterKey <> 212  --Hans Wiemann
		ORDER BY CMA.CenterManagementAreaSortOrder
END

IF @Filter = 3										--By BOS Office Centers
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT BOS.BOSOffice AS 'MainGroup'
	,	C.CenterDescriptionNumber
	,	C.CenterKey
	,	C.CenterNumber
	,	C.CenterSSID
	,	NULL AS 'SortOrder'
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		INNER JOIN dbo.lkpBOSOfficeHCCenter BOS
			ON C.CenterSSID = BOS.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
	WHERE CT.CenterTypeDescriptionShort = 'C'
		AND C.Active = 'Y'
		AND C.CenterKey <> 212  --Hans Wiemann
END

/***************** Find First Surgery, Additional Surgery and PostEXT Sales *************************************************************/

SELECT FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey
,	SUM(CASE WHEN CM.MembershipSSID=43 AND FST.S_SurCnt = 1 THEN 1 ELSE 0 END) AS 'FirstSurgerySold'
,	SUM(CASE WHEN CM.MembershipSSID=44 THEN 1 ELSE 0 END) AS 'AdditionalSurgerySold'
,	SUM(CASE WHEN CM.MembershipSSID=13 AND FST.S_PostExtCnt = 1 THEN 1 ELSE 0 END) AS 'PostEXTSold'
,	SUM(CASE WHEN CM.MembershipSSID=43  AND FST.S_SurCnt = 1 THEN CM.ClientMembershipContractPrice ELSE 0 END) AS 'FirstSurgeryProjectedRevenue'
,	SUM(CASE WHEN CM.MembershipSSID=44 THEN CM.ClientMembershipContractPrice ELSE 0 END) AS 'AdditionalSurgeryProjectedRevenue'
,	SUM(CASE WHEN CM.MembershipSSID=13 AND FST.S_PostExtCnt = 1 THEN CM.ClientMembershipContractPrice ELSE 0 END) AS 'PostEXTProjectedRevenue'
,	SUM(FST.S_SurCnt) AS 'S_SurCnt'
,	SUM(FST.S_PostExtCnt) AS 'S_PostExtCnt'
INTO #Sold
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON DSO.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN #Centers CTR
		ON FST.CenterKey = CTR.CenterKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
		ON FST.ClientMembershipKey = APPT.ClientMembershipKey
		AND APPT.AppointmentSubject='Surgery Scheduled'
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (
			(FST.S_SurCnt >= 1 AND CM.MembershipSSID IN (43, 44))
		OR FST.S_PostExtCnt >= 1
		)
GROUP BY FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey


 /***************** Confirm sales with (FirstSurgerySold <> 0 or AdditionalSurgerySold <> 0 OR PostEXTSold <> 0) from above *************/

SELECT *
INTO #Confirmed_Sold
FROM #Sold
WHERE (FirstSurgerySold <> 0 or AdditionalSurgerySold <> 0 OR PostEXTSold <> 0)

/***************** Find Procedures Done ************************************************************************************************/

SELECT FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey
,	1 AS 'ProceduresDone'
,	SUM(FST.ExtendedPrice) AS 'ProjectedRevenue'
,	SUM(FST.ExtendedPrice) AS 'Revenue'
,	SUM(FST.ExtendedPrice) AS 'RPP'
,	SUM(FST_Grafts.Quantity) AS 'Grafts'
INTO #Done
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON DSO.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN #Centers CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST_Grafts
		ON CM.ClientMembershipKey = FST_Grafts.ClientMembershipKey
		AND FST_Grafts.SalesCodeKey=1701
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey = 1701
GROUP BY FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey

/****************** Find Add-Ons ********************************************************************************/

--Find Add-Ons SalesCodeKeys

SELECT SalesCodeKey,
       SalesCodeSSID,
       SalesCodeDescription,
       SalesCodeDescriptionShort
INTO #AddOnSalesCodes
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE (SalesCodeDescription LIKE '%TriGen%'OR SalesCodeDescription LIKE '%Medical%Add-On%')
	AND SalesCodeTypeDescription = 'Membership'

--Then pull these SalesCodeKeys from FST

IF OBJECT_ID('tempdb..#AddOn') IS NOT NULL
BEGIN
	DROP TABLE #AddOn
END
SELECT DD.FullDate
,	FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey
,	FST.SalesCodeKey
,	AOSC.SalesCodeDescription
,	FST.ExtendedPrice
INTO #AddOn
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN #AddOnSalesCodes AOSC
		ON FST.SalesCodeKey = AOSC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON DSO.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN #Centers CTR
		ON FST.CenterKey = CTR.CenterKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY DD.FullDate
,	FST.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	FST.ClientKey
,	FST.SalesCodeKey
,	AOSC.SalesCodeDescription
,	FST.ExtendedPrice


SELECT CenterKey
,	CenterNumber
,	CenterSSID
,	COUNT(ClientKey) AS 'AddOnSold'
,	SUM(ISNULL(ExtendedPrice,0)) AS 'AddOnProjectedRevenue'
INTO #AddOnSum
FROM #AddOn
GROUP BY CenterKey,
       CenterNumber,
       CenterSSID


/************* Combine all into the Final table ******************************************************************/

INSERT INTO #Final
SELECT ISNULL(CS.CenterKey, D.CenterKey) AS 'CenterKey'
,	ISNULL(CS.CenterNumber, D.CenterNumber) AS 'CenterNumber'
,	ISNULL(CS.CenterSSID, D.CenterSSID) AS 'CenterSSID'
,	SUM(ISNULL(CS.FirstSurgerySold, 0)) AS 'FirstSurgerySold'
,	SUM(ISNULL(CS.FirstSurgeryProjectedRevenue, 0)) AS 'FirstSurgeryProjectedRevenue'
,	SUM(ISNULL(CS.AdditionalSurgerySold, 0)) AS 'AdditionalSurgerySold'
,	SUM(ISNULL(CS.AdditionalSurgeryProjectedRevenue, 0)) AS 'AdditionalSurgeryProjectedRevenue'
,	SUM(ISNULL(CS.PostEXTSold, 0)) AS 'PostEXTSold'
,	SUM(ISNULL(CS.PostEXTProjectedRevenue, 0)) AS 'PostEXTProjectedRevenue'
,	SUM(ISNULL(D.ProceduresDone, 0)) AS 'ProceduresDone'
,	SUM(ISNULL(D.Revenue, 0)) AS 'Revenue'
,	dbo.DIVIDE(SUM(ISNULL(D.Revenue, 0)), SUM(ISNULL(D.ProceduresDone, 0))) AS 'RPP'
,	SUM(ISNULL(D.Grafts, 0)) AS 'Grafts'
,	dbo.DIVIDE(SUM(ISNULL(D.Revenue, 0)), SUM(ISNULL(D.Grafts, 0))) AS 'PerGraft'
,	NULL AS 'AddOnSold'
,	NULL AS 'AddOnProjectedRevenue'
FROM #Confirmed_Sold CS
	FULL OUTER JOIN #Done D
		ON CS.CenterKey = D.CenterKey
		AND CS.ClientKey = D.ClientKey
GROUP BY ISNULL(CS.CenterKey, D.CenterKey)
,	ISNULL(CS.CenterNumber, D.CenterNumber)
,	ISNULL(CS.CenterSSID, D.CenterSSID)
UNION
SELECT CenterKey
,	CenterNumber
,	CenterSSID
,	NULL AS 'FirstSurgerySold'
,	NULL AS 'FirstSurgeryProjectedRevenue'
,	NULL AS 'AdditionalSurgerySold'
,	NULL AS 'AdditionalSurgeryProjectedRevenue'
,	NULL AS 'PostEXTSold'
,	NULL AS 'PostEXTProjectedRevenue'
,	NULL AS 'ProceduresDone'
,	NULL AS 'Revenue'
,	NULL AS 'RPP'
,	NULL 'Grafts'
,	NULL AS 'PerGraft'
,	SUM(ISNULL(AddOnSold,0)) AS 'AddOnSold'
,	SUM(ISNULL(AddOnProjectedRevenue,0)) AS 'AddOnProjectedRevenue'
FROM #AddOnSum
GROUP BY CenterKey,
         CenterNumber,
         CenterSSID


/*************  The final select statement  *********************************************************/

SELECT ISNULL(C.MainGroup, 'Unknown') AS 'MainGroup'
,	C.CenterDescriptionNumber
,	C.CenterNumber
,	C.CenterSSID
,	C.SortOrder
,	SUM(ISNULL(F.FirstSurgerySold, 0)) AS 'FirstSurgerySold'
,	SUM(ISNULL(F.FirstSurgeryProjectedRevenue, 0)) AS 'FirstSurgeryProjectedRevenue'
,	SUM(ISNULL(F.AdditionalSurgerySold, 0)) AS 'AdditionalSurgerySold'
,	SUM(ISNULL(F.AdditionalSurgeryProjectedRevenue, 0)) AS 'AdditionalSurgeryProjectedRevenue'
,	SUM(ISNULL(F.PostEXTSold, 0)) AS 'PostEXTSold'
,	SUM(ISNULL(F.PostEXTProjectedRevenue, 0)) AS 'PostEXTProjectedRevenue'
,	SUM(ISNULL(F.ProceduresDone, 0)) AS 'ProceduresDone'
,	SUM(ISNULL(F.Revenue, 0)) AS 'Revenue'
,	SUM(ISNULL(F.RPP, 0)) AS 'RPP'
,	SUM(ISNULL(F.Grafts, 0)) AS 'Grafts'
,	SUM(ISNULL(F.PerGraft, 0)) AS 'PerGraft'
,	SUM(ISNULL(F.AddOnSold,0)) AS 'AddOnSold'
,	SUM(ISNULL(F.AddOnProjectedRevenue,0)) AS 'AddOnProjectedRevenue'
FROM #Centers C
	LEFT OUTER JOIN #Final F
		ON C.CenterKey = F.CenterKey
GROUP BY ISNULL(C.MainGroup, 'Unknown'),
         C.CenterDescriptionNumber,
         C.CenterNumber,
         C.CenterSSID,
		 C.SortOrder

END
GO
