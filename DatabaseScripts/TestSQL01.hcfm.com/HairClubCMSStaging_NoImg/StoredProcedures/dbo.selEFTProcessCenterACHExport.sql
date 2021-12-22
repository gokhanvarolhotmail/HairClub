/* CreateDate: 05/14/2012 17:33:41.330 , ModifyDate: 02/27/2017 09:49:31.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selEFTProcessCenterACHExport]
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
		05/15/2012 - MMaass Ignore TaxExempt, fees will always be taxed.
		06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		06/25/2012 - Modified to use Pay Cycle Transactions
		07/02/2012 - Hdu added trim around bank details and exclude zero amounts
		02/03/2014 - MTovbin Modified to return cONEct Client Identifier instead of CMS 2.5 id
		07/01/2015 - Mtovbin Modified to use Clinet Membership from the Sales Order to deterime the ClientEFT.
					This was done to prevent non ACH EFT profiles from being returned if client has more than 1
					EFT profile with different EFT Account Types (ie.  ACH and AR)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTProcessCenterACHExport] '231D0108-49AE-4747-A7C4-BAE0B43AD2DA'
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTProcessCenterACHExport]
 @CenterFeeBatchGUID UNIQUEIDENTIFIER

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ACHPayCycleTransactionTypeDescriptionShort nvarchar(10) = 'ACH'


	/*****  The Routing Numbers for Canadian Centers are only 8 Characters. This is not
			an issue for NACHA files (which requires 9 characters) because HC does not
			process Canadian Centers with BOA.   ******/

	SELECT
		c.ClientGUID
		,c.ClientIdentifier AS ClientIdentifier
		,c.CenterID
		,c.LastName
		,c.FirstName
		,at.[EFTAccountTypeDescriptionShort]
		,RTRIM(LTRIM(ceft.[BankRoutingNumber])) [BankRoutingNumber]
		,RTRIM(LTRIM(ceft.[BankAccountNumber])) [BankAccountNumber]
		,pct.ChargeAmount -- includes tax
		,CASE WHEN at.[EFTAccountTypeDescriptionShort] = 'Checking' THEN 27
			WHEN at.[EFTAccountTypeDescriptionShort] = 'Savings' THEN 37
		  END AS 'trancode'
	FROM datPayCycleTransaction pct
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = pct.SalesOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN datClient c ON c.ClientGUID = pct.ClientGUID
		INNER JOIN datClientEFT ceft ON ceft.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN lkpPayCycleTransactionType ptype ON ptype.PayCycleTransactionTypeID = pct.PayCycleTransactionTypeID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID
		INNER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID

	WHERE pct.CenterFeeBatchGUID = @CenterFeeBatchGUID
			AND pct.CenterDeclineBatchGUID IS NULL -- exclude declines
			AND pct.IsSuccessfulFlag = 1
			AND ptype.PayCycleTransactionTypeDescriptionShort = @ACHPayCycleTransactionTypeDescriptionShort
			AND pct.ChargeAmount > 0
	ORDER BY pc.FeePayCycleValue


END
GO
