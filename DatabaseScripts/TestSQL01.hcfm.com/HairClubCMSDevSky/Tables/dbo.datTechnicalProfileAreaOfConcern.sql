/* CreateDate: 02/27/2017 11:32:21.907 , ModifyDate: 01/22/2018 05:54:33.817 */
GO
CREATE TABLE [dbo].[datTechnicalProfileAreaOfConcern](
	[TechnicalProfileAreaOfConcernID] [int] IDENTITY(1,1) NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ScalpRegionID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileAreaOfConcern] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileAreaOfConcernID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileAreaOfConcern_TechnicalProfileID_ScalpRegionID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC,
	[ScalpRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileAreaOfConcern]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileAreaOfConcern_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileAreaOfConcern] CHECK CONSTRAINT [FK_datTechnicalProfileAreaOfConcern_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileAreaOfConcern]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileAreaOfConcern_lkpScalpRegion] FOREIGN KEY([ScalpRegionID])
REFERENCES [dbo].[lkpScalpRegion] ([ScalpRegionID])
GO
ALTER TABLE [dbo].[datTechnicalProfileAreaOfConcern] CHECK CONSTRAINT [FK_datTechnicalProfileAreaOfConcern_lkpScalpRegion]
GO
