/****** Object:  Table [dbo].[DimAgency]    Script Date: 2/18/2022 8:28:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAgency]
(
	[AgencyKey] [int] IDENTITY(1,1) NOT NULL,
	[Hash] [varchar](256) NOT NULL,
	[AgencyName] [varchar](200) NULL,
	[AgencyAddress] [varchar](400) NULL,
	[AgencyDomain] [varchar](200) NULL,
	[DWH_LoadDate] [datetime] NOT NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[SourceSystem] [varchar](20) NOT NULL,
	[AgencyType] [varchar](100) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Hash] ASC
	)
)
GO
ALTER TABLE [dbo].[DimAgency] ADD  DEFAULT ('Non Paid') FOR [AgencyType]
GO
