/* CreateDate: 02/28/2011 20:07:11.187 , ModifyDate: 02/27/2017 09:49:28.653 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptMEAOrdersByFactory
-- Procedure Description:
--
-- Created By:				Mike Maass
-- Implemented By:			Mike Maass
-- Last Modified By:		Mike Maass
--
-- Date Created:			2/25/2011
-- Date Implemented:		2/25/2011
-- Date Last Modified:		2/25/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Notes:
	02/25/2011 - MLM - Initial Creation
Sample Execution:

EXEC rptMEAOrdersByFactory '2/14/08', '2/28/08, 1
================================================================================================*/
CREATE PROCEDURE [dbo].[rptMEAOrdersByFactory]
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


	DECLARE @HairSystemDesignTemplateID int

	Select @HairSystemDesignTemplateID = HairSystemDesignTemplateID from lkpHairSystemDesignTemplate WHERE HairSystemDesignTemplateDescriptionShort = 'MEA'

	-- Output results.
	SELECT
		[Vendor].VendorDescriptionShort AS 'FactoryCode'
	,	[Vendor].VendorDescription AS 'Factory'
	,	[PurchaseOrder].PurchaseOrderNumber AS 'HPONumber'
	,	[Orders].HairSystemOrderNumber AS 'SerialNumber'
	,	[HairSystem].HairSystemDescriptionShort AS 'SystemTypeCode'
	,	[HairSystemDesignTemplate].HairSystemDesignTemplateDescription AS 'TemplateSize'
	,	[HairSystemHairLength].HairSystemHairLengthDescriptionShort AS 'HairLength'
	,	RTRIM([Center].CenterDescriptionFullCalc) AS 'Center'
	,	RTRIM(CAST([Client].ClientNumber_Temp as varchar)) + ' - ' + RTRIM([Client].ClientFullNameAlt2Calc) AS 'Client'
	FROM [datHairSystemOrder] [Orders]
		INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail]
			ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
		INNER JOIN [datPurchaseOrder] [PurchaseOrder]
			ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		INNER JOIN [cfgVendor] [Vendor]
			ON [PurchaseOrder].VendorID = [Vendor].VendorID
		INNER JOIN cfgHairSystem [HairSystem]
			ON [Orders].HairSystemID = [HairSystem].HairSystemID
		INNER JOIN lkpHairSystemHairLength [HairSystemHairLength]
			ON [Orders].HairSystemHairLengthID = [HairSystemHairLength].HairSystemHairLengthID
		INNER JOIN lkpHairSystemDesignTemplate [HairSystemDesignTemplate]
			ON [Orders].HairSystemDesignTemplateID = [HairSystemDesignTemplate].HairSystemDesignTemplateID
		INNER JOIN cfgCenter [Center]
			ON [Orders].ClientHomeCenterID = [Center].CenterID
		INNER JOIN datClient [Client]
			ON [Orders].ClientGUID = [Client].ClientGUID
	WHERE CONVERT(DATETIME, CONVERT(VARCHAR, [PurchaseOrder].PurchaseOrderDate, 101)) BETWEEN @BeginDate AND @EndDate
		AND (@FactoryID IS NULL OR [Vendor].VendorID = @FactoryID)
		AND [Orders].HairSystemDesignTemplateID=@HairSystemDesignTemplateID
	ORDER BY
		[Vendor].VendorID
	,	[PurchaseOrder].PurchaseOrderDate
	,	[Center].CenterID
	,	[Client].ClientNumber_Temp
	,	[PurchaseOrder].PurchaseOrderNumber
	,	[HairSystem].HairSystemDescriptionShort

END
GO
