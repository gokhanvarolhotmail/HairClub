/* CreateDate: 05/03/2010 12:09:05.347 , ModifyDate: 05/03/2010 12:09:05.907 */
GO
CREATE TABLE [bi_ent_dqa].[DimTimeZone](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[TimeZoneKey] [int] NULL,
	[TimeZoneSSID] [int] NULL,
	[TimeZoneDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZoneDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
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
 CONSTRAINT [PK_DimTimeZone] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_UsesDayLightSavingsFlag_1]  DEFAULT ((1)) FOR [UsesDayLightSavingsFlag]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimTimeZone] ADD  CONSTRAINT [DF_DimTimeZone_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
