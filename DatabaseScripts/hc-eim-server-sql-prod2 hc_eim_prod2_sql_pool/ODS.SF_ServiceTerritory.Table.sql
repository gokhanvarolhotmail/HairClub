/****** Object:  Table [ODS].[SF_ServiceTerritory]    Script Date: 3/15/2022 2:11:58 PM ******/
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
	[AreaManager__c] [varchar](8000) NULL,
	[Area__c] [varchar](8000) NULL,
	[AssistantManager__c] [varchar](8000) NULL,
	[BackLinePhone__c] [varchar](8000) NULL,
	[BestTressedOffered__c] [bit] NULL,
	[Caller_Id__c] [varchar](8000) NULL,
	[CenterAlert__c] [varchar](8000) NULL,
	[CenterNumber__c] [varchar](8000) NULL,
	[CenterOwner__c] [varchar](8000) NULL,
	[CenterType__c] [varchar](8000) NULL,
	[CompanyID__c] [varchar](8000) NULL,
	[Company__c] [varchar](8000) NULL,
	[ConfirmationCallerIDEnglish__c] [varchar](8000) NULL,
	[ConfirmationCallerIDFrench__c] [varchar](8000) NULL,
	[ConfirmationCallerIDSpanish__c] [varchar](8000) NULL,
	[CustomerServiceLine__c] [varchar](8000) NULL,
	[DisplayName__c] [varchar](8000) NULL,
	[External_Id__c] [varchar](8000) NULL,
	[ImageConsultant__c] [varchar](8000) NULL,
	[MDPOffered__c] [bit] NULL,
	[MDPPerformed__c] [bit] NULL,
	[Main_Phone__c] [varchar](8000) NULL,
	[ManagerName__c] [varchar](8000) NULL,
	[Map_Short_Link__c] [varchar](8000) NULL,
	[MgrCellPhone__c] [varchar](8000) NULL,
	[OfferPRP__c] [bit] NULL,
	[OtherCallerIDEnglish__c] [varchar](8000) NULL,
	[OtherCallerIDFrench__c] [varchar](8000) NULL,
	[OtherCallerIDSpanish__c] [varchar](8000) NULL,
	[OutboundDialingAllowed__c] [bit] NULL,
	[ProfileCode__c] [varchar](8000) NULL,
	[Region__c] [varchar](8000) NULL,
	[Status__c] [varchar](8000) NULL,
	[Supported_Appointment_Types__c] [varchar](8000) NULL,
	[SurgeryOffered__c] [bit] NULL,
	[TimeZone__c] [varchar](8000) NULL,
	[Type__c] [varchar](8000) NULL,
	[WebPhone__c] [varchar](8000) NULL,
	[Web_Phone__c] [varchar](8000) NULL,
	[X1Apptperslot__c] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
