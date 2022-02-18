/* CreateDate: 05/31/2016 16:09:31.930 , ModifyDate: 01/24/2018 12:33:02.767 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_InitialNewStyleSchedulingAnalysis_Detail]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			InitialNewStyleSchedulingAnalysisDetail.rdl
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/24/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
CHANGE HISTORY:
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID; CenterManagementAreaDescription as description; Added @DetailGroupID (#132688)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_InitialNewStyleSchedulingAnalysis_Detail] '5/1/2017','5/31/2017', 1, 3, 0

EXEC [spRpt_InitialNewStyleSchedulingAnalysis_Detail] '5/1/2017','5/31/2017', 2, 3, 0
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_InitialNewStyleSchedulingAnalysis_Detail] (
	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
,	@DetailGroupID INT
,	@IsFutureAppt INT
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

/********************************** Create temp tables ************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	CenterKey INT
)


/********************************** Get list of centers ************************************************/


IF @Filter = 1 AND @DetailGroupID < 20						-- By a Franchise Region
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
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
					AND DR.RegionSSID = @DetailGroupID
END
ELSE
IF @Filter = 1 AND @DetailGroupID > 20										-- By a Franchise Center
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DC.CenterSSID
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
					AND DC.CenterSSID = @DetailGroupID
END
ELSE
IF @Filter = 2	AND @DetailGroupID BETWEEN 1 AND 10							-- By a Corporate Area
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		DC.CenterSSID
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
					AND CMA.CenterManagementAreaSSID = @DetailGroupID
END
ELSE
IF @Filter = 2	AND @DetailGroupID > 20										-- By a Corporate Center
BEGIN
	INSERT  INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,		DC.CenterSSID
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
					AND DC.CenterSSID = @DetailGroupID
END


/********************************** Completed main select statement ************************************************/


SELECT CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END AS 'Gender'
	,	M.MembershipDescription
	,	CM.ClientMembershipBeginDate
	,	CM.ClientMembershipEndDate
	,	SC.SalesCodeDescription
	,	DD.FullDate AS 'Date'
	,	FST.SalesOrderKey AS 'Key'
	,	E.EmployeeFullName
	,	0 AS 'IsFutureAppointment'
INTO #Completed
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
    ,	CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
    ,	CTR.CenterDescription
    ,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
    ,	CLT.ClientFullName
    ,	M.MembershipDescription
	,	CM.ClientMembershipBeginDate
	,	CM.ClientMembershipEndDate
	,	SC.SalesCodeDescription
	,	FST.SalesOrderKey
    ,	E.EmployeeFullName
	,	DD.FullDate



/********************************** Scheduled main select statement ************************************************/

SELECT  CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END AS 'Gender'
	,	M.MembershipDescription
	,	CM.ClientMembershipBeginDate
	,	CM.ClientMembershipEndDate
	,	SC.SalesCodeDescription
	,	APPT.AppointmentDate AS 'Date'
	,	APPT.AppointmentKey AS 'Key'
	,	E.EmployeeFullName
	,	1 AS 'IsFutureAppointment'
INTO #Scheduled
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
WHERE FAD.SalesCodeKey = 601 --Initial New Style (NB1A)
AND APPT.AppointmentDate BETWEEN @StartDate AND @EndDate
AND APPT.IsDeletedFlag = 0
AND APPT.CheckOutTime IS NULL
AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Completed)
GROUP BY CTR.MainGroupID
	,	CTR.MainGroup
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CASE WHEN CLT.GenderSSID = 1 THEN 'M' ELSE 'F' END
	,	M.MembershipDescription
	,	CM.ClientMembershipBeginDate
	,	CM.ClientMembershipEndDate
	,	SC.SalesCodeDescription
	,	APPT.AppointmentDate
	,	APPT.AppointmentKey
	,	E.EmployeeFullName



IF @IsFutureAppt = 0											--Completed appointments
BEGIN
SELECT * FROM #Completed
END
ELSE
BEGIN
SELECT * FROM #Scheduled
END



END
GO
