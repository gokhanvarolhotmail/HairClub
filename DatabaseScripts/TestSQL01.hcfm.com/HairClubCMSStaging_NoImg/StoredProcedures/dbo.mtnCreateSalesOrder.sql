/* CreateDate: 07/17/2013 15:28:41.097 , ModifyDate: 07/17/2013 15:38:43.840 */
GO
/***********************************************************************

PROCEDURE:				mtnCreateSalesOrder

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		7/16/13

LAST REVISION DATE: 	7/16/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Post EXT Sold transactions sent by Bosley.
	* 7/16/13 MLM - Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [mtnCreateSalesOrder] 286,'6/5/13 3:55','1E07E083-5BC0-4AC7-9022-05DA8A68F77A','192D3C76-F70D-4AF5-BD1C-2F74421FD02E',749,-2000,0,1,'9893FA8D-7053-4126-BFFA-13294F79E593','029E701D-B8D0-4A25-8B78-0DCD3933DA7C',NULL,'InterCoBOS',-2000

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnCreateSalesOrder]
	  @CenterID int,
	  @OrderDate DateTime,
	  @ClientGUID uniqueIdentifier,
	  @ClientMembershipGUID uniqueIdentifier,
	  @SalesCodeID int,
	  @Price decimal(21,6),
	  @Tax money,
	  @Quantity int,
	  @EmployeeGUID uniqueIdentifier,
	  @Employee1GUID uniqueIdentifier,
	  @Employee2GUID uniqueIdentifier,
	  @TenderTypeDescriptionShort nvarchar(10),
	  @TenderAmount money

AS
BEGIN

	SET NOCOUNT ON;

			-- SalesOrderType
			DECLARE @SalesOrder_SalesOrderTypeID INT
			SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'

			--TenderType
			DECLARE @TENDERTYPEID int
			SELECT @TENDERTYPEID = TenderTypeID FROM lkpTenderType where TenderTypeDescriptionShort = @TenderTypeDescriptionShort

			DECLARE @TempInvoiceTable table
			(
				InvoiceNumber nvarchar(50)
			)
			DECLARE @InvoiceNumber nvarchar(50)

			--create an invoice #
			INSERT INTO @TempInvoiceTable
				EXEC ('mtnGetInvoiceNumber ' + @CenterID)

			SELECT TOP 1 @InvoiceNumber = InvoiceNumber
			FROM @TempInvoiceTable

			DELETE FROM @TempInvoiceTable

			-- User
			DECLARE @User nvarchar(25) = 'sa-SurgeryFix'

			DECLARE @SalesOrderGUID uniqueIdentifier = newID()
			DECLARE @SalesOrderDetailGUID uniqueIdentifier = newid()
			DECLARE @SalesOrderTenderGUID uniqueIdentifier = newid()


			INSERT INTO [dbo].[datSalesOrder] (
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
						,cashier_temp
						,ctrOrderDate
						,CenterFeeBatchGUID
						,CenterDeclineBatchGUID
						,RegisterID
						,EndOfDayGUID
						,IncomingRequestID)
			Select @SalesOrderGUID as SalesOrderGUID
				,NULL as TenderTransactionNumber_Temp
				,NULL as TicketNumber_Temp
				,@CenterID as CenterID
				,@CenterID as ClientHomeCenterID
				,@SalesOrder_SalesOrderTypeID as SalesOrderTypeID
				,@ClientGUID as ClientGUID
				,@ClientMembershipGUID as ClientMembershipGUID
				,NULL as AppointmentGUID
				,NULL as HairSystemOrderGUID
				,@OrderDate as OrderDate
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
				,GETDATE() as CreateDate
				,@User as CreateUser
				,GETDATE() as LastUpdate
				,@User as LastUpdateUser
				,NULL as ParentSalesOrderGUID
				,0 as IsSurgeryReversalFlag
				,0 as IsGuaranteeFlag
				,NULL as cashier_temp
				,@OrderDate as ctrOrderDate
				,NULL as CenterFeeBatchGUID
				,NULL as CenterDeclineBatchGUID
				,NULL as RegisterID
				,NULL as EndOfDayGUID
				,NULL as IncomingRequestID


			INSERT INTO datSalesOrderDetail (
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
				,performer_temp
				,performer2_temp
				,Member1Price_temp
				,CancelReasonID
				,EntrySortOrder
				,HairSystemOrderGUID
				,DiscountTypeID
				,BenefitTrackingEnabledFlag
				,MembershipPromotionID
				,MembershipOrderReasonID
				,MembershipNotes
				,GenericSalesCodeDescription
				,SalesCodeSerialNumber)
			SELECT @SalesOrderDetailGUID as SalesOrderDetailGUID
				,NULL as TransactionNumber_Temp
				,@SalesOrderGUID as SalesOrderGUID
				,@SalesCodeID as SalesCodeID
				,@Quantity as Quantity
				,@Price as [Price]
				,0 as Discount
				,@Tax as Tax1
				,NULL as Tax2
				,0 as TaxRate1
				,0 as TaxRate2
				,0 as IsRefundedFlag
				,NULL as RefundedSalesORderDetailGUID
				,NULL as RefundedTotalQuantity
				,NULL as RefundedTotalPrice
				,@Employee1GUID as Employee1GUID
				,@Employee2GUID as Employee2GUID
				,NULL as Employee3GUID
				,NULL as Employee4GUID
				,NULL as previousClientMembershipGUID
				,NULL as NewCenterID
				,GETDATE() as CreateDate
				,@User as CreateUser
				,GETDATE() as LastUpdate
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

			INSERT INTO datSalesOrderTender(
				SalesOrderTenderGUID
				,SalesOrderGUID
				,TenderTypeID
				,Amount
				,CheckNumber
				,CreditCardLast4Digits
				,ApprovalCode
				,CreditCardTypeID
				,FinanceCompanyID
				,InterCompanyReasonID
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser
				,RefundAmount
				,MonetraTransactionId
				,EntrySortOrder
				,CashCollected)
			SELECT @SalesOrderTenderGUID as SalesOrderTenderGUID
				,@SalesOrderGUID as SalesOrderGUID
				,@TENDERTYPEID as TenderTypeID
				,@TenderAmount as Amount
				,NULL as CheckNumber
				,NULL as CreditCardLast4Digits
				,NULL as ApprovalCode
				,NULL as CreditCardTypeID
				,NULL as FinanceCompanyID
				,NULL as InterCompanyReasonID
				,GETDATE() as CreateDAte
				,@User as CreateUser
				,GETDATE() as LastUpdate
				,@User as LastUpdateUser
				,0 as RefundedAmount
				,NULL as MonetraTransactionID
				,1 as EntrySortOrder
				,NULL as CashCollected



			-- Call the Accum Stored Proc
			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID


END
GO
