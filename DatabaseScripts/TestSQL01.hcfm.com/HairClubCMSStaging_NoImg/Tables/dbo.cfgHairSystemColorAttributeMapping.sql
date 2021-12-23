/* CreateDate: 10/04/2010 12:08:45.840 , ModifyDate: 12/03/2021 10:24:48.717 */
GO
CREATE TABLE [dbo].[cfgHairSystemColorAttributeMapping](
	[HairSystemColorAttributeMappingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemAttributeMappingID] [int] NOT NULL,
	[HairSystemHairColorID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemColorAttributeMapping] PRIMARY KEY CLUSTERED
(
	[HairSystemColorAttributeMappingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemColorAttributeMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemColorAttributeMapping_cfgHairSystemAttributeMapping] FOREIGN KEY([HairSystemAttributeMappingID])
REFERENCES [dbo].[cfgHairSystemAttributeMapping] ([HairSystemAttributeMappingID])
GO
ALTER TABLE [dbo].[cfgHairSystemColorAttributeMapping] CHECK CONSTRAINT [FK_cfgHairSystemColorAttributeMapping_cfgHairSystemAttributeMapping]
GO
ALTER TABLE [dbo].[cfgHairSystemColorAttributeMapping]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemColorAttributeMapping_lkpHairSystemHairColor] FOREIGN KEY([HairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[cfgHairSystemColorAttributeMapping] CHECK CONSTRAINT [FK_cfgHairSystemColorAttributeMapping_lkpHairSystemHairColor]
GO
