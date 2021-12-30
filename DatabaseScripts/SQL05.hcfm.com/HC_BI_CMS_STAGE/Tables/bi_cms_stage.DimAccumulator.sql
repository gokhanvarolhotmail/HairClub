/* CreateDate: 10/05/2010 14:04:01.360 , ModifyDate: 10/05/2010 14:04:01.593 */
GO
CREATE TABLE [bi_cms_stage].[DimAccumulator](
	[DataPkgKey] [int] NULL,
	[AccumulatorKey] [int] NULL,
	[AccumulatorSSID] [int] NULL,
	[AccumulatorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDataTypeSSID] [int] NULL,
	[AccumulatorDataTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDataTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedulerActionTypeSSID] [int] NULL,
	[SchedulerActionTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedulerActionTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedulerAdjustmentTypeSSID] [int] NULL,
	[SchedulerAdjustmentTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedulerAdjustmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimAccumulator] ADD  CONSTRAINT [DF_DimAccumulator_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
