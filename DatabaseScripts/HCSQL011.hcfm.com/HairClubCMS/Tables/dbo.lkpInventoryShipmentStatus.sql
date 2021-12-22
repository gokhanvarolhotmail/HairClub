/* CreateDate: 10/04/2010 12:08:45.530 , ModifyDate: 05/26/2020 10:49:36.000 */
GO
CREATE TABLE [dbo].[lkpInventoryShipmentStatus](
	[InventoryShipmentStatusID] [int] NOT NULL,
	[InventoryShipmentStatusSortOrder] [int] NOT NULL,
	[InventoryShipmentStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryShipmentStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryShipmentStatus] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryShipmentStatus] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
