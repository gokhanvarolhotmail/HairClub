/* CreateDate: 07/24/2012 10:52:44.157 , ModifyDate: 01/25/2021 15:20:45.733 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusiness
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB2 Flash
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:
@Filter = 1 is By Regions, 2 is By Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
03/05/2013 - KM - Modified join to be on ClientMembership CenterKey rather than FactSalesTrx Centerkey
04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
04/11/2013 - KM - Modified to derive FactReceivables from HC_Accounting
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Change Get Center Listing query to join on vwDimCenter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
10/19/2013 - DL - Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
10/28/2013 - RH - Removed RetailSales from the Sales temp table; and joined on the RetailSales temp table
10/28/2013 - RH - For Franchise - Changed INNER JOIN ON DC.RegionSSID = DR.RegionKey to ON DC.RegionKey = DR.RegionKey
10/30/2013 - DL - (#93242) Moved AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
				  to Retail Sales query
10/30/2013 - DL - (#93242) Changed the joins of the Retail Sales query to exactly match what was being used in the Retail Flash procedure.
05/02/2014 - RH - Changed SUM(ISNULL(CLT.ClientARBalance, 0)) to SUM(ISNULL(FR.Balance, 0)) AS 'Balance'--Receivables
06/13/2014 - RH - (#102725) Added AND MembershipDescriptionShort NOT IN('POSTEXT','1STSURG','ADDSURG','SHOWNOSALE')for the receivables.
07/11/2014 - RH - (#103870) Added Xtrands Sales to the Center total sales amounts.
11/25/2014 - RH - (#108216) Added FST.NB_XTRConvCnt; Corrected EXT Expirations
02/04/2015 - RH - (#111093) Added Retention
05/26/2015 - DL - Limited query to recurring business memberships only
06/02/2015 - RH - (#115423) Added CurrentXtrandsClientMembershipSSID to the join on DimClientMembership for #Receivables
06/08/2015 - RH - (#115208) Changed join to FST.CenterKey = C.CenterKey since (FST.ServiceAmt) was not matching the Rich Matrix.
06/24/2015 - RH - (#115208) Modified join to be on ClientMembership CenterKey rather than FactSalesTrx Centerkey --KEEP
07/01/2015 - RH - (#116390) Changed Receivables query to remove duplicates - client multiple memberships were causing multiples of the AR balance.
07/14/2015 - RH - (#116450) In the #Sales section: Switched back to NB2Sales to include Non-Program in TotalCenterSales
07/28/2015 - RH - (#116552) Changed PCP headings, not values, to one month earlier
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
08/03/2016 - DL - (#127902) Added RegionSSID and RegionDescription, then changed the final sorting
11/16/2016 - DL - (#132711) Added DimSalesOrder & DimSalesOrderDetail JOIN statements to #Sales to match query to NB1 Flash
12/05/2016 - RH - (#133242) Changed query for Receivables to match the Detail - spRpt_FlashRecurringBusinessDetailsReceivables
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID and CenterManagementAreaDescription as description
03/03/2017 - RH - (#136610) Changed Receivables back to show ALL statuses; Added AND CLT.ClientARBalance > 0
04/05/2017 - RH - (#137787) Used logic with @ReceivablesDate to match the Warboard Receivables Ranking; AND FR.Balance >= 0
04/26/2017 - RH - (#137105) Added RegionSSID and RegionDescription to the final select
05/02/2017 - RH - (#137105) Added RegionSortOrder
01/12/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
03/06/2018 - RH - (#148073) Colorado Springs Client Count not showing - changed to use CenterNumber
06/21/2018 - RH - (#149538) Add Hans Wiemann; Pull only one service per day per client
01/14/2019 - RH - (Case 7444) Added a default value for PCP Year Begin and PCP End Dates for Delray and HW (Any date that is zero)
01/24/2019 - RH - Removed ISNULL(S.SurgerySales, 0) from the Total Center Sales (per Kevin/Melissa)
01/24/2019 - DL - Added + ISNULL(S.NB_MDPAmt, 0) to TotalCenterSales calc
05/20/2019 - JL - (Case 4824) Added drill down to report
10/10/2019 - JL - Added criteria to filter out inactive center
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashRecurringBusiness] 'C', '01/01/2021', '01/20/2021', 2
EXEC [spRpt_FlashRecurringBusiness] 'C', '01/01/2019', '01/15/2019', 3

EXEC [spRpt_FlashRecurringBusiness] 'C', '05/01/2019', '05/10/2019', 3
EXEC [spRpt_FlashRecurringBusiness] 'F', '01/01/2019', '01/15/2019', 1


EXEC [spRpt_FlashRecurringBusiness] 'C', '10/01/2019', '10/15/2019', 2

*****************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusiness]
(
		@sType CHAR(1)
	,	@begdt DATETIME
	,	@enddt DATETIME
	,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


--If @EndDate is this month, then pull yesterday's date, because FactReceivables populates once a day at 3:00 AM
DECLARE @ReceivablesDate DATETIME

IF MONTH(@enddt) = MONTH(GETDATE())
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101)
ELSE
	SET @ReceivablesDate = @enddt


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescription NVARCHAR(20)
)



CREATE TABLE #Receivables (
	CenterNumber INT
,	Receivable MONEY
)

CREATE TABLE #EXTExpirations (
	CenterNumber INT
,	Expirations INT
)

CREATE TABLE #Sales (
	CenterNumber INT
,	CenterType VARCHAR(50)
,	NetNB1Conv INT
,	NetEXTConv INT
,	NetXTRConv INT
,	NetTradSales MONEY
,	NetXtrSales MONEY
,	NetEXTCount INT
,	NetEXTSales MONEY
,	NetGradSales MONEY
,	NB2Sales MONEY
,	PCPSales MONEY
,	ServiceAmt MONEY
,	SurgerySales MONEY
,	PRPSales MONEY
,	PostEXTSales MONEY
,	NB1Apps INT
,	Upgrades INT
,	Downgrades INT
,	Cancels INT
,	Removals INT
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)

CREATE TABLE #RetailSales (
	CenterNumber INT
,	RetailSales MONEY
)

CREATE TABLE #Laser(
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)



/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
		,		CMA.CenterManagementAreaDescription AS MainGroup
		,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM		HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE		CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.CenterNumber NOT IN ( 901, 902, 903, 904 )
				AND DC.Active = 'Y'
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterNumber AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.CenterNumber NOT IN ( 901, 902, 903, 904 )
				AND DC.Active = 'Y'

END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		CASE WHEN CT.CenterTypeDescription = 'Joint' THEN 'Franchise' ELSE 'Franchise' END AS 'CenterTypeDescription'
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.CenterNumber NOT IN ( 901, 902, 903, 904 )
					AND DC.Active = 'Y'
END



/********************************** Get Open PCP data *************************************/

SELECT  a.CenterID AS 'CenterNumber'
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate)) AS 'PCPBegin'
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate)) AS 'YearPCPBegin'
,	SUM(a.Flash) AS 'OpenPCP'
INTO #OpenPCP
FROM    HC_Accounting.dbo.FactAccounting a
        INNER JOIN #Centers c
            ON a.CenterID = c.CenterNumber
WHERE   MONTH(a.PartitionDate) = MONTH(@begdt)
        AND YEAR(a.PartitionDate) = YEAR(@begdt)
        AND a.AccountID = 10400
GROUP BY a.CenterID
,	MONTH(a.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,a.PartitionDate))
,	YEAR(a.PartitionDate)


/********************************** Get Close PCP data *************************************/

SELECT  b.CenterID AS 'CenterNumber'   --CenterID matches CenterNumber in FactAccounting
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate)) AS 'PCPEnd'
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate)) AS 'YearPCPEnd'
,   SUM(b.Flash) AS 'ClosePCP'
INTO #ClosePCP
FROM    HC_Accounting.dbo.FactAccounting b
        INNER JOIN #Centers c
            ON b.CenterID = c.CenterNumber
WHERE   MONTH(b.PartitionDate) = MONTH(@enddt)
        AND YEAR(b.PartitionDate) = YEAR(@enddt)
        AND b.AccountID = 10400
GROUP BY b.CenterID
,	MONTH(b.PartitionDate)
,	MONTH(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(DATEADD(MONTH,-1,b.PartitionDate))
,	YEAR(b.PartitionDate)

/***************************** Find PCP Laser Membership Counts and Revenue ************************************/
INSERT INTO #Laser
SELECT  DISTINCT
		q.CenterNumber
,       q.CenterDescription
,       SUM(ISNULL(q.LaserCnt,0)) AS LaserCnt
,       SUM(ISNULL(q.LaserAmt,0)) AS LaserAmt
FROM (SELECT DD.FullDate
		,	C.CenterNumber
		,	#Centers.CenterDescription
		,	ISNULL(FST.PCP_LaserCnt, 0) AS LaserCnt
		,	ISNULL(FST.PCP_LaserAmt, 0) AS LaserAmt
		,	SC.SalesCodeDescriptionShort
		,	SC.SalesCodeDescription
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
							ON cm.MembershipKey = m.MembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C				--Keep HomeCenter-based
							ON cm.CenterKey = c.CenterKey
						INNER JOIN #Centers
							ON C.CenterNumber = #Centers.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
							ON FST.ClientKey = CLT.ClientKey
				WHERE   DD.FullDate BETWEEN @begdt AND @enddt
						AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
						AND SO.IsVoidedFlag = 0
							)q					--Membership Revenue

GROUP BY q.CenterNumber,
         q.CenterDescription



/********************************** Get Client Receivables Data *************************************/
INSERT INTO #Receivables
	SELECT	ctr.CenterNumber
	,		SUM(fr.Balance) AS 'Balance'
	FROM    HC_Accounting.dbo.FactReceivables fr
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
				ON dd.DateKey = fr.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
				ON clt.ClientKey = fr.ClientKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterKey = fr.CenterKey
			INNER JOIN #Centers c
				ON C.CenterSSID = ctr.CenterSSID
			CROSS APPLY (
				SELECT	DISTINCT
						cm.ClientKey
				FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
							ON m.MembershipKey = cm.MembershipKey
				WHERE	( cm.ClientMembershipSSID = clt.CurrentBioMatrixClientMembershipSSID
							OR cm.ClientMembershipSSID = clt.CurrentExtremeTherapyClientMembershipSSID
							OR cm.ClientMembershipSSID = clt.CurrentXtrandsClientMembershipSSID )
						AND m.RevenueGroupSSID = 2
			) x_Cm
	WHERE	dd.FullDate = @ReceivablesDate
			AND fr.Balance >= 0
	GROUP BY ctr.CenterNumber


--SELECT CenterNumber
--,	SUM(Balance) AS 'Balance'
--FROM
--	(SELECT  C.CenterNumber
--		,   CLT.ClientIdentifier
--		,	CLT.ClientKey
--		,   CM.ClientMembershipKey
--		,	FR.Balance AS 'Balance'
--		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS Ranking
--	FROM    HC_Accounting.dbo.FactReceivables FR
--			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--				ON FR.DateKey = DD.DateKey
--			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
--				ON FR.ClientKey = CLT.ClientKey
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--				ON FR.CenterKey = C.CenterKey
--			INNER JOIN #Centers
--				ON C.CenterSSID = #Centers.CenterSSID
--			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
--				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
--					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
--					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
--			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
--				ON CM.MembershipSSID = M.MembershipSSID
--	WHERE   DD.FullDate = @ReceivablesDate
--		AND M.RevenueGroupSSID = 2
--		AND FR.Balance >= 0
--		) b
--WHERE Ranking = 1
--GROUP BY CenterNumber

/********************************** Get EXT Expiration data *************************************/
INSERT  INTO #EXTExpirations
        SELECT  cntr.CenterNumber
        ,       COUNT(clt.ClientSSID) AS 'Expires'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
                INNER JOIN #Centers cntr
                    ON clt.CenterSSID = cntr.CenterSSID
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                    ON clt.CurrentExtremeTherapyClientMembershipSSID = cm.ClientMembershipSSID
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
		WHERE M.BusinessSegmentKey = 3  --EXT
				AND M.RevenueGroupDescription = 'New Business'
				AND M.MembershipDescriptionShort NOT LIKE '%BOS%'  --Bosley
				AND M.MembershipDescriptionShort NOT LIKE '%POST%'  --Post EXT
                AND cm.ClientMembershipEndDate BETWEEN @begdt
                                               AND     @enddt
                AND cm.ClientMembershipStatusSSID IN ( 1 )
        GROUP BY cntr.CenterNumber


/********************************** Get Sales Data *************************************/
INSERT  INTO #Sales
        SELECT  #Centers.CenterNumber
		,		CT.CenterTypeDescriptionShort AS 'CenterType'
        ,       SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'NetNB1Conv'
        ,       SUM(ISNULL(FST.NB_ExtConvCnt, 0)) AS 'NetEXTConv'
		,       SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'NetXTRConv' --Added 11/25/2014 -RH
        ,       SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'NetTradSales'
		,       SUM(ISNULL(FST.NB_XtrAmt, 0)) AS 'NetXtrSales' --Added 7/11/2014 -RH
        ,       SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'NetEXTCount'
        ,       SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'NetEXTSales'
        ,       SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'NetGradSales'
        ,       SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'NB2Sales'  --Includes Non-Program
        ,       SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCPSales'
        ,       SUM(ISNULL(FST.ServiceAmt, 0)) AS 'ServiceAmt'
        ,       SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgerySales'
		,       SUM(ISNULL(FST.S_PRPAmt, 0)) AS 'PRPSales'
        ,       SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTSales'
        ,       SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'NB1Apps'
        ,       SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN ( 1070 ) THEN 1
                         ELSE 0
                    END) AS 'Upgrades'
        ,       SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN ( 1080 ) THEN 1
                         ELSE 0
                    END) AS 'Downgrades'
        ,       SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN ( 1099 )
                              AND M.RevenueGroupDescriptionShort = 'PCP'
                         THEN 1
                         ELSE 0
                    END) AS 'Cancels'
        ,       SUM(CASE WHEN SC.SalesCodeSSID IN ( 399 ) THEN 1
                         ELSE 0
                    END) AS 'Removals'
		,		SUM(ISNULL(FST.NB_MDPCnt,0)) AS 'NB_MDPCnt'
		,		SUM(ISNULL(FST.NB_MDPAmt,0)) AS 'NB_MDPAmt'

		,		SUM(ISNULL(FST.NB_LaserCnt,0)) AS LaserCnt
		,		SUM(ISNULL(FST.NB_LaserAmt,0)) AS LaserAmt

        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = DD.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey       --KEEP HomeCenter Based
                INNER JOIN #Centers
                    ON C.CenterSSID = #Centers.CenterSSID
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON FST.SalesCodeKey = SC.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON CM.MembershipSSID = M.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
                    ON C.CenterTypeKey = CT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
                    ON C.RegionKey = R.RegionKey
        WHERE   DD.FullDate BETWEEN @begdt AND @enddt
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
        GROUP BY #Centers.CenterNumber
		,		CT.CenterTypeDescriptionShort

/***************************Find Clients with Services - one per day ************************************/

SELECT FullDate
,		#Centers.CenterNumber
,		SO.InvoiceNumber
,		CLT.ClientFullName
,       FST.ClientServicedCnt
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientKey, DD.FullDate ORDER BY DD.FullDate ASC) AS 'Ranking'
INTO #ServicePerClient
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FST.ClientKey
		INNER JOIN #Centers
			ON #Centers.CenterSSID = SO.CenterSSID
WHERE FST.ClientServicedCnt = 1
		AND DD.FullDate BETWEEN @begdt AND @enddt
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND SO.IsVoidedFlag = 0


/****************************** GET RETAIL DATA **************************************/

INSERT  INTO #RetailSales
        SELECT  #Centers.CenterNumber
		,	SUM(ISNULL(t.RetailAmt, 0)) AS 'RetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON t.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON t.CenterKey = c.CenterKey
		INNER JOIN #Centers
            ON c.CenterSSID = #Centers.CenterSSID
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON t.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @begdt AND @enddt
		GROUP BY #Centers.CenterNumber

/****************************** GET FINAL DATA SET ***********************************/
SELECT  CTR.CenterTypeDescription AS 'Type'
,		CTR.MainGroupID
,		CTR.MainGroup
,		CTR.MainGroupSortOrder
,		CTR.CenterNumber AS 'CenterID'
,		CTR.CenterDescription
,		CTR.CenterDescriptionNumber AS 'Center'
,		ISNULL(S.NetNB1Conv, 0) AS 'NBConversions'
,		ISNULL(S.NB2Sales, 0) AS 'NB2Amount'
,		ISNULL(S.PCPSales, 0) AS 'PCPAmount'
,		ISNULL(S.ServiceAmt, 0) AS 'ServiceAmount'
,		ISNULL(RS.RetailSales, 0) AS 'RetailAmount'
,		ISNULL(R.Receivable, 0) AS 'Receivables'
,		SUM(ISNULL(SPC.ClientServicedCnt,0)) AS 'ClientsServiced'
,		ISNULL(o.OpenPCP, 0) AS 'OpenPCP'
,		ISNULL(c.ClosePCP, 0) AS 'ClosePCP'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.PCPSales, 0), ISNULL(o.OpenPCP, 0)) AS 'PCPPerClient'
,		dbo.DIVIDE_DECIMAL(ISNULL(RS.RetailSales, 0), SUM(ISNULL(SPC.ClientServicedCnt,0))) AS 'RetailPerClient'
,		dbo.DIVIDE_DECIMAL(ISNULL(R.Receivable, 0), ISNULL(S.NB2Sales, 0)) AS 'ARPct'
,		(			ISNULL(S.NetTradSales, 0)
					+ ISNULL(S.NetGradSales, 0)
					+ ISNULL(S.NetEXTSales, 0)
					+ ISNULL(S.PostEXTSales, 0)
					+ ISNULL(S.NetXtrSales, 0)
					+ ISNULL(S.NB_MDPAmt, 0)
					+ ISNULL(S.LaserAmt, 0)
					+ ISNULL(S.SurgerySales, 0)
					+ ISNULL(S.PRPSales, 0)
					+ ISNULL(S.NB2Sales, 0)
					+ ISNULL(S.ServiceAmt, 0)
					+ ISNULL(RS.RetailSales, 0)
					+ ISNULL(LA.LaserAmt, 0)
					) AS 'TotalCenterSales'
,		ISNULL(S.Upgrades, 0) AS 'Upgrades'
,		ISNULL(S.Downgrades, 0) AS 'Downgrades'
,		ISNULL(S.Cancels, 0) AS 'Cancels'
,		ISNULL(S.NetNB1Conv, 0) AS 'BIOConversions'
,		ISNULL(S.NetEXTConv, 0) AS 'EXTConversions'
,		ISNULL(S.NetXTRConv, 0) AS 'XTRConversions'  --Added RH 11/25/2014
,		ISNULL(S.NetNB1Conv, 0) + ISNULL(S.NetEXTConv, 0) + ISNULL(S.NetXTRConv, 0) AS 'TotalConversions' --Added RH 11/25/2014
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Conv, 0), ISNULL(S.NB1Apps, 0)) AS 'BIOConversionPercent'
,		dbo.DIVIDE_DECIMAL(ISNULL(S.NetEXTConv, 0), ISNULL(EXT.Expirations, 0)) AS 'EXTConversionPercent'
,		ISNULL(S.NB1Apps, 0) AS 'Applications'
,		ISNULL(S.NetEXTCount, 0) AS 'EXTCount'
,		0 AS 'LERetailPerClient'
,		0 AS 'LETotalRetail'
,		0 AS 'LEClients'
,		ISNULL(EXT.Expirations, 0) AS 'EXTExpirations'
,		dbo.Retention(ISNULL(O.OpenPCP, 0), ISNULL(C.ClosePCP, 0), ISNULL(S.NetNB1Conv, 0), @begdt, @enddt)  AS 'Retention'
,		ISNULL(S.Removals, 0) AS 'Removals'
,		CASE WHEN ISNULL(O.PCPBegin,0) = 0 THEN MONTH(DATEADD(MONTH,-1,@begdt))ELSE O.PCPBegin END AS PCPBegin
,	CASE WHEN ISNULL(O.YearPCPBegin,0) = 0 THEN YEAR(DATEADD(MONTH,-1,@begdt))ELSE O.YearPCPBegin END AS YearPCPBegin
,	CASE WHEN ISNULL(C.PCPEnd,0) = 0 THEN MONTH(DATEADD(MONTH,-1,@enddt))ELSE C.PCPEnd END AS PCPEnd
,	CASE WHEN ISNULL(C.YearPCPEnd,0) = 0 THEN YEAR(DATEADD(MONTH,-1,@enddt))ELSE C.YearPCPEnd END AS YearPCPEnd
,		ISNULL(LA.LaserCnt,0) AS LaserCnt
,		ISNULL(LA.LaserAmt,0) AS LaserAmt
FROM    #Centers CTR
		LEFT OUTER JOIN #Sales S
			ON CTR.CenterNumber = S.CenterNumber
		LEFT OUTER JOIN #RetailSales RS
			ON CTR.CenterNumber = RS.CenterNumber
		LEFT OUTER JOIN #OpenPCP O
			ON CTR.CenterNumber = O.CenterNumber
		LEFT OUTER JOIN #ClosePCP C
			ON CTR.CenterNumber = C.CenterNumber
		LEFT OUTER JOIN #Receivables R
			ON CTR.CenterNumber = R.CenterNumber
		LEFT OUTER JOIN #EXTExpirations EXT
			ON CTR.CenterNumber = EXT.CenterNumber
		LEFT OUTER JOIN #ServicePerClient SPC
			ON CTR.CenterNumber = SPC.CenterNumber
		LEFT OUTER JOIN #Laser LA
			ON LA.CenterNumber = C.CenterNumber
WHERE (SPC.Ranking IS NULL OR SPC.Ranking = 1)  --Remove duplicates if clients had services on the same day
GROUP BY ISNULL(S.NetNB1Conv, 0)
       ,	ISNULL(S.NB2Sales, 0)
       ,	ISNULL(S.PCPSales, 0)
       ,	ISNULL(S.ServiceAmt, 0)
       ,	ISNULL(RS.RetailSales, 0)
       ,	ISNULL(R.Receivable, 0)
       ,	ISNULL(o.OpenPCP, 0)
       ,	ISNULL(c.ClosePCP, 0)
       ,	dbo.DIVIDE_DECIMAL(ISNULL(S.PCPSales, 0), ISNULL(o.OpenPCP, 0))
		,	(ISNULL(S.NetTradSales, 0)
				+ ISNULL(S.NetGradSales, 0)
				+ ISNULL(S.NetEXTSales, 0)
				+ ISNULL(S.PostEXTSales, 0)
				+ ISNULL(S.NetXtrSales, 0)
				+ ISNULL(S.NB_MDPAmt, 0)
				+ ISNULL(S.LaserAmt, 0)
				+ ISNULL(S.SurgerySales, 0)
				+ ISNULL(S.PRPSales, 0)
				+ ISNULL(S.NB2Sales, 0)
				+ ISNULL(S.ServiceAmt, 0)
				+ ISNULL(RS.RetailSales, 0)
				+ ISNULL(LA.LaserAmt, 0)
				)
       ,	ISNULL(S.Upgrades, 0)
       ,	ISNULL(S.Downgrades, 0)
       ,	ISNULL(S.Cancels, 0)
       ,	ISNULL(S.NetNB1Conv, 0)
       ,	ISNULL(S.NetEXTConv, 0)
       ,	ISNULL(S.NetXTRConv, 0)
       ,	ISNULL(S.NetNB1Conv, 0) + ISNULL(S.NetEXTConv, 0)
				+ ISNULL(S.NetXTRConv, 0)
       ,	dbo.DIVIDE_DECIMAL(ISNULL(S.NetNB1Conv, 0), ISNULL(S.NB1Apps, 0))
       ,	dbo.DIVIDE_DECIMAL(ISNULL(S.NetEXTConv, 0), ISNULL(EXT.Expirations, 0))
       ,	ISNULL(S.NB1Apps, 0)
       ,	ISNULL(S.NetEXTCount, 0)
       ,	ISNULL(EXT.Expirations, 0)
       ,	dbo.Retention(ISNULL(o.OpenPCP, 0), ISNULL(c.ClosePCP, 0), ISNULL(S.NetNB1Conv, 0), @begdt, @enddt)
       ,	ISNULL(S.Removals, 0)
       ,	CTR.CenterTypeDescription
       ,	CTR.MainGroupID
       ,	CTR.MainGroup
       ,	CTR.MainGroupSortOrder
       ,	CTR.CenterNumber
       ,	CTR.CenterDescription
       ,	CTR.CenterDescriptionNumber
       ,	o.PCPBegin
       ,	o.YearPCPBegin
       ,	c.PCPEnd
       ,	c.YearPCPEnd
	   ,	ISNULL(LA.LaserCnt,0)
	   ,	ISNULL(LA.LaserAmt,0)

END
GO
