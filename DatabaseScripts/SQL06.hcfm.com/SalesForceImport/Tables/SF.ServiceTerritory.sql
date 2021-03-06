/* CreateDate: 03/03/2022 13:53:57.083 , ModifyDate: 03/17/2022 23:50:24.237 */
GO
CREATE TABLE [SF].[ServiceTerritory](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ParentTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TopLevelTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperatingHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[TypicalInTerritoryTravelTime] [decimal](16, 2) NULL,
	[Alternative_Phone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaManager__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Area__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssistantManager__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BackLinePhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BestTressedOffered__c] [bit] NULL,
	[Caller_Id__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAlert__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber__c] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterOwner__c] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Company__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDEnglish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDFrench__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDSpanish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerServiceLine__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DisplayName__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ImageConsultant__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MDPOffered__c] [bit] NULL,
	[MDPPerformed__c] [bit] NULL,
	[Main_Phone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ManagerName__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Map_Short_Link__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MgrCellPhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OfferPRP__c] [bit] NULL,
	[OtherCallerIDEnglish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherCallerIDFrench__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherCallerIDSpanish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OutboundDialingAllowed__c] [bit] NULL,
	[ProfileCode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Supported_Appointment_Types__c] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurgeryOffered__c] [bit] NULL,
	[TimeZone__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WebPhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Web_Phone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[X1Apptperslot__c] [bit] NULL,
	[English_Directions__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[French_Directions__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Spanish_Directions__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Virtual__c] [bit] NULL,
	[English_Cross_Streets__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[French_Cross_Streets__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Spanish_Cross_Streets__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Business_Hours__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceTerritory] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceTerritory]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceTerritory]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
