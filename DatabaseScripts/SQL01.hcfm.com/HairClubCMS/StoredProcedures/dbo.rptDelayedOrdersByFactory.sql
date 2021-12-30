/* CreateDate: 10/04/2010 12:09:07.973 , ModifyDate: 01/02/2018 15:23:03.910 */
GO
/***********************************************************************
PROCEDURE:				rptDelayedOrdersByFactory
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Dominic Leiba
IMPLEMENTOR: 			Paul Madary
DATE IMPLEMENTED: 		1/25/08
LAST REVISION DATE: 	3/5/10
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
	* 01/25/08 DL  - Created Stored Proc
	* 02/19/10 AP  - Converted proc to CMS v3.0 db schema
	* 03/05/10 PRM - Modified associated table and simplified stored proc based on new table design
	* 02/02/11 MLM - Changed DaysDelay from 28 to 32
	* 03/07/11 MLM - Changed DaysDelay from 32 to 39
	* 06/07/12 HDu - Return all records, pivot at report on vendor
	* 01/02/18 RMH - Changed DaysDelay from 39 to 42 (#144801)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC rptDelayedOrdersByFactory
***********************************************************************/
CREATE PROCEDURE [dbo].[rptDelayedOrdersByFactory]
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @DaysDelay int = 42
	DECLARE @HairSystemOrderStatus_Order nvarchar(10) = 'ORDER'

	SELECT hsadd.HairSystemAllocationDaysDelayID
	,	hsadd.HairSystemAllocationDaysDelayDescription DelayDescription
	,	hsadd.HairSystemAllocationDaysDelaySortOrder
	,	v.VendorDescriptionShort
	,	CASE WHEN (DATEDIFF(dd, hso.HairSystemOrderDate, GETDATE()) - @DaysDelay) BETWEEN hsadd.MinimumValue AND hsadd.MaximumValue THEN 1 ELSE 0 END AS 'Delayed'
	FROM datHairSystemOrder hso
		INNER JOIN datPurchaseOrderDetail pod  ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID
		INNER JOIN datPurchaseOrder po  ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN cfgVendor v  ON po.VendorID = v.VendorID
		INNER JOIN lkpHairSystemOrderStatus hsos  ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		CROSS JOIN cfgHairSystemAllocationDaysDelay hsadd
	WHERE hsos.HairSystemOrderStatusDescriptionShort = 'ORDER'
		AND DATEDIFF(dd, hso.HairSystemOrderDate, GETDATE()) > @DaysDelay
		AND v.VendorDescriptionShort IS NOT NULL
		AND hsadd.[HairSystemAllocationDaysDelayID]<>10
		AND v.IsActiveFlag = 1
	UNION ALL
	SELECT hsadd.HairSystemAllocationDaysDelayID
	,	hsadd.HairSystemAllocationDaysDelayDescription DelayDescription
	,	hsadd.HairSystemAllocationDaysDelaySortOrder
	,	v.VendorDescriptionShort
	,	0 AS 'Delayed'
	FROM cfgVendor v
		CROSS JOIN cfgHairSystemAllocationDaysDelay hsadd
	WHERE v.VendorDescriptionShort IS NOT NULL
		AND hsadd.[HairSystemAllocationDaysDelayID]<>10
		AND v.IsActiveFlag = 1
		AND v.VendorTypeID = 2
	order by HairSystemAllocationDaysDelaySortOrder
END
GO
