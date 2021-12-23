/* CreateDate: 10/04/2010 12:08:45.897 , ModifyDate: 12/07/2021 16:20:16.283 */
GO
CREATE TABLE [dbo].[cfgHairSystemFrontalDesignJoin](
	[HairSystemFrontalDesignJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemFrontalDesignID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemFrontalDesignJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemFrontalDesignJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDesignJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFrontalDesignJoin_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDesignJoin] CHECK CONSTRAINT [FK_cfgHairSystemFrontalDesignJoin_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDesignJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemFrontalDesignJoin_lkpHairSystemFrontalDesign] FOREIGN KEY([HairSystemFrontalDesignID])
REFERENCES [dbo].[lkpHairSystemFrontalDesign] ([HairSystemFrontalDesignID])
GO
ALTER TABLE [dbo].[cfgHairSystemFrontalDesignJoin] CHECK CONSTRAINT [FK_cfgHairSystemFrontalDesignJoin_lkpHairSystemFrontalDesign]
GO
