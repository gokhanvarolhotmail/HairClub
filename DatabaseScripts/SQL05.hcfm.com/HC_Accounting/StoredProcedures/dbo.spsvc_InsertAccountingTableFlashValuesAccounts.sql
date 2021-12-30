/* CreateDate: 02/06/2018 13:11:56.107 , ModifyDate: 08/12/2020 13:59:00.380 */
GO
/***********************************************************************
PROCEDURE:	[spsvc_InsertAccountingTableFlashValuesNewAccounts]
DESTINATION SERVER:	   SQL06
DESTINATION DATABASE: HC_Accounting
RELATED APPLICATION:  Accounting table
AUTHOR: Marlon Burrell
IMPLEMENTOR: Marlon Burrell
DATE IMPLEMENTED: 5/10/10
------------------------------------------------------------------------
NOTES:

This procedure populates the Flash column in the Accounting table
from various Fact tables

06/04/2010 - MB - Added 10557, 10558
09/20/2010 - KM - WO#55625 - Changed @refreshinterval from -12 to -26
09/23/2010 - KM - WO#55625 - Changed @refreshinterval from -26 to -12
11/10/2011 - MB - Temporarily changed refresh dates to go back to 1/1/07 to populate PCP numbers
04/11/2012 - KM - Added 10431 & 10432 Gradual & Tradition Conversions
04/23/2012 - KM - Added 10241 & 10242 Gradual & Tradition Applications
06/14/2012 - MB - Added code to update Forecast values based on Flash values
07/11/2012 - MB - Changed @RefreshInterval parameter per DR request
03/05/2013 - KM - Modified to come from BI environment
03/18/2013 - KM - Excluded POSTEXT Sales from EXT counts
03/19/2013 - KM - Modified Hair System order select to be ISNULL(HairSystemAlocationDate,HairSystemOrderDate)
03/20/2013 - KM - Changed 10530 to be PCP_NB2$
03/26/2013 - KM - Modified 10557 to use DSO performer2_temp for CMS25 centers and Employee2key for cONEct ctrs
04/11/2013 - MB - Changed refresh interval to 1 month so that PCP numbers don't get overwritten
03/20/2013 - KM - Changed 10530 back to be PCP_PCP$
06/13/2013 - KM - Added 10604, 10614
06/26/2013 - KM - Added 10570,10575,10576
07/24/2013 - MB - Added 10580
08/14/2013 - MB - Added gender based PCP accounts (WO# 90131)
06/10/2014 - RH - Added 10206 NB_Xtr# and 10306 NB_Xtr$ (WO# 102937)
11/06/2014 - RH - Added Xtrands AccountID's (WO# 108389)
12/03/2014 - RH - Removed Xtrands from 10430 - BIO Conversions and 10431 - TRAD Conversions; Added 10433 Xtrands Conversions; Changed the statements for Conversions (WO#109328)
12/23/2014 - RH - Added PCP_Xtr$ as '10531'(WO#109702)
03/16/2015 - RH - Added FactPCP.XTR to the "Get PCP numbers" section (WO#112750) and added Xtrands Services (search on 03/16/2015)
06/29/2015 - RH - Changed to DimCenter (from HCSQL2\SQL2005 to SQL05) for inner join in the "Consolidate all tables" section and added a temp table to find the PayPeriodCt (WO#115211)
06/30/2015 - RH - Added a new AccountID 10532 PCP - BIO Sales $; Changed formula for 10536 = (10531+10532+10535) [PCP - Xtr Sales $]+[PCP - BIO Sales $]+[PCP - EXT Sales $]
06/14/2016 - DL - Added 10421 - PCP - XTR Lost #
02/06/2018 - KM	- Modified to use CenterNumber instead of CenterSSID
03/06/2018 - RH - Modified to use CenterType in query to find 10400 (since CenterID in FactPCP for Colorado Springs is 1002)
01/10/2019 - RH - Added [10236 - NB - Net Sales (Excl Sur) #] and [10237 - NB - Net Sales (Excl Sur) $] which will be populated with 10231 minus 10220, and 10233 minus 10320
06/21/2019 - DL - Added new Laser KPI accounts 10551 & 10552
01/23/2020 - RH - Changed to WHERE C.[CenterNumber] LIKE '[2378]%' AND C.Active = 'Y' AND CenterNumber NOT IN(340,366,341,355)  --DK International (340),London Hair Clinic (366),IHI (341),Hans Wiemann (355)
06/22/2020 - KM - Created new PRP numbers and added to totals where appropriate 10221 PRP# and 10321 PRP$
------------------------------------------------------------------------

SAMPLE EXEC:

EXEC spsvc_InsertAccountingTableFlashValuesAccounts
--***********************************************************************/
CREATE PROCEDURE [dbo].[spsvc_InsertAccountingTableFlashValuesAccounts]
AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON


	/*
		Declare and set the refresh interval for the query
	*/
	DECLARE @RefreshInterval INT
	,	@RefreshDate DATETIME
	,	@TransactionRefreshDate DATETIME
	,	@TransactionEndDate DATETIME
	,	@PCPRefreshDate DATETIME


	SET @RefreshInterval = -2
	SET @RefreshDate = DATEADD(mm, @RefreshInterval, GETDATE())
	SET @TransactionRefreshDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	SET @TransactionEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(getdate()+400)) + '/1/' + CONVERT(VARCHAR, YEAR(getdate()+400)))
	SET @PCPRefreshDate = DATEADD(mm, -4, GETDATE())
	--SET @PCPRefreshDate = '3/1/2019'


	/*
		Populate a temp table with the PayPeriodCt for dates between @TransactionRefreshDate AND @TransactionEndDate
	*/
	SELECT MONTH(PP.StartDate) AS [Month]
		,	YEAR(PP.StartDate) AS [Year]
		,	PP.PayGroup
		,	COUNT(PP.PayPeriodKey) AS 'PayPeriodCt'
	INTO #PayPeriods
	FROM SQL06.HC_Commission.dbo.lkpPayPeriods PP
	WHERE PP.PayGroup = 1
	AND  PP.StartDate BETWEEN @TransactionRefreshDate AND @TransactionEndDate
	GROUP BY MONTH(PP.StartDate), YEAR(PP.StartDate), PP.PayGroup


	/*
		Populate temporary table with all the centers and dates applicable to the report
	*/
	SELECT [DimCenter].CenterNumber AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))) AS 'Date'
	INTO #Centers
	FROM HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate, HC_BI_ENT_DDS.[bi_ent_dds].[DimCenter] DimCenter
	WHERE [DimDate].[FullDate] between @TransactionRefreshDate and @TransactionEndDate
		AND DimCenter.[CenterNumber] LIKE '[2378]%'
		AND DimCenter.Active = 'Y'
		AND DimCenter.CenterNumber NOT IN(340,366,341,355)
	GROUP BY [DimCenter].CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate])))
	ORDER BY [DimCenter].CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate])))


	/*
		Get Beback and Consultation numbers
		-------------------------------------------------------------
		10105 = BeBacks
		10110 = Consultations
		10100 = Appointments
		10120 = Shows
		10125 = Sales
	*/
	SELECT
		DimCenter.CenterNumber as 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101)) AS 'date'
	,	SUM(ISNULL(FactActivityResults.BeBack,0)) AS '10105'
	,	SUM(ISNULL(FactActivityResults.Consultation,0)) AS '10110'
	,	SUM(ISNULL(FactActivityResults.Appointments,0)) AS '10100'
	,	SUM(ISNULL(FactActivityResults.Show,0)) AS '10120'
	,	SUM(ISNULL(FactActivityResults.Sale,0)) AS '10125'
	INTO #FactActivity
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FactActivityResults
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate
			ON FactActivityResults.ActivityDueDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DimCenter
			on FactActivityResults.CenterKey = DimCenter.CenterKey
	WHERE DimCenter.[CenterNumber] LIKE '[2378]%'
		AND DimCenter.Active = 'Y'
		AND DimCenter.CenterNumber NOT IN(340,366,341,355)
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY FactActivityResults.CenterKey,DimCenter.CenterNumber
	,	CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101)
	ORDER BY FactActivityResults.CenterKey,DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))


	/*
		Get InHouse numbers
		(They were not being calculated in either of the Fact tables
		------------------------------------------------------------
		10115 = InHouse
	*/
	SELECT
		DimCenter.CenterNumber as 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DimDate.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DimDate.[FullDate]))), 101)) AS 'date'
	,	COUNT(FactActivity.ActivityKey) AS '10115'
	INTO #InHouse
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivity FactActivity
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DimActivity
			ON FactActivity.ActivityKey = DimActivity.ActivityKey
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate
			ON FactActivity.ActivityDueDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactActivity.CenterKey = DimCenter.CenterKey
	WHERE DimCenter.[CenterNumber] LIKE '[2378]%'
		AND DimCenter.Active = 'Y'
		AND DimCenter.CenterNumber NOT IN(340,366,341,355)
		AND DimDate.[FullDate] >= @TransactionRefreshDate
		AND DimActivity.ActioncodeSSID IN ('INHOUSE')
	GROUP BY FactActivity.CenterKey, DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DimDate.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DimDate.[FullDate]))), 101))
	ORDER BY FactActivity.CenterKey, DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DimDate.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DimDate.[FullDate]))), 101))


	/*
		Get Employee Hours numbers
		--------------------------
		10730 = Employee Hours - Managers
		10725 = Employee Hours - Admin
		10745 = Employee Hours - Technician
		10735 = Employee Hours - NB1
		10740 = Employee Hours - NB2
	*/
	SELECT [PerformerHomeCenter] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([CheckDate])) + '/1/' + CONVERT(VARCHAR, YEAR([CheckDate]))), 101)) AS 'date'
	,	SUM(CASE WHEN [Account] IN (9011) THEN ([SalHours] + [RegHours] + [OTHours] + [PTOHours] + [PartTimeHours] + [FuneralHours] + [JuryHours]) ELSE 0 END) AS '10730'
	,	SUM(CASE WHEN [Account] IN (9012) THEN ([SalHours] + [RegHours] + [OTHours] + [PTOHours] + [PartTimeHours] + [FuneralHours] + [JuryHours]) ELSE 0 END) AS '10725'
	,	SUM(CASE WHEN [Account] IN (9013, 9014) THEN ([SalHours] + [RegHours] + [OTHours] + [PTOHours] + [PartTimeHours] + [FuneralHours] + [JuryHours]) ELSE 0 END) AS '10745'
	,	SUM(CASE WHEN [Account] IN (9015) THEN ([SalHours] + [RegHours] + [OTHours] + [PTOHours] + [PartTimeHours] + [FuneralHours] + [JuryHours]) ELSE 0 END) AS '10735'
	,	SUM(CASE WHEN [Account] IN (9016) THEN ([SalHours] + [RegHours] + [OTHours] + [PTOHours] + [PartTimeHours] + [FuneralHours] + [JuryHours]) ELSE 0 END) AS '10740'
	INTO #Hours
	FROM [vwFactEmployeeHours]
	WHERE [CheckDate] >= @TransactionRefreshDate
	GROUP BY [PerformerHomeCenter]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([CheckDate])) + '/1/' + CONVERT(VARCHAR, YEAR([CheckDate]))), 101))


	/*
		Get Production Order numbers
		----------------------------
		10610 = Hair Systems
		10605 = Hair System Cost
	*/
	SELECT DimCenter.[CenterNumber] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(ISNULL(HairSystemAlocationDate,HairSystemOrderDate))) + '/1/' + CONVERT(VARCHAR, YEAR(ISNULL(HairSystemAlocationDate,HairSystemOrderDate)))), 101)) AS 'date'
	,	AVG(FactHairSystemOrder.[CostActual]) AS '10604'
	,	SUM(FactHairSystemOrder.[CostActual]) AS '10605'
	,	COUNT(FactHairSystemOrder.[HairSystemOrderNumber]) AS '10610'
	INTO #Orders
	FROM HC_BI_CMS_DDS.bi_cms_dds.[vwFactHairSystemOrder] FactHairSystemOrder
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactHairSystemOrder.ClientHomeCenterKey = DimCenter.CenterKey
	WHERE ISNULL(HairSystemAlocationDate,HairSystemOrderDate) >= @TransactionRefreshDate
	GROUP BY DimCenter.[CenterNumber]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(ISNULL(HairSystemAlocationDate,HairSystemOrderDate))) + '/1/' + CONVERT(VARCHAR, YEAR(ISNULL(HairSystemAlocationDate,HairSystemOrderDate)))), 101))


	/*
		Get Production Orders shipped numbers
		-------------------------------------
		10614 = Hair Systems Shipped Avg$
		10615 = Hair Systems Shipped #
		10620 = Hair System Shipped $
	*/
	SELECT DimCenter.[CenterNumber] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemShippedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemShippedDate] ))), 101)) AS 'date'
	,	AVG([CostActual]) AS '10614'
	,	SUM([CostActual]) AS '10615'
	,	COUNT([HairSystemOrderNumber]) AS '10620'
	INTO #OrdersShipped
	FROM HC_BI_CMS_DDS.bi_cms_dds.[vwFactHairSystemOrder] FactHairSystemOrder
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactHairSystemOrder.ClientHomeCenterKey = DimCenter.CenterKey
	WHERE [HairSystemShippedDate] >= @TransactionRefreshDate
	GROUP BY DimCenter.[CenterNumber]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemShippedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemShippedDate] ))), 101))


	/*
		Get Production Orders Applied numbers
		-------------------------------------
		10624 = Hair Systems Applied Avg$
		10625 = Hair Systems Applied #
		10630 = Hair System Applied $
	*/
	SELECT DimCenter.[CenterNumber] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemAppliedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemAppliedDate] ))), 101)) AS 'date'
	,	AVG([CostActual]) AS '10624'
	,	SUM([CostActual]) AS '10625'
	,	COUNT([HairSystemOrderNumber]) AS '10630'
	INTO #OrdersApplied
	FROM HC_BI_CMS_DDS.bi_cms_dds.[vwFactHairSystemOrder] FactHairSystemOrder
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactHairSystemOrder.ClientHomeCenterKey = DimCenter.CenterKey
	WHERE [HairSystemAppliedDate] >= @TransactionRefreshDate
	GROUP BY DimCenter.[CenterNumber]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemAppliedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemAppliedDate] ))), 101))


	/*
		Get Marketing numbers
		---------------------
		10155 = Leads

	*/
	SELECT DimCenter.CenterNumber AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101)) AS 'date'
	,	SUM(FactLead.Leads) AS '10155'
	INTO #FactLead
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FactLead
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate
			ON FactLead.LeadCreationDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactLead.CenterKey = DimCenter.CenterKey
	WHERE DimCenter.[CenterNumber] LIKE '[2378]%'
		AND DimCenter.Active = 'Y'
		AND DimCenter.CenterNumber NOT IN(340,366,341,355)
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))
	ORDER BY DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))


	/*
		Get Sales numbers
		-----------------
		10305 = Sales NB1 Traditional
		10306 = Sales NB1 Xtrands
		10315 = Sales Extreme Hair Program
		10310 = Sales NB1 Gradual
		10540 = Non-Prog $ (Old name: Sales NB2)
		10530 = PCP - PCP Sales $
		10531 = PCP - XTR Sales $
		10532 = PCP - BIO Sales $
		10535 = PCP - EXTMEM Sales $
		10536 = PCP - BIO & EXTMEM Sales $
		10320 = Surgery Revenue
		10325 = PostEXT Revenue
		10541 = NB2 + PCP
		3080 = Service
		3090 = Sales - Retail Products
		10205 = NB - Traditional
		10206 = NB - Xtrands
		10210 = NB - Gradual
		10215 = NB - Extreme
		10220 = NB - Surgery
		10221 = NB - PRP
		10235 = NB - Gross
		10225 = NB - PostEXT
		10240 = NB - Applications
		10241 = NB - Applications (Trad)
		10242 = NB - Applications (Grad)

		10551 = PCP Laser Sales $
		10552 = NB Laser Sales $

		10901 - NB - RestorInk #
		10891 - NB - RestorInk $

		10892 - Non-Program & A La Carte Sales $
		10893 - Extension Sales $
		10894 - Halo Sales $
		10895 - Retail Sales (Excl Extensions, Halos & Laser) $
		10896 - Wig Sales $
		10897 - SPA Device Sales $
		10898 - Salon Services (Excl Extensions) $
		10899 - Extension Services $

	*/
	SELECT DimCenter.CenterNumber as 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DimDate.[fulldate])-1 ), DimDate.[fulldate]), 101)) AS 'date'
	,	SUM(FactSalesConect.[NB_Trad$]) AS '10305'
		,	SUM(FactSalesConect.[NB_Xtr$]) AS '10306'
	,	SUM(FactSalesConect.[NB_Ext$]) AS '10315'
	,	SUM(FactSalesConect.[NB_Grad$]) AS '10310'
	,	SUM(FactSalesConect.[PCP_NB2$] - FactSalesConect.[PCP_PCP$]) AS '10540'
	,	SUM(FactSalesConect.[PCP_PCP$]) AS '10530'
	,	SUM(FactSalesConect.[PCP_Xtr$]) AS '10531'
	,	SUM(FactSalesConect.[PCP_BIO$]) AS '10532'
	,	SUM(FactSalesConect.[PCP_ExtMem$]) AS '10535'
	,	SUM(FactSalesConect.[PCP_Xtr$])+SUM(FactSalesConect.[PCP_BIO$])+SUM(FactSalesConect.[PCP_ExtMem$]) AS '10536'
	,	SUM(FactSalesConect.[S1_NetSales$] + FactSalesConect.[SA_NetSales$]) AS '10320'
	,	SUM(FactSalesConect.[S_PRP$]) AS '10321'
	,	SUM(FactSalesConect.[S_PostEXT$]) AS '10325'
	,	SUM(FactSalesConect.[PCP_NB2$]) AS '10541'
	,	SUM(FactSalesConect.[Service$]) AS '3080'
	,	SUM(FactSalesConect.[Retail$]) AS '3090'
	,	SUM(FactSalesConect.NB_Trad#) AS '10205'
	,	SUM(FactSalesConect.NB_Xtr#) AS '10206'
	,	SUM(FactSalesConect.NB_Grad#) AS '10210'
	,	SUM(FactSalesConect.NB_Ext#) AS '10215'
	,	SUM(FactSalesConect.S1_NetSales# + SA_NetSales#) AS '10220'
	,	SUM(FactSalesConect.S_PRP#) AS '10221'
	,	SUM(FactSalesConect.NB_Trad# + FactSalesConect.NB_Grad# + FactSalesConect.NB_Ext# + FactSalesConect.NB_Xtr#
			+ FactSalesConect.S1_NetSales# +  FactSalesConect.SA_NetSales# + FactSalesConect.[S_PostExt#]) AS '10235'
	,	SUM(FactSalesConect.[S_PostExt#]) AS '10225'
	,	SUM(FactSalesConect.NB_Apps#) AS '10240'
	,	SUM(CASE WHEN FactSalesConect.MembershipKey not in (56,57,58,98,99,100,101,108,109)
			then FactSalesConect.NB_Apps# else 0 end ) as '10241'
	,	SUM(CASE WHEN FactSalesConect.MembershipKey in (56,57,58,98,99,100,101,108,109)
			then FactSalesConect.NB_Apps# else 0 end ) as '10242'
	,	SUM(FactSalesConect.[NB_LaserAmt]) AS '10552'
	,	SUM(FactSalesConect.[PCP_LaserAmt]) AS '10551'
	,	SUM(FactSalesConect.[NB_MDPCnt]) AS '10901'
	,	SUM(FactSalesConect.[NB_MDPAmt]) AS '10891'
	,	SUM(FactSalesConect.[NonProgramAmt]) + SUM(FactSalesConect.[PCP_ALCAmt]) AS '10892'
	,	SUM(FactSalesConect.[Retail_ExtensionsAmt]) AS '10893'
	,	SUM(FactSalesConect.[Retail_HalosAmt]) AS '10894'
	,	SUM(FactSalesConect.[Retail_OtherAmt]) AS '10895'
	,	SUM(FactSalesConect.[Retail_SPAAmt]) AS '10897'
	,	( SUM(FactSalesConect.[Service$]) - SUM(FactSalesConect.[Retail_ExtensionsSvcAmt]) ) AS '10898'
	,	SUM(FactSalesConect.[Retail_ExtensionsSvcAmt]) AS '10899'
	INTO #Sales
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect FactSalesConect
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate
				ON FactSalesConect.OrderDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DimCenter
			on FactSalesConect.CenterKey = DimCenter.CenterKey
	WHERE DimCenter.[CenterNumber] LIKE '[2378]%'
		AND DimCenter.Active = 'Y'
		AND DimCenter.CenterNumber NOT IN(340,366,341,355)
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY DimCenter.CenterNumber
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DimDate.[Fulldate])-1 ), DimDate.[Fulldate]), 101))
	order by DimCenter.CenterNumber


	/*
	Get Wig Revenue
	----------------
	10896 - Wig Sales $
	*/
	SELECT	ctr.CenterNumber AS 'Center'
	,		CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, - (DAY(d.FullDate) - 1), d.FullDate), 101)) AS 'date'
	,		SUM(CASE WHEN ( sc.SalesCodeDepartmentSSID = 7052 AND sot.TenderTypeDescriptionShort <> 'InterCo' ) THEN fsc.[SF-ExtendedPrice] ELSE 0 END) AS '10896'
	INTO	#Wigs
	FROM	HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect fsc
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
				ON d.DateKey = fsc.OrderDateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter ctr
				ON ctr.CenterKey = fsc.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
				ON sc.SalesCodeKey = fsc.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender sot
				ON sot.SalesOrderKey = fsc.SalesOrderKey
	WHERE	ctr.[CenterNumber] LIKE '[2378]%'
			AND ctr.Active = 'Y'
			AND ctr.CenterNumber NOT IN(340,366,341,355)
			AND d.FullDate >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY ctr.CenterNumber
	,		CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, - (DAY(d.FullDate) - 1), d.FullDate), 101))


	/*
		Get Cancel numbers
		-----------------
		10915 - NB Xtrands+ Cancels #
		10916 - NB EXT Cancels #
		10917 - NB Xtrands Cancels #
	*/
	SELECT	ctr.CenterNumber AS 'Center'
	,		CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(DAY, - (DAY(fsc.OrderDate) - 1), fsc.OrderDate), 101)) AS 'date'
	,		SUM(fsc.NB_XTRP_CancelCnt) AS '10915'
	,		SUM(fsc.NB_EXT_CancelCnt) AS '10916'
	,		SUM(fsc.NB_XTR_CancelCnt) AS '10917'
	INTO	#NBCancels
	FROM	HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect fsc
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterKey = fsc.CenterKey
	WHERE	ctr.[CenterNumber] LIKE '[2378]%'
			AND ctr.Active = 'Y'
			AND ctr.CenterNumber NOT IN(340,366,341,355)
			AND fsc.OrderDate >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY ctr.CenterNumber
	,		CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(DAY, - (DAY(fsc.OrderDate) - 1), fsc.OrderDate), 101))
	ORDER BY ctr.CenterNumber
	,		CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(DAY, - (DAY(fsc.OrderDate) - 1), fsc.OrderDate), 101))


		/*
		Get PCP numbers
		---------------
		10400 = PCP - PCP - BIO Active PCP #
		10401 = PCP - XTR Active PCP #
		10405 = PCP - EXTMEM Active PCP #
		10410 = PCP - BIO EXT & XTR Active PCP #

		10860 = PCP - BIO Active PCP  Male #
		10861 = PCP - XTR Active PCP Male #
		10865 = PCP - EXTMEM Active PCP  Male #
		10870 = PCP - BIO EXT & XTR Active PCP Male #

		10880 = PCP - BIO Active PCP FEMALE #
		10881 = PCP - XTR Active PCP FEMALE #
		10885 = PCP - EXTMEM Active PCP FEMALE #
		10890 = PCP - BIO EXT & XTR Active FEMALE PCP #
	*/

	SELECT C.CenterNumber AS 'Center' --Colorado Springs is listed as 1002 for CenterID in FactPCP
	,	DimDate.[FullDate] as 'Date'
	,	SUM(FactPCP.PCP) AS '10410'
	,	SUM(FactPCP.PCP) - (SUM(FactPCP.Extreme)+SUM(FactPCP.XTR)) AS '10400'    --Added FactPCP.XTR to this section RH 03/16/2015
	,	SUM(FactPCP.XTR) AS '10401'
	,	SUM(FactPCP.Extreme) AS '10405'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 1 THEN FactPCP.PCP ELSE 0 END)
		- SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 1 THEN (FactPCP.Extreme + FactPCP.XTR) ELSE 0 END) AS '10860'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 1 THEN FactPCP.XTR ELSE 0 END) AS '10861'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 1 THEN FactPCP.Extreme ELSE 0 END) AS '10865'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 1 THEN FactPCP.PCP ELSE 0 END) AS '10870'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 2 THEN FactPCP.PCP ELSE 0 END)
		- SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 2 THEN (FactPCP.Extreme + FactPCP.XTR) ELSE 0 END) AS '10880'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 2 THEN FactPCP.XTR ELSE 0 END) AS '10881'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 2 THEN FactPCP.Extreme ELSE 0 END) AS '10885'
	,	SUM(CASE WHEN ISNULL(FactPCP.GenderID, 1) = 2 THEN FactPCP.PCP ELSE 0 END) AS '10890'
	INTO #PCP_Current
	FROM HC_Accounting.dbo.FactPCP FactPCP
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate
			ON FactPCP.Datekey = DimDate.Datekey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON C.CenterKey = FactPCP.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
	WHERE CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND C.Active = 'Y'
			AND C.CenterKey <> 2 --Corporate
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@PCPRefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@PCPRefreshDate)))  --Three months ago - first of the month
		--AND DimDate.[FullDate] >= @PCPRefreshDate
	GROUP BY C.CenterNumber
	,	DimDate.[FullDate]


	SELECT C.CenterNumber AS 'Center'
	,	DimDate.[FullDate] as 'Date'
	,	DATEADD(MONTH, 1, DimDate.[FullDate]) AS 'ActualMonth'
	,	SUM(FactPCP.PCP) AS '10410_PriorMonth'
	,	SUM(FactPCP.PCP) - (SUM(FactPCP.Extreme)+ SUM(FactPCP.XTR)) AS '10400_PriorMonth'  --Added FactPCP.XTR RH 03/16/2015
	,	SUM(FactPCP.XTR) AS '10401_PriorMonth'
	,	SUM(FactPCP.Extreme) AS '10405_PriorMonth'
	INTO #PCP_Prior
	FROM HC_Accounting.dbo.FactPCP FactPCP
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DimDate
			ON FactPCP.DateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON C.CenterKey = FactPCP.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
	WHERE CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND C.Active = 'Y'
			AND C.CenterKey <> 2 --Corporate
		AND DimDate.[FullDate] >= DATEADD(MONTH, -1, CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@PCPRefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@PCPRefreshDate)))) --Four months ago - first of the month
		--AND DimDate.[FullDate] >= @PCPRefreshDate
	GROUP BY C.CenterNumber
	,	DimDate.[FullDate]


	--Consolidate PCP numbers
	SELECT #PCP_Current.Center
	,	#PCP_Current.[Date]
	,	#PCP_Current.[10400]
	,	#PCP_Current.[10401]
	,	#PCP_Current.[10405]
	,	#PCP_Current.[10410]
	,	#PCP_Current.[10860]
	,	#PCP_Current.[10861]
	,	#PCP_Current.[10865]
	,	#PCP_Current.[10870]
	,	#PCP_Current.[10880]
	,	#PCP_Current.[10881]
	,	#PCP_Current.[10885]
	,	#PCP_Current.[10890]
	,	#PCP_Prior.[10410_PriorMonth]
	,	#PCP_Prior.[10400_PriorMonth]
	,	#PCP_Prior.[10401_PriorMonth]
	,	#PCP_Prior.[10405_PriorMonth]
	INTO #PCP
	FROM #PCP_Current
		LEFT OUTER JOIN #PCP_Prior
			ON #PCP_Current.Center = #PCP_Prior.Center
			AND #PCP_Current.[Date] = #PCP_Prior.ActualMonth


	/*
		Get Milestone and Service Count numbers
		---------------------------------------
		10430 = PCP - BIO Conversion #
		10431 = PCP - BIO (Trad) Conversion #
		10432 = PCP - BIO (Grad) Conversion #
		10433 = PCP - Xtrands Conversion #
		10435 = PCP - EXTMEM Conversion #
		10440 = PCP - BIO & EXTMEM Conversion #
		10505 = PCP - Cancels #
		10510 = PCP - Downgrades #
		10515 = PCP - Upgrades #
		10326 = NB - BIO Services #
		10327 = NB - EXT Services #
		10521 = PCP - EXTMEM Services #
		10520 = PCP - BIO Services #
		10328 = NB - BIO Services $
		10329 = NB - EXT Services $
		10523 = PCP - BIO Services $
		10555 = Retail Sales $
		10550 = Retail Sales #
		10524 = PCP - EXTMEM Services $
		10580 = Service ?
	*/
	SELECT C.[CenterNumber] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DD.[FullDate]))), 101)) AS 'date'
	,	SUM(NB_BIOConv#) AS '10430'
	,		SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND NB_BIOConv# = 1
			AND Mem.[MembershipDescription] NOT LIKE 'Grad%'
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10431'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND Mem.[MembershipDescriptionShort] NOT IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			AND Mem.[MembershipDescriptionShort] IN ('GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10432'
	,	SUM(NB_XTRConv#) AS '10433'
	,	SUM(NB_ExtConv#) AS '10435'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10440'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1099)
			and Mem.[RevenueGroupSSID] = 2
			and Mem.[MembershipDescriptionShort] not in ('NONPGM')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10505'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1080)
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10510'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1070)
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10515'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5020, 5040, 5037)
			AND Mem.[MembershipDescriptionShort] IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12', 'XTRAND','XTRAND6')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10326'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10327'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10521'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] NOT IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL'
					,'GRADSOL12','GRDSVSOL12', 'EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL', 'EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10520'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5020, 5040, 5037)
			AND Mem.[MembershipDescriptionShort] IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12''XTRAND','XTRAND6')
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10328'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10329'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] NOT IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL'
					,'GRADSOL12','GRDSVSOL12', 'EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL', 'EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10523'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (3010, 3020, 3030, 3040, 3050, 3060, 3070, 3080)
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10555'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (3010, 3020, 3030, 3040, 3050, 3060, 3070, 3080)
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10550'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10524'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5020, 5030, 5035, 5037, 5038, 5040)
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10570'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5020, 5030, 5035, 5037, 5038, 5040)
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10575'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5020, 5030, 5035, 5036, 5037, 5038, 5040, 5050, 5060, 5061)
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10580'
	INTO #Milestones_temp
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect FactSalesConect
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership Mem
			on FactSalesConect.MembershipKey = Mem.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FactSalesConect.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FactSalesConect.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FactSalesConect.CenterKey = C.CenterKey
	WHERE C.[CenterNumber] LIKE '[2378]%'
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(340,366,341,355)
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.[SalesCodeDepartmentSSID] IN (1070, 1080, 1099, 1075, 2020, 3010, 3020, 3030, 3040, 3050, 3060, 3070, 3080, 5010, 5020, 5030, 5035, 5036, 5040, 5050, 5060, 5061)
		AND SC.[SalesCodeDescriptionShort] NOT IN ('TXFR', 'NB1TXFR','NB1REM','TXFRIN','TXFROUT')
		AND MEM.BusinessSegmentSSID <> 3
	GROUP BY C.[CenterNumber]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.[Fulldate])) + '/1/' + CONVERT(VARCHAR, YEAR(DD.[Fulldate]))), 101))


	SELECT [Center]
	,	[Date]
	,	SUM([10430]) AS '10430'
	,	SUM([10431]) AS '10431'
	,	SUM([10432]) AS '10432'
	,	SUM([10433]) AS '10433'
	,	SUM([10435]) AS '10435'
	,	SUM([10440]) AS '10440'
	,	SUM([10505]) AS '10505'
	,	SUM([10510]) AS '10510'
	,	SUM([10515]) AS '10515'
	,	SUM([10326]) AS '10326'
	,	SUM([10327]) AS '10327'
	,	SUM([10520]) AS '10520'
	,	SUM([10521]) AS '10521'
	,	SUM([10550]) AS '10550'
	,	SUM([10555]) AS '10555'
	,	SUM([10328]) AS '10328'
	,	SUM([10329]) AS '10329'
	,	SUM([10523]) AS '10523'
	,	SUM([10524]) AS '10524'
	,	SUM([10570]) AS '10570'
	,	SUM([10575]) AS '10575'
	,	SUM([10580]) AS '10580'

	INTO #Milestones
	FROM #Milestones_temp
	GROUP BY [Center]
	,	[Date]
	ORDER BY [Center]
	,	[Date]


		/*

		Get Milestone and Service Count numbers
		---------------------------------------
		10561 = Serviced - Traditional #
		10562 = Serviced - Gradual #
		10563 = Serviced - Extreme #
		10564 = Serviced - PCP BIO #
		10565 = Serviced - PCP EXTMEM #
		10566 = Serviced - NonPGM #

		*/


	SELECT C.CenterNumber as 'Center'
	,	Client.[clientnumber_temp] as 'Client_no'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, c.CenterNumber))) + '/1/' + CONVERT(VARCHAR, YEAR(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, c.CenterNumber)))), 101)) AS 'date'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] IN ('TRADITION')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10561'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] IN ('GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10562'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10563'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] NOT IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL',
			'GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12','EXTENH6','EXT6','EXTENH9',
					'EXT12','EXTENH12','POSTEXT','POSTEL','EXTMEM','EXTMEMSOL','NONPGM')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10564'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] IN ('EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10565'
	,	CASE WHEN SUM(CASE WHEN Mem.[MembershipDescriptionShort] IN ('NONPGM')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) > 0 THEN 1 ELSE 0 END AS '10566'
	INTO #UniqueServices_Temp
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect FactSalesConect
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership Mem
			on FactSalesConect.MembershipKey = Mem.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FactSalesConect.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FactSalesConect.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FactSalesConect.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient Client
			ON FactSalesConect.ClientKey = Client.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FactSalesConect.SalesorderKey = DSO.SalesorderKey
	WHERE C.[CenterNumber] LIKE '[2378]%'
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(340,366,341,355)
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
		AND SC.[SalesCodeDescriptionShort] NOT IN ('TXFR', 'NB1TXFR','NB1REM','TXFRIN','TXFROUT')
	GROUP BY C.[CenterNumber]
	,	Client.[clientnumber_temp]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairclubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, c.CenterNumber))) + '/1/' + CONVERT(VARCHAR, YEAR(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, c.CenterNumber)))), 101))


	SELECT [Center]
	,	[Date]
	,	SUM([10561]) AS '10561'
	,	SUM([10562]) AS '10562'
	,	SUM([10563]) AS '10563'
	,	SUM([10564]) AS '10564'
	,	SUM([10565]) AS '10565'
	,	SUM([10566]) AS '10566'
	INTO #UniqueServices
	FROM #UniqueServices_Temp
	GROUP BY [Center]
	,	[Date]
	ORDER BY [Center]
	,	[Date]


	/*
		Get unique retail client numbers
		---------------------------------------
		10557 = Retail Clients - Purchased #
	*/
	SELECT C.CenterNumber AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DD.[FullDate]))), 101)) AS 'date'
	,	Client.[clientnumber_temp] AS '10557'
	INTO #UniqueRetailClients_Temp
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect FactSalesConect
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership Mem
			on FactSalesConect.MembershipKey = Mem.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FactSalesConect.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FactSalesConect.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FactSalesConect.CenterKey = C.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient Client
			ON FactSalesConect.ClientKey = Client.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail dso
			ON FactSalesConect.SalesOrderDetailKey = dso.SalesOrderDetailKey
	WHERE C.[CenterNumber] LIKE '[2378]%'
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(340,366,341,355)
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.SalesCodeDepartmentSSID like ('30%')
		AND Mem.[MembershipDescriptionShort] NOT IN ('PRS','PRSSOL', 'EXE','EXESOL' ,'PRE','PRESOL', 'PLA','PLASOL','DIA','DIASOL', 'NB1')
		AND ((c.HasFullAccessFlag = 0 and dso.performer2_temp <> '') or (c.HasFullAccessFlag = 1 and FactSalesConect.Employee2Key <> -1))


	SELECT [Center]
	,	[Date]
	,	COUNT([10557]) AS '10557'
	INTO #UniqueRetailClients
	FROM #UniqueRetailClients_Temp
	GROUP BY [Center]
	,	[Date]
	ORDER BY [Center]
	,	[Date]


	/*
		Consolidate all tables
		10231 - NB - Net Sales (Incl PEXT) #
		10233 - NB - Net Sales (Incl PEXT) $
		10236 - NB - Net Sales (Excl Sur) # --which is 10231 minus NB Surgery# (10220)
		10237 - NB - Net Sales (Excl Sur) $ --which is 10233 minus NB Surgery$ (10320)
		10300 - NB - BIO EXT & XTR Average Sale $
	*/
	SELECT #Centers.center
	,	#Centers.[date]
	,	#Sales.[10205]
	,	#Sales.[10206]
	,	#Sales.[10210]
	,	#Sales.[10215]
	,	#Sales.[10220]
	,	#Sales.[10221]
	,	#Sales.[10235]
	,	#Sales.[10225]
	,	#Sales.[10240]
	,	#Sales.[10241]
	,	#Sales.[10242]
	,	#Milestones.[10440]
	,	#Milestones.[10520]
	,	#Milestones.[10521]
	,	#PCP.[10410]
	,	#PCP.[10400]
	,	#PCP.[10401]
	,	#PCP.[10405]
	,	#Milestones.[10515]
	,	#Milestones.[10510]
	,	#Milestones.[10505]
	,	#FactLead.[10155]
	,	#FactActivity.[10100]
	,	#FactActivity.[10120]
	,	#FactActivity.[10125]
	,	#FactActivity.[10105]
	,	#FactActivity.[10110]
	,	#InHouse.[10115]
	,	#Milestones.[10430]
	,	#Milestones.[10431]
	,	#Milestones.[10432]
	,	#Milestones.[10433]
	,	#Milestones.[10435]
	,	#Hours.[10730]
	,	#Hours.[10725]
	,	#Hours.[10745]
	,	#Hours.[10735]
	,	#Hours.[10740]
	,	#Orders.[10610]
	,   #Orders.[10604]
	,	#Orders.[10605]
	,	dbo.DivideNumeric(#Sales.[10240], (#Sales.[10205] + #Sales.[10210])) AS '10200'
	,	dbo.DivideNumeric(#FactActivity.[10100], #FactLead.[10155]) AS '10130'
	,	dbo.DivideNumeric(#Orders.[10605], #Orders.[10610]) AS '10600'
	,	dbo.DivideNumeric((#Sales.[10305] + #Sales.[10306] + #Sales.[10315] + #Sales.[10310]), (#Sales.[10205] + #Sales.[10206] + #Sales.[10210] + #Sales.[10215])) AS '10300'
	,	dbo.DivideNumeric(#Sales.[10315], #Sales.[10215]) AS '10285'
	,	dbo.DivideNumeric(#Sales.[10310], #Sales.[10210]) AS '10280'
	,	dbo.DivideNumeric(#Sales.[10325], #Sales.[10225]) AS '10295'
	,	dbo.DivideNumeric(#Sales.[10320], #Sales.[10220]) AS '10290'
	,	dbo.DivideNumeric(#Sales.[10305], #Sales.[10205]) AS '10275'
	,	dbo.DivideNumeric(#Sales.[10306], #Sales.[10206]) AS '10281'
	,	dbo.DivideNumeric(#Sales.[10215], #FactActivity.[10110]) AS '10175'
	,	dbo.DivideNumeric(#Sales.[10210], #FactActivity.[10110]) AS '10170'
	,	dbo.DivideNumeric(#Sales.[10225], #FactActivity.[10110]) AS '10185'
	,	dbo.DivideNumeric(#Sales.[10220], #FactActivity.[10110]) AS '10180'
	,	dbo.DivideNumeric(#Sales.[10205], #FactActivity.[10110]) AS '10165'
	,	dbo.DivideNumeric(#Sales.[10206], #FactActivity.[10110]) AS '10172'
	,	#Sales.[10205] + #Sales.[10210] AS '10230'
	,	dbo.DivideNumeric(#Sales.[10541], #PCP.[10400]) AS '10445'
	,	dbo.DivideNumeric(#Milestones.[10440], (#Sales.[10205] + #Sales.[10210])) AS '10475'
	,	dbo.DivideNumeric((#Sales.[10541] + #Sales.[10535]), #PCP.[10410]) AS '10455'
	,	#Milestones.[10430] - (#PCP.[10400_PriorMonth] + #Milestones.[10430] - #PCP.[10400]) AS '10460'
	,	#Milestones.[10435] - (#PCP.[10405_PriorMonth] + #Milestones.[10435] - #PCP.[10405]) AS '10465'
	,	#Milestones.[10440] - (#PCP.[10410_PriorMonth] + #Milestones.[10440] - #PCP.[10410]) AS '10470'
	,	dbo.DivideNumeric(#Sales.[10535], #PCP.[10405]) AS '10450'
	,	dbo.DivideNumeric(#Milestones.[10435], #Sales.[10215]) AS '10480'
	,	dbo.DivideNumeric(#FactActivity.[10125], #FactLead.[10155]) AS '10160'
	,	dbo.DivideNumeric(#FactActivity.[10120], #FactActivity.[10100]) AS '10135'
	,	dbo.DivideNumeric(#FactActivity.[10105], #FactActivity.[10120]) AS '10140'
	,	dbo.DivideNumeric(#FactActivity.[10110], #FactActivity.[10120]) AS '10145'
	,	dbo.DivideNumeric(#FactActivity.[10120], #FactLead.[10155]) AS '10150'
	,	#PCP.[10400_PriorMonth] + #Milestones.[10430] - #PCP.[10400] AS '10415'
	,	(dbo.DivideNumeric((#PCP.[10400_PriorMonth] + #Milestones.[10430] - #PCP.[10400]), ((#PCP.[10400_PriorMonth] + #PCP.[10400]))/2)) * 12 AS '10490'
	,	#PCP.[10410_PriorMonth] + #Milestones.[10440] - #PCP.[10410] AS '10425'
	,	(dbo.DivideNumeric((#PCP.[10410_PriorMonth] + #Milestones.[10440] - #PCP.[10410]), ((#PCP.[10410_PriorMonth] + #PCP.[10410]))/2)) * 12 AS '10500'
	,	#PCP.[10405_PriorMonth]  + #Milestones.[10435] -#PCP.[10405] AS '10420'
	,	#PCP.[10401_PriorMonth]  + #Milestones.[10433] -#PCP.[10401] AS '10421'
	,	(dbo.DivideNumeric((#PCP.[10405_PriorMonth]  + #Milestones.[10435] - #PCP.[10405]), ((#PCP.[10405_PriorMonth] + #PCP.[10405]))/2)) * 12 AS '10495'
	,	((#Hours.[10725] / vwPP.PayPeriodCt) * 26) / 2080 AS '10700'
	,	((#Hours.[10730] / vwPP.PayPeriodCt) * 26) / 2080 AS '10705'
	,	((#Hours.[10735] / vwPP.PayPeriodCt) * 26) / 2080 AS '10710'
	,	((#Hours.[10740] / vwPP.PayPeriodCt) * 26) / 2080 AS '10715'
	,	((#Hours.[10745] / vwPP.PayPeriodCt) * 26) / 2080 AS '10720'
	,	dbo.[DivideNumeric]((#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10220] + #Sales.[10205] + #Sales.[10206] + #Sales.[10901] + #Sales.[10221]), #FactActivity.[10110]) AS '10190'
	,	dbo.[DivideNumeric]((#Sales.[10215] + #Sales.[10210] + #Sales.[10220] + #Sales.[10205] + #Sales.[10206] + #Sales.[10901] + #Sales.[10221]), #FactActivity.[10110]) AS '10191'
	,	#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10220] + #Sales.[10205]  + #Sales.[10206] + #Sales.[10901] + #Sales.[10221]  AS '10231'
	,	#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10205]  + #Sales.[10206] AS '10236'
	,	#Sales.[10215] + #Sales.[10210] + #Sales.[10220] + #Sales.[10205] + #Sales.[10206] + #Sales.[10901] + #Sales.[10221] AS '10232'
	,	dbo.[DivideNumeric](#FactActivity.[10110], #FactActivity.[10100]) AS '10146'
	,	#Sales.[10305]
	,	#Sales.[10306]
	,	#Sales.[10310]
	,	#Sales.[10315]
	,	#Sales.[10320]
	,	#Sales.[10321]
	,	#Sales.[10325]
	,	#Sales.[10541] + #Sales.[10535] AS '10541'
	,	#Sales.[10530]
	,	#Sales.[10531]
	,	#Sales.[10532]
	,	#Sales.[10535]
	,	#Sales.[10536]
	,	#Sales.[10540]
	,	#Sales.[10552]
	,	#Sales.[10551]
	,	#Sales.[10901]
	,	#Sales.[10891]
	,	#Sales.[10892]
	,	#Sales.[10893]
	,	#Sales.[10894]
	,	#Sales.[10895]
	,	#Wigs.[10896]
	,	#Sales.[10897]
	,	#Sales.[10898]
	,	#NBCancels.[10915]
	,	#NBCancels.[10916]
	,	#NBCancels.[10917]
	,	#Sales.[10899]
	,   #OrdersShipped.[10614]
	,	#OrdersShipped.[10615]
	,	#OrdersShipped.[10620]
	,   #OrdersApplied.[10624]
	,	#OrdersApplied.[10625]
	,	#OrdersApplied.[10630]
	,	#Milestones.[10326]
	,	#Milestones.[10327]
	,	#Milestones.[10550]
	,	#Milestones.[10555]
	,	#Milestones.[10328]
	,	#Milestones.[10329]
	,	#Milestones.[10523]
	,	#UniqueServices.[10561] + #UniqueServices.[10562] + #UniqueServices.[10563] + #UniqueServices.[10564] + #UniqueServices.[10565] + #UniqueServices.[10566] AS '10560'
	,	#UniqueServices.[10561]
	,	#UniqueServices.[10562]
	,	#UniqueServices.[10563]
	,	#UniqueServices.[10564]
	,	#UniqueServices.[10565]
	,	#UniqueServices.[10566]
	,	dbo.DivideNumeric(#Milestones.[10555], #Milestones.[10550]) AS '10556'
	,	#Sales.[10305] + #Sales.[10306] + #Sales.[10310] + #Sales.[10315] + #Sales.[10320] + #Sales.[10325] + #Sales.[10552] + #Sales.[10891] + #Sales.[10321] AS '10233'
	,	#Sales.[10305] + #Sales.[10306] + #Sales.[10310] + #Sales.[10315] + #Sales.[10325] AS '10237'
	,	#Sales.[10305] + #Sales.[10306]+ #Sales.[10310] + #Sales.[10315] + #Sales.[10320] + #Sales.[10321] + #Sales.[10891] AS '10234'
	,	dbo.DivideNumeric((#Milestones.[10440] + #Milestones.[10435]), (#Sales.[10205] + #Sales.[10206] + #Sales.[10210] + #Sales.[10215])) AS '10485'
	,	#Milestones.[10520] + #Milestones.[10521] AS '10522'
	,	#Milestones.[10524]
	,	#Milestones.[10523] + #Milestones.[10524] AS '10525'
	,	#UniqueRetailClients.[10557] AS '10557'
	,	dbo.DivideNumeric(#Milestones.[10555], #UniqueRetailClients.[10557]) AS '10558'
	,	#Milestones.[10570]
	,	#Milestones.[10575]
	,	dbo.[DivideNumeric](#Milestones.[10575], #Milestones.[10570]) AS '10576'
	,	#Milestones.[10580]
	,	#PCP.[10860]
	,	#PCP.[10861]
	,	#PCP.[10865]
	,	#PCP.[10870]
	,	#PCP.[10880]
	,	#PCP.[10881]
	,	#PCP.[10885]
	,	#PCP.[10890]
	,	( 1 - dbo.DivideNumeric(#NBCancels.[10915], (#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10220] + #Sales.[10205]  + #Sales.[10206] + #Sales.[10901])) ) AS '10902'
	,	( 1 - dbo.DivideNumeric(#NBCancels.[10916], #Sales.[10215]) ) AS '10903'
	,	( 1 - dbo.DivideNumeric(#NBCancels.[10917], #Sales.[10206]) ) AS '10904'
	INTO #Final
	FROM #Centers
		LEFT OUTER JOIN #Sales
			ON #Centers.center = #Sales.center
			AND #Centers.[date] = #Sales.[date]
		LEFT OUTER JOIN #Wigs
			ON #Wigs.Center = #Centers.Center
			AND #Wigs.[date] = #Centers.[Date]
		LEFT OUTER JOIN #NBCancels
			ON #NBCancels.Center = #Centers.Center
			AND #NBCancels.[date] = #Centers.[Date]
		LEFT OUTER JOIN #PCP
			ON #Centers.center = #PCP.center
			AND #Centers.[date] = #PCP.[date]
		LEFT OUTER JOIN #Milestones
			ON #Centers.center = #Milestones.center
			AND #Centers.[date] = #Milestones.[date]
		LEFT OUTER JOIN #FactLead
			ON #Centers.center = #FactLead.center
			AND #Centers.[date] = #FactLead.[date]
		LEFT OUTER JOIN #FactActivity
			ON #Centers.center = #FactActivity.center
			AND #Centers.[date] = #FactActivity.[date]
		LEFT OUTER JOIN #InHouse
			ON #Centers.center = #InHouse.center
			AND #Centers.[date] = #InHouse.[date]
		LEFT OUTER JOIN #Hours
			ON #Centers.center = #Hours.center
			AND #Centers.[date] = #Hours.[date]
		LEFT OUTER JOIN #Orders
			ON #Centers.center = #Orders.center
			AND #Centers.[date] = #Orders.[date]
		LEFT OUTER JOIN #OrdersShipped
			ON #Centers.center = #OrdersShipped.center
			AND #Centers.[date] = #OrdersShipped.[date]
		LEFT OUTER JOIN #OrdersApplied
			ON #Centers.center = #OrdersApplied.center
			AND #Centers.[date] = #OrdersApplied.[date]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON #Centers.center = c.CenterNumber
		LEFT OUTER JOIN #PayPeriods vwPP
			ON YEAR(#Centers.[date]) = vwPP.[Year]
			AND MONTH(#Centers.[date]) = vwPP.[Month]
		LEFT OUTER JOIN #UniqueServices
			ON #Centers.center = #UniqueServices.center
			AND #Centers.[date] = #UniqueServices.[date]
		LEFT OUTER JOIN #UniqueRetailClients
			ON #Centers.center = #UniqueRetailClients.center
			AND #Centers.[date] = #UniqueRetailClients.[date]
	ORDER BY #Centers.center
	,	#Centers.[date]


	/*
		Unpivot query results to get in desired format
	*/
	SELECT [Center]
	,	[Date]
	,	[Account]
	,	[Flash]
	INTO #ForInsert
	FROM (
		SELECT [Center]
		,	[Date]
		,	CONVERT(SQL_VARIANT, [10205]) AS [10205]
		,	CONVERT(SQL_VARIANT, [10206]) AS [10206]
		,	CONVERT(SQL_VARIANT, [10210]) AS [10210]
		,	CONVERT(SQL_VARIANT, [10215]) AS [10215]
		,	CONVERT(SQL_VARIANT, [10220]) AS [10220]
		,	CONVERT(SQL_VARIANT, [10221]) AS [10221]
		,	CONVERT(SQL_VARIANT, [10235]) AS [10235]
		,	CONVERT(SQL_VARIANT, [10225]) AS [10225]
		,	CONVERT(SQL_VARIANT, [10240]) AS [10240]
		,	CONVERT(SQL_VARIANT, [10241]) AS [10241]
		,	CONVERT(SQL_VARIANT, [10242]) AS [10242]
		,	CONVERT(SQL_VARIANT, [10440]) AS [10440]
		,	CONVERT(SQL_VARIANT, [10520]) AS [10520]
		,	CONVERT(SQL_VARIANT, [10521]) AS [10521]
		,	CONVERT(SQL_VARIANT, [10410]) AS [10410]
		,	CONVERT(SQL_VARIANT, [10400]) AS [10400]
		,	CONVERT(SQL_VARIANT, [10401]) AS [10401]
		,	CONVERT(SQL_VARIANT, [10405]) AS [10405]
		,	CONVERT(SQL_VARIANT, [10515]) AS [10515]
		,	CONVERT(SQL_VARIANT, [10510]) AS [10510]
		,	CONVERT(SQL_VARIANT, [10505]) AS [10505]
		,	CONVERT(SQL_VARIANT, [10155]) AS [10155]
		,	CONVERT(SQL_VARIANT, [10100]) AS [10100]
		,	CONVERT(SQL_VARIANT, [10120]) AS [10120]
		,	CONVERT(SQL_VARIANT, [10125]) AS [10125]
		,	CONVERT(SQL_VARIANT, [10105]) AS [10105]
		,	CONVERT(SQL_VARIANT, [10110]) AS [10110]
		,	CONVERT(SQL_VARIANT, [10115]) AS [10115]
		,	CONVERT(SQL_VARIANT, [10430]) AS [10430]
		,	CONVERT(SQL_VARIANT, [10431]) AS [10431]
		,	CONVERT(SQL_VARIANT, [10432]) AS [10432]
		,	CONVERT(SQL_VARIANT, [10433]) AS [10433]
		,	CONVERT(SQL_VARIANT, [10435]) AS [10435]
		,	CONVERT(SQL_VARIANT, [10730]) AS [10730]
		,	CONVERT(SQL_VARIANT, [10725]) AS [10725]
		,	CONVERT(SQL_VARIANT, [10745]) AS [10745]
		,	CONVERT(SQL_VARIANT, [10735]) AS [10735]
		,	CONVERT(SQL_VARIANT, [10740]) AS [10740]
		,	CONVERT(SQL_VARIANT, [10610]) AS [10610]
		,	CONVERT(SQL_VARIANT, [10604]) AS [10604]
		,	CONVERT(SQL_VARIANT, [10605]) AS [10605]
		,	CONVERT(SQL_VARIANT, [10200]) AS [10200]
		,	CONVERT(SQL_VARIANT, [10130]) AS [10130]
		,	CONVERT(SQL_VARIANT, [10600]) AS [10600]
		,	CONVERT(SQL_VARIANT, [10300]) AS [10300]
		,	CONVERT(SQL_VARIANT, [10285]) AS [10285]
		,	CONVERT(SQL_VARIANT, [10280]) AS [10280]
		,	CONVERT(SQL_VARIANT, [10295]) AS [10295]
		,	CONVERT(SQL_VARIANT, [10290]) AS [10290]
		,	CONVERT(SQL_VARIANT, [10275]) AS [10275]
		,	CONVERT(SQL_VARIANT, [10175]) AS [10175]
		,	CONVERT(SQL_VARIANT, [10170]) AS [10170]
		,	CONVERT(SQL_VARIANT, [10185]) AS [10185]
		,	CONVERT(SQL_VARIANT, [10180]) AS [10180]
		,	CONVERT(SQL_VARIANT, [10165]) AS [10165]
		,	CONVERT(SQL_VARIANT, [10230]) AS [10230]
		,	CONVERT(SQL_VARIANT, [10445]) AS [10445]
		,	CONVERT(SQL_VARIANT, [10460]) AS [10460]
		,	CONVERT(SQL_VARIANT, [10475]) AS [10475]
		,	CONVERT(SQL_VARIANT, [10455]) AS [10455]
		,	CONVERT(SQL_VARIANT, [10470]) AS [10470]
		,	CONVERT(SQL_VARIANT, [10450]) AS [10450]
		,	CONVERT(SQL_VARIANT, [10465]) AS [10465]
		,	CONVERT(SQL_VARIANT, [10480]) AS [10480]
		,	CONVERT(SQL_VARIANT, [10160]) AS [10160]
		,	CONVERT(SQL_VARIANT, [10135]) AS [10135]
		,	CONVERT(SQL_VARIANT, [10140]) AS [10140]
		,	CONVERT(SQL_VARIANT, [10145]) AS [10145]
		,	CONVERT(SQL_VARIANT, [10150]) AS [10150]
		,	CONVERT(SQL_VARIANT, [10415]) AS [10415]
		,	CONVERT(SQL_VARIANT, [10490]) AS [10490]
		,	CONVERT(SQL_VARIANT, [10425]) AS [10425]
		,	CONVERT(SQL_VARIANT, [10500]) AS [10500]
		,	CONVERT(SQL_VARIANT, [10420]) AS [10420]
		,	CONVERT(SQL_VARIANT, [10421]) AS [10421]
		,	CONVERT(SQL_VARIANT, [10495]) AS [10495]
		,	CONVERT(SQL_VARIANT, [10700]) AS [10700]
		,	CONVERT(SQL_VARIANT, [10705]) AS [10705]
		,	CONVERT(SQL_VARIANT, [10710]) AS [10710]
		,	CONVERT(SQL_VARIANT, [10715]) AS [10715]
		,	CONVERT(SQL_VARIANT, [10720]) AS [10720]
		,	CONVERT(SQL_VARIANT, [10190]) AS [10190]
		,	CONVERT(SQL_VARIANT, [10191]) AS [10191]
		,	CONVERT(SQL_VARIANT, [10231]) AS [10231]
		,	CONVERT(SQL_VARIANT, [10236]) AS [10236]
		,	CONVERT(SQL_VARIANT, [10232]) AS [10232]
		,	CONVERT(SQL_VARIANT, [10146]) AS [10146]
		,	CONVERT(SQL_VARIANT, [10305]) AS [10305]
		,	CONVERT(SQL_VARIANT, [10306]) AS [10306]
		,	CONVERT(SQL_VARIANT, [10310]) AS [10310]
		,	CONVERT(SQL_VARIANT, [10315]) AS [10315]
		,	CONVERT(SQL_VARIANT, [10320]) AS [10320]
		,	CONVERT(SQL_VARIANT, [10321]) AS [10321]
		,	CONVERT(SQL_VARIANT, [10325]) AS [10325]
		,	CONVERT(SQL_VARIANT, [10525]) AS [10525]
		,	CONVERT(SQL_VARIANT, [10530]) AS [10530]
		,	CONVERT(SQL_VARIANT, [10531]) AS [10531]
		,	CONVERT(SQL_VARIANT, [10532]) AS [10532]
		,	CONVERT(SQL_VARIANT, [10535]) AS [10535]
		,	CONVERT(SQL_VARIANT, [10536]) AS [10536]
		,	CONVERT(SQL_VARIANT, [10540]) AS [10540]
		,	CONVERT(SQL_VARIANT, [10552]) AS [10552]
		,	CONVERT(SQL_VARIANT, [10551]) AS [10551]
		,	CONVERT(SQL_VARIANT, [10614]) AS [10614]
		,	CONVERT(SQL_VARIANT, [10615]) AS [10615]
		,	CONVERT(SQL_VARIANT, [10620]) AS [10620]
		,	CONVERT(SQL_VARIANT, [10624]) AS [10624]
		,	CONVERT(SQL_VARIANT, [10625]) AS [10625]
		,	CONVERT(SQL_VARIANT, [10630]) AS [10630]
		,	CONVERT(SQL_VARIANT, [10326]) AS [10326]
		,	CONVERT(SQL_VARIANT, [10327]) AS [10327]
		,	CONVERT(SQL_VARIANT, [10550]) AS [10550]
		,	CONVERT(SQL_VARIANT, [10555]) AS [10555]
		,	CONVERT(SQL_VARIANT, [10328]) AS [10328]
		,	CONVERT(SQL_VARIANT, [10329]) AS [10329]
		,	CONVERT(SQL_VARIANT, [10523]) AS [10523]
		,	CONVERT(SQL_VARIANT, [10560]) AS [10560]
		,	CONVERT(SQL_VARIANT, [10561]) AS [10561]
		,	CONVERT(SQL_VARIANT, [10562]) AS [10562]
		,	CONVERT(SQL_VARIANT, [10563]) AS [10563]
		,	CONVERT(SQL_VARIANT, [10564]) AS [10564]
		,	CONVERT(SQL_VARIANT, [10565]) AS [10565]
		,	CONVERT(SQL_VARIANT, [10566]) AS [10566]
		,	CONVERT(SQL_VARIANT, [10233]) AS [10233]
		,	CONVERT(SQL_VARIANT, [10237]) AS [10237]
		,	CONVERT(SQL_VARIANT, [10234]) AS [10234]
		,	CONVERT(SQL_VARIANT, [10485]) AS [10485]
		,	CONVERT(SQL_VARIANT, [10522]) AS [10522]
		,	CONVERT(SQL_VARIANT, [10524]) AS [10524]
		,	CONVERT(SQL_VARIANT, [10541]) AS [10541]
		,	CONVERT(SQL_VARIANT, [10556]) AS [10556]
		,	CONVERT(SQL_VARIANT, [10557]) AS [10557]
		,	CONVERT(SQL_VARIANT, [10558]) AS [10558]
		,	CONVERT(SQL_VARIANT, [10570]) AS [10570]
		,	CONVERT(SQL_VARIANT, [10575]) AS [10575]
		,	CONVERT(SQL_VARIANT, [10576]) AS [10576]
		,	CONVERT(SQL_VARIANT, [10580]) AS [10580]
		,	CONVERT(SQL_VARIANT, [10860]) AS [10860]
		,	CONVERT(SQL_VARIANT, [10861]) AS [10861]
		,	CONVERT(SQL_VARIANT, [10865]) AS [10865]
		,	CONVERT(SQL_VARIANT, [10870]) AS [10870]
		,	CONVERT(SQL_VARIANT, [10880]) AS [10880]
		,	CONVERT(SQL_VARIANT, [10881]) AS [10881]
		,	CONVERT(SQL_VARIANT, [10885]) AS [10885]
		,	CONVERT(SQL_VARIANT, [10890]) AS [10890]
		,	CONVERT(SQL_VARIANT, [10901]) AS [10901]
		,	CONVERT(SQL_VARIANT, [10891]) AS [10891]
		,	CONVERT(SQL_VARIANT, [10892]) AS [10892]
		,	CONVERT(SQL_VARIANT, [10893]) AS [10893]
		,	CONVERT(SQL_VARIANT, [10894]) AS [10894]
		,	CONVERT(SQL_VARIANT, [10895]) AS [10895]
		,	CONVERT(SQL_VARIANT, [10896]) AS [10896]
		,	CONVERT(SQL_VARIANT, [10897]) AS [10897]
		,	CONVERT(SQL_VARIANT, [10898]) AS [10898]
		,	CONVERT(SQL_VARIANT, [10899]) AS [10899]
		,	CONVERT(SQL_VARIANT, [10902]) AS [10902]
		,	CONVERT(SQL_VARIANT, [10903]) AS [10903]
		,	CONVERT(SQL_VARIANT, [10904]) AS [10904]
		,	CONVERT(SQL_VARIANT, [10915]) AS [10915]
		,	CONVERT(SQL_VARIANT, [10916]) AS [10916]
		,	CONVERT(SQL_VARIANT, [10917]) AS [10917]
	   FROM #Final
	) f
	UNPIVOT (
		[Flash]
		FOR [Account] IN (
			[10205]
		,	[10206]
		,	[10210]
		,	[10215]
		,	[10220]
		,	[10221]
		,	[10235]
		,	[10225]
		,	[10240]
		,	[10241]
		,	[10242]
		,	[10440]
		,	[10520]
		,	[10521]
		,	[10410]
		,	[10400]
		,	[10401]
		,	[10405]
		,	[10515]
		,	[10510]
		,	[10505]
		,	[10155]
		,	[10100]
		,	[10120]
		,	[10125]
		,	[10105]
		,	[10110]
		,	[10115]
		,	[10430]
		,	[10431]
		,	[10432]
		,	[10433]
		,	[10435]
		,	[10730]
		,	[10725]
		,	[10745]
		,	[10735]
		,	[10740]
		,	[10610]
		,   [10604]
		,	[10605]
		,	[10200]
		,	[10130]
		,	[10600]
		,	[10300]
		,	[10285]
		,	[10280]
		,	[10295]
		,	[10290]
		,	[10275]
		,	[10175]
		,	[10170]
		,	[10185]
		,	[10180]
		,	[10165]
		,	[10230]
		,	[10445]
		,	[10460]
		,	[10475]
		,	[10455]
		,	[10470]
		,	[10450]
		,	[10465]
		,	[10480]
		,	[10160]
		,	[10135]
		,	[10140]
		,	[10145]
		,	[10150]
		,	[10415]
		,	[10490]
		,	[10425]
		,	[10500]
		,	[10420]
		,	[10421]
		,	[10495]
		,	[10700]
		,	[10705]
		,	[10710]
		,	[10715]
		,	[10720]
		,	[10190]
		,	[10191]
		,	[10231]
		,	[10236]
		,	[10232]
		,	[10146]
		,	[10305]
		,	[10306]
		,	[10310]
		,	[10315]
		,	[10320]
		,	[10321]
		,	[10325]
		,	[10525]
		,	[10530]
		,	[10531]
		,	[10532]
		,	[10535]
		,	[10536]
		,	[10540]
		,	[10552]
		,	[10551]
		,	[10614]
		,	[10615]
		,	[10620]
		,	[10624]
		,	[10625]
		,	[10630]
		,	[10326]
		,	[10327]
		,	[10550]
		,	[10555]
		,	[10328]
		,	[10329]
		,	[10523]
		,	[10560]
		,	[10561]
		,	[10562]
		,	[10563]
		,	[10564]
		,	[10565]
		,	[10566]
		,	[10233]
		,	[10237]
		,	[10234]
		,	[10485]
		,	[10522]
		,	[10524]
		,	[10541]
		,	[10556]
		,	[10557]
		,	[10558]
		,   [10570]
		,   [10575]
		,   [10576]
		,	[10580]
		,	[10860]
		,	[10861]
		,	[10865]
		,	[10870]
		,	[10880]
		,	[10881]
		,	[10885]
		,	[10890]
		,	[10901]
		,	[10891]
		,	[10892]
		,	[10893]
		,	[10894]
		,	[10895]
		,	[10896]
		,	[10897]
		,	[10898]
		,	[10899]
		,	[10902]
		,	[10903]
		,	[10904]
		,	[10915]
		,	[10916]
		,	[10917]
		)
	) AS tblPivot


	/*
		Update Accounting table with values where Center, Account, and Period already exist
	*/
	UPDATE A
	SET a.Flash = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
		,	a.FlashReporting = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
		,	a.Forecast = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
		,	a.[Timestamp] =  GETDATE()
	FROM HC_Accounting.dbo.FactAccounting A
		INNER JOIN #ForInsert
			ON a.centerID = #ForInsert.center
			AND a.[AccountID] = #ForInsert.Account
			AND a.PartitionDate = #ForInsert.[date]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount
			ON a.[AccountID] = [DimAccount].[AccountID]


	/*
		Insert new records into Accounting table where Center, Account, and Period do not exist
	*/
	INSERT INTO HC_Accounting.dbo.FactAccounting (
		CenterID
	,	DateKey
	,	PartitionDate
	,	AccountID
	,	Budget
	,	Actual
	,	Flash
	,	FlashReporting
	,	[Timestamp]
	)
	SELECT #ForInsert.[Center]
	,	DD.DateKey
	,	DD.FullDate
	,	#ForInsert.[Account]
	,	0
	,	0
	,	MIN((CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit]))
	,	MIN(((CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit]) * [DimAccount].[CalculateGrossProfit]))
	,	MAX(GETDATE())
	FROM #ForInsert
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount DimAccount
			ON #ForInsert.[Account] = [DimAccount].[AccountID]
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DD
			on #forinsert.[date] = DD.FullDate
	WHERE NOT EXISTS (
		SELECT *
		FROM HC_Accounting.dbo.FactAccounting
		WHERE [CenterID] = #ForInsert.[Center]
			AND [PartitionDate] = #ForInsert.[Date]
			AND [AccountID] = #ForInsert.[Account]
		)
	GROUP BY #ForInsert.[Center]
	,	DD.DateKey
	,	DD.FullDate
	,	#ForInsert.[Account]

END
GO
