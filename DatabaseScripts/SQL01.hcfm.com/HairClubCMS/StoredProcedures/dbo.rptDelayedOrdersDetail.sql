/*===============================================================================================
-- Procedure Name:			rptDelayedOrdersDetail
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			1/25/2008
-- Date Implemented:		1/25/2008
-- Date Last Modified:		02/23/2010
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Sample Execution:

EXEC rptDelayedOrdersDetail '6H', 3
EXEC rptDelayedOrdersDetail 'All Factories', 5
EXEC rptDelayedOrdersDetail 'All Factories', 10
EXEC rptDelayedOrdersDetail 'All Factories', 9

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns
	* 02/02/11 MLM - Changed DaysDelay from 28 to 32
	* 03/07/11 MLM - Changed DaysDelay from 32 to 39
	* 06/18/11 MLM - Fixed Issue With Displayed CenterID, Changed the join to ClientHomeCenterId
	* 06/07/12 HDu - filter vendors by IsActive
	* 01/02/18 RMH - Changed DaysDelay from 39 to 42 (#144801)(TFS#10083)
--------------------------------------------------------------------------------------------------------
================================================================================================*/
CREATE PROCEDURE [dbo].[rptDelayedOrdersDetail]
(
	@Factory VARCHAR(50),
	@TimePeriodID INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DaysDelay int = 42

	-- Output results
	SELECT
		[DaysDelay].[HairSystemAllocationDaysDelayDescription] AS 'DaysDelay'
	,	[Vendor].VendorDescriptionShort AS 'FactoryCode'
	,	[Vendor].VendorDescription AS 'Factory'
	,	[PurchaseOrder].PurchaseOrderNumber AS 'HPONumber'
	,	[Orders].HairSystemOrderNumber AS 'SerialNumber'
	,	[HairSystem].HairSystemDescriptionShort AS 'SystemTypeCode'
	,	[HairSystemDesignTemplate].HairSystemDesignTemplateDescription AS 'TemplateSize'
	,	[HairSystemHairLength].HairSystemHairLengthDescriptionShort AS 'HairLength'
	,	RTRIM([Center].CenterDescriptionFullCalc) AS 'Center'
	,	RTRIM(CAST([Client].ClientNumber_Temp as varchar)) + ' - ' + RTRIM([Client].ClientFullNameAlt2Calc) AS 'Client'
	FROM datHairSystemOrder [Orders]
		INNER JOIN lkpHairSystemHairLength [HairSystemHairLength]
			ON [Orders].HairSystemHairLengthID = [HairSystemHairLength].HairSystemHairLengthID
		INNER JOIN lkpHairSystemDesignTemplate [HairSystemDesignTemplate]
			ON [Orders].HairSystemDesignTemplateID = [HairSystemDesignTemplate].HairSystemDesignTemplateID
		INNER JOIN datPurchaseOrderDetail [PurchaseOrderDetail]
			ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN datPurchaseOrder [PurchaseOrder]
			ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN cfgHairSystem [HairSystem]
			ON [Orders].HairSystemID = [HairSystem].HairSystemID
		INNER JOIN cfgVendor [Vendor]
			ON [PurchaseOrder].VendorID = [Vendor].VendorID
			AND Vendor.IsActiveFlag = 1
		INNER JOIN lkpHairSystemOrderStatus [HairSystemOrderStatus]
			ON [Orders].HairSystemOrderStatusID = [HairSystemOrderStatus].HairSystemOrderStatusID
		INNER JOIN [cfgHairSystemAllocationDaysDelay] [DaysDelay]
			ON [DaysDelay].[HairSystemAllocationDaysDelayID] = @TimePeriodID
		INNER JOIN cfgCenter [Center]
			ON [Orders].ClientHomeCenterID = [Center].CenterID
		INNER JOIN datClient [Client]
			ON [Orders].ClientGUID = [Client].ClientGUID
	WHERE ISNULL([Vendor].VendorDescriptionShort, 'XX') LIKE CASE WHEN @Factory = 'All Factories' THEN '%' ELSE @Factory END
		AND	[HairSystemOrderStatus].HairSystemOrderStatusDescriptionShort = 'ORDER'
		AND (DATEDIFF(dd, [Orders].HairSystemOrderDate, GETDATE()) - @DaysDelay) BETWEEN [DaysDelay].[MinimumValue] AND [DaysDelay].[MaximumValue]
	ORDER BY [Vendor].VendorDescriptionShort
	,	[Orders].ClientHomeCenterID
	,	[Client].ClientNumber_Temp
	,	[PurchaseOrder].PurchaseOrderNumber
	,	[HairSystem].HairSystemDescriptionShort

END
