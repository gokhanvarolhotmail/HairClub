/***********************************************************************

PROCEDURE:				rptReceiptTender

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve tender data for Receipt report.
		* 10/07/10	MVT - Added last 4 digits of credit card to tender description
		* 02/11/13	MLM	- Added Field(s) to the resultSet
		* 09/25/13  MLM - Added Order by to Resultset
		* 01/13/16  RLM - (#122158) Added CreditCardTypeDescription
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptReceiptTender '0F1083AB-CD06-4034-94F0-22AA1DC23768' --Amex

rptReceiptTender '44C981CD-9511-4348-8B16-EC2BA2052115' --Visa

rptReceiptTender '429AA8FE-C77D-4884-8EAB-5712B590A02D' --No Credit Card Type listed

rptReceiptTender 'B1FB7B32-FD0E-4CE1-958E-3B222F5E1DD9' --MC

rptReceiptTender '210822C1-87C6-401C-A3A7-F6274C4F176D' --Disc

***********************************************************************/

CREATE PROCEDURE [dbo].[rptReceiptTender]
		@SalesOrderGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @TenderTypeID int,
			@CashTenderTypeID int

	Select  @TenderTypeID = TenderTypeID from LkpTenderType tt Where tt.TenderTypeDescriptionShort = 'CC'
	Select  @CashTenderTypeID = TenderTypeID from LkpTenderType tt Where tt.TenderTypeDescriptionShort = 'CASH'

	SELECT
		CASE WHEN sot.CreditCardLast4Digits is NULL THEN
			tt.TenderTypeDescription
		ELSE
			tt.TenderTypeDescription +
				(CASE WHEN cct.CreditCardTypeID = 1 THEN ' (Visa - '
					WHEN cct.CreditCardTypeID = 2 THEN ' (MC - '
					WHEN cct.CreditCardTypeID = 3 THEN ' (MC_Dbt - '
					WHEN cct.CreditCardTypeID = 4 THEN ' (Amex - '
					WHEN cct.CreditCardTypeID = 5 THEN ' (Disc - '
					ELSE ' (' END)  + sot.CreditCardLast4Digits + ')'
		END AS 'TenderTypeDescription',
		tt.TenderTypeSortOrder,
		CASE WHEN sot.TenderTypeID = @CashTenderTypeID THEN sot.CashCollected ELSE sot.Amount END as Amount,
		sot.CreditCardLast4Digits,
		c.ClientFullNameAlt2Calc,
		CONVERT(Int,CASE WHEN tt.TenderTypeID = @TenderTypeID THEN 1 ELSE 0 END) as IsCreditCard,
		sot.CreditCardTypeID,
		cct.CreditCardTypeDescription
	FROM datSalesOrder so
		INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
		INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
		INNER JOIN datClient c on so.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN dbo.lkpCreditCardType cct ON sot.CreditCardTypeID = cct.CreditCardTypeID
	WHERE so.SalesOrderGUID = @SalesOrderGUID
UNION
	SELECT
		'Change' as TenderTypeDescription,
		99 as TenderTypeSortOrder,
		ISNULL(sot.Amount,0) - ISNULL(sot.CashCollected,0) as Amount,
		sot.CreditCardLast4Digits,
		c.ClientFullNameAlt2Calc,
		CONVERT(Int,CASE WHEN tt.TenderTypeID = @TenderTypeID THEN 1 ELSE 0 END) as IsCreditCard,
		sot.CreditCardTypeID,
		cct.CreditCardTypeDescription
	FROM datSalesOrder so
		INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
		INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
		INNER JOIN datClient c on so.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN dbo.lkpCreditCardType cct ON sot.CreditCardTypeID = cct.CreditCardTypeID
	WHERE so.SalesOrderGUID = @SalesOrderGUID
		AND tt.TenderTypeID = @CashTenderTypeID
	Order by tt.TenderTypeSortOrder

END
