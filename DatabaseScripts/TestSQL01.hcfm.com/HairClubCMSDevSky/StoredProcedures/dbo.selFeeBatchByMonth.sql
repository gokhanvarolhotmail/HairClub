/* CreateDate: 05/14/2012 17:35:09.557 , ModifyDate: 02/27/2017 09:49:32.740 */
GO
/***********************************************************************

PROCEDURE:				selFeeBatchByMonth

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/03/2011

LAST REVISION DATE: 	08/03/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary of the EFT batches for the specified month.

		08/03/2011 - AS: Created Stored Proc

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[selFeeBatchByMonth] 1, 2012, 203

***********************************************************************/
CREATE PROCEDURE [dbo].[selFeeBatchByMonth]
	@month as int,
	@year as int,
	@centerId as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @BatchRunDate datetime
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@month) + '/01/' + CONVERT(nvarchar(4),@year), 101)


	-- create temp table for each EFT profile
	DECLARE @ClientFeeStatus TABLE
	(
		ClientEFTGUID uniqueidentifier NOT NULL,
		Amount money NOT NULL,
		IsValidToRun bit NOT NULL
	)


	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientFeeStatus (ClientEFTGUID, Amount, IsValidToRun)
		SELECT
			c.ClientEFTGUID,
			ISNULL(cm.MonthlyFee, 0),
			CASE WHEN
					-- Credit Card Not Expired
					(at.EFTAccountTypeDescriptionShort = 'CreditCard'
					AND DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) <= c.AccountExpiration)

					-- Active EFT Profile
					AND IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1

					-- Membership is Active
					AND (cm.BeginDate IS NULL OR (cm.BeginDate <= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)
						AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)))

					-- Account is not Frozen
					AND (c.Freeze_Start IS NULL
							OR (c.Freeze_End IS NULL AND DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) < c.Freeze_Start)
							OR (c.Freeze_End IS NOT NULL AND (DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) < c.Freeze_Start
									OR DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) > c.Freeze_End)))
				THEN 1 ELSE 0 END
		FROM datClientEFT c
		 INNER JOIN datClient cl ON cl.ClientGUID = c.ClientGUID
		 INNER JOIN datClientMembership cm
				ON cm.ClientMembershipGUID = (SELECT Top(1) clMem.ClientMembershipGUID
												FROM datClientMembership clMem
													INNER JOIN cfgMembership m ON m.MembershipID = clMem.MembershipID
													INNER JOIN lkpClientMembershipStatus cms ON clMem.ClientMembershipStatusID = cms.ClientMembershipStatusID
												WHERE clMem.ClientGUID = c.ClientGUID
													AND cms.ClientMembershipStatusDescriptionShort = 'A'
													AND m.MembershipDescriptionShort NOT IN ('CANCEL', 'RETAIL')
												ORDER BY clMem.EndDate desc)
		 INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID
		 LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
		 LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID
		WHERE cl.CenterID = @centerId

--SELECT * FROM @ClientEFTStatus ORDER BY IsValidToRun DESC,ClientEFTGUID

	SELECT
		cab.CenterFeeBatchGUID,
		pc.FeePayCycleDescription,
		COUNT(ceft.ClientEFTGUID) AS ProjectedCount,
		SUM(eftstat.Amount) AS ProjectedAmount,
		cab.ApprovedDate,
		CASE WHEN st.CenterFeeBatchStatusDescriptionShort IS NULL THEN 'Waiting Approval'
			WHEN st.CenterFeeBatchStatusDescriptionShort = 'APPROVED' THEN 'Approved on ' -- + ISNULL(CONVERT(VARCHAR(12), cab.ApprovedDate, 101), '')
			WHEN st.CenterFeeBatchStatusDescriptionShort = 'COMPLETED' THEN 'Run on ' + CONVERT(VARCHAR(12), cab.RunDate, 101)
			ELSE st.CenterFeeBatchStatusDescriptionShort END AS [Status],

		SUM(CASE WHEN ISNULL(eftStat.IsValidToRun, 0) = 0 THEN 1 ELSE 0 END) AS WontRunCount,
		SUM(CASE WHEN ISNULL(eftStat.IsValidToRun, 0) = 1 THEN 1 ELSE 0 END) AS WillRunCount,
		SUM(CASE WHEN ISNULL(eftStat.IsValidToRun, 0) = 0 THEN eftstat.Amount ELSE 0 END) AS WontRunAmount,
		SUM(CASE WHEN ISNULL(eftStat.IsValidToRun, 0) = 1 THEN eftstat.Amount ELSE 0 END) AS WillRunAmount,
		pc.FeePayCycleID AS FeePayCycleID
	FROM @ClientFeeStatus eftStat
		INNER JOIN datClientEFT ceft ON eftStat.ClientEFTGUID = ceft.ClientEFTGUID
		INNER JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID
		LEFT OUTER JOIN datCenterFeeBatch cab ON cab.CenterID = @centerId
				AND cab.FeeMonth = @month AND cab.FeeYear = @year AND cab.FeePayCycleID = pc.FeePayCycleID
		LEFT OUTER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
		LEFT OUTER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
	GROUP BY pc.FeePayCycleValue,
		pc.FeePayCycleID,
		pc.FeePayCycleDescription,
		cab.ApprovedDate,
		st.CenterFeeBatchStatusDescriptionShort,
		cab.RunDate,
		cab.CenterFeeBatchGUID
	ORDER BY pc.FeePayCycleValue

END
GO
