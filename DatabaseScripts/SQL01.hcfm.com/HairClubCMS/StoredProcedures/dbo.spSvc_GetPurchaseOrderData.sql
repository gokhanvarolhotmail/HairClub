/***********************************************************************
PROCEDURE:				spSvc_GetPurchaseOrderData
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetPurchaseOrderData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetPurchaseOrderData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, GETDATE())) + 1 , 0))


SELECT	ctr.CenterDescriptionFullCalc AS 'Distributor'
,		dpo.PurchaseOrderNumber
,		CAST(dpo.PurchaseOrderDate AS DATE) AS 'PurchaseOrderDate'
,		dpo.TrackingNumber
,		dpo.Carrier
,		dpo.StatusAtDistributor
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription
,		scd.ItemSKU
,		scd.PackSKU
,		uom.UnitOfMeasureDescription AS 'UnitOfMeasure'
,		dpod.Quantity
,		dpod.ExtendedCenterCost
FROM	HairClubCMS.dbo.datDistributorPurchaseOrder dpo
		INNER JOIN HairClubCMS.dbo.datDistributorPurchaseOrderDetail dpod
			ON dpod.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
		INNER JOIN HairClubCMS.dbo.lkpUnitOfMeasure uom
			ON uom.UnitOfMeasureID = dpod.UnitOfMeasureID
		INNER JOIN HairClubCMS.dbo.cfgSalesCodeDistributor scd
			ON scd.SalesCodeDistributorID = dpod.SalesCodeDistributorID
		INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON sc.SalesCodeID = scd.SalesCodeID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr
			ON ctr.CenterID = dpo.DistributorCenterID
WHERE	ctr.CenterNumber = 102 --IFS
		AND CAST(dpo.PurchaseOrderDate AS DATE) BETWEEN @StartDate AND @EndDate
ORDER BY dpo.PurchaseOrderDate

END
