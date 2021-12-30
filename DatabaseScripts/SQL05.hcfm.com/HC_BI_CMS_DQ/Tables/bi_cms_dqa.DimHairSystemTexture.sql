/* CreateDate: 06/27/2011 16:39:44.513 , ModifyDate: 06/27/2011 16:39:45.417 */
GO
CREATE TABLE [bi_cms_dqa].[DimHairSystemTexture](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[HairSystemTextureKey] [int] NULL,
	[HairSystemTextureSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemTextureDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemTextureDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemTextureSortOrder] [int] NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DimHairSystemTexture] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimHairSystemTexture] ADD  CONSTRAINT [DF_DimHairSystemTexture_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
