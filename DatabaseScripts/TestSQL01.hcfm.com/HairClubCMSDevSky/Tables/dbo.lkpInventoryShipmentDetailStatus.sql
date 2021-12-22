/* CreateDate: 10/04/2010 12:08:45.560 , ModifyDate: 12/07/2021 16:20:16.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpInventoryShipmentDetailStatus](
	[InventoryShipmentDetailStatusID] [int] NOT NULL,
	[InventoryShipmentDetailStatusSortOrder] [int] NOT NULL,
	[InventoryShipmentDetailStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryShipmentDetailStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryShipmentDetailStatus] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentDetailStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryShipmentDetailStatus] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
