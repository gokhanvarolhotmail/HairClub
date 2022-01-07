/****** Object:  Table [ODS].[Leads_HC_BI_Temp]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [ODS].[Leads_HC_BI_Temp]
(
	[realtimeValid] [varchar](8000) NULL,
	[Leads] [varchar](8000) NULL,
	[LeadId] [varchar](8000) NULL,
	[CubeAgencyOwnerType] [varchar](8000) NULL,
	[LeadCreationDateKey] [varchar](8000) NULL,
	[CampaignAgency] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[MobilePhone] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[LeadActivityStatusc] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[LeadSource] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'LeadValidation/leads05122021.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
