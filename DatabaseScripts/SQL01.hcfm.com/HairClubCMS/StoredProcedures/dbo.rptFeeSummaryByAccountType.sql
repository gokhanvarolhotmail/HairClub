/***********************************************************************

PROCEDURE:				rptFeeSummaryByAccountType

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/08/2011

LAST REVISION DATE: 	08/08/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT summary by Account Type for the specified Pay Cycle, Month, Year, and Center.

		08/04/2011 - AS: Created Stored Proc
		06/11/2012 - MLM: Added Tax into the Fee Totals
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptFeeSummaryByAccountType 1, 8, 2011, 203

***********************************************************************/
CREATE PROCEDURE [dbo].[rptFeeSummaryByAccountType]
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
		AccountTypeId int NOT NULL,
		Amount money NOT NULL,
		MembershipDescription nvarchar(50) NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		IsValidToRun bit NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientEFTGUID, AccountTypeId, Amount, MembershipDescription, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired)
		SELECT
			c.ClientEFTGUID,
			c.EFTAccountTypeId,
			ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))),
			memb.MembershipDescriptionShort,

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


	-- Update if client EFT profile is valid to run
	UPDATE @ClientEFTStatus SET
		IsValidToRun = CASE WHEN IsProfileExpired = 0 AND IsProfileFrozen = 0
								AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 THEN 1 ELSE 0 END


	DECLARE @FeeTotal AS money, @WillRunTotal As money, @WontRunTotal AS money

	SELECT
		@FeeTotal = SUM(estat.Amount),
		@WillRunTotal = SUM(CASE WHEN estat.IsValidToRun = 1 THEN estat.Amount ELSE 0 END),
		@WontRunTotal = SUM(CASE WHEN estat.IsValidToRun = 0 THEN estat.Amount ELSE 0 END)
	FROM @ClientEFTStatus estat


	SELECT
		at.EFTAccountTypeDescription AS AccountType,

		COUNT(estat.AccountTypeId) AS FeeCount,
		SUM(estat.Amount) AS FeeTotal,
		CASE WHEN @FeeTotal = 0 THEN 0 ELSE (SUM(estat.Amount)/@FeeTotal) END AS TotalPercent,

		SUM(CASE WHEN estat.IsValidToRun = 0 THEN 1 ELSE 0 END) AS WontRunCount,
		SUM(CASE WHEN estat.IsValidToRun = 0 THEN estat.Amount ELSE 0 END) AS WontRunAmount,
		CASE WHEN @WontRunTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 0 THEN estat.Amount ELSE 0 END)/@WontRunTotal) END AS WontRunPercent,

		SUM(CASE WHEN estat.IsValidToRun = 1 THEN 1 ELSE 0 END) AS WillRunCount,
		SUM(CASE WHEN estat.IsValidToRun = 1 THEN estat.Amount ELSE 0 END) AS WillRunAmount,
		CASE WHEN @WillRunTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 1 THEN estat.Amount ELSE 0 END)/@WillRunTotal) END AS WillRunPercent

	FROM @ClientEFTStatus estat
		INNER JOIN lkpEFTAccountType at ON estat.AccountTypeId = at.EFTAccountTypeId
	GROUP BY estat.AccountTypeId,
		at.EFTAccountTypeDescription

END
