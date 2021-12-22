/* CreateDate: 05/06/2015 16:25:00.257 , ModifyDate: 10/10/2018 14:21:24.820 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_WarBoardManagerChart

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		05/05/2015

==============================================================================
DESCRIPTION:	This stored procedure is for the chart for the Manager Warboard (WO#110458)
==============================================================================
CHANGE HISTORY:
09/11/2015 - RH - (#118524) Changed Budget to ROUND(Budget,0) and Flash to ROUND(Flash,0)
01/21/2016 - RH - (#122371) Changed to pull Retention from MonthlyRetention
03/24/2016 - RH - (#123656) Changed Retention target to 100%
07/08/2016 - RH - (#126425) Changed HairSalesMix_Budget to .50 (50%)
03/03/2017 - RH - (#134162) Added RecurringBusinessSize; changed to order by RecurringBusinessSize
01/15/2018 - RH - (#145629) Made requested changes for 2018; Added CenterType to Center query
04/16/2018 - RH - (#148069) Changed the Budget value called “NB - Net Sales (Incl PEXT) #” to total of each XTR+ Initial, XTR+ Initial 6, EXT, Xtrands, Surgery, and PostEXT
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_WarBoardManagerChart 1, 2018, 0

EXEC spRpt_WarBoardManagerChart 1, 2018, 1

==============================================================================
*/
CREATE PROCEDURE [dbo].[xxxspRpt_WarBoardManagerChart] (
	@Month INT
,	@Year INT
,	@CenterType INT  -- 0 All, 1 Corporate
)
AS
BEGIN
SET FMTONLY OFF
SET NOCOUNT OFF

DECLARE	@PartitionDate DATETIME
,	@PartitionDatePrecedingMonth DATETIME
,	@PartitionDateTwoMonthsAgo DATETIME
,	@NBTradGradRevenueToBudget_Cap  NUMERIC(15,5)
,	@NBTradGradToBudget_Cap NUMERIC(15,5)
,	@AppsToBudget_Cap NUMERIC(15,5)
,	@BioConvToBudget_Cap NUMERIC(15,5)
,	@PCPRetentionToBudget_Cap NUMERIC(15,5)
,	@PCPRevenueToBudget_Cap NUMERIC(15,5)

,	@NBTradGradRevenueToBudget_Weighting NUMERIC(15,5)
,	@NBTradGradToBudget_Weighting NUMERIC(15,5)
,	@AppsToBudget_Weighting NUMERIC(15,5)
,	@BioConvToBudget_Weighting NUMERIC(15,5)
,	@PCPRetentionToBudget_Weighting NUMERIC(15,5)
,	@PCPRevenueToBudget_Weighting NUMERIC(15,5)

SELECT @PartitionDate = CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME)
,	@PartitionDatePrecedingMonth = DATEADD(MONTH,-1,CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME))
,	@PartitionDateTwoMonthsAgo = DATEADD(MONTH,-2,CAST(CAST(@Month AS NVARCHAR(2)) + '/1/' + CAST(@Year AS NVARCHAR(4)) AS DATETIME))
,	@NBTradGradRevenueToBudget_Cap = 1.50
,	@NBTradGradToBudget_Cap = 1.25
,	@AppsToBudget_Cap = 1.50
,	@BioConvToBudget_Cap = 1.25
,	@PCPRetentionToBudget_Cap = 1.05
,	@PCPRevenueToBudget_Cap = 1.05

,	@NBTradGradRevenueToBudget_Weighting = .2
,	@NBTradGradToBudget_Weighting = .2
,	@AppsToBudget_Weighting = .2				--New Styles
,	@BioConvToBudget_Weighting = .1				--XTR+
,	@PCPRetentionToBudget_Weighting = .1
,	@PCPRevenueToBudget_Weighting = .2

--PRINT '@PartitionDate = ' + CAST(@PartitionDate AS NVARCHAR(12))
--PRINT '@PartitionDatePrecedingMonth = ' + CAST(@PartitionDatePrecedingMonth AS NVARCHAR(12))
--PRINT '@PartitionDateTwoMonthsAgo = ' + CAST(@PartitionDateTwoMonthsAgo AS NVARCHAR(12))

CREATE TABLE #Centers (
		CenterSSID INT
	,	CenterDescriptionNumber NVARCHAR(150)
	,	CenterDescription NVARCHAR(150)
	,	RecurringBusinessSize NVARCHAR(10)
	,	CenterManagementAreaSSID INT
	,	CenterManagementAreaDescription  NVARCHAR(150)
	,	CenterManagementAreaSortOrder  INT
)

INSERT INTO #Centers
SELECT C.CenterSSID
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
			10233		NB - Net Revenue (Incl PEXT) $
			10231		NB - Net Sales (Incl PEXT) $
			10240		NB - Applications #
			10430		PCP - BIO Conversion #
			10490		PCP - BIO Attrition %
			10530		BIO Active PCP $ (BIO only) --(Not using)per Mike N. 5/8/2015 RH
			10536		BIO EXT & XTR Sales $  --We are using this one for PCP Revenue
		*/
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10233) THEN ROUND(Flash,0) ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10233) THEN ROUND(Flash,0) ELSE 0 END, 0)) END AS 'NBTradGradRevenue'  --This is total NB1 revenue incl PEXT $
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10233) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10233) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NBTradGradRev_Budget'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(Flash,0) ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(Flash,0) ELSE 0 END, 0)) END AS 'NBTradGrad'		--This is total NB1 sales incl PEXT #
--,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
--		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10231) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NBTradGrad_Budget'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10206, 10210, 10215, 10220, 10225) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'NBTradGrad_Budget'

,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Flash,0) ELSE 0 END, 0)) = 0
		THEN 0 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Flash,0) ELSE 0 END, 0)) END AS 'Applications'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) = 0
		THEN 1 ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN ROUND(Budget,0) ELSE 0 END, 0)) END AS 'Applications_Budget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Flash,0) ELSE 0 END, 0)) AS 'BioConversions'
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Budget,0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN ROUND(Budget,0) ELSE 0 END, 0))END AS 'BioConversions_Budget'

,	RET.PCPRetention AS 'PCPRetention'   --BIO Only
,	1 AS 'PCPRetention_Budget'

,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN (ROUND(Flash,0)) ELSE 0 END, 0)) AS 'PCPRevenue'  --BIO EXT & XTR Sales $
,	CASE WHEN SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ROUND(Budget,0) ELSE 0 END, 0))= 0 THEN 1
		ELSE SUM(ISNULL(CASE WHEN FA.AccountID IN (10536) THEN ROUND(Budget,0) ELSE 0 END, 0))END AS 'PCPRevenue_Budget'

INTO #Accounting
FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterSSID
	LEFT OUTER JOIN MonthlyRetention RET
		ON FA.CenterID = RET.CenterSSID
		AND FA.PartitionDate = RET.FirstDateOfMonth
WHERE FA.PartitionDate IN(@PartitionDate, @PartitionDatePrecedingMonth, @PartitionDateTwoMonthsAgo)
GROUP BY FA.CenterID
,	FA.PartitionDate
,	RET.PCPRetention


/***************** Find totals with the caps *************************************************************/

SELECT C.CenterSSID
,	A.PartitionDate

,	ISNULL(a.NBTradGradRevenue, 0) AS 'NBTradGradRevenue'
,	ISNULL(a.NBTradGradRev_Budget, 0) AS 'NBTradGradRev_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.NBTradGradRevenue, 0), ISNULL(a.NBTradGradRev_Budget, 0)) > @NBTradGradRevenueToBudget_Cap
		THEN @NBTradGradRevenueToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.NBTradGradRevenue, 0), ISNULL(a.NBTradGradRev_Budget, 0))
	END AS 'NBTradGradRevenueToBudgetPercent'

,	ISNULL(a.NBTradGrad, 0) AS 'NBTradGrad'
,	ISNULL(a.NBTradGrad_Budget, 0) AS 'NBTradGrad_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.NBTradGrad, 0), ISNULL(a.NBTradGrad_Budget, 0)) > @NBTradGradToBudget_Cap
		THEN @NBTradGradToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.NBTradGrad, 0), ISNULL(a.NBTradGrad_Budget, 0))
	END AS 'NBTradGradToBudgetPercent'

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


,	ISNULL(a.PCPRetention, 0) AS 'PCPRetention'
,	ISNULL(a.PCPRetention_Budget, 0) AS 'PCPRetention_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.PCPRetention, 0), ISNULL(a.PCPRetention_Budget, 0)) > @PCPRetentionToBudget_Cap
		THEN @PCPRetentionToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.PCPRetention, 0), ISNULL(a.PCPRetention_Budget, 0))
	END AS 'PCPRetentionToBudgetPercent'

,	ISNULL(a.PCPRevenue, 0) AS 'PCPRevenue'
,	ISNULL(a.PCPRevenue_Budget, 0) AS 'PCPRevenue_Budget'
,	CASE WHEN dbo.DIVIDE_DECIMAL(ISNULL(a.PCPRevenue, 0), ISNULL(a.PCPRevenue_Budget, 0)) > @PCPRevenueToBudget_Cap
		THEN @PCPRevenueToBudget_Cap
		ELSE dbo.DIVIDE_DECIMAL(ISNULL(a.PCPRevenue, 0), ISNULL(a.PCPRevenue_Budget, 0))
	END AS 'PCPRevenueToBudgetPercent'
INTO #Final
FROM #Centers C
	LEFT OUTER JOIN #Accounting A
		ON C.CenterSSID = A.CenterID


SELECT CTR.CenterSSID
,	CTR.CenterDescriptionNumber
,	CTR.CenterDescription
,	CTR.RecurringBusinessSize
,	CTR.CenterManagementAreaSSID
,	CTR.CenterManagementAreaDescription
,	CTR.CenterManagementAreaSortOrder
,	F.PartitionDate
,	CASE WHEN F.PartitionDate = @PartitionDate THEN '3'
		WHEN F.PartitionDate = @PartitionDatePrecedingMonth THEN '2'
	ELSE '1'
	END AS 'Month'
,	SUM((F.NBTradGradRevenueToBudgetPercent * @NBTradGradRevenueToBudget_Weighting)
		+ (F.NBTradGradToBudgetPercent * @NBTradGradToBudget_Weighting)
		+ (F.ApplicationsToBudgetPercent * @AppsToBudget_Weighting)
		+ (F.BIOConversionToBudgetPercent * @BioConvToBudget_Weighting)
		+ (F.PCPRetentionToBudgetPercent * @PCPRetentionToBudget_Weighting)
		+ (F.PCPRevenueToBudgetPercent * @PCPRevenueToBudget_Weighting)
		)
	AS 'Total'
INTO #Rank
FROM #Final F
INNER JOIN #Centers CTR
	ON F.CenterSSID = CTR.CenterSSID
GROUP BY CTR.CenterSSID
,	CTR.CenterDescriptionNumber
,	CTR.CenterDescription
,	CTR.RecurringBusinessSize
,	CTR.CenterManagementAreaSSID
,	CTR.CenterManagementAreaDescription
,	CTR.CenterManagementAreaSortOrder
,	F.PartitionDate

SELECT CenterSSID
,	CenterDescriptionNumber
,	CenterDescription
,	RecurringBusinessSize
,	CenterManagementAreaSSID
,	CenterManagementAreaDescription
,	CenterManagementAreaSortOrder
,	PartitionDate
,	Total
,	[Month]
,	ROW_NUMBER() OVER(PARTITION BY RecurringBusinessSize,[Month]  ORDER BY Total DESC) AS 'TopFive'
INTO #FirstFive
FROM #Rank

SELECT * FROM #FirstFive
WHERE TopFive IN(1,2,3,4,5)
ORDER BY RecurringBusinessSize, [Month]

END
GO
