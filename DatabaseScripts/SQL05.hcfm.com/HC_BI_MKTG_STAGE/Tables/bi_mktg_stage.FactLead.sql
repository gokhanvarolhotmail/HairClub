/* CreateDate: 10/26/2011 12:14:33.060 , ModifyDate: 11/25/2021 19:53:43.567 */
GO
CREATE TABLE [bi_mktg_stage].[FactLead](
	[DataPkgKey] [int] NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationDateSSID] [date] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[LeadCreationTimeSSID] [time](7) NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[GenderSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationKey] [int] NULL,
	[OccupationSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[EthnicitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatusSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeKey] [int] NULL,
	[HairLossTypeSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeKey] [int] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [int] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCodeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCodeKey] [int] NULL,
	[SalesTypeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeKey] [int] NULL,
	[Leads] [int] NULL,
	[Appointments] [int] NULL,
	[Shows] [int] NULL,
	[Sales] [int] NULL,
	[Activities] [int] NULL,
	[NoShows] [int] NULL,
	[NoSales] [int] NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignedEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignedEmployeeKey] [int] NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResolutionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SHOWDIFF] [int] NULL,
	[SALEDIFF] [int] NULL,
	[QuestionAge] [int] NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecentSourceSSID] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecentSourceKey] [int] NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvalidLead] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_FactLead_SFDC_LeadID_DataPkgKey] ON [bi_mktg_stage].[FactLead]
(
	[DataPkgKey] ASC,
	[SFDC_LeadID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsUpdate] ASC,
	[IsDelete] ASC,
	[IsDuplicate] ASC
)
INCLUDE([IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactLead_DataPkgKey_ContactSSID] ON [bi_mktg_stage].[FactLead]
(
	[DataPkgKey] ASC
)
INCLUDE([ContactSSID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_FactLead_DataPkgKey_ContactKey] ON [bi_mktg_stage].[FactLead]
(
	[DataPkgKey] ASC,
	[ContactKey] ASC
)
INCLUDE([IsException]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsDelete1]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
