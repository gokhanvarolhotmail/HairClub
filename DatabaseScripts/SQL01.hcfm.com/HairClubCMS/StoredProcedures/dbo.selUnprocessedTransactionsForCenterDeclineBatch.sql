/* CreateDate: 05/14/2012 17:41:17.567 , ModifyDate: 02/27/2017 09:49:35.130 */
GO
/***********************************************************************
PROCEDURE:				[selUnprocessedTransactionsForCenterDeclineBatch]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		05/08/2012
LAST REVISION DATE: 	05/08/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Select Unprocessed sale request transactions for center decline batch
		05/08/2012 - MTovbin Created Stored Proc
		05/30/2012 - MMAASS Added InvoiceNumber to the ResultSet
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selUnprocessedTransactionsForCenterDeclineBatch] 'F923F21A-66DA-4ACF-9AC0-96191447B327'
***********************************************************************/
CREATE PROCEDURE [dbo].[selUnprocessedTransactionsForCenterDeclineBatch]
		@CenterDeclineBatchGUID uniqueidentifier

AS
BEGIN

	SET NOCOUNT ON

	SELECT
		so.SalesOrderGUID
		,ISNULL(sd.TaxRate1,0) as TaxRate1
		,ISNULL(sd.TaxRate2,0) as TaxRate2
		,c.ClientGUID
		,c.ClientFullNameCalc
		,c.CenterID
		,cm.ClientMembershipGUID
		,cab.RunDate
		,ceft.[EFTAccountTypeID]
		,at.[EFTAccountTypeDescriptionShort]
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
		,ISNULL(cm.MonthlyFee, 0) AS Amount
		,c.Address1 + ', ' + c.Address2 + ', ' + c.Address3 AS Street--
		,c.PostalCode --
		,c.IsTaxExemptFlag as IsTaxExempt
		,Cast(0 AS BIT) AS 'IsFrozen'
		,c.ClientIdentifier
		,cab.CenterFeeBatchGUID
		,so.InvoiceNumber
	FROM datSalesOrder so
		INNER JOIN datClient c ON c.ClientGUID = so.ClientGUID
		INNER JOIN datClientEFT ceft ON c.ClientGUID = ceft.ClientGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = ceft.ClientMembershipGUID AND ceft.ClientGUID = cm.ClientGUID
		INNER JOIN datCenterFeeBatch cab ON cab.CenterFeeBatchGUID = so.CenterFeeBatchGUID
		LEFT OUTER JOIN datSalesOrderDetail sd ON sd.SalesOrderGUID = so.SalesOrderGUID
		LEFT OUTER JOIN datPayCycleTransaction pc ON pc.SalesOrderGUID = sd.SalesOrderGUID
		LEFT OUTER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
	WHERE so.CenterDeclineBatchGUID = @CenterDeclineBatchGUID
		AND pc.PayCycleTransactionGUID IS NULL


END
GO
