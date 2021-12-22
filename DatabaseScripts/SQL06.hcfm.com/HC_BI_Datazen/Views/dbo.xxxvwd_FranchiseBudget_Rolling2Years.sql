/***********************************************************************
VIEW:					vwd_FranchiseBudget_Rolling2Years
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			05/18/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Franchise Datazen dashboards
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_FranchiseBudget_Rolling2Years ORDER BY CenterSSID, FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[xxxvwd_FranchiseBudget_Rolling2Years]
AS

WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -3, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 3 Years Ago
		  AND DATEADD(YEAR,-1,GETUTCDATE()) -- Today one year ago
)

,	Sales AS (
        SELECT  DC.CenterSSID
		,       DD.FirstDateOfMonth
		,       SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'XTRPlusConv'
		,       SUM(ISNULL(FST.NB_ExtConvCnt, 0)) AS 'EXTConv'
		,       SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConv'
		,       SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'NB2Sales'  --Includes Non-Program
        ,      ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
			+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
			+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			AS 'SubTotalCenterSales'
		,       (ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
                + ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
                + ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0) ) AS 'NetNB1Sales'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN Rolling2Years DD
					ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON CM.CenterKey = DC.CenterKey       --KEEP HomeCenter Based
		WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
			AND DC.Active = 'Y'
        GROUP BY DC.CenterSSID
        ,	DD.FirstDateOfMonth
	UNION
		SELECT  101 AS 'CenterSSID'
			,       DD.FirstDateOfMonth
			,       SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'XTRPlusConv'
			,       SUM(ISNULL(FST.NB_ExtConvCnt, 0)) AS 'EXTConv'
			,       SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConv'
			,       SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'NB2Sales'  --Includes Non-Program

			,     ( ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+	   ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.PCP_NB2Amt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
				+      ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0)
			) AS 'SubTotalCenterSales'
			,       (ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.NB_XtrAmt, 0)),0)
                + ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0)
				+ ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0)
                + ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0) ) AS 'NetNB1Sales'
        FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN Rolling2Years DD
					ON FST.OrderDateKey = DD.DateKey
            	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FST.CenterKey = DC.CenterKey
		WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
			AND DC.Active = 'Y'
        GROUP BY DD.FirstDateOfMonth
)
,	RetailSales AS (
        SELECT  DC.CenterSSID AS 'CenterSSID'
        ,    DD.FirstDateOfMonth
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) AS 'RetailAmt'
		,	ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'ServiceAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
			AND CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
		GROUP BY DC.CenterSSID
		,    DD.FirstDateOfMonth
	UNION
		SELECT  101 AS 'CenterSSID'
        ,    DD.FirstDateOfMonth
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) AS 'RetailAmt'
		,	ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'ServiceAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey						--KEEP Transaction Based
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		WHERE (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
			AND CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
		GROUP BY DD.FirstDateOfMonth
)
,	SalesMix AS (
	SELECT  DC.CenterSSID
	,       DD.FirstDateOfMonth --Always first of the month
	,   ROUND(SUM(ISNULL(FST.NB_TradCnt, 0)),0) AS 'NB_TradCnt'
	,	ROUND(SUM(ISNULL(FST.NB_GradCnt, 0)),0) AS 'NB_GradCnt'
	,	ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0)  AS 'NB_ExtCnt'
	,	ROUND(SUM(ISNULL(FST.S_PostExtCnt, 0)),0)  AS 'S_PostExtCnt'
	,	ROUND(SUM(ISNULL(FST.S_SurCnt, 0)),0) AS 'S_SurCnt'
	,	ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0)  AS 'NB_XTRCnt'

	,   ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0) AS 'NB_TradAmt'
	,	ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0) AS 'NB_GradAmt'
	,	ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)  AS 'NB_ExtAmt'
	,	ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)  AS 'S_PostExtAmt'
	,	ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0) AS 'S_SurAmt'
	,	ROUND(SUM(ISNULL(FST.NB_XTRAmt, 0)),0)  AS 'NB_XTRAmt'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON DSC.SalesCodeKey = FST.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON DSO.SalesOrderKey = FST.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DM.MembershipKey = DCM.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DC.CenterKey = DCM.CenterKey
	WHERE  DC.CenterSSID LIKE '[78]%'
		AND DC.Active = 'Y'
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND DSOD.IsVoidedFlag = 0
	GROUP BY DC.CenterSSID
	,       DD.FirstDateOfMonth
	UNION
		SELECT  101 AS 'CenterSSID'
        ,    DD.FirstDateOfMonth
		,   ROUND(SUM(ISNULL(FST.NB_TradCnt, 0)),0) AS 'NB_TradCnt'
		,	ROUND(SUM(ISNULL(FST.NB_GradCnt, 0)),0) AS 'NB_GradCnt'
		,	ROUND(SUM(ISNULL(FST.NB_ExtCnt, 0)),0)  AS 'NB_ExtCnt'
		,	ROUND(SUM(ISNULL(FST.S_PostExtCnt, 0)),0)  AS 'S_PostExtCnt'
		,	ROUND(SUM(ISNULL(FST.S_SurCnt, 0)),0) AS 'S_SurCnt'
		,	ROUND(SUM(ISNULL(FST.NB_XTRCnt, 0)),0)  AS 'NB_XTRCnt'

		,   ROUND(SUM(ISNULL(FST.NB_TradAmt, 0)),0) AS 'NB_TradAmt'
		,	ROUND(SUM(ISNULL(FST.NB_GradAmt, 0)),0) AS 'NB_GradAmt'
		,	ROUND(SUM(ISNULL(FST.NB_ExtAmt, 0)),0)  AS 'NB_ExtAmt'
		,	ROUND(SUM(ISNULL(FST.S_PostExtAmt, 0)),0)  AS 'S_PostExtAmt'
		,	ROUND(SUM(ISNULL(FST.S_SurAmt, 0)),0) AS 'S_SurAmt'
		,	ROUND(SUM(ISNULL(FST.NB_XTRAmt, 0)),0)  AS 'NB_XTRAmt'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Years DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON DSC.SalesCodeKey = FST.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON DSO.SalesOrderKey = FST.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DM.MembershipKey = DCM.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DC.CenterKey = DCM.CenterKey
	WHERE  CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
		AND DC.Active = 'Y'
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND DSOD.IsVoidedFlag = 0
	GROUP BY DD.FirstDateOfMonth
)

SELECT RS.CenterSSID
    ,	DATEADD(YEAR,1,RS.FirstDateOfMonth) AS 'FirstDateOfMonth'
    ,	RS.RetailAmt
	,	ServiceAmt
	,	XTRPlusConv
	,	XTRConv
	,	EXTConv
	,	(RS.RetailAmt + S.SubTotalCenterSales ) AS 'TotalCenterSales'
	,	NB2Sales
	,	NB_TradCnt AS 'Trad'
	,	NB_GradCnt AS 'Grad'
	,	NB_ExtCnt AS 'EXT'
	,	S_PostExtCnt AS 'PostEXT'
	,	S_SurCnt AS 'Surgery'
	,	NB_XTRCnt AS 'Xtrands'
	,	(NB_TradCnt + NB_GradCnt + NB_ExtCnt + NB_XTRCnt) AS 'TotalNBCount'

	,   NB_TradAmt
	,	NB_GradAmt
	,	NB_ExtAmt
	,	S_PostExtAmt
	,	S_SurAmt
	,	NB_XTRAmt
	,   (NB_TradAmt + NB_GradAmt + NB_ExtAmt + NB_XTRAmt + S_PostExtAmt + S_SurAmt) AS 'TotalNBRevenue'
	,	NetNB1Sales

FROM RetailSales RS
INNER JOIN Rolling2Years ROLL
	ON RS.FirstDateOfMonth = ROLL.FirstDateOfMonth
LEFT JOIN Sales S
	ON S.CenterSSID = RS.CenterSSID
	AND S.FirstDateOfMonth = RS.FirstDateOfMonth
LEFT JOIN SalesMix SM
	ON SM.CenterSSID = RS.CenterSSID
	AND SM.FirstDateOfMonth = RS.FirstDateOfMonth
GROUP BY DATEADD(YEAR ,1 ,RS.FirstDateOfMonth)
    ,	(RS.RetailAmt + S.SubTotalCenterSales)
    ,	RS.CenterSSID
    ,	RS.RetailAmt
	,	ServiceAmt
	,	XTRPlusConv
	,	XTRConv
	,	EXTConv
	,	NB2Sales
	,	NB_TradCnt
	,	NB_GradCnt
	,	NB_ExtCnt
	,	S_PostExtCnt
	,	S_SurCnt
	,	NB_XTRCnt
	,   NB_TradAmt
	,	NB_GradAmt
	,	NB_ExtAmt
	,	S_PostExtAmt
	,	S_SurAmt
	,	NB_XTRAmt
	,	NetNB1Sales
