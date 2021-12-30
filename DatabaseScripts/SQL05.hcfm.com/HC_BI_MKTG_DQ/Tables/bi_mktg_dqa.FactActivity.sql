/* CreateDate: 05/03/2010 12:22:42.657 , ModifyDate: 09/10/2020 11:17:34.583 */
GO
CREATE TABLE [bi_mktg_dqa].[FactActivity](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NOT NULL,
	[ActivityDateKey] [int] NULL,
	[ActivityDateSSID] [date] NULL,
	[ActivityTimeKey] [int] NULL,
	[ActivityTimeSSID] [time](0) NULL,
	[ActivityKey] [int] NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDueDateKey] [int] NULL,
	[ActivityDueDateSSID] [date] NULL,
	[ActivityStartTimeKey] [int] NULL,
	[ActivityStartTimeSSID] [time](0) NULL,
	[ActivityCompletedDateKey] [int] NULL,
	[ActivityCompletedDateSSID] [date] NULL,
	[ActivityCompletedTimeKey] [int] NULL,
	[ActivityCompletedTimeSSID] [time](0) NULL,
	[GenderKey] [int] NULL,
	[GenderSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[EthnicitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationKey] [int] NULL,
	[OccupationSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatusSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeKey] [int] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeKey] [int] NULL,
	[NorwoodSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeKey] [int] NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCodeKey] [int] NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityTypeKey] [int] NULL,
	[ActivityTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletedByEmployeeKey] [int] NULL,
	[CompletedByEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartedByEmployeeKey] [int] NULL,
	[StartedByEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[ActivityEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityEmployeeKey] [int] NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_FactActivity] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
