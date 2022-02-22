-- [dbo].[spSvc_GetSerializedInventorySnapshotData]
DECLARE @SerializedInventoryAuditSnapshotID INT ;

SELECT TOP 1
       @SerializedInventoryAuditSnapshotID = [SerializedInventoryAuditSnapshotID]
FROM [dbo].[datSerializedInventoryAuditSnapshot]
ORDER BY [SnapshotDate] DESC ;

SELECT
    [scci].[SalesCodeCenterInventoryID]
  , [scci].[QuantityOnHand]
  , [sc].[SalesCodeDescriptionShort] AS [Item SKU]
  , [sc].[SalesCodeDescription] AS [Item Description]
  , *
FROM [dbo].[datSerializedInventoryAuditSnapshot] AS [s]
LEFT JOIN [dbo].[datSerializedInventoryAuditBatch] AS [b] ON [s].[SerializedInventoryAuditSnapshotID] = [b].[SerializedInventoryAuditSnapshotID]
LEFT JOIN [dbo].[cfgCenter] AS [c] ON [b].[CenterID] = [c].[CenterID]
LEFT JOIN [dbo].[datSerializedInventoryAuditTransaction] AS [t] ON [b].[SerializedInventoryAuditBatchID] = [t].[SerializedInventoryAuditBatchID]
LEFT JOIN [dbo].[cfgSalesCode] AS [sc] ON [t].[SalesCodeID] = [sc].[SalesCodeID]
LEFT JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON( [sc].[SalesCodeID] = [scc].[SalesCodeID] AND [scc].[CenterID] = [b].[CenterID] )
LEFT JOIN [dbo].[datSalesCodeCenterInventory] AS [scci] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
LEFT JOIN [dbo].[datSerializedInventoryAuditTransactionSerialized] AS [ts] ON [t].[SerializedInventoryAuditTransactionID] = [ts].[SerializedInventoryAuditTransactionID]
LEFT JOIN [dbo].[lkpSerializedInventoryStatus] AS [sis] ON [ts].[SerializedInventoryStatusID] = [sis].[SerializedInventoryStatusID]
WHERE [s].[SerializedInventoryAuditSnapshotID] = @SerializedInventoryAuditSnapshotID
  AND [c].[CenterID] = 254
  AND [sc].[SalesCodeDescription] = 'Polyfuse Brushes'
ORDER BY [scci].[QuantityOnHand]
OPTION( RECOMPILE ) ;
GO
-- [dbo].[spSvc_GetNonSerializedInventorySnapshotData]
DECLARE @NonSerializedInventoryAuditSnapshotID INT ;

SELECT TOP 1
       @NonSerializedInventoryAuditSnapshotID = [NonSerializedInventoryAuditSnapshotID]
FROM [dbo].[datNonSerializedInventoryAuditSnapshot]
ORDER BY [SnapshotDate] DESC ;

SELECT
    [scci].[SalesCodeCenterInventoryID]
  , [scci].[QuantityOnHand]
  , [sc].[SalesCodeDescriptionShort] AS [Item SKU]
  , [sc].[SalesCodeDescription] AS [Item Description]
  , *
FROM [dbo].[datNonSerializedInventoryAuditSnapshot] AS [s]
INNER JOIN [dbo].[datNonSerializedInventoryAuditBatch] AS [b] ON [s].[NonSerializedInventoryAuditSnapshotID] = [b].[NonSerializedInventoryAuditSnapshotID]
LEFT JOIN [dbo].[cfgCenter] AS [c] ON [b].[CenterID] = [c].[CenterID]
LEFT JOIN [dbo].[cfgCenterManagementArea] AS [cma] ON [c].[CenterManagementAreaID] = [cma].[CenterManagementAreaID]
LEFT JOIN [dbo].[lkpInventoryAuditBatchStatus] AS [bs] ON [b].[InventoryAuditBatchStatusID] = [bs].[InventoryAuditBatchStatusID]
LEFT JOIN [dbo].[datEmployee] AS [e] ON [b].[CompletedByEmployeeGUID] = [e].[EmployeeGUID]
LEFT JOIN [dbo].[datEmployee] AS [e_rv] ON [b].[ReviewCompletedByEmployeeGUID] = [e_rv].[EmployeeGUID]
INNER JOIN [dbo].[datNonSerializedInventoryAuditTransaction] AS [t] ON [b].[NonSerializedInventoryAuditBatchID] = [t].[NonSerializedInventoryAuditBatchID]
LEFT JOIN [dbo].[cfgSalesCode] AS [sc] ON [t].[SalesCodeID] = [sc].[SalesCodeID]
LEFT JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON( [sc].[SalesCodeID] = [scc].[SalesCodeID] AND [scc].[CenterID] = [b].[CenterID] )
LEFT JOIN [dbo].[datSalesCodeCenterInventory] AS [scci] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
INNER JOIN( SELECT
                [t].[NonSerializedInventoryAuditTransactionID]
              , SUM([ta].[QuantityEntered]) AS [TotalQuantityEntered]
            FROM [dbo].[datNonSerializedInventoryAuditSnapshot] AS [s]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditBatch] AS [b] ON [s].[NonSerializedInventoryAuditSnapshotID] = [b].[NonSerializedInventoryAuditSnapshotID]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditTransaction] AS [t] ON [b].[NonSerializedInventoryAuditBatchID] = [t].[NonSerializedInventoryAuditBatchID]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditTransactionArea] AS [ta] ON [t].[NonSerializedInventoryAuditTransactionID] = [ta].[NonSerializedInventoryAuditTransactionID]
            WHERE [s].[NonSerializedInventoryAuditSnapshotID] = @NonSerializedInventoryAuditSnapshotID
            GROUP BY [t].[NonSerializedInventoryAuditTransactionID] ) AS [ta] ON [t].[NonSerializedInventoryAuditTransactionID] = [ta].[NonSerializedInventoryAuditTransactionID]
WHERE [c].[CenterID] = 254 AND [sc].[SalesCodeDescription] = 'Polyfuse Brushes'
ORDER BY [scci].[QuantityOnHand]
OPTION( RECOMPILE ) ;
GO
-- [dbo].[spSvc_GetSerializedInventorySnapshotData]
DECLARE @SerializedInventoryAuditSnapshotID INT ;

SELECT TOP 1
       @SerializedInventoryAuditSnapshotID = [SerializedInventoryAuditSnapshotID]
FROM [dbo].[datSerializedInventoryAuditSnapshot]
ORDER BY [SnapshotDate] DESC ;

IF OBJECT_ID('[tempdb]..[#SerializedInventoryAudit]') IS NOT NULL
    DROP TABLE [#SerializedInventoryAudit] ;

SELECT
    CONVERT(VARCHAR(11), [s].[SnapshotDate], 101) AS [Snapshot Date]
  , [c].[CenterNumber] AS [CenterID]
  , [c].[CenterDescriptionFullCalc] AS [Center Name]
  , ISNULL([cma].[CenterManagementAreaDescription], 'Corporate') AS [Area]
  , [bs].[InventoryAuditBatchStatusDescription] AS [Center Audit Status]
  , ISNULL(CONVERT(VARCHAR(11), [b].[CompleteDate], 101), '') AS [Completed Date]
  , ISNULL([e].[FirstName], '') + ' ' + ISNULL([e].[LastName], '') AS [Completed By]
  , CASE WHEN [b].[IsReviewCompleted] = 1 THEN 'Yes' ELSE 'No' END AS [Review Completed]
  , CASE WHEN [b].[IsReviewCompleted] = 0 THEN '' ELSE CONVERT(VARCHAR(11), [b].[ReviewCompleteDate], 101)END AS [Review Completed Date]
  , ISNULL([e_rv].[FirstName], '') + ' ' + ISNULL([e_rv].[LastName], '') AS [Reviewed By]
  , CASE WHEN [b].[IsAdjustmentCompleted] = 1 THEN 'Yes' ELSE 'No' END AS [Adjustment Completed]
  , CASE WHEN [b].[IsAdjustmentCompleted] = 0 THEN '' ELSE CONVERT(VARCHAR(11), [b].[LastUpdate], 101)END AS [Adjustment Date]
  , CASE WHEN [t].[IsExcludedFromCorrections] = 1 THEN 'Yes' ELSE 'No' END AS [Excluded From Adjustment]
  , ISNULL([t].[ExclusionReason], '') AS [Exclusion Reason]
  , [sc].[SalesCodeDescriptionShort] AS [Item SKU]
  , [sc].[SalesCodeDescription] AS [Item Description]
  , [scci].[QuantityOnHand] AS [Current Quantity]
  , [t].[QuantityExpected] AS [Expected Quantity]
  , ISNULL([tacount].[TotalQuantityScanned], 0) AS [Entered Quantity]
  , ( ISNULL([tacount].[TotalQuantityScanned], 0) - [t].[QuantityExpected] ) AS [Variance]
  , [scc].[CenterCost] AS [Per Item Cost]
  , ( ISNULL([tacount].[TotalQuantityScanned], 0) - [t].[QuantityExpected] ) * [scc].[CenterCost] AS [Variance Cost]
  , CASE WHEN [ts].[IsScannedEntry] IS NULL THEN 'N/A' WHEN [ts].[IsScannedEntry] = 0 THEN 'Yes' ELSE 'No' END AS [Typed Serialized Entry]
  , [ts].[SerialNumber] AS [Serial Number]
  , [currsis].[SerializedInventoryStatusDescription] AS [Current Status]
  , [sis].[SerializedInventoryStatusDescription] AS [Snapshot Status]
  , CASE WHEN [sis].[IsInTransit] IS NULL THEN 'N/A' WHEN [sis].[IsInTransit] = 1 THEN 'Yes' ELSE 'No' END AS [In Transit]
  , CONVERT(VARCHAR, [adj].[InventoryAdjustmentDate], 1) AS [Status Date]
  , CASE WHEN [sis].[SerializedInventoryStatusDescriptionShort] = 'Xfer' THEN [adj].[FromCenter] ELSE NULL END AS [Transfer From]
  , CASE WHEN [sis].[SerializedInventoryStatusDescriptionShort] = 'Xfer' THEN [adj].[ToCenter] ELSE NULL END AS [Transfer To]
INTO [#SerializedInventoryAudit]
FROM [dbo].[datSerializedInventoryAuditSnapshot] AS [s]
LEFT JOIN [dbo].[datSerializedInventoryAuditBatch] AS [b] ON [s].[SerializedInventoryAuditSnapshotID] = [b].[SerializedInventoryAuditSnapshotID]
LEFT JOIN [dbo].[cfgCenter] AS [c] ON [b].[CenterID] = [c].[CenterID]
LEFT JOIN [dbo].[cfgCenterManagementArea] AS [cma] ON [c].[CenterManagementAreaID] = [cma].[CenterManagementAreaID]
LEFT JOIN [dbo].[lkpInventoryAuditBatchStatus] AS [bs] ON [b].[InventoryAuditBatchStatusID] = [bs].[InventoryAuditBatchStatusID]
LEFT JOIN [dbo].[datEmployee] AS [e] ON [b].[CompletedByEmployeeGUID] = [e].[EmployeeGUID]
LEFT JOIN [dbo].[datEmployee] AS [e_rv] ON [b].[ReviewCompletedByEmployeeGUID] = [e_rv].[EmployeeGUID]
LEFT JOIN [dbo].[datSerializedInventoryAuditTransaction] AS [t] ON [b].[SerializedInventoryAuditBatchID] = [t].[SerializedInventoryAuditBatchID]
LEFT JOIN [dbo].[cfgSalesCode] AS [sc] ON [t].[SalesCodeID] = [sc].[SalesCodeID]
LEFT JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON( [sc].[SalesCodeID] = [scc].[SalesCodeID] AND [scc].[CenterID] = [b].[CenterID] )
LEFT JOIN [dbo].[datSalesCodeCenterInventory] AS [scci] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
LEFT JOIN [dbo].[datSerializedInventoryAuditTransactionSerialized] AS [ts] ON [t].[SerializedInventoryAuditTransactionID] = [ts].[SerializedInventoryAuditTransactionID]
LEFT JOIN [dbo].[lkpSerializedInventoryStatus] AS [sis] ON [ts].[SerializedInventoryStatusID] = [sis].[SerializedInventoryStatusID]
LEFT JOIN [dbo].[lkpInventoryNotScannedReason] AS [insr] ON [ts].[InventoryNotScannedReasonID] = [insr].[InventoryNotScannedReasonID]
LEFT JOIN [dbo].[datEmployee] AS [tse] ON [ts].[ScannedEmployeeGUID] = [tse].[EmployeeGUID]
LEFT JOIN [dbo].[cfgCenter] AS [tsc] ON [ts].[ScannedCenterID] = [tsc].[CenterID]
LEFT JOIN [dbo].[datSalesCodeCenterInventorySerialized] AS [sccis] ON [ts].[SerialNumber] = [sccis].[SerialNumber]
LEFT JOIN [dbo].[lkpSerializedInventoryStatus] AS [currsis] ON [sccis].[SerializedInventoryStatusID] = [currsis].[SerializedInventoryStatusID]
OUTER APPLY( SELECT TOP 1
                    [ia].[InventoryAdjustmentDate]
                  , [ctrfrom].[CenterNumber] AS [FromCenter]
                  , [ctrto].[CenterNumber] AS [ToCenter]
             FROM [dbo].[datInventoryAdjustmentDetailSerialized] AS [iads]
             INNER JOIN [dbo].[datInventoryAdjustmentDetail] AS [iad] ON [iads].[InventoryAdjustmentDetailID] = [iad].[InventoryAdjustmentDetailID]
             INNER JOIN [dbo].[datInventoryAdjustment] AS [ia] ON [iad].[InventoryAdjustmentID] = [ia].[InventoryAdjustmentID]
             LEFT JOIN [dbo].[cfgCenter] AS [ctrfrom] ON [ia].[CenterID] = [ctrfrom].[CenterID]
             LEFT JOIN [dbo].[cfgCenter] AS [ctrto] ON [ia].[TransferToCenterID] = [ctrto].[CenterID]
             WHERE [iads].[SerialNumber] = [sccis].[SerialNumber] AND [ia].[InventoryAdjustmentDate] <= [s].[SnapshotDate]
             ORDER BY [ia].[InventoryAdjustmentDate] DESC ) AS [adj]
LEFT JOIN( SELECT
               [t].[SerializedInventoryAuditTransactionID]
             , COUNT([ts].[ScannedCenterID]) AS [TotalQuantityScanned]
           FROM [dbo].[datSerializedInventoryAuditSnapshot] AS [s]
           LEFT JOIN [dbo].[datSerializedInventoryAuditBatch] AS [b] ON [s].[SerializedInventoryAuditSnapshotID] = [b].[SerializedInventoryAuditSnapshotID]
           LEFT JOIN [dbo].[datSerializedInventoryAuditTransaction] AS [t] ON [b].[SerializedInventoryAuditBatchID] = [t].[SerializedInventoryAuditBatchID]
           LEFT JOIN [dbo].[datSerializedInventoryAuditTransactionSerialized] AS [ts] ON [t].[SerializedInventoryAuditTransactionID] = [ts].[SerializedInventoryAuditTransactionID]
           WHERE [s].[SerializedInventoryAuditSnapshotID] = @SerializedInventoryAuditSnapshotID
             AND [ts].[ScannedCenterID] IS NOT NULL
             AND [ts].[ScannedCenterID] = [b].[CenterID]
           GROUP BY [t].[SerializedInventoryAuditTransactionID] ) AS [tacount] ON [t].[SerializedInventoryAuditTransactionID] = [tacount].[SerializedInventoryAuditTransactionID]
WHERE [s].[SerializedInventoryAuditSnapshotID] = @SerializedInventoryAuditSnapshotID AND [c].[CenterNumber] NOT IN (901, 902, 903, 904) --Exclude Virtual Centers
ORDER BY [c].[CenterNumber]
       , [sc].[SalesCodeDescriptionShort] ;

SELECT *
FROM [#SerializedInventoryAudit]
WHERE [Current Quantity] < 0
ORDER BY [Current Quantity] ASC ;
GO
-- [dbo].[spSvc_GetNonSerializedInventorySnapshotData]
DECLARE @NonSerializedInventoryAuditSnapshotID INT ;

SELECT TOP 1
       @NonSerializedInventoryAuditSnapshotID = [NonSerializedInventoryAuditSnapshotID]
FROM [dbo].[datNonSerializedInventoryAuditSnapshot]
ORDER BY [SnapshotDate] DESC ;

IF OBJECT_ID('[tempdb]..[#NonSerializedInventoryAudit]') IS NOT NULL
    DROP TABLE [#NonSerializedInventoryAudit] ;

SELECT
    CONVERT(VARCHAR(11), [s].[SnapshotDate], 101) AS [Snapshot Date]
  , [c].[CenterNumber] AS [CenterID]
  , [c].[CenterDescription] AS [Center Name]
  , [cma].[CenterManagementAreaDescription] AS [Area]
  , [bs].[InventoryAuditBatchStatusDescription] AS [Center Audit Status]
  , ISNULL(CONVERT(VARCHAR(11), [b].[CompleteDate], 101), '') AS [Completed Date]
  , ISNULL([e].[FirstName], '') + ' ' + ISNULL([e].[LastName], '') AS [Completed By]
  , CASE WHEN [b].[IsReviewCompleted] = 1 THEN 'Yes' ELSE 'No' END AS [Review Completed]
  , CASE WHEN [b].[IsReviewCompleted] = 0 THEN '' ELSE CONVERT(VARCHAR(11), [b].[ReviewCompleteDate], 101)END AS [Review Completed Date]
  , ISNULL([e_rv].[FirstName], '') + ' ' + ISNULL([e_rv].[LastName], '') AS [Reviewed By]
  , CASE WHEN [b].[IsAdjustmentCompleted] = 1 THEN 'Yes' ELSE 'No' END AS [Adjustment Completed]
  , CASE WHEN [b].[IsAdjustmentCompleted] = 0 THEN '' ELSE CONVERT(VARCHAR(11), [b].[LastUpdate], 101)END AS [Adjustment Date]
  , CASE WHEN [t].[IsExcludedFromCorrections] = 1 THEN 'Yes' ELSE 'No' END AS [Excluded From Adjustment]
  , ISNULL([t].[ExclusionReason], '') AS [Exclusion Reason]
  , [sc].[SalesCodeDescriptionShort] AS [Item SKU]
  , [sc].[SalesCodeDescription] AS [Item Description]
  , [scci].[QuantityOnHand] AS [Current Quantity]
  , [t].[QuantityExpected] AS [Snapshot Quantity]
  , ISNULL([ta].[TotalQuantityEntered], 0) AS [Entered Quantity]
  , ( ISNULL([ta].[TotalQuantityEntered], 0) - [t].[QuantityExpected] ) AS [Variance]
  , [scc].[CenterCost] AS [Per Item Cost]
  , ( ISNULL([ta].[TotalQuantityEntered], 0) - [t].[QuantityExpected] ) * [scc].[CenterCost] AS [Variance Cost]
INTO [#NonSerializedInventoryAudit]
FROM [dbo].[datNonSerializedInventoryAuditSnapshot] AS [s]
INNER JOIN [dbo].[datNonSerializedInventoryAuditBatch] AS [b] ON [s].[NonSerializedInventoryAuditSnapshotID] = [b].[NonSerializedInventoryAuditSnapshotID]
LEFT JOIN [dbo].[cfgCenter] AS [c] ON [b].[CenterID] = [c].[CenterID]
LEFT JOIN [dbo].[cfgCenterManagementArea] AS [cma] ON [c].[CenterManagementAreaID] = [cma].[CenterManagementAreaID]
LEFT JOIN [dbo].[lkpInventoryAuditBatchStatus] AS [bs] ON [b].[InventoryAuditBatchStatusID] = [bs].[InventoryAuditBatchStatusID]
LEFT JOIN [dbo].[datEmployee] AS [e] ON [b].[CompletedByEmployeeGUID] = [e].[EmployeeGUID]
LEFT JOIN [dbo].[datEmployee] AS [e_rv] ON [b].[ReviewCompletedByEmployeeGUID] = [e_rv].[EmployeeGUID]
INNER JOIN [dbo].[datNonSerializedInventoryAuditTransaction] AS [t] ON [b].[NonSerializedInventoryAuditBatchID] = [t].[NonSerializedInventoryAuditBatchID]
LEFT JOIN [dbo].[cfgSalesCode] AS [sc] ON [t].[SalesCodeID] = [sc].[SalesCodeID]
LEFT JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON( [sc].[SalesCodeID] = [scc].[SalesCodeID] AND [scc].[CenterID] = [b].[CenterID] )
LEFT JOIN [dbo].[datSalesCodeCenterInventory] AS [scci] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
INNER JOIN( SELECT
                [t].[NonSerializedInventoryAuditTransactionID]
              , SUM([ta].[QuantityEntered]) AS [TotalQuantityEntered]
            FROM [dbo].[datNonSerializedInventoryAuditSnapshot] AS [s]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditBatch] AS [b] ON [s].[NonSerializedInventoryAuditSnapshotID] = [b].[NonSerializedInventoryAuditSnapshotID]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditTransaction] AS [t] ON [b].[NonSerializedInventoryAuditBatchID] = [t].[NonSerializedInventoryAuditBatchID]
            LEFT JOIN [dbo].[datNonSerializedInventoryAuditTransactionArea] AS [ta] ON [t].[NonSerializedInventoryAuditTransactionID] = [ta].[NonSerializedInventoryAuditTransactionID]
            WHERE [s].[NonSerializedInventoryAuditSnapshotID] = @NonSerializedInventoryAuditSnapshotID
            GROUP BY [t].[NonSerializedInventoryAuditTransactionID] ) AS [ta] ON [t].[NonSerializedInventoryAuditTransactionID] = [ta].[NonSerializedInventoryAuditTransactionID]
WHERE [s].[NonSerializedInventoryAuditSnapshotID] = @NonSerializedInventoryAuditSnapshotID AND [c].[CenterNumber] NOT IN (901, 902, 903, 904) --Exclude Virtual Centers
ORDER BY [c].[CenterNumber]
       , [sc].[SalesCodeDescriptionShort] ;

SELECT *
FROM [#NonSerializedInventoryAudit]
WHERE [Current Quantity] < 0
ORDER BY [Current Quantity] ASC ;
GO
