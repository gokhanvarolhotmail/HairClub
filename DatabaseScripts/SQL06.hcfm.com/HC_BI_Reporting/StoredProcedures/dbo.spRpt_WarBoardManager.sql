/* CreateDate: 10/04/2018 14:04:23.543 , ModifyDate: 01/13/2020 09:00:02.560 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardManager

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		05/05/2015

==============================================================================
DESCRIPTION:	War Board for Managers (WO#110458)
WHEN CHANGES ARE MADE TO THIS STORED PROCEDURE, ALSO CHANGE THE CHART VERSION [spRpt_WarBoardManagerChart]
==============================================================================
CHANGE HISTORY:
09/02/2015 - RH - (#118294) Changed Budget to ROUND(Budget,0) and Flash to ROUND(Flash,0)
01/21/2016 - RH - (#122371) Changed to pull Retention from MonthlyRetention
03/24/2016 - RH - (#123656) Changed Retention target to 100%
07/08/2016 - RH - (#126425) Changed HairSalesMix_Budget to .50 (50%)
03/03/2017 - RH - (#134162) Added RecurringBusinessSize
01/15/2018 - RH - (#145629) Made requested changes for 2018; Added CenterType to Center query
04/16/2018 - RH - (#148069) Changed the Budget value called “NB - Net Sales (Incl PEXT) #” to total of each XTR+ Initial, XTR+ Initial 6, EXT, Xtrands, Surgery, and PostEXT
06/11/2018 - RH - (#147216) Added Retail, @RetailToBudget_Weighting; @NBTradGradToBudget_Cap = 1.50;@NBTradGradToBudget_Weighting = .2; Changed CenterSSID to CenterNumber; Removed Retention
07/13/2018 - JL - (#149913) Replaced Corporate Regions with Areas, Changed CenterSSID to CenterNumber
10/04/2018 - RH - (Case 5060) Made requested changes for October 2018
01/25/2019 - RH - (Case #7101) Replaced 10233 with 10237 NB - Net Sales (Excl Sur) $
01/28/2019 - RH - (Case #7507) Added MDP Revenue to total NB1 revenue; Changed Budget for NB1 to use a collection of $ account ID's (10305,10306,10310,10315,10325)
06/19/2019 - JL - (TFS 12573) Laser Report adjustment
01/10/2020 - RH - (TrackIT 5115) Add Surgery Revenue and NB - RestorInk $; changed 10237 to 10305,10306,10310,10315,10320,10325,10552,10891
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_WarBoardManager 12, 2019

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardManager] (
	@Month INT
,	@Year INT
)

AS
BEGIN
SET FMTONLY OFF
SET NOCOUNT OFF

DECLARE	@PartitionDate DATETIME
,	@EndOfMonth DATETIME

,	@NBTradGradRevenueToBudget_Cap  NUMERIC(15,5)
,	@AppsToBudget_Cap NUMERIC(15,5)
,	@BioConvToBudget_Cap NUMERIC(15,5)
,	@EXTConvToBudget_Cap NUMERIC(15,5)
,	@XtrConvToBudget_Cap NUMERIC(15,5)
,	@RetailToBudget_Cap NUMERIC(15,5)


,	@NBTradGradRevenueToBudget_Weighting NUMERIC(15,5)
,	@AppsToBudget_Weighting NUMERIC(15,5)
,	@BioConvToBudget_Weighting NUMERIC(15,5)
,	@XtrConvToBudget_Weighting NUMERIC(15,5)
,	@EXTConvToBudget_Weighting NUMERIC(15,5)
,	@RetailToBudget_Weighting NUMERIC(15,5)

SELECT @PartitionDate = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
,	@EndOfMonth = DATEADD(DAY,-1,DATEADD(MONTH,1,@PartitionDate)) + '23:59:000'  --End of the same month

,	@NBTradGradRevenueToBudget_Cap = 1.50
,	@AppsToBudget_Cap = 1.50
,	@BioConvToBudget_Cap = 1.25
,	@XtrConvToBudget_Cap = 1.25
,	@EXTConvToBudget_Cap = 1.25
,	@RetailToBudget_Cap = 2.00


,	@NBTradGradRevenueToBudget_Weighting = .20
,	@AppsToBudget_Weighting = .20
,	@BioConvToBudget_Weighting = .20
,	@XtrConvToBudget_Weighting = .15
,	@EXTConvToBudget_Weighting = .10
,	@RetailToBudget_Weighting = .15

/****************** Create temp tables *******************************************************/
IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
BEGIN
	DROP TABLE #Centers
END
CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(150)
,	CenterDescription NVARCHAR(150)
,	RecurringBusinessSize NVARCHAR(10)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription  NVARCHAR(150)
,	CenterManagementAreaSortOrder  INT
)

IF OBJECT_ID('tempdb..#RetailSales') IS NOT NULL
BEGIN
	DROP TABLE #RetailSales
END
CREATE TABLE #RetailSales (
	CenterNumber INT
,	PartitionDate DATETIME
,	RetailSales MONEY
)


CREATE TABLE #Laser(
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)


/*************************************************************************************************/


INSERT INTO #Centers
SELECT
	C.CenterNumber
,	C.CenterDescriptionNumber
,	C.CenterDescription
,	C.RecurringBusinessSize
,	R.CenterManagementAreaSSID
,	R.CenterManagementAreaDescription
,	R.CenterManagementAreaSortOrder
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea R
	ON C.CenterManagementAreaSSID = R.CenterManagementAreaSSID
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = C.CenterTypeKey
WHERE C.Active='Y'
	AND CT.CenterTypeDescriptionShort = 'C'


/******************* Pull values from FactAccounting ********************************************/

SELECT FA.CenterID
,	FA.PartitionDate

	/*	AccountID	AccountDescription
		10237		NB - Net Sales (Excl Sur) $
		10240		NB - Applications #
		10305		NB - Traditional Sales $
		10306		NB - Xtrands Sales $
		10310		NB - Gradual Sales $
		10315		NB - Extreme Sales $
		10320		NB - Surgery Sales $
		10325		NB - PostEXT Sales $
		10430		PCP - BIO Conversion #
		10490		PCP - BIO Attrition %
		10530		BIO Active PCP $ (BIO only) --(Not using)per Mike N. 5/8/2015 RH
		10536		BIO EXT & XTR Sales $  --We are using this one for PCP Revenue
		10552       NB Laser Sales $
		10891		NB - RestorInk $
	*/

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891)  THEN ROUND(Flash,0) ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891)  THEN ROUND(Flash,0) ELSE 0 END, 0)) END AS 'NetNb1Amount'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10305,10306,10310,10315,10320,10325,10552,10891) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NetNb1Budget'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Flash,0) ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Flash,0) ELSE 0 END, 0)) END AS 'Applications'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'Applications_Budget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Flash,0) ELSE 0 END, 0)) AS 'BioConversions'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Budget,0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Budget,0) ELSE 0 END, 0))END AS 'BioConversions_Budget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ROUND(Flash,0) ELSE 0 END, 0)) AS 'XtrConversions'--What AccountID?
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ROUND(Budget,0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10433) THEN ROUND(Budget,0) ELSE 0 END, 0))END AS 'XtrConversions_Budget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ROUND(Flash,0) ELSE 0 END, 0)) AS 'EXTConversions'--What AccountID?
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ROUND(Budget,0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN ROUND(Budget,0) ELSE 0 END, 0))END AS 'EXTConversions_Budget'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (3090)  THEN ROUND(ABS(Budget),0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN(3090) THEN ROUND(ABS(Budget),0) ELSE 0 END, 0))END AS 'Retail_Budget' --Retail amount is found separately below

INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber
WHERE FA.PartitionDate IN(@PartitionDate)
GROUP BY FA.CenterID
,	FA.PartitionDate



/********************* Find Retail ***************************************************************************/

INSERT  INTO #RetailSales
        SELECT  #Centers.CenterNumber
		,	@PartitionDate AS 'PartitionDate'
		,	SUM(ISNULL(t.RetailAmt, 0)) AS 'RetailSales'

		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON t.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON t.CenterKey = c.CenterKey                             --JOIN on Transaction Center
		INNER JOIN #Centers
            ON c.CenterNumber = #Centers.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON t.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @PartitionDate AND @EndOfMonth
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
		GROUP BY #Centers.CenterNumber


/***************** Find totals with the caps *************************************************************/

SELECT C.CenterNumber
,	A.PartitionDate

,	ISNULL(a.NetNb1Amount, 0) AS 'NBTradGradRevenue'
,	ISNULL(a.NetNb1Budget, 0) AS 'NBTradGradRev_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.NetNb1Amount, 0), ISNULL(a.NetNb1Budget, 0)) > @NBTradGradRevenueToBudget_Cap
		THEN @NBTradGradRevenueToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.NetNb1Amount, 0), ISNULL(a.NetNb1Budget, 0))
	END AS 'NBTradGradRevenueToBudgetPercent'

,	ISNULL(a.Applications, 0) AS 'Applications'
,	ISNULL(a.Applications_Budget, 0) AS 'Applications_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.Applications, 0), ISNULL(a.Applications_Budget, 0)) > @AppsToBudget_Cap
		THEN @AppsToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.Applications, 0), ISNULL(a.Applications_Budget, 0))
	END AS 'ApplicationsToBudgetPercent'

,	ISNULL(a.BioConversions, 0) AS 'BIOConversions'
,	ISNULL(a.BIOConversions_Budget, 0) AS 'BIOConversions_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BIOConversions_Budget, 0)) > @BioConvToBudget_Cap
		THEN @BioConvToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.BioConversions, 0), ISNULL(a.BIOConversions_Budget, 0))
	END AS 'BIOConversionToBudgetPercent'

,	ISNULL(a.XtrConversions, 0) AS 'XtrConversions'
,	ISNULL(a.XtrConversions_Budget, 0) AS 'XtrConversions_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.XtrConversions, 0), ISNULL(a.XtrConversions_Budget, 0)) > @XtrConvToBudget_Cap
		THEN @XtrConvToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.XtrConversions, 0), ISNULL(a.XtrConversions_Budget, 0))
	END AS 'XtrConversionToBudgetPercent'

,	ISNULL(a.EXTConversions, 0) AS 'EXTConversions'
,	ISNULL(a.EXTConversions_Budget, 0) AS 'EXTConversions_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(a.EXTConversions_Budget, 0)) > @EXTConvToBudget_Cap
		THEN @EXTConvToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.EXTConversions, 0), ISNULL(a.EXTConversions_Budget, 0))
	END AS 'EXTConversionToBudgetPercent'


,	ISNULL(RS.RetailSales, 0) AS 'RetailSales'
,	ISNULL(A.Retail_Budget, 0) AS 'Retail_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(RS.RetailSales, 0), ISNULL(A.Retail_Budget, 0)) > @RetailToBudget_Cap
		THEN @RetailToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(RS.RetailSales, 0), ISNULL(A.Retail_Budget, 0))
	END AS 'RetailToBudgetPercent'
INTO #Final
FROM #Centers C
	LEFT OUTER JOIN #Accounting A
		ON C.CenterNumber = A.CenterID
	LEFT OUTER JOIN #RetailSales RS
		ON RS.CenterNumber = C.CenterNumber AND RS.PartitionDate = A.PartitionDate

SELECT CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	CTR.CenterDescription
,	CTR.RecurringBusinessSize
,	CTR.CenterManagementAreaSSID
,	CTR.CenterManagementAreaDescription
,	CTR.CenterManagementAreaSortOrder
,	F.PartitionDate

,	F.NBTradGradRevenue
,	F.NBTradGradRev_Budget
,	F.NBTradGradRevenueToBudgetPercent

,	F.Applications
,	F.Applications_Budget
,	F.ApplicationsToBudgetPercent

,	F.BIOConversions
,	F.BIOConversions_Budget
,	F.BIOConversionToBudgetPercent

,	F.XtrConversions
,	F.XtrConversions_Budget
,	F.XtrConversionToBudgetPercent

,	F.EXTConversions
,	F.EXTConversions_Budget
,	F.EXTConversionToBudgetPercent

,	F.RetailSales
,	F.Retail_Budget
,	F.RetailToBudgetPercent

,	((F.NBTradGradRevenueToBudgetPercent * @NBTradGradRevenueToBudget_Weighting)
		+ (F.ApplicationsToBudgetPercent * @AppsToBudget_Weighting)
		+ (F.BIOConversionToBudgetPercent * @BioConvToBudget_Weighting)
		+ (F.XtrConversionToBudgetPercent * @XtrConvToBudget_Weighting)
		+ (F.EXTConversionToBudgetPercent * @EXTConvToBudget_Weighting)
		+ (F.RetailToBudgetPercent * @RetailToBudget_Weighting)
		)
	 Total

FROM #Final F
INNER JOIN #Centers CTR
	ON F.CenterNumber = CTR.CenterNumber

END
GO
