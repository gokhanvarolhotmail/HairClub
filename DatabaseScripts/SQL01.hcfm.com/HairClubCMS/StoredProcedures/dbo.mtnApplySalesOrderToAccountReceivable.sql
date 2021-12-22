/*
==============================================================================
PROCEDURE:		mtnApplySalesOrderToAccountReceivable

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		05/12/2016

LAST REVISION DATE: 	05/12/2016

==============================================================================
DESCRIPTION:  Apply a ARPayment to AR by passing in a SalesOrder
==============================================================================
NOTES:
		05/12/2016 MLM - Created
		02/03/2016 MVT - Added logic for handling Negative Tender to AR (AR Credit).
						This change was put in to mainly handle client referrals (TFS #8519)
		09/21/2018 SAL - Added handling of Laser Pre Payment (LASERPREPAY) sales code (TFS #11368)
		19/05/2021 AOS - added logic for choicepay
	    09/7/2021 AOS - fixed logic for choicepay
==============================================================================
SAMPLE EXECUTION: EXEC [mtnApplySalesOrderToAccountReceivable]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnApplySalesOrderToAccountReceivable]
	@SalesOrderGuid uniqueidentifier,
	@User nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ARPaymentTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'Payment')
	DECLARE @ARChargeTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'Charge')
	DECLARE @ARRefundTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'Refund')
	DECLARE @ARWriteOffTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'WriteOff')
	DECLARE @ARFinanceARTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'FinanceAR')
	DECLARE @ARPaymentRefundTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'PmntRefund')
	DECLARE @ARCreditTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'ARCredit')
	DECLARE @ARPaymentChoiceId INT = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'Choicepay')
	DECLARE @ARFinanceChoiceId INT = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'ChoiceFina')
    DECLARE @CompanyChoiceId INT = (SELECT [FinanceCompanyID] FROM [lkpFinanceCompany] Where [FinanceCompanyDescriptionshort] = 'Choice')

	DECLARE @ARPaymentSalesCodeTypeId int = (SELECT [SalesCodeTypeID] FROM [lkpSalesCodeType] WHERE [SalesCodeTypeDescriptionShort] = 'ARPayment')
	DECLARE @ARTenderTypeId int = (SELECT [TenderTypeID] FROM [lkpTenderType] WHERE [TenderTypeDescriptionShort] = 'AR')
	DECLARE @FinanceARTenderTypeId int = (SELECT [TenderTypeID] FROM [lkpTenderType] WHERE [TenderTypeDescriptionShort] = 'FinanceAR')
	DECLARE @SalesOrderTypeId_WriteOff int = (SELECT [SalesOrderTypeID] FROM [lkpSalesOrderType] WHERE [SalesOrderTypeDescriptionShort] = 'WO')

	DECLARE @SalesCode_ARRefundId int = (SELECT SalesCodeId FROM cfgSalesCode Where SalesCodeDescriptionShort = 'ARREFUND')

	DECLARE @ClientGuid uniqueidentifier
			,@CenterID int
			,@ClientMembershipGuid uniqueidentifier
			,@CenterFeeBatchGuid uniqueidentifier
			,@CenterDeclineBatchGuid uniqueidentifier
			,@RefundedSalesOrderGuid uniqueidentifier
			,@WriteOffSalesOrderGuid uniqueidentifier
			,@NSFSalesOrderGuid uniqueidentifier
			,@ChargeBackSalesOrderGuid uniqueidentifier
			,@SalesCodeId int
			,@IsRefunded bit
			,@IsWrittenOff bit
			,@ARTypeId INT
			,@ARCompanyId Int

	-- Get Client Information from the SalesOrder
	SELECT @ClientGuid = ClientGuid
		,@ClientMembershipGuid = ClientMembershipGuid
		,@CenterFeeBatchGuid = CenterFeeBatchGuid
		,@CenterDeclineBatchGuid = CenterDeclineBatchGuid
		,@RefundedSalesOrderGuid = RefundedSalesOrderGuid
		,@WriteOffSalesOrderGuid = WriteOffSalesOrderGuid
		,@NSFSalesOrderGuid = NSFSalesOrderGuid
		,@ChargeBackSalesOrderGuid = ChargeBackSalesOrderGuid
		,@IsRefunded  = IsRefundedFlag
		,@IsWrittenOff = IsWrittenOffFlag
	FROM datSalesOrder
	WHERE SalesOrderGuid = @SalesOrderGuid



	BEGIN TRANSACTION

	BEGIN TRY

		DECLARE @TenderAmount money
				,@TenderTypeId int

		-- Get all AR and ARFinance Tenders
		DECLARE tender_cursor CURSOR FOR
			SELECT sot.[Amount] as TenderAmount
				,sot.TenderTypeId
				,sot.FinanceCompanyID AS ARCompanyId
			FROM datSalesOrderTender sot
			WHERE sot.SalesOrderGuid = @SalesOrderGuid
				AND sot.TenderTypeId in (@ARTenderTypeId,@FinanceARTenderTypeId)

		OPEN tender_cursor
		FETCH NEXT FROM tender_cursor INTO @TenderAmount, @TenderTypeId,@ARCompanyId


		WHILE @@FETCH_STATUS = 0
		BEGIN



 IF @IsRefunded = 1
 BEGIN
    SET @ARTypeID = @ARRefundTypeId
 END
 ELSE IF  @IsWrittenOff = 1
  BEGIN
    SET  @ARTypeID =  @ARWriteOffTypeId
    END
 ELSE IF @TenderTypeId = @FinanceARTenderTypeId  AND @ARCompanyId = @CompanyChoiceId
   BEGIN
    SET  @ARTypeID =  @ARFinanceChoiceId
    END
 ELSE IF @TenderTypeId = @FinanceARTenderTypeId  AND @ARCompanyId <> @CompanyChoiceId
   BEGIN
    SET  @ARTypeID =  @ARFinanceARTypeId
    END
 ELSE IF  @TenderAmount < 0
   BEGIN
     SET  @ARTypeID =  @ARCreditTypeId
     END
     ELSE
       BEGIN
  SET  @ARTypeID =  @ARChargeTypeID
  END



			INSERT INTO [dbo].[datAccountReceivable]
				([ClientGUID]
				,[SalesOrderGUID]
				,[CenterFeeBatchGUID]
				,[Amount]
				,[IsClosed]
				,[AccountReceivableTypeID]
				,[RemainingBalance]
				,[CreateDate]
				,[CreateUser]
				,[LastUpdate]
				,[LastUpdateUser]
				,[CenterDeclineBatchGUID]
				,[RefundedSalesOrderGuid]
				,[WriteOffSalesOrderGUID]
				,[NSFSalesOrderGUID]
				,[ChargeBackSalesOrderGUID])

			VALUES
				(@ClientGuid
				,@SalesOrderGuid
				,@CenterFeeBatchGuid
				,ABS(@TenderAmount)
				,0
				,@ARTypeID
				,ABS(@TenderAmount)
				,GETUTCDATE()
				,@User
				,GETUTCDATE()
				,@User
				,@CenterDeclineBatchGUID
				,@RefundedSalesOrderGUID
				,@WriteOffSalesOrderGUID
				,@NSFSalesOrderGUID
				,@ChargeBackSalesOrderGUID)


			FETCH NEXT FROM tender_cursor INTO @TenderAmount, @TenderTypeId,@ARCompanyId
		END

		CLOSE tender_cursor
		DEALLOCATE tender_cursor


		DECLARE @PriceTax money

		-- Loop through Detail records
		DECLARE detail_cursor CURSOR FOR
			SELECT ABS(sod.PriceTaxCalc) as PriceTax
			FROM datSalesOrderDetail sod
				inner join cfgSalesCode sc on sod.SalesCodeId = sc.SalesCodeId
				inner join lkpSalesCodeType sct on sc.SalesCodeTypeId = sct.SalesCodeTypeId
				inner join cfgAccumulatorJoin aj on sod.SalesCodeId = aj.SalesCodeId
				inner join cfgAccumulator a on aj.AccumulatorID = a.AccumulatorId
				inner join lkpAccumulatorActionType aType on aj.AccumulatorActionTypeID = aType.AccumulatorActionTypeId
				inner join lkpAccumulatorDataType dType on aj.AccumulatorDataTypeID = dType.AccumulatorDataTypeId
			Where aType.AccumulatorActionTypedescriptionShort = 'Remove'
				and dType.AccumulatorDataTypeDescriptionShort = 'Money'
				and (sct.SalesCodeTypeDescriptionShort = 'ARPayment' or sc.SalesCodeDescriptionShort = 'LASERPREPAY')
				and sod.SalesOrderGuid = @SalesOrderGUID
				and a.AdjustARBalanceFlag = 1

		OPEN detail_cursor
		FETCH NEXT FROM detail_cursor INTO @PriceTax

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Determine the @ARTypeID
			SELECT @ARTypeID = CASE WHEN @IsRefunded = 1 THEN @ARPaymentRefundTypeId
									ELSE @ARPaymentTypeId
								END

			IF EXISTS (SELECT * FROM datSalesOrder
				  JOIN datSalesOrderDetail ON datSalesOrderDetail.SalesOrderGUID = datSalesOrder.SalesOrderGUID
				  JOIN cfgSalesCode ON cfgSalesCode.SalesCodeID = datSalesOrderDetail.SalesCodeID
				   WHERE datSalesOrder.SalesOrderGUID = @SalesOrderGuid AND SalescodeDescriptionshort = 'PMTRCVDCHOICE') AND @IsRefunded = 0 AND @IsWrittenOff = 0
				   BEGIN
				   SET @ARTypeID = @ARPaymentChoiceId
			 END

			INSERT INTO [dbo].[datAccountReceivable]
				([ClientGUID]
				,[SalesOrderGUID]
				,[CenterFeeBatchGUID]
				,[Amount]
				,[IsClosed]
				,[AccountReceivableTypeID]
				,[RemainingBalance]
				,[CreateDate]
				,[CreateUser]
				,[LastUpdate]
				,[LastUpdateUser]
				,[CenterDeclineBatchGUID]
				,[RefundedSalesOrderGuid]
				,[WriteOffSalesOrderGUID]
				,[NSFSalesOrderGUID]
				,[ChargeBackSalesOrderGUID])

			VALUES
				(@ClientGuid
				,@SalesOrderGuid
				,@CenterFeeBatchGuid
				,@PriceTax
				,0
				,@ARTypeID
				,@PriceTax
				,GETUTCDATE()
				,@User
				,GETUTCDATE()
				,@User
				,@CenterDeclineBatchGUID
				,@RefundedSalesOrderGUID
				,@WriteOffSalesOrderGUID
				,@NSFSalesOrderGUID
				,@ChargeBackSalesOrderGUID)


			FETCH NEXT FROM detail_cursor INTO @PriceTax
		END

		CLOSE detail_cursor
		deallocate detail_cursor


		-- Apply Open AR Charges For Client
		EXEC [dbo].[dbaApplyOpenARDetailsForClient] @ClientGUID, @User


		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
END
