/* CreateDate: 05/14/2012 17:35:10.427 , ModifyDate: 02/27/2017 09:49:22.587 */
GO
/***********************************************************************

		PROCEDURE:				mtnPayCycleTransactionTransferToEFT

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Mike Maass

		IMPLEMENTOR: 			Mike Maass

		DATE IMPLEMENTED: 		03/15/2012

		LAST REVISION DATE: 	03/15/2012

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Transfers Center Fee Transactions from the datPayCycleTransaction table to the EFT database

				03/15/2012 - AS: Created Stored Proc
				05/30/2012 - MLM: Fixed the Tender
				05/31/2012 - MLM: Modified the Txn_Type Caculation
				06/01/2012 - MLM: Fixed Export Issue
				06/04/2012 - MLM: Added the hcmtbl_Declines Download and Update.
				06/05/2012 - MLM: Fixed issue with ReProcessed Flag and Declines
				07/09/2012 - MLM: Changed the Txn_Type during the declines process to always be equal to 1
				07/10/2012 - MLM: Changed the Ran_by for declines to be 'dcl'
				07/10/2012 - MLM: Modified the Procedure to use the PayCycleDate vs the BatchRunDate in determining Tender & Txn_Type Values.
				07/10/2012 - MLM: Tender can never be NULL for Declines, Removed Section from case statement that cause expired cards to have NULL tender
				07/24/2012 - MLM: Modified the declines to use the orginial transaction to populate the txn_type and tender.
				03/07/2013 - MLM: GO-Live centers will no longer be downloaded.
		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		mtnPayCycleTransactionTransferToEFT

		***********************************************************************/
		CREATE PROCEDURE [dbo].[mtnPayCycleTransactionTransferToEFT]

		AS
		BEGIN

			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			DECLARE @CenterFeeBatchGUID char(36),
					@BatchRunDate DateTime,
					@CenterDeclineBatchStatus_Completed int,
					@CenterFeeBatchStatus_Completed int

			SELECT @CenterDeclineBatchStatus_Completed = CenterDeclineBatchStatusID FROM lkpCenterDeclineBatchStatus where CenterDeclineBatchStatusDescriptionShort = 'COMPLETED'
			SELECT @CenterFeeBatchStatus_Completed = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

			--GO LIVE Centers DO NOT need to be downloaded anymore.  Mark them as Exported
				Update datCenterFeeBatch
					SET IsExported = 1
						,CenterFeeBatchStatusId = @CenterFeeBatchStatus_Completed
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = 'sa'
				FROM datCenterFeeBatch fee
					INNER JOIN dbo.cfgConfigurationCenter cc on fee.CenterID = cc.CenterID
				WHERE fee.IsExported = 0
					AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_Completed
					AND cc.HasFullAccess = 1

				Update datCenterDeclineBatch
					SET IsExported = 1
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = 'sa'
				FROM datCenterDeclineBatch decline
					INNER JOIN datCenterFeeBatch fee on decline.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
					INNER JOIN dbo.cfgConfigurationCenter cc on fee.CenterID = cc.CenterID
				WHERE decline.IsExported = 0
					AND decline.CenterDeclineBatchStatusID = @CenterDeclineBatchStatus_Completed
					AND cc.HasFullAccess = 1

			-- Loop through the batches
			DECLARE batch_cursor CURSOR FOR
				SELECT fee.CenterFeeBatchGUID,(CASE WHEN payCycle.FeePayCycleValue = 0 THEN CONVERT(DATETIME, CONVERT(VARCHAR(10), GETUTCDATE(), 101))
										ELSE CONVERT(DATETIME, CONVERT(nvarchar(2),fee.FeeMonth) + '/' + CONVERT(nvarchar(2),payCycle.FeePayCycleValue ) + '/' + CONVERT(nvarchar(4),fee.FeeYear), 101)
								  END)
				FROM datCenterFeeBatch fee
					INNER JOIN dbo.lkpFeePayCycle paycycle on fee.FeePayCycleID = paycycle.FeePayCycleID
					INNER JOIN dbo.cfgConfigurationCenter cc on fee.CenterID = cc.CenterID
				WHERE fee.IsExported = 0
					AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_Completed
					AND cc.HasFullAccess = 0
				ORDER BY fee.CreateDate

			OPEN batch_cursor;

			FETCH NEXT FROM batch_cursor
			INTO @CenterFeeBatchGUID, @BatchRunDate;

			WHILE @@FETCH_STATUS = 0
			BEGIN

					--INSERT CenterFeeBatch Records into hcmtbl_Results
					INSERT INTO [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Results(
								Center
								,Client_No
								,Period_Day
								,Period_Month
								,Period_Year
								,Txn_Type
								,Amount
								,Tax
								,Tender
								,[Status]
								,Approval_Code
								,Ref_Num
								,Ran_On
								,Ran_By
								,Imported
								,Imported_On
								,Imported_By
								,Retry
								,[Timestamp]
								,ReProcessed
								,LastAction)
					SELECT fee.CenterID as Center
						,c.ClientNumber_Temp as Client_No
						,paycycle.FeePayCycleValue as Period_Day
						,fee.FeeMonth as Period_Month
						,fee.FeeYear as Period_Year
						,CASE WHEN @BatchRunDate BETWEEN eft.Freeze_Start AND eft.Freeze_End THEN 5 --Frozen
							  WHEN aType.EFTAccountTypeDescriptionShort = 'CreditCard'
										AND @BatchRunDate > eft.AccountExpiration THEN 6 -- CC Expired
							  WHEN IsNULL(eft.IsActiveFlag, 0) = 0 OR stat.IsEFTActiveFlag = 0 OR @BatchRunDate < cm.BeginDate OR @BatchRunDate > cm.EndDate THEN  7 -- Profile Expired
							  WHEN aType.EFTAccountTypeDescriptionShort = 'A/R' THEN 4 --Credit
							  WHEN aType.EFTAccountTypeDescriptionShort = 'Checking' THEN 2  --check
							  WHEN atype.EFTAccountTypeDescriptionShort = 'Savings' THEN 3 --Savings
							  WHEN aType.EFTAccountTypeDescriptionShort = 'CreditCard' THEN 1 -- CreditCard
						END as Txn_Type -- Credit Card
						,CASE WHEN trans.ChargeAmount = 0 THEN 0
							ELSE trans.FeeAmount
						 END as Amount
						,CASE WHEN trans.ChargeAmount = 0 THEN 0
							ELSE trans.TaxAmount
						 END as Tax
						,CASE WHEN @BatchRunDate BETWEEN eft.Freeze_Start AND eft.Freeze_End THEN  NULL --Frozen
							  WHEN aType.EFTAccountTypeDescriptionShort = 'CreditCard'
										AND @BatchRunDate > eft.AccountExpiration THEN NULL -- CC Expired
							  WHEN IsNULL(eft.IsActiveFlag, 0) = 0 OR stat.IsEFTActiveFlag = 0 OR @BatchRunDate < cm.BeginDate OR @BatchRunDate > cm.EndDate THEN  NULL -- Profile Expired
							  WHEN aType.EFTAccountTypeDescriptionShort = 'CreditCard' THEN 'charge'
							  WHEN aType.EFTAccountTypeDescriptionShort = 'A/R' THEN 'credit'
							  WHEN aType.EFTAccountTypeDescriptionShort = 'Checking' THEN 'check'
							  WHEN atype.EFTAccountTypeDescriptionShort = 'Savings' THEN 'check'
							  ELSE NULL
						 END as Tender
						,trans.HCStatusCode as [Status]
						,trans.ApprovalCode AS Approval_Code
						,NULL as Ref_Num
						,fee.RunDate as Ran_On
						,e.UserLogin as Ran_By
						,0 as Imported
						,NULL as Imported_On
						,NULL as Imported_By
						,0 as Retry
						,GETUTCDATE() as [TimeStamp]
						,0 as Reprocessed
						,GETUTCDATE() as LastAction
					FROM datPayCycleTransaction trans
						INNER JOIN lkpPayCycleTransactionType pType on trans.PayCycleTransactionTypeID = pType.PayCycleTransactionTypeID
						INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
						INNER JOIN datClient c on trans.ClientGUID = c.ClientGUID
						INNER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
						INNER JOIN datClientMembership cm
		 								ON cm.ClientMembershipGUID = eft.ClientMembershipGUID AND eft.ClientGUID = cm.ClientGUID
		 				LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = eft.EFTStatusID
						INNER JOIN lkpEFTAccountType aType on eft.EFTAccountTypeID = aType.EFTAccountTypeID
						INNER JOIN lkpFeePayCycle payCycle on fee.FeePayCycleID = payCycle.FeePayCycleID
						LEFT OUTER JOIN datEmployee e ON fee.RunByEmployeeGUID = e.EmployeeGUID
					WHERE fee.CenterFeeBatchGUID = @CenterFeeBatchGUID
							AND trans.CenterDeclineBatchGUID IS NULL



					--INSERT DECLINED Transactions into hcmtbl_Declines
					INSERT INTO [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Declines
						(Center
						,Client_No
						,Period_Day
						,Period_Month
						,Period_Year
						,Amount
						,Tax
						,Approval_Code
						,Ref_Num
						,Ran_On
						,ReProcess
						,Successful
						,[Timestamp]
						,LastAction)
					SELECT fee.CenterID as Center
						,c.ClientNumber_Temp as Client_No
						,paycycle.FeePayCycleValue as Period_Day
						,fee.FeeMonth as Period_Month
						,fee.FeeYear as Period_Year
						,CASE WHEN trans.ChargeAmount = 0 THEN 0
							ELSE trans.FeeAmount
						 END as Amount
						,CASE WHEN trans.ChargeAmount = 0 THEN 0
							ELSE trans.TaxAmount
						 END as Tax
						,trans.ApprovalCode AS Approval_Code
						,NULL as Ref_Num
						,fee.RunDate as Ran_On
						,trans.IsReprocessFlag as Reprocess
						,trans.IsSuccessfulFlag as Successful
						,GETUTCDATE() as [TimeStamp]
						,GETUTCDATE() as LastAction
					FROM datPayCycleTransaction trans
						INNER JOIN lkpPayCycleTransactionType pType on trans.PayCycleTransactionTypeID = pType.PayCycleTransactionTypeID
						INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
						INNER JOIN datClient c on trans.ClientGUID = c.ClientGUID
						INNER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
						INNER JOIN datClientMembership cm
		 								ON cm.ClientMembershipGUID = eft.ClientMembershipGUID AND eft.ClientGUID = cm.ClientGUID
		 				LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = eft.EFTStatusID
						INNER JOIN lkpEFTAccountType aType on eft.EFTAccountTypeID = aType.EFTAccountTypeID
						INNER JOIN lkpFeePayCycle payCycle on fee.FeePayCycleID = payCycle.FeePayCycleID
						LEFT OUTER JOIN datEmployee e ON fee.RunByEmployeeGUID = e.EmployeeGUID
					WHERE fee.CenterFeeBatchGUID = @CenterFeeBatchGUID
							AND trans.CenterDeclineBatchGUID IS NULL
							AND trans.IsSuccessfulFlag = 0
							AND Trans.IsReprocessFlag = 1
							AND aType.EFTAccountTypeDescriptionShort = 'CreditCard'



				IF @@ERROR = 0
					BEGIN
						Update datCenterFeeBatch
							SET IsExported = 1
								,CenterFeeBatchStatusId = @CenterFeeBatchStatus_Completed
								,LastUpdate = GETUTCDATE()
								,LastUpdateUser = 'sa'
						FROM datCenterFeeBatch
						WHERE CenterFeeBatchGUID = @CenterFeeBatchGUID
					END

				FETCH NEXT FROM batch_cursor
				INTO @CenterFeeBatchGUID, @BatchRunDate;
			END
			CLOSE batch_cursor;
			DEALLOCATE batch_cursor;


			DECLARE @CenterDeclineBatchGUID char(36)

			-- Loop through the batches
			DECLARE batch_cursor CURSOR FOR
				SELECT decline.CenterDeclineBatchGUID, CONVERT(DATETIME, CONVERT(VARCHAR(10), decline.RunDate, 101))
				FROM datCenterDeclineBatch decline
					INNER JOIN datCenterFeeBatch fee on decline.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
					INNER JOIN dbo.cfgConfigurationCenter cc on fee.CenterID = cc.CenterID
				WHERE decline.IsExported = 0
					AND decline.CenterDeclineBatchStatusID = @CenterDeclineBatchStatus_Completed
					AND cc.HasFullAccess = 0
				ORDER BY Decline.CreateDate

			OPEN batch_cursor;

			FETCH NEXT FROM batch_cursor
			INTO @CenterDeclineBatchGUID, @BatchRunDate;

			WHILE @@FETCH_STATUS = 0
			BEGIN

					--INSERT CenterFeeBatch Records into hcmtbl_Results
					INSERT INTO [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Results(
								Center
								,Client_No
								,Period_Day
								,Period_Month
								,Period_Year
								,Txn_Type
								,Amount
								,Tax
								,Tender
								,[Status]
								,Approval_Code
								,Ref_Num
								,Ran_On
								,Ran_By
								,Imported
								,Imported_On
								,Imported_By
								,Retry
								,[Timestamp]
								,ReProcessed
								,LastAction)
					SELECT fee.CenterID as Center
						,c.ClientNumber_Temp as Client_No
						,paycycle.FeePayCycleValue as Period_Day
						,fee.FeeMonth as Period_Month
						,fee.FeeYear as Period_Year
						,CASE WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'CC' THEN 1 -- CreditCard
							  -- MLM 7/9/12: All credit card transactions will have the txn_type = 1
							  --WHEN @BatchRunDate BETWEEN eft.Freeze_Start AND eft.Freeze_End THEN 5 --Frozen
							  --WHEN aType.EFTAccountTypeDescriptionShort = 'CreditCard'
									--	AND @BatchRunDate > eft.AccountExpiration THEN 6 -- CC Expired
							  WHEN IsNULL(eft.IsActiveFlag, 0) = 0 OR stat.IsEFTActiveFlag = 0 OR @BatchRunDate < cm.BeginDate OR @BatchRunDate > cm.EndDate THEN  7 -- Profile Expired
							  WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'A/R' THEN 4 --Credit
							  WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'Cash' THEN 2  --check
						END as Txn_Type -- Credit Card
						,CASE WHEN orgTrans.ChargeAmount = 0 THEN 0
							ELSE orgTrans.FeeAmount
						 END as Amount
						,CASE WHEN orgTrans.ChargeAmount = 0 THEN 0
							ELSE orgTrans.TaxAmount
						 END as Tax
						,CASE WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'CC' THEN 'charge'
							  WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'ACH' THEN 'credit'
							  WHEN pctType.PayCycleTransactionTypeDescriptionShort = 'Cash' THEN 'check'
							  ELSE NULL
						 END as Tender
						,trans.HCStatusCode as [Status]
						,trans.ApprovalCode AS Approval_Code
						,NULL as Ref_Num
						,decline.RunDate as Ran_On
						,'dcl' as Ran_By
						,0 as Imported
						,NULL as Imported_On
						,NULL as Imported_By
						,0 as Retry
						,GETUTCDATE() as [TimeStamp]
						,1 as Reprocessed
						,GETUTCDATE() as LastAction
					FROM datPayCycleTransaction trans
						INNER JOIN lkpPayCycleTransactionType pType on trans.PayCycleTransactionTypeID = pType.PayCycleTransactionTypeID
						INNER JOIN datCenterDeclineBatch decline on trans.CenterDeclineBatchGUID = decline.CenterDeclineBatchGUID
						INNER JOIN datCenterFeeBatch fee on decline.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
						INNER JOIN datPayCycleTransaction orgTrans on fee.CenterFeeBatchGUID = orgTrans.CenterFeeBatchGUID
										AND trans.ClientGUID = orgtrans.ClientGUID
						INNER JOIN datClient c on trans.ClientGUID = c.ClientGUID
						INNER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
						INNER JOIN datClientMembership cm
		 								ON cm.ClientMembershipGUID = eft.ClientMembershipGUID AND eft.ClientGUID = cm.ClientGUID
		 				LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = eft.EFTStatusID
						INNER JOIN lkpFeePayCycle payCycle on fee.FeePayCycleID = payCycle.FeePayCycleID
						--Use the PayCycleTransactionType to determine AccountType for Declines
						INNER JOIN lkpPayCycleTransactionType pctType ON orgTrans.PayCycleTransactionTypeId = pctType.PayCycleTransactionTypeId
					WHERE decline.CenterDeclineBatchGUID = @CenterDeclineBatchGUID
						AND orgtrans.CenterDeclineBatchGUID IS NULL

					--Update the hcmtbl_Declines table with the decline Results.
					Update [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Declines
						SET Successful = trans.IsSuccessfulFlag
							,Approval_Code = trans.ApprovalCode
							,LastAction = GETUTCDATE()
					FROM datPayCycleTransaction trans
						INNER JOIN lkpPayCycleTransactionType pType on trans.PayCycleTransactionTypeID = pType.PayCycleTransactionTypeID
						INNER JOIN datCenterDeclineBatch decline on trans.CenterDeclineBatchGUID = decline.CenterDeclineBatchGUID
						INNER JOIN datCenterFeeBatch fee on decline.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
						INNER JOIN datClient c on trans.ClientGUID = c.ClientGUID
						INNER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
						INNER JOIN datClientMembership cm
		 								ON cm.ClientMembershipGUID = eft.ClientMembershipGUID AND eft.ClientGUID = cm.ClientGUID
		 				LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = eft.EFTStatusID
						INNER JOIN lkpEFTAccountType aType on eft.EFTAccountTypeID = aType.EFTAccountTypeID
						INNER JOIN lkpFeePayCycle payCycle on fee.FeePayCycleID = payCycle.FeePayCycleID
						LEFT OUTER JOIN datEmployee e ON fee.RunByEmployeeGUID = e.EmployeeGUID
						INNER JOIN [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Declines eftDeclines ON c.CenterId = eftDeclines.Center
										AND c.ClientNumber_Temp = eftDeclines.Client_No
										AND paycycle.FeePayCycleValue = eftdeclines.Period_Day
										AND fee.FeeMonth = eftdeclines.Period_Month
										AND fee.FeeYear = eftDeclines.Period_Year
					WHERE decline.CenterDeclineBatchGUID = @CenterDeclineBatchGUID

				IF @@ERROR = 0
					BEGIN
						Update datCenterDeclineBatch
							SET IsExported = 1
								,LastUpdate = GETUTCDATE()
								,LastUpdateUser = 'sa'
						FROM datCenterDeclineBatch
						WHERE CenterDeclineBatchGUID = @CenterDeclineBatchGUID
					END

				FETCH NEXT FROM batch_cursor
				INTO @CenterDeclineBatchGUID, @BatchRunDate;
			END
			CLOSE batch_cursor;
			DEALLOCATE batch_cursor;

		END
GO
