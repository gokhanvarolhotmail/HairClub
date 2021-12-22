/*==============================================================================
PROCEDURE:                               sprpt_FeeCodeReport
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/22/2012
-- Date Implemented:       8/22/2012
-- Date Last Modified:     8/22/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
==============================================================================
DESCRIPTION:  Report that Displays Fee Code Breakdown by Codes
==============================================================================
NOTES:
-- 04/18/2011 - MB	--> Added Franchise centers
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_FeeCodeReport 3,2011
==============================================================================*/
 CREATE PROCEDURE [dbo].[sprpt_FeeCodeReport]
      @Month    TINYINT
,     @Year     SMALLINT
AS

BEGIN
DECLARE @startDate DATETIME
SET @startDate = RTRIM(@Month) + '/01/' + RTRIM(@Year)
--SET @startDate = '02/01/08'

create table #tmp (
       TranCode varchar(50)
,      DateMonth varchar(50)
,      StartDate datetime
,      SumPriceM1 money
,      RecordCountM1 int
,      SumPriceM2 money
,      RecordCountM2 int
,      SumPriceM3 money
,      RecordCountM3 int
,      SumPriceM4 money
,      RecordCountM4 int
,      SumPriceM5 money
,      RecordCountM5 int
,		CenterType VARCHAR(50)
)

INSERT INTO #tmp (TranCode, DateMonth, StartDate, SumPriceM1, RecordCountM1, CenterType)
SELECT sc.SalesCodeDescriptionShort AS TranCode
,DATENAME(MONTH,@startDate) AS DateMonth
,@startDate As StartDate
,CAST(SUM(CASE WHEN so.IsRefundedFlag = 1 THEN -t.Price ELSE t.Price END) AS MONEY) AS SumPriceM1
,SUM(CASE
	WHEN t.Price=0 AND sc.SalesCodeDescriptionShort IN ('fee expired', 'fee frozen') THEN 1
	WHEN t.Price <> 0 THEN 1
	ELSE 0
	END) AS RecordCountM1
,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END AS 'CenterType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
WHERE (so.OrderDate BETWEEN @startDate AND (DATEADD(DD, -1, DATEADD(M, 1, @startDate)) + ' 23:59:59')
       AND sc.SalesCodeDepartmentSSID IN (2020)
       AND m.RevenueGroupDescriptionShort = 'PCP'
       AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
       AND ce.CenterSSID LIKE '[278]%'
	   AND t.Price <> 0)
GROUP BY sc.SalesCodeDescriptionShort
,	CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END

-- Second Month
INSERT INTO #tmp (TranCode, DateMonth, StartDate, SumPriceM2, RecordCountM2, CenterType)
SELECT sc.SalesCodeDescriptionShort AS TranCode
,DATENAME(MONTH,DATEADD(M, -1, @startDate)) AS DateMonth
,DATEADD(M, -1, @startDate) As StartDate
,CAST(SUM(CASE WHEN so.IsRefundedFlag = 1 THEN -t.Price ELSE t.Price END) AS MONEY) AS SumPriceM1
,SUM(CASE
	WHEN t.Price=0 AND sc.SalesCodeDescriptionShort IN ('fee expired', 'fee frozen') THEN 1
	WHEN t.Price <> 0 THEN 1
	ELSE 0
	END) AS RecordCountM1
,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END AS 'CenterType'
--SELECT code AS TranCode
--,      DATENAME(MONTH,DATEADD(M, -1, @startDate)) AS DateMonth
--,      DATEADD(M, -1, @startDate) As StartDate
--,      CAST(SUM(price) AS MONEY) AS SumPriceM2
--,   SUM(CASE WHEN price=0 AND code IN ('fee expired', 'fee frozen') THEN 1
--              ELSE CASE WHEN price<>0 THEN 1 ELSE 0 END END) AS RecordCountM2
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END AS 'CenterType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
WHERE (so.OrderDate BETWEEN  DATEADD(M, -1, @startDate) AND (DATEADD(DD, -1, @startDate) + ' 23:59:59')
       AND sc.SalesCodeDepartmentSSID IN (2020)
       AND m.RevenueGroupDescriptionShort = 'PCP'
       AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
       AND ce.CenterSSID LIKE '[278]%'
	   AND t.Price <> 0)
GROUP BY sc.SalesCodeDescriptionShort,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END
--WHERE (date BETWEEN  DATEADD(M, -1, @startDate) AND (DATEADD(DD, -1, @startDate) + ' 23:59:59')
--       AND department IN (35,39)
--       AND code NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
--       AND center LIKE '[278]%'
--	   AND price <> 0)
--GROUP BY [Code]
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END

-- Third Month
INSERT INTO #tmp (TranCode, DateMonth, StartDate, SumPriceM3, RecordCountM3, CenterType)
SELECT sc.SalesCodeDescriptionShort AS TranCode
,DATENAME(MONTH,DATEADD(M, -2, @startDate)) AS DateMonth
,DATEADD(M, -2, @startDate) As StartDate
,CAST(SUM(CASE WHEN so.IsRefundedFlag = 1 THEN -t.Price ELSE t.Price END) AS MONEY) AS SumPriceM1
,SUM(CASE
	WHEN t.Price=0 AND sc.SalesCodeDescriptionShort IN ('fee expired', 'fee frozen') THEN 1
	WHEN t.Price <> 0 THEN 1
	ELSE 0
	END) AS RecordCountM1
,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END AS 'CenterType'
--SELECT code AS TranCode
--,      DATENAME(MONTH,DATEADD(M, -2, @startDate)) AS DateMonth
--,      DATEADD(M, -2, @startDate) As StartDate
--,      CAST(SUM(price) AS MONEY) AS SumPriceM3
--,   SUM(CASE WHEN price=0 AND code IN ('fee expired', 'fee frozen') THEN 1
--              ELSE CASE WHEN price<>0 THEN 1 ELSE 0 END END) AS RecordCountM3
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END AS 'CenterType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
WHERE (so.OrderDate BETWEEN  DATEADD(M, -2, @startDate) AND (DATEADD(DD, -1, DATEADD(M, -1, @startDate)) + ' 23:59:59')
       AND sc.SalesCodeDepartmentSSID IN (2020)
       AND m.RevenueGroupDescriptionShort = 'PCP'
       AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
       AND ce.CenterSSID LIKE '[278]%'
	   AND t.Price <> 0)
GROUP BY sc.SalesCodeDescriptionShort,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END
--WHERE (date BETWEEN  DATEADD(M, -2, @startDate) AND (DATEADD(DD, -1, DATEADD(M, -1, @startDate)) + ' 23:59:59')
--       AND department IN (35,39)
--       AND code NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
--       AND center LIKE '[278]%'
--	   AND price <> 0)
--GROUP BY [Code]
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END

-- Fourth Month
INSERT INTO #tmp (TranCode, DateMonth, StartDate, SumPriceM4, RecordCountM4, CenterType)
SELECT sc.SalesCodeDescriptionShort AS TranCode
,DATENAME(MONTH,DATEADD(M, -3, @startDate)) AS DateMonth
,DATEADD(M, -3, @startDate) As StartDate
,CAST(SUM(CASE WHEN so.IsRefundedFlag = 1 THEN -t.Price ELSE t.Price END) AS MONEY) AS SumPriceM1
,SUM(CASE
	WHEN t.Price=0 AND sc.SalesCodeDescriptionShort IN ('fee expired', 'fee frozen') THEN 1
	WHEN t.Price <> 0 THEN 1
	ELSE 0
	END) AS RecordCountM1
,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END AS 'CenterType'
--SELECT code AS TranCode
--,      DATENAME(MONTH,DATEADD(M, -3, @startDate)) AS DateMonth
--,      DATEADD(M, -3, @startDate) As StartDate
--,      CAST(SUM(price) AS MONEY) AS SumPriceM4
--,   SUM(CASE WHEN price=0 AND code IN ('fee expired', 'fee frozen') THEN 1
--              ELSE CASE WHEN price<>0 THEN 1 ELSE 0 END END) AS RecordCountM4
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END AS 'CenterType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
WHERE (so.OrderDate BETWEEN  DATEADD(M, -3, @startDate)  AND (DATEADD(DD, -1, DATEADD(M, -2, @startDate)) + ' 23:59:59')
       AND sc.SalesCodeDepartmentSSID IN (2020)
       AND m.RevenueGroupDescriptionShort = 'PCP'
       AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
       AND ce.CenterSSID LIKE '[278]%'
	   AND t.Price <> 0)
GROUP BY sc.SalesCodeDescriptionShort,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END
--WHERE (date BETWEEN  DATEADD(M, -3, @startDate)  AND (DATEADD(DD, -1, DATEADD(M, -2, @startDate)) + ' 23:59:59')
--		AND department IN (35,39)
--       AND code NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
--       AND center LIKE '[278]%'
--	   AND price <> 0)
--GROUP BY [Code]
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END
--ORDER BY StartDate ASC

-- Fifth Month
INSERT INTO #tmp (TranCode, DateMonth, StartDate, SumPriceM5, RecordCountM5, CenterType)
SELECT sc.SalesCodeDescriptionShort AS TranCode
,DATENAME(MONTH,DATEADD(M, -4, @startDate)) AS DateMonth
,DATEADD(M, -4, @startDate) As StartDate
,CAST(SUM(CASE WHEN so.IsRefundedFlag = 1 THEN -t.Price ELSE t.Price END) AS MONEY) AS SumPriceM1
,SUM(CASE
	WHEN t.Price=0 AND sc.SalesCodeDescriptionShort IN ('fee expired', 'fee frozen') THEN 1
	WHEN t.Price <> 0 THEN 1
	ELSE 0
	END) AS RecordCountM1
,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END AS 'CenterType'
--SELECT code AS TranCode
--,      DATENAME(MONTH,DATEADD(M, -4, @startDate)) AS DateMonth
--,      DATEADD(M, -4, @startDate) As StartDate
--,      CAST(SUM(price) AS MONEY) AS SumPriceM5
--,   SUM(CASE WHEN price=0 AND code IN ('fee expired', 'fee frozen') THEN 1
--              ELSE CASE WHEN price<>0 THEN 1 ELSE 0 END END) AS RecordCountM5
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END AS 'CenterType'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
WHERE (so.OrderDate BETWEEN  DATEADD(M, -4, @startDate) AND (DATEADD(DD, -1, DATEADD(M, -3, @startDate)) + ' 23:59:59')
       AND sc.SalesCodeDepartmentSSID IN (2020)
       AND m.RevenueGroupDescriptionShort = 'PCP'
       AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
       AND ce.CenterSSID LIKE '[278]%'
	   AND t.Price <> 0)
GROUP BY sc.SalesCodeDescriptionShort,CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'c' ELSE 'f' END
--WHERE (date BETWEEN  DATEADD(M, -4, @startDate)  AND (DATEADD(DD, -1, DATEADD(M, -3, @startDate)) + ' 23:59:59')
--       AND department IN (35,39)
--       AND code NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPMT')
--       AND center LIKE '[278]%'
--	   AND price <> 0)
--GROUP BY [Code]
--,	CASE WHEN center LIKE '2%' THEN 'c' ELSE 'f' END
--ORDER BY StartDate ASC

SELECT TranCode
,      DateMonth
,      StartDate
,      ISNULL(SumPriceM1, 0) AS 'SumPriceM1'
,      ISNULL(RecordCountM1, 0) AS 'RecordCountM1'
,      ISNULL(SumPriceM2, 0) AS 'SumPriceM2'
,      ISNULL(RecordCountM2, 0) AS 'RecordCountM2'
,      ISNULL(SumPriceM3, 0) AS 'SumPriceM3'
,      ISNULL(RecordCountM3, 0) AS 'RecordCountM3'
,      ISNULL(SumPriceM4, 0) AS 'SumPriceM4'
,      ISNULL(RecordCountM4, 0) AS 'RecordCountM4'
,      ISNULL(SumPriceM5, 0) AS 'SumPriceM5'
,      ISNULL(RecordCountM5, 0) AS 'RecordCountM5'
,	   CenterType
FROM #tmp

END
