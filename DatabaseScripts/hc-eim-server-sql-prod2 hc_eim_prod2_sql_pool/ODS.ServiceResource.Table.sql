/****** Object:  Table [ODS].[ServiceResource]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[ServiceResource]
(
	[Id] [nvarchar](18) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[Name] [nvarchar](765) NULL,
	[CurrencyIsoCode] [nvarchar](765) NULL,
	[CreatedDate] [datetime2](0) NULL,
	[CreatedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime2](0) NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[SystemModstamp] [datetime2](0) NULL,
	[LastViewedDate] [datetime2](0) NULL,
	[LastReferencedDate] [datetime2](0) NULL,
	[RelatedRecordId] [nvarchar](18) NULL,
	[ResourceType] [nvarchar](765) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[LocationId] [nvarchar](18) NULL,
	[AccountId] [nvarchar](18) NULL,
	[External_Id__c] [nvarchar](765) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
