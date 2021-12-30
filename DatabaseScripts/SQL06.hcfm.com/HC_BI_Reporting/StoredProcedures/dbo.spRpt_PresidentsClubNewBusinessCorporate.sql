/* CreateDate: 03/16/2017 16:10:11.337 , ModifyDate: 01/02/2019 16:26:55.837 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_PresidentsClubNewBusinessCorporate]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/02/2013
------------------------------------------------------------------------
CHANGE HISTORY:

01/27/2014 - DL - Removed EXT % column and replaced it with Hair % (#96819)
04/03/2014 - RH - Removed an additional SalesCodeKey = 468 for Center Transfer
11/21/2014 - RH - Added NB_XtrCnt and NB_XtrAmt for Xtrands to the fields and to the Net Sales counts.
11/24/2014 - RH - Removed Xtrands to be added Jan 2015.  Removed PostEXT from the formulas for Sales Mix.
					Added NetNB1Count_PostEXT for the Consultations ratio - it should include PostEXT per MO.
12/03/2014 - RH - (#109323) Added NetNB1Sales_PostEXT; Added Xtrands per Rev
01/28/2015 - RH - (#111093) Added Xtrands back in for 2015 for NetNB1Count and NetNB1Sales
12/16/2015 - RH - (#121325) Changed Sales to reflect home center in order to match the Flash report
12/29/2015 - RH - (#121868) BOSAppt was changed to a Consultation per MO
03/16/2017 - RH - (#135232) Changed to 2017 requirements
05/19/2017 - RH - (#138367) Changed logic to find consultations to match Closing by Consultant
11/28/2017 - RH - (#144997) Changed logic to join on DimActivityDemographic to find the Performer (Salesforce Integration issue)
12/15/2017 - RH - (#145768) President's Club report was showing duplicates - changed the logic to match the new Closing by Consultant
12/19/2018 - RH - Changed the code to find Consultations, Changed Region to Area
01/02/2019 - RH - (Case 7167) Revisited code for Performer for NSD's
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_PresidentsClubNewBusinessCorporate] 2, '1/1/2018', '11/30/2018'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubNewBusinessCorporate]
(
	@CenterType INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterManagementAreaSSID INT
,   CenterManagementAreaDescription  NVARCHAR(50)
,   CenterDescriptionNumber NVARCHAR(150)
)


CREATE TABLE #Consultations (
    CenterNumber INT
,	EmployeeFullName NVARCHAR(255)
,	Consultations INT
)

CREATE TABLE #Sales (
    CenterNumber INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(255)
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Count_PostEXT INT
,	NetNB1Sales INT
,	NetNB1Sales_PostEXT INT
,	NB_TradCnt INT
,	NB_TradAmt MONEY
,	NB_EXTCnt INT
,	NB_EXTAmt MONEY
,	NB_GradCnt INT
,	NB_GradAmt MONEY
,	NB_XTRCnt INT
,	NB_XTRAmt MONEY
,	S_SurCnt INT
,	S_SurAmt MONEY
,	S_PostExtCnt INT
,	S_PostExtAmt MONEY
,	HairSalesCount INT
,	TradGradExtCount INT
,	TradGradExtSales MONEY
,	NB_AppsCnt INT
)

CREATE TABLE #Results (
    CenterNumber INT
,	EmployeeKey INT
,	EmployeeFullName NVARCHAR(255)
,	Consultations INT
,	NetNB1Count INT
,	NetNB1Count_PostEXT INT
,	NetNB1Sales INT
,	NetNB1Sales_PostEXT INT
,	NB_TradCnt INT
,	NB_TradAmt MONEY
,	NB_EXTCnt INT
,	NB_EXTAmt MONEY
,	NB_GradCnt INT
,	NB_GradAmt MONEY
,	NB_XTRCnt INT
,	NB_XTRAmt MONEY
,	S_SurCnt INT
,	S_SurAmt MONEY
,	S_PostExtCnt INT
,	S_PostExtAmt MONEY
,	HairSalesCount INT
,	TradGradExtCount INT
,	TradGradExtSales MONEY
,	NB_AppsCnt INT
)

/********************************** Get list of centers *************************************/
IF @CenterType = 2
BEGIN
INSERT  INTO #Centers
SELECT  DC.CenterKey
	,	DC.CenterNumber
	,	DC.CenterSSID
	,	CMA.CenterManagementAreaSSID
	,   CMA.CenterManagementAreaDescription
	,   DC.CenterDescriptionNumber
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
            ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DC.CenterTypeKey = DCT.CenterTypeKey
WHERE	DCT.CenterTypeDescriptionShort = 'C'
		AND DC.Active = 'Y'

END


/********************************** Get consultations  *************************************/
SELECT CTR.CenterNumber
,	DD.FullDate AS ActivityDueDate
,	E.EmployeeFullName
,	CASE WHEN (FAR.Consultation = 1 ) THEN 1 ELSE 0 END AS 'IsConsultation'
,	APPT.SFDC_LeadID
,	C.ContactFullName
INTO #Consults
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR  WITH (NOLOCK)
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FAR.ActivityDueDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH (NOLOCK)
		ON FAR.CenterKey = CTR.CenterKey
	INNER JOIN #Centers
		ON CTR.CenterKey = #Centers.CenterKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact C
	ON C.ContactKey = FAR.ContactKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
	ON APPT.CenterKey = FAR.CenterKey
	AND APPT.AppointmentDate = DD.FullDate
	AND APPT.SFDC_LeadID = C.SFDC_LeadID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
	ON FAE.AppointmentKey = APPT.AppointmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeKey = FAE.EmployeeKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND FAR.Show=1
	AND (FAR.Consultation=1)
	AND FAR.CenterKey IN (SELECT CenterKey FROM #Centers)
	AND APPT.IsDeletedFlag = 0


SELECT CenterNumber
,	EmployeeFullName
,	SUM(IsConsultation) AS 'Consultations'
INTO #NetConsultations
FROM #Consults
GROUP BY CenterNumber
,	EmployeeFullName


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  DC.CenterNumber
		,		FST.Employee1Key AS 'EmployeeKey'
		,		EM.EmployeeFullName
		,		SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.NB_XTRCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                --+ SUM(ISNULL(FST.S_PostExtCnt, 0))
					AS 'NetNB1Count'
		,       SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.NB_XTRCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0))
					AS 'NetNB1Count_PostEXT'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                --+ SUM(ISNULL(FST.S_PostExtAmt, 0))
					AS 'NetNB1Sales'
		  ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.NB_XTRAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0))
					AS 'NetNB1Sales_PostEXT'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NB_TradCnt'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NB_TradAmt'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NB_ExtCnt'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NB_ExtAmt'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NB_GradCnt'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NB_GradAmt'
		,		SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NB_XtrCnt'
		,		SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NB_XtrAmt'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'S_SurCnt'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'S_SurAmt'
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'S_PostExtCnt'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'S_PostExtAmt'
		,       SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'HairSalesCount'
		,		SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'TradGradExtCount'
		,		SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'TradGradExtSales'
		,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB_AppsCnt'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
					ON FST.Employee1Key = EM.EmployeeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON CM.MembershipKey = M.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC   --Keep as Home Center
                    ON CM.CenterKey = DC.CenterKey
                INNER JOIN #Centers
                    ON DC.CenterKey = #Centers.CenterKey
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668, 468 )
                AND SOD.IsVoidedFlag = 0
        GROUP BY DC.CenterNumber
		,		FST.Employee1Key
		,		EM.EmployeeFullName



/********************************** Combine Consultations & Sales Data *************************************/
INSERT INTO #Results
SELECT    CenterNumber
,	EmployeeKey
,   ISNULL(EmployeeFullName, 'Unknown, Unknown') AS 'EmployeeFullName'
,   0 AS 'Consultations'
,   ISNULL(NetNB1Count, 0) AS 'NetNB1Count'
,	ISNULL(NetNB1Count_PostEXT, 0) AS 'NetNB1Count_PostEXT'
,   ISNULL(NetNB1Sales, 0) AS 'NetNB1Sales'
,   ISNULL(NetNB1Sales_PostEXT, 0) AS 'NetNB1Sales_PostEXT'
,   ISNULL(NB_TradCnt, 0) AS 'NB_TradCnt'
,   ISNULL(NB_TradAmt, 0) AS 'NB_TradAmt'
,   ISNULL(NB_EXTCnt, 0) AS 'NB_EXTCnt'
,   ISNULL(NB_ExtAmt, 0) AS 'NB_ExtAmt'
,   ISNULL(NB_GradCnt, 0) AS 'NB_GradCnt'
,   ISNULL(NB_GradAmt, 0) AS 'NB_GradAmt'
,   ISNULL(NB_XTRCnt, 0) AS 'NB_XTRCnt'
,   ISNULL(NB_XTRCnt, 0) AS 'NB_XTRAmt'
,   ISNULL(S_SurCnt, 0) AS 'S_SurCnt'
,   ISNULL(S_SurAmt, 0) AS 'S_SurAmt'
,   ISNULL(S_PostExtCnt, 0) AS 'S_PostExtCnt'
,   ISNULL(S_PostExtAmt, 0) AS 'S_PostExtAmt'
,   ISNULL(HairSalesCount, 0) AS 'HairSalesCount'
,   ISNULL(TradGradExtCount, 0) AS 'TradGradExtCount'
,   ISNULL(TradGradExtSales, 0) AS 'TradGradExtSales'
,	ISNULL(NB_AppsCnt,0) AS 'NB_AppsCnt'
FROM      #Sales
UNION
SELECT    CenterNumber
,	NULL AS 'EmployeeKey'
,	ISNULL(EmployeeFullName, 'Unknown, Unknown') AS 'EmployeeFullName'
,	ISNULL(Consultations, 0) AS 'Consultations'
,	0 AS 'NetNB1Count'
,	0 AS 'NetNB1Count_PostEXT'
,	0 AS 'NetNB1Sales'
,	0 AS 'NetNB1Sales_PostEXT'
,	0 AS 'NB_TradCnt'
,	0 AS 'NB_TradAmt'
,	0 AS 'NB_ExtCnt'
,	0 AS 'NB_ExtAmt'
,	0 AS 'NB_GradCnt'
,	0 AS 'NB_GradAmt'
,	0 AS 'NB_XTRCnt'
,	0 AS 'NB_XTRAmt'
,	0 AS 'S_SurCnt'
,	0 AS 'S_SurAmt'
,	0 AS 'S_PostExtCnt'
,	0 AS 'S_PostExtAmt'
,	0 AS 'HairSalesCount'
,	0 AS 'TradGradExtCount'
,	0 AS 'TradGradExtSales'
,	0 AS 'NB_AppsCnt'
FROM      #NetConsultations



SELECT  Results.CenterNumber
,		Results.EmployeeKey
,       Results.EmployeeFullName
,       SUM(Consultations) AS 'Consultations'
,       SUM(NetNB1Count) AS 'NetNB1Count'
,		SUM(NetNB1Count_PostEXT) AS 'NetNB1Count_PostEXT'
,       SUM(NetNB1Sales) AS 'NetNB1Sales'
,		SUM(NetNB1Sales_PostEXT) AS 'NetNB1Sales_PostEXT'
,       SUM(NB_TradCnt) AS 'NB_TradCnt'
,       SUM(NB_TradAmt) AS 'NB_TradAmt'
,       SUM(NB_ExtCnt) AS 'NB_ExtCnt'
,       SUM(NB_ExtAmt) AS 'NB_ExtAmt'
,       SUM(NB_GradCnt) AS 'NB_GradCnt'
,       SUM(NB_GradAmt) AS 'NB_GradAmt'
,       SUM(NB_XTRCnt) AS 'NB_XTRCnt'
,       SUM(NB_XTRAmt) AS 'NB_XTRAmt'
,       SUM(S_SurCnt) AS 'S_SurCnt'
,       SUM(S_SurAmt) AS 'S_SurAmt'
,       SUM(S_PostExtCnt) AS 'S_PostExtCnt'
,       SUM(S_PostExtAmt) AS 'S_PostExtAmt'
,       SUM(HairSalesCount) AS 'HairSalesCount'
,       SUM(TradGradExtCount) AS 'TradGradExtCount'
,       SUM(TradGradExtSales) AS 'TradGradExtSales'
,       SUM(NB_AppsCnt) AS 'NB_AppsCnt'
INTO #NetResults
FROM #Results Results
GROUP BY Results.CenterNumber
,		Results.EmployeeKey
,       Results.EmployeeFullName




/**************** UPDATE some names that have changed *************************/

UPDATE #NetResults
SET EmployeeFullName =  'Easterling Babin, Gerald' WHERE EmployeeFullName = 'Easterling, Gerald'

UPDATE #NetResults
SET EmployeeFullName =  'Ecker-Tsai, Emily' WHERE EmployeeFullName = 'Ecker, Emily'

/********  SUM the records to combine two records into one ********************/

SELECT
	CenterNumber
,	NULL AS EmployeeKey
,	EmployeeFullName
,	SUM(Consultations) AS 'Consultations'
,	SUM(NetNB1Count) AS 'NetNB1Count'
,	SUM(NetNB1Count_PostEXT) AS 'NetNB1Count_PostEXT'
,	SUM(NetNB1Sales) AS 'NetNB1Sales'
,	SUM(NetNB1Sales_PostEXT) AS 'NetNB1Sales_PostEXT'
,	SUM(NB_TradCnt) AS 'NB_TradCnt'
,	SUM(NB_TradAmt) AS 'NB_TradAmt'
,	SUM(NB_EXTCnt) AS 'NB_EXTCnt'
,	SUM(NB_EXTAmt) AS 'NB_EXTAmt'
,	SUM(NB_GradCnt) AS 'NB_GradCnt'
,	SUM(NB_GradAmt) AS 'NB_GradAmt'
,	SUM(NB_XTRCnt) AS 'NB_XTRCnt'
,	SUM(NB_XTRAmt) AS 'NB_XTRAmt'
,	SUM(S_SurCnt) AS 'S_SurCnt'
,	SUM(S_SurAmt) AS 'S_SurAmt'
,	SUM(S_PostExtCnt) AS 'S_PostExtCnt'
,	SUM(S_PostExtAmt) AS 'S_PostExtAmt'
,	SUM(HairSalesCount) AS 'HairSalesCount'
,	SUM(TradGradExtCount) AS 'TradGradExtCount'
,	SUM(TradGradExtSales) AS 'TradGradExtSales'
,	SUM(NB_AppsCnt) AS 'NB_AppsCnt'
INTO #SumResults
FROM #NetResults
GROUP BY CenterNumber
,	EmployeeFullName


/*****************UPDATE records with EmployeeKey *****************************/

UPDATE #SumResults
SET #SumResults.EmployeeKey = ISNULL(E.EmployeeKey,-1)
FROM #SumResults
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeFullName = #SumResults.EmployeeFullName
WHERE #SumResults.EmployeeKey IS NULL


/********This next section is to find initial applications, and then the consultant that initially sold the Trad or Grad membership to the client ***********/

DECLARE @BeginningOfTheYear DATETIME
DECLARE @BeginningOfThePreviousYear DATETIME

SET @BeginningOfTheYear = CAST('1/1/' + CAST(YEAR(@StartDate)AS NVARCHAR(4)) AS DATETIME)
SET @BeginningOfThePreviousYear = DATEADD(YEAR,-1,@BeginningOfTheYear)


CREATE TABLE #NB1A(
	NB1A DATETIME
,	SalesOrderDetailKey INT
,	SalesOrderKey INT
,	SalesCodeDescription NVARCHAR(50)
,	SalesCodeDescriptionShort NVARCHAR(10)
,	Quantity INT
,	Employee1Initials NVARCHAR(10)
,	CenterKey INT
,	ClientKey INT
,	EmployeeKey INT
)


CREATE TABLE #NBSalesWithApps(
	CenterKey INT
,	EmployeeKey INT
,	Quantity INT
)



--Find clients with NB1A's --Query to find Initial New Styles

INSERT INTO #NB1A
SELECT DD.FullDate AS NB1A
,	SOD.SalesOrderDetailKey
,	SOD.SalesOrderKey
,	SOD.SalesCodeDescription
,	SOD.SalesCodeDescriptionShort
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS Quantity
,	E.EmployeeInitials AS Employee1Initials
,	FST.CenterKey
,	FST.ClientKey
,	E.EmployeeKey
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FST.OrderDateKey = DD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON DSO.SalesOrderKey = SOD.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
	ON SC.SalesCodeKey = FST.SalesCodeKey
INNER JOIN #Centers
	ON FST.CenterKey = #Centers.CenterKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	ON E.EmployeeKey = DSO.EmployeeKey
LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = FST.MembershipKey
WHERE DSO.OrderDate BETWEEN @BeginningOfTheYear AND @EndDate
AND SC.SalesCodeDescriptionShort = 'NB1A'
AND SOD.IsClosedFlag > 0
AND SOD.IsVoidedFlag = 0


----Then find the sales for those clients using the @BeginningOfThePreviousYear
SELECT DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key AS EmployeeKey
,	1 AS Quantity  --FST.Quantity will show too many for surgery
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription
INTO #INITASG
FROM  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = dd.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
						ON fst.SalesCodeKey = sc.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON SO.ClientMembershipKey = DCM.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON DCM.MembershipKey = m.MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON DCM.CenterKey = C.CenterKey
WHERE DD.FullDate >= @BeginningOfThePreviousYear
AND SC.SalesCodeDescriptionShort  = 'INITASG'
AND FST.ClientKey IN(SELECT ClientKey FROM #NB1A)
AND SOD.IsVoidedFlag = 0
AND M.MembershipDescription NOT IN('New Client (ShowNoSale)','New Client (Surgery Offered)')
GROUP BY DD.FullDate
,	FST.ClientKey
,	FST.CenterKey
,	FST.ClientMembershipKey
,	FST.MembershipKey
,	FST.Employee1Key
,	FST.Quantity
,	SC.SalesCodeDescriptionShort
,	M.MembershipDescription

INSERT INTO #NBSalesWithApps
SELECT CenterKey, EmployeeKey, SUM(Quantity) AS Quantity
FROM #INITASG
GROUP BY CenterKey, EmployeeKey



/********************************** Display By Region/Center/Performer *************************************/

SELECT  R.CenterNumber AS 'CenterID'
,       #Centers.CenterManagementAreaSSID AS 'RegionID'
,       #Centers.CenterManagementAreaDescription AS 'region'
,       #Centers.CenterDescriptionNumber AS 'center'
,		R.EmployeeKey
,		R.EmployeeFullName  --Use in the header of the report
,		R.Consultations AS consultations
,       R.NetNB1Count
,       R.NetNB1Count_PostEXT
,		R.NetNB1Sales
,		R.NetNB1Sales_PostEXT
,       dbo.DIVIDE_DECIMAL(ISNULL(R.NetNB1Count_PostEXT, 0), ISNULL(R.Consultations, 0)) AS 'ClosePercent'
,		dbo.DIVIDE_DECIMAL(R.NetNB1Sales_PostEXT, R.NetNB1Count_PostEXT) AS 'NetDollarsOverCount'
,       R.HairSalesCount AS 'netHairSales'
,		R.NB_EXTAmt AS 'EXTSales'
,		dbo.DIVIDE_DECIMAL(R.HairSalesCount, R.NetNB1Count) AS 'HairSalesPercent'
,		ISNULL(SWA.Quantity,0) AS NB_AppsCnt
,		ISNULL(R.NB_TradCnt,0) AS 'NB_TradCnt'
,		ISNULL(R.NB_GradCnt,0) AS 'NB_GradCnt'
FROM    #SumResults R
        INNER JOIN #Centers
			ON R.CenterNumber = #Centers.CenterNumber
		LEFT JOIN #NBSalesWithApps SWA
			ON (SWA.EmployeeKey = R.EmployeeKey AND SWA.CenterKey = #Centers.CenterKey)
WHERE (ISNULL(R.HairSalesCount,0) <> 0
		OR ISNULL(R.Consultations,0) <> 0
		OR ISNULL(R.NetNB1Count,0) <> 0
		OR ISNULL(SWA.Quantity,0) <> 0)
GROUP BY R.CenterNumber
,       #Centers.CenterManagementAreaSSID
,       #Centers.CenterManagementAreaDescription
,       #Centers.CenterDescriptionNumber
,		R.EmployeeKey
,		R.EmployeeFullName
,		R.Consultations
,       R.NetNB1Count
,       R.NetNB1Count_PostEXT
,		R.NetNB1Sales
,		R.NetNB1Sales_PostEXT
,       dbo.DIVIDE_DECIMAL(ISNULL(R.NetNB1Count_PostEXT, 0), ISNULL(R.Consultations, 0))
,		dbo.DIVIDE_DECIMAL(R.NetNB1Sales_PostEXT, R.NetNB1Count_PostEXT)
,       R.HairSalesCount
,		R.NB_EXTAmt
,		dbo.DIVIDE_DECIMAL(R.HairSalesCount, R.NetNB1Count)
,		ISNULL(SWA.Quantity,0)
,		ISNULL(R.NB_TradCnt,0)
,		ISNULL(R.NB_GradCnt,0)

END
GO
