/* CreateDate: 08/30/2012 16:58:41.513 , ModifyDate: 11/21/2019 14:51:21.377 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE: 	[spRpt_FranchiseWarBoards_Manager]
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
	11/21/2019 - RH - (TrackIT #2159) Changed the fields to match the [spRpt_WarBoardRecurringBusinessByRegion]
NOTES:
WHEN FIELDS CHANGE IN THESE STORED PROCEDURES [spRpt_WarBoardRecurringBusiness], [spRpt_WarBoardRecurringBusiness_Groups] and [spRpt_WarBoardRecurringBusinessByRegion] ALSO CHANGE THEM
IN THIS STORED PROCEDURE.
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC [spRpt_FranchiseWarBoards_Manager] 11, 2019
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseWarBoards_Manager]
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
CREATE TABLE #FranchiseNB2(
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterID INT
,	CenterDescriptionNumber VARCHAR(104)

,	BIOConversions INT
,	Applications INT
,	ConversionsToAppsPercent  DECIMAL(18,4)

,	EXTXTRConversion INT
,	EXTXTRSales INT
,	EXTXTRConversionsToEXTXTRSalesPercent DECIMAL(18,4)

,	CurrentPCP INT
,	LastPCP INT
,	RollingPCPPercent DECIMAL(18,4)

,	Upgrade INT
,	Downgrade INT
,	NetUpgrades INT
,	PCPCountPercent DECIMAL(18,4)
,	Benchmark DECIMAL(18,4)
,	UpgradePercent DECIMAL(18,4)

,	Total_Franchise DECIMAL(18,4)
)

INSERT INTO #FranchiseNB2
EXEC [spRpt_WarBoardRecurringBusinessByRegion] @Month, @Year, 0, 2




SELECT RANK() OVER (ORDER BY Total_Franchise) + 1 AS 'NB2Rank'
,	MainGroup AS 'Region'
,	CenterID AS 'Center'
,	CenterDescriptionNumber AS 'CenterName'
,	Total_Franchise AS 'NB2TotalPoints'
INTO #NB2Final
FROM #FranchiseNB2



/***********************************************************************/
-- Return final result set to report
/***********************************************************************/
SELECT f.CenterName
,	f.Region
,	f.NB1Rank AS 'NB1TotalPoints'
,	f2.NB2Rank AS 'NB2TotalPoints'
,	(f.NB1Rank + f2.NB2Rank) AS 'Total'
FROM #NB1Final f
	INNER JOIN #NB2Final f2
		ON f.Center = f2.Center


END
GO
