/* CreateDate: 02/03/2011 16:30:07.947 , ModifyDate: 06/10/2021 09:43:00.870 */
GO
CREATE TABLE [bi_mktg_dqa].[FactLead](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationDateSSID] [date] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[LeadCreationTimeSSID] [time](7) NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[GenderSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationKey] [int] NULL,
	[OccupationSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[EthnicitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatusSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[AssignedEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssignedEmployeeKey] [int] NULL,
	[SHOWDIFF] [int] NULL,
	[SALEDIFF] [int] NULL,
	[QuestionAge] [int] NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecentSourceKey] [int] NULL,
	[RecentSourceSSID] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvalidLead] [int] NULL,
 CONSTRAINT [PK_FactLead] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsNew_1]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[FactLead] ADD  CONSTRAINT [DF_FactLead_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
