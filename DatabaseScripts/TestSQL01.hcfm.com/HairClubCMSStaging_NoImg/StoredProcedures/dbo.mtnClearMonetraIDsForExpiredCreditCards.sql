/* CreateDate: 07/19/2016 10:45:13.957 , ModifyDate: 07/19/2016 10:45:13.957 */
GO
/***********************************************************************

PROCEDURE:				mtnClearMonetraIDsForExpiredCreditCards

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		07/13/2016

LAST REVISION DATE: 	07/13/2016

--------------------------------------------------------------------------------------------------------
NOTES:  Clears the Sales Order Tender's MonetraTransactionID if the Credit Card is expired.
		This is done so that the centers can refund a sales order that was tendered against a credit card
		that is expired.

		* 07/13/2016	SAL	Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnClearMonetraIDsForExpiredCreditCards

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnClearMonetraIDsForExpiredCreditCards]
AS
BEGIN
	DECLARE @User nvarchar(25) = 'Nightly_ClearMonetraID'
	DECLARE @CurrentMonth int = MONTH(GETDATE())
	DECLARE @CurrentYear int = YEAR(GETDATE())

	UPDATE sot
	SET sot.MonetraTransactionID = NULL
		,sot.LastUpdate = GETUTCDATE()
		,sot.LastUpdateUser = @User
	FROM datCreditCardTransactionLog l
		inner join datSalesOrderTender sot on l.SalesOrderTenderGUID = sot.SalesOrderTenderGUID
	WHERE l.ExpirationDate <> '/'
		and l.ExpirationDate IS NOT NULL
		and sot.MonetraTransactionID IS NOT NULL
		and (@CurrentYear > RIGHT(l.ExpirationDate, (LEN(l.ExpirationDate) - CHARINDEX('/', l.ExpirationDate)))
		or (@CurrentYear = RIGHT(l.ExpirationDate, (LEN(l.ExpirationDate) - CHARINDEX('/', l.ExpirationDate))) and @currentMonth > LEFT(ExpirationDate, (CHARINDEX('/', ExpirationDate) - 1))))
END
GO
