/* CreateDate: 12/07/2020 16:29:30.200 , ModifyDate: 12/07/2020 16:29:30.200 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSvc_GetNonSerializedInventorySnapshotData_Daily]
AS

BEGIN

DECLARE @NonSerializedInventoryAuditSnapshotID INT

SELECT TOP 1 @NonSerializedInventoryAuditSnapshotID = NonSerializedInventoryAuditSnapshotID
FROM [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditSnapshot]
ORDER BY SnapshotDate DESC

INSERT INTO [dbo].[NonserializedInventorySnapshot]
SELECT	CONVERT(VARCHAR, s.SnapshotDate, 22) AS 'Snapshot Date'
,		c.CenterNumber AS 'CenterID'
,		c.CenterDescription AS 'Center Name'
,		cma.CenterManagementAreaDescription AS 'Area'
,		bs.InventoryAuditBatchStatusDescription AS 'Center Audit Status'
,		sc.SalesCodeDescriptionShort AS 'Item SKU'
,		sc.SalesCodeDescription AS 'Item Description'
,		scci.QuantityOnHand AS 'Current Quantity'
,		t.QuantityExpected AS 'Snapshot Quantity'
,		ISNULL(ta.TotalQuantityEntered, 0) AS 'Entered Quantity'
,		(ISNULL(ta.TotalQuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
,		scc.CenterCost AS 'Per Item Cost'
,		(ISNULL(ta.TotalQuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'Variance Cost'
FROM	[HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditSnapshot] s
		INNER JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditBatch] b
			ON s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgCenter] c                      -- LINKED
			ON b.CenterID = c.CenterID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgCenterManagementArea] cma      -- LINKED
			ON c.CenterManagementAreaID = cma.CenterManagementAreaID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[lkpInventoryAuditBatchStatus] bs  -- LINKED
			ON b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[datEmployee] e                    -- LINKED
			ON b.CompletedByEmployeeGUID = e.EmployeeGUID
		INNER JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransaction] t
			ON b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgSalesCode] sc
			ON t.SalesCodeID = sc.SalesCodeID
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgSalesCodeCenter] scc           -- LINKED
			ON (sc.SalesCodeID = scc.SalesCodeID AND scc.CenterID = b.CenterID)
		LEFT JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[datSalesCodeCenterInventory] scci -- LINKED
			ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
		INNER JOIN (
				SELECT	t.NonSerializedInventoryAuditTransactionID
				,		SUM(ta.QuantityEntered) AS TotalQuantityEntered
				FROM	[HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditSnapshot] s
						LEFT JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditBatch] b
							ON s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
						LEFT JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransaction] t
							ON b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
						LEFT JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransactionArea] ta
							ON t.NonSerializedInventoryAuditTransactionID = ta.NonSerializedInventoryAuditTransactionID
				WHERE	s.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID
				GROUP BY t.NonSerializedInventoryAuditTransactionID
				) ta
			ON t.NonSerializedInventoryAuditTransactionID = ta.NonSerializedInventoryAuditTransactionID
WHERE
s.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID AND
c.CenterNumber NOT IN ( 901, 902, 903, 904 )
ORDER BY c.CenterNumber
,		sc.SalesCodeDescriptionShort

END
GO
