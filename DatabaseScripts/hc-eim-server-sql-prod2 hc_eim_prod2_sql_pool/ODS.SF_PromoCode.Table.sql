/****** Object:  Table [ODS].[SF_PromoCode]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_PromoCode]
(
	[Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Active__c] [bit] NULL,
	[DiscountType__c] [varchar](8000) NULL,
	[EndDate__c] [datetime2](7) NULL,
	[NCCAvailable__c] [bit] NULL,
	[PromoCodeDisplay__c] [varchar](8000) NULL,
	[PromoCodeSort__c] [numeric](38, 18) NULL,
	[StartDate__c] [datetime2](7) NULL,
	[External_Id__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
