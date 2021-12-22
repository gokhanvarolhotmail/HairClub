/***********************************************************************
PROCEDURE:				dbaAuditEFTDeclineFeesByClientMembership
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	This script is used to audit declines for a specific client membership. It displays
		all pay cycles for the specified fee batch (including fee batch and decline
		batch records for the fee batch), all client's payments (not specific to client
		membership), and all client EFT profiles (not specific to client membership).

		Pass in the fee batch and client membership being audited.

		*** THIS SCRIPT SHOULD BE RUN RIGHT AFTER THE DECLINE RUN TO GET BEST RESULTS. AS
			PAYMENTS ARE RECEIVED AND CLIENTS ARE PLACED ON/OFF HOLD, THE COUNTS WILL BE OFF.

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [dbaAuditEFTDeclineFeesByClientMembership] '5D6015B6-510F-44C0-8AC5-829749B9F31E', 'FC7330DD-0DD4-4B92-B195-75BA71B3A577'
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaAuditEFTDeclineFeesByClientMembership]
	@CenterFeeBatchGUID uniqueidentifier,
	@ClientMembershipGUID uniqueidentifier
AS
BEGIN
	DECLARE @ClientGUID as uniqueidentifier

	SELECT @ClientGUID = ClientGUID FROM datClientMembership WHERE ClientMembershipGUID = @ClientMembershipGUID

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'



	select 'Pay Cycles For Client Membership and fee batch (includes fee run and decline run)', sc.SalesCodeDescription, so.ClientMembershipGUID,
			mem.MembershipDescription, cmStat.ClientMembershipStatusDescription, pt.*
	from datPayCycleTransaction pt
		inner join datSalesOrder so on so.SalesOrderGUID = pt.SalesOrderGUID
		inner join datSalesOrderDetail	sod on sod.SalesOrderGUID = so.SalesOrderGUID
		inner join cfgSalesCode sc on sc.SalesCodeID = sod.SalesCodeID
		inner join datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		inner join lkpClientMembershipStatus cmStat ON cmStat.ClientMembershipStatusID = cm.ClientMembershipStatusID
		inner join cfgMembership mem ON mem.MembershipID = cm.MembershipID
	where pt.CenterFeeBatchGUID = @CenterFeeBatchGUID
		and so.ClientMembershipGUID = @ClientMembershipGUID
	Order by pt.CreateDate desc


	select 'Client''s Payments (all client memberships)',
			so.OrderDate as PaymentDate, sod.PriceTaxCalc, sc.SalesCodeDescription, so.SalesOrderTypeID
	from datSalesOrder so
		inner join datSalesOrderDetail	sod on sod.SalesOrderGUID = so.SalesOrderGUID
		inner join cfgSalesCode sc on sc.SalesCodeID = sod.SalesCodeID
	where ClientGUID = @ClientGUID
		AND sod.SalesCodeID IN (@PAYMENT_RECEIVED, @PCP_WRITEOFF)
		AND so.IsClosedFlag = 1
	order by OrderDate desc


	select 'Client''s EFT Profile (all client membership)',
			mem.MembershipDescription,
			cmStat.ClientMembershipStatusDescription,
			cm.EndDate as ClientMembership_EndDate,
			cm.MonthlyFee as ClientMembership_MonthlyFee,
			at.EFTAccountTypeDescription, eft.*
	from datClientEFT eft
		inner join lkpEFTAccountType at on at.EFTAccountTypeID = eft.EFTAccountTypeID
		inner join datClientMembership cm ON cm.ClientMembershipGUID = eft.ClientMembershipGUID
		inner join lkpClientMembershipStatus cmStat ON cmStat.ClientMembershipStatusID = cm.ClientMembershipStatusID
		inner join cfgMembership mem ON mem.MembershipID = cm.MembershipID
	where eft.ClientGUID = @ClientGUID

END
