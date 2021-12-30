/* CreateDate: 06/27/2011 16:44:16.037 , ModifyDate: 06/27/2011 16:45:47.217 */
GO
CREATE TABLE [bi_cms_stage].[DimHairSystemHairLength](
	[DataPkgKey] [int] NULL,
	[HairSystemHairLengthKey] [int] NULL,
	[HairSystemHairLengthSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairLengthDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairLengthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairLengthValue] [int] NULL,
	[HairSystemHairLengthSortOrder] [int] NULL,
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
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemHairLength] ADD  CONSTRAINT [DF_DimHairSystemHairLength_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
