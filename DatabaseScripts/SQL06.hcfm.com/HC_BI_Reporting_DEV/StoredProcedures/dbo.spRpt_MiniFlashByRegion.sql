/*===============================================================================================
-- Procedure Name:			spRpt_MiniFlashByRegion
-- Procedure Description:
--
-- Created By:				Marlon Burrell
-- Date Created:			05/15/2013
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- ----------------------------------------------------------------------------------------------
-- Notes:
	05/28/2013 - MB - Filtered out Transfer IN/OUT
	05/29/2013 - MB - Changed divide function so we can go out more decimal places on report
	07/01/2013 - MB - Changed EXT Conv % to Conversions/Sales instead of Conversions/Expirations
	02/13/2014 - MB - Changed fiscal year to match calendar year (Exec Request)
	11/18/2014 - RH - Added Xtrands FST.NB_XTRAmt MONEY, FST.NB_XTRCnt INT
	07/13/2015 - RH - Changed SUM(FL.Leads) to COUNT(FL.Leads) to match the Rich Matrix and the cubes
	11/20/2015 - RH - Added NB_XTRConvCnt as XTRConversions and XTRConvPct (WO#120569)
	01/25/2019 - RH - (Case #7101) Removed S_SurAmt and S_SurCnt from NetNB1Revenue and NetNB1Sales
	01/29/2019 - RH - (Case #7507) Added NB_MDPAmt and NB_MDPCnt to NetNB1Revenue and NetNB1Sales
-- ----------------------------------------------------------------------------------------------
--
EXEC spRpt_MiniFlashByRegion 4
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_MiniFlashByRegion] (@RegionID INT)
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF

	DECLARE @YesterdayStart DATETIME
	,	@YesterdayEnd DATETIME
	,	@CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME
	,	@CurrentYearStart DATETIME
	,	@CurrentYearEnd DATETIME
	,	@CurrentFiscalYearStart DATETIME
	,	@CurrentFiscalYearEnd DATETIME
	,	@MinDate DATETIME
	,	@MaxDate DATETIME



	CREATE TABLE #Dates (
		DateID INT
	,	DateDesc VARCHAR(50)
	,	DateDescFiscalYear VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	,	SortOrder INT
	)

	CREATE TABLE #CentersByRegion(
		Center INT
	)


	SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, GETDATE()), 101))
	SET @YesterdayEnd = @YesterdayStart + ' 23:59'

	SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
	SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

	SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
	SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))

	SET @CurrentFiscalYearStart = (
		SELECT CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(FullDate)))
		FROM HC_BI_ENT_DDS.bief_dds.DimDate
		WHERE FullDate = CONVERT(DATETIME, CONVERT(VARCHAR, @YesterdayStart, 101))
	)
	SET @CurrentFiscalYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentFiscalYearStart))


	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (1, 'Day', 'Day', @YesterdayStart, @YesterdayEnd, 1)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (2, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentMonthStart, @YesterdayEnd, 2)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (4, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(@CurrentFiscalYearStart)), @CurrentFiscalYearStart, @YesterdayEnd, 5)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (5, 'MTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentMonthStart), DATEADD(YEAR, -1, @YesterdayEnd), 3)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (6, 'YTD', 'FY' + CONVERT(VARCHAR, YEAR(DATEADD(YEAR, -1, @CurrentFiscalYearStart))), DATEADD(YEAR, -1, @CurrentFiscalYearStart), DATEADD(YEAR, -1, @YesterdayEnd), 6)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (7, 'MTD', 'Difference', @CurrentMonthStart, @YesterdayEnd, 4)

	INSERT INTO #Dates(DateID, DateDesc, DateDescFiscalYear, StartDate, EndDate, SortOrder)
	VALUES (8, 'YTD', 'Difference', @CurrentFiscalYearStart, @YesterdayEnd, 7)


	SELECT @MinDate = MIN(StartDate)
	,	@MaxDate = MAX(EndDate)
	FROM #Dates


	UPDATE D
	SET D.DateDescFiscalYear = CASE WHEN D.DateID IN (2, 5) THEN DATENAME(MONTH, D.StartDate) ELSE 'FY' END + ' ' + CONVERT(VARCHAR, DD.FiscalYear)
	FROM #Dates D
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON D.StartDate = DD.FullDate
	WHERE D.DateID IN (2, 4, 5, 6)


	UPDATE D
	SET D.DateDescFiscalYear = 'var +(-)'
	FROM #Dates D
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON D.StartDate = DD.FullDate
	WHERE D.DateID IN (7, 8)


	/*
		Populate temporary table with all centers for the desired region
	*/
	IF @RegionID=1
		BEGIN
			INSERT INTO #CentersByRegion
			SELECT CenterSSID AS 'Center'
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			WHERE RegionSSID IN (7, 8, 9, 10, 11, 12, 13, 14)
		END
	ELSE
		BEGIN
			INSERT INTO #CentersByRegion
			SELECT CenterSSID AS 'Center'
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			WHERE RegionSSID = @RegionID
		END



	/*
		Populate temporary table with all the centers and dates applicable to the report
	*/
	SELECT DC.CenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.FullDate)) + '/1/' + CONVERT(VARCHAR, YEAR(DD.FullDate))) AS 'Period'
	INTO #Centers
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD, HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE DD.FullDate BETWEEN @MinDate AND @MaxDate
		AND DC.Active='Y'
		AND DC.CenterSSID IN (SELECT Center FROM #CentersByRegion)
	GROUP BY DC.CenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.FullDate)) + '/1/' + CONVERT(VARCHAR, YEAR(DD.FullDate)))
	ORDER BY DC.CenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DD.FullDate)) + '/1/' + CONVERT(VARCHAR, YEAR(DD.FullDate)))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	SUM(ISNULL(FST.NB_TradAmt, 0)) AS 'TraditionalRevenue'
	,	SUM(ISNULL(FST.NB_ExtAmt, 0)) AS 'EXTRevenue'
	,	SUM(ISNULL(FST.NB_GradAmt, 0)) AS 'GradualRevenue'
	,	SUM(ISNULL(FST.NB_XTRAmt, 0)) AS 'XtrandsRevenue'
	,	SUM(ISNULL(FST.PCP_NB2Amt, 0)) - SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'NB2Revenue'
	,	SUM(ISNULL(FST.PCP_PCPAmt, 0)) AS 'PCPRevenue'
	,	SUM(ISNULL(FST.PCP_NB2Amt, 0)) AS 'PCPTotalRevenue'
	,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'SurgeryRevenue'
	,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'PostEXTRevenue'
	,	SUM(ISNULL(FST.ServiceAmt, 0)) AS 'ServiceRevenue'
	,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailRevenue'
	,	SUM(ISNULL(FST.NB_TradCnt, 0)) AS 'TraditionalSales'
	,	SUM(ISNULL(FST.NB_GradCnt, 0)) AS 'GradualSales'
	,	SUM(ISNULL(FST.NB_XTRCnt, 0)) AS 'XtrandsSales'
	,	SUM(ISNULL(FST.NB_ExtCnt, 0)) AS 'EXTSales'
	,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'SurgerySales'
	,	SUM(ISNULL(FST.NB_TradCnt, 0))
			+ SUM(ISNULL(FST.NB_ExtCnt, 0))
			+ SUM(ISNULL(FST.NB_GradCnt, 0))
			--+ SUM(ISNULL(FST.S_SurCnt, 0))
			+ SUM(ISNULL(FST.S_PostExtCnt, 0))
			+ SUM(ISNULL(FST.NB_XTRCnt, 0))
			+ SUM(ISNULL(FST.NB_MDPCnt, 0))
		AS 'NetNB1Sales'
	,	SUM(ISNULL(FST.NB_TradAmt, 0))
			+ SUM(ISNULL(FST.NB_ExtAmt, 0))
			+ SUM(ISNULL(FST.NB_GradAmt, 0))
			--+ SUM(ISNULL(FST.S_SurAmt, 0))
			+ SUM(ISNULL(FST.S_PostExtAmt, 0))
			+ SUM(ISNULL(FST.NB_XTRAmt, 0))
			+ SUM(ISNULL(FST.NB_MDPAmt, 0))
		AS 'NetNB1Revenue'
	,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'PostEXTSales'
	,	SUM(ISNULL(FST.NB_AppsCnt, 0)) AS 'Applications'
	,	SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Sales'
	,	SUM(ISNULL(FST.SA_NetSalesCnt, 0)) AS 'AddtlSurgery'
	INTO #Sales
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON cm.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.Center
			AND DD.FullDate = #Centers.[Date]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @MinDate AND @MaxDate
		AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
	GROUP BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	SUM(ISNULL(FAR.BeBack, 0)) as 'BeBacks'
	,	SUM(ISNULL(FAR.Consultation, 0)) as 'Consultations'
	,	SUM(ISNULL(FAR.Appointments, 0)) as 'Appointments'
	,	SUM(ISNULL(FAR.Show, 0)) AS 'Shows'
	,	SUM(ISNULL(FAR.Sale, 0)) AS 'Sales'
	INTO #FactActivity
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FAR.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = dd.DateKey
		INNER JOIN #Centers cntr
			ON C.CenterSSID = cntr.Center
			AND DD.FullDate = cntr.[Date]
	WHERE DD.FullDate BETWEEN @MinDate AND @MaxDate
	GROUP BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))
	ORDER BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	COUNT(FL.Leads) AS 'Leads'
	INTO #FactLead
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FL.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FL.LeadCreationDateKey = dd.DateKey
		INNER JOIN #Centers cntr
			ON C.CenterSSID = cntr.Center
			AND DD.FullDate = cntr.[Date]
	WHERE DD.FullDate BETWEEN @MinDate AND @MaxDate
	GROUP BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	SUM(ISNULL(FST.NB_BIOConvCnt, 0)) AS 'BIOConversion'
	,	SUM(ISNULL(FST.NB_ExtConvCnt, 0)) AS 'EXTConversion'
	,	SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'XTRConversion'
	,	SUM(ISNULL(FST.NB_BIOConvCnt, 0))
			+ SUM(ISNULL(FST.NB_ExtConvCnt, 0))
			+ SUM(ISNULL(FST.NB_XTRConvCnt, 0)) AS 'TotalConversion'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1099)
			AND M.RevenueGroupDescriptionShort='PCP' THEN 1 ELSE 0 END)
		AS 'PCPCancels'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END) AS 'PCPDowngrades'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'PCPUpgrades'
	,	SUM(FST.PCP_ExtMemAmt) AS 'EXEMEMRevenue'
	INTO #Milestones
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON cm.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.Center
			AND DD.FullDate = #Centers.[Date]
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @MinDate AND @MaxDate
		AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
	GROUP BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	DD.FullDate AS 'Date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101)) AS 'Period'
	,	SUM(ISNULL(FR.Balance, 0)) AS 'Receivables'
	INTO #Receivables
	FROM HC_Accounting.dbo.FactReceivables FR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FR.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FR.DateKey = dd.DateKey
		INNER JOIN #Centers cntr
			ON C.ReportingCenterSSID = cntr.Center
			AND DD.FullDate = cntr.[Date]
	WHERE DD.FullDate = DATEADD(DAY, -1, CONVERT(DATETIME, CONVERT(VARCHAR, @MaxDate, 101)))
	GROUP BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))
	ORDER BY c.ReportingCenterSSID
	,	DD.FullDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(DD.FullDate)-1 ), DD.FullDate), 101))



	SELECT c.ReportingCenterSSID AS 'Center'
	,	CONVERT(DATETIME, CONVERT(VARCHAR, cm.ClientMembershipEndDate, 101)) AS 'date'
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(cm.ClientMembershipEndDate)-1 ), cm.ClientMembershipEndDate), 101)) AS 'Period'
	,	COUNT(clt.ClientSSID) AS 'EXTExpireCount'
	INTO #EXTExpirations
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON clt.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON clt.CurrentExtremeTherapyClientMembershipSSID = cm.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN #Centers cntr
			ON C.ReportingCenterSSID = cntr.Center
			AND CONVERT(DATETIME, CONVERT(VARCHAR, cm.ClientMembershipEndDate, 101)) = cntr.[Date]
	WHERE m.MembershipSSID IN (6, 7, 8, 9)
		AND cm.ClientMembershipEndDate BETWEEN @MinDate AND @MaxDate
		AND cm.ClientMembershipStatusSSID IN (1)
	GROUP BY c.ReportingCenterSSID
	,	CONVERT(DATETIME, CONVERT(VARCHAR, cm.ClientMembershipEndDate, 101))
	,	CONVERT(DATETIME, CONVERT(VARCHAR(11), DATEADD(dd, -(DAY(cm.ClientMembershipEndDate)-1 ), cm.ClientMembershipEndDate), 101))




	SELECT #Centers.center
	,	#Centers.[date]
	,	#Centers.Period
	,	ISNULL(#Sales.TraditionalRevenue, 0) AS 'TraditionalRevenue'
	,	ISNULL(#Sales.EXTRevenue, 0) AS 'EXTRevenue'
	,	ISNULL(#Sales.GradualRevenue, 0) AS 'GradualRevenue'
	,	ISNULL(#Sales.XtrandsRevenue, 0) AS 'XtrandsRevenue'
	,	ISNULL(#Sales.NB2Revenue, 0) AS 'NB2Revenue'
	,	ISNULL(#Sales.PCPRevenue, 0) AS 'PCPRevenue'
	,	ISNULL(#Sales.PCPTotalRevenue, 0) AS 'PCPTotalRevenue'
	,	ISNULL(#Sales.SurgeryRevenue, 0) AS 'SurgeryRevenue'
	,	ISNULL(#Sales.PostEXTRevenue, 0) AS 'PostEXTRevenue'
	,	ISNULL(#Sales.ServiceRevenue, 0) AS 'ServiceRevenue'
	,	ISNULL(#Sales.RetailRevenue, 0) AS 'RetailRevenue'
	,	ISNULL(#Sales.TraditionalSales, 0) AS 'TraditionalSales'
	,	ISNULL(#Sales.GradualSales, 0) AS 'GradualSales'
	,	ISNULL(#Sales.XtrandsSales, 0) AS 'XtrandsSales'
	,	ISNULL(#Sales.EXTSales, 0) AS 'EXTSales'
	,	ISNULL(#Sales.SurgerySales, 0) AS 'SurgerySales'
	,	ISNULL(#Sales.NetNB1Sales, 0) AS 'NetNB1Sales'
	,	ISNULL(#Sales.PostEXTSales, 0) AS 'PostEXTSales'
	,	ISNULL(#Sales.Applications, 0) AS 'Applications'
	,	ISNULL(#Sales.NetNB1Revenue, 0) AS 'NetNB1Revenue'
	,	ISNULL(#FactActivity.BeBacks, 0) AS 'BeBacks'
	,	ISNULL(#FactActivity.Consultations, 0) AS 'Consultations'
	,	ISNULL(#FactActivity.Appointments, 0) AS 'Appointments'
	,	ISNULL(#FactActivity.Shows, 0) AS 'Shows'
	,	ISNULL(#FactActivity.Sales, 0) AS 'Sales'
	,	ISNULL(#Milestones.BIOConversion, 0) AS 'BIOConversion'
	,	ISNULL(#Milestones.EXTConversion, 0) AS 'EXTConversion'
	,	ISNULL(#Milestones.XTRConversion, 0) AS 'XTRConversion'
	,	ISNULL(#Milestones.TotalConversion, 0) AS 'TotalConversion'
	,	ISNULL(#Milestones.PCPCancels, 0) AS 'PCPCancels'
	,	ISNULL(#Milestones.PCPDowngrades, 0) AS 'PCPDowngrades'
	,	ISNULL(#Milestones.PCPUpgrades, 0) AS 'PCPUpgrades'
	,	ISNULL(#Milestones.EXEMEMRevenue, 0) AS 'EXEMEMRevenue'
	,	ISNULL(#FactLead.Leads, 0) AS 'Leads'
	,	ISNULL(#Sales.GrossNB1Sales, 0) AS 'GrossNB1Sales'
	,	ISNULL(#Receivables.Receivables, 0) AS 'Receivables'
	,	ISNULL(#EXTExpirations.EXTExpireCount, 0) AS 'EXTExpireCount'
	,	ISNULL(#Sales.AddtlSurgery, 0) AS 'AddtlSurgery'
	INTO #Actuals
	FROM #Centers
		LEFT OUTER JOIN #Sales
			ON #Centers.center = #Sales.center
			AND #Centers.date = #Sales.date
		LEFT OUTER JOIN #FactActivity
			ON #Centers.center = #FactActivity.center
			AND #Centers.date = #FactActivity.date
		LEFT OUTER JOIN #Milestones
			ON #Centers.center = #Milestones.center
			AND #Centers.date = #Milestones.date
		LEFT OUTER JOIN #FactLead
			ON #Centers.center = #FactLead.center
			AND #Centers.date = #FactLead.date
		LEFT OUTER JOIN #Receivables
			ON #Centers.center = #Receivables.center
			AND #Centers.date = #Receivables.date
		LEFT OUTER JOIN #EXTExpirations
			ON #Centers.center = #EXTExpirations.center
			AND #Centers.date = #EXTExpirations.date



	SELECT CenterID AS 'Center'
	,	PartitionDate AS 'Period'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10305) THEN Budget ELSE 0 END, 0)) AS 'Budget_TraditionalRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10315) THEN Budget ELSE 0 END, 0)) AS 'Budget_EXTRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10310) THEN Budget ELSE 0 END, 0)) AS 'Budget_GradualRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10540) THEN Budget ELSE 0 END, 0)) AS 'Budget_NB2Revenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10536) THEN Budget ELSE 0 END, 0)) AS 'Budget_PCPRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10541) THEN Budget ELSE 0 END, 0)) AS 'Budget_PCPTotalRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10320) THEN Budget ELSE 0 END, 0)) AS 'Budget_SurgeryRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10325) THEN Budget ELSE 0 END, 0)) AS 'Budget_PostEXTRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (3080) THEN Budget ELSE 0 END, 0)) AS 'Budget_ServiceRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (3090) THEN Budget ELSE 0 END, 0)) AS 'Budget_RetailRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10205) THEN Budget ELSE 0 END, 0)) AS 'Budget_TraditionalSales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10210) THEN Budget ELSE 0 END, 0)) AS 'Budget_GradualSales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10215) THEN Budget ELSE 0 END, 0)) AS 'Budget_EXTSales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10220) THEN Budget ELSE 0 END, 0)) AS 'Budget_SurgerySales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10231) THEN Budget ELSE 0 END, 0)) AS 'Budget_NetNB1Sales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10225) THEN Budget ELSE 0 END, 0)) AS 'Budget_PostEXTSales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10240) THEN Budget ELSE 0 END, 0)) AS 'Budget_Applications'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10105) THEN Budget ELSE 0 END, 0)) AS 'Budget_BeBacks'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10110) THEN Budget ELSE 0 END, 0)) AS 'Budget_Consultations'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10100) THEN Budget ELSE 0 END, 0)) AS 'Budget_Appointments'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10120) THEN Budget ELSE 0 END, 0)) AS 'Budget_Shows'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10125) THEN Budget ELSE 0 END, 0)) AS 'Budget_Sales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10430) THEN Budget ELSE 0 END, 0)) AS 'Budget_BIOConversion'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10435) THEN Budget ELSE 0 END, 0)) AS 'Budget_EXTConversion'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10433) THEN Budget ELSE 0 END, 0)) AS 'Budget_XTRConversion'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10440) THEN Budget ELSE 0 END, 0)) AS 'Budget_TotalConversion'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10505) THEN Budget ELSE 0 END, 0)) AS 'Budget_PCPCancels'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10510) THEN Budget ELSE 0 END, 0)) AS 'Budget_PCPDowngrades'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10515) THEN Budget ELSE 0 END, 0)) AS 'Budget_PCPUpgrades'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10535) THEN Budget ELSE 0 END, 0)) AS 'Budget_EXEMEMRevenue'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10155) THEN Budget ELSE 0 END, 0)) AS 'Budget_Leads'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10235) THEN Budget ELSE 0 END, 0)) AS 'Budget_GrossNB1Sales'
	,	SUM(ISNULL(CASE WHEN AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'Budget_NetNB1Revenue'
	INTO #Budget
	FROM HC_Accounting.dbo.FactAccounting FA
		INNER JOIN #Centers cntr
			ON FA.CenterID = cntr.Center
			AND FA.PartitionDate = cntr.[Date]
	WHERE FA.PartitionDate BETWEEN @MinDate AND @MaxDate
		AND FA.AccountID IN (10305, 10315, 10310, 10540, 10536, 10541, 10320, 10325,
			3080, 3090, 10205, 10210, 10215, 10220, 10225, 10240, 10105, 10110,
			10100, 10120, 10125, 10430, 10435, 10440, 10505, 10510, 10515, 10535,
			10155, 10235)
	GROUP BY FA.CenterID
	,	FA.PartitionDate



	SELECT #Dates.DateDesc
	,	#Dates.DateDescFiscalYear
	,	#Actuals.Center
	,	#Dates.DateID
	,	#Dates.StartDate
	,	#Dates.SortOrder
	,	CONVERT(DATETIME, CONVERT(VARCHAR, #Dates.EndDate, 101)) AS 'EndDate'
	,	SUM(ISNULL(#Actuals.TraditionalRevenue, 0)) AS 'TraditionalRevenue'
	,	SUM(ISNULL(#Actuals.EXTRevenue, 0)) AS 'EXTRevenue'
	,	SUM(ISNULL(#Actuals.GradualRevenue, 0)) AS 'GradualRevenue'
	,	SUM(ISNULL(#Actuals.XtrandsRevenue, 0)) AS 'XtrandsRevenue'
	,	SUM(ISNULL(#Actuals.NB2Revenue, 0)) AS 'NB2Revenue'
	,	SUM(ISNULL(#Actuals.PCPRevenue, 0)) AS 'PCPRevenue'
	,	SUM(ISNULL(#Actuals.PCPTotalRevenue, 0)) AS 'PCPTotalRevenue'
	,	SUM(ISNULL(#Actuals.SurgeryRevenue, 0)) AS 'SurgeryRevenue'
	,	SUM(ISNULL(#Actuals.PostEXTRevenue, 0)) AS 'PostEXTRevenue'
	,	SUM(ISNULL(#Actuals.ServiceRevenue , 0)) AS 'ServiceRevenue'
	,	SUM(ISNULL(#Actuals.RetailRevenue, 0)) AS 'RetailRevenue'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.TraditionalSales, 0))) AS 'TraditionalSales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.GradualSales, 0))) AS 'GradualSales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.XtrandsSales, 0))) AS 'XtrandsSales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.EXTSales, 0))) AS 'EXTSales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.SurgerySales , 0))) AS 'SurgerySales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.NetNB1Sales, 0))) AS 'NetNB1Sales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.PostEXTSales, 0))) AS 'PostEXTSales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Applications, 0))) AS 'Applications'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.BeBacks, 0))) AS 'BeBacks'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Consultations, 0))) AS 'Consultations'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Appointments, 0))) AS 'Appointments'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Shows, 0))) AS 'Shows'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Sales, 0))) AS 'Sales'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.BIOConversion, 0))) AS 'BIOConversion'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.EXTConversion, 0))) AS 'EXTConversion'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.XTRConversion, 0))) AS 'XTRConversion'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.TotalConversion, 0))) AS 'TotalConversion'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.PCPCancels, 0))) AS 'PCPCancels'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.PCPDowngrades, 0))) AS 'PCPDowngrades'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.PCPUpgrades, 0))) AS 'PCPUpgrades'
	,	SUM(ISNULL(#Actuals.EXEMEMRevenue, 0)) AS 'EXEMEMRevenue'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.Leads, 0))) AS 'Leads'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.GrossNB1Sales, 0))) AS 'GrossNB1Sales'
	,	SUM(ISNULL(#Actuals.Receivables, 0)) AS 'Receivables'
	,	SUM(ISNULL(#Actuals.NetNB1Revenue, 0)) AS 'NetNb1Revenue'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.EXTExpireCount, 0))) AS 'EXTExpireCount'
	,	SUM(CONVERT(BIGINT, ISNULL(#Actuals.AddtlSurgery, 0))) AS 'AddtlSurgery'
	,	AVG(ISNULL(#Budget.Budget_TraditionalRevenue, 0)) AS 'Budget_TraditionalRevenue'
	,	AVG(ISNULL(#Budget.Budget_EXTRevenue, 0)) AS 'Budget_EXTRevenue'
	,	AVG(ISNULL(#Budget.Budget_GradualRevenue, 0)) AS 'Budget_GradualRevenue'
	,	AVG(ISNULL(#Budget.Budget_NB2Revenue, 0)) AS 'Budget_NB2Revenue'
	,	AVG(ISNULL(#Budget.Budget_PCPRevenue, 0)) AS 'Budget_PCPRevenue'
	,	AVG(ISNULL(#Budget.Budget_PCPTotalRevenue, 0)) AS 'Budget_PCPTotalRevenue'
	,	AVG(ISNULL(#Budget.Budget_SurgeryRevenue, 0)) AS 'Budget_SurgeryRevenue'
	,	AVG(ISNULL(#Budget.Budget_PostEXTRevenue, 0)) AS 'Budget_PostEXTRevenue'
	,	AVG(ISNULL(#Budget.Budget_ServiceRevenue , 0)) AS 'Budget_ServiceRevenue'
	,	AVG(ISNULL(#Budget.Budget_RetailRevenue, 0)) AS 'Budget_RetailRevenue'
	,	AVG(ISNULL(#Budget.Budget_TraditionalSales, 0)) AS 'Budget_TraditionalSales'
	,	AVG(ISNULL(#Budget.Budget_GradualSales, 0)) AS 'Budget_GradualSales'
	,	AVG(ISNULL(#Budget.Budget_EXTSales, 0)) AS 'Budget_EXTSales'
	,	AVG(ISNULL(#Budget.Budget_SurgerySales , 0)) AS 'Budget_SurgerySales'
	,	AVG(ISNULL(#Budget.Budget_NetNB1Sales, 0)) AS 'Budget_NetNB1Sales'
	,	AVG(ISNULL(#Budget.Budget_PostEXTSales, 0)) AS 'Budget_PostEXTSales'
	,	AVG(ISNULL(#Budget.Budget_Applications, 0)) AS 'Budget_Applications'
	,	AVG(ISNULL(#Budget.Budget_BeBacks, 0)) AS 'Budget_BeBacks'
	,	AVG(ISNULL(#Budget.Budget_Consultations, 0)) AS 'Budget_Consultations'
	,	AVG(ISNULL(#Budget.Budget_Appointments, 0)) AS 'Budget_Appointments'
	,	AVG(ISNULL(#Budget.Budget_Shows, 0)) AS 'Budget_Shows'
	,	AVG(ISNULL(#Budget.Budget_Sales, 0)) AS 'Budget_Sales'
	,	AVG(ISNULL(#Budget.Budget_BIOConversion, 0)) AS 'Budget_BIOConversion'
	,	AVG(ISNULL(#Budget.Budget_EXTConversion, 0)) AS 'Budget_EXTConversion'
	,	AVG(ISNULL(#Budget.Budget_XTRConversion, 0)) AS 'Budget_XTRConversion'
	,	AVG(ISNULL(#Budget.Budget_TotalConversion, 0)) AS 'Budget_TotalConversion'
	,	AVG(ISNULL(#Budget.Budget_PCPCancels, 0)) AS 'Budget_PCPCancels'
	,	AVG(ISNULL(#Budget.Budget_PCPDowngrades, 0)) AS 'Budget_PCPDowngrades'
	,	AVG(ISNULL(#Budget.Budget_PCPUpgrades, 0)) AS 'Budget_PCPUpgrades'
	,	AVG(ISNULL(#Budget.Budget_EXEMEMRevenue, 0)) AS 'Budget_EXEMEMRevenue'
	,	AVG(ISNULL(#Budget.Budget_Leads, 0)) AS 'Budget_Leads'
	,	AVG(ISNULL(#Budget.Budget_GrossNB1Sales, 0)) AS 'Budget_GrossNB1Sales'
	,	SUM(ISNULL(#Budget.Budget_NetNB1Revenue, 0)) AS 'Budget_NetNb1Revenue'
	INTO #tmp
	FROM #Actuals
		LEFT OUTER JOIN #Budget
			ON #Actuals.center = #Budget.center
			AND #Actuals.period = #Budget.period
		INNER JOIN #Dates
			ON #Actuals.[date] BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN #Centers cntr
			ON #Actuals.Center = cntr.Center
			AND #Actuals.Period = cntr.[Date]
	GROUP BY #Dates.DateDesc
	,	#Dates.DateDescFiscalYear
	,	#Actuals.Center
	,	#Dates.DateID
	,	#Dates.StartDate
	,	CONVERT(DATETIME, CONVERT(VARCHAR, #Dates.EndDate, 101))
	,	#Dates.SortOrder
	ORDER BY #Actuals.Center
	,	#Dates.SortOrder



	SELECT DateDesc
	,	DateDescFiscalYear
	,	DateID
	,	StartDate
	,	SortOrder
	,	EndDate
	,	SUM(TraditionalRevenue) AS 'TraditionalRevenue'
	,	SUM(EXTRevenue) AS 'EXTRevenue'
	,	SUM(GradualRevenue) AS 'GradualRevenue'
	,	SUM(XtrandsRevenue) AS 'XtrandsRevenue'
	,	SUM(NB2Revenue) AS 'NB2Revenue'
	,	SUM(PCPRevenue) AS 'PCPRevenue'
	,	SUM(PCPTotalRevenue) AS 'PCPTotalRevenue'
	,	SUM(SurgeryRevenue) AS 'SurgeryRevenue'
	,	SUM(PostEXTRevenue) AS 'PostEXTRevenue'
	,	SUM(ServiceRevenue) AS 'ServiceRevenue'
	,	SUM(RetailRevenue) AS 'RetailRevenue'
	,	SUM(TraditionalSales) AS 'TraditionalSales'
	,	SUM(GradualSales) AS 'GradualSales'
	,	SUM(XtrandsSales) AS 'XtrandsSales'
	,	SUM(EXTSales) AS 'EXTSales'
	,	SUM(SurgerySales) AS 'SurgerySales'
	,	SUM(NetNB1Sales) AS 'NetNB1Sales'
	,	SUM(PostEXTSales) AS 'PostEXTSales'
	,	SUM(Applications) AS 'Applications'
	,	SUM(BeBacks) AS 'BeBacks'
	,	SUM(Consultations) AS 'Consultations'
	,	SUM(Appointments) AS 'Appointments'
	,	SUM(Shows) AS 'Shows'
	,	SUM(Sales) AS 'Sales'
	,	SUM(BIOConversion) AS 'BIOConversion'
	,	SUM(EXTConversion) AS 'EXTConversion'
	,	SUM(XTRConversion) AS 'XTRConversion'
	,	SUM(TotalConversion) AS 'TotalConversion'
	,	SUM(PCPCancels) AS 'PCPCancels'
	,	SUM(PCPDowngrades) AS 'PCPDowngrades'
	,	SUM(PCPUpgrades) AS 'PCPUpgrades'
	,	SUM(EXEMEMRevenue) AS 'EXEMEMRevenue'
	,	SUM(Leads) AS 'Leads'
	,	SUM(GrossNB1Sales) AS 'GrossNB1Sales'
	,	SUM(Receivables) AS 'Receivables'
	,	SUM(NetNB1Revenue) AS 'NetNB1Revenue'
	,	SUM(EXTExpireCount) AS 'EXTExpireCount'
	,	SUM(AddtlSurgery) AS 'AddtlSurgery'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(Appointments, 0)), SUM(ISNULL(Leads, 0))) AS 'AppointmentPct'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(Consultations, 0)), SUM(ISNULL(Appointments, 0))) AS 'ConsultationPct'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(NetNB1Revenue, 0)), SUM(ISNULL(NetNB1Sales, 0))) AS 'NetNB1Avg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(NetNB1Sales, 0)), SUM(ISNULL(Consultations, 0))) AS 'ClosePct'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(TraditionalRevenue, 0)), SUM(ISNULL(TraditionalSales, 0))) AS 'TraditionalAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(GradualRevenue, 0)), SUM(ISNULL(GradualSales, 0))) AS 'GradualAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(XtrandsRevenue, 0)), SUM(ISNULL(XtrandsSales, 0))) AS 'XtrandsAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(EXTRevenue, 0)), SUM(ISNULL(EXTSales, 0))) AS 'EXTAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(SurgeryRevenue, 0)), SUM(ISNULL(SurgerySales , 0))) AS 'SurgeryAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(PostEXTRevenue, 0)), SUM(ISNULL(PostEXTSales, 0))) AS 'PostEXTAvg'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(Applications, 0)), (SUM(ISNULL(TraditionalSales, 0)) + SUM(ISNULL(GradualSales, 0)))) AS 'ApplicationPct'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(BIOConversion, 0)), SUM(ISNULL(Applications, 0))) AS 'BioConvPct'
	,	CASE WHEN DateID IN (5, 6) THEN 0.0 ELSE dbo.DIVIDE_NOROUND(SUM(ISNULL(EXTConversion, 0)), SUM(ISNULL(EXTSales, 0))) END AS 'EXTConvPct'
	,	CASE WHEN DateID IN (5, 6) THEN 0.0 ELSE dbo.DIVIDE_NOROUND(SUM(ISNULL(XTRConversion, 0)), SUM(ISNULL(XtrandsSales, 0))) END AS 'XTRConvPct'
	,	dbo.DIVIDE_NOROUND(SUM(ISNULL(PostEXTSales, 0)), SUM(ISNULL(SurgerySales, 0))) AS 'PostEXTPct'
	INTO #tmp2
	FROM #tmp
	GROUP BY DateDesc
	,	DateDescFiscalYear
	,	DateID
	,	StartDate
	,	SortOrder
	,	EndDate



	UPDATE f
	SET f.TraditionalRevenue = c.TraditionalRevenue - p.TraditionalRevenue
	,	f.EXTRevenue = c.EXTRevenue - p.EXTRevenue
	,	f.GradualRevenue = c.GradualRevenue - p.GradualRevenue
	,	f.XtrandsRevenue = c.XtrandsRevenue - p.XtrandsRevenue
	,	f.NB2Revenue = c.NB2Revenue - p.NB2Revenue
	,	f.PCPRevenue = c.PCPRevenue - p.PCPRevenue
	,	f.PCPTotalRevenue = c.PCPTotalRevenue - p.PCPTotalRevenue
	,	f.SurgeryRevenue = c.SurgeryRevenue - p.SurgeryRevenue
	,	f.PostEXTRevenue = c.PostEXTRevenue - p.PostEXTRevenue
	,	f.ServiceRevenue = c.ServiceRevenue - p.ServiceRevenue
	,	f.RetailRevenue = c.RetailRevenue - p.RetailRevenue
	,	f.TraditionalSales = c.TraditionalSales - p.TraditionalSales
	,	f.GradualSales = c.GradualSales - p.GradualSales
	,	f.XtrandsSales = c.XtrandsSales - p.XtrandsSales
	,	f.EXTSales = c.EXTSales - p.EXTSales
	,	f.SurgerySales = c.SurgerySales - p.SurgerySales
	,	f.NetNB1Sales = c.NetNB1Sales - p.NetNB1Sales
	,	f.PostEXTSales = c.PostEXTSales - p.PostEXTSales
	,	f.Applications = c.Applications - p.Applications
	,	f.BeBacks = c.BeBacks - p.BeBacks
	,	f.Consultations = c.Consultations - p.Consultations
	,	f.Appointments = c.Appointments - p.Appointments
	,	f.Shows = c.Shows - p.Shows
	,	f.Sales = c.Sales - p.Sales
	,	f.BIOConversion = c.BIOConversion - p.BIOConversion
	,	f.EXTConversion = c.EXTConversion - p.EXTConversion
	,	f.XTRConversion = c.XTRConversion - p.XTRConversion
	,	f.TotalConversion = c.TotalConversion - p.TotalConversion
	,	f.PCPCancels = c.PCPCancels - p.PCPCancels
	,	f.PCPDowngrades = c.PCPDowngrades - p.PCPDowngrades
	,	f.PCPUpgrades = c.PCPUpgrades - p.PCPUpgrades
	,	f.EXEMEMRevenue = c.EXEMEMRevenue - p.EXEMEMRevenue
	,	f.Leads = c.Leads - p.Leads
	,	f.GrossNB1Sales = c.GrossNB1Sales - p.GrossNB1Sales
	,	f.Receivables = c.Receivables - p.Receivables
	,	f.NetNB1Revenue = c.NetNB1Revenue - p.NetNB1Revenue
	,	f.AppointmentPct = c.AppointmentPct - p.AppointmentPct
	,	f.ConsultationPct = c.ConsultationPct - p.ConsultationPct
	,	f.NetNB1Avg = c.NetNB1Avg - p.NetNB1Avg
	,	f.ClosePct = c.ClosePct - p.ClosePct
	,	f.TraditionalAvg = c.TraditionalAvg - p.TraditionalAvg
	,	f.GradualAvg = c.GradualAvg - p.GradualAvg
	,	f.XtrandsAvg = c.XtrandsAvg - p.XtrandsAvg
	,	f.EXTAvg = c.EXTAvg - p.EXTAvg
	,	f.SurgeryAvg = c.SurgeryAvg - p.SurgeryAvg
	,	f.PostEXTAvg = c.PostEXTAvg - p.PostEXTAvg
	,	f.ApplicationPct = c.ApplicationPct - p.ApplicationPct
	,	f.BioConvPct = c.BioConvPct - p.BioConvPct
	,	f.EXTConvPct = c.EXTConvPct - p.EXTConvPct
	,	f.XTRConvPct = c.XTRConvPct - p.XTRConvPct
	,	f.PostEXTPct = c.PostEXTPct - p.PostEXTPct
	,	f.AddtlSurgery = c.AddtlSurgery - p.AddtlSurgery
	FROM #tmp2 f
		INNER JOIN #tmp2 c
			ON f.DateDesc = c.DateDesc
			AND c.DateID=2
		INNER JOIN #tmp2 p
			ON f.DateDesc = p.DateDesc
			AND p.DateID=5
	WHERE f.DateID=7


	UPDATE f
	SET f.TraditionalRevenue = c.TraditionalRevenue - p.TraditionalRevenue
	,	f.EXTRevenue = c.EXTRevenue - p.EXTRevenue
	,	f.GradualRevenue = c.GradualRevenue - p.GradualRevenue
	,	f.XtrandsRevenue = c.XtrandsRevenue - p.XtrandsRevenue
	,	f.NB2Revenue = c.NB2Revenue - p.NB2Revenue
	,	f.PCPRevenue = c.PCPRevenue - p.PCPRevenue
	,	f.PCPTotalRevenue = c.PCPTotalRevenue - p.PCPTotalRevenue
	,	f.SurgeryRevenue = c.SurgeryRevenue - p.SurgeryRevenue
	,	f.PostEXTRevenue = c.PostEXTRevenue - p.PostEXTRevenue
	,	f.ServiceRevenue = c.ServiceRevenue - p.ServiceRevenue
	,	f.RetailRevenue = c.RetailRevenue - p.RetailRevenue
	,	f.TraditionalSales = c.TraditionalSales - p.TraditionalSales
	,	f.GradualSales = c.GradualSales - p.GradualSales
	,	f.XtrandsSales = c.XtrandsSales - p.XtrandsSales
	,	f.EXTSales = c.EXTSales - p.EXTSales
	,	f.SurgerySales = c.SurgerySales - p.SurgerySales
	,	f.NetNB1Sales = c.NetNB1Sales - p.NetNB1Sales
	,	f.PostEXTSales = c.PostEXTSales - p.PostEXTSales
	,	f.Applications = c.Applications - p.Applications
	,	f.BeBacks = c.BeBacks - p.BeBacks
	,	f.Consultations = c.Consultations - p.Consultations
	,	f.Appointments = c.Appointments - p.Appointments
	,	f.Shows = c.Shows - p.Shows
	,	f.Sales = c.Sales - p.Sales
	,	f.BIOConversion = c.BIOConversion - p.BIOConversion
	,	f.EXTConversion = c.EXTConversion - p.EXTConversion
	,	f.XTRConversion = c.XTRConversion - p.XTRConversion
	,	f.TotalConversion = c.TotalConversion - p.TotalConversion
	,	f.PCPCancels = c.PCPCancels - p.PCPCancels
	,	f.PCPDowngrades = c.PCPDowngrades - p.PCPDowngrades
	,	f.PCPUpgrades = c.PCPUpgrades - p.PCPUpgrades
	,	f.EXEMEMRevenue = c.EXEMEMRevenue - p.EXEMEMRevenue
	,	f.Leads = c.Leads - p.Leads
	,	f.GrossNB1Sales = c.GrossNB1Sales - p.GrossNB1Sales
	,	f.Receivables = c.Receivables - p.Receivables
	,	f.NetNB1Revenue = c.NetNB1Revenue - p.NetNB1Revenue
	,	f.AppointmentPct = c.AppointmentPct - p.AppointmentPct
	,	f.ConsultationPct = c.ConsultationPct - p.ConsultationPct
	,	f.NetNB1Avg = c.NetNB1Avg - p.NetNB1Avg
	,	f.ClosePct = c.ClosePct - p.ClosePct
	,	f.TraditionalAvg = c.TraditionalAvg - p.TraditionalAvg
	,	f.GradualAvg = c.GradualAvg - p.GradualAvg
	,	f.XtrandsAvg = c.XtrandsAvg - p.XtrandsAvg
	,	f.EXTAvg = c.EXTAvg - p.EXTAvg
	,	f.SurgeryAvg = c.SurgeryAvg - p.SurgeryAvg
	,	f.PostEXTAvg = c.PostEXTAvg - p.PostEXTAvg
	,	f.ApplicationPct = c.ApplicationPct - p.ApplicationPct
	,	f.BioConvPct = c.BioConvPct - p.BioConvPct
	,	f.EXTConvPct = c.EXTConvPct - p.EXTConvPct
	,	f.XTRConvPct = c.XTRConvPct - p.XTRConvPct
	,	f.PostEXTPct = c.PostEXTPct - p.PostEXTPct
	,	f.AddtlSurgery = c.AddtlSurgery - p.AddtlSurgery
	FROM #tmp2 f
		INNER JOIN #tmp2 c
			ON f.DateDesc = c.DateDesc
			AND c.DateID=4
		INNER JOIN #tmp2 p
			ON f.DateDesc = p.DateDesc
			AND p.DateID=6
	WHERE f.DateID=8



	SELECT *
	FROM #tmp2
	ORDER BY SortOrder


END
