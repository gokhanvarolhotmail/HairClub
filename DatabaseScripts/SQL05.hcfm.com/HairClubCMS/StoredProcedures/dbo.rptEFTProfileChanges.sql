/* CreateDate: 01/09/2014 11:04:00.513 , ModifyDate: 01/09/2014 11:04:00.513 */
GO
/*===============================================================================================
-- Procedure Name:				rptEFTProfileChanges
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
Sample Execution:
EXEC rptEFTProfileChanges '12/1/2013','12/31/2013',292,'0487CDCD-C1F7-4D0A-9531-E4F41B15737A'

EXEC rptEFTProfileChanges '12/1/2013','12/31/2013',292,'All'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptEFTProfileChanges]
	@StartDate DATETIME
,	@EndDate DATETIME
,	@CenterID INT
,	@ClientGUID NVARCHAR(50)
AS
BEGIN

	IF @ClientGUID = 'All'
	BEGIN

		SELECT clt.CenterID
		,	c.CenterDescriptionFullCalc
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
			INNER JOIN lkpClientProcess as cp
				ON ct.ClientPRocessID = cp.ClientProcessID
			LEFT OUTER JOIN lkpFeePayCycle fpc1
				ON ct.PreviousFeePayCycleID = fpc1.FeePayCycleID
			LEFT OUTER JOIN lkpFeePayCycle fpc2
				ON ct.FeePayCycleID = fpc2.FeePayCycleID
		WHERE ct.TransactionDate BETWEEN @StartDate AND @EndDate
			AND clt.CenterID = @CenterID
		ORDER BY c.CenterID
			,	clt.ClientFullNameCalc
			,	ct.TransactionDate
	END
	ELSE
	BEGIN
		SELECT clt.CenterID
		,	c.CenterDescriptionFullCalc
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
			INNER JOIN lkpClientProcess as cp
				ON ct.ClientPRocessID = cp.ClientProcessID
			LEFT OUTER JOIN lkpFeePayCycle fpc1
				ON ct.PreviousFeePayCycleID = fpc1.FeePayCycleID
			LEFT OUTER JOIN lkpFeePayCycle fpc2
				ON ct.FeePayCycleID = fpc2.FeePayCycleID
		WHERE ct.TransactionDate BETWEEN @StartDate AND @EndDate
			AND clt.CenterID = @CenterID
			AND ct.ClientGUID = @ClientGUID
		ORDER BY c.CenterID
			,	clt.ClientFullNameCalc
			,	ct.TransactionDate
	END

END
GO
