/* CreateDate: 08/05/2008 13:37:18.210 , ModifyDate: 12/03/2021 10:24:48.670 */
GO
CREATE TABLE [dbo].[datFactoryOrder](
	[FactoryOrderGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[FactoryOrderStatusID] [int] NULL,
	[HairSystemTypeID] [int] NULL,
	[UsedByClientGUID] [uniqueidentifier] NULL,
	[UsedDate] [datetime] NULL,
	[IsHS4Flag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datFactoryOrder] PRIMARY KEY CLUSTERED
(
	[FactoryOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datFactoryOrder] ADD  CONSTRAINT [DF_datFactoryOrder_IsHS4Flag]  DEFAULT ((0)) FOR [IsHS4Flag]
GO
ALTER TABLE [dbo].[datFactoryOrder]  WITH CHECK ADD  CONSTRAINT [FK_datFactoryOrder_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datFactoryOrder] CHECK CONSTRAINT [FK_datFactoryOrder_datClient]
GO
ALTER TABLE [dbo].[datFactoryOrder]  WITH CHECK ADD  CONSTRAINT [FK_datFactoryOrder_datClient1] FOREIGN KEY([UsedByClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datFactoryOrder] CHECK CONSTRAINT [FK_datFactoryOrder_datClient1]
GO
ALTER TABLE [dbo].[datFactoryOrder]  WITH CHECK ADD  CONSTRAINT [FK_datFactoryOrder_lkpFactoryOrderStatus] FOREIGN KEY([FactoryOrderStatusID])
REFERENCES [dbo].[lkpFactoryOrderStatus] ([FactoryOrderStatusID])
GO
ALTER TABLE [dbo].[datFactoryOrder] CHECK CONSTRAINT [FK_datFactoryOrder_lkpFactoryOrderStatus]
GO
ALTER TABLE [dbo].[datFactoryOrder]  WITH CHECK ADD  CONSTRAINT [FK_datFactoryOrder_lkpHairSystemType] FOREIGN KEY([HairSystemTypeID])
REFERENCES [dbo].[lkpHairSystemType] ([HairSystemTypeID])
GO
ALTER TABLE [dbo].[datFactoryOrder] CHECK CONSTRAINT [FK_datFactoryOrder_lkpHairSystemType]
GO
