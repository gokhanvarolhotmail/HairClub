/* CreateDate: 05/14/2012 17:34:46.580 , ModifyDate: 05/08/2019 15:25:42.230 */
GO
/***********************************************************************

PROCEDURE:				rptFeeSummaryByCategory

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/04/2011

LAST REVISION DATE: 	08/04/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT summary by Category for the specified Pay Cycle, Month, Year, and Center for the specified month.

		08/04/2011 - AS: Created Stored Proc
		06/11/2012 - MLM: Added Tax into the Fee Totals
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptFeeSummaryByCategory 1, 8, 2011, 203

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxrptFeeSummaryByCategory]
	@feePayCycleId as int,
	@month as int,
	@year as int,
	@centerId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MonthlyFeeSalesCodeID int
	SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'

	DECLARE @PayCycleValue int
	SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @feePayCycleId)

	IF @PayCycleValue IS NULL
		RETURN

	DECLARE @BatchRunDate datetime
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@year), 101)


	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		ClientEFTGUID uniqueidentifier,
		Amount money NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientEFTGUID, Amount, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired)
		SELECT
			c.ClientEFTGUID,
			ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))),

			-- EFT Profile is active
			CASE
				WHEN c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0
						OR stat.IsEFTActiveFlag IS NULL OR stat.IsEFTActiveFlag = 0
				THEN 1 ELSE 0 END,

			-- Account is not Frozen
			CASE
				WHEN c.Freeze_Start IS NULL
							OR (c.Freeze_End IS NULL AND  @BatchRunDate < c.Freeze_Start)
							OR (c.Freeze_End IS NOT NULL AND (@BatchRunDate < c.Freeze_Start
									OR @BatchRunDate > c.Freeze_End))
				THEN 0 ELSE 1 END,

			-- Credit Card Not Expired
			CASE
				WHEN at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND @BatchRunDate <= c.AccountExpiration
					THEN 0 ELSE 1 END,

			-- Membership is  Active
			CASE
				WHEN cm.BeginDate IS NULL OR (cm.BeginDate <= @BatchRunDate
								AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= @BatchRunDate)
				THEN 0 ELSE 1 END
		FROM datClientEFT c
		 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
		 INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = (SELECT Top(1) clMem.ClientMembershipGUID
												FROM datClientMembership clMem
													INNER JOIN cfgMembership m ON m.MembershipID = clMem.MembershipID
													INNER JOIN lkpClientMembershipStatus cms ON clMem.ClientMembershipStatusID = cms.ClientMembershipStatusID
												WHERE clMem.ClientGUID = c.ClientGUID
													AND cms.ClientMembershipStatusDescriptionShort = 'A'
													AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
												ORDER BY clMem.EndDate desc)
		 INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
		 INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID
		 LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
		 LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
		 -- Tax Calculation
		 LEFT OUTER JOIN cfgSalesCodeCenter scc ON cl.CenterID = scc.CenterID
				AND scc.SalesCodeID = @MonthlyFeeSalesCodeID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 on scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 on scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
		 LEFT OUTER JOIN cfgSalesCodeMembership scm on scc.SalesCodeCenterID = scm.SalesCodeCenterID
				AND scm.MembershipID = memb.MembershipID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1 on scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
		 LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2 on scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
		WHERE pc.FeePayCycleId = @feePayCycleId
			AND cl.CenterID = @centerId


	--- Totals Temp Table
	DECLARE @Totals TABLE
	(
		FeeTotal money NOT NULL,
		ProfileExpiredCount int NOT NULL,
		ProfileFrozenCount int NOT NULL,
		CreditCardExpiredCount int NOT NULL,
		MembershipExpiredCount int NOT NULL,
		ProfileExpiredAmount money NOT NULL,
		ProfileFrozenAmount money NOT NULL,
		CreditCardExpiredAmount money NOT NULL,
		MembershipExpiredAmount money NOT NULL,
		NoAmountCount int NOT NULL,
		WontRunCount int NOT NULL,
		WontRunAmount money NOT NULL
	)


	INSERT INTO @Totals (
		FeeTotal,
		ProfileExpiredCount,
		ProfileFrozenCount,
		CreditCardExpiredCount,
		MembershipExpiredCount,
		ProfileExpiredAmount,
		ProfileFrozenAmount,
		CreditCardExpiredAmount,
		MembershipExpiredAmount,
		NoAmountCount,
		WontRunCount,
		WontRunAmount)
	SELECT
		SUM(estat.Amount),

		SUM(CASE WHEN estat.IsProfileExpired = 1 THEN 1 ELSE 0 END),		-- EFT prifile expired count
		SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN 1 ELSE 0 END),		-- Profile frozen count
		SUM(CASE WHEN estat.IsCreditCardExpired = 1 THEN 1 ELSE 0 END),	-- Credit card expired count
		SUM(CASE WHEN estat.IsMembershipExpired = 1 THEN 1 ELSE 0 END),	-- Membership expired count

		SUM(CASE WHEN estat.IsProfileExpired = 1 THEN estat.Amount ELSE 0 END),		-- EFT prifile expired amount
		SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN estat.Amount ELSE 0 END),		-- Profile frozen amount
		SUM(CASE WHEN estat.IsCreditCardExpired = 1 THEN estat.Amount ELSE 0 END),	-- Credit card expired amount
		SUM(CASE WHEN estat.IsMembershipExpired = 1 THEN estat.Amount ELSE 0 END),	-- Membership expired amount

		SUM(CASE WHEN estat.Amount = 0 THEN 1 ELSE 0 END),

		SUM(CASE WHEN estat.IsProfileExpired = 1 OR estat.IsProfileFrozen = 1
				OR estat.IsCreditCardExpired = 1 OR estat.IsMembershipExpired = 1 THEN 1 ELSE 0 END),
		SUM(CASE WHEN estat.IsProfileExpired = 1 OR estat.IsProfileFrozen = 1
				OR estat.IsCreditCardExpired = 1 OR estat.IsMembershipExpired = 1 THEN estat.Amount ELSE 0 END)
	FROM @ClientEFTStatus estat


	-- Results temp table
	DECLARE @Results TABLE
	(
		SortOrder int NOT NULL,
		Category nvarchar(100) NOT NULL,
		CountTotal int NOT NULL,
		AmountTotal money NOT NULL,
		PercentAmount decimal(38,2) NOT NULL
	)


	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			0,
			'Memberships Expired',
			MembershipExpiredCount,
			MembershipExpiredAmount,
			CASE WHEN t.FeeTotal = 0 THEN 0 ELSE (t.MembershipExpiredAmount/t.FeeTotal) END
		FROM @Totals t

	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			1,
			'EFT Profiles Expired',
			ProfileExpiredCount,
			ProfileExpiredAmount,
			CASE WHEN t.FeeTotal = 0 THEN 0 ELSE (t.ProfileExpiredAmount/t.FeeTotal) END
		FROM @Totals t

	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			3,
			'C.C.s Expired',
			CreditCardExpiredCount,
			CreditCardExpiredAmount,
			CASE WHEN t.FeeTotal = 0 THEN 0 ELSE (t.CreditCardExpiredAmount/t.FeeTotal) END
		FROM @Totals t

	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			4,
			'Frozen',
			ProfileFrozenCount,
			ProfileFrozenAmount,
			CASE WHEN t.FeeTotal = 0 THEN 0 ELSE (t.ProfileFrozenAmount/t.FeeTotal) END
		FROM @Totals t

	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			5,
			'Monthly Fees Equal to Zero',
			t.NoAmountCount,
			0,
			0
		FROM @Totals t

	INSERT INTO @Results (SortOrder, Category, CountTotal,AmountTotal, PercentAmount)
		SELECT
			6,
			'Clients Who Wont Run',
			WontRunCount,
			WontRunAmount,
			CASE WHEN t.FeeTotal = 0 THEN 0 ELSE (t.WontRunAmount/t.FeeTotal) END
		FROM @Totals t


	--- Return Results
	SELECT *
	FROM @Results
	ORDER BY SortOrder

END
GO
