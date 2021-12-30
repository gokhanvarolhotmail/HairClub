/* CreateDate: 05/03/2010 12:26:20.373 , ModifyDate: 08/12/2012 16:30:44.247 */
GO
CREATE TABLE [bi_mktg_stage].[DimActionCode](
	[DataPkgKey] [int] NULL,
	[ActionCodeKey] [int] NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActionCode_ActionCodeSSID_DataPkgKey] ON [bi_mktg_stage].[DimActionCode]
(
	[DataPkgKey] ASC,
	[ActionCodeSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsNew1]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_mktg_stage].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_IsValidated1]  DEFAULT ((0)) FOR [IsLoaded]
GO
