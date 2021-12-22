/* CreateDate: 10/04/2010 12:09:07.993 , ModifyDate: 02/27/2017 09:49:28.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptManualOrdersByFactory
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			1/25/2008
-- Date Implemented:		1/25/2008
-- Date Last Modified:		1/25/2008
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
================================================================================================
Change History:
	01/04/2011  MB 		Added filter to only retrieve manual orders (AND [Orders].HairSystemDesignTemplateID=31)
	02/25/2011  MLM 	Changed the Parameters to be a DateRange and allow FactoryID to be NULL
	05/08/2015  RH 		Added fields to report the MANUAL orders only
================================================================================================
Sample Execution:

EXEC rptManualOrdersByFactory '5/1/2015', '5/28/2015', NULL
================================================================================================*/
CREATE PROCEDURE [dbo].[rptManualOrdersByFactory]
(
	@BeginDate AS DATETIME,
	@EndDate AS DateTime,
	@FactoryID INT = null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Output results.
	SELECT
		V.VendorDescriptionShort
	,	V.VendorDescription
	,	PO.PurchaseOrderDate
	,	PO.PurchaseOrderNumber
	,	ORD.HairSystemOrderNumber
	,	HS.HairSystemDescriptionShort
	,	C.CenterDescriptionFullCalc
	,	CLT.ClientFullNameCalc
	,	POT.PurchaseOrderTypeDescription
	FROM datHairSystemOrder ORD
		INNER JOIN datPurchaseOrderDetail POD
			ON ORD.HairSystemOrderGUID = pod.HairSystemOrderGUID
		INNER JOIN datPurchaseOrder PO
			ON POD.PurchaseOrderGUID = PO.PurchaseOrderGUID
		INNER JOIN cfgVendor V
			ON PO.VendorID = V.VendorID
		INNER JOIN cfgHairSystem HS
			ON ORD.HairSystemID = HS.HairSystemID
		INNER JOIN cfgCenter C
			ON ORD.ClientHomeCenterID = C.CenterID
		INNER JOIN datClient CLT
			ON ORD.ClientGUID = CLT.ClientGUID
		INNER JOIN dbo.lkpPurchaseOrderType POT
			ON PO.PurchaseOrderTypeID = POT.PurchaseOrderTypeID
	WHERE PO.PurchaseOrderDate BETWEEN @BeginDate AND @EndDate
		AND (@FactoryID IS NULL OR V.VendorID = @FactoryID)
		AND PO.PurchaseOrderTypeID = 2 --Manual
	--ORDER BY
	--	V.VendorID
	--,	PO.PurchaseOrderDate
	--,	C.CenterID
	--,	CLT.ClientNumber_Temp
	--,	PO.PurchaseOrderNumber
	--,	HS.HairSystemDescriptionShort

END
GO
