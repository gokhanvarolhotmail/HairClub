/* CreateDate: 05/05/2020 17:42:50.580 , ModifyDate: 05/05/2020 17:43:10.990 */
GO
CREATE TABLE [dbo].[datInventoryShipmentDetail](
	[InventoryShipmentDetailGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[InventoryShipmentDetailStatusID] [int] NOT NULL,
	[InventoryTransferRequestGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[InventoryShipmentReasonID] [int] NULL,
	[PriorityTransferFee] [money] NULL,
	[PriorityHairSystemCenterContractPricingID] [int] NULL,
 CONSTRAINT [PK_datInventoryShipmentDetail] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
