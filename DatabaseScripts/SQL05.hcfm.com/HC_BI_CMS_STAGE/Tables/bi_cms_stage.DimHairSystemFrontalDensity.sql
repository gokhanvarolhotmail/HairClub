/* CreateDate: 06/27/2011 16:44:16.083 , ModifyDate: 06/27/2011 16:45:46.957 */
GO
CREATE TABLE [bi_cms_stage].[DimHairSystemFrontalDensity](
	[DataPkgKey] [int] NULL,
	[HairSystemFrontalDensityKey] [int] NULL,
	[HairSystemFrontalDensitySSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFrontalDensityDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFrontalDensityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFrontalDensitySortOrder] [int] NULL,
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
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemFrontalDensity] ADD  CONSTRAINT [DF_DimHairSystemFrontalDensity_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
