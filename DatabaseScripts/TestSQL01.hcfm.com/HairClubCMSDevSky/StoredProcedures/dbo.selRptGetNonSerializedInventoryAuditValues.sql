/* CreateDate: 06/18/2021 12:57:39.803 , ModifyDate: 06/22/2021 10:36:43.210 */
GO
-- =============================================
-- Author:		rrojas
-- Create date:
-- Description:	Get non serialized inventory audit values
-- =============================================
CREATE procedure selRptGetNonSerializedInventoryAuditValues
	-- Add the parameters for the stored procedure here
	@centerId nvarchar(max),
	@snapshotDate nvarchar(max)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
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
			,t.UpdateStamp,
			b.CenterId,
			cen.CenterDescription,
			nsias.SnapshotDate
	FROM	datNonSerializedInventoryAuditBatch b
				left join datNonSerializedInventoryAuditTransaction t on b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
				left join cfgSalesCode sc on (t.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
				left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID and scc.IsActiveFlag = 1)
				left join datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
				left join @InventoryQuantityEntered qe on t.NonSerializedInventoryAuditTransactionID = qe.NonSerializedInventoryAuditTransactionID
													   and t.SalesCodeID = qe.SalesCodeID
													   inner join cfgCenter cen on b.CenterId=cen.CenterId
		        inner join datNonSerializedInventoryAuditSnapshot nsias on nsias.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
	WHERE
		 sc.IsSerialized = 0
		and COALESCE(qe.QuantityEntered, 0) <> t.QuantityExpected
		AND convert(date,nsias.SnapshotDate)=convert(date, @snapshotDate)
		and b.CenterID in (select value from string_split(@centerId, ',')  where rtrim(value) <> '')
	ORDER BY b.CenterId,sc.SalesCodeDescriptionShort

END
GO
