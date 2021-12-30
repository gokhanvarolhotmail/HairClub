/* CreateDate: 03/07/2016 14:28:19.207 , ModifyDate: 03/06/2017 15:20:35.953 */
GO
/***********************************************************************
PROCEDURE: 	[spRpt_FranchiseWarBoards_Manager_TEST]
 Created By:             HDu
 Implemented By:         HDu
 Last Modified By:       HDu

 Date Created:           8/29/2012
 Date Implemented:       8/29/2012

 Destination Server:	SQL06
 Destination Database:	HC_BI_Reporting

 ----------------------------------------------------------------------------------------------

	09/20/2013 - MB - Changed NB2 War Board data to come from new combined Corp and Fran stored procedure (WO# 91245)
	03/05/2014 - RH - Added fields for the Franchise version of the report - WarBoard_Franchise_RecurringCustomer.rdl
						FranchiseConversionsToAppsPercent, Total_Franchise; Added fields for the new budget version - BIOConversions_Budget,
						BIOConversionsToBudgetPercent, EXTConversions_Budget, EXTConversionsToBudgetPercent, Total_Budget
	06/09/2014 - RH - Added columns XtrandsConversions and XtrandsConversion_Budget (The SSRS report has not been changed).
	06/30/2015 - RH - Added column XtrandsConversionsToBudgetPercent
	03/09/2016 - RH - Removed references to [spRpt_WarBoardRecurringBusinessByRegion]
	03/06/2017 - RH - (#136062) Added @XTRPlusConversionsToBudget_Cap of 2.00; Added @NetUpgrades_Cap of 1.25
NOTES:
WHEN FIELDS CHANGE IN THESE STORED PROCEDURES [spRpt_WarBoardRecurringBusiness], [spRpt_WarBoardRecurringBusiness_Groups] and [spRpt_WarBoardRecurringBusinessByRegion] ALSO CHANGE THEM
IN THIS STORED PROCEDURE.
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [spRpt_FranchiseWarBoards_Manager_TEST] 1, 2016
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseWarBoards_Manager_TEST]
	@Month TINYINT
,	@Year	int
AS

BEGIN

	SET FMTONLY OFF
	SET NOCOUNT OFF

	--Get values from Franchise NB1 War Board
	CREATE TABLE #FranchiseNB1 (
		Region VARCHAR(50)
	,	CenterID INT
	,	CenterName VARCHAR(100)
	,	Closing FLOAT
	,	ClosingGoal FLOAT
	,	ClosingPercentage FLOAT
	,	ClosingPoints FLOAT
	,	DollarPerSale FLOAT
	,	DollarPerSaleGoal FLOAT
	,	DollarPerSalePercentage FLOAT
	,	DollarPerSalePoints FLOAT
	,	HairSalesMix FLOAT
	,	HairSalesMixGoal FLOAT
	,	HairSalesMixPercentage FLOAT
	,	HairSalesMixPoints FLOAT
	,	NB1TotalPoints FLOAT
	)

	INSERT INTO #FranchiseNB1
	EXEC [spRpt_FranchiseWarBoards_NB1] @Month, @Year


	SELECT RANK() OVER (ORDER BY NB1TotalPoints) + 1 AS 'NB1Rank'
	,	Region
	,	CenterID AS 'Center'
	,	CenterName
	,	NB1TotalPoints AS 'NB1TotalPoints'
	INTO #NB1Final
	FROM #FranchiseNB1

	--Get values from Franchise NB2 War Board
	CREATE TABLE #FranchiseNB2 (RegionSSID INT
		,	CenterID INT
		,	CenterDescriptionNumber VARCHAR(50)
		,	RegionDescription VARCHAR(50)
		,	XTRPlusConversions INT
		,	XTRPlusConversions_Budget INT
		,	XTRPlusConversionsToBudgetPercent DECIMAL(18,4)
		,	EXTandXTRConversions INT
		,	EXTandXTRConversions_Budget INT
		,	EXTandXTRConversionsToBudgetPercent DECIMAL(18,4)
		,	Upgrade INT
		,	UpgradeGoal  DECIMAL(18,4)
		,	UpgradePercent  DECIMAL(18,4)
		,	PCPLastMonth INT
		,	PCPRevenueLastMonth INT
		,	PCPRevenueLastMonth_Budget INT
		,	PCPRevenueToBudgetPercent DECIMAL(18,4)
		,	Total DECIMAL(18,4)
	)

	INSERT INTO #FranchiseNB2
	EXEC [spRpt_WarBoardRecurringBusiness] @Month, @Year, 0, 2




	SELECT RANK() OVER (ORDER BY Total) + 1 AS 'NB2Rank'
	,	RegionDescription AS 'Region'
	,	CenterID AS 'Center'
	,	CenterDescriptionNumber AS 'CenterName'
	,	Total AS 'NB2TotalPoints'
	INTO #NB2Final
	FROM #FranchiseNB2



	/***********************************************************************/
	-- Return final result set to report
	/***********************************************************************/
	SELECT f.CenterName
	,	f.Region
	,NB1Rank AS 'NB1TotalPoints'
	,NB2Rank AS 'NB2TotalPoints'
	,NB1Rank + NB2Rank AS 'Total'
	FROM #NB1Final f
		INNER JOIN #NB2Final f2
			ON f.Center = f2.Center
END
GO
