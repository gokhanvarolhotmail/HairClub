/* CreateDate: 02/26/2017 22:35:10.607 , ModifyDate: 12/07/2021 16:20:15.823 */
GO
CREATE TABLE [dbo].[datTechnicalProfileScalpPreparation](
	[TechnicalProfileScalpPreparationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[ScalpPreparationID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfileScalpPreparation] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileScalpPreparationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datTechnicalProfileScalpPreparation_TechnicalProfileID] ON [dbo].[datTechnicalProfileScalpPreparation]
(
	[TechnicalProfileID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileScalpPreparation]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileScalpPreparation_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileScalpPreparation] CHECK CONSTRAINT [FK_datTechnicalProfileScalpPreparation_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileScalpPreparation]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileScalpPreparation_lkpScalpPreparation] FOREIGN KEY([ScalpPreparationID])
REFERENCES [dbo].[lkpScalpPreparation] ([ScalpPreparationID])
GO
ALTER TABLE [dbo].[datTechnicalProfileScalpPreparation] CHECK CONSTRAINT [FK_datTechnicalProfileScalpPreparation_lkpScalpPreparation]
GO
