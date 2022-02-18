/* CreateDate: 05/03/2010 12:21:09.693 , ModifyDate: 01/27/2022 09:18:11.580 */
GO
CREATE TABLE [bi_mktg_dds].[FactActivity](
	[ActivityDateKey] [int] NOT NULL,
	[ActivityKey] [int] NOT NULL,
	[ActivityTimeKey] [int] NOT NULL,
	[ActivityCompletedDateKey] [int] NOT NULL,
	[ActivityCompletedTimeKey] [int] NOT NULL,
	[ActivityDueDateKey] [int] NOT NULL,
	[ActivityStartTimeKey] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[EthnicityKey] [int] NOT NULL,
	[OccupationKey] [int] NOT NULL,
	[MaritalStatusKey] [int] NOT NULL,
	[AgeRangeKey] [int] NOT NULL,
	[HairLossTypeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[ContactKey] [int] NOT NULL,
	[ActionCodeKey] [int] NOT NULL,
	[ResultCodeKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ActivityTypeKey] [int] NOT NULL,
	[CompletedByEmployeeKey] [int] NOT NULL,
	[StartedByEmployeeKey] [int] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[ActivityEmployeeKey] [int] NULL,
 CONSTRAINT [PK_FactActivity] PRIMARY KEY CLUSTERED
(
	[ActivityDateKey] ASC,
	[ActivityKey] ASC,
	[ActivityTimeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactActivity_ActivityKey] ON [bi_mktg_dds].[FactActivity]
(
	[ActivityKey] ASC
)
INCLUDE([ActivityDateKey],[ActivityTimeKey],[ActivityCompletedDateKey],[ActivityCompletedTimeKey],[ActivityDueDateKey],[ActivityStartTimeKey],[GenderKey],[EthnicityKey],[OccupationKey],[MaritalStatusKey],[AgeRangeKey],[HairLossTypeKey],[CenterKey],[ContactKey],[ActionCodeKey],[ResultCodeKey],[SourceKey],[ActivityTypeKey],[CompletedByEmployeeKey],[StartedByEmployeeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivity_ActivityEmployeeKey] ON [bi_mktg_dds].[FactActivity]
(
	[ActivityEmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivity_ContactKey_INCL] ON [bi_mktg_dds].[FactActivity]
(
	[ContactKey] ASC
)
INCLUDE([ActivityKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dds].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_mktg_dds].[FactActivity] ADD  CONSTRAINT [DF_FactActivity_InsertAuditKey1]  DEFAULT ((0)) FOR [UpdateAuditKey]
GO
