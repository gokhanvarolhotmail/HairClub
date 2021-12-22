/* CreateDate: 03/19/2013 12:02:22.983 , ModifyDate: 03/19/2013 12:02:22.983 */
GO
/*********************************************************
  exec selPurchaseOrdersForDate '3/18/13'
**********************************************************/

CREATE PROCEDURE [dbo].[selPurchaseOrdersForDate] (
	@PurchaseOrderDate DateTime
) AS
BEGIN
	--Note: GUID parameter is intentially passed in as an nvarchar because uniqueidentifiers cause an issue in SSIS (MVT isn't an as dumb as you think)
	SET NOCOUNT ON

	SELECT
		CONVERT(nvarchar(100), po.PurchaseOrderGUID) as PurchaseOrderGUID,
		CONVERT(nvarchar(50), po.PurchaseOrderNumber) as PurchaseOrderNumber,
		v.VendorDescriptionShort,
		'mmaass@skylinetechnologies.com' AS MailTo,
		'mmaass@skylinetechnologies.com' AS MailFrom,
		'mmaass@skylinetechnologies.com' AS MailCC,
		--ISNULL(vc.EmailAlternative,'') AS MailCC,
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
	WHERE CONVERT(dateTime, CONVERT(nvarchar(10),po.PurchaseOrderDate,101)) = @PurchaseOrderDate

END
GO
