/*===============================================================================================
-- Procedure Name:                  rptCreditCardPaymentSummary
-- Procedure Description:
--
-- Created By:                Mike Maass
-- Implemented By:            Mike Maass
-- Last Modified By:          Mike Maass
--
-- Date Created:              01/15/2013
-- Date Implemented:
-- Date Last Modified:        01/15/2013
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
	02/19/13	MLM		Excluded Voided SalesOrders
	10/04/13	MVT		Modifed proc to handle more than 1 credit card tender on the order.
	10/16/13	MLM		Excluded Monthly Fees
	11/22/2013	RMH		Added WHERE CreditCardTypeID IS NOT NULL to remove cash payments (WO#93986).
						Show all refunds even if they are Monthly Fees.
	12/21/2016	DSL		Optimized procedure for DST
================================================================================================
Sample Execution:

EXEC [rptCreditCardPaymentSummary] 282, '10/26/13'
EXEC [rptCreditCardPaymentSummary] 201, '12/10/2016'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptCreditCardPaymentSummary]
	@CenterID int,
	@ReportDate DateTime
AS
BEGIN

SELECT  TimeZoneID
,       [UTCOffset]
,       [UsesDayLightSavingsFlag]
,       [IsActiveFlag]
,       dbo.GetUTCFromLocal(@ReportDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @ReportDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
INTO    #UTCDateParms
FROM    dbo.lkpTimeZone
WHERE   [IsActiveFlag] = 1


DECLARE @CCTenderTypeID int


SELECT  @CCTenderTypeID = TenderTypeID
FROM    lkpTenderType
WHERE   TenderTypeDescriptionShort = 'CC'


DECLARE @SalesOrderType_MonthlyFee INT


SELECT  @SalesOrderType_MonthlyFee = SalesOrderTypeID
FROM    lkpSalesOrderType
WHERE   SalesOrderTypeDescriptionShort = 'FO'


DECLARE @SaleOrders TABLE (
	InvoiceNumber NVARCHAR(50)
,	SalesOrderGuid UNIQUEIDENTIFIER
,	ClientFullNameCalc NVARCHAR(100)
,	Price MONEY
,	Tax1 MONEY
,	Tax2 MONEY
,	PriceTaxCalc MONEY
)


INSERT  INTO @SaleOrders (
			InvoiceNumber
        ,	SalesOrderGuid
        ,	ClientFullNameCalc
        ,	Price
        ,	Tax1
        ,	Tax2
        ,	PriceTaxCalc
		)
        SELECT  InvoiceNumber
        ,       results.SalesOrderGUID
        ,       ClientFullNameCalc
        ,       SUM(ExtendedPriceCalc) AS 'Price'
        ,       SUM(Tax1) AS 'Tax1'
        ,       SUM(Tax2) AS 'Tax2'
        ,       SUM(PriceTaxCalc) AS 'PriceTaxCalc'
        FROM    ( SELECT    so.InvoiceNumber
                  ,         so.SalesOrderGUID
                  ,         c.ClientFullNameCalc
                  ,         sod.ExtendedPriceCalc
                  ,         sod.Tax1
                  ,         sod.Tax2
                  ,         sod.PriceTaxCalc
                  FROM      datSalesOrder so
                            INNER JOIN datSalesOrderDetail sod
                                ON so.SalesOrderGUID = sod.SalesOrderGUID
                            INNER JOIN datClient c
                                ON so.ClientGUID = c.ClientGUID
							INNER JOIN cfgCenter ctr ON so.ClientHomeCenterID = ctr.CenterID
							INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
							JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
                            CROSS APPLY ( SELECT TOP 1
                                                    *
                                          FROM      datSalesOrderTender
                                          WHERE     SalesOrderGUID = so.SalesOrderGUID
                                                    AND TenderTypeID = @CCTenderTypeID
                                        ) sot
                  WHERE     so.CenterID = @CenterID
							AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
                            --AND CONVERT(DATETIME, CONVERT(VARCHAR(15), dbo.fn_GetLocalDateTime(so.OrderDate, so.CenterID), 101)) = @ReportDate
                            AND sod.IsRefundedFlag = 0
                            AND so.IsVoidedFlag = 0
                            AND so.SalesOrderTypeID <> @SalesOrderType_MonthlyFee
                  UNION ALL
                  SELECT    so.InvoiceNumber
                  ,         so.SalesOrderGUID
                  ,         c.ClientFullNameCalc
                  ,         sod.ExtendedPriceCalc
                  ,         sod.Tax1
                  ,         sod.Tax2
                  ,         sod.PriceTaxCalc
                  FROM      datSalesOrder so
                            INNER JOIN datSalesOrderDetail sod
                                ON so.SalesOrderGUID = sod.SalesOrderGUID
                            INNER JOIN datClient c
                                ON so.ClientGUID = c.ClientGUID
							INNER JOIN cfgCenter ctr ON so.ClientHomeCenterID = ctr.CenterID
							INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
							JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
                            CROSS APPLY ( SELECT TOP 1
                                                    *
                                          FROM      datSalesOrderTender
                                          WHERE     SalesOrderGUID = so.SalesOrderGUID
                                                    AND TenderTypeID = @CCTenderTypeID
                                        ) sot
                  WHERE     so.CenterID = @CenterID
                            AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
							--AND CONVERT(DATETIME, CONVERT(VARCHAR(15), dbo.fn_GetLocalDateTime(so.OrderDate, so.CenterID), 101)) = @ReportDate
                            AND sod.IsRefundedFlag = 1 --Pull where there are refunds
                            AND so.IsVoidedFlag = 0
                ) results
        GROUP BY results.InvoiceNumber
        ,       results.SalesOrderGUID
        ,       results.ClientFullNameCalc
		ORDER BY results.InvoiceNumber


SELECT  *
FROM    ( SELECT    tso.InvoiceNumber
          ,         ClientFullNameCalc
          ,         Price
          ,         Tax1
          ,         Tax2
          ,         PriceTaxCalc
          ,         sot.Amount AS 'TenderAmount'
          ,         CASE WHEN so.IsRefundedFlag = 1
                              AND sot.CreditCardTypeID IS NULL THEN origtender.CreditCardTypeID
                         ELSE sot.CreditCardTypeID
                    END AS 'CreditCardTypeID'
          ,         CASE WHEN so.IsRefundedFlag = 1
                              AND sot.CreditCardTypeID IS NULL THEN origcct.CreditCardTypeDescription
                         ELSE cct.CreditCardTypeDescription
                    END AS 'CreditCardTypeDescription'
          ,         sot.CreditCardLast4Digits
          FROM      @SaleOrders tso
                    INNER JOIN datSalesOrder so
                        ON so.SalesOrderGUID = tso.SalesOrderGuid
                    INNER JOIN datSalesOrderTender sot
                        ON sot.SalesOrderGUID = tso.SalesOrderGuid
                    OUTER APPLY ( SELECT TOP 1
                                            origsot.*
                                  FROM      datSalesOrderDetail sod
                                            INNER JOIN datSalesOrderDetail origsod
                                                ON origsod.SalesOrderDetailGUID = sod.RefundedSalesOrderDetailGUID
                                            INNER JOIN datSalesOrderTender origsot
                                                ON origsot.SalesOrderGUID = origsod.SalesOrderGUID
                                  WHERE     sod.SalesOrderGUID = tso.SalesOrderGuid
                                            AND origsot.TenderTypeID = @CCTenderTypeID
                                            AND origsot.CreditCardLast4Digits = sot.CreditCardLast4Digits
                                ) origtender
                    LEFT JOIN lkpCreditCardType cct
                        ON sot.CreditCardTypeID = cct.CreditCardTypeID
                    LEFT JOIN lkpCreditCardType origcct
                        ON origtender.CreditCardTypeID = origcct.CreditCardTypeID
        ) q
WHERE   q.CreditCardTypeID IS NOT NULL
ORDER BY q.InvoiceNumber

END
