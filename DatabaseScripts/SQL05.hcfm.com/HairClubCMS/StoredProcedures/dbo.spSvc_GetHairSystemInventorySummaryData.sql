/* CreateDate: 03/26/2021 09:54:55.093 , ModifyDate: 03/26/2021 09:54:55.093 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetHairSystemInventorySummaryData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/26/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetHairSystemInventorySummaryData
***********************************************************************/
CREATE PROCEDURE spSvc_GetHairSystemInventorySummaryData
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE	@CurrentDate DATETIME


SET @CurrentDate = GETDATE()


CREATE TABLE #HairSystemInventoryBatch (
	HairSystemInventoryBatchID INT IDENTITY(1,1)
,	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(103)
)

CREATE TABLE #HairSystemInventoryTransaction (
	HairSystemTransactionID INT IDENTITY(1,1)
,	HairSystemInventoryBatchID INT
,	HairSystemOrderGUID UNIQUEIDENTIFIER
,	HairSystemOrderNumber NVARCHAR(50)
,	HairSystemOrderStatusID INT
,	IsInTransit BIT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	ClientHomeCenterID INT
)


INSERT	INTO #HairSystemInventoryBatch
		SELECT	c.CenterID
		,		c.CenterNumber
		,		c.CenterDescriptionFullCalc AS 'CenterName'
		FROM	cfgCenter c
				INNER JOIN cfgConfigurationCenter cc
					ON cc.CenterID = c.CenterID
				INNER JOIN lkpCenterBusinessType bt
					ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		WHERE	c.IsActiveFlag = 1
				AND bt.CenterBusinessTypeDescriptionShort IN ( 'cONEctCorp', 'cONEctHQ', 'HW', 'AEU' )
				AND c.CenterNumber NOT IN ( 901, 902, 903, 904, 103 ) -- Exclude Virtual Centers
		ORDER BY c.CenterID


INSERT	INTO #HairSystemInventoryTransaction
		SELECT	batch.HairSystemInventoryBatchID
		,		hso.HairSystemOrderGUID
		,		hso.HairSystemOrderNumber
		,		hso.HairSystemOrderStatusID
		,		hstat.IsInTransitFlag AS 'IsInTransit'
		,		hso.ClientGUID
		,		hso.ClientMembershipGUID
		,		c.ClientIdentifier
		,		c.CenterID
		FROM	datHairSystemOrder hso
				INNER JOIN #HairSystemInventoryBatch batch
					ON batch.CenterID = hso.CenterID
				INNER JOIN datClient c
					ON c.ClientGUID = hso.ClientGUID
				INNER JOIN lkpHairSystemOrderStatus hstat
					ON hstat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		WHERE	hstat.IncludeInInventorySnapshotFlag = 1
				AND hso.DueDate <= CONVERT(DATE, @CurrentDate)


SELECT	CAST(@CurrentDate AS DATE) AS 'Date'
,		CONVERT(NVARCHAR(11), @CurrentDate, 108) AS 'Time'
,		ctr_hso.CenterID AS 'HairSystemCenterID'
,		ctr_hso.CenterNumber AS 'HairSystemCenterNumber'
,		ctr_hso.CenterDescriptionFullCalc AS 'HairSystemCenterName'
,		COUNT(hso.HairSystemOrderNumber) AS 'QuantityOnHand'
,		SUM(hso.CostContract) AS 'TotalCostContract'
,		SUM(hso.CostActual) AS 'TotalCostActual'
,		SUM(hso.CostFactoryShipped) AS 'TotalCostFactoryShipped'
FROM	#HairSystemInventoryBatch hsib
		INNER JOIN #HairSystemInventoryTransaction hsit
			ON hsit.HairSystemInventoryBatchID = hsib.HairSystemInventoryBatchID
		INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
			ON hso.HairSystemOrderGUID = hsit.HairSystemOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr_hso
			ON ctr_hso.CenterID = hso.CenterID
				AND ctr_hso.IsActiveFlag = 1
		INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
			ON hsos.HairSystemOrderStatusID = hsit.HairSystemOrderStatusID
GROUP BY ctr_hso.CenterID
,		ctr_hso.CenterNumber
,		ctr_hso.CenterDescriptionFullCalc
ORDER BY ctr_hso.CenterID

END
GO
