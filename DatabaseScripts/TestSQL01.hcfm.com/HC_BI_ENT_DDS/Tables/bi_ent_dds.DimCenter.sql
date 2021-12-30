/* CreateDate: 07/11/2011 12:03:56.377 , ModifyDate: 09/16/2019 09:25:18.663 */
GO
CREATE TABLE [bi_ent_dds].[DimCenter](
	[CenterKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[RegionKey] [int] NOT NULL,
	[RegionSSID] [int] NOT NULL,
	[TimeZoneKey] [int] NOT NULL,
	[TimeZoneSSID] [int] NOT NULL,
	[CenterTypeKey] [int] NOT NULL,
	[CenterTypeSSID] [int] NOT NULL,
	[DoctorRegionKey] [int] NOT NULL,
	[DoctorRegionSSID] [int] NOT NULL,
	[CenterOwnershipKey] [int] NOT NULL,
	[CenterOwnershipSSID] [int] NOT NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterAddress3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateProvinceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone1] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone1TypeSSID] [int] NOT NULL,
	[CenterPhone1TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone1TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone2] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone2TypeSSID] [int] NOT NULL,
	[CenterPhone2TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone2TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone3] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Phone3TypeSSID] [int] NOT NULL,
	[CenterPhone3TypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhone3TypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[ReportingCenterSSID] [int] NULL,
	[ReportingCenterKey] [int] NULL,
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
	[CenterDescriptionNumber]  AS ((([CenterDescription]+' (')+CONVERT([nvarchar](50),[CenterNumber],(0)))+')'),
 CONSTRAINT [PK_DimCenter] PRIMARY KEY CLUSTERED
(
	[CenterKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimCenter_RowIsCurrent_CenterSSID_CenterKey] ON [bi_ent_dds].[DimCenter]
(
	[CenterSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([CenterKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimCenter_CenterNumber] ON [bi_ent_dds].[DimCenter]
(
	[CenterNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone1TypeSSID]  DEFAULT ((-2)) FOR [Phone1TypeSSID]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone2TypeSSID]  DEFAULT ((-2)) FOR [Phone2TypeSSID]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_Phone3TypeSSID]  DEFAULT ((-2)) FOR [Phone3TypeSSID]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [DF_DimCenter_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  CONSTRAINT [MSrepl_tran_version_default_A8F58B2C_6366_47BE_A6FC_D73E3F5A0B81_133575514]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  DEFAULT ('Unknown') FOR [NewBusinessSize]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  DEFAULT ('Unknown') FOR [RecurringBusinessSize]
GO
ALTER TABLE [bi_ent_dds].[DimCenter] ADD  DEFAULT ((0)) FOR [CenterNumber]
GO
