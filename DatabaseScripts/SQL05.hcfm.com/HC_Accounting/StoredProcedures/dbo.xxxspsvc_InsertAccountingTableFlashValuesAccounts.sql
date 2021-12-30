/* CreateDate: 02/26/2013 16:13:40.733 , ModifyDate: 04/05/2013 13:54:47.270 */
GO
/***********************************************************************

PROCEDURE:	[spsvc_InsertAccountingTableFlashValuesNewAccounts]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_Accounting

RELATED APPLICATION:  Accounting table

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 5/10/10

LAST REVISION DATE: 4/23/12

------------------------------------------------------------------------
This procedure populates the Flash column in the Accounting table
from various Fact tables

	6/4/10 - MB - Added 10557, 10558
	9/20/10 - KM - WO#55625 - Changed @refreshinterval from -12 to -26
	9/23/10 - KM - WO#55625 - Changed @refreshinterval from -26 to -12
	11/10/2011 - MB - Temporarily changed refresh dates to go back to 1/1/07 to
						populate PCP numbers
	04/11/2012 - KM - Added 10431 & 10432 Gradual & Tradition Conversions
	04/23/2012 - KM - Added 10241 & 10242 Gradual & Tradition Applications
	06/14/2012 - MB - Added code to update Forecast values based on Flash values
	07/11/2012 - MB - Changed @RefreshInterval parameter per DR request
	03/05/2013 - KM - Modified to come from BI environment
	03/20/2013 - KM - Modified to include 281
	03/26/2013 = KM - Fixed 10557
------------------------------------------------------------------------

SAMPLE EXEC:
exec [spsvc_InsertAccountingTableFlashValuesAccounts]

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspsvc_InsertAccountingTableFlashValuesAccounts] AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON


	/*
		Declare and set the refresh interval for the query
	*/
	DECLARE @RefreshInterval INT
	DECLARE @RefreshDate DATETIME
	DECLARE @TransactionRefreshDate DATETIME
	DECLARE @TransactionEndDate DATETIME

	SET @RefreshInterval = -1
	--select @RefreshDate = DATEADD(dd, -1575, GETDATE())
	SET @RefreshDate = DATEADD(mm, @RefreshInterval, GETDATE())
	SET @TransactionRefreshDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	SET @TransactionEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(getdate()+400)) + '/1/' + CONVERT(VARCHAR, YEAR(getdate()+400)))



	/*
		Populate temporary table with all the centers and dates applicable to the report
	*/
	SELECT [DimCenter].[CenterSSID] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))) AS 'Date'
	INTO #Centers
	FROM HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate, HC_BI_ENT_DDS.[bi_ent_dds].[DimCenter] DimCenter
	WHERE [DimDate].[FullDate] between @TransactionRefreshDate and @TransactionEndDate
		AND DimCenter.active='Y'
		AND [DimCenter].[CenterSSID] in (292,281) --LIKE '[278]%'
	GROUP BY [DimCenter].[CenterSSID]
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate])))
	ORDER BY [DimCenter].[CenterSSID]
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
		DimCenter.CenterSSID as 'Center'
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
	WHERE DimCenter.CenterSSID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY FactActivityResults.CenterKey,DimCenter.CenterSSID
	,	CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101)
	ORDER BY FactActivityResults.CenterKey,DimCenter.CenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))
	/*
		Get InHouse numbers
		(They were not being calculated in either of the Fact tables
		------------------------------------------------------------
		10115 = InHouse
	*/
	SELECT
		DimCenter.CenterSSID as 'Center'
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
	WHERE DimCenter.CenterSSID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= @TransactionRefreshDate
		AND DimActivity.ActioncodeSSID IN ('INHOUSE')
	GROUP BY FactActivity.CenterKey, DimCenter.CenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DimDate.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DimDate.[FullDate]))), 101))
	ORDER BY FactActivity.CenterKey, DimCenter.CenterSSID
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
	SELECT DimCenter.[CenterSSID] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairSystemAlocationDate)) + '/1/' + CONVERT(VARCHAR, YEAR(HairSystemAlocationDate))), 101)) AS 'date'
	,	COUNT(FactHairSystemOrder.[HairSystemOrderNumber]) AS '10610'
	,	SUM(FactHairSystemOrder.[CostActual]) AS '10605'
	INTO #Orders
	FROM HC_BI_CMS_DDS.bi_cms_dds.[vwFactHairSystemOrder] FactHairSystemOrder
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactHairSystemOrder.ClientHomeCenterKey = DimCenter.CenterKey
	WHERE ISNULL(HairSystemAlocationDate,HairSystemOrderDate) >= @TransactionRefreshDate
	GROUP BY DimCenter.[CenterSSID]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairSystemAlocationDate)) + '/1/' + CONVERT(VARCHAR, YEAR(HairSystemAlocationDate))), 101))

	/*
		Get Production Orders shipped numbers
		-------------------------------------
		10615 = Hair Systems Shipped
		10620 = Hair System Shipped Cost
	*/
	SELECT DimCenter.[CenterSSID] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemShippedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemShippedDate] ))), 101)) AS 'date'
	,	COUNT([HairSystemOrderNumber]) AS '10615'
	,	SUM([CostActual]) AS '10620'
	INTO #OrdersShipped
	FROM HC_BI_CMS_DDS.bi_cms_dds.[vwFactHairSystemOrder] FactHairSystemOrder
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate
			ON FactHairSystemOrder.[HairSystemOrderDateKey] = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactHairSystemOrder.ClientHomeCenterKey = DimCenter.CenterKey
	WHERE [HairSystemShippedDate] >= @TransactionRefreshDate
	GROUP BY DimCenter.[CenterSSID]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([HairSystemShippedDate] )) + '/1/' + CONVERT(VARCHAR, YEAR([HairSystemShippedDate] ))), 101))


	/*
		Get Marketing numbers
		---------------------
		10155 = Leads

	*/
	SELECT DimCenter.CenterSSID AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101)) AS 'date'
	,	SUM(FactLead.Leads) AS '10155'
	INTO #FactLead
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FactLead
		INNER JOIN HC_BI_ENT_DDS.[bief_dds].[DimDate] DimDate
			ON FactLead.LeadCreationDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DimCenter
			on FactLead.CenterKey = DimCenter.CenterKey
	WHERE DimCenter.CenterSSID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY DimCenter.CenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))
	ORDER BY DimCenter.CenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH([DimDate].[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR([DimDate].[FullDate]))), 101))



	/*
		Get Sales numbers
		-----------------
		10305 = Sales NB1
		10315 = Sales Extreme Hair Program
		10310 = Sales NB1 Gradual
		10540 = Sales NB2
		10530 = Sales - Bronze (Should be PCP)
		10320 = Surgery Revenue
		10325 = PostEXT Revenue
		10541 = NB2 + PCP
		3080 = Service
		3090 = Sales - Retail Products
		10205 = NB - Traditional
		10210 = NB - Gradual
		10215 = NB - Extreme
		10220 = NB - Surgery
		10235 = NB - Gross
		10225 = NB - PostEXT
		10240 = NB - Applications
		10241 = NB - Applications (Trad)
		10242 = NB - Applications (Grad)

	*/
	SELECT DimCenter.CenterSSID as 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DimDate.[fulldate])-1 ), DimDate.[fulldate]), 101)) AS 'date'
	,	SUM(FactSalesConect.[NB_Trad$]) AS '10305'
	,	SUM(FactSalesConect.[NB_Ext$]) AS '10315'
	,	SUM(FactSalesConect.[NB_Grad$]) AS '10310'
	,	SUM(FactSalesConect.[PCP_NB2$] - FactSalesConect.[PCP_PCP$]) AS '10540'
	,	SUM(FactSalesConect.[PCP_NB2$]) AS '10530'
	,	SUM(FactSalesConect.[S1_NetSales$] + FactSalesConect.[SA_NetSales$]) AS '10320'
	,	SUM(FactSalesConect.[S_PostEXT$]) AS '10325'
	,	SUM(FactSalesConect.[PCP_NB2$]) AS '10541'
	,	SUM(FactSalesConect.[Service$]) AS '3080'
	,	SUM(FactSalesConect.[Retail$]) AS '3090'
	,	SUM(FactSalesConect.NB_Trad#) AS '10205'
	,	SUM(FactSalesConect.NB_Grad#) AS '10210'
	,	SUM(FactSalesConect.NB_Ext#) AS '10215'
	,	SUM(FactSalesConect.S1_NetSales# + SA_NetSales#) AS '10220'
	,	SUM(FactSalesConect.NB_Trad# + FactSalesConect.NB_Grad# + FactSalesConect.NB_Ext#
			+ FactSalesConect.S1_NetSales# +  FactSalesConect.SA_NetSales# + FactSalesConect.[S_PostExt#]) AS '10235'
	,	SUM(FactSalesConect.[S_PostExt#]) AS '10225'
	,	SUM(FactSalesConect.NB_Apps#) AS '10240'
	,	SUM(CASE WHEN FactSalesConect.MembershipKey not in (56,57,58,98,99,100,101,108,109)
			then FactSalesConect.NB_Apps# else 0 end ) as '10241'
	,	SUM(CASE WHEN FactSalesConect.MembershipKey in (56,57,58,98,99,100,101,108,109)
			then FactSalesConect.NB_Apps# else 0 end ) as '10242'


	INTO #Sales
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwFactSalesConect FactSalesConect
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate
				ON FactSalesConect.OrderDateKey = DimDate.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DimCenter
			on FactSalesConect.CenterKey = DimCenter.CenterKey
		--LEFT OUTER JOIN #SurgSales SS
		--	ON CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DimDate.[fulldate])-1 ), DimDate.[fulldate]), 101)) = SS.date
		--		and DimCenter.CenterSSID = SS.CenterSSID
	WHERE DimCenter.CenterSSID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY DimCenter.CenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DimDate.[Fulldate])-1 ), DimDate.[Fulldate]), 101))
	order by DimCenter.centerssid

		/*
		Get PCP numbers
		---------------
		10410 = PCP - Active + EXT
		10400 = PCP - Active
		10405 = PCP - Active EXT
	*/
	--Get current month numbers
	SELECT FactPCP.CenterID AS 'Center'
	,	DimDate.[FullDate] as 'Date'
	,	SUM(FactPCP.PCP) AS '10410'
	,	SUM(FactPCP.PCP) - SUM(FactPCP.Extreme) AS '10400'
	,	SUM(FactPCP.Extreme) AS '10405'
	INTO #PCP_Current
	FROM HC_Accounting.dbo.FactPCP FactPCP
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate
			ON FactPCP.Datekey = DimDate.Datekey
	WHERE FactPCP.CenterID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate)))
	GROUP BY FactPCP.CenterID
	,	DimDate.[FullDate]

	--Get prior month numbers
	SELECT FactPCP.CenterID AS 'Center'
	,	DimDate.[FullDate] as 'Date'
	,	DATEADD(MONTH, 1, DimDate.[FullDate]) AS 'ActualMonth'
	,	SUM(FactPCP.PCP) AS '10410_PriorMonth'
	,	SUM(FactPCP.PCP) - SUM(FactPCP.Extreme) AS '10400_PriorMonth'
	,	SUM(FactPCP.Extreme) AS '10405_PriorMonth'
	INTO #PCP_Prior
	FROM HC_Accounting.dbo.FactPCP FactPCP
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DimDate
			ON FactPCP.DateKey = DimDate.DateKey
	WHERE FactPCP.CenterID in (292,281) --LIKE '[278]%'
		AND DimDate.[FullDate] >= DATEADD(MONTH, -1, CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@RefreshDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@RefreshDate))))
	GROUP BY FactPCP.CenterID
	,	DimDate.[FullDate]

	--Consolidate PCP numbers
	SELECT #PCP_Current.Center
	,	#PCP_Current.[Date]
	,	#PCP_Current.[10410]
	,	#PCP_Current.[10400]
	,	#PCP_Current.[10405]
	,	#PCP_Prior.[10410_PriorMonth]
	,	#PCP_Prior.[10400_PriorMonth]
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
		10435 = PCP - EXTMEM Conversion #
		10440 = PCP - BIO & EXTMEM Conversion #
		10505 = PCP - Cancels #
		10510 = PCP - Downgrades #
		10515 = PCP - Upgrades #
		10535 = PCP - EXTMEM Sales $
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
	*/
	SELECT C.[CenterSSID] AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.[FullDate])) + '/1/' + CONVERT(VARCHAR, YEAR(DD.[FullDate]))), 101)) AS 'date'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND Mem.[MembershipDescriptionShort] NOT IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10430'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND Mem.[MembershipDescriptionShort] NOT IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			AND Mem.[MembershipDescription] NOT LIKE ('GRAD%')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10431'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND Mem.[MembershipDescriptionShort] NOT IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			AND Mem.[MembershipDescriptionShort] IN ('GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10432'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (1075)
			AND Mem.[MembershipDescriptionShort] IN ('EXTENH6','EXT6','EXTENH9','EXT12','EXTENH12','POSTEXT','POSTEL')
			THEN [FactSalesConect].[SF-Quantity] ELSE 0 END) AS '10435'
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
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (2020)
			AND Mem.[MembershipDescriptionShort] IN ('EXTMEM','EXTMEMSOL')
			THEN [FactSalesConect].[SF-ExtendedPrice] ELSE 0 END) AS '10535'
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12')
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
	,	SUM(CASE WHEN SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5020, 5040)
			AND Mem.[MembershipDescriptionShort] IN ('TRADITION', 'GRDSV','GRAD','GRDSV12','GRDSVSOL','GRADSOL6','GRDSVSOL','GRADSOL12','GRDSVSOL12')
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
	WHERE C.[CenterSSID] in (292,281) --LIKE '[278]%'
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.[SalesCodeDepartmentSSID] IN (1070, 1080, 1099, 1075, 2020, 5010, 5030, 5035, 5020, 5040, 3010, 3020, 3030, 3040, 3050, 3060, 3070, 3080)
		AND SC.[SalesCodeDescriptionShort] NOT IN ('TXFR', 'NB1TXFR','NB1REM','TXFRIN','TXFROUT')
		AND MEM.BusinessSegmentSSID <> 3
		--AND [Transaction].[bVoided] = 0 -- not necessary as they are not included.
	GROUP BY C.[CenterSSID]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.[Fulldate])) + '/1/' + CONVERT(VARCHAR, YEAR(DD.[Fulldate]))), 101))


	SELECT [Center]
	,	[Date]
	,	SUM([10430]) AS '10430'
	,	SUM([10431]) AS '10431'
	,	SUM([10432]) AS '10432'
	,	SUM([10435]) AS '10435'
	,	SUM([10440]) AS '10440'
	,	SUM([10505]) AS '10505'
	,	SUM([10510]) AS '10510'
	,	SUM([10515]) AS '10515'
	,	SUM([10535]) AS '10535'
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


	SELECT C.CenterSSID as 'Center'
	,	Client.[clientnumber_temp] as 'Client_no'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, DSO.centerSSID))) + '/1/' + CONVERT(VARCHAR, YEAR(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, DSO.CenterSSID)))), 101)) AS 'date'
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
	WHERE C.[CenterSSID] in (292,281) --LIKE '[278]%'
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.[SalesCodeDepartmentSSID] IN (5010, 5030, 5035, 5020, 5040)
		AND SC.[SalesCodeDescriptionShort] NOT IN ('TXFR', 'NB1TXFR','NB1REM','TXFRIN','TXFROUT')
		--AND [Transaction].[bVoided] = 0 -- not necessary as they are not included.
	GROUP BY C.[CenterSSID]
	,	Client.[clientnumber_temp]
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(HairclubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, DSO.centerSSID))) + '/1/' + CONVERT(VARCHAR, YEAR(HairClubCMS.[dbo].[fn_GetSTDDateFromUTC](DSO.orderdate, DSO.centerSSID)))), 101))


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
	SELECT C.CenterSSID AS 'Center'
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
	WHERE C.CenterSSID in (292,281) --LIKE '[278]%'
		AND DD.[Fulldate] >= @TransactionRefreshDate
		AND SC.SalesCodeDepartmentSSID like ('30%')
		--AND [Transaction].[bVoided] = 0 -- not necessary as they are not included.
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
	*/
	SELECT #Centers.center
	,	#Centers.[date]
	,	#Sales.[10205]
	,	#Sales.[10210]
	,	#Sales.[10215]
	,	#Sales.[10220]
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
	,	#Milestones.[10435]
	,	#Hours.[10730]
	,	#Hours.[10725]
	,	#Hours.[10745]
	,	#Hours.[10735]
	,	#Hours.[10740]
	,	#Orders.[10610]
	,	#Orders.[10605]
	,	dbo.DivideNumeric(#Sales.[10240], (#Sales.[10205] + #Sales.[10210])) AS '10200'
	,	dbo.DivideNumeric(#FactActivity.[10100], #FactLead.[10155]) AS '10130'
	,	dbo.DivideNumeric(#Orders.[10605], #Orders.[10610]) AS '10600'
	,	dbo.DivideNumeric((#Sales.[10305] + #Sales.[10315] + #Sales.[10310]), (#Sales.[10205] + #Sales.[10210] + #Sales.[10215])) AS '10300'
	,	dbo.DivideNumeric(#Sales.[10315], #Sales.[10215]) AS '10285'
	,	dbo.DivideNumeric(#Sales.[10310], #Sales.[10210]) AS '10280'
	,	dbo.DivideNumeric(#Sales.[10325], #Sales.[10225]) AS '10295'
	,	dbo.DivideNumeric(#Sales.[10320], #Sales.[10220]) AS '10290'
	,	dbo.DivideNumeric(#Sales.[10305], #Sales.[10205]) AS '10275'
	,	dbo.DivideNumeric(#Sales.[10215], #FactActivity.[10110]) AS '10175'
	,	dbo.DivideNumeric(#Sales.[10210], #FactActivity.[10110]) AS '10170'
	,	dbo.DivideNumeric(#Sales.[10225], #FactActivity.[10110]) AS '10185'
	,	dbo.DivideNumeric(#Sales.[10220], #FactActivity.[10110]) AS '10180'
	,	dbo.DivideNumeric(#Sales.[10205], #FactActivity.[10110]) AS '10165'
	,	#Sales.[10205] + #Sales.[10210] AS '10230'
	,	dbo.DivideNumeric(#Sales.[10541], #PCP.[10400]) AS '10445'
	,	dbo.DivideNumeric(#Milestones.[10440], (#Sales.[10205] + #Sales.[10210])) AS '10475'
	,	dbo.DivideNumeric((#Sales.[10541] + #Milestones.[10535]), #PCP.[10410]) AS '10455'
	,	#Milestones.[10430] - (#PCP.[10400_PriorMonth] + #Milestones.[10430] - #PCP.[10400]) AS '10460'
	,	#Milestones.[10435] - (#PCP.[10405_PriorMonth] + #Milestones.[10435] - #PCP.[10405]) AS '10465'
	,	#Milestones.[10440] - (#PCP.[10410_PriorMonth] + #Milestones.[10440] - #PCP.[10410]) AS '10470'
	,	dbo.DivideNumeric(#Milestones.[10535], #PCP.[10405]) AS '10450'
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
	,	(dbo.DivideNumeric((#PCP.[10405_PriorMonth]  + #Milestones.[10435] - #PCP.[10405]), ((#PCP.[10405_PriorMonth] + #PCP.[10405]))/2)) * 12 AS '10495'
	,	((#Hours.[10725] / vwPP.PayPeriodCt) * 26) / 2080 AS '10700'
	,	((#Hours.[10730] / vwPP.PayPeriodCt) * 26) / 2080 AS '10705'
	,	((#Hours.[10735] / vwPP.PayPeriodCt) * 26) / 2080 AS '10710'
	,	((#Hours.[10740] / vwPP.PayPeriodCt) * 26) / 2080 AS '10715'
	,	((#Hours.[10745] / vwPP.PayPeriodCt) * 26) / 2080 AS '10720'
	,	dbo.[DivideNumeric]((#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10220] + #Sales.[10205]), #FactActivity.[10110]) AS '10190'
	,	dbo.[DivideNumeric]((#Sales.[10215] + #Sales.[10210] + #Sales.[10220] + #Sales.[10205]), #FactActivity.[10110]) AS '10191'
	,	#Sales.[10215] + #Sales.[10210] + #Sales.[10225] + #Sales.[10220] + #Sales.[10205] AS '10231'
	,	#Sales.[10215] + #Sales.[10210] + #Sales.[10220] + #Sales.[10205] AS '10232'
	,	dbo.[DivideNumeric](#FactActivity.[10110], #FactActivity.[10100]) AS '10146'
	,	#Sales.[10305]
	,	#Sales.[10310]
	,	#Sales.[10315]
	,	#Sales.[10320]
	,	#Sales.[10325]
	,	#Sales.[10541] + #Milestones.[10535] AS '10541'
	,	#Sales.[10530]
	,	#Milestones.[10535]
	,	#Sales.[10540]
	,	#OrdersShipped.[10615]
	,	#OrdersShipped.[10620]
	,	#Milestones.[10326]
	,	#Milestones.[10327]
	,	#Milestones.[10550]
	,	#Milestones.[10555]
	,	#Milestones.[10328]
	,	#Milestones.[10329]
	,	#Milestones.[10523]
	,	#UniqueServices.[10561] + #UniqueServices.[10562] + #UniqueServices.[10563]
		+ #UniqueServices.[10564] + #UniqueServices.[10565] + #UniqueServices.[10566] AS '10560'
	,	#UniqueServices.[10561]
	,	#UniqueServices.[10562]
	,	#UniqueServices.[10563]
	,	#UniqueServices.[10564]
	,	#UniqueServices.[10565]
	,	#UniqueServices.[10566]
	,	dbo.DivideNumeric(#Milestones.[10555], #Milestones.[10550]) AS '10556'
	,	#Sales.[10305] + #Sales.[10310] + #Sales.[10315] + #Sales.[10320] + #Sales.[10325] AS '10233'
	,	#Sales.[10305] + #Sales.[10310] + #Sales.[10315] + #Sales.[10320] AS '10234'
	,	dbo.DivideNumeric((#Milestones.[10440] + #Milestones.[10435]), (#Sales.[10205] + #Sales.[10210] + #Sales.[10215])) AS '10485'
	,	#Milestones.[10520] + #Milestones.[10521] AS '10522'
	,	#Milestones.[10524]
	,	#Milestones.[10523] + #Milestones.[10524] AS '10525'
	,	#UniqueRetailClients.[10557] AS '10557'
	,	dbo.DivideNumeric(#Milestones.[10555], #UniqueRetailClients.[10557]) AS '10558'
	INTO #Final
	FROM #Centers
		LEFT OUTER JOIN #Sales
			ON #Centers.center = #Sales.center
			AND #Centers.[date] = #Sales.[date]
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
		INNER JOIN [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter] c
			ON #Centers.center = c.center_num
		LEFT OUTER JOIN [HCSQL2\SQL2005].[BOSOperations].dbo.vw_paydatepayperiods vwPP
			ON c.PayGroup = vwPP.PayGroup
			AND YEAR(#Centers.[date]) = vwPP.[Year]
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
		,	CONVERT(SQL_VARIANT, [10210]) AS [10210]
		,	CONVERT(SQL_VARIANT, [10215]) AS [10215]
		,	CONVERT(SQL_VARIANT, [10220]) AS [10220]
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
		,	CONVERT(SQL_VARIANT, [10435]) AS [10435]
		,	CONVERT(SQL_VARIANT, [10730]) AS [10730]
		,	CONVERT(SQL_VARIANT, [10725]) AS [10725]
		,	CONVERT(SQL_VARIANT, [10745]) AS [10745]
		,	CONVERT(SQL_VARIANT, [10735]) AS [10735]
		,	CONVERT(SQL_VARIANT, [10740]) AS [10740]
		,	CONVERT(SQL_VARIANT, [10610]) AS [10610]
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
		,	CONVERT(SQL_VARIANT, [10495]) AS [10495]
		,	CONVERT(SQL_VARIANT, [10700]) AS [10700]
		,	CONVERT(SQL_VARIANT, [10705]) AS [10705]
		,	CONVERT(SQL_VARIANT, [10710]) AS [10710]
		,	CONVERT(SQL_VARIANT, [10715]) AS [10715]
		,	CONVERT(SQL_VARIANT, [10720]) AS [10720]
		,	CONVERT(SQL_VARIANT, [10190]) AS [10190]
		,	CONVERT(SQL_VARIANT, [10191]) AS [10191]
		,	CONVERT(SQL_VARIANT, [10231]) AS [10231]
		,	CONVERT(SQL_VARIANT, [10232]) AS [10232]
		,	CONVERT(SQL_VARIANT, [10146]) AS [10146]
		,	CONVERT(SQL_VARIANT, [10305]) AS [10305]
		,	CONVERT(SQL_VARIANT, [10310]) AS [10310]
		,	CONVERT(SQL_VARIANT, [10315]) AS [10315]
		,	CONVERT(SQL_VARIANT, [10320]) AS [10320]
		,	CONVERT(SQL_VARIANT, [10325]) AS [10325]
		,	CONVERT(SQL_VARIANT, [10525]) AS [10525]
		,	CONVERT(SQL_VARIANT, [10530]) AS [10530]
		,	CONVERT(SQL_VARIANT, [10535]) AS [10535]
		,	CONVERT(SQL_VARIANT, [10540]) AS [10540]
		,	CONVERT(SQL_VARIANT, [10615]) AS [10615]
		,	CONVERT(SQL_VARIANT, [10620]) AS [10620]
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
		,	CONVERT(SQL_VARIANT, [10234]) AS [10234]
		,	CONVERT(SQL_VARIANT, [10485]) AS [10485]
		,	CONVERT(SQL_VARIANT, [10522]) AS [10522]
		,	CONVERT(SQL_VARIANT, [10524]) AS [10524]
		,	CONVERT(SQL_VARIANT, [10541]) AS [10541]
		,	CONVERT(SQL_VARIANT, [10556]) AS [10556]
		,	CONVERT(SQL_VARIANT, [10557]) AS [10557]
		,	CONVERT(SQL_VARIANT, [10558]) AS [10558]
	   FROM #Final
	) f
	UNPIVOT (
		[Flash]
		FOR [Account] IN (
			[10205]
		,	[10210]
		,	[10215]
		,	[10220]
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
		,	[10435]
		,	[10730]
		,	[10725]
		,	[10745]
		,	[10735]
		,	[10740]
		,	[10610]
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
		,	[10495]
		,	[10700]
		,	[10705]
		,	[10710]
		,	[10715]
		,	[10720]
		,	[10190]
		,	[10191]
		,	[10231]
		,	[10232]
		,	[10146]
		,	[10305]
		,	[10310]
		,	[10315]
		,	[10320]
		,	[10325]
		,	[10525]
		,	[10530]
		,	[10535]
		,	[10540]
		,	[10615]
		,	[10620]
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
		,	[10234]
		,	[10485]
		,	[10522]
		,	[10524]
		,	[10541]
		,	[10556]
		,	[10557]
		,	[10558]
		)
	) AS tblPivot



	/*
		Update Accounting table with values where Center, Account, and Period already exist
	*/
	--UPDATE a
	--SET a.Flash = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
	----,	a.FlashReporting = ((CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit]) * [DimAccount].[CalculateGrossProfit])
	----,	a.Forecast = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
	--,	a.[Timestamp] =  GETDATE()

	UPDATE A
	SET a.Flash = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit]),
		a.FlashReporting = (CONVERT(REAL, #ForInsert.[Flash]) * [DimAccount].[CalculateGrossProfit])
	--select #ForInsert.[Flash],a.Flash,*
	FROM HC_BI_ENT_DDS.bi_ent_dds.FactAccounting A
		INNER JOIN #ForInsert
			ON a.centerID = #ForInsert.center
			AND a.[AccountID] = #ForInsert.Account
			AND a.PartitionDate = #ForInsert.[date]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAccount
			ON a.[AccountID] = [DimAccount].[AccountID]
	--/*
	--	Add new account 10356 - PCP - BIO & EXTMEM Sales $
	--*/
	SELECT CenterID as 'Center'
	,	FactAccounting.[Partitiondate] as 'Period'
	,	10536 AS 'Account'
	,	CONVERT(REAL, SUM(ISNULL(Budget, 0))) AS 'Budget'
	,	CONVERT(REAL, SUM(ISNULL(Forecast, 0))) AS 'Forecast'
	,	CONVERT(REAL, SUM(ISNULL(Flash, 0))) AS 'Flash'
	,	CONVERT(REAL, SUM(ISNULL(FlashReporting, 0))) AS 'FlashReporting'
	INTO #NewAccountData
	FROM HC_BI_ENT_DDS.bi_ent_dds.FactAccounting FactAccounting
	WHERE AccountID IN (10530, 10535)
		AND FactAccounting.[Partitiondate] >= @RefreshDate
	GROUP BY CenterID
	,	FactAccounting.[Partitiondate]


	UPDATE A
	SET A.Budget = NAD.Budget
	,	A.Forecast = NAD.Forecast
	,	A.Flash = NAD.Flash
	,	A.FlashReporting = NAD.FlashReporting
	--select *
	FROM HC_BI_ENT_DDS.bi_ent_dds.FactAccounting A
		INNER JOIN #NewAccountData NAD
			ON A.CenterID = NAD.Center
			AND A.AccountID = NAD.Account
			AND A.PartitionDate = NAD.Period

	--select * from #forinsert order by date, account

end
GO
