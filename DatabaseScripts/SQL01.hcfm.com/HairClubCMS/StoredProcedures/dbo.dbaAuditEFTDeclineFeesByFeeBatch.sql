/* CreateDate: 03/12/2014 20:11:19.140 , ModifyDate: 03/12/2014 20:11:19.140 */
GO
/***********************************************************************
PROCEDURE:				dbaAuditEFTDeclineFeesByFeeBatch
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	This script is used to audit declines after the decline run for a specific batch.  It will
		provide a list of clients expected to run and list of clients that did run for the batch.

		Pass in the fee batch and decline fee batch being audited.

		*** THIS SCRIPT SHOULD BE RUN RIGHT AFTER THE DECLINE RUN TO GET BEST RESULTS. AS
			PAYMENTS ARE RECEIVED AND CLIENTS ARE PLACED ON/OFF HOLD, THE COUNTS WILL BE OFF.

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [dbaAuditEFTDeclineFeesByFeeBatch] '5D6015B6-510F-44C0-8AC5-829749B9F31E', '52371CE8-5EE7-4499-BC8B-CA96A5E8B890'
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaAuditEFTDeclineFeesByFeeBatch]
	@CenterFeeBatchGUID uniqueidentifier,
	@CenterDeclineBatchGUID uniqueidentifier
AS
BEGIN

	DECLARE @DeclineRunDate DateTime

	SELECT @DeclineRunDate = DATEADD(dd, 0, DATEDIFF(dd, 0, RunDate)) FROM datCenterDeclineBatch WHERE CenterDeclineBatchGUID = @CenterDeclineBatchGUID

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'

	SELECT 'Expected Clients for this Decline Run.', c.ClientFullNameCalc, so.ClientMembershipGUID,
			fpt.PayCycleTransactionGUID,  so.ClientGUID
		FROM datPayCycleTransaction fpt
			INNER JOIN datClient c ON c.ClientGUID = fpt.ClientGUID
			INNER JOIN datCenterFeeBatch cfb  on cfb.CenterFeeBatchGUID = fpt.CenterFeeBatchGUID
			INNER JOIN datSalesOrder so ON so.SalesOrderGUID = fpt.SalesOrderGUID
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
			INNER JOIN cfgMembership mem on mem.MembershipID = cm.MembershipID
			OUTER APPLY
			(
				SELECT d_fpt.IsSuccessfulFlag
					FROM datPayCycleTransaction d_fpt
						INNER JOIN datSalesOrder d_so ON d_so.SalesOrderGUID = d_fpt.SalesOrderGUID
						INNER JOIN datCenterDeclineBatch d_cdb ON d_cdb.CenterDeclineBatchGUID = d_fpt.CenterDeclineBatchGUID
					WHERE d_fpt.CenterFeeBatchGUID = fpt.CenterFeeBatchGUID
						AND d_cdb.RunDate < @DeclineRunDate
						AND d_so.ClientMembershipGUID = so.ClientMembershipGUID
						AND d_fpt.HCStatusCode = 'A'
			) d_success
			OUTER APPLY
			(
				SELECT ceft.ClientEFTGUID
				FROM datClientEFT ceft
					INNER JOIN datClientMembership eft_cm ON eft_cm.ClientMembershipGUID = ceft.ClientMembershipGUID
					INNER JOIN cfgMembership eft_mem on eft_mem.MembershipID = eft_cm.MembershipID
				WHERE ceft.ClientGUID = fpt.ClientGUID
					AND eft_mem.BusinessSegmentID = mem.BusinessSegmentID
					AND ceft.EFTAccountTypeID = 1
			) client_eft
			OUTER APPLY
			(
				SELECT pay_so.ClientGUID
				FROM datSalesOrder pay_so
					INNER JOIN datSalesOrderDetail pay_sod on pay_so.SalesOrderGUID = pay_sod.SalesOrderGUID
							AND ( pay_sod.SalesCodeID = @PAYMENT_RECEIVED OR pay_sod.SalesCodeID = @PCP_WRITEOFF)
				WHERE fpt.ClientGUID = pay_so.ClientGUID AND pay_so.IsClosedFlag = 1
							AND pay_so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), cfb.RunDate, 101) + ' 00:00:00') AND @DeclineRunDate
			) payment
		WHERE fpt.CenterFeeBatchGUID = @CenterFeeBatchGUID
			AND fpt.CenterDeclineBatchGUID IS NULL
			AND ((fpt.HCStatusCode IS NULL AND fpt.IsReprocessFlag = 1) OR fpt.HCStatusCode <> 'A')
			AND payment.ClientGUID IS NULL
			AND d_success.IsSuccessfulFlag IS NULL
			AND client_eft.ClientEFTGUID IS NOT NULL
			AND fpt.PayCycleTransactionTypeID = 3 -- CC
		ORDER BY c.ClientFullNameCalc


		SELECT 'Actual Clients for this Decline Run.', c.ClientFullNameCalc, so.ClientMembershipGUID, so.ClientGUID,
				pt.CenterDeclineBatchGUID, pt.CenterFeeBatchGUID
		FROM datPayCycleTransaction  pt
			inner join datSalesOrder so on so.SalesOrderGUID = pt.SalesOrderGUID
			inner join datClient c on so.ClientGUID = c.ClientGUID
		where pt.CenterDeclineBatchGUID = @CenterDeclineBatchGUID
		order by c.ClientFullNameCalc
END
GO
