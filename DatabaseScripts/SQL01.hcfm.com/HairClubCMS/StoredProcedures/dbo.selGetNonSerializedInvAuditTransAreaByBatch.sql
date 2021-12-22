/* CreateDate: 07/09/2021 07:27:33.017 , ModifyDate: 07/09/2021 07:27:33.017 */
GO
-- =============================================
-- Author:		rrojas
-- Create date:
-- Description:	Get non serialized inv audit transaction area By Batch
-- =============================================
create procedure selGetNonSerializedInvAuditTransAreaByBatch
		@batchId int,
		@areaId nvarchar(max)
as
begin
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set nocount on;
	-- Insert statements for procedure here
	select
		nSiAtA.NonSerializedInventoryAuditTransactionAreaID AS NonSerializedInventoryAuditTransactionAreaID,
		nSiAtA.NonSerializedInventoryAuditTransactionID AS NonSerializedInventoryAuditTransactionID,
		nSiAt.NonSerializedInventoryAuditBatchID AS NonSerializedInventoryAuditBatchID,
		nSiAtA.InventoryAreaID AS InventoryAreaID,
		ia.InventoryAreaDescription AS InventoryAreaDescription,
		ia.InventoryAreaDescriptionShort AS InventoryAreaDescriptionShort,
		sc.SalesCodeDescription AS SalesCodeDescription,
		sc.SalesCodeDescriptionShort AS SalesCodeDescriptionShort,
		scd.SalesCodeDepartmentDescription AS SalesCodeDepartmentDescription,
		sc.Size as Size,
		case when (sc.QuantityPerPack IS NULL) then 1 else sc.QuantityPerPack end as quantityPerPack,
		lkpUoM.UnitOfMeasureDescription AS UnitOfMeasureDescription,
		nSiAtA.QuantityEntered AS QuantityEntered,
		sc.PackSKU AS PackSKU,
		sc.BrandID AS BrandID,
		br.BrandDescription AS BrandDescription
    from       dbo.datNonSerializedInventoryAuditTransactionArea AS nSiAtA
    inner join dbo.datNonSerializedInventoryAuditTransaction AS nSiAt ON nSiAtA.NonSerializedInventoryAuditTransactionID = nSiAt.NonSerializedInventoryAuditTransactionID
    inner join dbo.lkpInventoryArea AS ia ON nSiAtA.InventoryAreaID = ia.InventoryAreaID
    inner join dbo.cfgSalesCode AS sc ON nSiAt.SalesCodeID = sc.SalesCodeID
    left outer join dbo.lkpSalesCodeDepartment AS scd ON sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
    left outer join dbo.lkpUnitOfMeasure AS lkpUoM ON sc.PackUnitOfMeasureID = lkpUoM.UnitOfMeasureID
    left outer join dbo.lkpBrand AS br ON sc.BrandID = br.BrandID
    where (nSiAt.NonSerializedInventoryAuditBatchID = @batchId) AND ((ia.InventoryAreaDescriptionShort = @areaId)) and (br.BrandDescriptionShort not in ( 'ItIs10', 'GrandeLash', 'Matrix'))
	order by  scd.SalesCodeDepartmentDescription, sc.SalesCodeDescription
	end
GO
