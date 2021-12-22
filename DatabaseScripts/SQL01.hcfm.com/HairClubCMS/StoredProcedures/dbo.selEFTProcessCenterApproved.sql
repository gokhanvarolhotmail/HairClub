/* CreateDate: 05/14/2012 17:33:40.680 , ModifyDate: 02/27/2017 09:49:31.913 */
GO
/***********************************************************************
PROCEDURE:				[selEFTProcessCenterApproved]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		02/02/2012
LAST REVISION DATE: 	02/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return individual client eft details for transaction processing
		for centers that are approved and for eft profiles that can run
		02/02/2012 - HDu Created Stored Proc
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTProcessCenterApproved] '2BD51AE9-6155-42E1-89D5-6B0BF2114DB1'
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTProcessCenterApproved]
 @ApprovalGuid UNIQUEIDENTIFIER
-- @PayCycleID INT
--,@FeeYear INT
--,@FeeMonth INT
--,@CenterID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE
 @PayCycleID INT
,@FeeYear INT
,@FeeMonth INT
,@CenterID INT

SELECT
 @PayCycleID =FeePayCycleID
,@FeeYear =FeeYear
,@FeeMonth =FeeMonth
,@CenterID =CenterID
FROM dbo.datCenterFeeBatch WHERE CenterFeeBatchGUID = @ApprovalGuid

--TEST
PRINT @PayCycleID
PRINT @FeeYear
PRINT @FeeMonth
PRINT @CenterID

DECLARE @PayCycleValue int
SET @PayCycleValue = (SELECT FeePayCycleValue FROM lkpFeePayCycle WHERE FeePayCycleID = @PayCycleID)

--DECLARE @CenterFeeBatchStatusID INT
--SELECT @CenterFeeBatchStatusID = CenterFeeBatchStatusID FROM dbo.lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = ''

DECLARE @BatchRunDate datetime
IF @PayCycleValue = 0
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(VARCHAR(10), GETUTCDATE(), 101))
ELSE
	SET @BatchRunDate = CONVERT(DATETIME, CONVERT(nvarchar(2),@FeeMonth) + '/' + CONVERT(nvarchar(2),@PayCycleValue) + '/' + CONVERT(nvarchar(4),@FeeYear), 101)

	-- create temp table for each EFT profile
	DECLARE @ClientEFTStatus TABLE
	(
		ClientEFTGUID uniqueidentifier NOT NULL,
		Amount money NOT NULL,
		IsValidToRun bit NOT NULL,
		ClientMembershipGUID uniqueidentifier NOT NULL
	)

	-- Insert into temp table if EFT Profile is valid to run
	INSERT INTO @ClientEFTStatus (ClientEFTGUID, Amount, IsValidToRun,cm.ClientMembershipGUID)
		SELECT
			c.ClientEFTGUID,
			ISNULL(cm.MonthlyFee, 0),
			CASE WHEN
					-- Credit Card Not Expired
					((at.EFTAccountTypeDescriptionShort = 'CreditCard' AND DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) <= c.AccountExpiration)
					OR at.EFTAccountTypeDescriptionShort != 'CreditCard')

					-- Active EFT Profile
					AND IsNULL(c.IsActiveFlag, 0) = 1 AND stat.IsEFTActiveFlag = 1

					-- Membership is Active
					AND (cm.BeginDate IS NULL OR (cm.BeginDate <= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)
						AND ISNULL(cm.EndDate, DATEADD(YEAR, 1, cm.BeginDate)) >= DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate)))

					-- Account is not Frozen
					--AND (c.Freeze_Start IS NULL
					--		OR (c.Freeze_End IS NULL AND DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) < c.Freeze_Start)
					--		OR (c.Freeze_End IS NOT NULL AND (DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) < c.Freeze_Start
					--				OR DATEADD(DAY, pc.FeePayCycleValue - 1, @BatchRunDate) > c.Freeze_End)))
				THEN 1 ELSE 0 END,
				cm.ClientMembershipGUID
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
			LEFT JOIN dbo.cfgCenter Center on Center.CenterID = cm.CenterID
		 INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = c.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
		 LEFT OUTER JOIN lkpEFTAccountType at ON c.EFTAccountTypeID = at.EFTAccountTypeID
		 LEFT OUTER JOIN lkpEFTStatus stat ON stat.EFTStatusID = c.EFTStatusID

		WHERE cl.CenterID = @centerId
		AND Center.IsCorporateHeadquartersFlag =0

--SELECT * FROM @ClientEFTStatus ORDER BY ClientEFTGUID

	SELECT
		c.ClientGUID
		,c.ClientFullNameCalc
		,c.CenterID
		,eftStat.ClientMembershipGUID
		,ISNULL(st.CenterFeeBatchStatusDescription, dstat.CenterFeeBatchStatusDescription) AS CenterFeeBatchStatusDescription
		,cab.RunDate
		-- FIELDS FOR SaleRequestTransaction OBJECT
      ,ceft.[EFTAccountTypeID]
      ,ceft.[EFTStatusID]
      ,ceft.[FeePayCycleID]
      ,ceft.[CreditCardTypeID]
      ,ceft.[AccountNumberLast4Digits]
      ,ceft.[BankName]
      ,ceft.[BankPhone]
      ,ceft.[BankRoutingNumber]

      ,ceft.[EFTProcessorToken] --
      ,ceft.[BankAccountNumber] --
      ,ceft.[AccountExpiration] --
      ,eftstat.Amount --
      -- SWIPE VALUE?
      -- TRANSACTIONID?
      ,c.Address1 + ', ' + c.Address2 + ', ' + c.Address3 AS Street--
      ,c.PostalCode --
      -- VERIFICATION NUMBER?
      -- ISCARDPRESENT
      -- ORDERNUMBER
      -- ISSENT
      -- ISRECIEVED
      ,CAST(CASE WHEN GETDATE() BETWEEN ceft.Freeze_Start AND Freeze_End THEN 1 ELSE 0 END  AS BIT) AS 'IsFrozen'
	FROM @ClientEFTStatus eftStat
		INNER JOIN datClientEFT ceft ON eftStat.ClientEFTGUID = ceft.ClientEFTGUID
		INNER JOIN datClient c ON c.ClientGUID = ceft.ClientGUID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID AND pc.FeePayCycleID = @PayCycleID
		LEFT OUTER JOIN datCenterFeeBatch cab ON cab.CenterID = c.CenterID
			AND cab.FeeMonth = @FeeMonth
			AND cab.FeeYear = @FeeYear
			AND cab.FeePayCycleID = @PayCycleID
		LEFT OUTER JOIN lkpCenterFeeBatchStatus st ON st.CenterFeeBatchStatusID = cab.CenterFeeBatchStatusID
		LEFT JOIN dbo.lkpCenterFeeBatchStatus dstat ON dstat.CenterFeeBatchStatusID = 1
		LEFT OUTER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
	WHERE eftStat.IsValidToRun = 1
	--AND st.CenterFeeBatchStatusID = @CenterFeeBatchStatusID
	ORDER BY pc.FeePayCycleValue

END
GO
