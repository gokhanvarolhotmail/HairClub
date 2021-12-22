CREATE TABLE [dbo].[datClientAddress](
	[ClientAddressGUID] [uniqueidentifier] NOT NULL,
	[ClientAddressTypeID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[CountryID] [int] NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[PostalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datClientAddress] PRIMARY KEY NONCLUSTERED
(
	[ClientAddressGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientAddress]  WITH CHECK ADD  CONSTRAINT [FK_datClientAddress_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientAddress] CHECK CONSTRAINT [FK_datClientAddress_datClient]
GO
ALTER TABLE [dbo].[datClientAddress]  WITH CHECK ADD  CONSTRAINT [FK_datClientAddress_datClient1] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientAddress] CHECK CONSTRAINT [FK_datClientAddress_datClient1]
GO
ALTER TABLE [dbo].[datClientAddress]  WITH CHECK ADD  CONSTRAINT [FK_datClientAddress_lkpClientAddressType] FOREIGN KEY([ClientAddressTypeID])
REFERENCES [dbo].[lkpClientAddressType] ([ClientAddressTypeID])
GO
ALTER TABLE [dbo].[datClientAddress] CHECK CONSTRAINT [FK_datClientAddress_lkpClientAddressType]
GO
ALTER TABLE [dbo].[datClientAddress]  WITH CHECK ADD  CONSTRAINT [FK_datClientAddress_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[datClientAddress] CHECK CONSTRAINT [FK_datClientAddress_lkpCountry]
GO
ALTER TABLE [dbo].[datClientAddress]  WITH CHECK ADD  CONSTRAINT [FK_datClientAddress_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[datClientAddress] CHECK CONSTRAINT [FK_datClientAddress_lkpState]
