/* CreateDate: 10/31/2019 21:09:58.587 , ModifyDate: 01/06/2020 09:13:00.887 */
GO
/*
==============================================================================
PROCEDURE:				mtnHairSystemOrderAllocationByDefaultFactory

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 1/12/2008

LAST REVISION DATE: 	 2/10/2010

==============================================================================
DESCRIPTION:	Allocation Step 3:
					Allocate orders to default factory where only one
					factory can make the hair system
==============================================================================
NOTES:
		* 2/10/10 PRM - Translated stored proc from Allocation to CMS v4.0
		* 12/17/10 PRM - removed attribute filtering since this is the only factory that can make the hair system
		* 3/24/14	MLM - Added Ranking2VendorID and Ranking3VendorID
==============================================================================
SAMPLE EXECUTION:
EXEC mtnHairSystemOrderAllocationByDefaultFactory 'C6F79487-A47D-405D-838D-42AC2C69D383', 'Allocation Process', 1, '9/22/2010 12:00 AM', 'READY'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnHairSystemOrderAllocationByDefaultFactory]
@HairSystemAllocationGUID uniqueidentifier,
@User nvarchar(50),
@FilterID int,
@EndDate datetime,
@HairSystemStatus_Ready nvarchar(10)
AS
  BEGIN
	SET NOCOUNT ON

	--assign all orders not assigned yet where there is only a 1 default factory
	INSERT INTO datPurchaseOrderDetail (PurchaseOrderDetailGUID, PurchaseOrderGUID, HairSystemOrderGUID, HairSystemAllocationFilterID, CreateDate, CreateUser ,LastUpdate, LastUpdateUser)
		SELECT NEWID(), po.PurchaseOrderGUID, HairSystemOrderGUID, @FilterID,
			GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM datHairSystemOrder hso
			INNER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			INNER JOIN lkpHairSystemOrderStatus  hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			INNER JOIN cfgHairSystemVendorRanking hsvr ON hso.HairSystemID = hsvr.HairSystemID
			INNER JOIN datPurchaseOrder po ON hsvr.Ranking1VendorID = po.VendorID AND po.HairSystemAllocationGUID = @HairSystemAllocationGUID
		WHERE hsos.HairSystemOrderStatusDescriptionShort = @HairSystemStatus_Ready
			AND NOT hso.HairSystemOrderGUID IN (SELECT HairSystemOrderGUID FROM datPurchaseOrderDetail)
			AND (NOT hsvr.Ranking1VendorID IS NULL AND hsvr.Ranking2VendorID IS NULL AND hsvr.Ranking3VendorID IS NULL AND hsvr.Ranking4VendorID IS NULL AND hsvr.Ranking5VendorID IS NULL AND hsvr.Ranking6VendorID IS NULL)

  END
GO
