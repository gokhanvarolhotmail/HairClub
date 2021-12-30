/* CreateDate: 12/20/2019 08:49:02.767 , ModifyDate: 05/24/2021 09:10:45.277 */
GO
/***********************************************************************
PROCEDURE:				mtnDistributorPurchaseOrderToXML	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	cONEct

AUTHOR:					Edmund Poillion

IMPLEMENTOR:			Edmund Poillion

DATE IMPLEMENTED:		12/09/2019

LAST REVISION DATE:		12/09/2019

--------------------------------------------------------------------------------------------------------
NOTES:
	12/09/2019	EPoillion	Initial Creation
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnDistributorPurchaseOrderToXML 3407

	CenterID = Logged in Center
	ClientGUID = From datAppointment - ClientGUID
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnDistributorPurchaseOrderToXML] (
	@DistributorPurchaseOrderID int,
	@accountId nvarchar(128) = N'HAR149BOC',
	--@whseID nvarchar(128) = N'1',
	@allowDuplicates nvarchar(128) = N'0',
	@HeaderComments nvarchar(512) = N'No deliveries on Monday;'
) AS
	BEGIN


	SET NOCOUNT ON

	-- Proc Params
	--DECLARE @DistributorPurchaseOrderID int = 3407;
	--DECLARE @accountId nvarchar(128) = N'HAR149BOC';
	--DECLARE @whseID nvarchar(128) = N'1';
	--DECLARE @allowDuplicates nvarchar(128) = N'0';
	--DECLARE @HeaderComments nvarchar(512) = N'Consignee is closed on Mondays, can not deliver on Mondays!  Hand cart or a dolly is need to complete the delivery.  Lift-Gate and Inside delivery is required for all delivery’s, product must be delivered to the center location.  Hair club employee must sign for the delivery.';

	-- Constants
	DECLARE @timestamp nvarchar(8) = CONVERT(varchar(8), GETDATE(), 112);
	DECLARE @UOM_Each_Id int = 0;
	DECLARE @UOM_Case_Id int = 0;
	DECLARE @HeaderComments201 nvarchar(512) = N'    Delivery time: 630 – 8 am; Contact: Stephen Dooley (908) 347-4563,  Susan Greenspan (732) 485-7278'

	SELECT @UOM_Each_Id = UnitOfMeasureId FROM dbo.lkpUnitOfMeasure WHERE UnitOfMeasureDescriptionShort = N'Each';
	SELECT @UOM_Case_Id = UnitOfMeasureId FROM dbo.lkpUnitOfMeasure WHERE UnitOfMeasureDescriptionShort = N'CASE';

	-- PO Header Info
	DECLARE @PurchaseOrderNumber nvarchar(128);
	DECLARE @CenterNumber int;
	DECLARE @CenterName nvarchar(128);
	DECLARE @CenterAddr1 nvarchar(128);
	DECLARE @CenterAddr2 nvarchar(128);
	DECLARE @CenterCity nvarchar(128);
	DECLARE @CenterState nvarchar(128);
	DECLARE @CenterPostalCode nvarchar(128);
	DECLARE @CenterPhone nvarchar(128);
	DECLARE @whseID nvarchar(128)


	SELECT
		@PurchaseOrderNumber = dpo.PurchaseOrderNumber,
		@CenterNumber = c.CenterNumber,
		@CenterName = c.CenterDescriptionFullCalc,
		@CenterAddr1 = c.Address1,
		@CenterAddr2 = c.Address2,
		@CenterCity = c.City,
		@CenterState = s.StateDescriptionShort,
		@CenterPostalCode = c.PostalCode,
		@CenterPhone = c.Phone1
	FROM
		dbo.datDistributorPurchaseOrder dpo
	INNER JOIN
		dbo.cfgCenter c ON c.CenterID = dpo.CenterID
	INNER JOIN
		dbo.lkpState s ON s.StateID = c.StateID
	WHERE
		dpo.DistributorPurchaseOrderID = @DistributorPurchaseOrderID;

	-- Get WareHouseID

	SELECT
		@whseID = c.[WareHouseId]
	FROM
		dbo.datDistributorPurchaseOrder dpo
	INNER JOIN
		dbo.cfgCenter c ON c.CenterID = dpo.DistributorCenterID
	LEFT JOIN
		dbo.lkpDistributorPurchaseOrderStatus dpos ON dpo.DistributorPurchaseOrderStatusID = dpos.DistributorPurchaseOrderStatusID
	INNER JOIN
		dbo.cfgCenterDistributorJoin cdj ON dpo.DistributorCenterID = cdj.[DistributorId] AND dpo.CenterID = cdj.[CenterId]
	WHERE
		dpo.DistributorPurchaseOrderID = @DistributorPurchaseOrderID



	--CREATE TABLE @data
	DECLARE @data table
	(
		[Tag] [int] NOT NULL,
		[Parent] [int] NOT NULL,
		[XML940!1!timestamp] [nvarchar](512) NULL,
		[OrderRequest!2] [nvarchar](512) NULL,
		[RequestHeader!3!accountID] [nvarchar](512) NULL,
		[RequestHeader!3!whseID] [nvarchar](512) NULL,
		[RequestHeader!3!allowDuplicates] [nvarchar](512) NULL,
		[HeaderDetail!4!OrderNumber!ELEMENT] [nvarchar](512) NULL,
		[HeaderDetail!4!PoNumber!ELEMENT] [nvarchar](512) NULL,
		[HeaderDetail!4!ShipDate!ELEMENT] [nvarchar](512) NULL,
		[ShipToPartner!5] [nvarchar](512) NULL,
		[Address!6!Name!ELEMENT] [nvarchar](512) NULL,
		[PostalAddress!7!name] [nvarchar](512) NULL,
		[PostalAddress!7!Street1!ELEMENT] [nvarchar](512) NULL,
		[PostalAddress!7!Street2!ELEMENT] [nvarchar](512) NULL,
		[PostalAddress!7!City!ELEMENT] [nvarchar](512) NULL,
		[PostalAddress!7!State!ELEMENT] [nvarchar](512) NULL,
		[PostalAddress!7!PostalCode!ELEMENT] [nvarchar](512) NULL,
		[Email!8] [nvarchar](512) NULL,
		[PhoneNumber!9!name] [nvarchar](512) NULL,
		[OrderPreDefsFV0!10] [nvarchar](512) NULL,
		[OrderPreDefsFV1!11] [nvarchar](512) NULL,
		[OrderPreDefsFV2!12] [nvarchar](512) NULL,
		[OrderPreDefsFV3!13] [nvarchar](512) NULL,
		[OrderPreDefsFV4!14] [nvarchar](512) NULL,
		[OrderPreDefsFV5!15] [nvarchar](512) NULL,
		[OrderPreDefsFV6!16] [nvarchar](512) NULL,
		[OrderPreDefsFV7!17] [nvarchar](512) NULL,
		[OrderPreDefsFV8!18] [nvarchar](512) NULL,
		[OrderPreDefsFV9!19] [nvarchar](512) NULL,
		[Comments!20] [nvarchar](512) NULL,
		[LineItem!21!lineNumber] [nvarchar](512) NULL,
		[LineItem!21!quantity] [nvarchar](512) NULL,
		[LineItem!21!uom] [nvarchar](512) NULL,
		[ItemID!22!VendorSKU!ELEMENT] [nvarchar](512) NULL,
		[ItemID!22!CustomerSKU!ELEMENT] [nvarchar](512) NULL,
		[ItemID!22!UPC!ELEMENT] [nvarchar](512) NULL,
		[ItemID!22!CustomerUPC!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!ShortName!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!Description!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!UnitPrice!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!EntryPreDefsFV2!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!EntryPreDefsFV3!ELEMENT] [nvarchar](512) NULL,
		[ItemDetail!23!EntryPreDefsFV4!ELEMENT] [nvarchar](512) NULL,
		[Comments!24] [nvarchar](512) NULL,
		[DetailId!25!!HIDE] [nvarchar](512) NULL
	);

	-- <XML940>	Tag = 1	Parent = 0
	INSERT INTO	@data
		(Tag, Parent, [XML940!1!timestamp])
	VALUES
		(1, 0, CONVERT(varchar(8), GETDATE(), 112));


	-- <OrderRequest>	Tag = 2	Parent = <XML940>(1)
	INSERT INTO	@data
		(Tag, Parent)
	VALUES
		(2, 1);

	-- <RequestHeader>	Tag = 3	Parent = <OrderRequest>(2)
	INSERT INTO	@data
		(Tag, Parent, [RequestHeader!3!accountID], [RequestHeader!3!whseID], [RequestHeader!3!allowDuplicates])
	VALUES
		(3, 2, N'HAR149BOC',@whseID, N'0');


	-- <HeaderDetail>	Tag = 4	Parent = <RequestHeader>(3)
	INSERT INTO	@data
		(Tag, Parent, [HeaderDetail!4!OrderNumber!ELEMENT], [HeaderDetail!4!PoNumber!ELEMENT], [HeaderDetail!4!ShipDate!ELEMENT])
	VALUES
		(4, 3, @DistributorPurchaseOrderID, @PurchaseOrderNumber, N'');


	-- <ShipToPartner>	Tag = 5	Parent = <RequestHeader>(3)
	INSERT INTO	@data
		(Tag, Parent)
	VALUES
		(5, 3);


	-- <Address>	Tag = 6	Parent = <ShipToPartner>(5)
	INSERT INTO	@data
		(Tag, Parent, [Address!6!Name!ELEMENT])
	VALUES
		(6, 5, @CenterName);


	-- <PostalAddress>	Tag = 7	Parent = <Address>(6)
	INSERT INTO	@data
		(Tag, Parent, [Address!6!Name!ELEMENT], [PostalAddress!7!name], [PostalAddress!7!Street1!ELEMENT], [PostalAddress!7!Street2!ELEMENT], [PostalAddress!7!City!ELEMENT], [PostalAddress!7!State!ELEMENT], [PostalAddress!7!PostalCode!ELEMENT])
	VALUES
		(7, 6, @CenterName, @CenterName, @CenterAddr1, @CenterAddr2, @CenterCity, @CenterState, @CenterPostalCode);


	-- <Email>	Tag = 8	Parent = <Address>(6)
	INSERT INTO	@data
		(Tag, Parent, [Email!8])
	VALUES
		(8, 6, N'');


	-- <PhoneNumber>	Tag = 9	Parent = <Address>(6)
	INSERT INTO	@data
		(Tag, Parent, [PhoneNumber!9!name])
	VALUES
		(9, 6, @CenterPhone);


	-- <OrderPreDefsFV[0-9]>	Tag = 10-19	Parent = <RequestHeader>(3)
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV0!10]) VALUES (10, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV1!11]) VALUES (11, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV2!12]) VALUES (12, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV3!13]) VALUES (13, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV4!14]) VALUES (14, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV5!15]) VALUES (15, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV6!16]) VALUES (16, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV7!17]) VALUES (17, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV8!18]) VALUES (18, 3, N'');
	INSERT INTO	@data (Tag, Parent, [OrderPreDefsFV9!19]) VALUES (19, 3, N'');


	-- <Comments>	Tag = 20	Parent = <RequestHeader>(3)
	INSERT INTO	@data
		(Tag, Parent, [Comments!20])
	VALUES
		(20, 3, CASE WHEN @CenterNumber = 201 THEN @HeaderComments + @HeaderComments201 ELSE @HeaderComments END);


	-- <LineItem>	Tag = 21	Parent = <OrderRequest>(2)
	INSERT INTO	@data
		(Tag, Parent, [LineItem!21!lineNumber], [LineItem!21!quantity], [LineItem!21!uom], [DetailId!25!!HIDE])
	SELECT
		21 AS [Tag],
		2 AS [Parent],
		ROW_NUMBER() OVER (PARTITION BY dpo.DistributorPurchaseOrderID ORDER BY dpod.DistributorPurchaseOrderDetailID) AS [LineItem!21!lineNumber],
		CASE
			WHEN dpod.UnitOfMeasureID = @UOM_Case_Id THEN dpod.Quantity * sc.QuantityPerPack
			ELSE dpod.Quantity
		END AS [LineItem!21!quantity],
		N'EA' AS [LineItem!21!uom],
		dpod.DistributorPurchaseOrderDetailID AS [DetailId!25!!HIDE]
	FROM
		dbo.datDistributorPurchaseOrder dpo
	INNER JOIN
		dbo.datDistributorPurchaseOrderDetail dpod ON dpod.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
	INNER JOIN
		dbo.lkpUnitOfMeasure uom ON uom.UnitOfMeasureID = dpod.UnitOfMeasureID
	INNER JOIN
		dbo.cfgSalesCodeDistributor scd ON scd.SalesCodeDistributorID = dpod.SalesCodeDistributorID AND scd.CenterID = dpo.DistributorCenterID
	INNER JOIN
		dbo.cfgSalesCode sc ON sc.SalesCodeID = scd.SalesCodeID
	WHERE
		dpod.DistributorPurchaseOrderID = @DistributorPurchaseOrderID;


	-- <ItemID>	Tag = 22	Parent = <LineItem>(21)
	INSERT INTO	@data
		(Tag, Parent, [ItemID!22!VendorSKU!ELEMENT], [ItemID!22!CustomerSKU!ELEMENT], [ItemID!22!UPC!ELEMENT], [ItemID!22!CustomerUPC!ELEMENT], [DetailId!25!!HIDE])
	SELECT
		22 AS [Tag],
		21 AS [Parent],
		scd.ItemSKU AS [ItemID!22!VendorSKU!ELEMENT],
		scd.PackSKU AS [ItemID!22!CustomerSKU!ELEMENT],
		N'' AS [ItemID!22!UPC!ELEMENT],
		N'' AS [ItemID!22!CustomerUPC!ELEMENT],
		dpod.DistributorPurchaseOrderDetailID AS [DetailId!25!!HIDE]
	FROM
		dbo.datDistributorPurchaseOrder dpo
	INNER JOIN
		dbo.datDistributorPurchaseOrderDetail dpod ON dpod.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
	INNER JOIN
		dbo.lkpUnitOfMeasure uom ON uom.UnitOfMeasureID = dpod.UnitOfMeasureID
	INNER JOIN
		dbo.cfgSalesCodeDistributor scd ON scd.SalesCodeDistributorID = dpod.SalesCodeDistributorID AND scd.CenterID = dpo.DistributorCenterID
	INNER JOIN
		dbo.cfgSalesCode sc ON sc.SalesCodeID = scd.SalesCodeID
	WHERE
		dpod.DistributorPurchaseOrderID = @DistributorPurchaseOrderID;


	-- <ItemDetail>	Tag = 23	Parent = <LineItem>(21)
	INSERT INTO	@data
		(Tag, Parent, [ItemDetail!23!ShortName!ELEMENT], [ItemDetail!23!Description!ELEMENT], [ItemDetail!23!UnitPrice!ELEMENT], [DetailId!25!!HIDE])
	SELECT
		23 AS [Tag],
		21 AS [Parent],
		N'' AS [ItemDetail!23!ShortName!ELEMENT],
		scd.ItemDescription AS [ItemDetail!23!Description!ELEMENT],
		N'' AS [ItemDetail!23!UnitPrice!ELEMENT],
		dpod.DistributorPurchaseOrderDetailID AS [DetailId!25!!HIDE]
	FROM
		dbo.datDistributorPurchaseOrder dpo
	INNER JOIN
		dbo.datDistributorPurchaseOrderDetail dpod ON dpod.DistributorPurchaseOrderID = dpo.DistributorPurchaseOrderID
	INNER JOIN
		dbo.lkpUnitOfMeasure uom ON uom.UnitOfMeasureID = dpod.UnitOfMeasureID
	INNER JOIN
		dbo.cfgSalesCodeDistributor scd ON scd.SalesCodeDistributorID = dpod.SalesCodeDistributorID AND scd.CenterID = dpo.DistributorCenterID
	INNER JOIN
		dbo.cfgSalesCode sc ON sc.SalesCodeID = scd.SalesCodeID
	WHERE
		dpod.DistributorPurchaseOrderID = @DistributorPurchaseOrderID;



	--SELECT * FROM @data;
	SELECT * FROM (SELECT * FROM @data ORDER BY [DetailId!25!!HIDE], [Tag] FOR XML EXPLICIT) AS y(XML_COL);


	--DROP TABLE @data;
END
GO
