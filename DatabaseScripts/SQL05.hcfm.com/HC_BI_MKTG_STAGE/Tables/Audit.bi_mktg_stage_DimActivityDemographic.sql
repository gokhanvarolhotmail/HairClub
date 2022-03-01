/* CreateDate: 02/24/2022 08:54:23.870 , ModifyDate: 02/27/2022 21:41:28.963 */
GO
CREATE TABLE [Audit].[bi_mktg_stage_DimActivityDemographic](
	[LogId] [int] NOT NULL,
	[LogUser] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogAppName] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogDate] [datetime2](7) NOT NULL,
	[Action] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LogRowNum] [int] NOT NULL,
	[DataPkgKey] [int] NULL,
	[ActivityDemographicKey] [int] NULL,
	[ActivityDemographicSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderSSID] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [date] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [money] NULL,
	[SolutionOffered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateSaved] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DiscStyleSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [bi_mktg_stage_DimActivityDemographic_PKC] ON [Audit].[bi_mktg_stage_DimActivityDemographic]
(
	[LogId] ASC,
	[LogRowNum] ASC,
	[Action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
