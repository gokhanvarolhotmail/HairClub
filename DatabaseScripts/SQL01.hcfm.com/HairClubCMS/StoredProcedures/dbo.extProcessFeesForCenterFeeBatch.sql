/***********************************************************************
PROCEDURE:				[extProcessFeesForCenterFeeBatch]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MMaass
IMPLEMENTOR: 			MMaass
DATE IMPLEMENTED: 		04/02/2012
LAST REVISION DATE: 	04/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Fees for a CenterFeeBatch
		04/02/2012 - MMaass Created Stored Proc
		05/04/2012 - MTovbin Modified to return Client Identifier and Center Fee Batch GUID
		05/08/2012 - MTovbin Updated so LastUpdate is set to the Current UTC time
		05/10/2012 - MMaass  Fixed issue with All Credit Card Transactions getting written to AR
		05/14/2012 - MMaass Fixed issue where expired Credit Cards were not tendering
		05/14/2012 - MMaass Now rounding to 2 decimal places.
		05/14/2012 - MMaass TaxExempt Clients should have a value of zero in the tax fields when tax Exempt
		05/15/2012 - MMaass Ignore TaxExempt, fees will always be taxed.
		05/30/2012 - MMaass Add InvoiceNumber to the resultset
		06/14/2012 - MMaass Added check to see if SalesOrder & PayCycleTransaction Exist.  This is needed for Reconcilation.
		06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		07/02/2012 - MTovbin Fixed issue with the Tender records not being created.  Fixed SO to use UTC Date.
		01/09/2013 - MMaass Modified SalesOrder Creation to set the IsClosedFlag = 1
		03/13/2013 - MTovbin Fixed issue with AR Detail record so that it includes tax.
		03/04/2014 - MTovbin Modified to use Client Membership GUID to determine fees.
		06/16/2015 - MTovbin Modified to check for the Voided Sales Orders
		06/23/2016 - SLemery Modified to get TaxType1 and TaxType2 and add to Sales Order Detail insert
								Fixed issue with @ChargeAmount not including Tax2 in it's calculation
		08/01/2016 - MLM	Added In-House Payment Plan Processing
		08/17/2016 - MLM	Fixed PayCycleTransaction TaxRate2 Amount
		09/17/2017 - SAL	Replaced code that generated the Invoice Number with a call to the mtnGetInvoiceNumber stored proc
		02/12/2019 - SAL	Modified to: (TFS #11939)
								Include Monthly Add-Ons
								Comment out Payment Plan logic (keep commented out code in place in case reinstated later)
								Use the original fee's sales code when card is expired versus the CARD EXPIRED sales code (I also
									left this code just commented out in case we need to reinstate it)
		04/02/2019 - JLM	Updated logic to determine add-on fee amount. (TFS #12202)
		05/01/2019 - JLM	Only change transaction type to inter-company if entire sales order amount is zero (TFS #12397)
							Update tax calculation for cash transactions. (TFS #12399)
		05/03/2019 - JLM	When fee is frozen, show a line for each add-on. (TFS #12414)
		05/04/2019 - MVT	Fixed issue with duplicate AR records being written. See TFS for detailed explanation. (TFS #12418).
		05/07/2019 - JLM	When fee is expired, show a line for each add-on. (TFS #12423)
		05/08/2019 - JLM	Update cash tax calculation logic. (TFS #12399)
		05/09/2019 - JLM	Reset Tax variables in Cursor to prevent against carrying over to the next iteration. (TFS #12439)
		06/23/2019 - SAL: Update the logic for memberships' Monthly Fees to consider
								cfgConfigurationMembership.IsEFTProcessingRestrictedByContractBalance (TFS #12679)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [extProcessFeesForCenterFeeBatch] 'F6D3AF4A-D0E9-4EC9-AD3C-18654BF616B8', 'F923F21A-66DA-4ACF-9AC0-96191447B327'
***********************************************************************/
CREATE PROCEDURE [dbo].[extProcessFeesForCenterFeeBatch]
		@CenterFeeBatchGUID uniqueidentifier,
		@EmployeeGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON

	--CenterFeeBatch has to be in APPROVED Status to process
	IF NOT EXISTS (SELECT * FROM datCenterFeeBatch fee
								INNER JOIN lkpCenterFeeBatchStatus batchstatus on fee.CenterFeeBatchStatusId = batchStatus.CenterFeeBatchStatusId
							WHERE batchStatus.CenterFeeBatchStatusDescriptionShort = 'APPROVED')
	BEGIN
		RETURN
	END

	--SET CenterFeeBatchStatus to Processing
	DECLARE @CenterFeeBatchStatus_Processing int
	SELECT @CenterFeeBatchStatus_Processing = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus where CenterFeeBatchStatusDescriptionShort = 'PROCESSING'

	UPDATE datCenterFeeBatch
	SET CenterFeeBatchStatusId = @CenterFeeBatchStatus_Processing
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = 'sa'
	FROM datCenterFeeBatch
	WHERE CenterFeeBatchGUID = @CenterFeeBatchGUID

	--Create temp table for each item to be processed against a client's EFT Profile (membership, add-ons, etc.)
	DECLARE @ClientMonthlyFees TABLE
		(
			SalesOrderGUID uniqueidentifier NOT NULL,
			ClientGUID uniqueidentifier NOT NULL,
			ClientMembershipGUID uniqueidentifier NOT NULL,
			ClientMembershipAddOnID int NULL,
			SalesCodeID int NOT NULL,
			MembershipID int NOT NULL,
			Amount money NOT NULL,
			AccountTypeDescShort nvarchar(15),
			IsValidToRun bit NOT NULL,
			IsFrozen bit NOT NULL,
			IsCardExpired bit NOT NULL,
			IsFeeExpired bit NOT NULL,
			DoesSalesOrderExist bit NOT NULL
			--,IsPaymentPlan bit NOT NULL
		)

	--Create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
		(
			ClientGUID uniqueidentifier NOT NULL,
			ClientMembershipGUID uniqueidentifier NOT NULL,
			ClientMembershipAddOnID int NULL,
			SalesOrderGUID uniqueidentifier NOT NULL,
			SalesCodeId int not null,
			SalesOrderTypeId int NOT NULL,
			InvoiceNumber nvarchar(50) NOT NULL,
			AccountTypeDescShort nvarchar(15),
			TenderTypeId int not null,
			AccountReceivableTypeID int not null,
			PayCycleTransactionTypeID int not null,
			Amount money NOT NULL,
			ChargeAmount money NOT NULL,
			TaxRate1 money NULL,
			TaxRate2 money NULL,
			IsFrozen bit not NULL,
			IsFeeExpired bit not null,
			IsCardExpired bit not null,
			DoesSalesOrderExist bit not null,
			TaxType1ID int NULL,
			TaxType2ID int NULL,
			SalesOrderAmountTotal MONEY NOT NULL
		)

	--Create temp table to sum totals for each sales order
	DECLARE @SalesOrderTotalAmount TABLE
	(
		SalesOrderGUID UNIQUEIDENTIFIER NOT NULL,
		TotalAmount MONEY NOT NULL
	)

	--Internal Variables
	DECLARE @SalesOrderTypeID_MonthlyFee int,
			@SalesCodeID int,
			@CardExpiredSalesCodeID int,
			@FeeExpiredSalesCodeID int,
			@MembershipMonthlyFeeSalesCodeID int,
			--@PaymentPlanSalesCodeID int,
			@FrozenSalesCodeID int,
			@HCUser nvarchar(25),
			@PayCycleID INT,
			@FeeYear INT,
			@FeeMonth INT,
			@CenterID INT,
			@PayCycleValue int ,
			@BatchRunDate datetime,
			@InvoiceNumber nvarchar(50),
			@InvoiceCounter int,
			@ARTenderTypeID int,
			@ICTenderTypeID int,
			@CCTenderTypeID int,
			@CheckTenderTypeID int,
			@TenderTypeID int,
			@PayCycleTransactionTypeID int,
			@ACHPayCycleTransactionTypeID int,
			@FRPayCycleTransactionTypeID int,
			@CCPayCycleTransactionTypeID int,
			@CashPayCycleTransactionTypeID int,
			@AccountReceivableTypeID int,
			@TaxRate1 money,
			@TaxRate2 money,
			@TaxType1ID int,
			@TaxType2ID int,
			@ChargeAmount money,
			@DateToday Date

	--Cursor Variables
	DECLARE @SalesOrderGUID uniqueidentifier,
			@ClientGUID uniqueidentifier,
			@ClientMembershipGUID uniqueidentifier,
			@ClientMembershipAddOnID int,
			@MonthlyFeeSalesCodeID int,
			@MembershipId int,
			@Amount money,
			@AccountTypeDescShort nvarchar(15),
			@IsValidToRun bit,
			@IsFrozen bit,
			@IsCardExpired bit,
			@IsFeeExpired bit,
			@DoesSalesOrderExist bit,
			@SalesOrderAmountTotal money
			--,@IsPaymentPlan bit

	-- SET Today's Date
	SET @DateToday = CONVERT(DATE,CONVERT(NVARCHAR,GETDATE(),101))

	--Retrieve the SalesOrderTypeID for the MonthlyFee (FO)
	SELECT @SalesOrderTypeID_MonthlyFee = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'FO'

	--Retrieve TenderTypes
	SELECT @ARTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'AR'
	SELECT @ICTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'InterCo'
	SELECT @CCTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'CC'
	SELECT @CheckTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Check'

	--PayCycleTransactionTypeID
	SELECT @ACHPayCycleTransactionTypeID = PayCycleTransactionTypeID  FROM lkpPayCycleTransactionType WHERE PayCycleTransactionTypeDescriptionShort = 'ACH'
	SELECT @FRPayCycleTransactionTypeID = PayCycleTransactionTypeID  FROM lkpPayCycleTransactionType WHERE PayCycleTransactionTypeDescriptionShort = 'Frozen'
	SELECT @CCPayCycleTransactionTypeID = PayCycleTransactionTypeID  FROM lkpPayCycleTransactionType WHERE PayCycleTransactionTypeDescriptionShort = 'CC'
	SELECT @CashPayCycleTransactionTypeID = PayCycleTransactionTypeID  FROM lkpPayCycleTransactionType WHERE PayCycleTransactionTypeDescriptionShort = 'Cash'

	--ARTypeID
	SELECT @AccountReceivableTypeID = AccountReceivableTypeID  FROM lkpAccountReceivableType WHERE AccountReceivableTypeDescriptionShort = 'Charge'

	--GET the SalesCodeID
	SELECT @MembershipMonthlyFeeSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'
	--SELECT @CardExpiredSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CARD EXPIRED'
	SELECT @FeeExpiredSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'FEE EXPIRED'
	SELECT @FrozenSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'FEE FROZEN'
	--SELECT @PaymentPlanSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'MTHPLANPMT'

	SELECT @PayCycleID =fee.FeePayCycleID
		,@FeeYear =fee.FeeYear
		,@FeeMonth =fee.FeeMonth
		,@CenterID =fee.CenterID
		,@PayCycleValue = payCycle.FeePayCycleValue
		,@BatchRunDate = (CASE WHEN @PayCycleValue = 0 THEN CONVERT(DATETIME, CONVERT(VARCHAR(10), GETUTCDATE(), 101))
							   ELSE CONVERT(DATETIME, CONVERT(nvarchar(2),fee.FeeMonth) + '/' + CONVERT(nvarchar(2),payCycle.FeePayCycleValue ) + '/' + CONVERT(nvarchar(4),fee.FeeYear), 101)
						  END)
	FROM dbo.datCenterFeeBatch fee
		INNER JOIN dbo.lkpFeePayCycle paycycle on fee.FeePayCycleID = paycycle.FeePayCycleID
	WHERE fee.CenterFeeBatchGUID = @CenterFeeBatchGUID

	--Get the HairClub UserLogin From the EmployeeGUID
	SELECT @HCUser = UserLogin FROM datEmployee WHERE EmployeeGUID = @EmployeeGUID

	--Select Membership Monthly Fees into Temp Table
	INSERT INTO @ClientMonthlyFees(
			SalesOrderGUID,
			ClientGUID,
			ClientMembershipGUID,
			ClientMembershipAddOnID,
			SalesCodeID,
			MembershipID,
			Amount,
			AccountTypeDescShort,
			IsValidToRun,
			IsFrozen,
			IsCardExpired,
			IsFeeExpired,
			DoesSalesOrderExist
			--,IsPaymentPlan
			)
	SELECT ISNULL(so.SalesOrderGUID,NEWID()) as SalesOrderGUID,
			c.ClientGUID,
			cm.ClientMembershipGUID,
			NULL As ClientMembershipAddOnID,
			@MembershipMonthlyFeeSalesCodeID As MonthlyPaymentSalesCodeID,
			m.MembershipID,
			--ISNULL(cm.MonthlyFee, 0) as Amount,
			CASE WHEN cfgmem.IsEFTProcessingRestrictedByContractBalance = 0 THEN
					ISNULL(cm.MonthlyFee, 0)
				WHEN cm.ContractPrice <= cm.ContractPaidAmount THEN
					0.0
				WHEN (cm.ContractPrice - cm.ContractPaidAmount) > 0 AND (cm.ContractPrice - cm.ContractPaidAmount) < ISNULL(cm.MonthlyFee, 0.0) THEN
					(cm.ContractPrice - cm.ContractPaidAmount)
				ELSE ISNULL(cm.MonthlyFee, 0)
			END AS Amount,
			--CASE WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance,0) < ISNULL(cm.MonthlyFee, 0) THEN
			--	ISNULL(pp.RemainingBalance,0)
			--ELSE
			--	ISNULL(cm.MonthlyFee, 0)
			--END AS Amount,
			at.EFTAccountTypeDescriptionShort,
			CASE WHEN
					-- Credit Card Not Expired
					((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND @BatchRunDate <= c.AccountExpiration)
					OR at.EFTAccountTypeDescriptionShort != 'CreditCard')

					-- Active EFT Profile
					AND IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1

				THEN 1 ELSE 0 END as IsValidToRun,
			CAST(CASE WHEN @BatchRunDate BETWEEN c.Freeze_Start AND c.Freeze_End THEN 1 ELSE 0 END  AS BIT) AS IsFrozen,
			CAST(CASE WHEN ((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND  @BatchRunDate <= c.AccountExpiration)
					OR at.EFTAccountTypeDescriptionShort != 'CreditCard') THEN 0 ELSE 1 END AS BIT) AS IsCardExpired,
			CAST(CASE WHEN IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1 AND (@BatchRunDate BETWEEN cm.BeginDate AND cm.EndDate) THEN 0 ELSE 1 END AS BIT) as IsFeeExpired,
			CAST(CASE WHEN so.SalesOrderGUID IS NULL THEN 0 ELSE 1 END AS BIT) AS DoesSalesOrderExist
			--,CAST(CASE WHEN pp.PaymentPlanID IS NULL THEN 0 ELSE 1 END AS Bit) as IsPaymentPlan
	FROM datClientEFT c
			INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.ClientMembershipGUID AND c.ClientGUID = cm.ClientGUID
			INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
			INNER JOIN cfgConfigurationMembership cfgmem ON m.MembershipID = cfgmem.MembershipID
			INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
			LEFT JOIN dbo.cfgCenter Center on Center.CenterID = cm.CenterID
			INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
			LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
			LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
			--Add a Check to verify that no PayCycleTransaction(s) already exist for client
			OUTER APPLY
				(
				SELECT ptrans.*
				FROM datPayCycleTransaction ptrans
					INNER JOIN datSalesOrder ptransSo ON ptransSO.SalesOrderGUID = ptrans.SalesOrderGUID
				WHERE ptrans.CenterFeeBatchGUID = @CenterFeeBatchGUID
					AND ptransSo.ClientmembershipGUID = c.ClientMembershipGUID
				) trans
			--Add a Check to determine if a SalesOrder has already been created
			LEFT OUTER JOIN datSalesOrder so on @CenterFeeBatchGUID = so.CenterFeeBatchGUID
						AND c.ClientMembershipGUID = so.ClientMembershipGUID
						AND so.IsVoidedFlag = 0
			-- Adding PaymentPlan
			--LEFT OUTER JOIN datPaymentPlan pp on c.ClientMembershipGUID = pp.ClientMembershipGUID
			--LEFT OUTER JOIN lkpPaymentPlanStatus pps on pp.PaymentPlanStatusID = pps.PaymentPlanStatusID
	WHERE cl.CenterID = @centerId
			AND Center.IsCorporateHeadquartersFlag =0
			AND cms.ClientMembershipStatusDescriptionShort = 'A'
			AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
			AND trans.PayCycleTransactionGUID IS NULL
			-- Added Payment Plan Filter
			--AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))

	--Select Add-On Monthly Fees into Temp Table
	INSERT INTO @ClientMonthlyFees(
			SalesOrderGUID,
			ClientGUID,
			ClientMembershipGUID,
			ClientMembershipAddOnID,
			SalesCodeID,
			MembershipID,
			Amount,
			AccountTypeDescShort,
			IsValidToRun,
			IsFrozen,
			IsCardExpired,
			IsFeeExpired,
			DoesSalesOrderExist
			--,IsPaymentPlan
			)
	SELECT cmf.SalesOrderGUID,
			c.ClientGUID,
			cm.ClientMembershipGUID,
			cmaos.ClientMembershipAddOnID,
			cmaos.AddOnMonthlyFeeSalesCodeID,
			m.MembershipID,
			ISNULL(cmaos.AddOnMonthlyFee, 0) as Amount,
			--CASE WHEN pp.PaymentPlanID is NOT null AND ISNULL(pp.RemainingBalance,0) < ISNULL(cmaos.AddOnMonthlyFee, 0) THEN
			--	ISNULL(pp.RemainingBalance,0)
			--ELSE
			--	ISNULL(cmaos.AddOnMonthlyFee, 0)
			--END AS Amount,
			at.EFTAccountTypeDescriptionShort,
			CASE WHEN
					-- Credit Card Not Expired
					((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND @BatchRunDate <= c.AccountExpiration)
					OR at.EFTAccountTypeDescriptionShort != 'CreditCard')

					-- Active EFT Profile
					AND IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1

				THEN 1 ELSE 0 END as IsValidToRun,
			CAST(CASE WHEN @BatchRunDate BETWEEN c.Freeze_Start AND c.Freeze_End THEN 1 ELSE 0 END  AS BIT) AS IsFrozen,
			CAST(CASE WHEN ((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND  @BatchRunDate <= c.AccountExpiration)
					OR at.EFTAccountTypeDescriptionShort != 'CreditCard') THEN 0 ELSE 1 END AS BIT) AS IsCardExpired,
			CAST(CASE WHEN IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1 AND (@BatchRunDate BETWEEN cm.BeginDate AND cm.EndDate) THEN 0 ELSE 1 END AS BIT) as IsFeeExpired,
			CAST(CASE WHEN so.SalesOrderGUID IS NULL THEN 0 ELSE 1 END AS BIT) AS DoesSalesOrderExist
			--,CAST(CASE WHEN pp.PaymentPlanID IS NULL THEN 0 ELSE 1 END AS Bit) as IsPaymentPlan
	FROM datClientEFT c
			INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.ClientMembershipGUID AND c.ClientGUID = cm.ClientGUID
			INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
			INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
			LEFT JOIN dbo.cfgCenter Center on Center.CenterID = cm.CenterID
			INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
			LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
			LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
			--Add a Check to verify that no PayCycleTransaction(s) already exist for client
			OUTER APPLY
				(
				SELECT ptrans.*
				FROM datPayCycleTransaction ptrans
					INNER JOIN datSalesOrder ptransSo ON ptransSO.SalesOrderGUID = ptrans.SalesOrderGUID
				WHERE ptrans.CenterFeeBatchGUID = @CenterFeeBatchGUID
					AND ptransSo.ClientmembershipGUID = c.ClientMembershipGUID
				) trans
			--AddOns
			CROSS APPLY
				(
				SELECT cmao.ClientMembershipAddOnID,
					CASE
						WHEN cmao.ContractPrice <= cmao.ContractPaidAmount THEN 0
						WHEN cmao.ContractBalanceAmount < COALESCE(cmao.MonthlyFee, 0.0) THEN cmao.ContractBalanceAmount
						ELSE cmao.MonthlyFee
						END AS AddOnMonthlyFee
					,COALESCE(ctrmao.MonthlyFeeSalesCodeID, ao.MonthlyFeeSalesCodeID) AS AddOnMonthlyFeeSalesCodeID
				FROM datClientMembershipAddOn cmao
					INNER JOIN lkpClientMembershipAddOnStatus cmaos ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID

					--AddOn Level Monthly Fee Sales Code and Tax Rates
					INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
					INNER JOIN lkpAddOnType aot ON ao.AddOnTypeID = aot.AddOnTypeID

					--CenterMembershipAddOn Level Monthly Fee Sales Code and Tax Rates
					LEFT OUTER JOIN cfgCenterMembership ctrm ON m.MembershipID = ctrm.MembershipID
						AND cl.CenterID = ctrm.CenterID
					LEFT OUTER JOIN cfgCenterMembershipAddOn ctrmao ON ao.AddOnID = ctrmao.AddOnID
						AND ctrm.CenterMembershipID = ctrmao.CenterMembershipID
				WHERE cmao.ClientMembershipGUID = cm.ClientMembershipGUID
					AND cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'
					AND aot.IsMonthlyAddOnType = 1
				) cmaos
			--Add a Check to determine if a SalesOrder has already been created
			LEFT OUTER JOIN datSalesOrder so on @CenterFeeBatchGUID = so.CenterFeeBatchGUID
							AND c.ClientMembershipGUID = so.ClientMembershipGUID
							AND so.IsVoidedFlag = 0
			-- Adding PaymentPlan
			--LEFT OUTER JOIN datPaymentPlan pp on c.ClientMembershipGUID = pp.ClientMembershipGUID
			--LEFT OUTER JOIN lkpPaymentPlanStatus pps on pp.PaymentPlanStatusID = pps.PaymentPlanStatusID
			INNER JOIN @ClientMonthlyFees cmf on cm.ClientMembershipGUID = cmf.ClientMembershipGUID
	WHERE cl.CenterID = @centerId
			AND Center.IsCorporateHeadquartersFlag =0
			AND cms.ClientMembershipStatusDescriptionShort = 'A'
			AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
			AND trans.PayCycleTransactionGUID IS NULL
			-- Added Payment Plan Filter
			--AND ((cm.HasInHousePaymentPlan = 0) OR (pp.StartDate <= CONVERT(DATE,@BatchRunDate) AND (pp.SatisfactionDate IS NULL) AND pps.PaymentPlanStatusDescriptionShort = 'Active'))

	INSERT INTO @SalesOrderTotalAmount
	(
		SalesOrderGUID,
		TotalAmount
	) SELECT DISTINCT SalesOrderGUID,
			          SUM(Amount)
	  FROM @ClientMonthlyFees
	  GROUP BY SalesOrderGUID

	DECLARE CLIENT_CURSOR CURSOR FAST_FORWARD FOR

	SELECT cmt.SalesOrderGUID,
			cmt.ClientGUID,
			cmt.ClientMembershipGUID,
			cmt.ClientMembershipAddOnID,
			cmt.SalesCodeID,
			cmt.MembershipID,
			cmt.Amount,
			cmt.AccountTypeDescShort,
			cmt.IsValidToRun,
			cmt.IsFrozen,
			cmt.IsCardExpired,
			cmt.IsFeeExpired,
			cmt.DoesSalesOrderExist,
			sota.TotalAmount as SalesOrderAmountTotal
			--,IsPaymentPlan
	FROM @ClientMonthlyFees cmt
	INNER JOIN @SalesOrderTotalAmount sota ON cmt.SalesOrderGUID = sota.SalesOrderGUID

	OPEN CLIENT_CURSOR
	FETCH NEXT FROM CLIENT_CURSOR INTO @SalesOrderGUID, @ClientGUID, @ClientMembershipGUID, @ClientMembershipAddOnID, @MonthlyFeeSalesCodeID, @MembershipId, @Amount, @AccountTypeDescShort, @IsValidToRun, @IsFrozen, @IsCardExpired, @IsFeeExpired, @DoesSalesOrderExist, @SalesOrderAmountTotal --, @IsPaymentPlan

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		SET @TaxRate1 = NULL
		SET @TaxRate2 = NULL
		SET @TaxType1ID = NULL
		SET @TaxType2ID = NULL

		--Set the SalesCodeID
		IF @IsFrozen = 1
			BEGIN
				SET @SalesCodeID = @FrozenSalesCodeID
			END
		--ELSE IF @IsCardExpired = 1
		--	BEGIN
		--		SET @SalesCodeID = @CardExpiredSalesCodeID
		--	END
		ELSE IF @IsFeeExpired = 1
			BEGIN
				SET @SalesCodeID = @FeeExpiredSalesCodeID
			END
		--ELSE IF @IsPaymentPlan = 1
		--	BEGIN
		--		SET @SalesCodeID = @PaymentPlanSalesCodeID
		--	END
		ELSE
			BEGIN
				SET @SalesCodeID = @MonthlyFeeSalesCodeID
			END

		-- Set the PayCycleTransactionType
		IF (@IsFrozen = 1)
			BEGIN
				SET @PayCycleTransactionTypeID = @FRPayCycleTransactionTypeID
				SET @TenderTypeID = @ICTenderTypeID
			END
		ELSE IF (@AccountTypeDescShort = 'CreditCard')
			BEGIN
				SET @PayCycleTransactionTypeID = @CCPayCycleTransactionTypeID
				if (@IsCardExpired = 1 )
					SET @TenderTypeID = @ARTenderTypeID
				ELSE
					SET @TenderTypeID = @CCTenderTypeID
			END
		ELSE IF (@AccountTypeDescShort = 'Checking' OR @AccountTypeDescShort = 'Savings')
			BEGIN
				SET @PayCycleTransactionTypeID = @ACHPayCycleTransactionTypeID
				SET @TenderTypeID = @CheckTenderTypeID
			END
		ELSE
			BEGIN
				SET @PayCycleTransactionTypeID = @CashPayCycleTransactionTypeID
				SET @TenderTypeID = @ARTenderTypeID
			END

		IF ((@Amount = 0 AND @SalesOrderAmountTotal = 0) OR @IsFeeExpired = 1)
			SET @TenderTypeID = @ICTenderTypeID

		--Get the TaxRates for the Sales Code
		SELECT @TaxRate1 = ISNULL(mTaxRate1.TaxRate, cTaxRate1.TaxRate)
			,@TaxRate2 = ISNULL(mtaxrate2.TaxRate, cTaxRate2.TaxRate)
			,@TaxType1ID = ISNULL(mTaxRate1.TaxTypeID, cTaxRate1.TaxTypeID)
			,@TaxType2ID = ISNULL(mTaxRate2.TaxTypeID, cTaxRate2.TaxTypeID)
		FROM cfgSalesCodeCenter scc
			LEFT OUTER JOIN cfgCenterTaxRate cTaxRate1 on scc.TaxRate1ID = cTaxRate1.CenterTaxRateID
			LEFT OUTER JOIN cfgCenterTaxRate cTaxRate2 on scc.TaxRate2ID = cTaxRate2.CenterTaxRateID
			LEFT OUTER JOIN cfgSalesCodeMembership scm on scc.SalesCodeCenterID = scm.SalesCodeCenterID
					AND scm.MembershipID = @MembershipId
			LEFT OUTER JOIN cfgCenterTaxRate mTaxRate1 on scm.TaxRate1ID = mTaxRate1.CenterTaxRateID
			LEFT OUTER JOIN cfgCenterTaxRate mTaxRate2 on scm.TaxRate2ID = mTaxRate2.CenterTaxRateID
		WHERE scc.SalesCodeID = @SalesCodeID
			AND scc.CenterID = @CenterID

		----Grab the next Invoice Number
		DECLARE @TempInvoiceNumberTable TABLE (InvoiceNumber nvarchar(50))
		INSERT INTO @TempInvoiceNumberTable EXEC mtnGetInvoiceNumber @CenterID
		SELECT @InvoiceNumber = InvoiceNumber FROM @TempInvoiceNumberTable

		--Set ChargeAmount
		IF ((@IsFrozen = 1 or @Amount = 0) OR @IsFeeExpired = 1)
			SET @ChargeAmount = 0
		ELSE
			SET @ChargeAmount = ISNULL(@Amount,0) + (ISNULL(@Amount,0) * ISNULL(@TaxRate1,0)) + (ISNULL(@Amount,0) * ISNULL(@TaxRate2,0))

		IF @AccountTypeDescShort = 'CreditCard' AND @IsCardExpired = 1
			SET @PayCycleTransactionTypeID = @CCPayCycleTransactionTypeID

		--Place the Record into the Temp table
		INSERT INTO @ClientEFTStatus(
				ClientGUID,
				ClientMembershipGUID,
				ClientMembershipAddOnID,
				SalesOrderGUID,
				SalesCodeId,
				SalesOrderTypeId,
				InvoiceNumber,
				AccountTypeDescShort,
				TenderTypeId,
				AccountReceivableTypeID,
				PayCycleTransactionTypeID,
				Amount,
				ChargeAmount,
				TaxRate1,
				TaxRate2,
				IsFrozen,
				IsFeeExpired,
				IsCardExpired,
				DoesSalesOrderExist,
				TaxType1ID,
				TaxType2ID,
				SalesOrderAmountTotal)
		VALUES( @ClientGUID
				,@ClientMembershipGUID
				,@ClientMembershipAddOnID
				,@SalesOrderGUID
				,@SalesCodeID
				,@SalesOrderTypeID_MonthlyFee
				,@InvoiceNumber
				,@AccountTypeDescShort
				,@TenderTypeID
				,@AccountReceivableTypeID
				,@PayCycleTransactionTypeID
				,Round(@Amount,2)
				,Round(@ChargeAmount,2)
				,@TaxRate1
				,@TaxRate2
				,@IsFrozen
				,@IsFeeExpired
				,@IsCardExpired
				,@DoesSalesOrderExist
				,@TaxType1ID
				,@TaxType2ID
				,@SalesOrderAmountTotal)

		FETCH NEXT FROM CLIENT_CURSOR INTO @SalesOrderGUID, @ClientGUID, @ClientMembershipGUID, @ClientMembershipAddOnID, @MonthlyFeeSalesCodeID, @MembershipId, @Amount, @AccountTypeDescShort, @IsValidToRun, @IsFrozen, @IsCardExpired, @IsFeeExpired, @DoesSalesOrderExist,  @SalesOrderAmountTotal --, @IsPaymentPlan
	END

	CLOSE CLIENT_CURSOR
	DEALLOCATE CLIENT_CURSOR


	--Create a Transaction
	BEGIN TRAN

		--Write Sales Order
		INSERT INTO datSalesOrder(SalesOrderGUID ,TenderTransactionNumber_Temp ,TicketNumber_Temp ,CenterID ,ClientHomeCenterID ,SalesOrderTypeID ,ClientGUID ,ClientMembershipGUID ,AppointmentGUID
									,HairSystemOrderGUID ,OrderDate ,InvoiceNumber ,IsTaxExemptFlag ,IsVoidedFlag ,IsClosedFlag ,RegisterCloseGUID ,EmployeeGUID ,FulfillmentNumber ,IsWrittenOffFlag
									,IsRefundedFlag ,RefundedSalesOrderGUID ,CreateDate ,CreateUser ,LastUpdate ,LastUpdateUser ,ParentSalesOrderGUID ,IsSurgeryReversalFlag ,IsGuaranteeFlag
									,CenterFeeBatchGUID)
		SELECT trans.SalesOrderGUID
			,NULL
			,NULL
			,@CenterID
			,@CenterID
			,trans.SalesOrderTypeId
			,trans.ClientGUID
			,trans.ClientMembershipGUID
			,NULL
			,NULL
			,GETUTCDATE()
			,trans.InvoiceNumber
			,0 -- IsTaxExempt
			,0
			,1 -- IsClosedFlag
			,NULL
			,@EmployeeGUID
			,NULL
			,0
			,0
			,NULL
			,GETUTCDATE()
			,@HCUser
			,GETUTCDATE()
			,@HCUser
			,NULL
			,0
			,NULL
			,@CenterFeeBatchGUID
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY SalesOrderGUID ORDER BY SalesOrderGUID) AS rn
			  FROM @ClientEFTStatus) AS trans
		WHERE trans.rn = 1
			AND trans.DoesSalesOrderExist = 0

		--Write Sales Order Details
		INSERT INTO datSalesOrderDetail(SalesOrderDetailGUID ,TransactionNumber_Temp ,SalesOrderGUID ,SalesCodeID ,Quantity ,Price ,Discount ,Tax1 ,Tax2 ,TaxRate1 ,TaxRate2 ,IsRefundedFlag
										,RefundedSalesOrderDetailGUID ,RefundedTotalQuantity ,RefundedTotalPrice ,Employee1GUID ,Employee2GUID ,Employee3GUID ,Employee4GUID
										,PreviousClientMembershipGUID ,NewCenterID ,CreateDate ,CreateUser ,LastUpdate ,LastUpdateUser ,Center_Temp	,TaxType1ID	,TaxType2ID
										,ClientMembershipAddOnID, EntrySortOrder)
		SELECT NEWID()
			,NULL
			,trans.SalesOrderGUID
			,trans.SalesCodeID
			,1
			,CASE WHEN trans.IsFrozen = 1 OR trans.IsFeeExpired = 1 THEN 0
				ELSE trans.Amount
				END
			,0
			,CASE WHEN trans.IsFrozen = 1 OR trans.IsFeeExpired = 1 THEN 0
				ELSE (ISNULL(trans.Amount,0) * ISNULL(trans.TaxRate1,0))
				END --Tax1
			,CASE WHEN trans.IsFrozen = 1 OR trans.IsFeeExpired = 1 THEN 0
				ELSE (ISNULL(trans.Amount,0) * ISNULL(trans.TaxRate2,0))
				END --Tax2
			,trans.TaxRate1 --TaxRate1
			,trans.TaxRate2 --TaxRate2
			,0 --IsRefundedFlag
			,NULL --RefundedSalesOrderDetailGUID
			,NULL --RefunedTotalQuantity
			,NULL --RefundedTotalPrice
			,NULL --Employee1GUID
			,NULL --Employee2GUID
			,NULL --Employee3GUID
			,NULL --Employee4GUID
			,NULL --PreviousClientMembershpGUID
			,NULL --NewCenterID
			,GETUTCDATE() --CreateDate
			,@HCUSER --CreateUser
			,GETUTCDATE() --LastUpdate
			,@HCUSER --LastUpdateUser
			,NULL
			,trans.TaxType1ID
			,trans.TaxType2ID
			,trans.ClientMembershipAddOnID
			,trans.rn --EntrySortOrder
		FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY SalesOrderGUID ORDER BY SalesOrderGUID, ClientMembershipAddOnID) AS rn
			  FROM @ClientEFTStatus) AS trans
		WHERE trans.DoesSalesOrderExist = 0

		--Write Sales Order Tender
		INSERT INTO datSalesOrderTender(SalesOrderTenderGUID ,SalesOrderGUID ,TenderTypeID ,Amount ,CheckNumber	,CreditCardLast4Digits ,ApprovalCode ,CreditCardTypeID ,FinanceCompanyID
										,InterCompanyReasonID ,CreateDate ,CreateUser ,LastUpdate ,LastUpdateUser ,RefundAmount ,MonetraTransactionId)
		SELECT NEWID()
			,ces.SalesOrderGUID
			,ces.TenderTypeId
			,ROUND(SUM(ISNULL(ces.ChargeAmount, 0.0)), 2)
			,NULL --CheckNumber
			,NULL --CreditCardlast4Digits
			,NULL --ApprovalCode
			,NULL --CreditCardTypeID
			,NULL --FinanceCompanyID
			,NULL --InterCompanyReasonID
			,GETUTCDATE() --CreateDate
			,@HCUSER --CreateUser
			,GETUTCDATE() --LastUpdate
			,@HCUSER --LastUpdateUser
			,NULL --RefundAmount
			,NULL --MonetraTransactionId
		FROM @ClientEFTStatus ces
		WHERE (ces.DoesSalesOrderExist = 0) AND (ces.AccountTypeDescShort <> 'CreditCard' OR ces.IsFrozen = 1 OR ces.IsFeeExpired = 1 OR ces.SalesOrderAmountTotal <= 0 OR ces.IsCardExpired = 1)
		GROUP BY ces.SalesOrderGUID, ces.TenderTypeId

		--Write Pay Cycle Transaction
		INSERT INTO datPayCycleTransaction(PayCycleTransactionGUID ,PayCycleTransactionTypeID ,CenterFeeBatchGUID ,CenterDeclineBatchGUID ,SalesOrderGUID ,ClientGUID ,ProcessorTransactionID
											,ApprovalCode ,FeeAmount ,TaxAmount ,ChargeAmount ,Verbiage ,SoftCode ,HardCode ,Last4Digits ,ExpirationDate ,IsTokenUsedFlag ,IsCardPresentFlag ,IsSuccessfulFlag
											,IsReprocessFlag ,TransactionErrorMessage ,AVSResult ,HCStatusCode ,CreateDate ,CreateUser ,LastUpdate ,LastUpdateUser)
		SELECT NEWID()  --PayCycleTransactionGUID
			,ces.PayCycleTransactionTypeID --PayCycleTransactionTypeID
			,@CenterFeeBatchGUID --CenterFeeBatchGUID
			,NULL --CenterDeclineBatchGUID
			,ces.SalesOrderGUID --SalesOrderGUID
			,ces.ClientGUID --ClientGUID
			,NULL --ProcessorTransactionID
			,NULL --ApprovalCode
			,SUM(ROUND(ISNULL(ces.Amount, 0.0), 2)) --FeeAmount
			,SUM((ISNULL(ces.Amount, 0.0) * ISNULL(ces.TaxRate1, 0.0)) + (ISNULL(ces.Amount, 0.0) * ISNULL(ces.TaxRate2, 0.0))) --TaxAmount
			,SUM(ROUND(ISNULL(ces.ChargeAmount, 0.0), 2))  --ChargeAmount
			,NULL --Verbiage
			,NULL --SoftCode
			,NULL --HardCode
			,NULL --Last4Digits
			,NULL --ExpirationDAte
			,0 --IsTokenUsedFlag
			,0 --IsCardPresentFlag
			,1 --IsSucessfulFlag
			,0  --IsReprocessFlag
			,NULL --TransactionErrorMessage
			,NULL --AVSResult
			,NULL --HCStatusCode
			,GETUTCDATE() --CreateDate
			,@HCUSER --CreateUser
			,GETUTCDATE() --LastUpdate
			,@HCUSER
		FROM @ClientEFTStatus ces
		WHERE (ces.DoesSalesOrderExist = 0) AND (ces.AccountTypeDescShort <> 'CreditCard' OR ces.IsFrozen = 1 OR ces.IsFeeExpired = 1 OR ces.SalesOrderAmountTotal <= 0)
		GROUP BY ces.PayCycleTransactionTypeID, ces.SalesOrderGUID, ces.ClientGUID


		--If Frozen do not Write to AR
		INSERT INTO datAccountReceivable(ClientGUID ,SalesOrderGUID ,CenterFeeBatchGUID ,Amount ,IsClosed ,AccountReceivableTypeID ,RemainingBalance ,CreateDate ,CreateUser
										 ,LastUpdate ,LastUpdateUser ,CenterDeclineBatchGUID)
		SELECT ces.ClientGUID --ClientGUID
			,ces.SalesOrderGUID --SalesOrderGUID
			,@CenterFeeBatchGUID  --CenterFeeBatchGUID
			,SUM(ROUND(ces.ChargeAmount, 2)) --Amount
			,0 --IsClosed
			,ces.AccountReceivableTypeID --AccountReceivableTypeID
			,SUM(ROUND(ces.ChargeAmount, 2)) --RemainingBalance
			,GETUTCDATE() --CreateDate
			,@HCUSER --CreateUser
			,GETUTCDATE() --LastUpdate
			,@HCUSER --LastUpdateUser
			,NULL --CenterDeclineBatchGUID
		FROM @ClientEFTStatus ces
		WHERE ces.DoesSalesOrderExist = 0 AND ces.ChargeAmount <> 0 And (ces.TenderTypeId = @ARTenderTypeID OR ces.IsCardExpired = 1)
		GROUP BY ces.ClientGUID, ces.SalesOrderGUID, ces.AccountReceivableTypeID


		--Write CreditCard Transactions For Expired CreditCards
		INSERT INTO datPayCycleTransaction(PayCycleTransactionGUID ,PayCycleTransactionTypeID ,CenterFeeBatchGUID ,CenterDeclineBatchGUID ,SalesOrderGUID ,ClientGUID ,ProcessorTransactionID
								,ApprovalCode ,FeeAmount ,TaxAmount ,ChargeAmount ,Verbiage ,SoftCode ,HardCode ,Last4Digits ,ExpirationDate ,IsTokenUsedFlag ,IsCardPresentFlag ,IsSuccessfulFlag
								,IsReprocessFlag ,TransactionErrorMessage ,AVSResult ,HCStatusCode ,CreateDate ,CreateUser ,LastUpdate ,LastUpdateUser)
		SELECT NEWID()  --PayCycleTransactionGUID
			,ces.PayCycleTransactionTypeID --PayCycleTransactionTypeID
			,@CenterFeeBatchGUID --CenterFeeBatchGUID
			,NULL --CenterDeclineBatchGUID
			,ces.SalesOrderGUID --SalesOrderGUID
			,ces.ClientGUID --ClientGUID
			,NULL --ProcessorTransactionID
			,NULL --ApprovalCode
			,SUM(ROUND(ISNULL(ces.Amount, 0.0), 2)) --FeeAmount
			,SUM((ISNULL(ces.Amount, 0) * ISNULL(ces.TaxRate1, 0)) + (ISNULL(ces.Amount, 0) * ISNULL(ces.TaxRate2, 0))) --TaxAmount
			,SUM(ROUND(ISNULL(ces.ChargeAmount, 0.0), 2))  --ChargeAmount
			,'Card Expired' --Verbiage
			,NULL --SoftCode
			,NULL --HardCode
			,NULL --Last4Digits
			,NULL --ExpirationDAte
			,0 --IsTokenUsedFlag
			,0 --IsCardPresentFlag
			,0 --IsSucessfulFlag
			,0  --IsReprocessFlag
			,NULL --TransactionErrorMessage
			,NULL --AVSResult
			,NULL --HCStatusCode
			,GETUTCDATE() --CreateDate
			,@HCUSER --CreateUser
			,GETUTCDATE() --LastUpdate
			,@HCUSER --LastUpdateUser
		FROM @ClientEFTStatus ces
		WHERE ces.DoesSalesOrderExist = 0 AND ces.IsCardExpired = 1 AND ces.AccountTypeDescShort = 'CreditCard' AND ces.IsFrozen = 0 AND ces.IsFeeExpired = 0
		GROUP BY ces.PayCycleTransactionTypeID, ces.SalesOrderGUID, ces.ClientGUID

	IF (@@TRANCOUNT > 0) BEGIN
		COMMIT TRAN -- Never makes it here cause of the ROLLBACK
	END

	;WITH
		clientEFTStatusCTE as
			(SELECT SalesOrderGUID, ClientGUID, ClientMembershipGUID, AccountTypeDescShort, IsFeeExpired, IsFrozen, IsCardExpired
				,SUM(ISNULL(Amount, 0.0)) as Amount, SUM(ISNULL(TaxRate1, 0.0) * ISNULL(Amount, 0.0)) as TaxAmount1, SUM(ISNULL(TaxRate2, 0.0) * ISNULL(Amount, 0.0)) as TaxAmount2
			 FROM @ClientEFTStatus
			 GROUP BY SalesOrderGUID, ClientGUID, ClientMembershipGUID, AccountTypeDescShort, IsFeeExpired, IsFrozen, IsCardExpired)

	SELECT
		so.SalesOrderGUID
		,c.ClientGUID
		,c.ClientFullNameCalc
		,c.CenterID
		,so.ClientMembershipGUID
		,ISNULL(st.CenterFeeBatchStatusDescription, dstat.CenterFeeBatchStatusDescription) AS CenterFeeBatchStatusDescription
		,cab.RunDate
		-- FIELDS FOR SaleRequestTransaction OBJECT
		,ceft.[EFTAccountTypeID]
		,eat.[EFTAccountTypeDescriptionShort]
		,ceft.[EFTStatusID]
		,ceft.[FeePayCycleID]
		,ceft.[CreditCardTypeID]
		,ceft.[AccountNumberLast4Digits]
		,ceft.[BankName]
		,ceft.[BankPhone]
		,ceft.[BankRoutingNumber]

		,ceft.[EFTProcessorToken] --
		,ceft.[BankAccountNumber] --
		,ceft.[AccountExpiration] --
		,eftstat.Amount --
		-- SWIPE VALUE?
		-- TRANSACTIONID?
		,c.Address1 + ', ' + c.Address2 + ', ' + c.Address3 AS Street--
		,c.PostalCode --
		,CONVERT(bit,0) as IsTaxExempt
		-- VERIFICATION NUMBER?
		-- ISCARDPRESENT
		-- ORDERNUMBER
		-- ISSENT
		-- ISRECIEVED
		,CAST(CASE WHEN @BatchRunDate BETWEEN ceft.Freeze_Start AND Freeze_End THEN 1 ELSE 0 END  AS BIT) AS 'IsFrozen'
		,c.ClientIdentifier
		,cab.CenterFeeBatchGUID
		,so.InvoiceNumber
		,TaxAmount1
		,TaxAmount2
	FROM clientEFTStatusCTE eftStat
		INNER JOIN datClient c ON c.ClientGUID = eftStat.ClientGUID
		INNER JOIN datClientEFT ceft ON eftStat.ClientMembershipGUID = ceft.ClientMembershipGUID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
		INNER JOIN datCenterFeeBatch cab ON cab.CenterID = c.CenterID
			AND cab.FeeMonth = @FeeMonth
			AND cab.FeeYear = @FeeYear
			AND cab.FeePayCycleID = @PayCycleID
		INNER JOIN datSalesOrder so ON eftStat.ClientMembershipGUID = so.ClientMembershipGUID
			AND cab.CenterFeeBatchGUID = so.CenterFeeBatchGUID
			AND so.IsVoidedFlag = 0
		LEFT OUTER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
		LEFT JOIN dbo.lkpCenterFeeBatchStatus dstat ON dstat.CenterFeeBatchStatusID = 1
		LEFT OUTER JOIN lkpEFTAccountType eat ON eat.EFTAccountTypeID = ceft.EFTAccountTypeID
	WHERE eftStat.Amount > 0
		AND eftStat.AccountTypeDescShort = 'CreditCard'
		AND IsFeeExpired = 0
		AND IsFrozen = 0
		AND IsCardExpired = 0
END






SET ANSI_NULLS ON
