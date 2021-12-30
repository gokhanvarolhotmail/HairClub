/* CreateDate: 06/27/2011 16:44:15.217 , ModifyDate: 10/26/2011 11:46:17.923 */
GO
CREATE TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee](
	[DataPkgKey] [int] NOT NULL,
	[SurgeryCloseOutEmployeeKey] [int] NULL,
	[SurgeryCloseOutEmployeeSSID] [uniqueidentifier] NULL,
	[AppointmentKey] [int] NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
	[CutCount] [int] NULL,
	[PlaceCount] [int] NULL,
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
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
