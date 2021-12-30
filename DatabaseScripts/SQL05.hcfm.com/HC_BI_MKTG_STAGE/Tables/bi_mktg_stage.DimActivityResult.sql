/* CreateDate: 05/03/2010 12:26:20.513 , ModifyDate: 01/18/2021 20:27:17.250 */
GO
CREATE TABLE [bi_mktg_stage].[DimActivityResult](
	[DataPkgKey] [int] NULL,
	[ActivityResultKey] [int] NULL,
	[ActivityResultSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsShow] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSale] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractNumber] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractAmount] [decimal](15, 4) NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitialPayment] [decimal](15, 4) NULL,
	[NumberOfGraphs] [int] NULL,
	[OrigApptDate] [date] NULL,
	[DateSaved] [date] NULL,
	[RescheduledFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RescheduledDate] [date] NULL,
	[SurgeryOffered] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferredToDoctor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityResult_ActivityResultSSID_DataPkgKey] ON [bi_mktg_stage].[DimActivityResult]
(
	[DataPkgKey] ASC,
	[ActivityResultSSID] ASC,
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
CREATE NONCLUSTERED INDEX [IDX_DimActivityResult_DataPkgKey_SFDC_TaskID_INCL] ON [bi_mktg_stage].[DimActivityResult]
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
CREATE NONCLUSTERED INDEX [IX_DimActivityResult_DataPkgKey_ActivityResultSSID] ON [bi_mktg_stage].[DimActivityResult]
(
	[DataPkgKey] ASC
)
INCLUDE([ActivityResultSSID],[ActivitySSID],[ContactSSID],[SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityResult_DataPkgKey_INCL] ON [bi_mktg_stage].[DimActivityResult]
(
	[DataPkgKey] ASC
)
INCLUDE([SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ActionCodeSSID_1]  DEFAULT ('') FOR [ActionCodeSSID]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ActionCodeDescription_1]  DEFAULT ('') FOR [ActionCodeDescription]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ResultCodeSSID_1]  DEFAULT ('') FOR [ResultCodeSSID]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ResultCodeDescription_1]  DEFAULT ('') FOR [ResultCodeDescription]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_SourceSSID_1]  DEFAULT ('') FOR [SourceSSID]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_SourceDescription_1]  DEFAULT ('') FOR [SourceDescription]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
