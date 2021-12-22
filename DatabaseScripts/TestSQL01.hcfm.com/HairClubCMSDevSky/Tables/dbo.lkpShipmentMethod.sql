/* CreateDate: 10/04/2010 12:08:46.143 , ModifyDate: 12/07/2021 16:20:16.000 */
GO
CREATE TABLE [dbo].[lkpShipmentMethod](
	[ShipmentMethodID] [int] NOT NULL,
	[ShipmentMethodSortOrder] [int] NOT NULL,
	[ShipmentMethodDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ShipmentMethodDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpShipmentMethod] PRIMARY KEY CLUSTERED
(
	[ShipmentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpShipmentMethod] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
