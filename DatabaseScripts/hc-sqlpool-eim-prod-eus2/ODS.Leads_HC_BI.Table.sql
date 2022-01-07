/****** Object:  Table [ODS].[Leads_HC_BI]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[Leads_HC_BI]
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
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
