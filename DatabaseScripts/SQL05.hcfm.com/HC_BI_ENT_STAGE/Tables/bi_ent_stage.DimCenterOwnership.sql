/* CreateDate: 05/03/2010 12:09:34.850 , ModifyDate: 05/14/2010 13:43:10.660 */
GO
CREATE TABLE [bi_ent_stage].[DimCenterOwnership](
	[DataPkgKey] [int] NULL,
	[CenterOwnershipKey] [int] NULL,
	[CenterOwnershipSSID] [int] NULL,
	[GeographyKey] [int] NULL,
	[CenterOwnershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterOwnershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerLastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerFirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CorporateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE NONCLUSTERED INDEX [IDX_DimCenterOwnership_CenterOwnershipSSID_DataPkgKey] ON [bi_ent_stage].[DimCenterOwnership]
(
	[DataPkgKey] ASC,
	[CenterOwnershipSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_ent_stage].[DimCenterOwnership] ADD  CONSTRAINT [DF_DimCenterOwnership_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
