/*
==============================================================================
PROCEDURE:				mtnClientEFTImport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 3/5/2011

LAST REVISION DATE: 	 3/5/2011

==============================================================================
DESCRIPTION:	Import ClientEFT records from legacy system
==============================================================================
NOTES:
		* 03/05/11 MLM - Created Stored Proc
		* 03/05/11 MLM - Added @CenterID parameter

==============================================================================
SAMPLE EXECUTION:
EXEC mtnClientEFTImport 201
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnClientEFTImportxxx]
	@CenterID int = null
AS
BEGIN

DECLARE @AccountType_Credit integer
DECLARE @AccountType_Checking integer
DECLARE @AccountType_Savings integer
DECLARE @AccountType_AR integer

SELECT @AccountType_Credit = EFTAccountTypeID FROM lkpEFTAccountType WHERE EFTAccountTypeDescriptionShort = 'CreditCard'
SELECT @AccountType_Checking = EFTAccountTypeID FROM lkpEFTAccountType WHERE EFTAccountTypeDescriptionShort = 'Checking'
SELECT @AccountType_Savings = EFTAccountTypeID FROM lkpEFTAccountType WHERE EFTAccountTypeDescriptionShort = 'Savings'
SELECT @AccountType_AR = EFTAccountTypeID FROM lkpEFTAccountType WHERE EFTAccountTypeDescriptionShort = 'A/R'


DECLARE @CreditCardType_Visa int,
		@CreditCardType_Master int,
		@CreditCardType_American int,
		@CreditCardType_Discover int

SELECT @CreditCardType_Visa = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'V' AND IsActiveFlag = 1
SELECT @CreditCardType_Master = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'M' AND IsActiveFlag = 1
SELECT @CreditCardType_American = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'A' AND IsActiveFlag = 1
SELECT @CreditCardType_Discover = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'D' AND IsActiveFlag = 1


DECLARE @Status_Active int,
		@Status_Frozen int

SELECT @Status_Active = EFTStatusID FROM lkpEFTStatus WHERE EFTStatusDescriptionShort = 'Active'
SELECT @Status_Frozen = EFTStatusID FROM lkpEFTStatus WHERE EFTStatusDescriptionShort = 'Frozen'


--Delete Record(s) Do not Exists in CMS 2.6
DELETE dbo.datClientEFT
FROM dbo.datClientEFt cEFT
	INNER JOIN dbo.datClient c on cEFT.ClientGUID = c.ClientGUID
	LEFT OUTER JOIN EFT.dbo.hcmtbl_EFT eft on c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
WHERE  eft.Client_No IS NULL


--Update Existing Records
UPDATE cEFT
	SET EFTAccountTypeID = CASE WHEN eft.Acct_Type = 'C' THEN @AccountType_Checking
								WHEN eft.Acct_Type = 'S' ThEN @AccountType_Savings
								WHEN eft.Acct_Type in ('A','I','M','V') THEN @AccountType_Credit
								ELSE @AccountType_AR -- 'P' and everything else
							END,
		EFTStatusID = CASE WHEN c.CenterID = eft.Center AND c.ClientNumber_Temp = eft.Client_No AND GETUTCDATE() BETWEEN eft.Freeze_Start AND eft.Freeze_End THEN @Status_Frozen
								ELSE @Status_Active
					  END,
		EFTPayCycleID = pc.EFTPayCycleID,
		CreditCardTypeID = CASE WHEN eft.Acct_Type = 'V' THEN @CreditCardType_Visa
								WHEN eft.Acct_Type = 'M' THEN @CreditCardType_Master
								WHEN eft.Acct_Type = 'A' Then @CreditCardType_American
								ELSE @CreditCardType_Discover
							END,
		AccountNumberLast4Digits = CASE WHEN eft.Acct_No IS NULL THEN NULL
										WHEN LEN(eft.Acct_No) < 4 THEN NULL
										ELSE RIGHT(eft.Acct_No,4)
									END,
		AccountExpiration = CASE WHEN eft.Acct_Exp IS NOT NULL THEN
								CASE WHEN LEN(eft.Acct_Exp) = 5 THEN DATEADD(DAY,-1,DATEADD(MONTH,1,CONVERT(DATETIME,REPLACE(eft.Acct_Exp,'/','/01/'),1)))
									ELSE NULL
								END
								ELSE NULL
							END,
		BankName = eft.Bank_Name,
		BankPhone = eft.Bank_Phone,
		BankRoutingNumber = bank.Bank_ABA,
		BankAccountNumber = CASE WHEN eft.Acct_Type IN ('C','S') THEN eft.Acct_No
								ELSE NULL
							END,
		CreateDate = GETUTCDATE(),
		CreateUser = 'sa',
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
FROM EFT.dbo.hcmtbl_EFT eft
	INNER JOIN dbo.datClient c on c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
	INNER JOIN dbo.datClientMembership cm on c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
	INNER JOIN dbo.lkpEFTPayCycle pc ON eft.PayCycleID = pc.EFTPayCycleID
	INNER JOIN dbo.datClientEFT cEFT ON cEFT.ClientGUID = c.ClientGUID
	LEFT OUTER JOIN EFT.dbo.hcmtbl_Bank bank on eft.Bank_ABA = bank.Bank_ABA
WHERE (@CenterID IS NULL OR eft.Center = @CenterID)

--INSERT NEW\Missing records into the database
INSERT INTO datClientEFT(
		ClientEFTGUID,
		ClientGUID,
		ClientMembershipGUID,
		EFTAccountTypeID,
		EFTStatusID,
		EFTPayCycleID,
		CreditCardTypeID,
		AccountNumberLast4Digits,
		AccountExpiration,
		BankName,
		BankPhone,
		BankRoutingNumber,
		BankAccountNumber,
		EFTProcessorToken,
		IsActiveFlag,
		CreateDate,
		CreateUser,
		LastUpdate,
		LastUpdateUser,
		Freeze_Start,
		Freeze_End,
		EFT_Freeze)
SELECT NEWID()
	,c.ClientGUID
	,cm.ClientMembershipGUID
	,CASE WHEN eft.Acct_Type = 'C' THEN @AccountType_Checking
		WHEN eft.Acct_Type = 'S' ThEN @AccountType_Savings
		WHEN eft.Acct_Type in ('A','I','M','V') THEN @AccountType_Credit
		ELSE @AccountType_AR -- 'P' and everything else
	END as EFTAccountTypeID
	,CASE WHEN c.CenterID = eft.Center AND c.ClientNumber_Temp = eft.Client_No AND GETUTCDATE() BETWEEN eft.Freeze_Start AND eft.Freeze_End THEN @Status_Frozen
		ELSE @Status_Active
	END as EFTStatusID
	,pc.EFTPayCycleID
	,CASE WHEN eft.Acct_Type = 'V' THEN @CreditCardType_Visa
		WHEN eft.Acct_Type = 'M' THEN @CreditCardType_Master
		WHEN eft.Acct_Type = 'A' Then @CreditCardType_American
		ELSE @CreditCardType_Discover
	 END CreditCardTypeID
	 ,CASE WHEN eft.Acct_No IS NULL THEN NULL
		   WHEN LEN(eft.Acct_No) < 4 THEN NULL
		   ELSE RIGHT(eft.Acct_No,4)
	  END AS AccountNumberLast4Digits
	 ,CASE WHEN eft.Acct_Exp IS NOT NULL THEN
		  CASE WHEN LEN(eft.Acct_Exp) = 5 THEN DATEADD(DAY,-1,DATEADD(MONTH,1,CONVERT(DATETIME,REPLACE(eft.Acct_Exp,'/','/01/'),1)))
			ELSE NULL
		  END
		ELSE NULL
	  END AS AccountExpiration
	 ,eft.Bank_Name as BankName
	 ,eft.Bank_Phone as BankPhone
	 ,bank.Bank_ABA as BankRoutingNumber
	 ,CASE WHEN eft.Acct_Type IN ('C','S') THEN eft.Acct_No
		ELSE NULL
	  END as BankAccountNumber
	  ,NULL as EFTProcessorToken
	 ,1 as IsActiveFlag -- Assume All are active For initial Import, IsActiveFlag = 0 will occur when records are removed from CMS 2.5
	 ,GETUTCDATE() as CreateDate
	 ,'sa' as CreateUser
	 ,GETUTCDATE() as LastUpdate
	 ,'sa' as LastUpdateUser
	 ,eft.Freeze_Start as Freeze_Start
	 ,eft.Freeze_End as Freeze_End
	 ,eft.EFT_Freeze as EFT_Freeze
FROM EFT.dbo.hcmtbl_EFT eft
	INNER JOIN dbo.datClient c on c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
	INNER JOIN dbo.datClientMembership cm on c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
	INNER JOIN dbo.lkpEFTPayCycle pc ON eft.PayCycleID = pc.EFTPayCycleID
	LEFT OUTER JOIN EFT.dbo.hcmtbl_Bank bank on eft.Bank_ABA = bank.Bank_ABA
	LEFT OUTER JOIN dbo.datClientEFT cEFT ON cEFT.ClientGUID = c.ClientGUID
WHERE cEFT.ClientEFTGUID IS NULL
	AND (@CenterID IS NULL OR eft.Center = @CenterID)

END
