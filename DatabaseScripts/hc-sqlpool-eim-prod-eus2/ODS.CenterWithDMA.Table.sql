/****** Object:  Table [ODS].[CenterWithDMA]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[CenterWithDMA]
(
	[CenterKey] [varchar](8000) NULL,
	[CenterSSID] [varchar](8000) NULL,
	[RegionKey] [varchar](8000) NULL,
	[RegionSSID] [varchar](8000) NULL,
	[TimeZoneKey] [varchar](8000) NULL,
	[TimeZoneSSID] [varchar](8000) NULL,
	[CenterTypeKey] [varchar](8000) NULL,
	[CenterTypeSSID] [varchar](8000) NULL,
	[DoctorRegionKey] [varchar](8000) NULL,
	[DoctorRegionSSID] [varchar](8000) NULL,
	[CenterOwnershipKey] [varchar](8000) NULL,
	[CenterOwnershipSSID] [varchar](8000) NULL,
	[CenterDescription] [varchar](8000) NULL,
	[CenterAddress1] [varchar](8000) NULL,
	[CenterAddress2] [varchar](8000) NULL,
	[CenterAddress3] [varchar](8000) NULL,
	[CountryRegionDescription] [varchar](8000) NULL,
	[CountryRegionDescriptionShort] [varchar](8000) NULL,
	[StateProvinceDescription] [varchar](8000) NULL,
	[StateProvinceDescriptionShort] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[CenterPhone1] [varchar](8000) NULL,
	[Phone1TypeSSID] [varchar](8000) NULL,
	[CenterPhone1TypeDescription] [varchar](8000) NULL,
	[CenterPhone1TypeDescriptionShort] [varchar](8000) NULL,
	[CenterPhone2] [varchar](8000) NULL,
	[Phone2TypeSSID] [varchar](8000) NULL,
	[CenterPhone2TypeDescription] [varchar](8000) NULL,
	[CenterPhone2TypeDescriptionShort] [varchar](8000) NULL,
	[CenterPhone3] [varchar](8000) NULL,
	[Phone3TypeSSID] [varchar](8000) NULL,
	[CenterPhone3TypeDescription] [varchar](8000) NULL,
	[CenterPhone3TypeDescriptionShort] [varchar](8000) NULL,
	[Active] [varchar](8000) NULL,
	[RowIsCurrent] [varchar](8000) NULL,
	[RowStartDate] [varchar](8000) NULL,
	[RowEndDate] [varchar](8000) NULL,
	[RowChangeReason] [varchar](8000) NULL,
	[RowIsInferred] [varchar](8000) NULL,
	[InsertAuditKey] [varchar](8000) NULL,
	[UpdateAuditKey] [varchar](8000) NULL,
	[RowTimeStamp] [varchar](8000) NULL,
	[msrepl_tran_version] [varchar](8000) NULL,
	[ReportingCenterSSID] [varchar](8000) NULL,
	[ReportingCenterKey] [varchar](8000) NULL,
	[HasFullAccessFlag] [varchar](8000) NULL,
	[CenterBusinessTypeID] [varchar](8000) NULL,
	[RegionRSMNBConsultantSSID] [varchar](8000) NULL,
	[RegionRSMMembershipAdvisorSSID] [varchar](8000) NULL,
	[RegionRTMTechnicalManagerSSID] [varchar](8000) NULL,
	[RegionROMOperationsManagerSSID] [varchar](8000) NULL,
	[CenterManagementAreaSSID] [varchar](8000) NULL,
	[NewBusinessSize] [varchar](8000) NULL,
	[RecurringBusinessSize] [varchar](8000) NULL,
	[CenterNumber] [varchar](8000) NULL,
	[CenterDescriptionNumber] [varchar](8000) NULL,
	[DMACode] [varchar](8000) NULL,
	[DMADescription] [varchar](8000) NULL,
	[DMARegion] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Local/cfgCenter - with DMA.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
