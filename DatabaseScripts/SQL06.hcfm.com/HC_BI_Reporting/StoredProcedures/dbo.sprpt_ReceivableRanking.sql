/***********************************************************************

PROCEDURE:	Receivable Ranking

DESTINATION SERVER:	   HCSQL2

DESTINATION DATABASE: INFOSTORE

RELATED APPLICATION:  Receivable Ranking Report

AUTHOR: James Hannah III

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 4/29/2009

LAST REVISION DATE: 4/29/2009

--------------------------------------------------------------------------------------------------------
NOTES:
	05/08/2009 -- JH --	Added another variable @StartDate sales to get only previous month data for
						PCP & Non Prgm Total

	05/11/2009 -- AP --	Changed the output to include the month selected by the user, and the previous 5 months.

	05/12/2009 -- JH -- Added a New Report Parameter @Type to select Corporate or Franchise.  Also changed
						'% of Recv. + W/O' Write Off amount to be current month and not all months combined.

	05/12/2009 -- JH --	Changed Center Type Selection to Select Corporate or Franchise based on if they are on
						CMS.

	05/12/2009 -- JH --	Changed Monthly calculation for @StartDate because it wasn't calculating months correct
						in some instances.

	07/14/2009 -- DL --	Changed @Month and @Year Parameters to integers to facilitate the comparison to MONTH(GETDATE())
						Changed @StartDate to CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)

	07/14/2009 -- DL --	Changed the 'receivables' query to return the Center's AR Balance depending on the value
						of @Month. If @Month is equal to the current month, select receivables for the previous day.
						If @Month is equal to a past month, get the last day of that month and select receivables
						for that day.
	08/07/2009 -- JH --	Changed Ranking to rank by AR/PCP$ Instead of (AR and writeoffs)/NB$ as per ticket #45509
	11/10/2010 -- MB -- Temporarily asked by DP to remove center 219 - Queens
	01/27/2011 -- MB -- Added center 219 - Queens back to the report output
	02/17/2011 -- MB -- Excluded 279 - Reno per DP request
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC sprpt_ReceivableRanking 11, 2010, 'C'
--------------------------------------------------------------------------------------------------------
EXECUTE ACCESS:  GRANT EXECUTE ON sprpt_ReceivableRanking to IIS
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_ReceivableRanking] (
	@Month INT,
	@Year INT,
	@Type VARCHAR(2))
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF

	DECLARE @StartDate DATETIME
	DECLARE @StartDateSales DATETIME
	DECLARE @EndDate DATETIME

	SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
	SET @EndDate = DATEADD(dd,-1,DATEADD(mm, 1, @StartDate))


	DECLARE @Receivables TABLE (
		[CenterID] [int] NULL
	,	[receivables] [float] NULL
	)

	DECLARE @Sales TABLE (
		[CenterID] [int] NULL
	,	[nb2$] [float] NULL
	,	[pcp$] [float] NULL
	)


	DECLARE @WOCounts TABLE (
		[CenterID] [int] NULL
	,	[WriteOffs] [float] NULL

	)


	-- 07/14/2009 --> DL
	-- If @Month is equal to the current month, select receivables for the previous day.
	-- If @Month is equal to a past month, get the last day of that month and select receivables for that day.
	DECLARE @ReceivablesDate DATETIME

	IF @Month = MONTH(GETDATE())
	  BEGIN
		SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101)
	  END
	ELSE
	  BEGIN
		SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @StartDate) + 1, 0)), 101)
	  END

	INSERT	@Receivables
	SELECT  [center]
	,		SUM([dbo].[CanadianConversion]([center], [balance], @ReceivablesDate)) AS 'Receivables'
	FROM    [hcmtbl_receivables]
	WHERE	[Date] = @ReceivablesDate
	GROUP BY [center]


	IF @TYPE = 'C'
		BEGIN
			INSERT @Sales
			SELECT tblCenter.center_num AS CenterID
			,	SUM(nb2$) AS 'nb2$'
			,	SUM(pcp$) 'pcp$'
			FROM [hcmvw_sales_summary]
					INNER JOIN HCFMDirectory.dbo.tblCenter tblCenter
						ON ([hcmvw_sales_summary].center = tblCenter.center_num
							OR [hcmvw_sales_summary].center = tblCenter.SurgeryCenterNumber)
			WHERE Date BETWEEN @StartDate AND @EndDate + '23:59:59'
				AND tblCenter.CMS = 1
				AND tblCenter.center_num like '2%'
				AND tblCenter.INACTIVE = 0
			GROUP BY tblCenter.center_num
			ORDER BY tblCenter.center_num
		END
	ELSE
		BEGIN
			INSERT @Sales
			SELECT tblCenter.center_num AS CenterID
			,	SUM(nb2$) AS 'nb2$'
			,	SUM(pcp$) 'pcp$'
			FROM [hcmvw_sales_summary]
					INNER JOIN HCFMDirectory.dbo.tblCenter tblCenter
						ON ([hcmvw_sales_summary].center = tblCenter.center_num
							OR [hcmvw_sales_summary].center = tblCenter.SurgeryCenterNumber)
			WHERE Date BETWEEN @StartDate AND @EndDate + '23:59:59'
				AND tblCenter.CMS = 1
				AND tblCenter.center_num LIKE '[678]__'
				AND tblCenter.INACTIVE = 0
			GROUP BY tblCenter.center_num
			ORDER BY tblCenter.center_num
		END


	--MONTH 1
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months1
	FROM transactions
	WHERE Date BETWEEN @StartDate AND DATEADD(dd,-1,DATEADD(mm,1,@StartDate)) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	--MONTH 2
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months2
	FROM transactions
	WHERE Date BETWEEN DATEADD(mm,-1,@StartDate) AND DATEADD(dd, -1, @StartDate) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	--MONTH 3
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months3
	FROM transactions
	WHERE Date BETWEEN DATEADD(mm,-2,@StartDate) AND DATEADD(dd, -1, DATEADD(mm,-1,@StartDate)) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	--MONTH 4
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months4
	FROM transactions
	WHERE Date BETWEEN DATEADD(mm,-3,@StartDate) AND DATEADD(dd, -1, DATEADD(mm,-2,@StartDate)) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	--MONTH 5
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months5
	FROM transactions
	WHERE Date BETWEEN DATEADD(mm,-4,@StartDate) AND DATEADD(dd, -1, DATEADD(mm,-3,@StartDate)) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	--MONTH 6
	SELECT Center AS CenterID
	,	SUM(transactions.price) * -1 AS 'Writeoffs'
	INTO #WO_Months6
	FROM transactions
	WHERE Date BETWEEN DATEADD(mm,-5,@StartDate) AND DATEADD(dd, -1, DATEADD(mm,-4,@StartDate)) + '23:59:59'
		AND code IN ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
		AND ISNULL(bvoided,0)= 0
	GROUP BY Center

	IF @TYPE = 'C'
		BEGIN
			SELECT CASE WHEN [Center].Type = 'C' THEN 'Corporate' ELSE 'Franchise' END AS 'Type'
			,	[tblRegion].Region
			,	tblRegion.[RegionID]
			,	Center.Center_Num
			,	CONVERT(VARCHAR(3),[Center].center_num) + ' - ' + [Center].center AS 'Center'
			,	ISNULL([Sales].nb2$, 0) AS 'nb2$'
			,	ISNULL([Sales].pcp$, 0) AS 'pcp$'
			,	ISNULL([Receivables].receivables,0) 'receivables'
			,	dbo.Divide(ISNULL([Receivables].receivables,0),ISNULL([Sales].nb2$, 0)) AS 'recievablesPercent'
			,	dbo.Divide((ISNULL([Receivables].receivables,0) + ISNULL([WO1].WriteOffs, 0))
					,ISNULL([Sales].nb2$, 0)) AS 'AR_WO_Percent'
			,	dbo.Divide((ISNULL([Receivables].receivables,0))
					,ISNULL([Sales].pcp$, 0)) AS 'AR_PCP_Percent'
			,	ISNULL(WO1.Writeoffs,0) AS 'MONTH1'
			,	ISNULL(WO2.Writeoffs,0) AS 'MONTH2'
			,	ISNULL(WO3.Writeoffs,0) AS 'MONTH3'
			,	ISNULL(WO4.Writeoffs,0) AS 'MONTH4'
			,	ISNULL(WO5.Writeoffs,0) AS 'MONTH5'
			,	ISNULL(WO6.Writeoffs,0) AS 'MONTH6'
			FROM HCFMDirectory.dbo.tblcenter AS Center
				LEFT JOIN @Sales [Sales]
					ON [Center].center_num=[Sales].CenterID
				LEFT OUTER JOIN @Receivables [Receivables]
					ON [Center].center_num=[Receivables].CenterID
				LEFT OUTER JOIN hcfmdirectory.dbo.tblRegion tblRegion
					ON [Center].regionID=tblRegion.RegionID
				LEFT OUTER JOIN #WO_Months1 [WO1]
					ON [Center].center_num=[WO1].CenterID
				LEFT OUTER JOIN #WO_Months2 [WO2]
					ON [Center].center_num=[WO2].CenterID
				LEFT OUTER JOIN #WO_Months3 [WO3]
					ON [Center].center_num=[WO3].CenterID
				LEFT OUTER JOIN #WO_Months4 [WO4]
					ON [Center].center_num=[WO4].CenterID
				LEFT OUTER JOIN #WO_Months5 [WO5]
					ON [Center].center_num=[WO5].CenterID
				LEFT OUTER JOIN #WO_Months6 [WO6]
					ON [Center].center_num=[WO6].CenterID
			WHERE [Center].center_num LIKE '[2]__'
				AND [Center].INACTIVE = 0
				AND [Center].CMS = 1
				AND [Center].center_num NOT IN (279)
			ORDER BY dbo.Divide((ISNULL([Receivables].receivables,0))
					,ISNULL([Sales].pcp$, 0))
			--ORDER BY dbo.Divide((ISNULL([Receivables].receivables,0) + ISNULL([WO1].WriteOffs, 0))
			--		,ISNULL([Sales].nb2$, 0))
		END
	ELSE
		BEGIN
			SELECT CASE WHEN [Center].Type = 'C' THEN 'Corporate' ELSE 'Franchise' END AS 'Type'
			,	[tblRegion].Region
			,	tblRegion.[RegionID]
			,	Center.Center_Num
			,	CONVERT(VARCHAR(3),[Center].center_num) + ' - ' + [Center].center AS 'Center'
			,	ISNULL([Sales].nb2$, 0) AS 'nb2$'
			,	ISNULL([Sales].pcp$, 0) AS 'pcp$'
			,	ISNULL([Receivables].receivables,0) 'receivables'
			,	dbo.Divide(ISNULL([Receivables].receivables,0),ISNULL([Sales].nb2$, 0)) AS 'recievablesPercent'
			,	dbo.Divide((ISNULL([Receivables].receivables,0) + ISNULL([WO1].WriteOffs, 0))
					,ISNULL([Sales].nb2$, 0)) AS 'AR_WO_Percent'
			,	dbo.Divide((ISNULL([Receivables].receivables,0))
					,ISNULL([Sales].pcp$, 0)) AS 'AR_PCP_Percent'
			,	ISNULL(WO1.Writeoffs,0) AS 'MONTH1'
			,	ISNULL(WO2.Writeoffs,0) AS 'MONTH2'
			,	ISNULL(WO3.Writeoffs,0) AS 'MONTH3'
			,	ISNULL(WO4.Writeoffs,0) AS 'MONTH4'
			,	ISNULL(WO5.Writeoffs,0) AS 'MONTH5'
			,	ISNULL(WO6.Writeoffs,0) AS 'MONTH6'
			FROM HCFMDirectory.dbo.tblcenter AS Center
				LEFT JOIN @Sales [Sales]
					ON [Center].center_num=[Sales].CenterID
				LEFT OUTER JOIN @Receivables [Receivables]
					ON [Center].center_num=[Receivables].CenterID
				LEFT OUTER JOIN hcfmdirectory.dbo.tblRegion tblRegion
					ON [Center].regionID=tblRegion.RegionID
				LEFT OUTER JOIN #WO_Months1 [WO1]
					ON [Center].center_num=[WO1].CenterID
				LEFT OUTER JOIN #WO_Months2 [WO2]
					ON [Center].center_num=[WO2].CenterID
				LEFT OUTER JOIN #WO_Months3 [WO3]
					ON [Center].center_num=[WO3].CenterID
				LEFT OUTER JOIN #WO_Months4 [WO4]
					ON [Center].center_num=[WO4].CenterID
				LEFT OUTER JOIN #WO_Months5 [WO5]
					ON [Center].center_num=[WO5].CenterID
				LEFT OUTER JOIN #WO_Months6 [WO6]
					ON [Center].center_num=[WO6].CenterID
			WHERE [Center].center_num LIKE '[678]__'
				AND [Center].INACTIVE = 0
				AND [Center].CMS = 1
				AND [Center].center_num NOT IN (279)
			ORDER BY dbo.Divide((ISNULL([Receivables].receivables,0))
					,ISNULL([Sales].pcp$, 0))
		END
END
