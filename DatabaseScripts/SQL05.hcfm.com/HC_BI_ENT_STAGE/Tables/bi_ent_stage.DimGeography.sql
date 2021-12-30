/* CreateDate: 05/03/2010 12:09:34.887 , ModifyDate: 03/22/2017 21:17:27.273 */
GO
CREATE TABLE [bi_ent_stage].[DimGeography](
	[DataPkgKey] [int] NULL,
	[GeographyKey] [int] NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE NONCLUSTERED INDEX [IDX_DimGeography_GeographySSID_DataPkgKey] ON [bi_ent_stage].[DimGeography]
(
	[DataPkgKey] ASC,
	[PostalCode] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_ent_stage].[DimGeography] ADD  CONSTRAINT [DF_DimGeography_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
