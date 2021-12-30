/* CreateDate: 06/27/2011 16:44:15.930 , ModifyDate: 06/27/2011 16:45:47.480 */
GO
CREATE TABLE [bi_cms_stage].[DimHairSystemRecession](
	[DataPkgKey] [int] NULL,
	[HairSystemRecessionKey] [int] NULL,
	[HairSystemRecessionSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemRecessionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemRecessionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemRecessionSortOrder] [int] NULL,
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
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemRecession] ADD  CONSTRAINT [DF_DimHairSystemRecession_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
