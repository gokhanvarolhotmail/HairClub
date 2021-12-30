/* CreateDate: 05/03/2010 12:09:34.803 , ModifyDate: 05/14/2010 13:42:10.403 */
GO
CREATE TABLE [bi_ent_stage].[DimBusinessSegment](
	[DataPkgKey] [int] NULL,
	[BusinessSegmentKey] [int] NULL,
	[BusinessSegmentSSID] [int] NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessUnitKey] [int] NULL,
	[BusinessUnitSSID] [int] NULL,
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
CREATE NONCLUSTERED INDEX [IDX_DimBusinessSegment_BusinessSegmentSSID_DataPkgKey] ON [bi_ent_stage].[DimBusinessSegment]
(
	[DataPkgKey] ASC,
	[BusinessSegmentSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsDeleted]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsFixed1]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsException1]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsRejected1]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsAllowed1]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_ent_stage].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
