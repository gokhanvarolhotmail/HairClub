/***********************************************************************

PROCEDURE:				rptDeclineSummaryByMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		06/17/2013

LAST REVISION DATE: 	06/17/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT summary by Membership for the specified Decline Batch
		06/17/2013 - MLM: Created Stored Proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptDeclineSummaryByMembership '6/17/13', 201

***********************************************************************/
CREATE PROCEDURE [dbo].[rptDeclineSummaryByMembership]
	@DeclineBatchDate as DateTime,
	@centerId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MonthlyFeeSalesCodeID int
	SELECT @MonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'


	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		ClientEFTGUID uniqueidentifier,
		Amount money NOT NULL,
		MembershipDescription nvarchar(50) NOT NULL,
		MembershipId int NOT NULL,
		IsProfileExpired bit NOT NULL,
		IsProfileFrozen bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		IsFeeAmountZero bit NOT NULL,
		IsValidToRun bit NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientEFTGUID, Amount, MembershipDescription, MembershipId, IsProfileExpired, IsProfileFrozen, IsCreditCardExpired, IsMembershipExpired, IsFeeAmountZero)
		SELECT
			c.ClientEFTGUID,
			ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))),
			memb.MembershipDescription,
			memb.MembershipId,

			-- EFT Profile is active
			CASE
				WHEN c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0
						OR stat.IsEFTActiveFlag IS NULL OR stat.IsEFTActiveFlag = 0
				THEN 1 ELSE 0 END,

			-- Account is not Frozen
			CASE
				WHEN (c.Freeze_Start IS NULL AND c.Freeze_End IS NULL)
							OR (c.Freeze_End IS NULL AND  @DeclineBatchDate < c.Freeze_Start)
							OR (c.Freeze_Start IS NULL AND  @DeclineBatchDate > c.Freeze_End)
							OR (@DeclineBatchDate < c.Freeze_Start OR @DeclineBatchDate > c.Freeze_End)
				THEN 0 ELSE 1 END,

			-- Credit Card Not Expired
			CASE
				WHEN (at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND @DeclineBatchDate <= c.AccountExpiration)
					  OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard')
					THEN 0 ELSE 1 END,

			-- Membership is  Active
			CASE
				WHEN cm.BeginDate IS NULL OR (cm.BeginDate <= @DeclineBatchDate
								AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= @DeclineBatchDate)
				THEN 0 ELSE 1 END,

			-- Fee Amount is Zero
			CASE
				WHEN ISNULL(cm.MonthlyFee, 0) > 0 THEN 0 ELSE 1 END

		FROM datClientEFT c
		 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
		 INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = c.ClientMembershipGUID and cm.ClientGUID = c.ClientGUID
		 INNER JOIN cfgMembership memb ON memb.MembershipID = cm.MembershipID
		 INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		 INNER JOIN datPayCycleTransaction pct on c.ClientGUID = pct.ClientGUID
		 INNER JOIN datCenterDeclineBatch decline on pct.CenterDeclineBatchGUID = decline.CenterDeclineBatchGUID
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
		WHERE  CONVERT(nvarchar(10),decline.RunDate,101) = @DeclineBatchDate
			AND cl.CenterID = @centerId
			AND cms.ClientMembershipStatusDescriptionShort = 'A'
			AND memb.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')



	-- Update if client EFT profile is valid to run
	UPDATE @ClientEFTStatus SET
		IsValidToRun = CASE WHEN IsProfileExpired = 0
								AND IsCreditCardExpired = 0 AND IsMembershipExpired = 0 AnD IsFeeAmountZero = 0 THEN 1 ELSE 0 END



	DECLARE @FeeTotal AS money, @WillRunTotal As money, @WontRunTotal AS money,  @ExceptionsTotal as money, @FrozenTotal AS money

	SELECT
		@FeeTotal = SUM(estat.Amount),
		@ExceptionsTotal = SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN estat.Amount ELSE 0 END),
		@FrozenTotal = SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN estat.Amount ELSE 0 END),
		@WillRunTotal = SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0  THEN estat.Amount ELSE 0 END),
		@WontRunTotal = SUM(CASE WHEN estat.IsValidToRun = 0 OR estat.IsProfileFrozen = 1  THEN estat.Amount ELSE 0 END)
	FROM @ClientEFTStatus estat


	SELECT
		estat.MembershipId,
		estat.MembershipDescription,
		COUNT(estat.MembershipDescription) AS MembershipCount,
		SUM(estat.Amount) AS MembershipTotal,
		CASE WHEN @FeeTotal = 0 THEN 0 ELSE (SUM(estat.Amount)/@FeeTotal) END AS TotalPercent,

		SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN 1 ELSE 0 END) AS ExceptionsCount,
		SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN estat.Amount ELSE 0 END) AS ExceptionsAmount,
		CASE WHEN @ExceptionsTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 0 AND estat.IsProfileFrozen <> 1 THEN estat.Amount ELSE 0 END)/@ExceptionsTotal) END AS ExceptionsPercent,

		SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN 1 ELSE 0 END) AS FrozenCount,
		SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN estat.Amount ELSE 0 END) AS FrozenAmount,
		CASE WHEN @FrozenTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsProfileFrozen = 1 THEN estat.Amount ELSE 0 END)/@FrozenTotal) END AS FrozenPercent,

		SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN 1 ELSE 0 END) AS WillRunCount,
		SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN estat.Amount ELSE 0 END) AS WillRunAmount,
		CASE WHEN @WillRunTotal = 0 THEN 0 ELSE (SUM(CASE WHEN estat.IsValidToRun = 1 AND estat.IsProfileFrozen = 0 THEN estat.Amount ELSE 0 END)/@WillRunTotal) END AS WillRunPercent

	FROM @ClientEFTStatus estat
	GROUP BY estat.MembershipDescription,
		estat.MembershipId

END
