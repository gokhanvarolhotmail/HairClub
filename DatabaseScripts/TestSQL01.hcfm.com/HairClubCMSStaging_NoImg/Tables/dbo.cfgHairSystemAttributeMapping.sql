/* CreateDate: 10/04/2010 12:08:45.830 , ModifyDate: 03/04/2022 16:09:12.870 */
GO
CREATE TABLE [dbo].[cfgHairSystemAttributeMapping](
	[HairSystemAttributeMappingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemCurlID] [int] NOT NULL,
	[HairSystemHairMaterialID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsBaseColorFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemAttributeMapping] PRIMARY KEY CLUSTERED
(
	[HairSystemAttributeMappingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemAttributeMapping] ADD  DEFAULT ((0)) FOR [IsBaseColorFlag]
GO
ALTER TABLE [dbo].[cfgHairSystemAttributeMapping]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAttributeMapping_lkpHairSystemCurl] FOREIGN KEY([HairSystemCurlID])
REFERENCES [dbo].[lkpHairSystemCurl] ([HairSystemCurlID])
GO
ALTER TABLE [dbo].[cfgHairSystemAttributeMapping] CHECK CONSTRAINT [FK_cfgHairSystemAttributeMapping_lkpHairSystemCurl]
GO
ALTER TABLE [dbo].[cfgHairSystemAttributeMapping]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAttributeMapping_lkpHairSystemHairMaterial] FOREIGN KEY([HairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[cfgHairSystemAttributeMapping] CHECK CONSTRAINT [FK_cfgHairSystemAttributeMapping_lkpHairSystemHairMaterial]
GO
