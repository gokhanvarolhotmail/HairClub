/*
==============================================================================
PROCEDURE:				mtnPaymentPlanUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 8/3/2016

LAST REVISION DATE: 	 11/26/2020

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
		* 8/3/2016 MLM - Created Stored Proc
		* 11/26/2020 ANDREA OROZCO TEAM - Add validation's LASEREZPAY Membership

==============================================================================
SAMPLE EXECUTION:
EXEC mtnPaymentPlanUpdate 'BF6C64F1-4CFE-4EE8-8F5C-4643BC850DCA'
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnPaymentPlanUpdate]
	@SalesOrderGUID uniqueidentifier,
	@User nvarchar(25)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @PaymentAmount money
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @PaymentPlanStatus_Active int
	DECLARE @PaymentPlanStatus_Paid int
	DECLARE @Monthly_SalesCodeID int
	DECLARE @SalesCodeID int

	Select @PaymentPlanStatus_Active = PaymentPlanStatusID From lkpPaymentPlanStatus where PaymentPlanStatusDescriptionShort = 'Active'
	Select @PaymentPlanStatus_Paid = PaymentPlanStatusID From lkpPaymentPlanStatus where PaymentPlanStatusDescriptionShort = 'Paid'
	SELECT @Monthly_SalesCodeID = SalesCodeID From cfgSalesCode Where SalesCodeDescriptionShort = 'MTHPLANPMT'

	Select @ClientMembershipGUID = so.ClientMembershipGUID, @PaymentAmount = ISNULL(sod.[Price],0), @SalesCodeID = sc.SalesCodeID
   	from datSalesOrder so
		inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
		inner join cfgSalesCode sc on sod.SalesCodeId = sc.SalesCodeId
		INNER JOIN datClientMembership ON datClientMembership.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgMembership ON cfgMembership.MembershipID = datClientMembership.MembershipID
	Where sod.SalesOrderGUID = @SalesOrderGUID
		AND (sc.SalesCodeDescriptionShort in ('MTHPLANPMT','PAYPLANPMT') OR cfgMembership.MembershipDescriptionShort = 'LASEREZPAY')

	if @ClientMembershipGUID is not null and @PaymentAmount > 0
		BEGIN
			--Update the PaymentPlan
			Update datPaymentPlan
				SET RemainingBalance = RemainingBalance - @PaymentAmount
					,RemainingNumberOfPayments = (CASE WHEN @SalesCodeID = @Monthly_SalesCodeId THEN RemainingNumberOfPayments -1 ELSE RemainingNumberOFPayments END)
					,PaymentPlanStatusID = (CASE WHEN ISNULL(RemainingBalance,0) - @PaymentAmount = 0 THEN @PaymentPlanStatus_Paid ELSE @PaymentPlanStatus_Active End)
					,SatisfactionDate = (CASE WHEN ISNULL(RemainingBalance,0) - @PaymentAmount = 0 THEN GETUTCDATE() ELSE NULL End)
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @user
			From datPaymentPlan
			Where ClientMembershipGUID = @ClientMembershipGUID

			--Insert an Entry into the Journal
			INSERT INTO datPaymentPlanJournal(PaymentPlanId,PaymentDate,[Amount], CreateDate, CreateUser, LastUpdate, LastUpdateUser)
				SELECT PaymentPlanID
					,GETUTCDATE()
					,@PaymentAmount
					,GETUTCDATE()
					,@User
					,GETUTCDATE()
					,@User
				From datPaymentPlan
				where ClientMembershipGUID = @ClientMembershipGUID

		END




END
