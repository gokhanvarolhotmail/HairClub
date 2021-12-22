/* CreateDate: 10/15/2013 14:02:27.463 , ModifyDate: 01/03/2016 15:13:32.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusiness
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is All, 2 is Regional Sales Managers, 3 is Membership Advisors and 4 is Technical Managers
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers

2012-06-11 - HD - Convert Stored proc, also create view
2012-09-27 - MB - Rewrote stored proc to point to better optimized BI tables
2012-12-26 - MB - Changed query so that surgery monies go to appropriate center
2013-03-04 - KM - Modified join to go from FST.Centerkey rather than CM.CenterKey
2013-03-05 - KM - Modified join to go from CM.CenterKey rather than FST.Centerkey
05/22/2013 - MB - Added filter for IsVoidedFlag
05/28/2013 - MB - Removed membership filter so that surgery payments show up properly
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Change Get Center Listing query to join on vwDimCenter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
10/19/2013 - DL - (#89184) Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
10/28/2013 - RH - (#93072) For Franchise - Changed INNER JOIN ON DC.RegionSSID = DR.RegionKey to ON DC.RegionKey = DR.RegionKey
11/13/2013 - DL - (#93702) Removed PostEXT total from Sales Mix calculations
01/27/2014 - DL - (#94826) Added additional query to determine Applications using Transaction Center.
06/03/2014 - RH - (#102515) Added SUM(ISNULL(FST.NB_XtrCnt, 0)) to the NetNB1Count and added SUM(ISNULL(FST.NB_XtrAmt, 0)) to the NetNB1Sales.
07/09/2014 - KM - (Executive Req) Added Xtr to Sales Mix
07/10/2014 - DL - (Executive Req) Changed calculations to use DIVIDE function instead of DIVIDE_DECIMAL function for percentages
10/22/2014 - DL/RH - Changed database to SQL05; changed back to SQL06
11/07/2014 - RH - Added NB_XtrCnt and NB_XtrAmt fields to #Sales; Removed Xtr from pct_Bio and added a new field pct_Xtr
03/17/2015 - RH - Added Referrals total
04/15/2015 - KM - (WO#113005) Added ResultCodeSSID NOT IN ('NOSHOW') for Referrals
04/21/2015 - RH - (#113005)	Added code to exclude/include certain Referrals from Consultations, Referrals; Pulls from vwFactActivityResults instead of FactActivityResults
05/04/2015 - RH - (#114035) The values for Consultations and BeBacks have been set in the view vwFactActivityResults - referrals have already been removed.
05/07/2015 - RH - (#114035) Added code for BeBacks to report where Appointment = 1 and ActionCode Desc = 'BEBACK'; Added ActionCodeDescription = 'Appointment' to Consultations
05/07/2015 - DL - (#112391) Joined on DimClientMembership from DimSalesOrder instead of FactSalesTransaction
05/28/2015 - RH - (#114035) Removed WHEN A.IsConsultation = 1 and IsBeBack <> 1 in Referrals section since this was removing referrals; Removed where FAR.ActionCodeKey = 4  --Appointment in Consultations section
12/29/2015 - RH - (#121868) BOSAppt was changed to a Consultation per Melissa - it had been removed before from Referrals
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashNewBusiness 'C', '12/1/2015', '12/30/2015', 1
EXEC spRpt_FlashNewBusiness 'C', '03/1/2015', '03/17/2015', 4

EXEC spRpt_FlashNewBusiness 'F', '5/15/2015', '5/22/2015', 1
EXEC spRpt_FlashNewBusiness 'F', '03/1/2015', '03/17/2015', 4
***********************************************************************/
CREATE PROCEDURE [dbo].[xxx_spRpt_FlashNewBusiness]
(
	@sType CHAR(1)
,	@begdt SMALLDATETIME
,	@enddt SMALLDATETIME
,	@Filter INT
) AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Consultations(
	CenterSSID INT
,	Consultations INT
)


CREATE TABLE #BeBacks(
	CenterSSID INT
,	BeBacks INT
)


CREATE TABLE #Referrals (
	CenterSSID INT
,	Referrals INT
)

CREATE TABLE #Sales (
	CenterSSID INT
,	NB1Applications INT
,	GrossNB1Count INT
,	NetNB1Count INT
,	NetNB1Sales INT
,	NetTradCount INT
,	NetTradSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetXtrCount INT  --Added 11/7/2014 RH
,	NetXtrSales MONEY
,	NetGradCount INT
,	NetGradSales MONEY
,	SurgeryCount INT
,	SurgerySales MONEY
,	PostEXTCount INT
,	PostEXTSales MONEY
)


/********************************** Get list of centers *************************************/
IF @sType = 'C' AND @Filter = 1
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END

	/*IF @sType = 'C' AND @Filter = 2  --By Area Managers
	BEGIN
		INSERT  INTO #Centers
			SELECT  AM.EmployeeSSID AS MainGroupID
			,	R.RegionDescription AS MainGroup
			,	AM.CenterSSID
			,	AM.CenterDescriptionNumber
			,	AM.CenterDescription
			,	AM.EmployeeFullName
			FROM    dbo.vw_AreaManager AM
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON AM.RegionSSID = R.RegionSSID
			WHERE	Active = 'Y'
	END
	IF @sType = 'C' AND @Filter = 3  -- By Centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.CenterSSID AS MainGroupID
				,		DR.RegionDescription AS MainGroup
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				--,		DCT.CenterTypeDescriptionShort
				,	NULL AS EmployeeFullName
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END*/


IF @sType = 'C' AND @Filter = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END


IF @sType = 'C' AND @Filter = 3
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionMA, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END

IF @sType = 'C' AND @Filter = 4
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionTM, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
				WHERE	CONVERT(VARCHAR, DC.CenterSSID) LIKE '2%'
						AND DC.Active = 'Y'
	END


IF @sType = 'F' AND @Filter = 1
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


IF @sType = 'F' AND @Filter = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionNB1, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMNBConsultantSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


IF @sType = 'F' AND @Filter = 3
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionMA, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRSMMembershipAdvisorSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END

IF @sType = 'F' AND @Filter = 4
	BEGIN
		INSERT  INTO #Centers
				SELECT  ISNULL(DE.EmployeeKey, '-1')
				,		ISNULL(DC.RegionTM, 'Unknown, Unknown')
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
							ON DC.RegionRTMTechnicalManagerSSID = DE.EmployeeSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
						AND DC.Active = 'Y'
	END


/********************************** Get consultations and bebacks *************************************/
INSERT  INTO #Consultations
        SELECT DC.CenterSSID
		,	SUM(CASE WHEN Consultation = 1 THEN 1 WHEN FAR.BOSAppt = 1 THEN 1 ELSE 0 END) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
	WHERE   DD.FullDate BETWEEN @begdt AND @enddt
		AND FAR.BeBack <> 1
		AND FAR.Show=1
	GROUP BY DC.CenterSSID


INSERT  INTO #BeBacks
        SELECT DC.CenterSSID
		,	SUM(CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5)THEN 1 ELSE 0 END) AS 'BeBacks'
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
			INNER JOIN #Centers CTR
				ON DC.CenterSSID = CTR.CenterSSID
	WHERE   DD.FullDate BETWEEN @begdt AND @enddt
		AND (FAR.BeBack = 1)
		AND FAR.Show=1
	GROUP BY DC.CenterSSID

/********************************** Get referrals ****************************************************/
INSERT  INTO #Referrals
SELECT CenterSSID, SUM(r.Referral) AS Referrals
FROM
	(
	SELECT CTR.ReportingCenterSSID AS 'CenterSSID'
	,	CASE
			WHEN FAR.BOSRef = 1 THEN 1
			WHEN FAR.BOSOthRef = 1 THEN 1
			WHEN FAR.HCRef = 1 THEN 1
		END AS 'Referral'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
			ON FAR.ActivityKey = A.ActivityKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON A.CenterSSID = CTR.CenterSSID
		INNER JOIN #Centers
			ON CTR.ReportingCenterSSID = #Centers.CenterSSID
		 INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
			ON A.SourceSSID = DS.SourceSSID
	WHERE A.ActivityDueDate BETWEEN @begdt AND @enddt
		AND DS.Media = 'Referrals'
		AND A.ResultCodeSSID NOT IN ('NOSHOW')
		AND FAR.BOSAppt <> 1
	)r
GROUP BY CenterSSID


/********************************** Get sales data *************************************************/
INSERT  INTO #Sales
        SELECT  c.ReportingCenterSSID
		,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Applications'
        ,       SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
		,		SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0))
				+ SUM(ISNULL(FST.NB_ExtAmt, 0))
				+ SUM(ISNULL(FST.NB_XtrAmt, 0))
                + SUM(ISNULL(FST.NB_GradAmt, 0))
				+ SUM(ISNULL(FST.S_SurAmt, 0))
                + SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'NetNB1Sales'
        ,       SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'NetTradCount'
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
		,       SUM(ISNULL(FST.NB_XtrCnt, 0)) AS 'NetXtrCount' --Added 11/7/2014 RH
        ,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetXtrSales'
        ,       SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'NetGradCount'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
        ,       SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgeryCount'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
        ,       SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXTCount'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON cm.CenterKey = c.CenterKey
                INNER JOIN #Centers
                    ON C.ReportingCenterSSID = #Centers.CenterSSID
        WHERE   DD.FullDate BETWEEN @begdt AND @enddt
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
        GROUP BY c.ReportingCenterSSID


/********************************** Display By Main Group/Center *************************************/
SELECT  C.CenterType AS 'TYPE'
,		C.MainGroupID
,		C.MainGroup
,		C.CenterSSID AS 'CenterID'
,		C.CenterDescription AS 'Center'
,		ISNULL(Cons.Consultations, 0) AS 'consultations'
,		ISNULL(BB.BeBacks, 0) AS 'beback'
,		ISNULL(Ref.Referrals, 0) AS 'Referrals'  --Added 03/17/2015 RH
,		ISNULL(S.GrossNB1Count, 0) AS 'gross_nb1'
,       ISNULL(S.NetNB1Count, 0) AS 'net_nb1_sales'
,       ISNULL(S.NetNB1Sales, 0) AS 'net_nb1$'
,       ISNULL(S.NetTradCount, 0) AS 'net_trad'
,       ISNULL(S.NetTradSales, 0) AS 'net_trad_nb1$'
,       ISNULL(S.NetEXTCount, 0) AS 'net_ext'
,       ISNULL(S.NetEXTSales, 0) AS 'net_ext$'
,		ISNULL(S.NetXtrCount, 0) AS 'net_xtr'
,       ISNULL(S.NetXtrSales, 0) AS 'net_xtr$'  --Added 11/7/2014 RH
,       ISNULL(S.NetGradCount, 0) AS 'net_grad'
,       ISNULL(S.NetGradSales, 0) AS 'net_grad$'
,       ISNULL(S.SurgeryCount, 0) AS 'sur'
,       ISNULL(S.SurgerySales, 0) AS 'sur$'
,       ISNULL(S.PostEXTCount, 0) AS 'postEXT'
,       ISNULL(S.PostEXTSales, 0) AS 'postEXT$'
,		ISNULL(S.NB1Applications, 0) AS 'net_nb1_apps'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Sales, 0), ISNULL(S.NetNB1Count, 0)) AS '$per_nb1'
,		dbo.DIVIDE(ISNULL(S.NetNB1Count, 0), ISNULL(Cons.Consultations, 0)) AS 'close_pct'
,		dbo.DIVIDE((ISNULL(S.NetTradCount, 0) + ISNULL(S.NetGradCount, 0)), (ISNULL(S.NetNB1Count, 0) - ISNULL(S.PostEXTCount, 0))) AS 'pct_Bio'  --removed NetXtrCount RH 11/7/2014
,		dbo.DIVIDE(ISNULL(S.NetEXTCount, 0), (ISNULL(S.NetNB1Count, 0) - ISNULL(S.PostEXTCount, 0))) AS 'pct_EXT'
,		dbo.DIVIDE(ISNULL(S.SurgeryCount, 0), (ISNULL(S.NetNB1Count, 0) - ISNULL(S.PostEXTCount, 0))) AS 'pct_Sur'
,		dbo.DIVIDE(ISNULL(S.NetXtrCount, 0), (ISNULL(S.NetNB1Count, 0) - ISNULL(S.PostEXTCount, 0))) AS 'pct_Xtr'  --Added 11/7/2014 RH
FROM    #Centers C
		LEFT OUTER JOIN #Sales S
			ON C.CenterSSID = S.CenterSSID
		LEFT OUTER JOIN #Consultations Cons
			ON C.CenterSSID = Cons.CenterSSID
		LEFT OUTER JOIN #Bebacks BB
			ON C.CenterSSID = BB.CenterSSID
		LEFT OUTER JOIN #Referrals Ref
			ON C.CenterSSID = Ref.CenterSSID
ORDER BY C.MainGroup
,		C.CenterDescription

END
GO
