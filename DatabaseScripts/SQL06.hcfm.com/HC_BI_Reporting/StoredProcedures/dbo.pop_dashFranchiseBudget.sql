/* CreateDate: 01/05/2017 15:20:56.210 , ModifyDate: 01/06/2017 08:56:56.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[pop_dashFranchiseBudget]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
RELATED REPORT:			Dashboard
AUTHOR:					Rachelen Hut
------------------------------------------------------------------------
NOTES:
This stored procedure was written to populate a table dashFranchiseBudget - created on 12/20/2016 (#133852)
------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashFranchiseBudget]
***********************************************************************/

CREATE PROCEDURE [dbo].[pop_dashFranchiseBudget]
AS

SET ARITHABORT OFF
SET ANSI_WARNINGS ON
SET ANSI_NULLS ON


/********************* Create temp table ******************************/

CREATE TABLE #dashFranchiseBudget(
CenterSSID INT NOT NULL
,	FirstDateOfMonth DATETIME NOT NULL
,	RetailAmt   INT NULL
,	ServiceAmt   INT NULL
,	XTRPlusConv   INT NULL
,	XTRConv   INT NULL
,	EXTConv   INT NULL
,	TotalCenterSales  INT NULL
,	NB2Sales   INT NULL
,	Trad   INT NULL
,	Grad   INT NULL
,	EXT   INT NULL
,	PostEXT   INT NULL
,	Surgery   INT NULL
,	Xtrands   INT NULL
,	TotalNBCount   INT NULL
,	NB_TradAmt   INT NULL
,	NB_GradAmt   INT NULL
,	NB_ExtAmt   INT NULL
,	S_PostExtAmt   INT NULL
,	S_SurAmt   INT NULL
,	NB_XTRAmt   INT NULL
,	TotalNBRevenue   INT NULL
,	NetNB1Sales   INT NULL
)


DECLARE @StartDate DATETIME
SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)

--;WITH Rolling2Years AS (  --This was used for the initial population
--	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
--	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
--	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
--		  AND DATEADD(YEAR,-1,GETUTCDATE()) -- Today one year ago

--)

;WITH Rolling2Months AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(YEAR,-1,DATEADD(MONTH, -2, @StartDate) )-- Two months ago one year ago
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
                INNER JOIN Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON CM.CenterKey = DC.CenterKey       --KEEP HomeCenter Based
		WHERE DC.CenterSSID LIKE '[78]%'
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
                INNER JOIN Rolling2Months DD
					ON FST.OrderDateKey = DD.DateKey
            	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                    ON FST.ClientMembershipKey = CM.ClientMembershipKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON CM.CenterKey = DC.CenterKey       --KEEP HomeCenter Based
		WHERE  DC.CenterSSID LIKE '[78]%'
			AND DC.Active = 'Y'
        GROUP BY DD.FirstDateOfMonth
)
,	RetailSales AS (
        SELECT  DC.CenterSSID AS 'CenterSSID'
        ,    DD.FirstDateOfMonth
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) AS 'RetailAmt'
		,	ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'ServiceAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Months DD
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
			AND DC.CenterSSID LIKE '[78]%'
		GROUP BY DC.CenterSSID
		,    DD.FirstDateOfMonth
	UNION
		SELECT  101 AS 'CenterSSID'
        ,    DD.FirstDateOfMonth
		,	ROUND(SUM(ISNULL(FST.RetailAmt, 0)),0) AS 'RetailAmt'
		,	ROUND(SUM(ISNULL(FST.ServiceAmt, 0)),0) AS 'ServiceAmt'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN Rolling2Months DD
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
			AND DC.CenterSSID LIKE '[78]%'
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
		INNER JOIN Rolling2Months DD
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
		INNER JOIN Rolling2Months DD
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
	GROUP BY DD.FirstDateOfMonth
)

/******** SET FirstDateOfMonth to one year forward to be used as the Budget values ***********/

INSERT INTO #dashFranchiseBudget
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
INNER JOIN Rolling2Months ROLL
	ON RS.FirstDateOfMonth = ROLL.FirstDateOfMonth
LEFT JOIN Sales S
	ON S.CenterSSID = RS.CenterSSID
	AND S.FirstDateOfMonth = RS.FirstDateOfMonth
LEFT JOIN SalesMix SM
	ON SM.CenterSSID = RS.CenterSSID
	AND SM.FirstDateOfMonth = RS.FirstDateOfMonth
GROUP BY DATEADD(YEAR ,1 ,RS.FirstDateOfMonth)
    ,   RS.CenterSSID
    ,	RS.RetailAmt
	,	ServiceAmt
	,	XTRPlusConv
	,	XTRConv
	,	EXTConv
	,	(RS.RetailAmt + S.SubTotalCenterSales )
	,	NB2Sales
	,	NB_TradCnt
	,	NB_GradCnt
	,	NB_ExtCnt
	,	S_PostExtCnt
	,	S_SurCnt
	,	NB_XTRCnt
	,	(NB_TradCnt + NB_GradCnt + NB_ExtCnt + NB_XTRCnt)
	,   NB_TradAmt
	,	NB_GradAmt
	,	NB_ExtAmt
	,	S_PostExtAmt
	,	S_SurAmt
	,	NB_XTRAmt
	,   (NB_TradAmt + NB_GradAmt + NB_ExtAmt + NB_XTRAmt + S_PostExtAmt + S_SurAmt)
	,	NetNB1Sales



--merge records with Target and Source
MERGE HC_BI_Datazen.dbo.dashFranchiseBudget AS Target
USING (SELECT CenterSSID
     , FirstDateOfMonth
     , RetailAmt
     , ServiceAmt
     , XTRPlusConv
     , XTRConv
     , EXTConv
     , TotalCenterSales
     , NB2Sales
     , Trad
     , Grad
     , EXT
     , PostEXT
     , Surgery
     , Xtrands
     , TotalNBCount
     , NB_TradAmt
     , NB_GradAmt
     , NB_ExtAmt
     , S_PostExtAmt
     , S_SurAmt
     , NB_XTRAmt
     , TotalNBRevenue
     , NetNB1Sales
FROM #dashFranchiseBudget
GROUP BY CenterSSID
     , FirstDateOfMonth
     , RetailAmt
     , ServiceAmt
     , XTRPlusConv
     , XTRConv
     , EXTConv
     , TotalCenterSales
     , NB2Sales
     , Trad
     , Grad
     , EXT
     , PostEXT
     , Surgery
     , Xtrands
     , TotalNBCount
     , NB_TradAmt
     , NB_GradAmt
     , NB_ExtAmt
     , S_PostExtAmt
     , S_SurAmt
     , NB_XTRAmt
     , TotalNBRevenue
     , NetNB1Sales
	  ) AS Source
ON (Target.CenterSSID = Source.CenterSSID AND Target.FirstDateOfMonth = Source.FirstDateOfMonth
)
WHEN MATCHED THEN
	UPDATE SET Target.RetailAmt = Source.RetailAmt
	,	Target.ServiceAmt = Source.ServiceAmt

	,	Target.XTRPlusConv = Source.XTRPlusConv
	,	Target.XTRConv = Source.XTRConv
	,	Target.EXTConv = Source.EXTConv

	,	Target.TotalCenterSales = Source.TotalCenterSales
	,	Target.NB2Sales = Source.NB2Sales

	,	Target.Trad = Source.Trad
	,	Target.Grad = Source.Grad
	,	Target.EXT = Source.EXT
	,	Target.PostEXT = Source.PostEXT
	,	Target.Surgery = Source.Surgery
	,	Target.Xtrands = Source.Xtrands

	,	Target.TotalNBCount = Source.TotalNBCount
	,	Target.NB_TradAmt = Source.NB_TradAmt
	,	Target.NB_GradAmt = Source.NB_GradAmt
	,	Target.NB_ExtAmt = Source.NB_ExtAmt
	,	Target.S_PostExtAmt = Source.S_PostExtAmt
	,	Target.S_SurAmt = Source.S_SurAmt
	,	Target.NB_XTRAmt = Source.NB_XTRAmt

	,	Target.TotalNBRevenue = Source.TotalNBRevenue
	,	Target.NetNB1Sales = Source.NetNB1Sales

WHEN NOT MATCHED BY TARGET THEN
	INSERT( CenterSSID
     , FirstDateOfMonth
     , RetailAmt
     , ServiceAmt
     , XTRPlusConv
     , XTRConv
     , EXTConv
     , TotalCenterSales
     , NB2Sales
     , Trad
     , Grad
     , EXT
     , PostEXT
     , Surgery
     , Xtrands
     , TotalNBCount
     , NB_TradAmt
     , NB_GradAmt
     , NB_ExtAmt
     , S_PostExtAmt
     , S_SurAmt
     , NB_XTRAmt
     , TotalNBRevenue
     , NetNB1Sales  )
	VALUES( Source.CenterSSID
	,	Source.FirstDateOfMonth
	,	Source.RetailAmt
    ,	Source.ServiceAmt
    ,	Source.XTRPlusConv
    ,	Source.XTRConv
    ,	Source.EXTConv
    ,	Source.TotalCenterSales
    ,	Source.NB2Sales
    ,	Source.Trad
    ,	Source.Grad
    ,	Source.EXT
    ,	Source.PostEXT
    ,	Source.Surgery
    ,	Source.Xtrands
    ,	Source.TotalNBCount
    ,	Source.NB_TradAmt
    ,	Source.NB_GradAmt
    ,	Source.NB_ExtAmt
    ,	Source.S_PostExtAmt
    ,	Source.S_SurAmt
    ,	Source.NB_XTRAmt
    ,	Source.TotalNBRevenue
    ,	Source.NetNB1Sales
			)
;
GO
