/* CreateDate: 10/26/2011 12:14:46.460 , ModifyDate: 01/18/2021 20:28:54.677 */
GO
CREATE TABLE [bi_mktg_stage].[FactActivityResults](
	[DataPkgKey] [int] NOT NULL,
	[ActivityResultDateKey] [int] NULL,
	[ActivityResultDateSSID] [date] NULL,
	[ActivityResultKey] [int] NULL,
	[ActivityResultSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityResultTimeKey] [int] NULL,
	[ActivityResultTimeSSID] [time](0) NULL,
	[ActivityKey] [int] NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDateKey] [int] NULL,
	[ActivityDateSSID] [date] NULL,
	[ActivityTimeKey] [int] NULL,
	[ActivityTimeSSID] [time](0) NULL,
	[ActivityDueDateKey] [int] NULL,
	[ActivityDueDateSSID] [date] NULL,
	[ActivityStartTimeKey] [int] NULL,
	[ActivityStartTimeSSID] [time](0) NULL,
	[ActivityCompletedDateKey] [int] NULL,
	[ActivityCompletedDateSSID] [date] NULL,
	[ActivityCompletedTimeKey] [int] NULL,
	[ActivityCompletedTimeSSID] [time](0) NULL,
	[OriginalAppointmentDateKey] [int] NULL,
	[OriginalAppointmentDateSSID] [date] NULL,
	[ActivitySavedDateKey] [int] NULL,
	[ActivitySavedDateSSID] [date] NULL,
	[ActivitySavedTimeKey] [int] NULL,
	[ActivitySavedTimeSSID] [time](0) NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeKey] [int] NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeKey] [int] NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCodeKey] [int] NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[GenderSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationKey] [int] NULL,
	[OccupationSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[EthnicitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatusSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeKey] [int] NULL,
	[HairLossTypeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeKey] [int] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletedByEmployeeKey] [int] NULL,
	[CompletedByEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleNoSaleFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShowNoShowFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurgeryOfferedFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferredToDoctorFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointments] [int] NULL,
	[Show] [int] NULL,
	[NoShow] [int] NULL,
	[Sale] [int] NULL,
	[NoSale] [int] NULL,
	[Consultation] [int] NULL,
	[BeBack] [int] NULL,
	[SurgeryOffered] [int] NULL,
	[ReferredToDoctor] [int] NULL,
	[InitialPayment] [decimal](15, 4) NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
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
	[ActivityEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityEmployeeKey] [int] NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResolutionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceKey] [int] NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[PromoCodeKey] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_FactActivityResults_ActivityResultSSID_DataPkgKey] ON [bi_mktg_stage].[FactActivityResults]
(
	[DataPkgKey] ASC,
	[ActivityResultSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsUpdate] ASC,
	[IsDelete] ASC,
	[IsDuplicate] ASC
)
INCLUDE([IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_FactActivityResults_DataPkgKey_SFDC_TaskID_INCL] ON [bi_mktg_stage].[FactActivityResults]
(
	[DataPkgKey] ASC,
	[SFDC_TaskID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsUpdate] ASC,
	[IsDelete] ASC,
	[IsDuplicate] ASC
)
INCLUDE([IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_ActivitySSID] ON [bi_mktg_stage].[FactActivityResults]
(
	[ActivitySSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_DataPkgKey_ActivityResultSSID] ON [bi_mktg_stage].[FactActivityResults]
(
	[DataPkgKey] ASC
)
INCLUDE([ActivityResultSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_SFDC_TaskID] ON [bi_mktg_stage].[FactActivityResults]
(
	[SFDC_TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
