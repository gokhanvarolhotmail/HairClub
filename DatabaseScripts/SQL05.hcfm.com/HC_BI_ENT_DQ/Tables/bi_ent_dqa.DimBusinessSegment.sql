/* CreateDate: 05/03/2010 12:09:05.163 , ModifyDate: 05/03/2010 12:09:05.500 */
GO
CREATE TABLE [bi_ent_dqa].[DimBusinessSegment](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DimBusinessSegment] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsDuplicate_1]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsInferredMember_1]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsException_1]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
