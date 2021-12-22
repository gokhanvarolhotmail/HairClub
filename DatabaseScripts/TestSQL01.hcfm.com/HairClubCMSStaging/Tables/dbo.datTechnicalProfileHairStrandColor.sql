/* CreateDate: 02/26/2017 22:34:52.923 , ModifyDate: 05/26/2020 10:49:16.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datTechnicalProfileHairStrandColor](
	[TechnicalProfileHairStrandColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[HairStrandColorID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileHairStrandColor] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileHairStrandColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileHairStrandColor_TechnicalProfileID_HairStrandColorID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[HairStrandColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileHairStrandColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileHairStrandColor_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileHairStrandColor] CHECK CONSTRAINT [FK_datTechnicalProfileHairStrandColor_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileHairStrandColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileHairStrandColor_lkpHairStrandColor] FOREIGN KEY([HairStrandColorID])
REFERENCES [dbo].[lkpHairStrandColor] ([HairStrandColorID])
GO
ALTER TABLE [dbo].[datTechnicalProfileHairStrandColor] CHECK CONSTRAINT [FK_datTechnicalProfileHairStrandColor_lkpHairStrandColor]
GO
