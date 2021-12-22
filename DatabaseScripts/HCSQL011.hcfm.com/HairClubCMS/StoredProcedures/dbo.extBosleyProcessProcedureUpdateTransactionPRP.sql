/* CreateDate: 05/21/2017 22:25:07.220 , ModifyDate: 03/09/2020 15:11:19.457 */
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessProcedureUpdateTransactionPRP

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		05/02/2017

LAST REVISION DATE: 	05/02/2017

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Procedure Update transactions sent by Bosley for PRP.
	* 05/02/2017 PRM - Created
	* 05/24/2018 MVT - Added logic to update email if sent by Bosley.
	* 04/30/2019 SAL - Removed code that creates the sales order for a contract ajustment when cancelling
						the Add-On.  No longer need to adjust the contract because Add-Ons are now being
						accounted for on their own and are not lumped into the Client Membership. (TFS #12385)
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. Moved reading of the Email Address from
					incoming request log to the top and modified query that updates email on client record to only update if not set on the client record. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @IsSuccessfullyProcessed BIT
exec [extBosleyProcessProcedureUpdateTransactionPRP] @1234, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessProcedureUpdateTransactionPRP]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(10) = 'Bosley-PRP'

	DECLARE @BOSLEYPROCEDURESTATUS_CANCELLED nvarchar(30) = 'Cancelled'
	DECLARE @ADDON_TGE nvarchar(15) = 'TGE'
	DECLARE @ADDON_TGE9BPS nvarchar(15) = 'TGE9BPS'

	DECLARE @CMSADDONSTATUS_ACTIVE nvarchar(15) = 'Active'
	DECLARE @CMSADDONSTATUS_CANCELLED nvarchar(15) = 'Canceled'
	DECLARE @SALESCODE_CANCELADDON nvarchar(15) = 'CANCELADDON'

	DECLARE @AddOnId_TGE INT,
			@AddOnId_TGE9BPS INT,
			@ClientMembershipAddOnStatusID_Active INT,
			@ClientMembershipAddOnStatusID_Canceled INT

	SELECT @AddOnId_TGE = AddOnID FROM cfgAddOn WHERE AddOnDescriptionShort = @ADDON_TGE
	SELECT @AddOnId_TGE9BPS = AddOnID FROM cfgAddOn WHERE AddOnDescriptionShort = @ADDON_TGE9BPS

	SELECT @ClientMembershipAddOnStatusID_Active = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_ACTIVE
	SELECT @ClientMembershipAddOnStatusID_Canceled = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_CANCELLED

	DECLARE @EmailAddress AS nvarchar(100), @ClientGUID AS uniqueidentifier, @BosleySalesforceAccountID nvarchar(50)

	SELECT  @EmailAddress = irl.EmailAddress
			, @ClientGUID = c.ClientGUID
			, @BosleySalesforceAccountID = irl.BosleySalesforceAccountID
	FROM datIncomingRequestLog irl
		INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
	WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

	-- Update Bosley Salesforce Account ID
	IF (@ClientGUID IS NOT NULL AND @BosleySalesforceAccountID IS NOT NULL AND LTRIM(RTRIM(@BosleySalesforceAccountID)) <> '')
	BEGIN
		UPDATE c SET
			BosleySalesforceAccountID = @BosleySalesforceAccountID
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID
			AND (c.BosleySalesforceAccountID IS NULL OR
					(c.BosleySalesforceAccountID <> @BosleySalesforceAccountID))
	END


	IF (@ClientGUID IS NULL)
	BEGIN
		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = 'Unable to process, client not found.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END
	ELSE IF NOT EXISTS (SELECT irl.* FROM datIncomingRequestLog irl
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							AND (irl.ProcedureStatus IS NULL OR irl.ProcedureStatus = @BOSLEYPROCEDURESTATUS_CANCELLED))
	  BEGIN
			-- add warning
			UPDATE irl SET
				WarningMessage = 'Record not processed. ProcedureStatus is not set to Cancelled.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
			FROM datIncomingRequestLog irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			SET @IsSuccessfullyProcessed = 1

	  END
	ELSE IF NOT EXISTS (SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						INNER JOIN datClientMembershipAddOn cmao on cm.ClientMembershipGUID = cmao.ClientMembershipGUID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND cmao.ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Active
						AND cmao.AddOnID IN (@AddOnId_TGE, @AddOnId_TGE9BPS))
			BEGIN
				-- add warning
				Update datIncomingRequestLog
					SET WarningMessage = 'Record not processed. No Active PRP Add-On exists'
						,LastUpdate = GETDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				SET @IsSuccessfullyProcessed = 1
			END
	ELSE
	  BEGIN

		DECLARE @SalesOrderGUID uniqueidentifier = NEWID(),
				@InvoiceNumber nvarchar(50),
				@EmployeeGUID Uniqueidentifier,
				@MembershipOrder_SalesOrderTypeID INT,
				@CenterID INT,
				@CurrentSurgeryMembershipGUID UNIQUEIDENTIFIER,
				@MembershipDescriptionShort NVARCHAR(15),
				@SalesCodeId_CancelAddOn INT,
				@ClientMembershipAddOnID INT
		DECLARE @TempInvoiceTable table (InvoiceNumber nvarchar(50))
		DECLARE @SalesCodeId_ContractAdjust INT,
				@CurrentContractBal DECIMAL(21,6) = 0

		SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'
		SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
		SELECT @SalesCodeId_CancelAddOn = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = @SALESCODE_CANCELADDON

		SELECT 	@CenterID = c.CenterID,
				@CurrentSurgeryMembershipGUID = CurrentSurgeryClientMembershipGUID,
				@MembershipDescriptionShort = m.MembershipDescriptionShort
		FROM datIncomingRequestLog irl
			INNER JOIN datClient c on c.ClientIdentifier = irl.ConectID
			INNER JOIN datClientMembership cm ON c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN cfgMembership m ON cm.MembershipId = m.MembershipId
			INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusId = cms.ClientMembershipStatusId
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			AND cms.IsActiveMembershipFlag = 1

		SELECT TOP 1 @ClientMembershipAddOnID = ClientMembershipAddOnID
		FROM datClientMembershipAddOn cmao
		WHERE cmao.ClientMembershipGUID = @CurrentSurgeryMembershipGUID
			AND cmao.ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Active
			AND cmao.AddOnId IN (@AddOnId_TGE, @AddOnId_TGE9BPS)

		UPDATE datClientMembershipAddOn
		SET ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Canceled
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID

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
			,@MembershipOrder_SalesOrderTypeID as SalesOrderTypeID
			,c.ClientGUID as ClientGUID
			,@CurrentSurgeryMembershipGUID as ClientMembershipGUID
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
			,@User as CreateUser
			,GETUTCDATE() as LastUpdate
			,@User as LastUpdateUser
			,NULL as ParentSalesOrderGUID
			,0 as IsSurgeryReversalFlag
			,0 as IsGuaranteeFlag
			,NULL as cashier_temp
			,GETUTCDATE() as ctrOrderDate
			,NULL as CenterFeeBatchGUID
			,NULL as CenterDeclineBatchGUID
			,NULL as RegisterID
			,NULL as EndOfDayGUID
			,irl.IncomingRequestID as IncomingRequestID
		FROM datIncomingRequestLog irl
			INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
			INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

		INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
										IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
										PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
										Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
										MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber, ClientMembershipAddOnID)
		SELECT NEWID() as SalesOrderDetailGUID
			,NULL as TransactionNumber_Temp
			,@SalesOrderGUID as SalesOrderGUID
			,@SalesCodeId_CancelAddOn as SalesCodeID
			,1 as Quantity
			,0 as [Price]
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
			,@User as CreateUser
			,GETUTCDATE() as LastUpdate
			,@User as LastUpdateUser
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
			,@ClientMembershipAddOnID as ClientMembershipAddOnID

		--Update the Accumulators
		EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

		SET @IsSuccessfullyProcessed = 1

	  	UPDATE c SET
			EmailAddress = @EmailAddress
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID
			AND (c.EmailAddress IS NULL OR c.EmailAddress = '')
			AND (@EmailAddress IS NOT NULL AND @EmailAddress <> '')

	  END
END
GO
