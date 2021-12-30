/* CreateDate: 12/19/2018 08:03:27.960 , ModifyDate: 09/23/2019 12:32:47.897 */
GO
/***********************************************************************

PROCEDURE:				selInventoryAuditBatchProductVariances

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		12/06/2018

LAST REVISION DATE: 	06/27/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Return the Inventory Audit Batch's Product Variances

		* 11/17/2018	SAL	Created (TFS #11697)
		* 01/03/2019	SAL Modified to return Size (TFS #11763)
		* 06/27/2019	JLM Update to use non serialized inventory table (TFS #12660)
		* 09/09/2019	SAL	Updated to consider the scc.IsActiveFlag on joins (TFS #13001)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selInventoryAuditBatchProductVariances 239

***********************************************************************/

CREATE PROCEDURE [dbo].[selInventoryAuditBatchProductVariances]
	@InventoryAuditBatchID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	DECLARE @InventoryQuantityEntered TABLE
	(
		NonSerializedInventoryAuditTransactionID INT,
		SalesCodeID INT,
		QuantityEntered INT
	)

	INSERT INTO @InventoryQuantityEntered
	(
		NonSerializedInventoryAuditTransactionID,
		SalesCodeID,
		QuantityEntered
	)
	SELECT t.NonSerializedInventoryAuditTransactionID,
		   t.SalesCodeID,
		   SUM(area.QuantityEntered)
	FROM datNonSerializedInventoryAuditTransactionArea area
	INNER JOIN datNonSerializedInventoryAuditTransaction t ON area.NonSerializedInventoryAuditTransactionID = t.NonSerializedInventoryAuditTransactionID
	WHERE t.NonSerializedInventoryAuditBatchID = @InventoryAuditBatchID
	GROUP BY t.NonSerializedInventoryAuditTransactionID, t.SalesCodeID

	SELECT	t.NonSerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
			,sc.SalesCodeDescriptionShort
			,sc.SalesCodeDescription
			,scci.QuantityOnHand
			,t.QuantityExpected
			,COALESCE(qe.QuantityEntered, 0) AS 'QuantityEntered'
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
			,scc.CenterCost
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'VarianceCost'
			,t.IsExcludedFromCorrections AS 'TransactionIsExcluded'
			,t.ExclusionReason AS 'TransactionExclusionReason'
			,sc.Size
			,t.UpdateStamp
	FROM	datNonSerializedInventoryAuditBatch b
				left join datNonSerializedInventoryAuditTransaction t on b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
					left join cfgSalesCode sc on (t.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
					left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID and scc.IsActiveFlag = 1)
					left join datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
				left join @InventoryQuantityEntered qe on t.NonSerializedInventoryAuditTransactionID = qe.NonSerializedInventoryAuditTransactionID
													   and t.SalesCodeID = qe.SalesCodeID
	WHERE	b.NonSerializedInventoryAuditBatchID = @InventoryAuditBatchID
		and sc.IsSerialized = 0
		and COALESCE(qe.QuantityEntered, 0) <> t.QuantityExpected
	ORDER BY sc.SalesCodeDescriptionShort

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
GO
