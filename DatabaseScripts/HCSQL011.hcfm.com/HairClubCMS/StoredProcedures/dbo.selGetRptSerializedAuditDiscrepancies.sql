/* CreateDate: 06/18/2021 12:56:25.197 , ModifyDate: 08/19/2021 23:19:12.483 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        rrojas
-- Create date: 22/06/2021
-- Description:    <Description,,>
-- =============================================
CREATE procedure selGetRptSerializedAuditDiscrepancies
    -- Add the parameters for the stored procedure here
        @centerId nvarchar(max),
        @snapshotDate nvarchar(max)
    as
 begin
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
        SELECT
        DISTINCT
            "CenterID" =CASE WHEN t1.CenterID IS NULL THEN t2.CenterID ELSE t1.CenterID END,
            "CenterDescription" =CASE WHEN t1.CenterDescription IS NULL THEN t2.CenterDescription ELSE t1.CenterDescription END,
            "ItemSKU" = CASE WHEN t2.ItemSKU IS NULL THEN '' ELSE t2.ItemSKU END,
            "ItemDescription"=CASE WHEN t2.salesCodeDescription IS NULL THEN '' ELSE t2.salesCodeDescription END,
            "EntryResult" =CASE WHEN t2.CenterID IS NULL THEN 'Missing' WHEN t1.CenterID = t2.CenterID THEN 'No Issue' ELSE 'Device Added' END,
            "SerialNumber"=CASE WHEN t1.SerialNumber IS NULL THEN t2.SerialNumber ELSE t1.SerialNumber END,
            "SnapshotStatus"=CASE WHEN t1.SnapshotStatus IS NULL THEN t2.SnapshotStatus ELSE t1.SnapshotStatus END
            FROM
            (SELECT
                cen.CenterID,
                cen.CenterDescription,
                sc.SalesCodeDescriptionShort as 'ItemSKU',
                sc.SalesCodeDescription,
                auditSnapshot.SerializedInventoryAuditSnapshotID,
                srAuditTr.SerialNumber,
                sc.SalesCodeID,
                sInvStatus.SerializedInventoryStatusDescription as 'SnapshotStatus'
            from datSerializedInventoryAuditBatch inventoryBatch
            join datSerializedInventoryAuditSnapshot auditSnapshot on auditSnapshot.SerializedInventoryAuditSnapshotID = inventoryBatch.SerializedInventoryAuditSnapshotID
            join datSerializedInventoryAuditTransactionSerialized srAuditTr ON srAuditTr.ScannedSerializedInventoryAuditBatchID = inventoryBatch.SerializedInventoryAuditBatchID
            join datSerializedInventoryAuditTransaction auditTransaction on inventoryBatch.SerializedInventoryAuditBatchID = auditTransaction.SerializedInventoryAuditBatchID
            join cfgSalesCode sc on (auditTransaction.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
            join cfgCenter cen ON cen.CenterID = inventoryBatch.CenterID
            join lkpSerializedInventoryStatus sInvStatus ON sInvStatus.SerializedInventoryStatusID = srAuditTr.SerializedInventoryStatusID
            WHERE convert(date, auditSnapshot.SnapshotDate) = convert(date, @snapshotDate)
            AND cen.CenterID IN (select value from string_split(@centerId, ',')  where rtrim(value) <> '')) AS t1
            FULL OUTER JOIN (select
            sci.SerialNumber,
            sc.SalesCodeID,
            sc.SalesCodeDescriptionShort AS 'ItemSKU',
            sc.SalesCodeDescription,
            c.CenterId,
            c.CenterDescription,
            sct.SalesCodeTypeDescription,
            invStatus.SerializedInventoryStatusID,
            invStatus.SerializedInventoryStatusDescription AS 'SnapshotStatus'
            from cfgSalesCodeCenter scc
            inner join cfgSalesCode sc on sc.SalesCodeID = scc.SalesCodeID
            inner join cfgCenter c on c.centerid = scc.centerid
            inner join lkpSalesCodeType sct on sct.SalesCodeTypeID = sc.SalesCodeTypeID
            inner join datSalesCodeCenterInventory scin ON scc.SalesCodeCenterID = scin.SalesCodeCenterID
            inner join datSalesCodeCenterInventorySerialized sci ON sci.SalesCodeCenterInventoryID = scin.SalesCodeCenterInventoryID
            inner join lkpSerializedInventoryStatus invStatus ON invStatus.SerializedInventoryStatusID = sci.SerializedInventoryStatusID
            where scc.centerId IN (select value from string_split(@centerId, ',') where rtrim(value) <> '')) AS t2 ON t1.SerialNumber = t2.SerialNumber
            --AND t1.SalesCodeID = t2.SalesCodeID
    set nocount on;
 end
GO
