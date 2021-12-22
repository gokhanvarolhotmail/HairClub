/***********************************************************************
PROCEDURE:				[spRpt_InitialNewStyleSchedulingAnalysis]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			InitialNewStyleSchedulingAnalysis.rdl
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/24/2015
------------------------------------------------------------------------
NOTES:
@MainGroupID = 1  By Corporate Regions
@MainGroupID = 2  By Franchise Regions
@MainGroupID = 3  By Area Managers
------------------------------------------------------------------------
CHANGE HISTORY:
06/12/2016 - RH - Added code to show ALL centers whether or not they have scheduled or completed initial new styles
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
05/30/2017 - RH - (#138922) Added code for @EndDate; Added @PartitionStartDate and @PartitionEndDate
01/24/2018 - RH - (#145957) Changed @MainGroupID to @Filter and changed the aspx page to match
03/12/2018 - RH - (#145957) Added CenterType for #Centers
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_InitialNewStyleSchedulingAnalysis] '3/1/2018','3/31/2018', 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_InitialNewStyleSchedulingAnalysis] (
	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
)

AS
BEGIN

/****** This code sets the @EndDate for select from FactAppointmentDetail ****************************/

IF @StartDate = @EndDate
BEGIN
SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,@StartDate+1),0) )) --@StartDate at 11:59PM
END
ELSE
BEGIN
SET @EndDate = @EndDate
END


/*************** Find @PartitionStartDate and @PartitionEndDate **************************************/

DECLARE @PartitionStartDate DATETIME
DECLARE @PartitionEndDate DATETIME

SET @PartitionStartDate = CAST(MONTH(@StartDate) AS NVARCHAR(2)) + '/1/' + CAST(YEAR(@StartDate) AS NVARCHAR(4))
SET @PartitionEndDate = CAST(MONTH(@EndDate) AS NVARCHAR(2)) + '/1/' + CAST(YEAR(@EndDate) AS NVARCHAR(4))


/********************************** Create temp tables ************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
)


/********************************** Get list of centers ************************************************/


IF @Filter = 2 -- By Corporate Areas
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterNumber
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
					AND CMA.Active = 'Y'
END

IF @Filter = 1 -- By Franchise Regions
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterSSID
			,		DC.CenterNumber
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		'F' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END


/************************************* Find Budgets for Centers for Initial New Styles ****************************/

SELECT CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.MainGroupSortOrder
	,	CTR.CenterNumber
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CASE WHEN FA.AccountID = 10240 THEN SUM(ISNULL(FA.Budget,1)) ELSE 1 END AS 'Budget'  --If Budget is zero, then set to 1
INTO #Budget
FROM #Centers CTR
LEFT JOIN HC_Accounting.dbo.FactAccounting FA
	ON CTR.CenterSSID = FA.CenterID
		AND (FA.PartitionDate BETWEEN @PartitionStartDate AND @PartitionEndDate
		AND FA.AccountID = 10240)
GROUP BY CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.MainGroupSortOrder
	,	CTR.CenterNumber
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	FA.AccountID


/********************************** Completed main select statement ************************************************/


SELECT CTR.CenterNumber
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END AS 'Gender'
	,	M.MembershipDescription
	,	SC.SalesCodeDescription
	,	DD.FullDate
	,	FST.SalesOrderKey
	,	E.EmployeeFullName
INTO #completed
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
    ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON FST.SalesCodeKey = SC.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
	ON FST.SalesOrderKey = SO.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
	ON FST.ClientMembershipKey = CM.ClientMembershipKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON CM.MembershipKey = M.MembershipKey
INNER JOIN #Centers CTR
	ON FST.CenterKey= CTR.CenterKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON FST.ClientKey = CLT.ClientKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeKey = FST.Employee2Key
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
AND SC.SalesCodeSSID = 648										-- Initial New Style (NB1A)
AND SOD.IsVoidedFlag = 0
GROUP BY CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END
    ,	CTR.CenterNumber
    ,	CTR.CenterDescription
    ,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
    ,	CLT.ClientFullName
    ,	M.MembershipDescription
	,	SC.SalesCodeDescription
	,	FST.SalesOrderKey
    ,	E.EmployeeFullName
	,	DD.FullDate

/********************************** Scheduled main select statement ************************************************/


SELECT  CTR.CenterNumber
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END AS 'Gender'
	,	M.MembershipDescription
	,	SC.SalesCodeDescription
	,	APPT.AppointmentDate
	,	APPT.AppointmentKey
	,	E.EmployeeFullName
INTO #scheduled
FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
	ON FAD.AppointmentKey = APPT.AppointmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON APPT.ClientKey = CLT.ClientKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
	ON APPT.ClientMembershipKey = CM.ClientMembershipKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON CM.MembershipKey = M.MembershipKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
	ON APPT.AppointmentKey = FAE.AppointmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON FAE.EmployeeKey = E.EmployeeKey
INNER JOIN #Centers CTR
	ON APPT.CenterKey = CTR.CenterKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON FAD.SalesCodeKey = SC.SalesCodeKey
WHERE FAD.SalesCodeKey = 601 --Initial New Style
AND APPT.AppointmentDate BETWEEN @StartDate AND @EndDate
AND APPT.IsDeletedFlag = 0
AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Completed)
AND APPT.CheckOutTime IS NULL
GROUP BY CTR.CenterNumber
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END
	,	M.MembershipDescription
	,	SC.SalesCodeDescription
	,	APPT.AppointmentDate
	,	APPT.AppointmentKey
	,	E.EmployeeFullName

/********************************** Find the final counts per center ************************************************/

--Find Completed Initial New Styles
SELECT CTR.MainGroupID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterNumber
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	COUNT(C.SalesOrderKey) AS 'Completed'
,	NULL AS 'Scheduled'
INTO #Combo
FROM #completed C
INNER JOIN #Centers CTR
	ON CTR.CenterNumber = C.CenterNumber
GROUP BY CTR.MainGroupID
,	CTR.MainGroup
,	CTR.MainGroupSortOrder
,	CTR.CenterNumber
,	C.CenterDescription
,	C.CenterDescriptionNumber

--Find Future Scheduled Initial New Styles

SELECT S.CenterNumber
,	S.CenterDescription
,	S.CenterDescriptionNumber
,	COUNT(S.AppointmentKey) AS 'Scheduled'
INTO #scheduledcount
FROM #scheduled S
GROUP BY  S.CenterNumber
,	S.CenterDescription
,	S.CenterDescriptionNumber

--Update the Scheduled counts in #Combo

UPDATE Combo
SET Combo.Scheduled = SCH.Scheduled
FROM #Combo Combo
LEFT JOIN #scheduledcount SCH
ON SCH.CenterNumber = Combo.CenterNumber

--Insert records that were not in #Combo

IF EXISTS(SELECT CenterNumber FROM #scheduledcount SCH WHERE SCH.CenterNumber NOT IN (SELECT CenterNumber FROM #Combo))
BEGIN
INSERT INTO #Combo
        (MainGroupID
	,	MainGroup
	,	MainGroupSortOrder
	,	CenterNumber
    ,	CenterDescription
    ,	CenterDescriptionNumber
	,	Scheduled
        )
SELECT CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.MainGroupSortOrder
	,	SCH.CenterNumber
	,	SCH.CenterDescription
	,	SCH.CenterDescriptionNumber
	,	SCH.Scheduled
FROM #scheduledcount SCH
LEFT JOIN #Centers CTR
	ON CTR.CenterNumber = SCH.CenterNumber
WHERE SCH.CenterNumber NOT IN (SELECT CenterNumber FROM #Combo)
END






/************************************* Final select, Set NULLs to zero, Add budget amounts ****************************************/

SELECT B.MainGroupID
	,	B.MainGroup
	,	B.MainGroupSortOrder
	,	B.CenterNumber
    ,	B.CenterDescription
    ,	B.CenterDescriptionNumber
    ,	ISNULL(COM.Completed,0) AS 'Completed'
	,	ISNULL(COM.Scheduled,0) AS 'Scheduled'
	,	ISNULL(ROUND(B.Budget,0), 1) AS 'Budget'
FROM #Budget B
LEFT JOIN #Combo COM
	ON COM.CenterNumber = B.CenterNumber
GROUP BY ISNULL(COM.Completed ,0)
    ,	ISNULL(COM.Scheduled ,0)
    ,	ISNULL(ROUND(B.Budget,0), 1)
    ,	B.MainGroupID
    ,	B.MainGroup
	,	B.MainGroupSortOrder
    ,	B.CenterNumber
    ,	B.CenterDescription
    ,	B.CenterDescriptionNumber



END
