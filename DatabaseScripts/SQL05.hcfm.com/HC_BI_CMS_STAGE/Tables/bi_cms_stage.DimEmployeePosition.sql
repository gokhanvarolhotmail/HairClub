/* CreateDate: 08/02/2012 13:39:00.813 , ModifyDate: 08/02/2012 13:39:01.487 */
GO
CREATE TABLE [bi_cms_stage].[DimEmployeePosition](
	[DataPkgKey] [int] NULL,
	[EmployeePositionKey] [int] NULL,
	[EmployeePositionSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeePositionSortOrder] [int] NULL,
	[ActiveDirectoryGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAdministratorFlag] [bit] NULL,
	[IsEmployeeOneFlag] [bit] NULL,
	[IsEmployeeTwoFlag] [bit] NULL,
	[IsEmployeeThreeFlag] [bit] NULL,
	[IsEmployeeFourFlag] [bit] NULL,
	[CanScheduleFlag] [bit] NULL,
	[ApplicationTimeoutMinutes] [int] NULL,
	[UseDefaultCenterFlag] [bit] NULL,
	[IsSurgeryCenterEmployeeFlag] [bit] NULL,
	[IsNonSurgeryCenterEmployeeFlag] [bit] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimEmployeePosition] ADD  CONSTRAINT [DF_DimEmployeePosition_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
