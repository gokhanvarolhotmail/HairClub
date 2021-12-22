/***********************************************************************
PROCEDURE:				mtnLogOutOfBalanceSalesOrders
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/16/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC mtnLogOutOfBalanceSalesOrders
***********************************************************************/
CREATE PROCEDURE mtnLogOutOfBalanceSalesOrders
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


CREATE TABLE #SalesOrdersOutOfBalance (
	CenterName NVARCHAR(128)
,	ClientName NVARCHAR(128)
,	OrderType NVARCHAR(10)
,	SalesOrderGUID UNIQUEIDENTIFIER
,	InvoiceNumber NVARCHAR(50)
,	SalesCodes NVARCHAR(2048)
,	DetailTotal DECIMAL(18, 2)
,	Tenders NVARCHAR(2048)
,	TenderTotal DECIMAL(18, 2)
,	Employee NVARCHAR(128)
)


INSERT	INTO #SalesOrdersOutOfBalance
		EXEC selSalesOrdersOutOfBalance


CREATE NONCLUSTERED INDEX IDX_SalesOrdersOutOfBalance_SalesOrderGUID ON #SalesOrdersOutOfBalance ( SalesOrderGUID );


UPDATE STATISTICS #SalesOrdersOutOfBalance;


INSERT INTO tmpOutOfBalance (
	CenterName
,	ClientName
,	OrderType
,	SalesOrderGUID
,	InvoiceNumber
,	SalesCodes
,	DetailTotal
,	Tenders
,	TenderTotal
,	Employee
,	CreateDate
,	CreateUser
)
SELECT	oob.CenterName
,		oob.ClientName
,		oob.OrderType
,		oob.SalesOrderGUID
,		oob.InvoiceNumber
,		oob.SalesCodes
,		oob.DetailTotal
,		oob.Tenders
,		oob.TenderTotal
,		oob.Employee
,		GETDATE()
,		'sa_OOB'
FROM	#SalesOrdersOutOfBalance oob
		LEFT OUTER JOIN tmpOutOfBalance toob
			ON toob.SalesOrderGUID = oob.SalesOrderGUID
WHERE	toob.SalesOrderGUID IS NULL

END
