/* CreateDate: 06/22/2017 17:21:45.867 , ModifyDate: 06/22/2017 17:21:45.867 */
GO
/***********************************************************************

PROCEDURE:				utilCreateSurgeryClientMembership

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/21/17

LAST REVISION DATE: 	06/21/17

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Cool Sculpting transactions sent by Bosley.
	* 06/21/17 PRM - Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:
exec [utilCreateSurgeryClientMembership] @CurrentTransactionIdBeingProcessed, 'TGE', 'TGE9BPS', @IsSuccessfullyProcessed OUTPUT
***********************************************************************/

CREATE PROCEDURE [dbo].[utilCreateSurgeryClientMembership]
	  @ClientGUID UNIQUEIDENTIFIER,
	  @EmployeeGUID UNIQUEIDENTIFIER,
	  @NewClientMembershipGUID UNIQUEIDENTIFIER,
	  @NewMembershipDescriptionShort NVARCHAR(10),
	  @UpdatedCurrentClientMembershipStatusDescriptionShort NVARCHAR(15),
	  @ContractPrice DECIMAL(21,6),
      @GraftCount INT,
	  @AssignSalesCodeID INT,
	  @BeginDate DATETIME,
	  @Username NVARCHAR(25),
	  @IncomingRequestID INT = NULL

AS
BEGIN

	SET NOCOUNT ON;

		DECLARE @NewClientMembershipStatusID INT,
				@UpdatedCurrentClientMembershipStatusID INT,
				@CurrentClientMembershipStatusDescriptionShort NVARCHAR(10),
				@CurrentClientMembershipGUID UNIQUEIDENTIFIER,
				@NewMembershipID INT,
				@ClientMembershipNumber NVARCHAR(50),
				@CenterID INT


		SELECT @NewMembershipID = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = @NewMembershipDescriptionShort
		SELECT @NewClientMembershipStatusID = ClientMembershipStatusID FROM LkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
		SELECT @UpdatedCurrentClientMembershipStatusID = ClientMembershipStatusID FROM LkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = @UpdatedCurrentClientMembershipStatusDescriptionShort

		SELECT
			@CurrentClientMembershipStatusDescriptionShort = st.ClientMembershipStatusDescriptionShort
			, @CurrentClientMembershipGUID = cm.ClientMembershipGUID
			, @CenterID = c.CenterID
		FROM datClient c
			LEFT JOIN datClientMembership cm ON c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
			LEFT JOIN lkpClientMembershipStatus st ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
		WHERE c.ClientGUID = @ClientGUID

		--INSERT Client Membership record
		INSERT INTO datClientMembership (
			ClientMembershipGUID,
			Member1_ID_Temp,
			ClientGUID,
			CenterID,
			MembershipID,
			ClientMembershipStatusID,
			ContractPrice,
			ContractPaidAmount,
			MonthlyFee,
			BeginDate,
			EndDate,
			MembershipCancelReasonID,
			CancelDate,
			IsGuaranteeFlag,
			IsRenewalFlag,
			IsMultipleSurgeryFlag,
			RenewalCount,
			IsActiveFlag,
			CreateDate, CreateUser, LastUpdate, LastUpdateUser,
			ClientMembershipIdentifier)
		SELECT
			@NewClientMembershipGUID AS  ClientMembershipGUID,
			NULL AS  Member1_ID_Temp,
			@ClientGUID AS  ClientGUID,
			@CenterID,
			m.MembershipID AS  MembershipID,
			@NewClientMembershipStatusID AS  ClientMembershipStatusID,
			@ContractPrice AS ContractPrice,
			0 AS  ContractPaidAmount,
			0 AS  MonthlyFee,
			@BeginDate,
			DATEADD(MONTH, m.DurationMonths, @BeginDate)  AS  EndDate,
			NULL AS  MembershipCancelReasonID,
			NULL AS  CancelDate,
			0 AS  IsGuaranteeFlag,
			0 AS  IsRenewalFlag,
			0 AS  IsMultipleSurgeryFlag,
			0 AS  RenewalCount,
			1 AS  IsActiveFlag,
			GETUTCDATE() AS CreateDate, @Username AS CreateUser, GETUTCDATE() AS LastUpdate, @Username AS LastUpdateUser, @ClientMembershipNumber
		FROM cfgMembership m
		WHERE m.MembershipID = @NewMembershipID

		--Get Client Membership Number
		EXEC [mtnGetClientMembershipNumber] @ClientGUID, @CenterID, @BeginDate, @ClientMembershipNumber OUTPUT

		-- Update Client Membershp Identifier
		UPDATE datClientMembership SET
			[ClientMembershipIdentifier] = @ClientMembershipNumber
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @UserName
		WHERE clientmembershipguid = @NewClientMembershipGUID

		IF (@CurrentClientMembershipStatusDescriptionShort IS NOT NULL
				AND @CurrentClientMembershipStatusDescriptionShort = 'A')
		BEGIN
			--Update previous Membership
			UPDATE datClientMembership SET
				EndDate = DATEADD(DAY,-1,@BeginDate)
				,ClientMembershipStatusID = @UpdatedCurrentClientMembershipStatusID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UserName
			WHERE clientmembershipguid = @CurrentClientMembershipGUID
		END

		-- Update Memberhsip on the client record
		UPDATE datClient SET
				CurrentSurgeryClientMembershipGUID = @NewClientMembershipGUID
			, LastUpdateUser = @UserName
			, LastUpdate = GETUTCDATE()
		WHERE ClientGUID = @ClientGUID

		--Create Client Membership Accumulator records
		INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @NewClientMembershipGUID, AccumulatorID, 0, 0.00, NULL, InitialQuantity,
			GETUTCDATE(),@UserName,GETUTCDATE(),@UserName
		FROM cfgMembershipAccum
		WHERE MembershipID = @NewMembershipID
			AND IsActiveFlag = 1


		-- CREATE MEMBERSHIP ORDER
		DECLARE @SalesOrderGUID UNIQUEIDENTIFIER,
				@MembershipTenderTypeID INT,
				@InvoiceNumber nvarchar(50),
				@MembershipOrderSalesOrderTypeID INT

		DECLARE @TempInvoiceTable table (InvoiceNumber nvarchar(50))

		SET @SalesOrderGUID = NEWID()
		SELECT @MembershipOrderSalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] WHERE SalesOrderTypeDescriptionShort = 'MO'
		SELECT @MembershipTenderTypeID = TenderTypeID FROM LkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'


			--DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT, @MEMBERSHIP_TENDERTYPEID INT

			--Select @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'

		--create an invoice #
		INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
		SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
		DELETE FROM @TempInvoiceTable

		INSERT INTO [dbo].[datSalesOrder] (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID, SalesOrderTypeID, ClientGUID, ClientMembershipGUID,
											AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber, IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID,
											FulfillmentNumber, IsWrittenOffFlag, IsRefundedFlag, RefundedSalesOrderGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
											ParentSalesOrderGUID , IsSurgeryReversalFlag, IsGuaranteeFlag, cashier_temp, ctrOrderDate, CenterFeeBatchGUID, CenterDeclineBatchGUID,
											RegisterID, EndOfDayGUID, IncomingRequestID)
		Select @SalesOrderGUID as SalesOrderGUID
			,NULL as TenderTransactionNumber_Temp
			,NULL as TicketNumber_Temp
			,c.CenterID as CenterID
			,c.CenterID as ClientHomeCenterID
			,@MembershipOrderSalesOrderTypeID as SalesOrderTypeID
			,c.ClientGUID as ClientGUID
			,@NewClientMembershipGUID as ClientMembershipGUID
			,NULL as AppointmentGUID
			,NULL as HairSystemOrderGUID
			,GETUTCDATE() as OrderDate
			,@InvoiceNumber as InvoiceNumber
			,0 as IsTaxExemptFlag
			,0 as IsVoidedFlag
			,1 as IsClosedFlag
			,NULL as RegisterCloseGUID
			,@EmployeeGUID as EmployeeGUID
			,NULL as FulfillmentNumber
			,0 as IsWrittenOffFlag
			,0 as IsRefundedFlag
			,NULL as RefundedSalesOrderGUID
			,GETUTCDATE() as CreateDate
			,@UserName as CreateUser
			,GETUTCDATE() as LastUpdate
			,@UserName as LastUpdateUser
			,NULL as ParentSalesOrderGUID
			,0 as IsSurgeryReversalFlag
			,0 as IsGuaranteeFlag
			,NULL as cashier_temp
			,GETUTCDATE() as ctrOrderDate
			,NULL as CenterFeeBatchGUID
			,NULL as CenterDeclineBatchGUID
			,NULL as RegisterID
			,NULL as EndOfDayGUID
			,@IncomingRequestID
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID

		INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
										IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
										PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
										Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
										MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber)
		SELECT NEWID() as SalesOrderDetailGUID
			,NULL as TransactionNumber_Temp
			,@SalesOrderGUID as SalesOrderGUID
			,@AssignSalesCodeID as SalesCodeID
			,0 as Quantity
			,0 as Price
			,0 as Discount
			,NULL as Tax1
			,NULL as Tax2
			,0 as TaxRate1
			,0 as TaxRate2
			,0 as IsRefundedFlag
			,NULL as RefundedSalesORderDetailGUID
			,NULL as RefundedTotalQuantity
			,NULL as RefundedTotalPrice
			,@EmployeeGUID as Employee1GUID
			,NULL as Employee2GUID
			,NULL as Employee3GUID
			,NULL as Employee4GUID
			,NULL as previousClientMembershipGUID
			,NULL as NewCenterID
			,GETUTCDATE() as CreateDate
			,@UserName as CreateUser
			,GETUTCDATE() as LastUpdate
			,@UserName as LastUpdateUser
			,NULL as Center_Temp
			,NULL as performer_temp
			,NULL as performer2_temp
			,NULL as Member1Price_temp
			,NULL as CancelReasonID
			,1 as EntrySortOrder
			,NULL as HairSystemOrderGUID
			,NULL as DiscountTypeID
			,1 as BenefitTrackingEnabledFlag
			,NULL as MembershipPromotionID
			,NULL as MembershipOrderReasonID
			,NULL as MembershipNotes
			,NULL as genericSalesCodeDescription
			,NULL as SalesCodeSerialNumber

		INSERT INTO datSalesOrderTender(SalesOrderTenderGUID, SalesOrderGUID, TenderTypeID, Amount, CheckNumber, CreditCardLast4Digits, ApprovalCode, CreditCardTypeID, FinanceCompanyID,
										InterCompanyReasonID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, RefundAmount, MonetraTransactionId, EntrySortOrder, CashCollected)
		SELECT NEWID() as SalesOrderTenderGUID
			,@SalesOrderGUID as SalesOrderGUID
			,@MembershipTenderTypeID as TenderTypeID
			,0 as Amount
			,NULL as CheckNumber
			,NULL as CreditCardLast4Digits
			,NULL as ApprovalCode
			,NULL as CreditCardTypeID
			,NULL as FinanceCompanyID
			,NULL as InterCompanyReasonID
			,GETUTCDATE() as CreateDAte
			,@UserName as CreateUser
			,GETUTCDATE() as LastUpdate
			,@UserName as LastUpdateUser
			,0 as RefundedAmount
			,NULL as MonetraTransactionID
			,1 as EntrySortOrder
			,NULL as CashCollected

		--Update the Accumulators
		EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID
END
GO
