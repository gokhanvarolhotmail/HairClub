/* CreateDate: 07/11/2011 11:56:15.280 , ModifyDate: 07/11/2011 11:56:15.483 */
GO
CREATE TABLE [bi_ent_dqa].[DimRegion](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[RegionKey] [int] NULL,
	[RegionSSID] [int] NULL,
	[RegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionSortOrder] [int] NULL,
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
 CONSTRAINT [PK_DimRegion] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
