/* CreateDate: 11/12/2014 11:49:28.033 , ModifyDate: 07/20/2021 22:00:25.380 */
GO
/*
==============================================================================
PROCEDURE:				dbaApplyOpenARDetailsForClient

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		11/11/2014

LAST REVISION DATE: 	11/11/2014
==============================================================================
DESCRIPTION:  Applies open credits to open charges for a client.
==============================================================================
NOTES:
		11/11/2014 SAL - Created
		07/09/2021 AOS - fixed logic for Refund

==============================================================================
SAMPLE EXECUTION: EXEC [dbaApplyOpenARDetailsForClient] '607BAAB3-334B-4A1B-AB25-8E28232D082B', 'TFS3755'
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaApplyOpenARDetailsForClient]
	@ClientGuid uniqueidentifier,
	@User nvarchar(25)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @CreditAccountReceivableId int,
			@AmountToApply money,
			@ChargeAccountReceivableId int,
			@ChargeAmount MONEY,
			@AccountReceivableTypeID INT,
			@FinaceCompanyID INT

    DECLARE @ARPaymentChoiceId INT = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'Choicepay')
    DECLARE @ARFinanceChoiceId INT = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] Where [AccountReceivableTypeDescriptionShort] = 'ChoiceFina')
    DECLARE @FinaceCompanyChoiceId INT = (SELECT [FinanceCompanyID] FROM [lkpFinanceCompany] Where [FinanceCompanyDescriptionShort] = 'Choice')



	BEGIN TRANSACTION

	BEGIN TRY

		DECLARE AR_CURSOR_CREDIT CURSOR FAST_FORWARD FOR
				SELECT ar.ClientGUID, ar.AccountReceivableId, ar.RemainingBalance  , art.AccountReceivableTypeID, tender.FinanceCompanyID
				FROM datAccountReceivable ar
					INNER JOIN lkpAccountReceivableType art ON ar.AccountReceivableTypeID = art.AccountReceivableTypeID
					INNER JOIN datSalesOrder sale ON sale.SalesOrderGUID = ar.SalesOrderGUID
					INNER JOIN datSalesOrderTender tender ON tender.SalesOrderGUID = sale.SalesOrderGUID
				WHERE art.IsCreditFlag = 1
					AND ar.IsClosed = 0
					AND ar.ClientGuid = @ClientGUID
				ORDER BY ar.CreateDate

		OPEN AR_CURSOR_CREDIT
		FETCH NEXT FROM AR_CURSOR_CREDIT INTO @ClientGUID, @CreditAccountReceivableId, @AmountToApply,@AccountReceivableTypeID, @FinaceCompanyID

		WHILE (@@FETCH_STATUS = 0)
			BEGIN

				DECLARE AR_CURSOR_CHARGE CURSOR FAST_FORWARD FOR
					SELECT ar.AccountReceivableId, ar.RemainingBalance
					FROM datAccountReceivable ar
						INNER JOIN lkpAccountReceivableType art ON ar.AccountReceivableTypeID = art.AccountReceivableTypeID
					    INNER JOIN datSalesOrder sale ON sale.SalesOrderGUID = ar.SalesOrderGUID
					    INNER JOIN datSalesOrderTender tender ON tender.SalesOrderGUID = sale.SalesOrderGUID
					WHERE art.IsCreditFlag = 0
						AND ar.IsClosed = 0
						AND ar.ClientGuid = @ClientGUID
						AND ((@FinaceCompanyID = @FinaceCompanyChoiceId AND tender.FinanceCompanyID = @FinaceCompanyChoiceId)
						 OR (@FinaceCompanyID <> @FinaceCompanyChoiceId AND tender.FinanceCompanyID <> @FinaceCompanyChoiceId)
						 OR (@AccountReceivableTypeID = @ARPaymentChoiceId AND ar.AccountReceivableTypeID = @ARFinanceChoiceId)
						 OR (@AccountReceivableTypeID <> @ARPaymentChoiceId AND ar.AccountReceivableTypeID <> @ARFinanceChoiceId))

					ORDER BY ar.CreateDate

				OPEN AR_CURSOR_CHARGE
				FETCH NEXT FROM AR_CURSOR_CHARGE INTO @ChargeAccountReceivableId, @ChargeAmount

				WHILE (@@FETCH_STATUS = 0) AND (@AmountToApply > 0)
					BEGIN

						IF @ChargeAmount >= @AmountToApply
						BEGIN

							-- Insert Join record
							INSERT INTO [dbo].[datAccountReceivableJoin]
									   ([ARChargeID]
									   ,[ARPaymentID]
									   ,[Amount]
									   ,[CreateDate]
									   ,[CreateUser]
									   ,[LastUpdate]
									   ,[LastUpdateUser])
								 VALUES
									   (@ChargeAccountReceivableId
									   ,@CreditAccountReceivableId
									   ,@AmountToApply
									   ,GETUTCDATE()
									   ,@User
									   ,GETUTCDATE()
									   ,@User)

							-- Close out the Credit Record
							UPDATE datAccountReceivable
							SET	RemainingBalance = 0,
								IsClosed = 1,
								LastUpdate = GETUTCDATE(),
								LastUpdateUser = @User
							WHERE AccountReceivableId = @CreditAccountReceivableId

							-- Update Charge Record
							UPDATE datAccountReceivable
							SET	RemainingBalance = (@ChargeAmount - @AmountToApply),
								IsClosed = IIF((@ChargeAmount - @AmountToApply) = 0, 1, 0),
								LastUpdate = GETUTCDATE(),
								LastUpdateUser = @User
							WHERE AccountReceivableId = @ChargeAccountReceivableId

							-- Credit always will get fully applied.
							SET @AmountToApply = 0
						END
						ELSE IF @ChargeAmount < @AmountToApply
						BEGIN

							-- Insert Join record
							INSERT INTO [dbo].[datAccountReceivableJoin]
									   ([ARChargeID]
									   ,[ARPaymentID]
									   ,[Amount]
									   ,[CreateDate]
									   ,[CreateUser]
									   ,[LastUpdate]
									   ,[LastUpdateUser])
								 VALUES
									   (@ChargeAccountReceivableId
									   ,@CreditAccountReceivableId
									   ,@ChargeAmount
									   ,GETUTCDATE()
									   ,@User
									   ,GETUTCDATE()
									   ,@User)

							-- Update the Credit Record
							UPDATE datAccountReceivable
							SET	RemainingBalance = (@AmountToApply - @ChargeAmount),
								IsClosed = 0,
								LastUpdate = GETUTCDATE(),
								LastUpdateUser = @User
							WHERE AccountReceivableId = @CreditAccountReceivableId

							-- Update Charge Record
							UPDATE datAccountReceivable
							SET	RemainingBalance = 0,
								IsClosed = 1,
								LastUpdate = GETUTCDATE(),
								LastUpdateUser = @User
							WHERE AccountReceivableId = @ChargeAccountReceivableId

							SET @AmountToApply = (@AmountToApply - @ChargeAmount)
						END

						FETCH NEXT FROM AR_CURSOR_CHARGE INTO @ChargeAccountReceivableId, @ChargeAmount
					END

				CLOSE AR_CURSOR_CHARGE
				DEALLOCATE AR_CURSOR_CHARGE

				-- Get Next Credit Record.
				FETCH NEXT FROM AR_CURSOR_CREDIT INTO @ClientGUID, @CreditAccountReceivableId, @AmountToApply,@AccountReceivableTypeID,@FinaceCompanyID
			END

		CLOSE AR_CURSOR_CREDIT
		DEALLOCATE AR_CURSOR_CREDIT

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
GO
