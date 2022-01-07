/****** Object:  Table [ODS].[SFDC_PromoCode]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SFDC_PromoCode]
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
	[PromoCodeDisplay__c] [varchar](8000) NULL,
	[DiscountType__c] [varchar](8000) NULL,
	[StartDate__c] [datetime2](7) NULL,
	[EndDate__c] [datetime2](7) NULL,
	[Active__c] [bit] NULL,
	[NCCAvailable__c] [bit] NULL,
	[PromoCodeSort__c] [numeric](38, 18) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Id] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
