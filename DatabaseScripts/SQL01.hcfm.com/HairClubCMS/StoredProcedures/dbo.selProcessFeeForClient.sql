/* CreateDate: 05/14/2012 17:33:41.273 , ModifyDate: 09/17/2017 18:33:02.683 */
GO
/***********************************************************************
	PROCEDURE:				[selProcessFeeForClient]
	DESTINATION SERVER:		SQL01
	DESTINATION DATABASE: 	HairClubCMS
	RELATED APPLICATION:  	CMS
	AUTHOR: 				MMAASS
	IMPLEMENTOR: 			MMAASS
	DATE IMPLEMENTED: 		03/16/2012
	LAST REVISION DATE: 	03/16/2012
	--------------------------------------------------------------------------------------------------------
	NOTES: 	Return individual client eft details for transaction processing

			03/16/2012 - MMAASS Created Stored Proc
			05/30/2012 - MMAASS Added InvoiceNumber to the resultSet
			09/17/2017 - SLEMERY Replaced code that generated the Invoice Number with a call to the mtnGetInvoiceNumber stored proc
	--------------------------------------------------------------------------------------------------------
	SAMPLE EXECUTION:
	EXEC [selProcessFeeForClient] '6e9b7834-90ad-43be-a7d3-c1c5da9d74f3', '0485dbda-d23f-4b75-8d7a-9447db47924c'
	***********************************************************************/
	CREATE PROCEDURE [dbo].[selProcessFeeForClient]
	 @CenterFeeBatchGuid UNIQUEIDENTIFIER,
	 @ClientGuid UNIQUEIDENTIFIER,
	 @EmployeeGuid UNIQUEIDENTIFIER

	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
			DECLARE
			 @PayCycleID INT
			,@FeeYear INT
			,@FeeMonth INT
			,@CenterID INT

			SELECT
			 @PayCycleID =FeePayCycleID
			,@FeeYear =FeeYear
			,@FeeMonth =FeeMonth
			,@CenterID =CenterID
			FROM dbo.datCenterFeeBatch WHERE CenterFeeBatchGUID = @CenterFeeBatchGuid


			DECLARE @PayCycleValue int
			SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @PayCycleID)


			DECLARE @BatchRunDate datetime
			SET @BatchRunDate = GETUTCDATE()

		-- create temp table for each EFT profile
		DECLARE @ClientEFTStatus TABLE
		(
			ClientEFTGUID uniqueidentifier NOT NULL,
			Amount money NOT NULL,
			IsValidToRun bit NOT NULL,
			IsTaxExempt bit NOT NULL,
			ClientMembershipGUID uniqueidentifier NOT NULL,
			MembershipId int NULL
		)

		-- Insert into temp table if EFT Profile is valid to run
		INSERT INTO @ClientEFTStatus (ClientEFTGUID, Amount, IsValidToRun,IsTaxExempt,ClientMembershipGUID, MembershipId)
			SELECT
				c.ClientEFTGUID,
				ISNULL(cm.MonthlyFee, 0),
				CASE WHEN
						-- Credit Card Not Expired
						((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) <= c.AccountExpiration)
						OR at.EFTAccountTypeDescriptionShort != 'CreditCard')

						-- Active EFT Profile
						AND IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1

						-- Membership is Active
						AND (cm.BeginDate IS NULL OR (cm.BeginDate <= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)
							AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)))
					THEN 1 ELSE 0 END,
					cl.IsTaxExemptFlag as IsTaxExempt,
					cm.ClientMembershipGUID,
					cm.MembershipID
			FROM datClientEFT c
			 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
			 INNER JOIN datClientMembership cm on c.ClientMembershipGUID = cm.ClientMembershipGUID
			 LEFT JOIN dbo.cfgCenter Center on Center.CenterID = cm.CenterID
			 INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
			 LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
			 LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
			WHERE cl.CenterID = @centerId
				AND cl.ClientGUID = @ClientGuid
				AND Center.IsCorporateHeadquartersFlag =0


					-- Internal Variables
					DECLARE @SalesOrderGUID uniqueidentifier,
							@SalesOrderTypeID_MonthlyFee int,
							@SalesCodeID int,
							@HCUser nvarchar(25),
							@InvoiceNumber nvarchar(50),
							@InvoiceCounter int,
							@Amount money,
							@IsTaxExempt bit,
							@ClientMembershipGuid uniqueidentifier,
							@TaxRate1 money ,
							@TaxRate2 money ,
							@MembershipId int

					--Set IsTaxExempt & ClientMembershipGuid
					SELECT @IsTaxExempt = IsTaxExempt, @ClientMembershipGuid = ClientMembershipGUID FROM @ClientEFTStatus

					--Find the CenterId
					SELECT @CenterId = CenterID From datCenterFeeBatch WHERE CenterFeeBatchGUID = @CenterFeeBatchGUID

					--Get the HairClub UserLogin From the EmployeeGUID
					Select @HCUser = UserLogin from datEmployee where EmployeeGUID = @EmployeeGUID

					--GET the SalesCodeID
					SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EFTFEE'

					--Retrieve the SalesOrderTypeID for the MonthlyFee (FO)
					SELECT @SalesOrderTypeID_MonthlyFee = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'FO'

					--SET the MembershipId
					SELECT TOP 1 @MembershipId = MembershipId From @ClientEFTStatus

					--Get the TaxRates
					SELECT @TaxRate1 = ISNULL(mTaxRate1.TaxRate, ISNULL(cTaxRate1.TaxRate,0))
							,@TaxRate2 = ISNULL(mtaxrate2.TaxRate, ISNULL(cTaxRate2.TaxRate,0))
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
						,CenterFeeBatchGUID)
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
						,@IsTaxExempt --IsTaxExemptFlag
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
						,@CenterFeeBatchGUID)


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
							,Center_Temp)
				VALUES(NEWID() --SalesOrderDetailGUID
							,NULL --TransactionNumber_Temp
							,@SalesOrderGUID --SalesOrderGUID
							,@SalesCodeID --SalesCodeID
							,1 --Quantity
							,@Amount --Price
							,0 --Discount
							,0 --Tax1
							,0 --Tax2
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
							,NULL) --Center_Temp




		SELECT
			@SalesOrderGUID as SalesOrderGuid
			,ISNULL(@TaxRate1,0) as TaxRate1
			,ISNULL(@TaxRate2,0) as TaxRate2
			,c.ClientGUID
			,c.ClientFullNameCalc
			,c.CenterID
			,eftStat.ClientMembershipGUID
			,ISNULL(st.CenterFeeBatchStatusDescription, dstat.CenterFeeBatchStatusDescription) AS CenterFeeBatchStatusDescription
			,cab.RunDate
			,eftstat.ClientMembershipGUID
		  ,ceft.[EFTAccountTypeID]
		  ,ceft.[EFTStatusID]
		  ,at.EFTAccountTypeDescriptionShort
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
		  ,c.Address1 + ', ' + c.Address2 + ', ' + c.Address3 AS Street--
		  ,c.PostalCode --
		  ,c.IsTaxExemptFlag as IsTaxExempt
		  ,CAST(CASE WHEN GETDATE() BETWEEN ceft.Freeze_Start AND Freeze_End THEN 1 ELSE 0 END  AS BIT) AS 'IsFrozen'
		  ,@InvoiceNumber as InvoiceNumber
		FROM @ClientEFTStatus eftStat
			INNER JOIN datClientEFT ceft ON eftStat.ClientEFTGUID = ceft.ClientEFTGUID
			INNER JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
			INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
			LEFT OUTER JOIN datCenterFeeBatch cab ON cab.CenterID = c.CenterID
				AND cab.FeeMonth = @FeeMonth
				AND cab.FeeYear = @FeeYear
				AND cab.FeePayCycleID = @PayCycleID
			LEFT OUTER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
			LEFT JOIN dbo.lkpCenterFeeBatchStatus dstat ON dstat.CenterFeeBatchStatusID = 1
			LEFT OUTER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
		WHERE eftStat.IsValidToRun = 1
		--AND st.CenterFeeBatchStatusID = @CenterFeeBatchStatusID
		ORDER BY pc.FeePayCycleValue

	END
GO
