CREATE TABLE [dbo].[cfgHairSystemDesignTemplateJoin](
	[HairSystemDesignTemplateJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemDesignTemplateID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemDesignTemplateJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemDesignTemplateJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemDesignTemplateJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemDesignTemplateJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemDesignTemplateJoin] CHECK CONSTRAINT [FK_cfgHairSystemDesignTemplateJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemDesignTemplateJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemDesignTemplateJoin_lkpHairSystemDesignTemplate] FOREIGN KEY([HairSystemDesignTemplateID])
REFERENCES [dbo].[lkpHairSystemDesignTemplate] ([HairSystemDesignTemplateID])
GO
ALTER TABLE [dbo].[cfgHairSystemDesignTemplateJoin] CHECK CONSTRAINT [FK_cfgHairSystemDesignTemplateJoin_lkpHairSystemDesignTemplate]
