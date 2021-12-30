/* CreateDate: 02/02/2011 16:19:49.380 , ModifyDate: 11/26/2018 14:51:37.503 */
GO
CREATE TABLE [bi_mktg_stage].[DimPromotionCode](
	[DataPkgKey] [int] NULL,
	[PromotionCodeKey] [int] NULL,
	[PromotionCodeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
