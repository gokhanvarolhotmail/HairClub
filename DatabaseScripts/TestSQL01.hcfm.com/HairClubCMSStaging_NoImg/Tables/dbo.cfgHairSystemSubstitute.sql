/* CreateDate: 08/29/2016 07:22:33.687 , ModifyDate: 03/04/2022 16:09:12.687 */
GO
CREATE TABLE [dbo].[cfgHairSystemSubstitute](
	[HairSystemSubstituteID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[SubstituteHairSystemID] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[Comments] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemSubstitute] PRIMARY KEY CLUSTERED
(
	[HairSystemSubstituteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_cfgHairSystemSubstitute_HairSystemID_SubstituteHairSystemID] UNIQUE NONCLUSTERED
(
	[HairSystemID] ASC,
	[SubstituteHairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemSubstitute]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemSubstitute_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemSubstitute] CHECK CONSTRAINT [FK_cfgHairSystemSubstitute_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemSubstitute]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemSubstitute_cfgHairSystem_SubstituteHairSystem] FOREIGN KEY([SubstituteHairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemSubstitute] CHECK CONSTRAINT [FK_cfgHairSystemSubstitute_cfgHairSystem_SubstituteHairSystem]
GO
