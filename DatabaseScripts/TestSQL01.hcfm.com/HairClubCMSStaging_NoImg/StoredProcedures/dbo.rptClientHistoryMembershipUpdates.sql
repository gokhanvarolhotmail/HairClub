/* CreateDate: 06/19/2013 23:57:22.580 , ModifyDate: 06/12/2017 16:03:31.820 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:                  rptClientHistoryMembershipUpdates
-- Procedure Description:
--
-- Created By:                      Mike Maass
-- Implemented By:                  Mike Maass
-- Last Modified By:				Mike Maass
--
-- Date Created:              06/18/13
-- Date Implemented:
-- Date Last Modified:        06/18/13
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
CHANGE HISTORY:
06/05/2017 - RH - Added @MonthlyFeeAmountChangeID and @BankAccountNumberChangeID
================================================================================================
Sample Execution:
EXEC rptClientHistoryMembershipUpdates '0E18E1B8-4270-4BAF-8D36-F36E580BFA01'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientHistoryMembershipUpdates]
	@ClientGUID UNIQUEIDENTIFIER
AS
BEGIN

		DECLARE @FreezeStartID INT
			,@FreezeEndID INT
			,@HoldStartID INT
			,@HoldEndID INT
			,@CreditCardNumberChangeID INT
			,@CreditCardExpirationDateChangeID INT
			,@FeePayCycleChangeID INT
			,@MonthlyFeeAmountChangeID INT
			,@BankAccountNumberChangeID INT

		SELECT @FreezeStartID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'EFTFRZSTR'
		SELECT @FreezeEndID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'EFTFRZEND'
		SELECT @HoldStartID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'DCLHLDSTR'
		SELECT @HoldEndID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'DCLHLDEND'
		SELECT @CreditCardNumberChangeID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'CCNBR'
		SELECT @CreditCardExpirationDateChangeID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'CCEXP'
		SELECT @FeePayCycleChangeID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'PAYCYC'
		SELECT @MonthlyFeeAmountChangeID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'MONTHLYFEE'
		SELECT @BankAccountNumberChangeID = ClientProcessID FrOM lkpClientProcess Where ClientProcessDescriptionShort = 'ACCTNBR'

		Select ct.TransactionDate
			,CASE WHEN ct.ClientProcessID = @FreezeStartID THEN 'EFT Freeze Start Date Changed'
				  WHEN ct.ClientProcessID = @FreezeEndID THEN 'EFT Freeze End Date Changed'
				  WHEN ct.ClientProcessID = @HoldStartID THEN 'Decline Hold Start Date Changed'
				  WHEN ct.ClientProcessID = @HoldEndID THEN 'Decline Hold End Date Changed'
				  WHEN ct.ClientProcessID = @CreditCardNumberChangeID THEN 'Credit Card Number Changed'
				  WHEN ct.ClientProcessID = @CreditCardExpirationDateChangeID THEN 'Credit Card Expiration Date Changed'
				  WHEN ct.ClientProcessID = @FeePayCycleChangeID THEN 'Pay Cycle Changed'
				  WHEN ct.ClientProcessID = @MonthlyFeeAmountChangeID THEN 'Monthly Fee Amount Changed'
				  WHEN ct.ClientProcessID = @BankAccountNumberChangeID THEN 'Bank Account Number Changed'
				  ELSE ''
			END as ProcessDescription
			,CASE WHEN ct.ClientProcessID = @FreezeStartID THEN CONVERT(nvarchar(100), ct.PreviousEFTFreezeStartDate, 101)
				  WHEN ct.ClientProcessID = @FreezeEndID THEN CONVERT(nvarchar(100), ct.PreviousEFTFreezeEndDate, 101)
				  WHEN ct.ClientProcessID = @HoldStartID THEN CONVERT(nvarchar(100), ct.PreviousEFTHoldStartDate, 101)
				  WHEN ct.ClientProcessID = @HoldEndID THEN CONVERT(nvarchar(100), ct.PreviousEFTHoldEndDate,101)
				  WHEN ct.ClientProcessID = @CreditCardNumberChangeID THEN CONVERT(nvarchar(100), ct.PreviousCCNumber)
				  WHEN ct.ClientProcessID = @CreditCardExpirationDateChangeID THEN CONVERT(nvarchar(100), ct.PreviousCCExpirationDate, 101)
				  WHEN ct.ClientProcessID = @FeePayCycleChangeID THEN fpc.FeePayCycleDescription
				  WHEN ct.ClientProcessID = @MonthlyFeeAmountChangeID THEN CONVERT(VARCHAR, ct.PreviousMonthlyFeeAmount)
				  WHEN ct.ClientProcessID = @BankAccountNumberChangeID THEN ct.PreviousBankAccountNumber
				  ELSE ''
			END as PreviousValue
			,CASE WHEN ct.ClientProcessID = @FreezeStartID THEN CONVERT(nvarchar(100), ct.EFTFreezeStartDate, 101)
				  WHEN ct.ClientProcessID = @FreezeEndID THEN CONVERT(nvarchar(100), ct.EFTFreezeEndDate, 101)
				  WHEN ct.ClientProcessID = @HoldStartID THEN CONVERT(nvarchar(100), ct.EFTHoldStartDate, 101)
				  WHEN ct.ClientProcessID = @HoldEndID THEN CONVERT(nvarchar(100), ct.EFTHoldEndDate,101)
				  WHEN ct.ClientProcessID = @CreditCardNumberChangeID THEN CONVERT(nvarchar(100), ct.CCNumber)
				  WHEN ct.ClientProcessID = @CreditCardExpirationDateChangeID THEN CONVERT(nvarchar(100), ct.CCExpirationDate, 101)
				  WHEN ct.ClientProcessID = @FeePayCycleChangeID THEN fpc2.FeePayCycleDescription
				  WHEN ct.ClientProcessID = @MonthlyFeeAmountChangeID THEN CONVERT(VARCHAR, ct.MonthlyFeeAmount)
				  WHEN ct.ClientProcessID = @BankAccountNumberChangeID THEN ct.BankAccountNumber
				  ELSE ''
			END as NewValue
			,ct.CreateUser as EnterBy
		from datClientTransaction ct
			LEFT OUTER JOIN lkpFeePayCycle fpc on ct.PreviousFeePayCycleID = fpc.FeePayCycleID
			LEFT OUTER JOIN lkpFeePayCycle fpc2 on ct.FeePayCycleID = fpc2.FeePayCycleID
		Where ct.ClientGUID = @ClientGUID
		Order by ct.TransactionDate desc

END
GO
