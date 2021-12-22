/***********************************************************************
PROCEDURE:				dbaAuditEFTDeclineFees
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	This script is used to audit declines after the decline run. If discrepencies
		exist, use the detail proc to audit.

		*** THIS SCRIPT SHOULD BE RUN RIGHT AFTER THE DECLINE RUN TO GET BEST RESULTS. AS
			PAYMENTS ARE RECEIVED AND CLIENTS ARE PLACED ON/OFF HOLD, THE COUNTS WILL BE OFF.

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [dbaAuditEFTDeclineFees] '3/10/2014', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaAuditEFTDeclineFees]
	@DeclineRunDate datetime,
	@DiscrepenciesOnly bit = 1
AS
BEGIN


	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'


	SELECT CASE WHEN decline_tran.DeclineCount <> fee_tran.ReprocessCount THEN 1 ELSE 0 END AS IsDiscrepency,
			cfb.CenterID, cfb.FeeMonth, cfb.FeeYear,
			pc.FeePayCycleDescription, decline_tran.DeclineCount as ActualProcessedCount, ISNULL(fee_tran.ReprocessCount, 0) as CalculatedReprocessCount
			,cfb.CenterFeeBatchGUID, cdb.CenterDeclineBatchGUID
	FROM datCenterDeclineBatch cdb
		INNER JOIN datCenterFeeBatch cfb ON cfb.CenterFeeBatchGUID = cdb.CenterFeeBatchGUID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = cfb.FeePayCycleID
		OUTER APPLY
		(
			SELECT COUNT(*) as DeclineCount
			FROM datPayCycleTransaction pct
			WHERE pct.CenterDeclineBatchGUID = cdb.CenterDeclineBatchGUID
		) decline_tran
		OUTER APPLY
		(
			SELECT COUNT(*) as ReprocessCount
				FROM datPayCycleTransaction fpt
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
				WHERE fpt.CenterFeeBatchGUID = cdb.CenterFeeBatchGUID
					AND fpt.CenterDeclineBatchGUID IS NULL
					AND ((fpt.HCStatusCode IS NULL AND fpt.IsReprocessFlag = 1) OR fpt.HCStatusCode <> 'A')
					AND payment.ClientGUID IS NULL
					AND d_success.IsSuccessfulFlag IS NULL
					AND client_eft.ClientEFTGUID IS NOT NULL
					AND fpt.PayCycleTransactionTypeID = 3

		) fee_tran
	WHERE cdb.RunDate >= @DeclineRunDate
		AND cdb.RunDate <= DATEADD(dd,1,@DeclineRunDate)
		AND (@DiscrepenciesOnly = 0 OR decline_tran.DeclineCount <> fee_tran.ReprocessCount)
	ORDER BY cfb.CenterID, cfb.FeeMonth, cfb.FeePayCycleID


	-- More than one pay cycle for the membership
	SELECT 'More than 1 pay cycle transaction for client membership.', c.CenterID, c.[ClientFullNameCalc],
				so.ClientMembershipGUID, COUNT(*) as NumberOfTransactions,
				db.CenterDeclineBatchGUID
	FROM datPayCycleTransaction pt
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = pt.SalesOrderGUID
		INNER JOIN datCenterDeclineBatch db ON db.CenterDeclineBatchGUID = pt.CenterDeclineBatchGUID
		INNER JOIN datClient c ON pt.ClientGUID = c.ClientGUID
	WHERE db.RunDate >= @DeclineRunDate
		AND db.RunDate <= DATEADD(dd,1,@DeclineRunDate)
	GROUP BY so.ClientMembershipGUID, c.CenterID, c.[ClientFullNameCalc], db.CenterDeclineBatchGUID
	HAVING COUNT(*) > 1

END
