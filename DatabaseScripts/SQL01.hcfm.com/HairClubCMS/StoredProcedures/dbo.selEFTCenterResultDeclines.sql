/***********************************************************************

PROCEDURE:				selEFTCenterResultDeclines

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		02/07/2012

LAST REVISION DATE: 	02/07/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns a list of EFTCenterResult records which have been declined and need to be reprocessed.

	02/07/2012 - AS: Created Stored Proc

	* 06/04/2012 - MMaass Fixed Logic to Exclude People who have made payments.
	* 06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
	* 07/25/2012 - MMaass Changed Logic to use Orginial PayCycle Transaction to determine Account Type
	* 10/15/2012 - MMaass Added PCP Write Sales Code
	* 09/20/2017 - SLemery Modified to exclude processing the decline if Write Off with EFTFEE sales code was performed
	* 02/04/2019 - SLemery Modified to return AddOnMonthlyFeeAmount and AddOnMonthlyTaxAmount and change FeeAmount to
					MembershipMonthlyFeeAmount and TaxAmount to MembershipTaxAmount (TFS #11935)
	  03/15/2021 - AP: Fix pay cycle dates when the date is 30 TFS14844
	****************************************************************************************************************
	*** The logic in this procedure should match the selection logic in selClientEFTForCenterDeclineProcessing *****
	****************************************************************************************************************

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selEFTCenterResultDeclines 825

***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTCenterResultDeclines]
@centerId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CenterFeeBatchStatus_CompletedID int
	SELECT @CenterFeeBatchStatus_CompletedID = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @CenterDeclineBatchStatusID_Completed int
	SELECT @CenterDeclineBatchStatusID_Completed = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @CenterDeclineBatchStatusID_Processing int
	SELECT @CenterDeclineBatchStatusID_Processing = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'

	DECLARE @EFT_MONTHLY_FEE INT
	SELECT @EFT_MONTHLY_FEE = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'

	-- create temp table
	DECLARE @ClientEFTDeclines TABLE
	(
		ClientFullNameCalc nvarchar(127),
		CenterID int NOT NULL,
		AccountExpirationDate datetime NULL,
		PayCycleTransactionGUID uniqueidentifier NOT NULL,
		ChargeAmount money NOT NULL,
		MembershipMonthlyFeeAmount money NOT NULL,
		MembershipTaxAmount money NOT NULL,
		AddOnMonthlyFeeAmount money NOT NULL,
		AddOnTaxAmount money NOT NULL,
		IsReprocessFlag bit NOT NULL,
		MembershipDescription nvarchar(100) NOT NULL,
		FeePayCycle nvarchar(100),
		RunDate	datetime NULL
	)


	-- Insert into temp table
	INSERT INTO @ClientEFTDeclines (ClientFullNameCalc, CenterID, AccountExpirationDate, PayCycleTransactionGUID, ChargeAmount, MembershipMonthlyFeeAmount, MembershipTaxAmount,
						AddOnMonthlyFeeAmount, AddOnTaxAmount, IsReprocessFlag, MembershipDescription, FeePayCycle, RunDate)

	Select DISTINCT c.ClientFullNameCalc
			,c.CenterID
			,cEFT.AccountExpiration
			,trans.PayCycleTransactionGUID
			,trans.ChargeAmount as ChargeAmount
			,ISNULL((trans.FeeAmount - o_AddOns.AddOnMonthlyFeeAmount), 0.0) as MembershipMonthlyFeeAmount
			,ISNULL((trans.TaxAmount - o_AddOns.AddOnTaxAmount), 0.0) as MembershipTaxAmount
			,ISNULL(o_AddOns.AddOnMonthlyFeeAmount, 0.0) as AddOnMonthlyFeeAmount
			,ISNULL(o_AddOns.AddOnTaxAmount, 0.0) as AddOnTaxAmount
			,trans.IsReprocessFlag
			,m.MembershipDescription
			,payCycle.FeePayCycleDescription as FeePayCycle
			,fee.RunDate
	from datPayCycleTransaction trans
		INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
		INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
		INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
		INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
		INNER JOIN datClientMembership cm on cEFT.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
		LEFT OUTER JOIN lkpPayCycleTransactionType pctt ON trans.PayCycleTransactionTypeId = pctt.PayCycleTransactionTypeId
		LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
						AND decline.CenterDeclineBatchStatusID <> @CenterDeclineBatchStatusID_Completed
		--Add Ons
		OUTER APPLY (
					SELECT
						ISNULL(SUM(sod.ExtendedPriceCalc), 0.0) AS AddOnMonthlyFeeAmount
						,ISNULL(SUM(sod.TotalTaxCalc), 0.0) AS AddOnTaxAmount
					FROM datSalesOrder so
						INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
					WHERE so.SalesOrderGUID = trans.SalesOrderGUID
						AND sod.ClientMembershipAddOnID IS NOT NULL
					) o_AddOns
	WHERE trans.IsSuccessfulFlag = 0
		AND fee.CenterId = @centerId
		AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
		AND trans.CenterDeclineBatchGUID IS NULL
		AND decline.CenterDeclineBatchGUID IS NULL
		AND pctt.PayCycleTransactionTypeDescriptionShort = 'CC'
		AND GETUTCDATE() BETWEEN
			[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
			AND
			--DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
             CASE WHEN (fee.FeeMonth = 2 AND payCycle.FeePayCycleValue = 30)
			    THEN
				DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, 28 , fee.FeeYear) )) + ' 23:59:59'
             ELSE
		        DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
			END

		AND c.ClientGUID NOT IN (
			(SELECT so.ClientGUID
				FROM datSalesOrder so
					INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
							AND ( sod.SalesCodeID = @PAYMENT_RECEIVED OR sod.SalesCodeID = @PCP_WRITEOFF OR (sod.SalesCodeID = @EFT_MONTHLY_FEE AND sod.WriteOffSalesOrderDetailGUID IS NOT NULL))
				WHERE c.ClientGUID = so.ClientGUID
							AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))
	ORDER BY c.ClientFullNameCalc

	SELECT ClientFullNameCalc
		,CenterID
		,AccountExpirationDate
		,PayCycleTransactionGUID
		,ChargeAmount
		,MembershipMonthlyFeeAmount
		,MembershipTaxAmount
		,ISNULL((MembershipMonthlyFeeAmount + MembershipTaxAmount), 0.0) AS TotalMembershipMonthlyAmount
		,AddOnMonthlyFeeAmount
		,AddOnTaxAmount
		,ISNULL((AddOnMonthlyFeeAmount + AddOnTaxAmount), 0.0) AS TotalAddOnMonthlyAmount
		,IsReprocessFlag
		,MembershipDescription
		,FeePayCycle
		,RunDate
	FROM @ClientEFTDeclines
	ORDER BY ClientFullNameCalc

END
