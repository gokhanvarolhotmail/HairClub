/*
==============================================================================
PROCEDURE:				mtnGetInsertClientEFTImport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

==============================================================================
DESCRIPTION:	Import ClientEFT records from legacy system
==============================================================================
NOTES:
		* 02/1/12 MLM - Created Stored Proc
		* 05/21/12 KRM - Added CardholderName from EFT
		* 05/30/12 MLM - Added Address and City, Changed CardHolderName to be eft.FirstName + EFT.lastName
		* 05/31/12 MLM - If Freeze Start Date is null or Freeze End Date is null = Set both Dates to NULL
		* 06/14/12 MLM - Added FreezeReason to Results
		* 07/31/12 MT  - Modified to always return EFTStatus as Active
		* 01/30/14 MLM - Add Logic to Handle 1/1/1900 for Freeze Dates
==============================================================================
SAMPLE EXECUTION:
EXEC mtnGetInsertClientEFTImport 201
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnGetInsertClientEFTImport]
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

SELECT @CreditCardType_Visa = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'V' and IsActiveFlag = 1
SELECT @CreditCardType_Master = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'M' and IsActiveFlag = 1
SELECT @CreditCardType_American = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'A' and IsActiveFlag = 1
SELECT @CreditCardType_Discover = CreditCardTypeID FROM lkpCreditCardType WHERE CreditCardTypeDescriptionShort = 'D' and IsActiveFlag = 1


DECLARE @Status_Active int,
		@Status_Frozen int

SELECT @Status_Active = EFTStatusID FROM lkpEFTStatus WHERE EFTStatusDescriptionShort = 'Active'
SELECT @Status_Frozen = EFTStatusID FROM lkpEFTStatus WHERE EFTStatusDescriptionShort = 'Frozen'

	SELECT NEWID() AS ClientEFTGUID
		,c.ClientGUID
		,cm.ClientMembershipGUID
		,eft.CardHolder_Name as CardHolderName
		,CASE WHEN eft.Acct_Type = 'C' THEN @AccountType_Checking
			WHEN eft.Acct_Type = 'S' ThEN @AccountType_Savings
			WHEN eft.Acct_Type in ('A','I','M','V') THEN @AccountType_Credit
			ELSE @AccountType_AR -- 'P' and everything else
		END as EFTAccountTypeID
		,@Status_Active as EFTStatusID
		,pc.FeePayCycleID
		,CASE WHEN eft.Acct_Type = 'V' THEN @CreditCardType_Visa
			WHEN eft.Acct_Type = 'M' THEN @CreditCardType_Master
			WHEN eft.Acct_Type = 'A' Then @CreditCardType_American
			WHEN eft.Acct_Type = 'I' THEN @CreditCardType_Discover
			ELSE NULL
		 END CreditCardTypeID
		 ,eft.Acct_No as AccountNumber
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
		 ,eft.Bank_ABA as BankRoutingNumber
		 ,CASE WHEN eft.Acct_Type IN ('C','S') THEN eft.Acct_No
			ELSE NULL
		  END as BankAccountNumber
		  ,CONVERT(nvarchar(50),'') as EFTProcessorToken
		 ,1 as IsActiveFlag -- Assume All are active For initial Import, IsActiveFlag = 0 will occur when records are removed from CMS 2.5
		 ,GETUTCDATE() as CreateDate
		 ,'sa' as CreateUser
		 ,GETUTCDATE() as LastUpdate
		 ,'sa' as LastUpdateUser
		 ,CASE WHEN eft.Freeze_End IS NULL or eft.Freeze_End = '1/1/1900' THEN NULL
			   ELSE eft.Freeze_Start
		  END as Freeze_Start
		 ,CASE WHEN eft.Freeze_Start IS NULL or eft.Freeze_Start = '1/1/1900' THEN NULL
			ELSE eft.Freeze_End
		  END as Freeze_End
		 ,c.[Address1] as [Address]
		 ,c.PostalCode as [Zip]
		 ,c.ClientIdentifier
		 ,feeFreeze.FeeFreezeReasonID
	FROM [HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT eft
		INNER JOIN dbo.datClient c on c.ClientNumber_Temp = eft.Client_No AND c.CenterID = eft.Center
		INNER JOIN [HCSQL2\SQL2005].INFOSTORE.dbo.Clients hcc on hcc.Center = c.CenterId AND hcc.Client_no = c.clientNumber_Temp
		INNER JOIN datClientMembership cm on hcc.Member1_ID = cm.Member1_ID_Temp AND c.ClientGUID = cm.ClientGUID
		INNER JOIN dbo.lkpFeePayCycle pc ON eft.PayCycleID = pc.FeePayCycleID
		--LEFT OUTER JOIN [HCSQL2\SQL2005].EFT.dbo.hcmtbl_Bank bank on eft.Bank_ABA = bank.Bank_ABA
		LEFT OUTER JOIN dbo.datClientEFT cEFT ON cEFT.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN [HCSQL2\SQL2005].EFT.dbo.lkpEFTFreezeReason  eftFreeze ON eft.FreezeReasonID = eftfreeze.EftFreezeReasonID
		LEFT OUTER JOIN lkpFeeFreezeReason feeFreeze on eftFreeze.EftFreezeReasonDescriptionShort = feeFreeze.FeeFreezeReasonDescriptionShort
	WHERE cEFT.ClientEFTGUID IS NULL
		AND (@CenterID IS NULL OR eft.Center = @CenterID)


END
