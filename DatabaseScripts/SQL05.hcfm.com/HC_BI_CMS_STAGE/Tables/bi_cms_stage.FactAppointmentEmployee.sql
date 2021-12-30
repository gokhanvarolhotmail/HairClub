/* CreateDate: 06/27/2011 16:44:15.707 , ModifyDate: 03/12/2014 16:18:40.417 */
GO
CREATE TABLE [bi_cms_stage].[FactAppointmentEmployee](
	[DataPkgKey] [int] NOT NULL,
	[AppointmentEmployeeKey] [int] NULL,
	[AppointmentEmployeeSSID] [uniqueidentifier] NULL,
	[AppointmentKey] [int] NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
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
	[ExceptionMessage] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentEmployee_DataPkgKey] ON [bi_cms_stage].[FactAppointmentEmployee]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
