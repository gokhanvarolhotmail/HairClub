/* CreateDate: 12/31/2010 13:21:00.910 , ModifyDate: 03/04/2022 16:09:12.853 */
GO
CREATE TABLE [dbo].[lkpInventoryShipmentReason](
	[InventoryShipmentReasonID] [int] NOT NULL,
	[InventoryShipmentReasonSortOrder] [int] NOT NULL,
	[InventoryShipmentReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryShipmentReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryShipmentReason] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
