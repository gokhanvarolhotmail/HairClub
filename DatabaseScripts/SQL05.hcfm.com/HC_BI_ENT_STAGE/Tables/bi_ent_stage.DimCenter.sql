/* CreateDate: 02/28/2017 15:02:42.380 , ModifyDate: 02/28/2017 15:02:42.967 */
GO
CREATE TABLE [bi_ent_stage].[DimCenter](
	[DataPkgKey] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[RegionKey] [int] NULL,
	[RegionSSID] [int] NULL,
	[TimeZoneKey] [int] NULL,
	[TimeZoneSSID] [int] NULL,
	[CenterTypeKey] [int] NULL,
	[CenterTypeSSID] [int] NULL,
	[DoctorRegionKey] [int] NULL,
	[DoctorRegionSSID] [int] NULL,
	[CenterOwnershipKey] [int] NULL,
	[CenterOwnershipSSID] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone1TypeSSID] [int] NULL,
	[CenterPhone1TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone1TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2TypeSSID] [int] NULL,
	[CenterPhone2TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone2TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone3TypeSSID] [int] NULL,
	[CenterPhone3TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone3TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportingCenterSSID] [int] NULL,
	[HasFullAccessFlag] [bit] NULL,
	[CenterBusinessTypeID] [int] NULL,
	[RegionRSMNBConsultantSSID] [uniqueidentifier] NULL,
	[RegionRSMMembershipAdvisorSSID] [uniqueidentifier] NULL,
	[RegionRTMTechnicalManagerSSID] [uniqueidentifier] NULL,
	[RegionROMOperationsManagerSSID] [uniqueidentifier] NULL,
	[CenterManagementAreaSSID] [int] NULL,
	[NewBusinessSize] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RecurringBusinessSize] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterNumber] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimCenter_CenterSSID_DataPkgKey] ON [bi_ent_stage].[DimCenter]
(
	[DataPkgKey] ASC,
	[CenterSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone1TypeSSID_1]  DEFAULT ((-2)) FOR [Phone1TypeSSID]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone2TypeSSID_1]  DEFAULT ((-2)) FOR [Phone2TypeSSID]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone3TypeSSID_1]  DEFAULT ((-2)) FOR [Phone3TypeSSID]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_ent_stage].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
