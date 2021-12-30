/* CreateDate: 05/05/2020 17:42:49.013 , ModifyDate: 05/05/2020 18:41:00.240 */
GO
CREATE TABLE [dbo].[datClientDemographic](
	[ClientDemographicID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClientDemographic_ClientIdentifier] ON [dbo].[datClientDemographic]
(
	[ClientIdentifier] ASC
)
INCLUDE([EthnicityID],[OccupationID],[MaritalStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
