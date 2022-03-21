USE [HairClubCMS] ;
GO
DROP TABLE IF EXISTS [tempdb].[dbo].[GetNonSerializedInventorySnapshotData] ;

CREATE TABLE [tempdb].[dbo].[GetNonSerializedInventorySnapshotData]
(
    [Snapshot Date]            VARCHAR(11)   NULL
  , [CenterID]                 INT           NULL
  , [Center Name]              NVARCHAR(50)  NULL
  , [Area]                     NVARCHAR(100) NULL
  , [Center Audit Status]      NVARCHAR(100) NULL
  , [Completed Date]           VARCHAR(11)   NOT NULL
  , [Completed By]             NVARCHAR(101) NOT NULL
  , [Review Completed]         VARCHAR(3)    NOT NULL
  , [Review Completed Date]    VARCHAR(11)   NULL
  , [Reviewed By]              NVARCHAR(101) NOT NULL
  , [Adjustment Completed]     VARCHAR(3)    NOT NULL
  , [Adjustment Date]          VARCHAR(11)   NULL
  , [Excluded From Adjustment] VARCHAR(3)    NOT NULL
  , [Exclusion Reason]         NVARCHAR(200) NOT NULL
  , [Item SKU]                 NVARCHAR(15)  NULL
  , [Item Description]         NVARCHAR(50)  NULL
  , [Current Quantity]         INT           NULL
  , [Snapshot Quantity]        INT           NOT NULL
  , [Entered Quantity]         INT           NOT NULL
  , [Variance]                 INT           NULL
  , [Per Item Cost]            MONEY         NULL
  , [Variance Cost]            MONEY         NULL
) ;
GO
/***********************************************************************
PROCEDURE:				spSvc_GetNonSerializedInventorySnapshotData
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

EXEC spSvc_GetNonSerializedInventorySnapshotData
***********************************************************************/

CREATE PROCEDURE [dbo].[spSvc_GetNonSerializedInventorySnapshotData_V2]
AS
DECLARE @NonSerializedInventoryAuditSnapshotID INT ;

SELECT TOP 1
       @NonSerializedInventoryAuditSnapshotID = [NonSerializedInventoryAuditSnapshotID]
FROM [dbo].[datNonSerializedInventoryAuditSnapshot]
ORDER BY [SnapshotDate] DESC ;

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
       , [sc].[SalesCodeDescriptionShort]
OPTION( RECOMPILE ) ;
GO
INSERT [tempdb].[dbo].[GetNonSerializedInventorySnapshotData]
EXEC [dbo].[spSvc_GetNonSerializedInventorySnapshotData_V2] ;

CREATE CLUSTERED INDEX XXX ON [tempdb].[dbo].[GetNonSerializedInventorySnapshotData]([CenterID],[Item SKU])

SELECT
    [Snapshot Date]
  , [CenterID]
  , [Center Name]
  , [Area]
  , [Center Audit Status]
  , [Completed Date]
  , [Completed By]
  , [Review Completed]
  , [Review Completed Date]
  , [Reviewed By]
  , [Adjustment Completed]
  , [Adjustment Date]
  , [Excluded From Adjustment]
  , [Exclusion Reason]
  , [Item SKU]
  , [Item Description]
  , [Current Quantity]
  , [Snapshot Quantity]
  , [Entered Quantity]
  , [Variance]
  , [Per Item Cost]
  , [Variance Cost]
FROM [tempdb].[dbo].[GetNonSerializedInventorySnapshotData]
ORDER BY [CenterID]
       , [Item SKU] ;
GO
