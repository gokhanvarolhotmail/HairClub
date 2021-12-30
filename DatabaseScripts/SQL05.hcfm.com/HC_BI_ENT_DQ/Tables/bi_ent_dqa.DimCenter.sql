/* CreateDate: 02/28/2017 15:04:08.837 , ModifyDate: 02/28/2017 15:04:09.277 */
GO
CREATE TABLE [bi_ent_dqa].[DimCenter](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
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
	[CenterNumber] [int] NOT NULL,
 CONSTRAINT [PK_DimCenter] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone1TypeSSID]  DEFAULT ((-2)) FOR [Phone1TypeSSID]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone2TypeSSID]  DEFAULT ((-2)) FOR [Phone2TypeSSID]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone3TypeSSID]  DEFAULT ((-2)) FOR [Phone3TypeSSID]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_ent_dqa].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
