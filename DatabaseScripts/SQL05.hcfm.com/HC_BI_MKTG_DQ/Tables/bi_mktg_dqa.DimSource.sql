/* CreateDate: 05/03/2010 12:22:42.640 , ModifyDate: 12/08/2020 12:57:42.407 */
GO
CREATE TABLE [bi_mktg_dqa].[DimSource](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level02Location] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level03Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level04Format] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05Creative] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Number] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[CampaignName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Content] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimSource] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[DimSource] ADD  CONSTRAINT [DF_DimSource_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
