/****** Object:  Table [ODS].[SF_ServiceTerritory]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_ServiceTerritory]
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
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ParentTerritoryId] [varchar](8000) NULL,
	[TopLevelTerritoryId] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[OperatingHoursId] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[StateCode] [varchar](8000) NULL,
	[CountryCode] [varchar](8000) NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) NULL,
	[IsActive] [bit] NULL,
	[TypicalInTerritoryTravelTime] [numeric](38, 18) NULL,
	[Alternative_Phone__c] [varchar](8000) NULL,
	[Back_Line_Phone__c] [varchar](8000) NULL,
	[CenterId__c] [varchar](8000) NULL,
	[Center_Number__c] [numeric](38, 18) NULL,
	[Center_Owner__c] [varchar](8000) NULL,
	[Customer_Service_Line__c] [varchar](8000) NULL,
	[Main_Phone__c] [varchar](8000) NULL,
	[Manager_Cell_Phone__c] [varchar](8000) NULL,
	[Map_Short_Link__c] [varchar](8000) NULL,
	[Phone__c] [varchar](8000) NULL,
	[Type__c] [varchar](8000) NULL,
	[Virtual__c] [bit] NULL,
	[Web_Phone__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
