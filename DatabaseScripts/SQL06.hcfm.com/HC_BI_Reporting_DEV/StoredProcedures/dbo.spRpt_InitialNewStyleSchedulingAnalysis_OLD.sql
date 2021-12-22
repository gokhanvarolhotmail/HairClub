/* CreateDate: 11/07/2019 14:42:06.397 , ModifyDate: 11/07/2019 14:42:06.397 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
06/12/2016	RH - Added code to show ALL centers whether or not they have scheduled or completed initial new styles
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
05/30/2017 - RH - (#138922) Added code for @EndDate; Added @PartitionStartDate and @PartitionEndDate
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_InitialNewStyleSchedulingAnalysis] '5/1/2017','5/31/2017', 3
EXEC [spRpt_InitialNewStyleSchedulingAnalysis] '5/18/2017','5/18/2017', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_InitialNewStyleSchedulingAnalysis_OLD] (
	@StartDate DATETIME
,	@EndDate DATETIME
,	@MainGroupID INT
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
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(102)
)


/********************************** Get list of centers ************************************************/


IF @MainGroupID = 1 -- By Corporate Regions
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND DC.Active = 'Y'
END

IF @MainGroupID = 2 -- By Franchise Regions
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		'F' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			,		NULL AS CenterManagementAreaSSID
			,		NULL AS CenterManagementAreaDescription
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
					AND DC.Active = 'Y'
END

IF @MainGroupID = 3 -- By Area Managers
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		'C' AS CenterTypeDescriptionShort
			,		DC.CenterKey
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			FROM  HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND CMA.Active = 'Y'

END

/************************************* Find Budgets for Centers for Initial New Styles ****************************/

SELECT CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CASE WHEN FA.AccountID = 10240 THEN SUM(ISNULL(FA.Budget,0)) END AS 'Budget'
INTO #Budget
FROM #Centers CTR
LEFT JOIN HC_Accounting.dbo.FactAccounting FA
	ON CTR.CenterSSID = FA.CenterID
WHERE FA.PartitionDate BETWEEN @PartitionStartDate AND @PartitionEndDate
	AND FA.AccountID = 10240
GROUP BY CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	FA.AccountID


/********************************** Completed main select statement ************************************************/


SELECT CTR.CenterSSID
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
    ,	CTR.CenterSSID
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


SELECT  CTR.CenterSSID
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
AND APPT.IsDeletedFlag <> 1
AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Completed)
GROUP BY CTR.CenterSSID
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
,	CTR.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber
,	COUNT(C.SalesOrderKey) AS 'Completed'
,	NULL AS 'Scheduled'
INTO #Combo
FROM #completed C
INNER JOIN #Centers CTR
	ON CTR.CenterSSID = C.CenterSSID
GROUP BY CTR.MainGroupID
,	CTR.MainGroup
,	CTR.CenterSSID
,	C.CenterDescription
,	C.CenterDescriptionNumber

--Find Future Scheduled Initial New Styles

SELECT S.CenterSSID
,	S.CenterDescription
,	S.CenterDescriptionNumber
,	COUNT(S.AppointmentKey) AS 'Scheduled'
INTO #scheduledcount
FROM #scheduled S
GROUP BY  S.CenterSSID
,	S.CenterDescription
,	S.CenterDescriptionNumber

--Update the Scheduled counts in #Combo

UPDATE Combo
SET Combo.Scheduled = SCH.Scheduled
FROM #Combo Combo
LEFT JOIN #scheduledcount SCH
ON SCH.CenterSSID = Combo.CenterSSID

--Insert records that were not in #Combo

IF EXISTS(SELECT CenterSSID FROM #scheduledcount SCH WHERE SCH.CenterSSID NOT IN (SELECT CenterSSID FROM #Combo))
BEGIN
INSERT INTO #Combo
        (MainGroupID
	,	MainGroup
	,	CenterSSID
    ,	CenterDescription
    ,	CenterDescriptionNumber
	,	Scheduled
        )
SELECT CTR.MainGroupID
	,	CTR.MainGroup
	,	SCH.CenterSSID
	,	SCH.CenterDescription
	,	SCH.CenterDescriptionNumber
	,	SCH.Scheduled
FROM #scheduledcount SCH
LEFT JOIN #Centers CTR
	ON CTR.CenterSSID = SCH.CenterSSID
WHERE SCH.CenterSSID NOT IN (SELECT CenterSSID FROM #Combo)
END






/************************************* Final select, Set NULLs to zero, Add budget amounts ****************************************/

SELECT B.MainGroupID
	,	B.MainGroup
	,	B.CenterSSID
    ,	B.CenterDescription
    ,	B.CenterDescriptionNumber
    ,	ISNULL(COM.Completed,0) AS 'Completed'
	,	ISNULL(COM.Scheduled,0) AS 'Scheduled'
	,	ISNULL(ROUND(B.Budget,0), 0) AS 'Budget'
FROM #Budget B
LEFT JOIN #Combo COM
	ON COM.CenterSSID = B.CenterSSID
GROUP BY ISNULL(COM.Completed ,0)
       , ISNULL(COM.Scheduled ,0)
       , ISNULL(ROUND(B.Budget,0), 0)
       , B.MainGroupID
       , B.MainGroup
       , B.CenterSSID
       , B.CenterDescription
       , B.CenterDescriptionNumber

ORDER BY B.CenterSSID

END
GO
