CREATE TABLE [dbo].[cfgEntity](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[EntitySortOrder] [int] NOT NULL,
	[EntityDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EntityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[PostalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1TypeID] [int] NULL,
	[Phone2TypeID] [int] NULL,
	[Phone3TypeID] [int] NULL,
	[IsPhone1Primary] [bit] NOT NULL,
	[IsPhone2Primary] [bit] NOT NULL,
	[IsPhone3Primary] [bit] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgEntity] PRIMARY KEY CLUSTERED
(
	[EntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgEntity]  WITH CHECK ADD  CONSTRAINT [FK_cfgEntity_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[cfgEntity] CHECK CONSTRAINT [FK_cfgEntity_lkpCountry]
GO
ALTER TABLE [dbo].[cfgEntity]  WITH CHECK ADD  CONSTRAINT [FK_cfgEntity_lkpPhone1Type] FOREIGN KEY([Phone1TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgEntity] CHECK CONSTRAINT [FK_cfgEntity_lkpPhone1Type]
GO
ALTER TABLE [dbo].[cfgEntity]  WITH CHECK ADD  CONSTRAINT [FK_cfgEntity_lkpPhone2Type] FOREIGN KEY([Phone2TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgEntity] CHECK CONSTRAINT [FK_cfgEntity_lkpPhone2Type]
GO
ALTER TABLE [dbo].[cfgEntity]  WITH CHECK ADD  CONSTRAINT [FK_cfgEntity_lkpPhone3Type] FOREIGN KEY([Phone3TypeID])
REFERENCES [dbo].[lkpPhoneType] ([PhoneTypeID])
GO
ALTER TABLE [dbo].[cfgEntity] CHECK CONSTRAINT [FK_cfgEntity_lkpPhone3Type]
GO
ALTER TABLE [dbo].[cfgEntity]  WITH CHECK ADD  CONSTRAINT [FK_cfgEntity_lkpState] FOREIGN KEY([StateID])
REFERENCES [dbo].[lkpState] ([StateID])
GO
ALTER TABLE [dbo].[cfgEntity] CHECK CONSTRAINT [FK_cfgEntity_lkpState]
