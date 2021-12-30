/* CreateDate: 03/13/2014 10:05:57.763 , ModifyDate: 05/15/2014 15:47:20.390 */
GO
/***********************************************************************
PROCEDURE:				dbaAuditEFTMonthlyFeesPostFeeRun
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	This script verifies that there was not more than 1 transaction created per
		Client and per Client Membership.  There may be a scenarios where more than 1 transaction per
		client is valid, but there should not be a scenario where there is more than 1 transaction per
		client membership.

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:  FeePayCycleID's:  1 - 1st, 2 - 15th
EXEC [dbaAuditEFTMonthlyFeesPostFeeRun] 5, 2014, 2
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaAuditEFTMonthlyFeesPostFeeRun]
	@FeeMonth int,
	@FeeYear int,
	@FeePayCycleID int
AS
BEGIN

	------------------------------------------------------------------
	--
	-- Determine Whether a client has more than 1 pay cycle transaction
	-- per client.
	--
	-- Active
	--
	------------------------------------------------------------------
	SELECT 'More than 1 pay cycle transaction per Client', c.CenterID, c.[ClientFullNameAltCalc], COUNT(*) as NumberOfPayCycleTransactions
	FROM datPayCycleTransaction pt
		INNER JOIN datCenterFeeBatch cfb ON cfb.CenterFeeBatchGUID = pt.CenterFeeBatchGUID
		INNER JOIN datClient c ON pt.ClientGUID = c.ClientGUID
		--INNER JOIN datSalesOrder so ON so.SalesOrderGUID = pt.SalesOrderGUID
		--INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		--INNER JOIN lkpClientMembershipStatus cmStat ON cmStat.ClientMembershipStatusID = cm.ClientMembershipStatusID
		--INNER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
	WHERE cfb.FeeMonth = @FeeMonth
		AND cfb.FeeYear = @FeeYear
		AND cfb.FeePayCycleID = @FeePayCycleID
		AND pt.CenterDeclineBatchGUID IS NULL
	GROUP BY pt.ClientGUID, c.CenterID, c.[ClientFullNameAltCalc]
	HAVING COUNT(*) > 1

	------------------------------------------------------------------
	--
	-- Determine Whether a client has more than 1 pay cycle transaction
	-- per client membership.
	--
	-- Active
	--
	------------------------------------------------------------------
	SELECT c.CenterID, c.[ClientFullNameAltCalc], c.ClientGUID, so.ClientMembershipGUID,
			mem.MembershipDescription, cm.EndDate as ClientMembership_EndDate,
			cmStat.ClientMembershipStatusDescription as ClientMembership_Status,
			COUNT(*) as NumberOfPayCycleTransactions
	FROM datPayCycleTransaction pt
		INNER JOIN datCenterFeeBatch cfb ON cfb.CenterFeeBatchGUID = pt.CenterFeeBatchGUID
		INNER JOIN datClient c ON pt.ClientGUID = c.ClientGUID
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = pt.SalesOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN lkpClientMembershipStatus cmStat ON cmStat.ClientMembershipStatusID = cm.ClientMembershipStatusID
		INNER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
	WHERE cfb.FeeMonth = @FeeMonth
		AND cfb.FeeYear = @FeeYear
		AND cfb.FeePayCycleID = @FeePayCycleID
		AND pt.CenterDeclineBatchGUID IS NULL
	GROUP BY so.ClientMembershipGUID,c.ClientGUID, c.CenterID, c.[ClientFullNameAltCalc], mem.MembershipDescription, cm.EndDate,
			cmStat.ClientMembershipStatusDescription
	HAVING COUNT(*) > 1

END
GO
