/*===============================================================================================
Procedure Name:			spRpt_FranchiseSalesDetails

Author:					Rachelen Hut
Date Created:           8/21/2012
Destination Server:		SQL06
Destination Database:	HC_BI_Reporting
Related Application:	Flash Sales Report
----------------------------------------------------------------------------------------------
NOTES: @Division	 1 = NB1	2 = NB2		3 = PCP		4 = Retail		5 = Service

----------------------------------------------------------------------------------------------
CHANGE HISTORY:
03/30/2016 - RH - Wrote new stored procedure to not use dynamic SQL and use @Division
04/19/2016 - RH - Added t.NB_XtrAmt to the Revenue for NB1
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC spRpt_FranchiseSalesDetails 0, 2, 2016, 1

EXEC spRpt_FranchiseSalesDetails 0, 2, 2016, 1

EXEC spRpt_FranchiseSalesDetails 896, 4, 2016, 1
================================================================================================*/

CREATE PROCEDURE [dbo].[spRpt_FranchiseSalesDetails]
( @CenterNumber INT
  , @Month INT
  , @Year INT
  , @Division INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	/* @Division
	0 = ALL
	1 = NB1
	2 = NB2
	3 = PCP
	4 = Retail
    5 = Service
	*/

/************ Create temp tables *******************************************************************/

CREATE TABLE #Centers(CenterSSID INT)


CREATE TABLE #Amt(CenterDescriptionNumber NVARCHAR(50)
,	CenterSSID INT
,	InvoiceNumber NVARCHAR(25)
,	OrderDate DATETIME
,	Client NVARCHAR(104)
,	SalesCodeDescriptionShort  NVARCHAR(50)
,	SalesCodeDescription  NVARCHAR(50)
,	Division   NVARCHAR(50)
,	SalesCodeDepartmentDescription   NVARCHAR(50)
,	Amount MONEY)


IF @CenterNumber = 0
BEGIN
INSERT INTO #Centers
SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterSSID LIKE '[78]%'
END
ELSE
BEGIN
INSERT INTO #Centers
SELECT CenterSSID FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterSSID = @CenterNumber
END


/*************** Populate table #Amt based on the @Division passed from the Summary report ********/

IF @Division = 0 --ALL
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientIdentifier) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	((t.NB_TradAmt + t.NB_GradAmt + t.NB_EXTAmt + t.NB_XTRAmt)
		+ t.PCPNonPgmAmt
		+ t.PCP_PCPAmt
		+ t.RetailAmt
		+ t.ServiceAmt) AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND (t.NB_TradAmt <> 0
		OR t.NB_ExtAmt <> 0
		OR t.NB_GradAmt <> 0
		OR t.NB_XtrAmt <> 0
		OR t.PCPNonPgmAmt <> 0
		OR t.PCP_PCPAmt <> 0
		OR t.RetailAmt <> 0
		OR t.ServiceAmt <> 0)
	AND so.IsVoidedFlag <> 1
END
ELSE IF @Division = 1 --NB1 (NB_TradAmt or NB_GradAmt or NB_EXTAmt or NB_XtrAmt)
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientIdentifier) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	(t.NB_TradAmt + t.NB_GradAmt + t.NB_EXTAmt + t.NB_XTRAmt) AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND (t.NB_TradAmt <> 0
		OR t.NB_ExtAmt <> 0
		OR t.NB_GradAmt <> 0
		OR t.NB_XtrAmt <> 0)
	AND so.IsVoidedFlag <> 1
END
ELSE IF @Division = 2 --NB2 --Non-Program
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientNumber_Temp) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	(t.PCPNonPgmAmt) AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND (t.PCP_NB2Amt <> 0
		OR t.PCP_PCPAmt <> 0)
	AND so.IsVoidedFlag <> 1
END
ELSE IF @Division = 3 --PCP
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientNumber_Temp) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	t.PCP_PCPAmt AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND (t.PCP_NB2Amt <> 0
		OR t.PCP_PCPAmt <> 0)
	AND so.IsVoidedFlag <> 1
END
ELSE IF @Division = 4 --Retail --Products
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientNumber_Temp) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	t.RetailAmt AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND t.RetailAmt <> 0
	AND so.IsVoidedFlag <> 1
END
ELSE IF @Division = 5 --Service
BEGIN
INSERT INTO #Amt
SELECT ce.CenterDescriptionNumber
	,	ce.CenterSSID
	,	so.InvoiceNumber
	,	so.OrderDate
	,	CONVERT(VARCHAR, cl.ClientNumber_Temp) + ' - ' + cl.ClientFullName AS 'Client'
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	CONVERT(VARCHAR(2), scv.SalesCodeDivisionSSID) + ' - ' + scv.SalesCodeDivisionDescription AS 'Division'
	,	scd.SalesCodeDepartmentDescription
	,	t.ServiceAmt AS 'Amount'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	ON ce.CenterKey = t.CenterKey
INNER JOIN #Centers CTR
	ON ce.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
	ON d.DateKey = t.OrderDateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
	ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
	ON scd.SalesCodeDepartmentKey = sc.SalesCodeDepartmentKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision scv
	ON scv.SalesCodeDivisionKey = scd.SalesCodeDivisionKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
	ON so.SalesOrderKey = t.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
	ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
	ON t.ClientKey = cl.ClientKey
WHERE d.MonthNumber = @Month
	AND d.YearNumber = @Year
	AND t.ServiceAmt <> 0
	AND so.IsVoidedFlag <> 1
END



SELECT * FROM #Amt WHERE Amount <> '0.00'

END
