/* CreateDate: 09/03/2021 09:37:05.227 , ModifyDate: 03/22/2022 23:17:11.577 */
GO
CREATE TABLE [bi_mktg_dds].[DimActivityDemographic](
	[ActivityDemographicKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActivityDemographicSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderSSID] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EthnicitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EthnicityDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaritalStatusSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaritalStatusDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Birthday] [date] NOT NULL,
	[Age] [int] NOT NULL,
	[AgeRangeSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AgeRangeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossTypeSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossTypeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NorwoodSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LudwigSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PriceQuoted] [money] NOT NULL,
	[SolutionOffered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NoSaleReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DateSaved] [date] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[DiscStyleSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimActivityDemographic] PRIMARY KEY CLUSTERED
(
	[ActivityDemographicKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [SFDC_DAD_TasKID] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[SFDC_TaskID] ASC
)
INCLUDE([Performer]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
