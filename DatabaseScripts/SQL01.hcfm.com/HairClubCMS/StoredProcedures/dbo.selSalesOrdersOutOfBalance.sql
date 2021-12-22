/***********************************************************************

PROCEDURE:				selSalesOrdersOutOfBalance

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		01/08/2019

LAST REVISION DATE: 	01/08/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Selects sales orders that are open, not voided, and out of blance between the details and tenders

		* 01/08/2019	SAL	Created
		  05/22/2019	JL	Round to 2 decimal point when comparing tender and detail amount
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selSalesOrdersOutOfBalance

***********************************************************************/

CREATE PROCEDURE [dbo].[selSalesOrdersOutOfBalance]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	SELECT c.CenterDescriptionFullCalc AS Center
		,cl.ClientFullNameCalc AS Client
		,sotype.SalesOrderTypeDescriptionShort AS OrderType
		,so.SalesOrderGUID
		,so.InvoiceNumber
		,oobd.SalesCodes
		,oobd.DetailTotal
		,oobt.TenderTypes AS Tenders
		,oobt.TenderTotal
		,e.EmployeeFullNameCalc AS Employee
	FROM datSalesOrder so
		INNER JOIN (SELECT so.SalesOrderGUID, SUM(sod.PriceTaxCalc) AS DetailTotal, STRING_AGG(sc.SalesCodeDescriptionShort, ', ') AS SalesCodes
					FROM datSalesOrder so
						INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
						INNER JOIN cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
					WHERE so.IsClosedFlag = 0
						AND so.IsVoidedFlag = 0
					GROUP BY so.SalesOrderGUID) oobd on so.SalesOrderGUID = oobd.SalesOrderGUID
		INNER JOIN (SELECT so.SalesOrderGUID, SUM(sot.Amount) AS TenderTotal, STRING_AGG(tt.TenderTypeDescriptionShort, ', ') AS TenderTypes
					FROM datSalesOrder so
						INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
						INNER JOIN lkpTenderType tt on sot.TenderTypeID = tt.TenderTypeID
					WHERE so.IsClosedFlag = 0
						AND so.IsVoidedFlag = 0
					GROUP BY so.SalesOrderGUID) oobt on so.SalesOrderGUID = oobt.SalesOrderGUID
		INNER JOIN cfgCenter c on so.CenterID = c.CenterID
		INNER JOIN lkpSalesOrderType sotype on so.SalesOrderTypeID = sotype.SalesOrderTypeID
		INNER JOIN datClient cl on so.ClientGUID = cl.ClientGUID
		INNER JOIN datEmployee e on so.EmployeeGUID = e.EmployeeGUID
	WHERE so.IsClosedFlag = 0
		AND so.IsVoidedFlag = 0
		--AND oobd.DetailTotal <> oobt.TenderTotal
		AND ROUND(oobd.DetailTotal, 2) <> ROUND(oobt.TenderTotal, 2)

  END TRY

  BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END
