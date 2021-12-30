/* CreateDate: 08/02/2012 10:20:35.790 , ModifyDate: 08/02/2012 10:20:36.090 */
GO
CREATE TABLE [bi_cms_stage].[FactEmployeeSecurity](
	[DataPkgKey] [int] NOT NULL,
	[EmployeeSecurityKey] [int] NULL,
	[EmployeeSecuritySSID] [uniqueidentifier] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
	[EmployeePositionKey] [int] NULL,
	[EmployeePositionSSID] [int] NULL,
	[ActiveDirectoryGroupKey] [int] NULL,
	[ActiveDirectoryGroupSSID] [int] NULL,
	[HasAccess] [int] NULL,
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
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
