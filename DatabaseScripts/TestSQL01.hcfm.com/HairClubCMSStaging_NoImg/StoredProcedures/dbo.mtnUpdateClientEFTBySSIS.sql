/* CreateDate: 05/14/2012 17:40:59.707 , ModifyDate: 02/27/2017 09:49:23.273 */
GO
/***********************************************************************

PROCEDURE:				mtnUpdateClientEFTBySSIS

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 2/1/12 MLM - Created stored proc
		* 06/14/12 MLM - Added FeeFreezeReasonId
		* 06/15/12 MLM: Added CardHolderName
		* 08/12/13 MLM: Added Logging of EFT FeePayCycleID changes
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnUpdateClientEFTBySSIS '27EC303A-A8B0-4C7B-AEC4-0BF8D65F0D18'

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnUpdateClientEFTBySSIS]
	@ClientEFTGUID uniqueIdentifier,
	@ClientGUID uniqueIdentifier,
	@ClientMembershipGUID uniqueIdentifier,
	@EFTAccountTypeID int,
	@EFTStatusID int,
	@FeePayCycleID int,
	@CreditCardTypeID int,
	@AccountNumberLast4Digits nvarchar(4),
	@AccountExpiration datetime,
	@BankName nvarchar(100),
	@BankPhone nvarchar(15),
	@BankRoutingNumber nvarchar(25),
	@BankAccountNumber nvarchar(25),
	@EFTProcessorToken nvarchar(50),
	--@LastRun datetime,
	@IsActiveFlag bit,
	@Freeze_Start datetime,
	@Freeze_End datetime,
	@FeeFreezeReasonId int,
	@CardHolderName nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON

	--Get the Previous Freeze Dates, Needed to Determine
	--whether a clientTransaction needs to be written
	Declare @PreviousFreeze_Start datetime
	Declare @PreviousFreeze_End datetime
	Declare @PreviousFeePayCycleID int

	SELECT @PreviousFreeze_Start = Freeze_Start
		,@PreviousFreeze_End = Freeze_End
		,@PreviousFeePayCycleID = FeePayCycleID
	FROM datClientEFT
	Where ClientEFTGUID = @ClientEFTGUID

	UPDATE datClientEFT
		SET ClientGUID = @ClientGUID
			,ClientMembershipGUID = @ClientMembershipGUID
			,EFTAccountTypeID = @EFTAccountTypeID
			,EFTStatusID = @EFTStatusID
			,FeePayCycleID = @FeePayCycleID
			,CreditCardTypeId = @CreditCardTypeID
			,AccountNumberLast4Digits = @AccountNumberLast4Digits
			,AccountExpiration = @AccountExpiration
			,BankName=@BankName
			,BankPhone=@BankPhone
			,BankRoutingNumber=@BankRoutingNumber
			,BankAccountNumber=@BankAccountNumber
			,EFTProcessorToken=@EFTProcessorToken
			--,LastRun=@LastRun
			,IsActiveFlag=@IsActiveFlag
			,LastUpdate=GETUTCDATE()
			,LastUpdateUser='sa'
			,Freeze_Start=@Freeze_Start
			,Freeze_End=@Freeze_End
			,FeeFreezeReasonId=@FeeFreezeReasonId
			,CardHolderName=@CardHolderName
	FROM datClientEFT
	WHERE ClientEFTGUID = @ClientEFTGUID


	Declare @CurrentDateTime datetime
	SET @CurrentDateTime = GETUTCDATE()

	--Write datClientTransaction Record(s)
	if ISNULL(@PreviousFreeze_Start,@CurrentDateTime) <> ISNULL(@Freeze_Start,@CurrentDateTime)
		BEGIN

			DECLARE @StartProcessID int
			SELECT @StartProcessID = ClientProcessID FROM lkpClientProcess WHERE ClientProcessDescriptionShort = 'EFTFRZSTR'

			INSERT INTO datClientTransaction(
					ClientTransactionGUID
					,ClientGUID
					,ClientProcessID
					,CreateDate
					,CreateUser
					,EFTFreezeEndDate
					,EFTFreezeStartDate
					,EFTHoldEndDate
					,EFTHoldStartDate
					,LastUpdate
					,LastUpdateUser
					,PreviousEFTFreezeEndDate
					,PreviousEFTFreezeStartDate
					,PreviousEFTHoldEndDate
					,PreviousEFTHoldStartDate
					,TransactionDate
				)
			Values(
					NEWID()
					,@ClientGUID
					,@StartProcessID
					,GETUTCDATE()
					,'sa'
					,NULL
					,@Freeze_Start
					,Null
					,Null
					,GETUTCDATE()
					,'sa'
					,Null
					,@PreviousFreeze_Start
					,Null
					,NULL
					,GETUTCDATE()
				)
		END

	if (ISNULL(@PreviousFreeze_End,@CurrentDateTime) <> ISNULL(@Freeze_End,@CurrentDateTime))
		BEGIN

			DECLARE @EndProcessID int
			SELECT @EndProcessID = ClientProcessID FROM lkpClientProcess WHERE ClientProcessDescriptionShort = 'EFTFRZEND'

			INSERT INTO datClientTransaction(
					ClientTransactionGUID
					,ClientGUID
					,ClientProcessID
					,CreateDate
					,CreateUser
					,EFTFreezeEndDate
					,EFTFreezeStartDate
					,EFTHoldEndDate
					,EFTHoldStartDate
					,LastUpdate
					,LastUpdateUser
					,PreviousEFTFreezeEndDate
					,PreviousEFTFreezeStartDate
					,PreviousEFTHoldEndDate
					,PreviousEFTHoldStartDate
					,TransactionDate
				)
			Values(
					NEWID()
					,@ClientGUID
					,@EndProcessID
					,GETUTCDATE()
					,'sa'
					,@Freeze_End
					,Null
					,Null
					,Null
					,GETUTCDATE()
					,'sa'
					,@PreviousFreeze_End
					,NULL
					,Null
					,NULL
					,GETUTCDATE()
				)
		END


	if ISNULL(@PreviousFeePayCycleID,0) <> ISNULL(@FeePayCycleID, 0)
		BEGIN

			DECLARE @PayCycleProcessID int
			SELECT @PayCycleProcessID = ClientProcessID FROM lkpClientProcess WHERE ClientProcessDescriptionShort = 'PAYCYC'

			INSERT INTO datClientTransaction(
					ClientTransactionGUID
					,ClientGUID
					,ClientProcessID
					,CreateDate
					,CreateUser
					,EFTFreezeEndDate
					,EFTFreezeStartDate
					,EFTHoldEndDate
					,EFTHoldStartDate
					,LastUpdate
					,LastUpdateUser
					,PreviousEFTFreezeEndDate
					,PreviousEFTFreezeStartDate
					,PreviousEFTHoldEndDate
					,PreviousEFTHoldStartDate
					,FeePayCycleID
					,PreviousFeePayCycleID
					,TransactionDate
				)
			Values(
					NEWID()
					,@ClientGUID
					,@PayCycleProcessID
					,GETUTCDATE()
					,'sa'
					,NULL
					,NULL
					,Null
					,Null
					,GETUTCDATE()
					,'sa'
					,Null
					,NULL
					,Null
					,NULL
					,@FeePayCycleID
					,@PreviousFeePayCycleID
					,GETUTCDATE()
				)
		END


END
GO
