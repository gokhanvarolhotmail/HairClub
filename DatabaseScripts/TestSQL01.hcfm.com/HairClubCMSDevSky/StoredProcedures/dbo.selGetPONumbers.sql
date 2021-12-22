/* CreateDate: 12/31/2010 13:21:06.810 , ModifyDate: 02/27/2017 09:49:33.987 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selGetPONumbers

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 10/27/2010

LAST REVISION DATE: 	 12/17/2010

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used during the allocation process (SSIS package) to retrieve POs to create Files sent to Factories
		* 10/27/2010 MVT - Created stored proc
		* 12/12/2010 MVT - Modified to return Purchase Order Type
		* 01/05/2010 PRM - Only bring back active vendor contacts
		* 09/02/2011 MVT - Modified to include Vendor Export File Type
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selGetPONumbers 'Mail@HCFM.com'


***********************************************************************/

CREATE PROCEDURE [dbo].[selGetPONumbers] (
	@MailFrom nvarchar(250)
) AS
BEGIN
	SET NOCOUNT ON

	--create variable to hold date to be queried
	DECLARE @OrderedPOStatus NVarChar(10) = 'ORDERED'


	SELECT
		CONVERT(nvarchar(100), po.PurchaseOrderGUID) as PurchaseOrderGUID,
		CONVERT(nvarchar(50), po.PurchaseOrderNumber) as PurchaseOrderNumber,
		v.VendorDescriptionShort,
		vc.EmailMain AS MailTo,
		@MailFrom AS MailFrom,
		ISNULL(vc.EmailAlternative,'') AS MailCC,
		UPPER(ISNULL(t.PurchaseOrderTypeDescription, '')) as PurchaseOrderType,
		vft.VendorExportFileTypeDescriptionShort AS VendorExportFileType
	FROM datPurchaseOrder po
		INNER JOIN cfgVendorContact vc
			ON po.VendorID = vc.VendorID AND IsActiveFlag = 1
		INNER JOIN cfgVendor v
			ON po.VendorID = v.VendorID
		INNER JOIN lkpPurchaseOrderStatus s
			ON s.PurchaseOrderStatusID = po.PurchaseOrderStatusID
		INNER JOIN lkpVendorExportFileType vft
			ON vft.VendorExportFileTypeID = v.VendorExportFileTypeID
		LEFT OUTER JOIN lkpPurchaseOrderType t
			ON po.PurchaseOrderTypeID = t.PurchaseOrderTypeID
	WHERE s.PurchaseOrderStatusDescriptionShort = @OrderedPOStatus

	----get 5 PO numbers from previous day
	--INSERT INTO #PurchaseOrders (PurchaseOrder, POType, MailTo, MailFrom, MailCC)
	--SELECT TOP 5 [OrderAllocation].HPONumber
	--,	RTRIM([OrderAllocation].OrderType) AS 'OrderType'
	--,	[Factory].ExportMailTo
	--,	[Factory].ExportMailFrom
	--,	[Factory].ExportMailCC
	--FROM [OrderAllocation]
	--	INNER JOIN [Factory]
	--		ON [OrderAllocation].AllocatedFactory = [Factory].[FactoryAbbrev]
	--WHERE [OrderAllocation].OrderDate=@Yesterday
	--	AND [OrderAllocation].HPONumber NOT IN (0)
	--	AND [OrderAllocation].AllocatedFactory=@Factory
	--GROUP BY [OrderAllocation].HPONumber
	--,	[OrderAllocation].OrderType
	--,	[Factory].ExportMailTo
	--,	[Factory].ExportMailFrom
	--,	[Factory].ExportMailCC
	--ORDER BY [OrderAllocation].HPONumber DESC

	--SELECT *
	--FROM #PurchaseOrders
END
GO
