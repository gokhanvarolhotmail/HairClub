/***********************************************************************

PROCEDURE:				mtnCenterDeclineBatchCreate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		02/22/2012

LAST REVISION DATE: 	02/22/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a new datCenterDeclineBatch and corresponding datPayCycleTransaction records to be
		processed. The new CenterDeclineBatchGUID is passed in.

		02/22/2012 - AS: Created Stored Proc
		* 06/04/2012 - MMaass Fixed Logic to Exclude People who have made payments.
		* 06/18/2012 - MMaass Added Logic to make sure there are no other CenterDeclineBatch which are not completed.
		* 06/25/2012 - MMaass Added Logic to be able to return multiple decline batches.
		* 06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		* 07/10/2012 - MMaass Modified to include expired credit cards when creating a decline batch.
		* 10/15/2012 - MMaass Added PCP Write Sales Code
		* 03/06/2014 - MTovbin Modified to use business segment and client membership to determine if EFT profile exists.
		* 05/06/2021 - rrojas Added validation for paycycle date
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnCenterDeclineBatchCreate 276

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnCenterDeclineBatchCreate]
	@CenterID int

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CenterDeclineBatchStatusID_Processing int
	SELECT @CenterDeclineBatchStatusID_Processing = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'

	DECLARE @CenterDeclineBatchStatusID_Completed int
	SELECT @CenterDeclineBatchStatusID_Completed = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @CenterFeeBatchStatus_CompletedID int
	SELECT @CenterFeeBatchStatus_CompletedID = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'

	DECLARE @CreateDate dateTime
	SET @CreateDate = GETUTCDATE()


		--Create the new CenterDeclineBatch
		INSERT INTO datCenterDeclineBatch(
					CenterDeclineBatchGUID
					,results.CenterFeeBatchGUID
					,CenterDeclineBatchStatusID
					,RunDate
					,RunByEmployeeGUID
					,IsCompletedFlag
					,CreateDate
					,CreateUser
					,LastUpdate
					,LastUpdateUser)
		SELECT NEWID()
			,CenterFeeBatchGUID
			,@CenterDeclineBatchStatusID_Processing
			,GETUTCDATE() as RunDate
			,NULL as RunByEmployeeGUID
			,0 as IsCompletedFlag
			,@CreateDate as CreateDate
			,'Decline Processing' as CreateUser
			,GETUTCDATE() as LastUpdate
			,'Decline Processing' as LastUpdateUser
		FROM (
				Select DISTINCT
					fee.CenterFeeBatchGUID
				from datPayCycleTransaction trans
					INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
					INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
					INNER JOIN datSalesOrder transSO ON transSO.SalesOrderGUID = trans.SalesOrderGUID
					INNER JOIN datClientMembership transCM ON transCM.ClientMembershipGUID = transSO.ClientMembershipGUID
					INNER JOIN cfgMembership transMem ON transMem.MembershipID = transCM.MembershipID
					INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
					CROSS APPLY  -- Find Client EFT for the same business segment
						(
							SELECT eft.*
								FROM datClientEFT eft
									INNER JOIN datClientMembership eftCM ON eftCM.ClientMembershipGUID = eft.ClientMembershipGUID
									INNER JOIN cfgMembership eftMem  ON eftMem.MembershipID = eftCM.MembershipID
								WHERE eft.ClientGUID = trans.ClientGUID
										AND eftMem.BusinessSegmentID = transMem.BusinessSegmentID
						) ceft
					--INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
					LEFT OUTER JOIN lkpEFTAccountType at ON ceft.EFTAccountTypeID = at.EFTAccountTypeID
					LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
										AND decline.CenterDeclineBatchStatusID <> @CenterDeclineBatchStatusID_Completed
				WHERE trans.IsReprocessFlag = 1
					AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
					AND decline.CenterDeclineBatchGUID IS NULL
					AND fee.CenterID = @CenterID
					--AND (at.EFTAccountTypeDescriptionShort = 'CreditCard'
					--				AND CONVERT(DATE,CONVERT(NVARCHAR,GETDATE(),101)) <= ceft.AccountExpiration)
					AND GETUTCDATE() BETWEEN
							[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
							AND
							--DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
							  CASE WHEN (fee.FeeMonth = 2 AND payCycle.FeePayCycleValue = 30)
								THEN
								DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, 28 , fee.FeeYear) )) + ' 23:59:59'
								ELSE
								DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
								end
					AND c.ClientGUID NOT IN (
						(SELECT so.ClientGUID
							FROM datSalesOrder so
								INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
										AND ( sod.SalesCodeID = @PAYMENT_RECEIVED OR sod.SalesCodeID = @PCP_WRITEOFF)
							WHERE c.ClientGUID = so.ClientGUID AND so.IsClosedFlag = 1
										AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))
		) as results

	--Return the CenterDeclineBatchGUID
	SELECT DISTINCT decline.CenterDeclineBatchGUID
	FROM datCenterDeclineBatch decline
		INNER JOIN datCenterFeeBatch fee on decline.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
	where decline.CreateDate = @CreateDate
		AND fee.CenterID = @CenterID

END
