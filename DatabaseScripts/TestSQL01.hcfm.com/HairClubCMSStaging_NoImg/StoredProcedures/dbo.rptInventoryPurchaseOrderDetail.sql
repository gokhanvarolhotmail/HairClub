/* CreateDate: 05/28/2018 22:20:41.807 , ModifyDate: 07/17/2018 07:25:38.027 */
GO
/***********************************************************************

PROCEDURE:				rptInventoryPurchaseOrderDetail

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED: 		05/03/2018

LAST REVISION DATE: 	05/03/2018

--------------------------------------------------------------------------------------------------------
NOTES:  Gets Distributor Purchase Order for Inventory Purchase Order Detail report

		* 05/03/2018	RH	Created
		* 06/09/2018	SL	Modified to return DPO.DistributorPurchaseOrderStatusDate
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptInventoryPurchaseOrderDetail 1

***********************************************************************/

CREATE PROCEDURE [dbo].[rptInventoryPurchaseOrderDetail]
	@DPOId int
AS
BEGIN

	SELECT DPO.PurchaseOrderNumber
		,	DPO.PurchaseOrderDate
		,	DPO.DistributorOrderReference
		,	DISTCTR.CenterDescriptionFullCalc AS Distributor
		,	POCTR.CenterDescriptionFullCalc AS Center
		,	DPOS.DistributorPurchaseOrderStatusDescription As PurchaseOrderStatus
		,	SCD.SalesCodeDistributorID
		,	SCD.SalesCodeID
		,	SCD.ItemSKU
		,	SCD.ItemName
		,	SCD.ItemDescription
		,	SCD.IsActive
		,	DPOD.UnitOfMeasureID
		,	UOM.UnitOfMeasureDescription
		,	DPOD.Quantity
		,	DPOD.ExtendedCenterCost
		,	DPO.DistributorPurchaseOrderStatusDate As PurchaseOrderStatusDate
	FROM dbo.datDistributorPurchaseOrder DPO
	INNER JOIN datDistributorPurchaseOrderDetail DPOD
		ON DPOD.DistributorPurchaseOrderID = DPO.DistributorPurchaseOrderID
	INNER JOIN dbo.cfgSalesCodeDistributor SCD
		ON SCD.SalesCodeDistributorID = DPOD.SalesCodeDistributorID
	INNER JOIN dbo.lkpUnitOfMeasure UOM
		ON UOM.UnitOfMeasureID = DPOD.UnitOfMeasureID
	INNER JOIN dbo.cfgCenter DISTCTR
		ON DISTCTR.CenterID = DPO.DistributorCenterID
	INNER JOIN dbo.cfgCenter POCTR
		ON POCTR.CenterID = DPO.CenterID
	INNER JOIN dbo.lkpDistributorPurchaseOrderStatus DPOS
		ON DPO.DistributorPurchaseOrderStatusID = DPOS.DistributorPurchaseOrderStatusID
	WHERE DPO.DistributorPurchaseOrderID = @DPOId

END
GO
