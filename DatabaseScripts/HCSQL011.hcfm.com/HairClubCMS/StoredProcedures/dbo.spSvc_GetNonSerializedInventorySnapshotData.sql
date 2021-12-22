/* CreateDate: 05/28/2020 09:51:47.600 , ModifyDate: 03/09/2021 12:02:40.047 */
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
CREATE PROCEDURE [dbo].[spSvc_GetNonSerializedInventorySnapshotData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @NonSerializedInventoryAuditSnapshotID INT


SELECT TOP 1 @NonSerializedInventoryAuditSnapshotID = NonSerializedInventoryAuditSnapshotID FROM HairClubCMS.dbo.datNonSerializedInventoryAuditSnapshot ORDER BY SnapshotDate DESC


SELECT	CONVERT(VARCHAR(11), s.SnapshotDate, 101) AS 'Snapshot Date'
,		c.CenterNumber AS 'CenterID'
,		c.CenterDescription AS 'Center Name'
,		cma.CenterManagementAreaDescription AS 'Area'
,		bs.InventoryAuditBatchStatusDescription AS 'Center Audit Status'
,		ISNULL(CONVERT(VARCHAR(11), b.CompleteDate, 101), '') AS 'Completed Date'
,		ISNULL(e.FirstName, '') + ' ' + ISNULL(e.LastName, '') AS 'Completed By'
,		CASE WHEN b.IsReviewCompleted = 1 THEN 'Yes' ELSE 'No' END AS 'Review Completed'
,		CASE WHEN b.IsReviewCompleted = 0 THEN '' ELSE CONVERT(VARCHAR(11), b.ReviewCompleteDate, 101) END AS 'Review Completed Date'
,		ISNULL(e_rv.FirstName, '') + ' ' + ISNULL(e_rv.LastName, '') AS 'Reviewed By'
,		CASE WHEN b.IsAdjustmentCompleted = 1 THEN 'Yes' ELSE 'No' END AS 'Adjustment Completed'
,		CASE WHEN b.IsAdjustmentCompleted = 0 THEN '' ELSE CONVERT(VARCHAR(11), b.LastUpdate, 101) END AS 'Adjustment Date'
,		CASE WHEN t.IsExcludedFromCorrections = 1 THEN 'Yes' ELSE 'No' END AS 'Excluded From Adjustment'
,		ISNULL(t.ExclusionReason, '') AS 'Exclusion Reason'
,		sc.SalesCodeDescriptionShort AS 'Item SKU'
,		sc.SalesCodeDescription AS 'Item Description'
,		scci.QuantityOnHand AS 'Current Quantity'
,		t.QuantityExpected AS 'Snapshot Quantity'
,		ISNULL(ta.TotalQuantityEntered, 0) AS 'Entered Quantity'
,		(ISNULL(ta.TotalQuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
,		scc.CenterCost AS 'Per Item Cost'
,		(ISNULL(ta.TotalQuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'Variance Cost'
FROM	HairClubCMS.dbo.datNonSerializedInventoryAuditSnapshot s
		INNER JOIN HairClubCMS.dbo.datNonSerializedInventoryAuditBatch b
			ON s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
		LEFT JOIN HairClubCMS.dbo.cfgCenter c
			ON b.CenterID = c.CenterID
		LEFT JOIN HairClubCMS.dbo.cfgCenterManagementArea cma
			ON c.CenterManagementAreaID = cma.CenterManagementAreaID
		LEFT JOIN HairClubCMS.dbo.lkpInventoryAuditBatchStatus bs
			ON b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
		LEFT JOIN HairClubCMS.dbo.datEmployee e
			ON b.CompletedByEmployeeGUID = e.EmployeeGUID
		LEFT JOIN HairClubCMS.dbo.datEmployee e_rv
			ON b.ReviewCompletedByEmployeeGUID = e_rv.EmployeeGUID
		INNER JOIN HairClubCMS.dbo.datNonSerializedInventoryAuditTransaction t
			ON b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
		LEFT JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON t.SalesCodeID = sc.SalesCodeID
		LEFT JOIN HairClubCMS.dbo.cfgSalesCodeCenter scc
			ON (sc.SalesCodeID = scc.SalesCodeID AND scc.CenterID = b.CenterID)
		LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventory scci
			ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
		INNER JOIN (
				SELECT	t.NonSerializedInventoryAuditTransactionID
				,		SUM(ta.QuantityEntered) AS TotalQuantityEntered
				FROM	HairClubCMS.dbo.datNonSerializedInventoryAuditSnapshot s
						LEFT JOIN HairClubCMS.dbo.datNonSerializedInventoryAuditBatch b
							ON s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
						LEFT JOIN HairClubCMS.dbo.datNonSerializedInventoryAuditTransaction t
							ON b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
						LEFT JOIN HairClubCMS.dbo.datNonSerializedInventoryAuditTransactionArea ta
							ON t.NonSerializedInventoryAuditTransactionID = ta.NonSerializedInventoryAuditTransactionID
				WHERE	s.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID
				GROUP BY t.NonSerializedInventoryAuditTransactionID
				) ta
			ON t.NonSerializedInventoryAuditTransactionID = ta.NonSerializedInventoryAuditTransactionID
WHERE	s.NonSerializedInventoryAuditSnapshotID = @NonSerializedInventoryAuditSnapshotID
		AND c.CenterNumber NOT IN ( 901, 902, 903, 904 ) --Exclude Virtual Centers
ORDER BY c.CenterNumber
,		sc.SalesCodeDescriptionShort

END
GO
