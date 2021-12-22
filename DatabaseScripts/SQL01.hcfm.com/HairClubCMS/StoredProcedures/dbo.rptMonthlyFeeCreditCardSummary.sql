/*===============================================================================================
 Procedure Name:                  rptMonthlyFeeCreditCardSummary
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              04/15/2014
 Destination Server:        HairclubCMS
 Destination Database:      SQL01
 Related Application:       Conect
================================================================================================
**NOTES**
This report was cloned from the stored procedure and report [rptCreditCardPaymentSummary].
================================================================================================
Sample Execution:
EXEC [rptMonthlyFeeCreditCardSummary] 282, '4/1/2014'

EXEC [rptMonthlyFeeCreditCardSummary] 855, '4/1/2014'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptMonthlyFeeCreditCardSummary]
	@CenterID int,
	@ReportDate DateTime
AS
BEGIN


	DECLARE @CCTenderTypeID int
	SELECT @CCTenderTypeID = TenderTypeID from lkpTendertype Where TenderTypeDescriptionShort = 'CC'

	DECLARE @SalesOrderType_MonthlyFee int
	SELECT @SalesOrderType_MonthlyFee = SalesOrderTypeID From LkpSalesOrderType where SalesOrderTypeDescriptionShort = 'FO'

	DECLARE @SaleOrders TABLE
	(
	  InvoiceNumber nvarchar(50),
	  SalesOrderGuid uniqueidentifier,
	  ClientFullNameCalc nvarchar(100),
	  [Price] money,
	  Tax1 money,
	  Tax2 money,
	  PriceTaxCalc money
	)

	INSERT INTO @SaleOrders
			(InvoiceNumber, SalesOrderGuid, ClientFullNameCalc, [Price], Tax1, Tax2, PriceTaxCalc)
	SELECT InvoiceNumber
		,results.SalesOrderGuid
		,ClientFullNameCalc
		,SUM([ExtendedPriceCalc]) as [Price]
		,SUM(Tax1) as Tax1
		,SUM(Tax2) as Tax2
		,SUM(PriceTaxCalc) as PriceTaxCalc
	FROM (
				Select so.InvoiceNumber
					,so.SalesOrderGuid
					,c.ClientFullNameCalc
					,sod.[ExtendedPriceCalc]
					,sod.[Tax1]
					,sod.[Tax2]
					,sod.PriceTaxCalc
				From datSalesOrder so
				inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
				inner join datClient c on so.ClientGUID = c.ClientGUID
				CROSS APPLY
				(
					SELECT TOP 1 *
						FROM datSalesOrderTender
						WHERE SalesOrderGUID = so.SalesOrderGUID
							AND TenderTypeID = @CCTenderTypeID
				) sot
				Where so.CenterID = @CenterID
					AND CONVERT(DATETIME,CONVERT(VARCHAR(15), dbo.[fn_GetLocalDateTime](so.OrderDate,so.CenterID), 101)) = @ReportDate
					AND sod.IsRefundedFlag = 0
					AND so.IsVoidedFlag = 0
					AND so.SalesOrderTypeID = @SalesOrderType_MonthlyFee
			UNION ALL
				Select so.InvoiceNumber
					,so.SalesOrderGuid
					,c.ClientFullNameCalc
					,sod.[ExtendedPriceCalc]
					,sod.[Tax1]
					,sod.[Tax2]
					,sod.PriceTaxCalc
				From datSalesOrder so
				inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
				inner join datClient c on so.ClientGUID = c.ClientGUID
				CROSS APPLY
				(
					SELECT TOP 1 *
						FROM datSalesOrderTender
						WHERE SalesOrderGUID = so.SalesOrderGUID
							AND TenderTypeID = @CCTenderTypeID
				) sot
				Where so.CenterID = @CenterID
					AND CONVERT(DATETIME,CONVERT(VARCHAR(15), dbo.[fn_GetLocalDateTime](so.OrderDate,so.CenterID), 101)) = @ReportDate
					AND sod.IsRefundedFlag = 1 --Pull where there are refunds
					AND so.IsVoidedFlag = 0
					AND so.SalesOrderTypeID = @SalesOrderType_MonthlyFee  -- Show refunds
			) results
		GROUP BY results.InvoiceNumber, results.SalesOrderGuid, results.ClientFullNameCalc
		ORDER BY results.InvoiceNumber

	SELECT *
	FROM
		(SELECT
			tso.InvoiceNumber
			,ClientFullNameCalc
			,[Price]
			,Tax1
			,Tax2
			,PriceTaxCalc
			,sot.Amount as TenderAmount
			,CASE WHEN so.IsRefundedFlag = 1 AND sot.CreditCardTypeID IS NULL THEN origtender.CreditCardTypeID
					ELSE  sot.CreditCardTypeID END AS 'CreditCardTypeID'
			,CASE WHEN so.IsRefundedFlag = 1 AND sot.CreditCardTypeID IS NULL THEN origcct.CreditCardTypeDescription
					ELSE  cct.CreditCardTypeDescription END AS 'CreditCardTypeDescription'
			,sot.CreditCardLast4Digits
		FROM @SaleOrders tso
			INNER JOIN datSalesOrder so ON so.SalesOrderGUID = tso.SalesOrderGuid
			INNER JOIN datSalesOrderTender sot ON sot.SalesOrderGuid = tso.SalesOrderGuid
			OUTER APPLY
			(
				SELECT TOP 1 origsot.*
					FROM datSalesOrderDetail sod
						INNER JOIN datSalesOrderDetail origsod ON origsod.SalesOrderDetailGUID = sod.RefundedSalesOrderDetailGUID
						INNER JOIN datSalesOrderTender origsot ON origsot.SalesOrderGUID = origsod.SalesOrderGUID
					WHERE sod.SalesOrderGUID = tso.SalesOrderGUID
						AND origsot.TenderTypeID = @CCTenderTypeID
						AND origsot.CreditCardLast4Digits = sot.CreditCardLast4Digits
			) origtender
			LEFT JOIN lkpCreditCardType cct on sot.CreditCardTypeID = cct.CreditCardTypeID
			LEFT JOIN lkpCreditCardType origcct on origtender.CreditCardTypeID = origcct.CreditCardTypeID
		)q
	WHERE q.CreditCardTypeID IS NOT NULL
	ORDER BY q.InvoiceNumber

END
