/* CreateDate: 06/19/2012 11:14:21.090 , ModifyDate: 09/26/2017 14:26:07.170 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selClientEFTForCenterDeclineProcessing]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MMaass
IMPLEMENTOR: 			MMaass
DATE IMPLEMENTED: 		02/22/2012
LAST REVISION DATE: 	02/22/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return individual client eft details for transaction processing
		of declines by CenterDeclineBatchGUID
		* 02/22/2012 - MMaass Created Stored Proc
		* 05/07/2012 - MMaass Added the ClientIdentifier to the Resultset
		* 05/09/2012 - MMaass Only Selected Records From CenterFeeBatches that are Completed.
		* 05/14/2012 - MMaass TaxExempt Clients should have a value of zero in the tax fields when tax Exempt
		* 05/15/2012 - MMaass Ignore TaxExempt, fees will always be taxed.
		* 05/30/2012 - MMaass Added InvoiceNumber to the ResultSet
		* 06/04/2012 - MMaass Fixed Logic to Exclude People who have made payments.
		* 06/18/2012 - MMaass Added Logic to Exclude Transactions that already have a PayCycleTransaction
		* 06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		* 07/25/2012 - MMaass Changed Logic to use Orginial PayCycle Transaction to determine Account Type
		* 10/15/2012 - MMaass Added PCP Write Sales Code
		* 03/04/2014 - MTovbin Modified to use Client Membership to determine fees.
		* 03/06/2014 - MTovbin Modified to determine EFT Profile to use by Business Segment
		* 06/23/2016 - SLemery Modified to get TaxType1 and TaxType2 and add to Sales Order Detail insert
		* 09/17/2017 - SLemery Replaced code that generated the Invoice Number with a call to the mtnGetInvoiceNumber stored proc
		* 09/20/2017 - SLemery Modified to exclude processing the decline if Write Off with EFTFEE sales code was performed
		****************************************************************************************************************
		***		  The selection logic in this procedure should match the logic in selEFTCenterResultDeclines       *****
		****************************************************************************************************************
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selClientEFTForCenterDeclineProcessing] '595F7DE3-2FD4-4097-8690-05BF0E2DCA71', 'DEBB3A68-2FBD-402E-8DB3-41FCACD6CCFE'
***********************************************************************/
CREATE PROCEDURE [dbo].[selClientEFTForCenterDeclineProcessing]
 @CenterDeclineBatchGuid UNIQUEIDENTIFIER,
 @EmployeeGUID uniqueidentifier

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @RunDate DateTime
	DECLARE @CenterFeeBatchGUID char(36)

	SELECT @RunDate = RunDate, @CenterFeeBatchGUID = CenterFeeBatchGUID  FROM datCenterDeclineBatch where CenterDeclineBatchGUID = @CenterDeclineBatchGuid

	DECLARE @CenterFeeBatchStatus_CompletedID int
	SELECT @CenterFeeBatchStatus_CompletedID = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @CenterDeclineBatchStatusID_Processing int
	SELECT @CenterDeclineBatchStatusID_Processing = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'

	DECLARE @EFT_MONTHLY_FEE INT
	SELECT @EFT_MONTHLY_FEE = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'

	DECLARE @DeclineTransaction TABLE
	(
		Id int identity,
		PayCycleTransactionGUID char(36) Primary Key ,
		ChargeAmount money,
		Amount money,
		CenterFeeBatchGUID char(36),
		ClientGUID char(36),
		ClientMembershipGUID uniqueidentifier,
		EFTProfileClientMembershipGUID uniqueidentifier,
		IsSuccessfulFlag bit,
		IsReprocessFlag bit,
		SalesOrderGUID uniqueidentifier,
		TaxRate1 money,
		TaxRate2 money,
		InvoiceNumber nvarchar(50),
		DoesSalesOrderExist bit not null ,
		TaxType1ID int,
		TaxType2ID int
	)

	INSERT INTO @DeclineTransaction(
			PayCycleTransactionGUID,
			ChargeAmount,
			Amount,
			CenterFeeBatchGUID,
			ClientGUID,
			ClientMembershipGUID,
			EFTProfileClientMembershipGUID,
			IsSuccessfulFlag,
			IsReprocessFlag,
			DoesSalesOrderExist,
			TaxRate1,
			TaxRate2,
			SalesOrderGUID,
			InvoiceNumber,
			TaxType1ID,
			TaxType2ID)
		Select DISTINCT trans.PayCycleTransactionGUID
				,trans.ChargeAmount
				,trans.FeeAmount
				,trans.CenterFeeBatchGUID
				,trans.ClientGUID
				,transSo.ClientMembershipGUID
				,ceft.ClientMembershipGUID
				,trans.IsSuccessfulFlag
				,trans.IsReprocessFlag
				,CAST(CASE WHEN so.SalesOrderGUID IS NULL THEN 0 ELSE 1 END AS BIT) AS DoesSalesOrderExist
				,sod.TaxRate1
				,sod.TaxRate2
				,so.SalesOrderGUID
				,so.InvoiceNumber
				,sod.TaxType1ID
				,sod.TaxType2ID
		from datPayCycleTransaction trans
			INNER JOIN datSalesOrder transSo ON transSo.SalesOrderGUID = trans.SalesOrderGUID
			INNER JOIN datClientMembership transCM ON transCM.ClientMembershipGUID = transSO.ClientMembershipGUID
			INNER JOIN cfgMembership transMem ON transMem.MembershipID = transCM.MembershipID
			CROSS APPLY  -- Find Client EFT for the same business segment (CC Profile)
				(
					SELECT eft.*
						FROM datClientEFT eft
							INNER JOIN datClientMembership eftCM ON eftCM.ClientMembershipGUID = eft.ClientMembershipGUID
							INNER JOIN cfgMembership eftMem  ON eftMem.MembershipID = eftCM.MembershipID
							INNER JOIN lkpEFTAccountType eft_at ON eft_at.EFTAccountTypeID = eft.EFTAccountTypeID
						WHERE eft.ClientGUID = trans.ClientGUID
								AND eftMem.BusinessSegmentID = transMem.BusinessSegmentID
								AND eft_at.EFTAccountTypeDescriptionShort = 'CreditCard'
				) ceft
			--INNER JOIN datClientEFT ceft on transSo.ClientMembershipGUID = ceft.ClientMembershipGUID
			INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
			INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
			INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
			--INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
			LEFT OUTER JOIN lkpPayCycleTransactionType pctt ON trans.PayCycleTransactionTypeId = pctt.PayCycleTransactionTypeId
			LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
								AND decline.CenterDeclineBatchStatusID = @CenterDeclineBatchStatusID_Processing
								AND decline.CenterDeclineBatchGUID <> @CenterDeclineBatchGuid
			----LEFT OUTER JOIN datPayCycleTransaction declinetrans ON @CenterDeclineBatchGuid = declinetrans.CenterDeclineBatchGUID
			----					AND c.ClientGUID = declinetrans.ClientGUID
			--Add a Check to verify that no PayCycleTransaction(s) already exist for client
			OUTER APPLY  -- Check if pay cycle transaction already exists for that business segment.
			(
				SELECT dtran.*
				FROM datPayCycleTransaction dtran
					INNER JOIN datSalesOrder dso ON dso.SalesOrderGUID = dtran.SalesOrderGUID
					INNER JOIN datClientMembership dCM ON dCM.ClientMembershipGUID = dso.ClientMembershipGUID
					INNER JOIN cfgMembership dMem  ON dMem.MembershipID = dCM.MembershipID
				WHERE dtran.CenterDeclineBatchGUID = @CenterDeclineBatchGuid
					AND dMem.BusinessSegmentID = transMem.BusinessSegmentID
			) declinetrans

			--Add a Check to determine if a SalesOrder has already been created
			LEFT OUTER JOIN datSalesOrder so on @CenterDeclineBatchGuid = so.CenterDeclineBatchGUID
								AND ceft.ClientMembershipGUID = so.ClientMembershipGUID
			LEFT OUTER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
		WHERE fee.CenterFeeBatchGUID = @CenterFeeBatchGUID
			AND trans.IsReprocessFlag = 1
			AND trans.IsSuccessfulFlag = 0
			AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
			AND trans.CenterDeclineBatchGUID IS NULL
			AND decline.CenterDeclineBatchGUID IS NULL
			AND declinetrans.PayCycleTransactionGUID IS NULL
			AND pctt.PayCycleTransactionTypeDescriptionShort = 'CC'
			AND GETUTCDATE() BETWEEN
					[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
					AND
					DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
			AND c.ClientGUID NOT IN (
				(SELECT so.ClientGUID
					FROM datSalesOrder so
						INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
								AND (sod.SalesCodeID = @PAYMENT_RECEIVED OR sod.SalesCodeID = @PCP_WRITEOFF OR (sod.SalesCodeID = @EFT_MONTHLY_FEE AND sod.WriteOffSalesOrderDetailGUID IS NOT NULL))
					WHERE c.ClientGUID = so.ClientGUID
								AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))

				-- Internal Variables
				DECLARE @SalesOrderGUID uniqueidentifier,
						@SalesOrderTypeID_MonthlyFee int,
						@SalesCodeID int,
						@HCUser nvarchar(25),
						@BatchRunDate datetime,
						@InvoiceNumber nvarchar(50),
						@InvoiceCounter int,
						@CenterId int,
						@TaxRate1 money,
						@TaxRate2 money,
						@TaxType1ID int,
						@TaxType2ID int

				--Find the CenterId
				SELECT @CenterId = CenterID From datCenterFeeBatch WHERE CenterFeeBatchGUID = @CenterFeeBatchGUID

				--Get the HairClub UserLogin From the EmployeeGUID
				Select @HCUser = UserLogin from datEmployee where EmployeeGUID = @EmployeeGUID

				--GET the SalesCodeID
				SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'AUTO CC PMT'

				--Retrieve the SalesOrderTypeID for the MonthlyFee (FO)
				SELECT @SalesOrderTypeID_MonthlyFee = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'FO'

				--CURSOR VARIABLES
				DECLARE @ClientGUID uniqueidentifier,
						@ClientMembershipGUID uniqueidentifier,
						@MembershipId int,
						@ChargeAmount money,
						@Amount money,
						@Id int,
						@DoesSalesOrderExists bit

				DECLARE CLIENT_CURSOR CURSOR FAST_FORWARD FOR
						SELECT dt.Id
							,dt.ClientGUID
							,dt.ClientMembershipGUID
							,cm.MembershipId
							,dt.ChargeAmount
							,dt.Amount
							,dt.DoesSalesOrderExist
						FROM @DeclineTransaction dt
							INNER JOIN datPayCycleTransaction trans on dt.PayCycleTransactionGUID = trans.PayCycleTransactionGUID
							--INNER JOIN datClientEFT ceft on dt.ClientMembershipGUID = ceft.ClientMembershipGUID
							INNER JOIN datClientMembership cm on dt.ClientMembershipGUID = cm.ClientMembershipGUID
							--INNER JOIN datClient c on dt.ClientGUID  = c.ClientGUID

				OPEN CLIENT_CURSOR
				FETCH NEXT FROM CLIENT_CURSOR INTO @Id, @ClientGUID, @ClientMembershipGUID, @MembershipId, @ChargeAmount, @Amount, @DoesSalesOrderExists

				WHILE (@@FETCH_STATUS = 0)
				   BEGIN
						IF @DoesSalesOrderExists = 0
							BEGIN
					  				--Get the TaxRates
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

									--Grab the next Invoice Number
									DECLARE @TempInvoiceNumberTable TABLE (InvoiceNumber nvarchar(50))
									INSERT INTO @TempInvoiceNumberTable EXEC mtnGetInvoiceNumber @CenterID
									SELECT @InvoiceNumber = InvoiceNumber FROM @TempInvoiceNumberTable

									--SET the SalesOrderGUID
									SET @SalesOrderGUID = NEWID()

									--Insert datSalesOrder Record
									INSERT INTO datSalesOrder(
										SalesOrderGUID
										,TenderTransactionNumber_Temp
										,TicketNumber_Temp
										,CenterID
										,ClientHomeCenterID
										,SalesOrderTypeID
										,ClientGUID
										,ClientMembershipGUID
										,AppointmentGUID
										,HairSystemOrderGUID
										,OrderDate
										,InvoiceNumber
										,IsTaxExemptFlag
										,IsVoidedFlag
										,IsClosedFlag
										,RegisterCloseGUID
										,EmployeeGUID
										,FulfillmentNumber
										,IsWrittenOffFlag
										,IsRefundedFlag
										,RefundedSalesOrderGUID
										,CreateDate
										,CreateUser
										,LastUpdate
										,LastUpdateUser
										,ParentSalesOrderGUID
										,IsSurgeryReversalFlag
										,IsGuaranteeFlag
										,CenterFeeBatchGUID
										,CenterDeclineBatchGUID)
									VALUES
										(@SalesOrderGUID -- SalesOrderGUID
										,NULL    -- TenderTransactionNumber_Temp
										,NULL    -- TicketNumber_Temp
										,@CenterID --CenterID
										,@CenterID --CenterID
										,@SalesOrderTypeID_MonthlyFee --SalesOrderTypeID
										,@ClientGUID --ClientGUID
										,@ClientMembershipGUID --ClientMembershipGUID
										,NULL --AppointmentGUID
										,NULL --HairSystemOrderGUID
										,GETUTCDATE() --OrderDate
										,@InvoiceNumber --InvoiceNumber
										,0 --IsTaxExemptFlag
										,0 --IsVoidedflag
										,0 --IsClosedFlag  Need to be passed in?
										,NULL --RegisterCloseGUID
										,@EmployeeGUID  --EmployeeGUID
										,NULL --FulfillmentNumber
										,0 --IsWrittenOffFlag
										,0 --IsRefundedFlag
										,NULL --RefundedSalesOrderGUID
										,GETUTCDATE() --CreateDate
										,@HCUSER --CreateUser
										,GETUTCDATE() --LastUpdate
										,@HCUSER -- LastUpdateUser
										,NULL --ParentSalesOrderGUID
										,0 --IsSurgeryReversalFlag
										,NULL --IsGuarnteeFlag
										,@CenterFeeBatchGUID
										,@CenterDeclineBatchGuid)


								INSERT INTO datSalesOrderDetail(
											SalesOrderDetailGUID
											,TransactionNumber_Temp
											,SalesOrderGUID
											,SalesCodeID
											,Quantity
											,Price
											,Discount
											,Tax1
											,Tax2
											,TaxRate1
											,TaxRate2
											,IsRefundedFlag
											,RefundedSalesOrderDetailGUID
											,RefundedTotalQuantity
											,RefundedTotalPrice
											,Employee1GUID
											,Employee2GUID
											,Employee3GUID
											,Employee4GUID
											,PreviousClientMembershipGUID
											,NewCenterID
											,CreateDate
											,CreateUser
											,LastUpdate
											,LastUpdateUser
											,Center_Temp
											,TaxType1ID
											,TaxType2ID)
								VALUES(NEWID() --SalesOrderDetailGUID
											,NULL --TransactionNumber_Temp
											,@SalesOrderGUID --SalesOrderGUID
											,@SalesCodeID --SalesCodeID
											,1 --Quantity
											,@ChargeAmount --Price
											,0 --Discount
											,(ISNULL(@Amount,0) * ISNULL(@TaxRate1,0)) -- Tax1
											,(ISNULL(@Amount,0) * ISNULL(@TaxRate2,0)) -- Tax2
											,@TaxRate1 --TaxRate1
											,@TaxRate2 --TaxRate2
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
											,NULL --Center_Temp
											,@TaxType1ID
											,@TaxType1ID)

								--Update the SalesOrderGUID
								Update @DeclineTransaction
									SET SalesOrderGUID = @SalesOrderGUID
										,TaxRate1 = @TaxRate1
										,TaxRate2 = @TaxRate2
										,InvoiceNumber = @InvoiceNumber
								FROM @DeclineTransaction
								WHERE [Id] = @Id
							END
					  FETCH NEXT FROM CLIENT_CURSOR INTO @Id, @ClientGUID, @ClientMembershipGUID, @MembershipId, @ChargeAmount, @Amount, @DoesSalesOrderExists
				   END
				CLOSE CLIENT_CURSOR
				DEALLOCATE CLIENT_CURSOR


		SELECT DISTINCT
			p1.SalesOrderGUID
			,ISNULL(p1.TaxRate1,0) as TaxRate1
			,ISNULL(p1.TaxRate2,0) as TaxRate2
			,c.ClientGUID
			,c.ClientFullNameCalc
			,c.CenterID
			,cEFT.ClientMembershipGUID AS ClientMembershipGUID
			,ISNULL(st.CenterFeeBatchStatusDescription, dstat.CenterFeeBatchStatusDescription) AS CenterFeeBatchStatusDescription
			,fee.CenterFeeBatchGUID
			--,trans.PayCycleTransactionGUID
			,@RunDate as RunDate
			-- FIELDS FOR SaleRequestTransaction OBJECT
			,ceft.[EFTAccountTypeID]
			,at.EFTAccountTypeDescriptionShort
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
			,trans.ChargeAmount as ChargeAmount
			,trans.FeeAmount as FeeAmount
			,trans.TaxAmount as TaxAmount
			,c.Address1 + ', ' + c.Address2 + ', ' + c.Address3 AS Street--
			,c.PostalCode --
			,CONVERT(bit,0) as IsTaxExempt
			,c.ClientIdentifier
			,at.EFTAccountTypeDescriptionShort
			,payCycle.FeePayCycleValue
			,ceft.AccountExpiration
			,p1.InvoiceNumber as InvoiceNumber
		from @DeclineTransaction p1
				INNER JOIN datPayCycleTransaction trans on p1.PayCycleTransactionGUID = trans.PayCycleTransactionGUID
				INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID  --Needed to get the Batch date, used in Where Clause
				INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
				INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
				INNER JOIN datClientEFT ceft on p1.EFTProfileClientMembershipGUID = ceft.ClientMembershipGUID
				LEFT OUTER JOIN lkpEFTAccountType at ON ceft.EFTAccountTypeID = at.EFTAccountTypeID
				LEFT OUTER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = fee.CenterFeeBatchStatusID
				LEFT OUTER JOIN dbo.lkpCenterFeeBatchStatus dstat ON dstat.CenterFeeBatchStatusID = 1

END
GO
