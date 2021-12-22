/*===============================================================================================
-- Procedure Name:				[rptEFTProfileChanges_SP]
-- Procedure Description:
--
-- Created By:					Rachelen Hut
-- Implemented By:				Rachelen Hut
-- Last Modified By:			Rachelen Hut
--
-- Date Created:				12/20/13
-- Date Implemented:
-- Date Last Modified:			12/20/13
--
-- Destination Server:			HairclubCMS
-- Destination Database:
-- Related Application:			Hairclub CMS
================================================================================================
**NOTES**
================================================================================================
CHANGE HISTORY:

04/30/2015 - RH - Added code for @CenterID to allow Corporate or Franchise All
05/19/2015 - DL - Added code to include Franchise centers when a specific center is selected (#114755)
================================================================================================
Sample Execution:
EXEC rptEFTProfileChanges_SP '4/1/2015','4/30/2015',292,'260B1960-B340-4A59-B510-12762151F5F9'

EXEC rptEFTProfileChanges_SP '4/1/2015','4/30/2015',1,'All'

EXEC rptEFTProfileChanges_SP '4/1/2015','4/30/2015',1,'All'

EXEC [rptEFTProfileChanges_SP] '4/1/2015','4/30/2015',2,'All'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptEFTProfileChanges_SP]
	@StartDate DATETIME
,	@EndDate DATETIME
,	@CenterID INT
,	@ClientGUID NVARCHAR(50)
AS
BEGIN
	CREATE TABLE #Centers (
		CenterID INT
	,	CenterDescriptionFullCalc VARCHAR(50)
	,	RegionDescription VARCHAR(50)
	,	RegionID INT
	,	RegionSortOrder INT
	)

	IF @CenterID = 1 --Corporate
	BEGIN
		INSERT INTO #Centers
			SELECT  cfg.CenterID
            ,       cfg.CenterDescriptionFullCalc
            ,       r.RegionDescription
            ,       r.RegionID
			,		r.RegionSortOrder
			FROM    cfgCenter cfg
					INNER JOIN dbo.lkpRegion r
						ON cfg.RegionID = r.RegionID
			WHERE   CONVERT(VARCHAR, cfg.CenterID) LIKE '[2]%'
					AND cfg.IsActiveFlag = 1
	END
	ELSE
	IF @CenterID = 2 --Franchise
	BEGIN
	INSERT INTO #Centers
				SELECT  cfg.CenterID
            ,       cfg.CenterDescriptionFullCalc
            ,       r.RegionDescription
            ,       r.RegionID
			,		r.RegionSortOrder
			FROM    cfgCenter cfg
					INNER JOIN dbo.lkpRegion r
						ON cfg.RegionID = r.RegionID
			WHERE   CONVERT(VARCHAR, cfg.CenterID) LIKE '[78]%'
					AND cfg.IsActiveFlag = 1
	END
	ELSE
	IF @CenterID > 2  --Then a specific center has been selected
	BEGIN
	INSERT INTO #Centers
				SELECT  cfg.CenterID
            ,       cfg.CenterDescriptionFullCalc
            ,       r.RegionDescription
            ,       r.RegionID
			,		r.RegionSortOrder
			FROM    cfgCenter cfg
					INNER JOIN dbo.lkpRegion r
						ON cfg.RegionID = r.RegionID
			WHERE   CONVERT(VARCHAR, cfg.CenterID) LIKE '[278]%'
					AND cfg.IsActiveFlag = 1
					AND CenterID = @CenterID
	END

			--SELECT * FROM #Centers


	IF @ClientGUID = 'All'
	BEGIN

		SELECT ctr.RegionID
		,	ctr.RegionDescription
		,	ctr.RegionSortOrder
		,	ctr.CenterID
		,	ctr.CenterDescriptionFullCalc
		,	clt.ClientFullNameCalc
		,	ct.TransactionDate
		,	cp.ClientProcessDescription
		,	CASE WHEN ct.ClientProcessID = 1 THEN CONVERT(nvarchar,ct.PreviousEFTFreezeStartDate,101)
				WHEN ct.ClientProcessID = 2 THEN CONVERT(nvarchar,ct.PreviousEFTFreezeEndDate, 101)
				WHEN ct.ClientProcessID = 3 THEN CONVERT(nvarchar,ct.PreviousEFTHoldEndDate,101)
				WHEN ct.ClientProcessID = 4 THEN CONVERT(nvarchar,ct.PreviousEFTHoldStartDate,101)
				WHEN ct.ClientProcessID = 5 THEN CONVERT(nvarchar,ct.PreviousCCNumber)
				WHEN ct.ClientProcessID = 6 THEN CONVERT(nvarchar,ct.PreviousCCExpirationDate,101)
				WHEN ct.ClientProcessID = 7 THEN CONVERT(nvarchar,fpc1.FeePayCycleDescription)
				WHEN ct.ClientProcessID = 8 THEN CONVERT(nvarchar,ct.PreviousMonthlyFeeAmount)
			END BeginningValue
		,	CASE WHEN ct.ClientProcessID = 1 THEN CONVERT(nvarchar,ct.EFTFreezeStartDate,101)
				WHEN ct.ClientProcessID = 2 THEN CONVERT(nvarchar,ct.EFTFreezeEndDate,101)
				WHEN ct.ClientProcessID = 3 THEN CONVERT(nvarchar,ct.EFTHoldEndDate,101)
				WHEN ct.ClientProcessID = 4 THEN CONVERT(nvarchar,ct.EFTHoldStartDate,101)
				WHEN ct.ClientProcessID = 5 THEN CONVERT(nvarchar,ct.CCNumber)
				WHEN ct.ClientProcessID = 6 THEN CONVERT(nvarchar,ct.CCExpirationDate,101)
				WHEN ct.ClientProcessID = 7 THEN CONVERT(nvarchar,fpc2.FeePayCycleDescription)
				WHEN ct.ClientProcessID = 8 THEN CONVERT(nvarchar,ct.MonthlyFeeAmount)
			END EndingValue
		,	ct.CreateUser as EnteredBy
		FROM datClientTransaction ct
			INNER JOIN datClient clt
				ON ct.ClientGUID = clt.ClientGUID
			INNER JOIN cfgCenter c
				ON clt.CenterID = c.CenterID
			INNER JOIN #Centers ctr
				ON clt.CenterID = ctr.CenterID
			INNER JOIN lkpClientProcess as cp
				ON ct.ClientPRocessID = cp.ClientProcessID
			LEFT OUTER JOIN lkpFeePayCycle fpc1
				ON ct.PreviousFeePayCycleID = fpc1.FeePayCycleID
			LEFT OUTER JOIN lkpFeePayCycle fpc2
				ON ct.FeePayCycleID = fpc2.FeePayCycleID
		WHERE ct.TransactionDate BETWEEN @StartDate AND @EndDate
	END
	ELSE
	BEGIN
		SELECT ctr.RegionID
		,	ctr.RegionDescription
		,	ctr.RegionSortOrder
		,	ctr.CenterID
		,	ctr.CenterDescriptionFullCalc
		,	clt.ClientFullNameCalc
		,	ct.TransactionDate
		,	cp.ClientProcessDescription
		,	CASE WHEN ct.ClientProcessID = 1 THEN CONVERT(nvarchar,ct.PreviousEFTFreezeStartDate,101)
				WHEN ct.ClientProcessID = 2 THEN CONVERT(nvarchar,ct.PreviousEFTFreezeEndDate, 101)
				WHEN ct.ClientProcessID = 3 THEN CONVERT(nvarchar,ct.PreviousEFTHoldEndDate,101)
				WHEN ct.ClientProcessID = 4 THEN CONVERT(nvarchar,ct.PreviousEFTHoldStartDate,101)
				WHEN ct.ClientProcessID = 5 THEN CONVERT(nvarchar,ct.PreviousCCNumber)
				WHEN ct.ClientProcessID = 6 THEN CONVERT(nvarchar,ct.PreviousCCExpirationDate,101)
				WHEN ct.ClientProcessID = 7 THEN CONVERT(nvarchar,fpc1.FeePayCycleDescription)
				WHEN ct.ClientProcessID = 8 THEN CONVERT(nvarchar,ct.PreviousMonthlyFeeAmount)
			END BeginningValue
		,	CASE WHEN ct.ClientProcessID = 1 THEN CONVERT(nvarchar,ct.EFTFreezeStartDate,101)
				WHEN ct.ClientProcessID = 2 THEN CONVERT(nvarchar,ct.EFTFreezeEndDate,101)
				WHEN ct.ClientProcessID = 3 THEN CONVERT(nvarchar,ct.EFTHoldEndDate,101)
				WHEN ct.ClientProcessID = 4 THEN CONVERT(nvarchar,ct.EFTHoldStartDate,101)
				WHEN ct.ClientProcessID = 5 THEN CONVERT(nvarchar,ct.CCNumber)
				WHEN ct.ClientProcessID = 6 THEN CONVERT(nvarchar,ct.CCExpirationDate,101)
				WHEN ct.ClientProcessID = 7 THEN CONVERT(nvarchar,fpc2.FeePayCycleDescription)
				WHEN ct.ClientProcessID = 8 THEN CONVERT(nvarchar,ct.MonthlyFeeAmount)
			END EndingValue
		,	ct.CreateUser as EnteredBy
		FROM datClientTransaction ct
			INNER JOIN datClient clt
				ON ct.ClientGUID = clt.ClientGUID
			INNER JOIN cfgCenter c
				ON clt.CenterID = c.CenterID
			INNER JOIN #Centers ctr
				ON clt.CenterID = ctr.CenterID
			INNER JOIN lkpClientProcess as cp
				ON ct.ClientPRocessID = cp.ClientProcessID
			LEFT OUTER JOIN lkpFeePayCycle fpc1
				ON ct.PreviousFeePayCycleID = fpc1.FeePayCycleID
			LEFT OUTER JOIN lkpFeePayCycle fpc2
				ON ct.FeePayCycleID = fpc2.FeePayCycleID
		WHERE ct.TransactionDate BETWEEN @StartDate AND @EndDate
			AND clt.CenterID = @CenterID
			AND ct.ClientGUID = @ClientGUID

	END

END
