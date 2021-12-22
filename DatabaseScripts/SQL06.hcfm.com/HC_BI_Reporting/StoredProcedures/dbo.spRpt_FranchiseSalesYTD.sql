/*===============================================================================================
-- Procedure Name:			spRpt_FranchiseSalesYTD
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/21/2012
-- Date Implemented:       8/21/2012
-- Date Last Modified:     8/21/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
-- ----------------------------------------------------------------------------------------------
-- Notes:
04/19/2016 - RH - Added SUM(FST.NB_XtrAmt) to the Revenue for NB1
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [spRpt_FranchiseSalesYTD] 2016, 1
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_FranchiseSalesYTD]
(
	@Year INT
	,	@Division INT
)
AS
BEGIN
	SET NOCOUNT OFF;
	SET FMTONLY OFF;


/* @Division
0 = All
1 = NB1
2 = Non-Program
3 = PCP
4 = Retail
5 = Service
*/

CREATE TABLE #Transactions
	(
		[RowID] INT IDENTITY(1, 1)
	,	[Center] VARCHAR(50)
	,	[CenterNumber] INT
	,	[Type] VARCHAR(1)
	,	[Division] NVARCHAR(11)
	,	[Month] INT
	,	[Revenue] MONEY
	)

CREATE TABLE #FranchiseSales
	(
		[RowID] INT IDENTITY(1, 1)
	,	[Center] VARCHAR(50)
	,	[CenterNumber] INT
	,	[Type] VARCHAR(1)
	,	[Division] NVARCHAR(11)
	,	[Jan] MONEY
	,	[Feb] MONEY
	,	[Mar] MONEY
	,	[Apr] MONEY
	,	[May] MONEY
	,	[Jun] MONEY
	,	[Jul] MONEY
	,	[Aug] MONEY
	,	[Sep] MONEY
	,	[Oct] MONEY
	,	[Nov] MONEY
	,	[Dec] MONEY
	)


/*
	Select NB1, NB2, PCP, Retail and Service transactions for the specified year.
*/
IF @Division = 0  --ALL
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'ALL' AS 'Division'
	,   DD.MonthNumber
	,   SUM(FST.NB_TradAmt) + SUM(FST.NB_ExtAmt) + SUM(FST.NB_GradAmt) + SUM(FST.NB_XtrAmt)--NB1
			+ SUM(FST.PCPNonPgmAmt)		--NB2
			+ SUM(FST.PCP_PCPAmt)		--PCP
			+ SUM(FST.ServiceAmt)		--SERVICES
			+ SUM(FST.RetailAmt)		--SALES
		AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END
ELSE IF @Division = 1  --NB1
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'NB1' AS 'Division'
	,   DD.MonthNumber
	,   SUM(FST.NB_TradAmt) + SUM(FST.NB_ExtAmt) + SUM(FST.NB_GradAmt) + SUM(FST.NB_XtrAmt) --NB1
		AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END
ELSE IF @Division = 2  --Non-Program
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'Non-Program' AS 'Division'
	,   DD.MonthNumber
	,	SUM(FST.PCPNonPgmAmt)		--Non-Program
		AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END
ELSE IF @Division = 3  --PCP
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'PCP' AS 'Division'
	,   DD.MonthNumber
	,   SUM(FST.PCP_PCPAmt)		--PCP
		AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END
ELSE IF @Division = 4  --Retail Products
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'Retail' AS 'Division'
	,   DD.MonthNumber
	,   SUM(FST.RetailAmt)		--Retail
	AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END
ELSE IF @Division = 5  --Service
BEGIN
INSERT  INTO #Transactions
SELECT  CE.CenterDescriptionNumber
	,	CE.CenterSSID
	,	LEFT(ISNULL(CT.CenterTypeDescription, ''), 1) AS 'Type'
	,	'Service' AS 'Division'
	,   DD.MonthNumber
	,   SUM(FST.ServiceAmt)		--Service
	AS 'Revenue'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CE
	ON CE.CenterKey = FST.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CE.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.DateKey = FST.OrderDateKey
WHERE   DD.YearNumber = @Year
	AND CE.CenterSSID LIKE '[78]%'
GROUP BY CE.CenterSSID
	,	CE.CenterDescriptionNumber
	,	CT.CenterTypeDescription
	,   DD.MonthNumber
END


/*
	Use a PIVOT table to format the data.
*/
INSERT  INTO #FranchiseSales
		(
			[Center]
		,	[CenterNumber]
		,	[Type]
		,	[Division]
		,	[Jan]
		,	[Feb]
		,	[Mar]
		,	[Apr]
		,	[May]
		,	[Jun]
		,	[Jul]
		,	[Aug]
		,	[Sep]
		,	[Oct]
		,	[Nov]
		,	[Dec]
		)
		SELECT  [Center]
		,		[CenterNumber]
		,		[Type]
		,		[Division]
		,       [1] AS 'Jan'
		,       [2] AS 'Feb'
		,       [3] AS 'Mar'
		,       [4] AS 'Apr'
		,       [5] AS 'May'
		,       [6] AS 'Jun'
		,       [7] AS 'Jul'
		,       [8] AS 'Aug'
		,       [9] AS 'Sep'
		,       [10] AS 'Oct'
		,       [11] AS 'Nov'
		,       [12] AS 'Dec'
		FROM    ( SELECT  [Center]
					,		[CenterNumber]
					,		[Type]
					,		[Division]
					,       [Month]
					,       [Revenue]
					FROM    [#Transactions] ) ps PIVOT ( SUM([Revenue]) FOR [Month] IN ( [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12] ) ) AS pvt


/*
	Return the data.
*/
SELECT  [#FranchiseSales].[Center] AS 'FranchiseName'
,		[#FranchiseSales].[CenterNumber]
,       [#FranchiseSales].[Type]
,       [#FranchiseSales].[Division]
,       ISNULL([#FranchiseSales].[Jan], 0) AS 'Jan'
,       ISNULL([#FranchiseSales].[Feb], 0) AS 'Feb'
,       ISNULL([#FranchiseSales].[Mar], 0) AS 'Mar'
,       ISNULL([#FranchiseSales].[Apr], 0) AS 'Apr'
,       ISNULL([#FranchiseSales].[May], 0) AS 'May'
,       ISNULL([#FranchiseSales].[Jun], 0) AS 'Jun'
,       ISNULL([#FranchiseSales].[Jul], 0) AS 'Jul'
,       ISNULL([#FranchiseSales].[Aug], 0) AS 'Aug'
,       ISNULL([#FranchiseSales].[Sep], 0) AS 'Sep'
,       ISNULL([#FranchiseSales].[Oct], 0) AS 'Oct'
,       ISNULL([#FranchiseSales].[Nov], 0) AS 'Nov'
,       ISNULL([#FranchiseSales].[Dec], 0) AS 'Dec'
FROM    [#FranchiseSales]
ORDER BY [#FranchiseSales].[Center]
END
