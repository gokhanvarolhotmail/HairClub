/****** Object:  Table [dbo].[Leads06232021]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE EXTERNAL TABLE [dbo].[Leads06232021]
(
	[LeadID] [varchar](8000) NULL,
	[ExternalID] [varchar](8000) NULL,
	[GCLID] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[Mobile] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[StateProvince] [varchar](8000) NULL,
	[ZipPostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[Rating] [varchar](8000) NULL,
	[LeadOwner] [varchar](8000) NULL,
	[CreatedBy] [varchar](8000) NULL,
	[LeadRecordType] [varchar](8000) NULL,
	[CreateDate] [varchar](8000) NULL,
	[LeadStatus] [varchar](8000) NULL,
	[Converted] [varchar](8000) NULL,
	[LeadSource] [varchar](8000) NULL,
	[Website] [varchar](8000) NULL,
	[Gender] [varchar](8000) NULL,
	[Age] [varchar](8000) NULL,
	[Birthdate] [varchar](8000) NULL,
	[Ethnicity] [varchar](8000) NULL,
	[DoNotCall] [varchar](8000) NULL,
	[DoNotContact] [varchar](8000) NULL,
	[DoNotEmail] [varchar](8000) NULL,
	[DoNotMail] [varchar](8000) NULL,
	[DoNotText] [varchar](8000) NULL,
	[ServiceTerritory] [varchar](8000) NULL,
	[PromoCode] [varchar](8000) NULL,
	[DNCValidationMobilePhone] [varchar](8000) NULL,
	[DNCValidationPhone] [varchar](8000) NULL
)
WITH (DATA_SOURCE = [filesystemeim_steimdatalakeprod2_dfs_core_windows_net],LOCATION = N'Leads Report-2021-06-24-13-39-49.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO
