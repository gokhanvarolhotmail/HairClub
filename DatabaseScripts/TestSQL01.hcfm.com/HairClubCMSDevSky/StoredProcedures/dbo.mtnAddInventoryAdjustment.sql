/* CreateDate: 07/10/2020 14:09:17.583 , ModifyDate: 07/10/2020 14:09:17.583 */
GO
/***********************************************************************
PROCEDURE:				mtnAddInventoryAdjustment
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/9/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC mtnAddInventoryAdjustment 0, 1618, NULL
EXEC mtnAddInventoryAdjustment 0, 0, NULL
EXEC mtnAddInventoryAdjustment 201, 0, 1
EXEC mtnAddInventoryAdjustment 201, 1618, 1
***********************************************************************/
CREATE PROCEDURE mtnAddInventoryAdjustment
(
	@CenterID INT,
	@SalesCodeID INT,
	@QuantityAdjustment INT = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(10)
,	Area NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
,	SalesCodeID INT
,	QuantityAdjustment INT
)


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ctr.CenterNumber
		,       ctr.CenterDescription
		,       ct.CenterTypeDescriptionShort AS 'CenterType'
		,		ISNULL(cma.CenterManagementAreaDescription, '') AS 'Area'
		,       ISNULL(ctr.Address1, '') AS 'Address1'
		,       ISNULL(ctr.Address2, '') AS 'Address2'
		,       ISNULL(ctr.City, '') AS 'City'
		,       ISNULL(ls.StateDescriptionShort, '') AS 'StateCode'
		,       ISNULL(ctr.PostalCode, '') AS 'ZipCode'
		,       ISNULL(lc.CountryDescription, '') AS 'Country'
		,       ISNULL(ctr.Phone1, '561-361-7600') AS 'PhoneNumber'
		,		tia.SalesCodeID
		,		CASE WHEN ISNULL(@QuantityAdjustment, 0) = 0 THEN tia.DefaultQuantityAdjustment ELSE @QuantityAdjustment END
		FROM    cfgCenter ctr WITH ( NOLOCK )
				INNER JOIN tmpInventoryAdjustment tia
					ON tia.CenterNumber = ctr.CenterNumber
				INNER JOIN lkpCenterType ct WITH ( NOLOCK )
					ON ct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN lkpState ls WITH ( NOLOCK )
					ON ls.StateID = ctr.StateID
				INNER JOIN lkpCountry lc WITH ( NOLOCK )
					ON lc.CountryID = ctr.CountryID
				LEFT OUTER JOIN lkpRegion lr WITH ( NOLOCK )
					ON lr.RegionID = ctr.RegionID
				LEFT OUTER JOIN cfgConfigurationCenter ccc WITH ( NOLOCK )
					ON ccc.CenterID = ctr.CenterID
				LEFT OUTER JOIN cfgCenterManagementArea cma WITH ( NOLOCK )
					ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
		WHERE   ctr.CenterID LIKE CASE WHEN @CenterID = 0 THEN '%' ELSE CONVERT(VARCHAR, @CenterID) + '%' END
				AND tia.SalesCodeID LIKE CASE WHEN @SalesCodeID = 0 THEN '%' ELSE CONVERT(VARCHAR, @SalesCodeID) + '%' END
				AND ctr.IsActiveFlag = 1


/********************************** Insert Inventory Adjustment Header Records *************************************/
INSERT INTO datInventoryAdjustment (
	CenterID
,	TransferToCenterID
,	TransferFromCenterID
,	DistributorPurchaseOrderID
,	InventoryAdjustmentTypeID
,	InventoryAdjustmentDate
,	Note
,	EmployeeGUID
,	SalesOrderGUID
,	CreateDate
,	CreateUser
,	LastUpdate
,	LastUpdateUser
,	SerializedInventoryAuditBatchID
,	NonSerializedInventoryAuditBatchID
)
SELECT	c.CenterID
,		NULL AS 'TransferToCenterID'
,		NULL AS 'TransferFromCenterID'
,		NULL AS 'DistributorPurchaseOrderID'
,		11 AS 'InventoryAdjustmentTypeID'
,		GETUTCDATE() AS 'InventoryAdjustmentDate'
,		'Correction Add for ' + sc.SalesCodeDescription AS 'Note'
,		'9EA3F325-9863-4BE6-9833-5717D2481ACB' AS 'EmployeeGUID'
,		NULL AS 'SalesOrderGUID'
,		GETUTCDATE()
,		'sa-InvAdj' AS 'CreateUser'
,		GETUTCDATE()
,		'sa-InvAdj' AS 'LastUpdateUser'
,		NULL AS 'SerializedInventoryAuditBatchID'
,		NULL AS 'NonSerializedInventoryAuditBatchID'
FROM	#Center c
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = c.SalesCodeID


/********************************** Insert Inventory Adjustment Detail Records *************************************/
INSERT INTO datInventoryAdjustmentDetail (
	InventoryAdjustmentID
,	DistributorPurchaseOrderDetailID
,	SalesOrderDetailGUID
,	SalesCodeID
,	QuantityAdjustment
,	CreateDate
,	CreateUser
,	LastUpdate
,	LastUpdateUser
,	SerializedInventoryAuditTransactionID
,	NonSerializedInventoryAuditTransactionID
)
SELECT	ia.InventoryAdjustmentID
,		NULL AS 'DistributorPurchaseOrderDetailID'
,		NULL AS 'SalesOrderDetailGUID'
,		c.SalesCodeID
,		c.QuantityAdjustment
,		GETUTCDATE()
,		'sa-InvAdj' AS 'CreateUser'
,		GETUTCDATE()
,		'sa-InvAdj' AS 'LastUpdateUser'
,		NULL AS 'SerializedInventoryAuditBatchID'
,		NULL AS 'NonSerializedInventoryAuditBatchID'
FROM	datInventoryAdjustment ia
		INNER JOIN #Center c
			ON c.CenterID = ia.CenterID
		LEFT OUTER JOIN datInventoryAdjustmentDetail iad
			ON iad.InventoryAdjustmentID = ia.InventoryAdjustmentID
WHERE	ia.InventoryAdjustmentTypeID = 11 --Correction - Add
		AND ia.CreateUser = 'sa-InvAdj'
		AND iad.InventoryAdjustmentDetailID IS NULL

END
GO
