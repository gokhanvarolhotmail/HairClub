/* CreateDate: 06/27/2011 16:44:16.143 , ModifyDate: 06/27/2011 16:45:46.793 */
GO
CREATE TABLE [bi_cms_stage].[DimHairSystemDensity](
	[DataPkgKey] [int] NULL,
	[HairSystemDensityKey] [int] NULL,
	[HairSystemDensitySSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemDensitySortOrder] [int] NULL,
	[HairSystemDensityDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemDensityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemDensity] ADD  CONSTRAINT [DF_DimHairSystemDensity_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
