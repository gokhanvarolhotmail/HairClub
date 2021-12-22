/* CreateDate: 12/10/2014 22:51:34.047 , ModifyDate: 12/07/2021 16:20:16.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datClientDemographic](
	[ClientDemographicID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[EthnicityID] [int] NULL,
	[OccupationID] [int] NULL,
	[MaritalStatusID] [int] NULL,
	[LudwigScaleID] [int] NULL,
	[NorwoodScaleID] [int] NULL,
	[DISCStyleID] [int] NULL,
	[SolutionOfferedID] [int] NULL,
	[PriceQuoted] [money] NULL,
	[LastConsultationDate] [datetime] NULL,
	[LastConsultantGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsPotentialModel] [bit] NOT NULL,
 CONSTRAINT [PK_datClientDemographic] PRIMARY KEY CLUSTERED
(
	[ClientDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientDemographic_ClientIdentifier] ON [dbo].[datClientDemographic]
(
	[ClientIdentifier] ASC
)
INCLUDE([EthnicityID],[OccupationID],[MaritalStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datClientDemographic_ClientGUID] ON [dbo].[datClientDemographic]
(
	[ClientGUID] ASC
)
INCLUDE([EthnicityID],[OccupationID],[MaritalStatusID],[LudwigScaleID],[NorwoodScaleID],[DISCStyleID],[SolutionOfferedID],[PriceQuoted],[LastConsultationDate],[ClientDemographicID],[ClientIdentifier],[LastConsultantGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientDemographic] ADD  DEFAULT ((0)) FOR [IsPotentialModel]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_datClient]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_datEmployee] FOREIGN KEY([LastConsultantGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_datEmployee]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpBusinessSegment] FOREIGN KEY([SolutionOfferedID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpDISCStyle] FOREIGN KEY([DISCStyleID])
REFERENCES [dbo].[lkpDISCStyle] ([DISCStyleID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpDISCStyle]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpEthnicity] FOREIGN KEY([EthnicityID])
REFERENCES [dbo].[lkpEthnicity] ([EthnicityID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpEthnicity]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpLudwigScale] FOREIGN KEY([LudwigScaleID])
REFERENCES [dbo].[lkpLudwigScale] ([LudwigScaleID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpLudwigScale]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpMaritalStatus] FOREIGN KEY([MaritalStatusID])
REFERENCES [dbo].[lkpMaritalStatus] ([MaritalStatusID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpMaritalStatus]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpNorwoodScale] FOREIGN KEY([NorwoodScaleID])
REFERENCES [dbo].[lkpNorwoodScale] ([NorwoodScaleID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpNorwoodScale]
GO
ALTER TABLE [dbo].[datClientDemographic]  WITH CHECK ADD  CONSTRAINT [FK_datClientDemographic_lkpOccupation] FOREIGN KEY([OccupationID])
REFERENCES [dbo].[lkpOccupation] ([OccupationID])
GO
ALTER TABLE [dbo].[datClientDemographic] CHECK CONSTRAINT [FK_datClientDemographic_lkpOccupation]
GO
