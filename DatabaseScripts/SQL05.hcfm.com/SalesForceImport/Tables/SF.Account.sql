/* CreateDate: 03/04/2022 08:10:42.600 , ModifyDate: 03/08/2022 08:42:58.443 */
GO
CREATE TABLE [SF].[Account](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MasterRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BillingLatitude] [decimal](25, 15) NULL,
	[BillingLongitude] [decimal](25, 15) NULL,
	[BillingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShippingLatitude] [decimal](25, 15) NULL,
	[ShippingLongitude] [decimal](25, 15) NULL,
	[ShippingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountNumber] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Website] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sic] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Industry] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AnnualRevenue] [decimal](18, 0) NULL,
	[NumberOfEmployees] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ownership] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TickerSymbol] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rating] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Site] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[PersonContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPersonAccount] [bit] NULL,
	[PersonMailingStreet] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCity] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingState] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingPostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCountry] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingStateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingCountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMailingLatitude] [decimal](25, 15) NULL,
	[PersonMailingLongitude] [decimal](25, 15) NULL,
	[PersonMailingGeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonHomePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonOtherPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonAssistantPhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonEmail] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonTitle] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonDepartment] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonDoNotCall] [bit] NULL,
	[PersonLastCURequestDate] [datetime2](7) NULL,
	[PersonLastCUUpdateDate] [datetime2](7) NULL,
	[PersonEmailBouncedReason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonEmailBouncedDate] [datetime2](7) NULL,
	[Jigsaw] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JigsawCompanyId] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SicDesc] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperatingHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active__c] [bit] NULL,
	[Company__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConectCreationDate__c] [datetime2](7) NULL,
	[ConectLastUpdate__c] [datetime2](7) NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonMobilePhone_Number_Normalized__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Count_Close_Won_Opportunities__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaManager__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Area__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssistantManager__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BackLinePhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BestTressedOffered__c] [bit] NULL,
	[CenterAlert__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterOwner__c] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterType__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDEnglish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDFrench__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationCallerIDSpanish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerServiceLine__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Customer_Status__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNCDateMobilePhone__c] [datetime2](7) NULL,
	[DNCDatePhone__c] [datetime2](7) NULL,
	[DNCValidationMobilePhone__c] [bit] NULL,
	[DNCValidationPhone__c] [bit] NULL,
	[DisplayName__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ImageConsultant__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MDPOffered__c] [bit] NULL,
	[MDPPerformed__c] [bit] NULL,
	[ManagerName__c] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MgrCellPhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OfferPRP__c] [bit] NULL,
	[OtherCallerIDEnglish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherCallerIDFrench__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherCallerIDSpanish__c] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OutboundDialingAllowed__c] [bit] NULL,
	[ProfileCode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurgeryOffered__c] [bit] NULL,
	[TimeZone__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Virtual__c] [bit] NULL,
	[WebPhone__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[X1Apptperslot__c] [bit] NULL,
	[ClientGUID__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goals_Expectations__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_many_times_a_week_do_you_think__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_much_time_a_week_do_you_spend__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Other_Reason__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_are_your_main_concerns_today__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_else_would_be_helpful_for_your__c] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[What_methods_have_you_used_or_currently__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ExemptionCertificate__c] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__IsBillingAddressValidated__c] [bit] NULL,
	[fferpcore__IsShippingAddressValidated__c] [bit] NULL,
	[fferpcore__MaterializedBillingAddressValidated__c] [bit] NULL,
	[fferpcore__MaterializedShippingAddressValidated__c] [bit] NULL,
	[fferpcore__OutputVatCode__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__SalesTaxStatus__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__TaxCode1__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__TaxCode2__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__TaxCode3__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__TaxCountryCode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedBillingCity__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedBillingCountry__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedBillingPostalCode__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedBillingState__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedBillingStreet__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedShippingCity__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedShippingCountry__c] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedShippingPostalCode__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedShippingState__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__ValidatedShippingStreet__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__VatRegistrationNumber__c] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fferpcore__VatStatus__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__AccountParticulars__c] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__BankBIC__c] [varchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__PaymentCode__c] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__PaymentCountryISO__c] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__PaymentPriority__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffbf__PaymentRoutingMethod__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SCMFFA__Company_Name__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ffaci__CurrencyCulture__c] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Territory_Time_Zone__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rh2__testCurrency__c] [decimal](14, 2) NULL,
	[Initial_Campaign_Source__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Landing_Page_Form_Submitted_Date__c] [datetime2](7) NULL,
	[Age__pc] [decimal](18, 0) NULL,
	[Birthdate__pc] [date] NULL,
	[DoNotContact__pc] [bit] NULL,
	[DoNotEmail__pc] [bit] NULL,
	[DoNotMail__pc] [bit] NULL,
	[DoNotText__pc] [bit] NULL,
	[Ethnicity__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossOrVolume__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCopyPreferred__pc] [bit] NULL,
	[Language__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Text_Reminder_Opt_In__pc] [bit] NULL,
	[rh2__Currency_Test__pc] [decimal](18, 0) NULL,
	[rh2__Describe__pc] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rh2__Formula_Test__pc] [decimal](18, 0) NULL,
	[rh2__Integer_Test__pc] [decimal](3, 0) NULL,
	[Next_Milestone_Event__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Next_Milestone_Event_Date__pc] [date] NULL,
	[Bosley_Center_Number__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Client_Id__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Legacy_Source_Code__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Salesforce_Id__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Siebel_Id__pc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact_ID_18_dig__pc] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Landing_Page_Form_Submitted_Date__pc] [datetime2](7) NULL,
 CONSTRAINT [pk_Account] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Account]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Account]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
