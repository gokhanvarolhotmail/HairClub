/***********************************************************************

PROCEDURE:				rptDeclineExceptions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		06/17/2013

LAST REVISION DATE: 	06/17/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Return EFT Exceptions for Declines

		06/17/2013 - MLM: Created Stored Proc

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptDeclineExceptions '6/3/13', 292

***********************************************************************/
CREATE PROCEDURE [dbo].[rptDeclineExceptions]
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
		ClientGUID uniqueidentifier,
		ClientEFTGUID uniqueidentifier,
		ClientFullName nvarchar(200),
		MembershipDescription nvarchar(50),
		MembershipStart date,
		MembershipEnd Date,
		MonthlyFee money,
		EFTCreditCardExpiration date,
		EFTFreezeStart date,
		EFTFreezeEnd date,
		IsProfileExpired bit NOT NULL,
		IsCreditCardExpired bit NOT NULL,
		IsMembershipExpired bit NOT NULL,
		IsFeeAmountZero bit NOT NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientGUID, ClientEFTGUID, ClientFullName, MembershipDescription,
			MembershipStart, MembershipEnd, MonthlyFee, EFTCreditCardExpiration, EFTFreezeStart, EFTFreezeEnd,
			IsProfileExpired, IsCreditCardExpired, IsMembershipExpired, IsFeeAmountZero)
		SELECT
			c.ClientGUID,
			c.ClientEFTGUID,
			cl.ClientFullNameCalc AS ClientName,

			memb.MembershipDescription as Membership,
			cm.BeginDate as MembershipStart,
			cm.EndDate as MembershipEnd,
			ISNULL(cm.MonthlyFee, 0) * (1 + (ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0)) + ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0)))) AS MonthlyFee,

			c.AccountExpiration,
			c.Freeze_Start,
			c.Freeze_End,

			-- EFT Profile is active
			CASE
				WHEN (c.IsActiveFlag IS NULL OR c.IsActiveFlag = 0)
						OR stat.IsEFTActiveFlag IS NULL
						OR (stat.IsEFTActiveFlag = 0 AND stat.IsFrozenFlag = 0 )
				THEN 1 ELSE 0 END,

			-- Credit Card Not Expired
			CASE
				WHEN (at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND @DeclineBatchDate <= c.AccountExpiration)
					  OR (at.EFTAccountTypeDescriptionShort <> 'CreditCard') THEN 0
					ELSE 1 END,

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
				ON cm.ClientMembershipGUID = c.ClientMembershipGUID
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
			AND ( (c.Freeze_Start IS NULL OR (c.Freeze_End IS NULL AND  @DeclineBatchDate < c.Freeze_Start))
					OR (c.Freeze_End IS NOT NULL AND ((@DeclineBatchDate < c.Freeze_Start) OR (@DeclineBatchDate > c.Freeze_End))) )


	--DECLARE @FeeTotal AS money, @WillRunTotal As money, @WontRunTotal AS money

	SELECT
		estat.ClientGUID,
		estat.ClientEFTGUID,
		estat.ClientFullName AS ClientName,
		estat.MembershipDescription,
		estat.MembershipStart,
		estat.MembershipEnd,
		estat.EFTCreditCardExpiration AS CreditCardExpiration,
		estat.EFTFreezeStart AS FreezeStart,
		estat.EFTFreezeEnd AS FreezeEnd,
		estat.MonthlyFee,
		estat.IsCreditCardExpired,
		estat.IsMembershipExpired,
		estat.IsProfileExpired,
		estat.IsFeeAmountZero
	FROM @ClientEFTStatus estat
	WHERE estat.IsCreditCardExpired = 1 OR estat.IsMembershipExpired = 1
			OR estat.IsProfileExpired = 1 or estat.IsFeeAmountZero = 1
	Order By estat.ClientFullName


END
