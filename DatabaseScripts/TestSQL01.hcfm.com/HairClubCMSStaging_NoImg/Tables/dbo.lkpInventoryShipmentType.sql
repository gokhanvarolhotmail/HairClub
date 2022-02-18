/* CreateDate: 10/04/2010 12:08:45.590 , ModifyDate: 01/31/2022 08:32:31.857 */
GO
CREATE TABLE [dbo].[lkpInventoryShipmentType](
	[InventoryShipmentTypeID] [int] NOT NULL,
	[InventoryShipmentTypeSortOrder] [int] NOT NULL,
	[InventoryShipmentTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryShipmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpInventoryShipmentType] PRIMARY KEY CLUSTERED
(
	[InventoryShipmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpInventoryShipmentType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
