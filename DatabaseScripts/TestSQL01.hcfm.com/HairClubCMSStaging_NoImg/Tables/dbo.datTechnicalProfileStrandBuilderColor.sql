/* CreateDate: 02/26/2017 22:34:52.837 , ModifyDate: 12/03/2021 10:24:48.563 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datTechnicalProfileStrandBuilderColor](
	[TechnicalProfileStrandBuilderColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[StrandBuilderColorID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileStrandBuilderColor] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileStrandBuilderColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileStrandBuilderColor_TechnicalProfileID_StrandBuilderColorID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[StrandBuilderColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileStrandBuilderColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileStrandBuilderColor_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileStrandBuilderColor] CHECK CONSTRAINT [FK_datTechnicalProfileStrandBuilderColor_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileStrandBuilderColor]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileStrandBuilderColor_lkpStrandBuilderColor] FOREIGN KEY([StrandBuilderColorID])
REFERENCES [dbo].[lkpStrandBuilderColor] ([StrandBuilderColorID])
GO
ALTER TABLE [dbo].[datTechnicalProfileStrandBuilderColor] CHECK CONSTRAINT [FK_datTechnicalProfileStrandBuilderColor_lkpStrandBuilderColor]
GO
