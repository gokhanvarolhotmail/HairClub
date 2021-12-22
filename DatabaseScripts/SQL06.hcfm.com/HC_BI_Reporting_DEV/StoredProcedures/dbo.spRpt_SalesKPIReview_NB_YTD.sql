/* CreateDate: 05/22/2018 15:37:31.570 , ModifyDate: 05/22/2018 15:40:44.873 */
GO
/******************************************************************************************************************************
PROCEDURE:				[spRpt_SalesKPIReview_NB_YTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Sales KPI Review Year to Date
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/04/2018
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This is used in the report Sales KPI Review.  The IC version is for New Business.


--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_SalesKPIReview_NB_YTD] 202,4,2018

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SalesKPIReview_NB_YTD]
(
	@CenterNumber INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;
--/************************************************************************************/

--Find CenterSSID
DECLARE @CenterSSID INT
SET @CenterSSID = (SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterNumber = @CenterNumber)



--Find dates
DECLARE
	@StartDate DATETIME
,	@FirstDateOfMonth DATETIME
,	@EndDate DATETIME
,	@DecPreviousPCP DATETIME


SET @StartDate = CAST('1/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)										--Beginning of the year
SET @FirstDateOfMonth = CAST(CAST(@Month AS VARCHAR(2)) + '/1/' + CAST(@Year AS VARCHAR(4)) AS DATETIME)	--Beginning of the selected month
SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@FirstDateOfMonth)) + '23:59:000'								--End of the selected month
SET @DecPreviousPCP = DATEADD(Month,-1,@StartDate)															--Dec 2017


PRINT '@StartDate = ' +	CAST(@StartDate AS NVARCHAR(12))
PRINT '@FirstDateOfMonth = ' +	CAST( @FirstDateOfMonth AS NVARCHAR(12))
PRINT '@EndDate  = ' +	CAST(@EndDate AS NVARCHAR(12))
PRINT '@DecPreviousPCP = ' +	CAST( @DecPreviousPCP AS NVARCHAR(12))


/*************************** Create temp tables ****************************************/

CREATE TABLE #NB (
		CenterSSID INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	CenterTypeDescription NVARCHAR(25)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	ClosingRate_inclPEXT DECIMAL(18,4)
	,	Bud_NBCount INT
	,	NBCount  INT
	,	Bud_NBRevenue DECIMAL(18,4)
	,	NBRevenue DECIMAL(18,4)
	,	Bud_NBApps INT
	,	NBApps INT
	)

/************************ Find values from Fact Accounting ******************************/
INSERT INTO #NB
SELECT q.CenterID AS 'CenterSSID'
     , q.CenterDescriptionNumber
     , q.CenterTypeDescription
     , q.DateKey
     , q.PartitionDate
     , SUM(ISNULL(q.ClosingRate_inclPEXT,0)) AS 'ClosingRate_inclPEXT'
     , SUM(ISNULL(q.Bud_NBCount,0)) AS 'Bud_NBCount'
     , SUM(ISNULL(q.NBCount,0)) AS 'NBCount'
     , SUM(ISNULL(q.Bud_NBRevenue,0)) AS 'Bud_NBRevenue'
     , SUM(ISNULL(q.NBRevenue,0)) AS 'NBRevenue'
	 , SUM(ISNULL(q.Bud_NBApps,0)) AS 'Bud_NBApps'
	 , SUM(ISNULL(q.NBApps,0)) AS 'NBApps'
FROM(
	SELECT
	FA.CenterID
	,	C.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,	FA.DateKey
	,	FA.PartitionDate

	,	CASE WHEN ACC.AccountID = 10190 THEN FA.Flash end as 'ClosingRate_inclPEXT'  --10190 - Closing Rate - Net Total (incl PEXT) %

	,	CASE WHEN ACC.AccountID IN(10205,10206,10210,10215,10220,10225) THEN FA.Budget END AS 'Bud_NBCount'
	,	CASE WHEN ACC.AccountID IN(10205,10206,10210,10215,10220,10225) THEN FA.Flash END AS 'NBCount'
			/*10205 - NB - Traditional Sales #
			10206 - NB - Xtrands Sales #
			10210 - NB - Gradual Sales #
			10215 - NB - Extreme Sales #
			10220 - NB - Surgery Sales #
			10225 - NB - PostEXT Sales #
			*/

	,	CASE WHEN ACC.AccountID IN(10305,10306,10310,10315,10320,10325) THEN FA.Budget END AS 'Bud_NBRevenue'
	,	CASE WHEN ACC.AccountID IN(10305,10306,10310,10315,10320,10325) THEN FA.Flash END AS 'NBRevenue'
			/*10305 - NB - Traditional Sales $
			10306 - NB - Xtrands Sales $
			10310 - NB - Gradual Sales $
			10315 - NB - Extreme Sales $
			10320 - NB - Surgery Sales $
			10325 - NB - PostEXT Sales $
			*/

	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Budget END AS 'Bud_NBApps'
	,	CASE WHEN ACC.AccountID IN (10240) THEN FA.Flash END AS 'NBApps'
			/*10240 - NB - Applications #*/
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON FA.CenterID = C.CenterSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount ACC
		ON FA.AccountID = ACC.AccountID
WHERE FA.AccountID IN(10190,10206,10215,10220,10225,10305,10306,10310,10315,10320,10325,10240)
	AND FA.PartitionDate BETWEEN @StartDate AND @EndDate
	AND FA.CenterID = @CenterSSID

	)q

GROUP BY q.CenterID
	,	q.CenterDescriptionNumber
	,	q.CenterTypeDescription
	,	q.DateKey
	,	q.PartitionDate



/*********** FInd PostEXT volume and Surgery volume to compare ***********************************************************************/

SELECT c.CenterSSID
,	SUM(ISNULL(FST.S_PostExtCnt,0)) AS 'PostEXTCount'
,      SUM(ISNULL( FST.S_SurCnt,0)) AS 'SurgeryCount'
INTO #PostEXTPercent
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON cm.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
AND C.CenterNumber = @CenterNumber
        AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
        AND SO.IsVoidedFlag = 0
GROUP BY c.CenterSSID


/***************** Find XTR Plus Hair Mix     XTR+Sales#/NBCount# as 'XTR+HairSalesMix' ********************/

SELECT C.CenterSSID
,		SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
               AS 'NetNB1Count'																--Remove PostEXT for the Hair Sales Mix % to match the NB Flash
	,	SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'XtrPlusNBCount'
INTO #XTRPlusSalesMix
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
                    ON cm.MembershipKey = m.MembershipKey					---Changed to MembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
                    ON cm.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
        WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND C.CenterNumber = @CenterNumber
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
                AND SO.IsVoidedFlag = 0
        GROUP BY C.CenterSSID

--Find Sales Mix %

SELECT MIX.CenterSSID
, dbo.DIVIDE_NOROUND(SUM(MIX.XtrPlusNBCount),SUM(MIX.NetNB1Count)) AS 'XTRPlusHairSalesMix'
INTO #HairSalesMix
FROM #XTRPlusSalesMix MIX
GROUP BY MIX.CenterSSID



/************************ Final Select ********************************************************************/
SELECT r.CenterSSID
,	r.CenterDescriptionNumber
,	r.CenterTypeDescription
,	MAX(r.Bud_ClosingRate_inclPEXT) AS 'Bud_ClosingRate_inclPEXT'
,	AVG(r.ClosingRate_inclPEXT) AS 'ClosingRate_inclPEXT'
,	SUM(ISNULL(r.Bud_NBCount,0)) AS 'Bud_NBCount'
,	SUM(ISNULL(r.NBCount,0)) AS 'NBCount'
,	SUM(ISNULL(r.Bud_NBRevenue,0)) AS 'Bud_NBRevenue'
,	SUM(ISNULL(r.NBRevenue,0)) AS 'NBRevenue'
,	MAX(r.PostEXTCount) AS 'PostEXTCount'
,	MAX(r.SurgeryCount) AS 'SurgeryCount'
,	MAX(r.Bud_XTRPlusHairSalesMix) AS 'Bud_XTRPlusHairSalesMix'
,	MAX(r.XTRPlusHairSalesMix) AS 'XTRPlusHairSalesMix'
,	SUM(ISNULL(r.Bud_NBApps,0)) AS 'Bud_NBApps'
,	SUM(ISNULL(r.NBApps,0)) AS 'NBApps'
FROM
	(SELECT #NB.CenterSSID
	,	CenterDescriptionNumber
	,	CenterTypeDescription
	,	DateKey
	,	PartitionDate
	,	.45 AS 'Bud_ClosingRate_inclPEXT'
	,	ClosingRate_inclPEXT
	,	Bud_NBCount
	,	NBCount
	,	Bud_NBRevenue
	,	NBRevenue
	,	PostEXTCount
	,	SurgeryCount
	,	.5 AS 'Bud_XTRPlusHairSalesMix'
	,	XTRPlusHairSalesMix
	,	Bud_NBApps
	,	NBApps
	FROM #NB
	LEFT JOIN #PostEXTPercent
		ON #PostEXTPercent.CenterSSID = #NB.CenterSSID
	LEFT JOIN #HairSalesMix
		ON #HairSalesMix.CenterSSID = #NB.CenterSSID
	)r
GROUP BY r.CenterSSID
,	r.CenterDescriptionNumber
,	r.CenterTypeDescription




END
GO
