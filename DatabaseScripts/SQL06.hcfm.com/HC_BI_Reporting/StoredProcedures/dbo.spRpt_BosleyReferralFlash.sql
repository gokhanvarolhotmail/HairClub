/***********************************************************************
PROCEDURE:				spRpt_BosleyReferralFlash
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		09/21/2017
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers, 4 is By Source
------------------------------------------------------------------------
CHANGE HISTORY:
09/26/2017 - RH - (#143052) Adjust Appointment, Sales, NoSales, Show and NoShow according to NB1Counts - otherwise, if there are multiple appointments per client, these values do not make sense.
10/13/2017 - RH - (#143895) Added @Filter = 4 for grouping by Source
12/07/2017 - RH - (#144147) Added ShowDate, SaleDate and ReferringConsultant from SQL01.
03/05/2018 - RH - (#145957) Remove Regions for Corporate and add join on DimCenterType
04/10/2018 - RH - (#148857) Changed the logic to use a UNION of Activities and Leads
05/10/2018 - RH - (#148857) Added logic to find additional SiebelID's by joining on ClientFullName and CenterID
08/16/2018 - RH - (Case 389)Changed to WHERE SourceName LIKE '%BOS%'
09/14/2018 - RH - (Case 389) Changed to WHERE SourceName LIKE 'BOSREF%'AND RIGHT(SourceName,1) <> '-' per Paoli; rewrote sp to match the mini-flash
09/25/2018 - RH - Source Code query still had WHERE SourceName LIKE 'BOSREF%'. Changed it to match comment above 'BOS%REF%'; Changed from SQL01 to [SQL05].[HairClubCMS].[dbo].[datIncomingRequestLog]
09/27/2018 - RH - Added AND ds.SourceSSID <> 'BOSOHREF'
01/13/2020 - JL - Remove Bosley Consult from leads, appointments & consultation count TrackIT 5322
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_BosleyReferralFlash 'C', '9/1/2018', '9/13/2018', 2
EXEC spRpt_BosleyReferralFlash 'C', '9/1/2018', '9/25/2018', 3
EXEC spRpt_BosleyReferralFlash 'F', '9/1/2018', '9/13/2018', 3
EXEC spRpt_BosleyReferralFlash 'C', '9/1/2018', '9/13/2018', 4
EXEC spRpt_BosleyReferralFlash 'F', '9/1/2018', '9/13/2018', 1
EXEC spRpt_BosleyReferralFlash 'C', '1/8/2020', '1/8/2020', 4
EXEC spRpt_BosleyReferralFlash 'C', '1/1/2020', '1/7/2020', 4

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_BosleyReferralFlash]
(
	@sType CHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
) AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


--EXEC spRpt_BosleyReferralFlash 'C', '1/1/2017', '9/25/2018', 3

--declare
--	@sType CHAR(1)
--,	@StartDate DATETIME
--,	@EndDate DATETIME
--,	@Filter INT


--SET	@sType = 'C'
--SET	@StartDate =  '09/01/2018'
--SET	@EndDate = '09/25/2018'
--SET	@Filter = 3



--IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
--    DROP TABLE #Centers

--IF OBJECT_ID('tempdb..#Center') IS NOT NULL
--    DROP TABLE #Center

--IF OBJECT_ID('tempdb..#SourceKeys') IS NOT NULL
--    DROP TABLE #SourceKeys

--IF OBJECT_ID('tempdb..#Activity') IS NOT NULL
--DROP TABLE #Activity

--IF OBJECT_ID('tempdb..#SUM_Activity') IS NOT NULL
--DROP TABLE #SUM_Activity

--IF OBJECT_ID('tempdb..#Consultant') IS NOT NULL
--DROP TABLE #Consultant

--IF OBJECT_ID('tempdb..#total') IS NOT NULL
--DROP TABLE #total


--IF OBJECT_ID('tempdb..#NonSurgery') IS NOT NULL
--DROP TABLE #NonSurgery

--IF OBJECT_ID('tempdb..#LeadNoAppointment') IS NOT NULL
--DROP TABLE #LeadNoAppointment

--IF OBJECT_ID('tempdb..#Combined') IS NOT NULL
--DROP TABLE #Combined



/*NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers, 4 is By Source*/

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder NVARCHAR(150)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
)


CREATE TABLE #SourceKeys(
	[SourceKey] INT
,	SourceSSID NVARCHAR(20)
,	SourceName NVARCHAR(50)
,   OwnerType NVARCHAR(50)
)


--CREATE TABLE #Activity(
--	FullDate DATETIME
--,	CenterKey INT
--,	CenterNumber INT
--,	ContactKey INT
--,	SourceKey INT
--,	SourceSSID NVARCHAR(30)
--,	SourceName NVARCHAR(50)
--,	BeBacks INT
--,	Consultations INT
--,	Appointments INT
--,	Shows INT
--,	Sales INT
--,	NoShows INT
--,	NoSales INT
--,	ShowDate DATETIME
--)

--CREATE TABLE #SUM_Activity(
--	FullDate DATETIME
--,	CenterKey INT
--,	CenterNumber INT
--,	ContactKey INT
--,	ContactFullName NVARCHAR(104)
--,	SourceKey INT
--,	SourceSSID NVARCHAR(30)
--,	SourceName NVARCHAR(50)
--,	BeBacks INT
--,	Consultations INT
--,	Appointments INT
--,	Shows INT
--,	Sales INT
--,	NoShows INT
--,	NoSales INT
--,	ShowDate DATETIME
--)

CREATE TABLE #Consultant
(	HC_Center INT
,	ConsultantUserName NVARCHAR(50)
,	ConectID INT
,	SiebelID NVARCHAR(15)
)


--CREATE TABLE #NonSurgery(
--	CenterKey INT
--,	ContactKey INT
--,	ClientKey INT
--,	ClientIdentifier INT
--,	BosleySiebelID NVARCHAR(50)
--,	ContactFullName NVARCHAR(102)
--,	SourceKey INT
--,	CreationDate DATETIME
----,	SaleDate DATETIME
--,	NetTradCount INT
--,	NetTradSales MONEY
--,	NetGradCount INT
--,	NetGradSales MONEY
--,	NetEXTCount INT
--,	NetEXTSales MONEY
--,	NetXtrandCount INT
--,	NetXtrandSales MONEY
--)


CREATE TABLE #LeadNoAppointment(
	CreationDate DATETIME
,	CenterKey INT
,	ContactKey INT
,	ContactFullName NVARCHAR(104)
,	BosleySiebelID NVARCHAR(50)
,	SourceKey INT
,	SourceSSID  NVARCHAR(30)
,	SourceName	NVARCHAR(50)
,	NoAppt INT
)


--CREATE TABLE #Combined(
--	CenterKey INT
--,	ContactKey INT
--,	ClientKey INT
--,	ClientIdentifier INT
--,	BosleySiebelID NVARCHAR(50)
--,	ContactFullName NVARCHAR(104)
--,	SourceKey INT
--,	SourceSSID NVARCHAR(30)
--,	SourceName NVARCHAR(50)
--,	CreationDate DATETIME
--,	SaleDate DATETIME
--,	NetTradCount INT
--,	NetTradSales MONEY
--,	NetGradCount INT
--,	NetGradSales MONEY
--,	NetEXTCount INT
--,	NetEXTSales MONEY
--,	NetXtrandCount INT
--,	NetXtrandSales MONEY
--,	NetNB1Count INT
--,	NetNB1Sales MONEY
--)


/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 4  --By Source
BEGIN
	INSERT  INTO #Centers
	SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
	,		CMA.CenterManagementAreaDescription AS MainGroup
	,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
	,		DC.CenterKey
	,		DC.CenterNumber
	,		DC.CenterSSID
	,		DC.CenterDescription
	,		DC.CenterDescriptionNumber
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
	WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND DC.Active = 'Y'
END
IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
	SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
	,		CMA.CenterManagementAreaDescription AS MainGroup
	,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
	,		DC.CenterKey
	,		DC.CenterNumber
	,		DC.CenterSSID
	,		DC.CenterDescription
	,		DC.CenterDescriptionNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND CMA.Active = 'Y'
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
	SELECT  DC.CenterNumber AS MainGroupID
	,		DC.CenterDescriptionNumber AS MainGroup
	,		DC.CenterDescriptionNumber AS MainGroupSortOrder
	,		DC.CenterKey
	,		DC.CenterNumber
	,		DC.CenterSSID
	,		DC.CenterDescription
	,		DC.CenterDescriptionNumber
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort = 'C'
			AND CMA.Active = 'Y'
END


IF @sType = 'F'
BEGIN
INSERT  INTO #Centers
	SELECT  DR.RegionSSID AS MainGroupID
	,		DR.RegionDescription AS MainGroup
	,		DR.RegionSortOrder AS MainGroupSortOrder
	,		CenterKey
	,		DC.CenterNumber
	,		DC.CenterSSID
	,		DC.CenterDescription
	,		DC.CenterDescriptionNumber
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE  CT.CenterTypeDescriptionShort IN('F','JV')
			AND DC.Active = 'Y'
END


/**************** Find Bosley Referral SourceKeys **********************************************/

INSERT INTO #SourceKeys
SELECT [SourceKey] AS 'SourceKey'
,	[SourceSSID] AS 'SourceSSID'
,	SourceName
,   OwnerType
FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimSource
WHERE ( SourceSSID LIKE 'BOS%REF%'
					AND SourceSSID <> 'BOSOHREF' )
AND RIGHT(SourceName,1) <> '-' --These are codes for the web - these codes end in a '-'
AND OwnerType <> 'Bosley Consult'

--Per Paoli --These are the source codes that are reported to Bosley in his weekly reports

/********************************** Get BOSREF Activity data *************************************/

		SELECT  dd.FullDate
		,		c.CenterKey
		,		c.CenterNumber
		,		clt.ContactKey
		,		far.SourceKey
		,		sc.SourceSSID
		,		sc.SourceName
		,       CON.ContactFullName
		,       clt.ClientIdentifier
		,       SUM(ISNULL(far.BeBack, 0)) AS 'BeBacks'
		,       SUM(ISNULL(far.Consultation, 0)) AS 'Consultations'
		,       SUM(ISNULL(far.Appointments, 0)) AS 'Appointments'
		,       SUM(ISNULL(far.Show, 0)) AS 'Shows'
		,       SUM(ISNULL(far.Sale, 0)) AS 'Sales'
		,		SUM(ISNULL(far.NoShow, 0)) AS 'NoShows'
		,		SUM(ISNULL(far.NoSale, 0)) AS 'NoSales'
		,		CASE WHEN ISNULL(far.Show, 0) = 1 THEN FullDate ELSE '' END AS 'ShowDate'

		INTO #Activity

		FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					ON dd.DateKey = far.ActivityDueDateKey
				INNER JOIN #Centers c
					ON c.CenterKey = far.CenterKey
				INNER JOIN #SourceKeys sc
					ON sc.SourceKey = far.SourceKey
				LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
					ON clt.contactkey = far.ContactKey
				LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
					ON CON.ContactKey = clt.ContactKey

		WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
		GROUP BY  dd.FullDate
        ,		c.CenterKey
        ,		c.CenterNumber
        ,		clt.contactkey
        ,		CASE WHEN ISNULL(far.Show, 0) = 1 THEN FullDate ELSE '' END
		,		far.SourceKey
		,		sc.SourceSSID
		,		sc.SourceName
		,       CON.ContactFullName
		,       clt.ClientIdentifier

--INSERT INTO #SUM_Activity
--		SELECT MAX(FullDate) AS 'FullDate'
--		,		CenterKey
--		,		CenterNumber
--		,		ACT.ContactKey
--		,		ContactFullName
--		,		SourceKey
--		,		SourceSSID
--		,		SourceName
--		,		SUM(BeBacks) AS 'Bebacks'
--		,		SUM(Consultations) AS 'Consultations'
--		,		SUM(Appointments) AS 'Appointments'
--		,		SUM(Shows) AS 'Shows'
--		,		SUM(Sales) AS 'Sales'
--		,		SUM(NoShows) AS 'NoShows'
--		,		SUM(NoSales) AS 'NoSales'
--		,		MIN(ShowDate) AS 'ShowDate'
--		FROM #Activity ACT
--		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
--			ON CON.ContactKey = ACT.ContactKey
--		GROUP BY CenterKey
--		,		CenterNumber
--		,		ACT.ContactKey
--		,		ContactFullName
--		,		SourceKey
--		,		SourceSSID
--		,		SourceName


/********************************** Get Non-Surgery Sales data *************************************/
		SELECT	fst.CenterKey
		,		clt.ContactKey
		,		clt.ClientKey
		,		clt.ClientIdentifier
		,		COALESCE(clt.BosleySiebelID, CON.BosleySiebelID) AS 'BosleySiebelID'
		,		con.ContactFullName
		,		fst.SourceKey
		--,		CON.CreationDate
		--,		q.SaleDate AS 'SaleDate'
		,       dd.fulldate
		,		ISNULL(fst.NB_TradCnt, 0) AS 'NetTradCount'
		,       ISNULL(fst.NB_TradAmt, 0) AS 'NetTradSales'
		,       ISNULL(fst.NB_GradCnt, 0) AS 'NetGradCount'
		,       ISNULL(fst.NB_GradAmt, 0) AS 'NetGradSales'
		,       ISNULL(fst.NB_ExtCnt, 0) AS 'NetEXTCount'
		,       ISNULL(fst.NB_ExtAmt, 0) AS 'NetEXTSales'
		,       ISNULL(fst.NB_XTRCnt, 0) AS 'NetXtrandCount'
		,       ISNULL(fst.NB_XTRAmt, 0) AS 'NetXtrandSales'

		,       ISNULL(fst.NB_MDPCnt, 0) AS 'NetMDPCount'
		,       ISNULL(fst.NB_MDPAmt, 0) AS 'NetMDPSales'

		INTO #NonSurgery
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
			ON dd.DateKey = fst.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
			ON clt.ClientKey = fst.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
			ON sc.SalesCodeKey = fst.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
			ON so.SalesOrderKey = fst.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
			ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
			ON dcm.ClientMembershipKey = so.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
			ON ctr.CenterKey = dcm.CenterKey
		INNER JOIN #Centers c
			ON c.CenterNumber = ctr.CenterNumber
		INNER JOIN #SourceKeys s
			ON s.SourceKey = fst.SourceKey

		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact con
			ON con.ContactKey = fst.ContactKey
		WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
				AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND sod.IsVoidedFlag = 0
                AND s.OwnerType <> 'Bosley Consult'

 ----   SELECT @StartDate, @EndDate
	--SELECT	FullDate, ContactFullName
	--	,		SUM(ISNULL(NetTradCount, 0)) AS 'NetTradCount'
	--	,       SUM(ISNULL(NetTradSales, 0)) AS 'NetTradSales'
	--	,       SUM(ISNULL(NetGradCount, 0)) AS 'NetGradCount'
	--	,       SUM(ISNULL(NetGradSales, 0)) AS 'NetGradSales'
	--	,       SUM(ISNULL(NetExtCount, 0)) AS 'NetEXTCount'
	--	,       SUM(ISNULL(NetExtSales, 0)) AS 'NetEXTSales'
	--	,       SUM(ISNULL(NetXtrandCount, 0)) AS 'NetXtrandCount'
	--	,       SUM(ISNULL(NetXtrandSales, 0)) AS 'NetXtrandSales'
	--	,       SUM(ISNULL(NetTradCount, 0) + ISNULL(NetGradCount, 0) + ISNULL(NetExtCount, 0) + ISNULL(NetXtrandCount, 0) + ISNULL(NetMDPCount, 0)) AS 'NetCount'
	--	,       SUM(ISNULL(NetTradSales, 0) + ISNULL(NetGradSales, 0) + ISNULL(NetExtSales, 0) + ISNULL(NetXtrandSales, 0) + ISNULL(NetMDPSales, 0)) AS 'NetSales'

	--FROM #NonSurgery
	--GROUP BY FullDate, ContactFullName

		--FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst WITH ( NOLOCK )
		--		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd WITH ( NOLOCK )
		--			ON dd.DateKey = fst.OrderDateKey
		--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt WITH ( NOLOCK )
		--			ON clt.ClientKey = fst.ClientKey
		--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc WITH ( NOLOCK )
		--			ON sc.SalesCodeKey = fst.SalesCodeKey
		--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so WITH ( NOLOCK )
		--			ON so.SalesOrderKey = fst.SalesOrderKey
		--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod WITH ( NOLOCK )
		--			ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
		--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm WITH ( NOLOCK )
		--			ON dcm.ClientMembershipKey = so.ClientMembershipKey
		--		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH ( NOLOCK )
		--			ON ctr.CenterKey = dcm.CenterKey
		--		INNER JOIN #Centers c
		--			ON c.CenterNumber = ctr.CenterNumber
		--		INNER JOIN #SourceKeys s
		--			ON s.SourceKey = fst.SourceKey
		--		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact con
		--			ON con.ContactKey = fst.ContactKey
		--		--OUTER APPLY(SELECT DD.FullDate AS 'SaleDate', FST.ClientKey,  ROW_NUMBER() OVER (PARTITION BY ClientKey ORDER BY DD.FullDate DESC) AS Ranking
		--		--			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		--		--				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		--		--					ON FST.OrderDateKey = DD.DateKey
		--		--			WHERE SalesCodeKey IN (SELECT SalesCodeKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode WHERE SalesCodeDescriptionShort = 'INITASG')
		--		--			 AND clt.ClientKey = FST.ClientKey
		--		--			)q
		--WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
		--		AND sc.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		--		AND sod.IsVoidedFlag = 0
		--		AND (ISNULL(fst.NB_TradCnt, 0) <> 0
		--			OR ISNULL(fst.NB_TradAmt, 0) <> 0
		--			OR ISNULL(fst.NB_GradCnt, 0) <> 0
		--			OR ISNULL(fst.NB_GradAmt, 0) <> 0
		--			OR ISNULL(fst.NB_ExtCnt, 0)  <> 0
		--			OR ISNULL(fst.NB_ExtAmt, 0)  <> 0
		--			OR ISNULL(fst.NB_XTRCnt, 0)  <> 0
		--			OR ISNULL(fst.NB_XTRAmt, 0)  <> 0
		--			)
		--		--AND q.Ranking = 1



/********************************** Get BOSREF Leads with no appointment data *************************************/
INSERT	INTO #LeadNoAppointment
SELECT  dd.FullDate AS 'CreationDate'
,		fl.CenterKey
,		fl.ContactKey
,		CON.ContactFullName
,		CON.BosleySiebelID
,		fl.SourceKey
,		sc.SourceSSID
,		sc.SourceName
,      1 AS 'NoAppt'

FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON dd.DateKey = fl.LeadCreationDateKey
		INNER JOIN #Centers c
			ON c.CenterKey = fl.CenterKey
		INNER JOIN #SourceKeys sc
			ON sc.SourceKey = fl.SourceKey
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
			ON CON.ContactKey = fl.ContactKey
WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
		AND ( fl.Appointments = 0
				AND fl.Shows = 0
				AND fl.NoShows = 0
				AND fl.Sales = 0
				AND fl.NoSales = 0 )
GROUP BY dd.FullDate
,		fl.CenterKey
,		fl.ContactKey
,		CON.ContactFullName
,		fl.SourceKey
,		sc.SourceSSID
,		sc.SourceName
,		CON.BosleySiebelID





/*********  Find ClientKey based on full name and center *******************************************/

UPDATE NS
SET NS.ClientKey = CLT.ClientKey
FROM #NonSurgery NS
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterKey = NS.CenterKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON NS.ClientIdentifier = CLT.ClientIdentifier
		OR (NS.ContactFullName = CLT.ClientFullName AND NS.CenterKey = CTR.CenterKey)
WHERE NS.ClientKey IS NULL

/*********  Find SiebelID based on full name and center *******************************************/

UPDATE NS
SET NS.BosleySiebelID = CLT.BosleySiebelID
FROM #NonSurgery NS
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterKey = NS.CenterKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON NS.ClientIdentifier = CLT.ClientIdentifier
		OR (NS.ContactFullName = CLT.ClientFullName
			AND NS.CenterKey = CTR.CenterKey)
WHERE (NS.BosleySiebelID IS NULL OR NS.BosleySiebelID = '')





/*********** Combine Counts and Sales - SUM the values per client *****************************************/



SELECT CenterKey
,	ContactKey
,	ClientKey
,	ClientIdentifier
,	BosleySiebelID
,	ContactFullName
,	#NonSurgery.SourceKey
,	SourceSSID
,	SourceName
--,	CreationDate
,   fulldate
,	SUM(NetTradCount) AS 'NetTradCount'
,	SUM(NetTradSales) AS 'NetTradSales'
,	SUM(NetGradCount) AS 'NetGradCount'
,	SUM(NetGradSales) AS 'NetGradSales'
,	SUM(NetEXTCount) AS 'NetEXTCount'
,	SUM(NetEXTSales) AS 'NetEXTSales'
,	SUM(NetXtrandCount) AS 'NetXtrandCount'
,	SUM(NetXtrandSales) AS 'NetXtrandSales'
,	(SUM(NetTradCount) + SUM(NetGradCount) + SUM(NetEXTCount) + SUM(NetXtrandCount) + SUM(NetMDPCount)) AS 'NetNB1Count'
,	(SUM(NetTradSales) + SUM(NetGradSales) + SUM(NetEXTSales) + SUM(NetXtrandSales) + SUM(NetMDPSales)) AS 'NetNB1Sales'

INTO #Combined
FROM #NonSurgery
INNER JOIN #SourceKeys
	ON #SourceKeys.SourceKey = #NonSurgery.SourceKey
WHERE Fulldate BETWEEN @StartDate AND @EndDate
GROUP BY CenterKey
,	ContactKey
,	ClientKey
,	ClientIdentifier
,	ContactFullName
,	BosleySiebelID
,	#NonSurgery.SourceKey
,	SourceSSID
,	SourceName
--,	CreationDate
,   fulldate
HAVING
	((SUM(NetTradCount) + SUM(NetGradCount) + SUM(NetEXTCount) + SUM(NetXtrandCount) + SUM(NetMDPCount)) <> 0 OR
  (SUM(NetTradSales) + SUM(NetGradSales) + SUM(NetEXTSales) + SUM(NetXtrandSales) + SUM(NetMDPSales)) <> 0 )


/******* Find the consultant ******************************************************************************/


INSERT INTO #Consultant
SELECT HC_Center
,	ConsultantUserName --AS 'ReferringCounselor'
,	ConectID
,	SiebelID
FROM [SQL05].[HairClubCMS].[dbo].[datIncomingRequestLog]
WHERE SiebelID IN (SELECT BosleySiebelID from #NonSurgery)
AND ConectID <> 0
GROUP BY HC_Center
,	ConsultantUserName
,	ConectID
,	SiebelID

/*********************** Combine data and add detail fields ******************************************************/

--SELECT --@sType AS 'TYPE'
--	MainGroupID
--,	MainGroup
--,	MainGroupSortOrder
--,	CTR.CenterKey
--,	CTR.CenterNumber
--,	CenterSSID
--,	CenterDescription
--,	CenterDescriptionNumber
----,	COALESCE(COMB.SourceKey, NoAppt.SourceKey, SUM_Act.SourceKey) AS 'SourceKey'
----,	COALESCE(COMB.SourceSSID, NoAppt.SourceSSID, SUM_Act.SourceSSID) AS 'SourceSSID'
----,	COALESCE(COMB.SourceName, NoAppt.SourceName, SUM_Act.SourceName) AS 'SourceName'
----,	COALESCE(COMB.ContactKey, NoAppt.ContactKey, SUM_Act.ContactKey) AS 'ContactKey'
--,    SUM_Act.ContactKey
----,	COALESCE(COMB.ContactFullName,  NoAppt.ContactFullName, SUM_Act.ContactFullName) AS 'ContactFullName'
--,   SUM_Act.ContactFullName  AS 'ContactFullName'
----,	NoAppt.CreationDate
--,	SUM_Act.Appointments AS 'Appointment'
--,	SUM_Act.Shows AS 'Show'
--,	SUM_Act.NoShows AS 'NoShow'
----,	MIN(SUM_Act.ShowDate) AS 'ShowDate'
--,	SUM_Act.Sales AS 'Sale'
--,	SUM_Act.NoSales AS 'NoSale'
------,	COMB.SaleDate
--,	COMB.NetNB1Count
--,	COMB.NetNB1Sales
--,	COMB.NetTradCount
--,	COMB.NetTradSales
--,	COMB.NetGradCount
--,	COMB.NetGradSales
--,	COMB.NetEXTCount
--,	COMB.NetEXTSales
--,	COMB.NetXtrandCount AS 'NetXtrCount'
--,	COMB.NetXtrandSales AS 'NetXtrSales'
--,	CONS.ConsultantUserName AS 'ReferringCounselor'
--,	COALESCE(COMB.BosleySiebelID, NoAppt.BosleySiebelID) AS 'BosleySiebelID'
--,	COMB.ClientKey
--,	COMB.ClientIdentifier
--,	ISNULL(NoAppt,0) AS 'NoAppt'
--FROM #Centers CTR
----LEFT JOIN #SUM_Activity SUM_Act
----	ON SUM_Act.CenterKey = CTR.CenterKey

--LEFT JOIN #Activity SUM_Act
--	ON SUM_Act.CenterKey = CTR.CenterKey

--LEFT JOIN #Combined COMB
--	ON COMB.CenterKey = CTR.CenterKey
--LEFT JOIN #LeadNoAppointment NoAppt
--	ON NoAppt.CenterKey = CTR.CenterKey
--LEFT JOIN #Consultant CONS
--	ON CONS.HC_Center = CTR.CenterSSID
----INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
----	ON (SUM_Act.ContactKey = CON.ContactKey OR COMB.ContactKey = CON.ContactKey OR NoAppt.ContactKey = CON.ContactKey)
----WHERE COALESCE(COMB.SourceKey, NoAppt.SourceKey, SUM_Act.SourceKey) IS NOT NULL
--GROUP BY
--SUM_Act.ContactFullName
--,	COALESCE(COMB.SourceKey, NoAppt.SourceKey, SUM_Act.SourceKey)
--,	COALESCE(COMB.SourceSSID, NoAppt.SourceSSID, SUM_Act.SourceSSID)
--,	COALESCE(COMB.SourceName, NoAppt.SourceName, SUM_Act.SourceName)
--,	COALESCE(COMB.ContactKey, NoAppt.ContactKey, SUM_Act.ContactKey)
--,SUM_Act.ContactKey
----,	COALESCE(COMB.BosleySiebelID, NoAppt.BosleySiebelID)
----,	COALESCE(COMB.ContactFullName,  NoAppt.ContactFullName, SUM_Act.ContactFullName)
--,	ISNULL(NoAppt, 0)
--,	CTR.MainGroupID
--,	CTR.MainGroup
--,	CTR.MainGroupSortOrder
--,	CTR.CenterKey
--,	CTR.CenterNumber
--,	CTR.CenterSSID
--,	CTR.CenterDescription
--,	CTR.CenterDescriptionNumber
--,	NoAppt.CreationDate
----,	COMB.SaleDate
--,	COMB.NetNB1Count
--,	COMB.NetNB1Sales
--,	COMB.NetTradCount
--,	COMB.NetTradSales
--,	COMB.NetGradCount
--,	COMB.NetGradSales
--,	COMB.NetEXTCount
--,	COMB.NetEXTSales
--,	COMB.NetXtrandCount
--,	COMB.NetXtrandSales
--,	CONS.ConsultantUserName
--,	COMB.ClientKey
--,	COMB.ClientIdentifier
--,	SUM_Act.Appointments
--,	SUM_Act.Shows
--,	SUM_Act.NoShows
--,	SUM_Act.Sales
--,	SUM_Act.NoSales

--ORDER BY 2



--SELECT * FROM #combined
--WHERE
--(NetTradCount <> 0 or
--NetTradSales <> 0 or
--NetGradCount <> 0 or
--NetGradSales <> 0 or
--NetEXTCount	 <> 0 or
--NetEXTSales	 <> 0 or
--NetXtrandCount	 <> 0 or
--NetXtrandSales	 <> 0 or
--NetNB1Count	 <> 0 or
--NetNB1Sales <> 0
--)

--SELECT
----@sType AS 'TYPE'
----	MainGroupID
----,	MainGroup
----,	MainGroupSortOrder
----,	CTR.CenterKey
--	CTR.CenterNumber
----,	CTR.CenterSSID
----,	CTR.CenterDescription
----,	CTR.CenterDescriptionNumber
----,   SourceKey AS 'SourceKey'
----,	sourcessid AS 'SourceSSID'
----,	'' AS 'SourceName'
--,	comb.contactkey AS 'ContactKey'
----,   ContactFullName
--,   contactssid
--,	SUM(COMB.NetNB1Count) AS 'NetNB1Count'
--,	SUM(COMB.NetNB1Sales) AS 'NetNB1Sales'
--,	SUM(COMB.NetTradCount) AS 'NetTradCount'
--,	SUM(COMB.NetTradSales) AS 'NetTradSales'
--,	SUM(COMB.NetGradCount) AS 'NetGradCount'
--,	SUM(COMB.NetGradSales) AS 'NetGradSales'
--,	SUM(COMB.NetEXTCount) AS 'NetEXTCount'
--,	SUM(COMB.NetEXTSales) AS 'NetEXTSales'
--,	SUM(COMB.NetXtrandCount) AS 'NetXtrCount'
--,	SUM(COMB.NetXtrandSales) AS 'NetXtrSales'
--,	COMB.BosleySiebelID
--,	COMB.ClientKey
--,	COMB.ClientIdentifier



--INTO #total
--FROM #Centers CTR INNER JOIN #Combined COMB
--	ON COMB.CenterKey = CTR.CenterKey
--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
--	ON clt.contactkey = COMB.ContactKey

--GROUP BY
--	CTR.CenterNumber
--,   contactssid
----,   ContactFullName
----,	CTR.CenterSSID
----,	CTR.CenterDescription
----,	CTR.CenterDescriptionNumber
----,   ContactFullName
----,   SourceKey
--,   COMB.contactkey
--,	COMB.BosleySiebelID
--,	COMB.ClientKey
--,	COMB.ClientIdentifier



SELECT
@sType AS 'TYPE'
,	MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,   a.SourceKey
,	a.SourceSSID
,	a.SourceName
,	a.ContactKey
,   a.ContactFullName
,   0 AS  'Appointment'
,	0 AS 'Show'
,	0 AS 'NoShow'
,   NULL AS 'ShowDate'
--,	0 AS 'Sale'
,	ISNULL(a.NetNB1Count, 0) AS 'Sale'
,	0 AS 'NoSale'
,   NULL AS 'SaleDate'
,	ISNULL(a.NetNB1Count, 0) AS 'NetNB1Count'
,	ISNULL(a.NetNB1Sales, 0) AS 'NetNB1Sales'
,	ISNULL(a.NetTradCount, 0) AS 'NetTradCount'
,	ISNULL(a.NetTradSales, 0) AS 'NetTradSales'
,	ISNULL(a.NetGradCount, 0) AS 'NetGradCount'
,	ISNULL(a.NetGradSales, 0) AS 'NetGradSales'
,	ISNULL(a.NetEXTCount, 0) AS 'NetEXTCount'
,	ISNULL(a.NetEXTSales, 0) AS 'NetEXTSales'
,	ISNULL(a.NetXtrandCount, 0) AS 'NetXtrCount'
,	ISNULL(a.NetXtrandSales, 0) AS 'NetXtrSales'
,	'' AS 'ReferringCounselor'
,	a.BosleySiebelID
,	a.ClientKey
,	a.ClientIdentifier
,	0 AS 'NoAppt'

FROM #Centers CTR INNER JOIN #Combined a
		ON a.CenterKey = CTR.CenterKey
/* NO APPOINTMENT BUT HAVE A SALE*/
WHERE ClientIdentifier NOT IN (SELECT DISTINCT clientidentifier FROM #activity WHERE ISNULL(clientidentifier, '') <> '' AND sales = 1)

UNION ALL

SELECT
@sType AS 'TYPE'
,	MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,   a.SourceKey
,	a.SourceSSID
,	a.SourceName
,	a.ContactKey
,   a.ContactFullName
,   ISNULL(a.Appointments, 0) AS  'Appointment'
,	ISNULL(a.Shows, 0) AS 'Show'
,	ISNULL(a.NoShows, 0) AS 'NoShow'
,	CASE WHEN a.Shows = 1 THEN a.ShowDate ELSE NULL END AS 'ShowDate'
--,	ISNULL(a.sales, 0) AS 'Sale'
,	ISNULL(t.NetNB1Count, 0) AS 'Sale'
,	ISNULL(a.NoSales, 0) AS 'NoSale'
,   CASE WHEN a.sales = 1 THEN a.fulldate ELSE NULL end AS 'SaleDate'
,	ISNULL(NetNB1Count, 0) AS 'NetNB1Count'
,	ISNULL(NetNB1Sales, 0) AS 'NetNB1Sales'
,	ISNULL(NetTradCount, 0) AS 'NetTradCount'
,	ISNULL(NetTradSales, 0) AS 'NetTradSales'
,	ISNULL(NetGradCount, 0) AS 'NetGradCount'
,	ISNULL(NetGradSales, 0) AS 'NetGradSales'
,	ISNULL(NetEXTCount, 0) AS 'NetEXTCount'
,	ISNULL(NetEXTSales, 0) AS 'NetEXTSales'
,	ISNULL(NetXtrandCount, 0) AS 'NetXtrCount'
,	ISNULL(NetXtrandSales, 0) AS 'NetXtrSales'
,	'' AS 'ReferringCounselor'
,	t.BosleySiebelID
,	t.ClientKey
,	t.ClientIdentifier
,	0 AS 'NoAppt'


FROM #Centers CTR INNER JOIN #Activity a
		ON a.CenterKey = CTR.CenterKey
  --  LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
		--ON clt.contactkey = a.ContactKey
	LEFT JOIN #Combined t ON t.clientidentifier = a.clientidentifier AND t.fulldate = a.fulldate AND a.sales = 1
--ORDER BY ctr.centernumber
--SELECT * FROM #activity WHERE ClientIdentifier = '628756'

UNION ALL

SELECT
@sType AS 'TYPE'
,	MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterSSID
,	CTR.CenterDescription
,	CTR.CenterDescriptionNumber
,   NoAppt.SourceKey
,	NoAppt.SourceSSID
,	NoAppt.SourceName
,	NoAppt.ContactKey
,   noAppt.ContactFullName
,   0 AS  'Appointment'
,	0 AS 'Show'
,	0 AS 'NoShow'
,   NULL AS 'ShowDate'
,	0 AS 'Sale'
,	0 AS 'NoSale'
,   NULL AS 'SaleDate'
,	0 AS 'NetNB1Count'
,	0 AS 'NetNB1Sales'
,	0 AS 'NetTradCount'
,	0 AS 'NetTradSales'
,	0 AS 'NetGradCount'
,	0 AS 'NetGradSales'
,	0 AS 'NetEXTCount'
,	0 AS 'NetEXTSales'
,	0 AS 'NetXtrCount'
,	0 AS 'NetXtrSales'
,	'' AS 'ReferringCounselor'
, 	NoAppt.BosleySiebelID AS 'BosleySiebelID'
,	'' AS 'ClientKey'
,	'' AS 'ClientIdentifier'
,	ISNULL(NoAppt,0) AS 'NoAppt'

FROM #Centers CTR INNER JOIN #LeadNoAppointment NoAppt
	ON NoAppt.CenterKey = CTR.CenterKey
--LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
--	ON clt.contactkey = NoAppt.ContactKey

END
