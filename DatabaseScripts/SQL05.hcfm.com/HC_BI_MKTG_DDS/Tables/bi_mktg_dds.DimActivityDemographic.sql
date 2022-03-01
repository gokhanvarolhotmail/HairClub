/* CreateDate: 05/03/2010 12:21:09.460 , ModifyDate: 02/24/2022 08:37:25.673 */
/* ***HasTriggers*** TriggerCount: 1 */
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
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_ActivityDemographicKey] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[ActivityDemographicKey] ASC
)
INCLUDE([SFDC_TaskID],[ActivityDemographicSSID],[GenderDescription],[EthnicityDescription],[OccupationDescription],[MaritalStatusDescription],[Birthday],[Age],[AgeRangeDescription],[HairLossTypeDescription],[Performer],[PriceQuoted],[SolutionOffered],[NoSaleReason],[DateSaved]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_ActivityDemographicKey_ActivityDemographicSSID] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[ActivityDemographicKey] ASC
)
INCLUDE([SFDC_TaskID],[ActivityDemographicSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_RowIsCurrent_ActivityDemographicSSID_ActivityDemographicKey] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[ActivityDemographicSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ActivityDemographicKey],[ActivitySSID],[ContactSSID],[SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_RowIsCurrent_SFDC_TaskID_INCL] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[SFDC_TaskID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ActivityDemographicKey],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityDemographic_ActivitySSID] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[ActivitySSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityDemographic_SFDC_TaskID] ON [bi_mktg_dds].[DimActivityDemographic]
(
	[SFDC_TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE TRIGGER [bi_mktg_dds].[TRG_bi_mktg_dds_DimActivityDemographic_Log]
ON [bi_mktg_dds].[DimActivityDemographic]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON ;

INSERT [Audit].[bi_mktg_dds_DimActivityDemographic]( [LogId]
                                                   , [LogUser]
                                                   , [LogAppName]
                                                   , [LogDate]
                                                   , [Action]
                                                   , [ActivityDemographicKey]
                                                   , [ActivityDemographicSSID]
                                                   , [ActivitySSID]
                                                   , [ContactSSID]
                                                   , [GenderSSID]
                                                   , [GenderDescription]
                                                   , [EthnicitySSID]
                                                   , [EthnicityDescription]
                                                   , [OccupationSSID]
                                                   , [OccupationDescription]
                                                   , [MaritalStatusSSID]
                                                   , [MaritalStatusDescription]
                                                   , [Birthday]
                                                   , [Age]
                                                   , [AgeRangeSSID]
                                                   , [AgeRangeDescription]
                                                   , [HairLossTypeSSID]
                                                   , [HairLossTypeDescription]
                                                   , [NorwoodSSID]
                                                   , [LudwigSSID]
                                                   , [Performer]
                                                   , [PriceQuoted]
                                                   , [SolutionOffered]
                                                   , [NoSaleReason]
                                                   , [DateSaved]
                                                   , [RowIsCurrent]
                                                   , [RowStartDate]
                                                   , [RowEndDate]
                                                   , [RowChangeReason]
                                                   , [RowIsInferred]
                                                   , [InsertAuditKey]
                                                   , [UpdateAuditKey]
                                                   , [RowTimeStamp]
                                                   , [DiscStyleSSID]
                                                   , [SFDC_TaskID]
                                                   , [SFDC_LeadID]
                                                   , [SFDC_PersonAccountID] )
SELECT
    ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[bi_mktg_dds_DimActivityDemographic] ORDER BY [LogId] DESC ), 1) AS [LogId]
  , SUSER_SNAME() AS [LogUser]
  , APP_NAME() AS [LogAppName]
  , GETDATE() AS [LogDate]
  , [k].[Action]
  , [k].[ActivityDemographicKey]
  , [k].[ActivityDemographicSSID]
  , [k].[ActivitySSID]
  , [k].[ContactSSID]
  , [k].[GenderSSID]
  , [k].[GenderDescription]
  , [k].[EthnicitySSID]
  , [k].[EthnicityDescription]
  , [k].[OccupationSSID]
  , [k].[OccupationDescription]
  , [k].[MaritalStatusSSID]
  , [k].[MaritalStatusDescription]
  , [k].[Birthday]
  , [k].[Age]
  , [k].[AgeRangeSSID]
  , [k].[AgeRangeDescription]
  , [k].[HairLossTypeSSID]
  , [k].[HairLossTypeDescription]
  , [k].[NorwoodSSID]
  , [k].[LudwigSSID]
  , [k].[Performer]
  , [k].[PriceQuoted]
  , [k].[SolutionOffered]
  , [k].[NoSaleReason]
  , [k].[DateSaved]
  , [k].[RowIsCurrent]
  , [k].[RowStartDate]
  , [k].[RowEndDate]
  , [k].[RowChangeReason]
  , [k].[RowIsInferred]
  , [k].[InsertAuditKey]
  , [k].[UpdateAuditKey]
  , [k].[RowTimeStamp]
  , [k].[DiscStyleSSID]
  , [k].[SFDC_TaskID]
  , [k].[SFDC_LeadID]
  , [k].[SFDC_PersonAccountID]
FROM( SELECT
          'D' AS [Action]
        , [ActivityDemographicKey]
        , [ActivityDemographicSSID]
        , [ActivitySSID]
        , [ContactSSID]
        , [GenderSSID]
        , [GenderDescription]
        , [EthnicitySSID]
        , [EthnicityDescription]
        , [OccupationSSID]
        , [OccupationDescription]
        , [MaritalStatusSSID]
        , [MaritalStatusDescription]
        , [Birthday]
        , [Age]
        , [AgeRangeSSID]
        , [AgeRangeDescription]
        , [HairLossTypeSSID]
        , [HairLossTypeDescription]
        , [NorwoodSSID]
        , [LudwigSSID]
        , [Performer]
        , [PriceQuoted]
        , [SolutionOffered]
        , [NoSaleReason]
        , [DateSaved]
        , [RowIsCurrent]
        , [RowStartDate]
        , [RowEndDate]
        , [RowChangeReason]
        , [RowIsInferred]
        , [InsertAuditKey]
        , [UpdateAuditKey]
        , [RowTimeStamp]
        , [DiscStyleSSID]
        , [SFDC_TaskID]
        , [SFDC_LeadID]
        , [SFDC_PersonAccountID]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
        , [ActivityDemographicKey]
        , [ActivityDemographicSSID]
        , [ActivitySSID]
        , [ContactSSID]
        , [GenderSSID]
        , [GenderDescription]
        , [EthnicitySSID]
        , [EthnicityDescription]
        , [OccupationSSID]
        , [OccupationDescription]
        , [MaritalStatusSSID]
        , [MaritalStatusDescription]
        , [Birthday]
        , [Age]
        , [AgeRangeSSID]
        , [AgeRangeDescription]
        , [HairLossTypeSSID]
        , [HairLossTypeDescription]
        , [NorwoodSSID]
        , [LudwigSSID]
        , [Performer]
        , [PriceQuoted]
        , [SolutionOffered]
        , [NoSaleReason]
        , [DateSaved]
        , [RowIsCurrent]
        , [RowStartDate]
        , [RowEndDate]
        , [RowChangeReason]
        , [RowIsInferred]
        , [InsertAuditKey]
        , [UpdateAuditKey]
        , [RowTimeStamp]
        , [DiscStyleSSID]
        , [SFDC_TaskID]
        , [SFDC_LeadID]
        , [SFDC_PersonAccountID]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
ALTER TABLE [bi_mktg_dds].[DimActivityDemographic] ENABLE TRIGGER [TRG_bi_mktg_dds_DimActivityDemographic_Log]
GO
