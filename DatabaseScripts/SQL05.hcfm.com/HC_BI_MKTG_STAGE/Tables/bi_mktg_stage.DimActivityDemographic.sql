/* CreateDate: 05/03/2010 12:26:20.467 , ModifyDate: 02/24/2022 08:54:30.407 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [bi_mktg_stage].[DimActivityDemographic](
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
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_ActivityDemographicSSID_DataPkgKey] ON [bi_mktg_stage].[DimActivityDemographic]
(
	[DataPkgKey] ASC,
	[ActivityDemographicSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded],[ActivitySSID],[ContactSSID],[SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityDemographic_DataPkgKey_SFDC_TaskID_INCL] ON [bi_mktg_stage].[DimActivityDemographic]
(
	[DataPkgKey] ASC,
	[SFDC_TaskID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityDemographic_DataPkgKey_ActivityDemographicSSID] ON [bi_mktg_stage].[DimActivityDemographic]
(
	[DataPkgKey] ASC
)
INCLUDE([ActivityDemographicSSID],[ActivitySSID],[ContactSSID],[SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityDemographic_DataPkgKey_INCL] ON [bi_mktg_stage].[DimActivityDemographic]
(
	[DataPkgKey] ASC
)
INCLUDE([SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ADD  CONSTRAINT [DF_DimActivityDemographic_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
CREATE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
ON [bi_mktg_stage].[DimActivityDemographic]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON ;

INSERT [Audit].[bi_mktg_stage_DimActivityDemographic]( [LogId]
                                                     , [LogUser]
                                                     , [LogAppName]
                                                     , [LogDate]
                                                     , [Action]
                                                     , [LogRowNum]
                                                     , [DataPkgKey]
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
                                                     , [ModifiedDate]
                                                     , [IsNew]
                                                     , [IsType1]
                                                     , [IsType2]
                                                     , [IsDelete]
                                                     , [IsDuplicate]
                                                     , [IsInferredMember]
                                                     , [IsException]
                                                     , [IsHealthy]
                                                     , [IsRejected]
                                                     , [IsAllowed]
                                                     , [IsFixed]
                                                     , [SourceSystemKey]
                                                     , [RuleKey]
                                                     , [DataQualityAuditKey]
                                                     , [IsNewDQA]
                                                     , [IsValidated]
                                                     , [IsLoaded]
                                                     , [CDC_Operation]
                                                     , [DiscStyleSSID]
                                                     , [SFDC_TaskID]
                                                     , [SFDC_LeadID]
                                                     , [SFDC_PersonAccountID] )
SELECT
    ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[bi_mktg_stage_DimActivityDemographic] ORDER BY [LogId] DESC ), 1) AS [LogId]
  , SUSER_SNAME() AS [LogUser]
  , APP_NAME() AS [LogAppName]
  , GETDATE() AS [LogDate]
  , [k].[Action]
  , [k].[LogRowNum]
  , [k].[DataPkgKey]
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
  , [k].[ModifiedDate]
  , [k].[IsNew]
  , [k].[IsType1]
  , [k].[IsType2]
  , [k].[IsDelete]
  , [k].[IsDuplicate]
  , [k].[IsInferredMember]
  , [k].[IsException]
  , [k].[IsHealthy]
  , [k].[IsRejected]
  , [k].[IsAllowed]
  , [k].[IsFixed]
  , [k].[SourceSystemKey]
  , [k].[RuleKey]
  , [k].[DataQualityAuditKey]
  , [k].[IsNewDQA]
  , [k].[IsValidated]
  , [k].[IsLoaded]
  , [k].[CDC_Operation]
  , [k].[DiscStyleSSID]
  , [k].[SFDC_TaskID]
  , [k].[SFDC_LeadID]
  , [k].[SFDC_PersonAccountID]
FROM( SELECT
          'D' AS [Action]
        , ROW_NUMBER() OVER ( ORDER BY( SELECT 0 )) AS [LogRowNum]
        , [d].[DataPkgKey]
        , [d].[ActivityDemographicKey]
        , [d].[ActivityDemographicSSID]
        , [d].[ActivitySSID]
        , [d].[ContactSSID]
        , [d].[GenderSSID]
        , [d].[GenderDescription]
        , [d].[EthnicitySSID]
        , [d].[EthnicityDescription]
        , [d].[OccupationSSID]
        , [d].[OccupationDescription]
        , [d].[MaritalStatusSSID]
        , [d].[MaritalStatusDescription]
        , [d].[Birthday]
        , [d].[Age]
        , [d].[AgeRangeSSID]
        , [d].[AgeRangeDescription]
        , [d].[HairLossTypeSSID]
        , [d].[HairLossTypeDescription]
        , [d].[NorwoodSSID]
        , [d].[LudwigSSID]
        , [d].[Performer]
        , [d].[PriceQuoted]
        , [d].[SolutionOffered]
        , [d].[NoSaleReason]
        , [d].[DateSaved]
        , [d].[ModifiedDate]
        , [d].[IsNew]
        , [d].[IsType1]
        , [d].[IsType2]
        , [d].[IsDelete]
        , [d].[IsDuplicate]
        , [d].[IsInferredMember]
        , [d].[IsException]
        , [d].[IsHealthy]
        , [d].[IsRejected]
        , [d].[IsAllowed]
        , [d].[IsFixed]
        , [d].[SourceSystemKey]
        , [d].[RuleKey]
        , [d].[DataQualityAuditKey]
        , [d].[IsNewDQA]
        , [d].[IsValidated]
        , [d].[IsLoaded]
        , [d].[CDC_Operation]
        , [d].[DiscStyleSSID]
        , [d].[SFDC_TaskID]
        , [d].[SFDC_LeadID]
        , [d].[SFDC_PersonAccountID]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
        , ROW_NUMBER() OVER ( ORDER BY( SELECT 0 )) AS [LogRowNum]
        , [i].[DataPkgKey]
        , [i].[ActivityDemographicKey]
        , [i].[ActivityDemographicSSID]
        , [i].[ActivitySSID]
        , [i].[ContactSSID]
        , [i].[GenderSSID]
        , [i].[GenderDescription]
        , [i].[EthnicitySSID]
        , [i].[EthnicityDescription]
        , [i].[OccupationSSID]
        , [i].[OccupationDescription]
        , [i].[MaritalStatusSSID]
        , [i].[MaritalStatusDescription]
        , [i].[Birthday]
        , [i].[Age]
        , [i].[AgeRangeSSID]
        , [i].[AgeRangeDescription]
        , [i].[HairLossTypeSSID]
        , [i].[HairLossTypeDescription]
        , [i].[NorwoodSSID]
        , [i].[LudwigSSID]
        , [i].[Performer]
        , [i].[PriceQuoted]
        , [i].[SolutionOffered]
        , [i].[NoSaleReason]
        , [i].[DateSaved]
        , [i].[ModifiedDate]
        , [i].[IsNew]
        , [i].[IsType1]
        , [i].[IsType2]
        , [i].[IsDelete]
        , [i].[IsDuplicate]
        , [i].[IsInferredMember]
        , [i].[IsException]
        , [i].[IsHealthy]
        , [i].[IsRejected]
        , [i].[IsAllowed]
        , [i].[IsFixed]
        , [i].[SourceSystemKey]
        , [i].[RuleKey]
        , [i].[DataQualityAuditKey]
        , [i].[IsNewDQA]
        , [i].[IsValidated]
        , [i].[IsLoaded]
        , [i].[CDC_Operation]
        , [i].[DiscStyleSSID]
        , [i].[SFDC_TaskID]
        , [i].[SFDC_LeadID]
        , [i].[SFDC_PersonAccountID]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
ALTER TABLE [bi_mktg_stage].[DimActivityDemographic] ENABLE TRIGGER [TRG_bi_mktg_stage_DimActivityDemographic_Log]
GO
