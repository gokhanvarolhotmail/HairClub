SET XACT_ABORT ON
GO
BEGIN TRANSACTION
/*============================================================================*/
/* DBMS: MS SQL Server 2017*/
/* Created on : 02/28/2022 9:56:11 PM                                           */
/*============================================================================*/


/*============================================================================*/
/*                                  TABLES                                    */
/*============================================================================*/
CREATE TABLE [et4ae5__abTest__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__abTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Account] ( 
  [Id]                                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                                BIT NOT NULL,
  [MasterRecordId]                                           VARCHAR(18),
  [Name]                                                     VARCHAR(255),
  [LastName]                                                 VARCHAR(80),
  [FirstName]                                                VARCHAR(40),
  [Salutation]                                               VARCHAR(255),
  [MiddleName]                                               VARCHAR(40),
  [Suffix]                                                   VARCHAR(40),
  [Type]                                                     VARCHAR(255),
  [RecordTypeId]                                             VARCHAR(18),
  [ParentId]                                                 VARCHAR(18),
  [BillingStreet]                                            VARCHAR(255),
  [BillingCity]                                              VARCHAR(40),
  [BillingState]                                             VARCHAR(80),
  [BillingPostalCode]                                        VARCHAR(20),
  [BillingCountry]                                           VARCHAR(80),
  [BillingStateCode]                                         VARCHAR(255),
  [BillingCountryCode]                                       VARCHAR(255),
  [BillingLatitude]                                          DECIMAL(15,15),
  [BillingLongitude]                                         DECIMAL(15,15),
  [BillingGeocodeAccuracy]                                   VARCHAR(255),
  [BillingAddress]                                           VARCHAR(255),
  [ShippingStreet]                                           VARCHAR(255),
  [ShippingCity]                                             VARCHAR(40),
  [ShippingState]                                            VARCHAR(80),
  [ShippingPostalCode]                                       VARCHAR(20),
  [ShippingCountry]                                          VARCHAR(80),
  [ShippingStateCode]                                        VARCHAR(255),
  [ShippingCountryCode]                                      VARCHAR(255),
  [ShippingLatitude]                                         DECIMAL(15,15),
  [ShippingLongitude]                                        DECIMAL(15,15),
  [ShippingGeocodeAccuracy]                                  VARCHAR(255),
  [ShippingAddress]                                          VARCHAR(255),
  [Phone]                                                    VARCHAR(40),
  [Fax]                                                      VARCHAR(40),
  [AccountNumber]                                            VARCHAR(40),
  [Website]                                                  VARCHAR(1024),
  [PhotoUrl]                                                 VARCHAR(1024),
  [Sic]                                                      VARCHAR(20),
  [Industry]                                                 VARCHAR(255),
  [AnnualRevenue]                                            DECIMAL(18,0),
  [NumberOfEmployees]                                        VARCHAR(255),
  [Ownership]                                                VARCHAR(255),
  [TickerSymbol]                                             VARCHAR(20),
  [Description]                                              TEXT,
  [Rating]                                                   VARCHAR(255),
  [Site]                                                     VARCHAR(80),
  [CurrencyIsoCode]                                          VARCHAR(255),
  [OwnerId]                                                  VARCHAR(18) NOT NULL,
  [CreatedDate]                                              DATETIME2 NOT NULL,
  [CreatedById]                                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                         DATETIME2 NOT NULL,
  [LastModifiedById]                                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                                           DATETIME2 NOT NULL,
  [LastActivityDate]                                         DATE,
  [LastViewedDate]                                           DATETIME2,
  [LastReferencedDate]                                       DATETIME2,
  [PersonContactId]                                          VARCHAR(18),
  [IsPersonAccount]                                          BIT NOT NULL,
  [PersonMailingStreet]                                      VARCHAR(255),
  [PersonMailingCity]                                        VARCHAR(40),
  [PersonMailingState]                                       VARCHAR(80),
  [PersonMailingPostalCode]                                  VARCHAR(20),
  [PersonMailingCountry]                                     VARCHAR(80),
  [PersonMailingStateCode]                                   VARCHAR(255),
  [PersonMailingCountryCode]                                 VARCHAR(255),
  [PersonMailingLatitude]                                    DECIMAL(15,15),
  [PersonMailingLongitude]                                   DECIMAL(15,15),
  [PersonMailingGeocodeAccuracy]                             VARCHAR(255),
  [PersonMailingAddress]                                     VARCHAR(255),
  [PersonMobilePhone]                                        VARCHAR(40),
  [PersonHomePhone]                                          VARCHAR(40),
  [PersonOtherPhone]                                         VARCHAR(40),
  [PersonAssistantPhone]                                     VARCHAR(40),
  [PersonEmail]                                              VARCHAR(128),
  [PersonTitle]                                              VARCHAR(80),
  [PersonDepartment]                                         VARCHAR(80),
  [PersonDoNotCall]                                          BIT NOT NULL,
  [PersonLastCURequestDate]                                  DATETIME2,
  [PersonLastCUUpdateDate]                                   DATETIME2,
  [PersonEmailBouncedReason]                                 VARCHAR(255),
  [PersonEmailBouncedDate]                                   DATETIME2,
  [Jigsaw]                                                   VARCHAR(20),
  [JigsawCompanyId]                                          VARCHAR(20),
  [AccountSource]                                            VARCHAR(255),
  [SicDesc]                                                  VARCHAR(80),
  [OperatingHoursId]                                         VARCHAR(18),
  [Active__c]                                                BIT NOT NULL,
  [Company__c]                                               VARCHAR(255),
  [ConectCreationDate__c]                                    DATETIME2,
  [ConectLastUpdate__c]                                      DATETIME2,
  [External_Id__c]                                           VARCHAR(255),
  [PersonMobilePhone_Number_Normalized__c]                   VARCHAR(40),
  [Status__c]                                                VARCHAR(255),
  [Count_Close_Won_Opportunities__c]                         VARCHAR(30),
  [ClientIdentifier__c]                                      VARCHAR(255),
  [Occupation__c]                                            VARCHAR(255),
  [AreaManager__c]                                           VARCHAR(100),
  [Area__c]                                                  VARCHAR(255),
  [AssistantManager__c]                                      VARCHAR(100),
  [BackLinePhone__c]                                         VARCHAR(40),
  [BestTressedOffered__c]                                    BIT NOT NULL,
  [CenterAlert__c]                                           VARCHAR(255),
  [CenterOwner__c]                                           VARCHAR(80),
  [CenterType__c]                                            VARCHAR(255),
  [CompanyID__c]                                             VARCHAR(255),
  [ConfirmationCallerIDEnglish__c]                           VARCHAR(30),
  [ConfirmationCallerIDFrench__c]                            VARCHAR(30),
  [ConfirmationCallerIDSpanish__c]                           VARCHAR(30),
  [CustomerServiceLine__c]                                   VARCHAR(40),
  [Customer_Status__c]                                       VARCHAR(1300),
  [DNCDateMobilePhone__c]                                    DATETIME2,
  [DNCDatePhone__c]                                          DATETIME2,
  [DNCValidationMobilePhone__c]                              BIT NOT NULL,
  [DNCValidationPhone__c]                                    BIT NOT NULL,
  [DisplayName__c]                                           VARCHAR(255),
  [ImageConsultant__c]                                       VARCHAR(100),
  [MDPOffered__c]                                            BIT NOT NULL,
  [MDPPerformed__c]                                          BIT NOT NULL,
  [ManagerName__c]                                           VARCHAR(100),
  [MgrCellPhone__c]                                          VARCHAR(40),
  [OfferPRP__c]                                              BIT NOT NULL,
  [OtherCallerIDEnglish__c]                                  VARCHAR(30),
  [OtherCallerIDFrench__c]                                   VARCHAR(30),
  [OtherCallerIDSpanish__c]                                  VARCHAR(30),
  [OutboundDialingAllowed__c]                                BIT NOT NULL,
  [ProfileCode__c]                                           VARCHAR(255),
  [Region__c]                                                VARCHAR(255),
  [Service_Territory__c]                                     VARCHAR(18),
  [SurgeryOffered__c]                                        BIT NOT NULL,
  [TimeZone__c]                                              VARCHAR(255),
  [Virtual__c]                                               BIT NOT NULL,
  [WebPhone__c]                                              VARCHAR(40),
  [X1Apptperslot__c]                                         BIT NOT NULL,
  [ClientGUID__c]                                            VARCHAR(255),
  [Goals_Expectations__c]                                    TEXT,
  [How_many_times_a_week_do_you_think__c]                    VARCHAR(255),
  [How_much_time_a_week_do_you_spend__c]                     TEXT,
  [Other_Reason__c]                                          TEXT,
  [What_are_your_main_concerns_today__c]                     VARCHAR(255),
  [What_else_would_be_helpful_for_your__c]                   TEXT,
  [What_methods_have_you_used_or_currently__c]               VARCHAR(255),
  [fferpcore__ExemptionCertificate__c]                       VARCHAR(25),
  [fferpcore__IsBillingAddressValidated__c]                  BIT NOT NULL,
  [fferpcore__IsShippingAddressValidated__c]                 BIT NOT NULL,
  [fferpcore__MaterializedBillingAddressValidated__c]        BIT NOT NULL,
  [fferpcore__MaterializedShippingAddressValidated__c]       BIT NOT NULL,
  [fferpcore__OutputVatCode__c]                              VARCHAR(18),
  [fferpcore__SalesTaxStatus__c]                             VARCHAR(255),
  [fferpcore__TaxCode1__c]                                   VARCHAR(18),
  [fferpcore__TaxCode2__c]                                   VARCHAR(18),
  [fferpcore__TaxCode3__c]                                   VARCHAR(18),
  [fferpcore__TaxCountryCode__c]                             VARCHAR(255),
  [fferpcore__ValidatedBillingCity__c]                       VARCHAR(40),
  [fferpcore__ValidatedBillingCountry__c]                    VARCHAR(40),
  [fferpcore__ValidatedBillingPostalCode__c]                 VARCHAR(20),
  [fferpcore__ValidatedBillingState__c]                      VARCHAR(20),
  [fferpcore__ValidatedBillingStreet__c]                     VARCHAR(255),
  [fferpcore__ValidatedShippingCity__c]                      VARCHAR(40),
  [fferpcore__ValidatedShippingCountry__c]                   VARCHAR(40),
  [fferpcore__ValidatedShippingPostalCode__c]                VARCHAR(20),
  [fferpcore__ValidatedShippingState__c]                     VARCHAR(20),
  [fferpcore__ValidatedShippingStreet__c]                    VARCHAR(255),
  [fferpcore__VatRegistrationNumber__c]                      VARCHAR(20),
  [fferpcore__VatStatus__c]                                  VARCHAR(255),
  [ffbf__AccountParticulars__c]                              VARCHAR(12),
  [ffbf__BankBIC__c]                                         VARCHAR(16),
  [ffbf__PaymentCode__c]                                     VARCHAR(12),
  [ffbf__PaymentCountryISO__c]                               VARCHAR(2),
  [ffbf__PaymentPriority__c]                                 VARCHAR(255),
  [ffbf__PaymentRoutingMethod__c]                            VARCHAR(255),
  [SCMFFA__Company_Name__c]                                  VARCHAR(255),
  [ffaci__CurrencyCulture__c]                                VARCHAR(8),
  [Service_Territory_Time_Zone__c]                           VARCHAR(1300),
  [rh2__testCurrency__c]                                     DECIMAL(14,2),
  [Age__pc]                                                  DECIMAL(18,0),
  [Birthdate__pc]                                            DATE,
  [DoNotContact__pc]                                         BIT NOT NULL,
  [DoNotEmail__pc]                                           BIT NOT NULL,
  [DoNotMail__pc]                                            BIT NOT NULL,
  [DoNotText__pc]                                            BIT NOT NULL,
  [Ethnicity__pc]                                            VARCHAR(255),
  [Gender__pc]                                               VARCHAR(255),
  [HairLossExperience__pc]                                   VARCHAR(255),
  [HairLossFamily__pc]                                       VARCHAR(255),
  [HairLossOrVolume__pc]                                     VARCHAR(255),
  [HairLossProductOther__pc]                                 VARCHAR(255),
  [HairLossProductUsed__pc]                                  VARCHAR(255),
  [HairLossSpot__pc]                                         VARCHAR(255),
  [HardCopyPreferred__pc]                                    BIT NOT NULL,
  [Language__pc]                                             VARCHAR(255),
  [MaritalStatus__pc]                                        VARCHAR(255),
  [Text_Reminder_Opt_In__pc]                                 BIT NOT NULL,
  [rh2__Currency_Test__pc]                                   DECIMAL(18,0),
  [rh2__Describe__pc]                                        VARCHAR(18),
  [rh2__Formula_Test__pc]                                    DECIMAL(18,0),
  [rh2__Integer_Test__pc]                                    DECIMAL(3,0),
  [Next_Milestone_Event__pc]                                 VARCHAR(255),
  [Next_Milestone_Event_Date__pc]                            DATE,
  [Bosley_Center_Number__pc]                                 VARCHAR(255),
  [Bosley_Client_Id__pc]                                     VARCHAR(255),
  [Bosley_Legacy_Source_Code__pc]                            VARCHAR(255),
  [Bosley_Salesforce_Id__pc]                                 VARCHAR(255),
  [Bosley_Siebel_Id__pc]                                     VARCHAR(255),
  [Contact_ID_18_dig__pc]                                    VARCHAR(1300),
CONSTRAINT [pk_Account] PRIMARY KEY ([Id]),
CONSTRAINT [uk_AccountExternal_Id__c] UNIQUE ([External_Id__c]),
CONSTRAINT [uk_AccountClientIdentifier__c] UNIQUE ([ClientIdentifier__c]),
CONSTRAINT [uk_AccountClientGUID__c] UNIQUE ([ClientGUID__c])
) 
;

CREATE TABLE [AccountContactRelation] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [AccountId]                      VARCHAR(18) NOT NULL,
  [ContactId]                      VARCHAR(18) NOT NULL,
  [Roles]                          VARCHAR(1000),
  [IsDirect]                       BIT NOT NULL,
  [IsActive]                       BIT NOT NULL,
  [StartDate]                      DATE,
  [EndDate]                        DATE,
  [CurrencyIsoCode]                VARCHAR(255) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [Relationship_Strength__c]       VARCHAR(255),
CONSTRAINT [pk_AccountContactRelation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__AccountCreditTerms__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(80),
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [fferpcore__Account__c]            VARCHAR(18) NOT NULL,
  [fferpcore__BaseDate1__c]          VARCHAR(255),
  [fferpcore__BaseDate2__c]          VARCHAR(255),
  [fferpcore__BaseDate3__c]          VARCHAR(255),
  [fferpcore__BaseDate4__c]          VARCHAR(255),
  [fferpcore__DaysOffset1__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset2__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset3__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset4__c]        DECIMAL(18,0),
  [fferpcore__Description1__c]       VARCHAR(80),
  [fferpcore__Description2__c]       VARCHAR(80),
  [fferpcore__Description3__c]       VARCHAR(80),
  [fferpcore__Description4__c]       VARCHAR(80),
  [fferpcore__Discount1__c]          DECIMAL(5,2),
  [fferpcore__Discount2__c]          DECIMAL(5,2),
  [fferpcore__Discount3__c]          DECIMAL(5,2),
  [fferpcore__Discount4__c]          DECIMAL(5,2),
CONSTRAINT [pk_fferpcore__AccountCreditTerms__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__AccountExtension__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [LastViewedDate]                         DATETIME2,
  [LastReferencedDate]                     DATETIME2,
  [fferpcore__Account__c]                  VARCHAR(18) NOT NULL,
  [fferpcore__TaxExemptionReason__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__AccountExtension__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__AccountTest__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [OwnerId]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(80),
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [ffbf__AccountParticulars__c]         VARCHAR(12),
  [ffbf__BankAccountNumber__c]          VARCHAR(40),
  [ffbf__BankBIC__c]                    VARCHAR(16),
  [ffbf__BankCity__c]                   VARCHAR(40),
  [ffbf__BankIBANNumber__c]             VARCHAR(40),
  [ffbf__BankName__c]                   VARCHAR(255),
  [ffbf__BankSortCode__c]               VARCHAR(20),
  [ffbf__BankStreet__c]                 VARCHAR(255),
  [ffbf__BankZipPostalCode__c]          VARCHAR(20),
  [ffbf__BillingStreet__c]              VARCHAR(50),
  [ffbf__Fax__c]                        VARCHAR(9),
  [ffbf__InvoiceEmail__c]               VARCHAR(128),
  [ffbf__PaymentCode__c]                VARCHAR(12),
  [ffbf__PaymentCountryISO__c]          VARCHAR(2),
  [ffbf__PaymentPriority__c]            VARCHAR(255),
  [ffbf__PaymentRoutingMethod__c]       VARCHAR(255),
CONSTRAINT [pk_ffbf__AccountTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__AccountingCurrencyTest__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_ffbf__AccountingCurrencyTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__AggregateLink__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(80),
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [et4ae5__Unique_Link_ID__c]       VARCHAR(255) NOT NULL,
CONSTRAINT [pk_et4ae5__AggregateLink__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_et4ae5__AggregateLink__cet4ae5__Unique_Link_ID__c] UNIQUE ([et4ae5__Unique_Link_ID__c])
) 
;

CREATE TABLE [fferpcore__AnalysisItem__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(80),
  [CurrencyIsoCode]                          VARCHAR(255),
  [RecordTypeId]                             VARCHAR(18),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [LastViewedDate]                           DATETIME2,
  [LastReferencedDate]                       DATETIME2,
  [fferpcore__ReportingCode__c]              VARCHAR(24) NOT NULL,
  [fferpcore__UniquenessConstraint__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__AnalysisItem__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__AnalysisItem__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [UserAppMenuItem] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [AppMenuItemId]                   VARCHAR(255),
  [ApplicationId]                   VARCHAR(18),
  [Label]                           VARCHAR(80),
  [Description]                     VARCHAR(250),
  [Name]                            VARCHAR(250),
  [UserSortOrder]                   VARCHAR(255),
  [SortOrder]                       VARCHAR(255),
  [Type]                            VARCHAR(255),
  [LogoUrl]                         VARCHAR(1024),
  [IconUrl]                         VARCHAR(1024),
  [InfoUrl]                         VARCHAR(1024),
  [StartUrl]                        VARCHAR(1024),
  [MobileStartUrl]                  VARCHAR(1024),
  [IsVisible]                       BIT NOT NULL,
  [IsUsingAdminAuthorization]       BIT NOT NULL,
CONSTRAINT [pk_UserAppMenuItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [AppointmentTopicTimeSlot] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [TimeSlotId]                        VARCHAR(18) NOT NULL,
  [WorkTypeId]                        VARCHAR(18),
  [WorkTypeGroupId]                   VARCHAR(18),
  [OperatingHoursId]                  VARCHAR(18),
  [AppointmentTopicTimeSlotKey]       VARCHAR(255),
CONSTRAINT [pk_AppointmentTopicTimeSlot] PRIMARY KEY ([Id]),
CONSTRAINT [uk_AppointmentTopicTimeSlotAppointmentTopicTimeSlotKey] UNIQUE ([AppointmentTopicTimeSlotKey])
) 
;

CREATE TABLE [Asset] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [ContactId]                 VARCHAR(18),
  [AccountId]                 VARCHAR(18),
  [ParentId]                  VARCHAR(18),
  [RootAssetId]               VARCHAR(18),
  [Product2Id]                VARCHAR(18),
  [ProductCode]               VARCHAR(255),
  [IsCompetitorProduct]       BIT NOT NULL,
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [CurrencyIsoCode]           VARCHAR(255),
  [Name]                      VARCHAR(255) NOT NULL,
  [SerialNumber]              VARCHAR(80),
  [InstallDate]               DATE,
  [PurchaseDate]              DATE,
  [UsageEndDate]              DATE,
  [Status]                    VARCHAR(255),
  [Price]                     DECIMAL(18,0),
  [Quantity]                  DECIMAL(10,2),
  [Description]               TEXT,
  [OwnerId]                   VARCHAR(18) NOT NULL,
  [AssetProvidedById]         VARCHAR(18),
  [AssetServicedById]         VARCHAR(18),
  [IsInternal]                BIT NOT NULL,
  [AssetLevel]                VARCHAR(255),
  [StockKeepingUnit]          VARCHAR(180),
  [LastViewedDate]            DATETIME2,
  [LastReferencedDate]        DATETIME2,
CONSTRAINT [pk_Asset] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [AssetRelationship] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [AssetRelationshipNumber]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
  [AssetId]                       VARCHAR(18) NOT NULL,
  [RelatedAssetId]                VARCHAR(18) NOT NULL,
  [FromDate]                      DATETIME2,
  [ToDate]                        DATETIME2,
  [RelationshipType]              VARCHAR(255),
CONSTRAINT [pk_AssetRelationship] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [AssignedResource] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [AssignedResourceNumber]       VARCHAR(255) NOT NULL,
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [ServiceAppointmentId]         VARCHAR(18) NOT NULL,
  [ServiceResourceId]            VARCHAR(18) NOT NULL,
  [IsRequiredResource]           BIT NOT NULL,
  [Role]                         VARCHAR(255),
  [EventId]                      VARCHAR(18),
  [ServiceResourceId__c]         VARCHAR(255),
CONSTRAINT [pk_AssignedResource] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [AssociatedLocation] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [AssociatedLocationNumber]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [ParentRecordId]                 VARCHAR(18) NOT NULL,
  [LocationId]                     VARCHAR(18) NOT NULL,
  [Type]                           VARCHAR(255),
  [ActiveFrom]                     DATETIME2,
  [ActiveTo]                       DATETIME2,
CONSTRAINT [pk_AssociatedLocation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [BackgroundOperation] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255) NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [SubmittedAt]            DATETIME2,
  [Status]                 VARCHAR(255),
  [ExecutionGroup]         VARCHAR(255),
  [SequenceGroup]          VARCHAR(255),
  [SequenceNumber]         VARCHAR(255),
  [GroupLeaderId]          VARCHAR(18),
  [StartedAt]              DATETIME2,
  [FinishedAt]             DATETIME2,
  [WorkerUri]              VARCHAR(255),
  [Timeout]                VARCHAR(255),
  [ExpiresAt]              DATETIME2,
  [NumFollowers]           VARCHAR(255),
  [ProcessAfter]           DATETIME2,
  [ParentKey]              VARCHAR(255),
  [RetryLimit]             VARCHAR(255),
  [RetryCount]             VARCHAR(255),
  [RetryBackoff]           VARCHAR(255),
  [Error]                  VARCHAR(255),
  [Type]                   VARCHAR(255),
CONSTRAINT [pk_BackgroundOperation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [WorkBadgeDefinition] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [IsCompanyWide]            BIT NOT NULL,
  [Description]              TEXT NOT NULL,
  [ImageUrl]                 VARCHAR(1024) NOT NULL,
  [IsActive]                 BIT NOT NULL,
  [NetworkId]                VARCHAR(18),
  [LimitNumber]              VARCHAR(255),
  [IsLimitPerUser]           BIT NOT NULL,
  [LimitStartDate]           DATE,
  [GivenBadgeCount]          VARCHAR(255),
  [IsRewardBadge]            BIT NOT NULL,
CONSTRAINT [pk_WorkBadgeDefinition] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__BankAccountTest__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(80),
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [ffbf__AccountNumber__c]                      VARCHAR(36) NOT NULL,
  [ffbf__BankAccountCurrency__c]                VARCHAR(18),
  [ffbf__BankCode__c]                           VARCHAR(24) NOT NULL,
  [ffbf__BranchNumber__c]                       VARCHAR(24),
  [ffbf__ChargesBankAccountIdentifier__c]       VARCHAR(34),
  [ffbf__CodewordNumber10__c]                   VARCHAR(4),
  [ffbf__CodewordNumber1__c]                    VARCHAR(4),
  [ffbf__CodewordNumber2__c]                    VARCHAR(4),
  [ffbf__CodewordNumber3__c]                    VARCHAR(4),
  [ffbf__CodewordNumber4__c]                    VARCHAR(4),
  [ffbf__CodewordNumber5__c]                    VARCHAR(4),
  [ffbf__CodewordNumber6__c]                    VARCHAR(4),
  [ffbf__CodewordNumber7__c]                    VARCHAR(4),
  [ffbf__CodewordNumber8__c]                    VARCHAR(4),
  [ffbf__CodewordNumber9__c]                    VARCHAR(4),
  [ffbf__CodewordText10__c]                     VARCHAR(29),
  [ffbf__CodewordText1__c]                      VARCHAR(29),
  [ffbf__CodewordText2__c]                      VARCHAR(29),
  [ffbf__CodewordText3__c]                      VARCHAR(29),
  [ffbf__CodewordText4__c]                      VARCHAR(29),
  [ffbf__CodewordText5__c]                      VARCHAR(29),
  [ffbf__CodewordText6__c]                      VARCHAR(29),
  [ffbf__CodewordText7__c]                      VARCHAR(29),
  [ffbf__CodewordText8__c]                      VARCHAR(29),
  [ffbf__CodewordText9__c]                      VARCHAR(29),
  [ffbf__ConfidentialPayments__c]               VARCHAR(1),
  [ffbf__DebitAccountIdentifier2__c]            VARCHAR(1300),
  [ffbf__DebitAccountIdentifier__c]             VARCHAR(1300),
  [ffbf__ExportFileName__c]                     VARCHAR(50),
  [ffbf__FXDealRate__c]                         DECIMAL(11,4),
  [ffbf__FXDeal__c]                             DECIMAL(16,0),
  [ffbf__IntermediaryBank__c]                   VARCHAR(16),
  [ffbf__OwnerCompany__c]                       VARCHAR(18),
  [ffbf__PaymentBankIndentifier__c]             VARCHAR(34),
  [ffbf__PaymentChargesCode__c]                 VARCHAR(255),
  [ffbf__PaymentInstitutionIdentifier__c]       VARCHAR(16),
  [ffbf__RTGSRequired__c]                       VARCHAR(255),
  [ffbf__RemittanceAdvice__c]                   VARCHAR(255),
  [ffbf__SortCode__c]                           VARCHAR(20),
CONSTRAINT [pk_ffbf__BankAccountTest__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffbf__BankAccountTest__cffbf__BankCode__c] UNIQUE ([ffbf__BankCode__c])
) 
;

CREATE TABLE [ffbf__BankFormatDefinition__c] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [Name]                        VARCHAR(80),
  [CurrencyIsoCode]             VARCHAR(255),
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [ffbf__CSVOutput__c]          BIT NOT NULL,
  [ffbf__DoubleQuotes__c]       BIT NOT NULL,
  [ffbf__ExternalId__c]         VARCHAR(32) NOT NULL,
  [ffbf__UpperCase__c]          BIT NOT NULL,
CONSTRAINT [pk_ffbf__BankFormatDefinition__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffbf__BankFormatDefinition__cffbf__ExternalId__c] UNIQUE ([ffbf__ExternalId__c])
) 
;

CREATE TABLE [ffbf__BankFormatDefinitionField__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(80),
  [CurrencyIsoCode]                               VARCHAR(255),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [ffbf__BankFormatDefinitionRecordType__c]       VARCHAR(18) NOT NULL,
  [ffbf__BlankFilled__c]                          BIT NOT NULL,
  [ffbf__EndPosition__c]                          DECIMAL(5,0),
  [ffbf__ExternalId__c]                           VARCHAR(32) NOT NULL,
  [ffbf__LeftJustified__c]                        BIT NOT NULL,
  [ffbf__MustBeBlank__c]                          BIT NOT NULL,
  [ffbf__NoDecimals__c]                           BIT NOT NULL,
  [ffbf__NumericOnly__c]                          BIT NOT NULL,
  [ffbf__OutputSequence__c]                       DECIMAL(18,0) NOT NULL,
  [ffbf__RecordSize__c]                           DECIMAL(10,0),
  [ffbf__RecordType__c]                           VARCHAR(10),
  [ffbf__RecordValue__c]                          VARCHAR(80),
  [ffbf__RemoveDashes__c]                         BIT NOT NULL,
  [ffbf__RightJustified__c]                       BIT NOT NULL,
  [ffbf__StartPosition__c]                        DECIMAL(5,0),
  [ffbf__Unsigned__c]                             BIT NOT NULL,
  [ffbf__ZeroFilled__c]                           BIT NOT NULL,
CONSTRAINT [pk_ffbf__BankFormatDefinitionField__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffbf__BankFormatDefinitionField__cffbf__ExternalId__c] UNIQUE ([ffbf__ExternalId__c])
) 
;

CREATE TABLE [ffbf__BankFormatDefinitionRecordType__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(80),
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [ffbf__BankFormatDefinition__c]       VARCHAR(18) NOT NULL,
  [ffbf__ExternalId__c]                 VARCHAR(32) NOT NULL,
  [ffbf__OutputTypeSequence__c]         DECIMAL(5,0) NOT NULL,
  [ffbf__OutputTypeValue__c]            DECIMAL(2,0) NOT NULL,
  [ffbf__OutputType__c]                 VARCHAR(32),
  [ffbf__RecordTypeValue__c]            VARCHAR(255),
  [ffbf__RecordType__c]                 VARCHAR(10),
  [ffbf__RecordLength__c]               VARCHAR(30),
CONSTRAINT [pk_ffbf__BankFormatDefinitionRecordType__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffbf__BankFormatDefinitionRecordType__cffbf__ExternalId__c] UNIQUE ([ffbf__ExternalId__c])
) 
;

CREATE TABLE [ffbf__BankFormatDocumentConversion__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ffbf__FromDate__c]        DATE NOT NULL,
  [ffbf__ToDate__c]          DATE NOT NULL,
CONSTRAINT [pk_ffbf__BankFormatDocumentConversion__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__BankFormatMapping__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [OwnerId]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(80),
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [LastViewedDate]                      DATETIME2,
  [LastReferencedDate]                  DATETIME2,
  [ffbf__BankFormatDefinition__c]       VARCHAR(18),
  [ffbf__DateFormat__c]                 VARCHAR(24),
  [ffbf__DecimalSeparator__c]           VARCHAR(255),
  [ffbf__DefinitionExternalId__c]       VARCHAR(1300),
  [ffbf__RootSourceObject__c]           VARCHAR(80),
  [ffbf__ThousandsSeparator__c]         VARCHAR(255),
CONSTRAINT [pk_ffbf__BankFormatMapping__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__BankFormatMappingField__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(80),
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [ffbf__BankFormatMappingRecordType__c]       VARCHAR(18) NOT NULL,
  [ffbf__BankFormatRecordSourceField__c]       VARCHAR(18),
  [ffbf__FieldExternalId__c]                   VARCHAR(1300),
  [ffbf__OutputSequenceField__c]               DECIMAL(18,0),
  [ffbf__SourceFieldPath__c]                   VARCHAR(80),
  [ffbf__SourceField__c]                       VARCHAR(80),
  [ffbf__SourceLiteralExt__c]                  VARCHAR(80),
  [ffbf__SourceLiteral__c]                     VARCHAR(30),
  [ffbf__SourceObject__c]                      VARCHAR(80),
  [ffbf__TargetFieldPath__c]                   VARCHAR(80),
  [ffbf__TargetField__c]                       VARCHAR(80),
  [ffbf__TargetObject__c]                      VARCHAR(80),
CONSTRAINT [pk_ffbf__BankFormatMappingField__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__BankFormatMappingJoin__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [ffbf__BankFormatMapping__c]       VARCHAR(18) NOT NULL,
  [ffbf__ObjectFromField__c]         VARCHAR(80),
  [ffbf__ObjectFrom__c]              VARCHAR(80),
  [ffbf__ObjectToField__c]           VARCHAR(80),
  [ffbf__ObjectTo__c]                VARCHAR(80),
  [ffbf__RecordType__c]              VARCHAR(10),
CONSTRAINT [pk_ffbf__BankFormatMappingJoin__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__BankFormatMappingRecordType__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(80),
  [CurrencyIsoCode]                               VARCHAR(255),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [ffbf__BankFormatMapping__c]                    VARCHAR(18) NOT NULL,
  [ffbf__BankFormatDefinitionRecordType__c]       VARCHAR(18),
  [ffbf__OutputTypeSequence__c]                   DECIMAL(5,0) NOT NULL,
  [ffbf__RecordTypeExternalId__c]                 VARCHAR(1300),
  [ffbf__RootSourceObject__c]                     VARCHAR(80),
CONSTRAINT [pk_ffbf__BankFormatMappingRecordType__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__fflib_SchedulerConfiguration__c] ( 
  [Id]                                             VARCHAR(18) NOT NULL,
  [OwnerId]                                        VARCHAR(18) NOT NULL,
  [IsDeleted]                                      BIT NOT NULL,
  [Name]                                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                VARCHAR(255),
  [CreatedDate]                                    DATETIME2 NOT NULL,
  [CreatedById]                                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]                               DATETIME2 NOT NULL,
  [LastModifiedById]                               VARCHAR(18) NOT NULL,
  [SystemModstamp]                                 DATETIME2 NOT NULL,
  [ffbf__EndAfterX__c]                             DECIMAL(2,0),
  [ffbf__EndDate__c]                               DATE,
  [ffbf__HourlyRecurrenceInterval__c]              DECIMAL(2,0),
  [ffbf__MonthlyFixedDate__c]                      DECIMAL(2,0),
  [ffbf__MonthlyRecurMode__c]                      VARCHAR(255),
  [ffbf__MonthlyRecurRelativeDateFlavor__c]        VARCHAR(255),
  [ffbf__MonthlyRecurRelativeDateOrdinal__c]       VARCHAR(255),
  [ffbf__NearestWeekday__c]                        BIT NOT NULL,
  [ffbf__PreferredStartTimeHour__c]                DECIMAL(2,0),
  [ffbf__PreferredStartTimeMinute__c]              DECIMAL(2,0),
  [ffbf__SchedulingFrequency__c]                   VARCHAR(255),
  [ffbf__StartDate__c]                             DATE,
  [ffbf__VisibleFields__c]                         VARCHAR(1000),
  [ffbf__WeeklyRecurOnDays__c]                     VARCHAR(1000),
CONSTRAINT [pk_ffbf__fflib_SchedulerConfiguration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__fflib_BatchProcess__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [OwnerId]                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [ffirule__ApexJobClassName__c]              VARCHAR(80),
  [ffirule__ApexJobID__c]                     VARCHAR(18),
  [ffirule__BatchControlRecordID__c]          VARCHAR(18),
  [ffirule__ConcurrencyModeUniqueID__c]       VARCHAR(80),
  [ffirule__CurrentChainIndex__c]             DECIMAL(3,0),
  [ffirule__CurrentChainNumber__c]            DECIMAL(3,0),
  [ffirule__FailedRecordID__c]                VARCHAR(18),
  [ffirule__FromProgressBar__c]               BIT NOT NULL,
  [ffirule__NumberofBatchesinChain__c]        DECIMAL(3,0),
  [ffirule__ProcessName__c]                   VARCHAR(255),
  [ffirule__ProgressInformation__c]           VARCHAR(255),
  [ffirule__StatusDetail__c]                  VARCHAR(255),
  [ffirule__Status__c]                        VARCHAR(255),
  [ffirule__SuccessfulRecordID__c]            VARCHAR(18),
  [ffirule__TotalChainNumber__c]              DECIMAL(3,0),
  [ffirule__UseDefaultConstructor__c]         BIT NOT NULL,
CONSTRAINT [pk_ffirule__fflib_BatchProcess__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffirule__fflib_BatchProcess__cffirule__ApexJobID__c] UNIQUE ([ffirule__ApexJobID__c]),
CONSTRAINT [uk_ffirule__fflib_BatchProcess__cffirule__ConcurrencyModeUniqueID__c] UNIQUE ([ffirule__ConcurrencyModeUniqueID__c])
) 
;

CREATE TABLE [ffvat__fflib_BatchProcess__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [ffvat__ApexJobClassName__c]              VARCHAR(80),
  [ffvat__ApexJobID__c]                     VARCHAR(18),
  [ffvat__BatchControlRecordID__c]          VARCHAR(18),
  [ffvat__ConcurrencyModeUniqueID__c]       VARCHAR(80),
  [ffvat__CurrentChainIndex__c]             DECIMAL(3,0),
  [ffvat__CurrentChainNumber__c]            DECIMAL(3,0),
  [ffvat__FailedRecordID__c]                VARCHAR(18),
  [ffvat__FromProgressBar__c]               BIT NOT NULL,
  [ffvat__NumberofBatchesinChain__c]        DECIMAL(3,0),
  [ffvat__ProcessName__c]                   VARCHAR(255),
  [ffvat__ProgressInformation__c]           VARCHAR(255),
  [ffvat__StatusDetail__c]                  VARCHAR(255),
  [ffvat__Status__c]                        VARCHAR(255),
  [ffvat__SuccessfulRecordID__c]            VARCHAR(18),
  [ffvat__TotalChainNumber__c]              DECIMAL(3,0),
  [ffvat__UseDefaultConstructor__c]         BIT NOT NULL,
CONSTRAINT [pk_ffvat__fflib_BatchProcess__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffvat__fflib_BatchProcess__cffvat__ApexJobID__c] UNIQUE ([ffvat__ApexJobID__c]),
CONSTRAINT [uk_ffvat__fflib_BatchProcess__cffvat__ConcurrencyModeUniqueID__c] UNIQUE ([ffvat__ConcurrencyModeUniqueID__c])
) 
;

CREATE TABLE [ffvat__fflib_BatchProcessDetail__c] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [Name]                         VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [ffvat__BatchProcess__c]       VARCHAR(18) NOT NULL,
  [ffvat__ApexJobId__c]          VARCHAR(18),
  [ffvat__ChainNumber__c]        DECIMAL(3,0),
  [ffvat__StatusDetail__c]       VARCHAR(255),
  [ffvat__Status__c]             VARCHAR(255),
CONSTRAINT [pk_ffvat__fflib_BatchProcessDetail__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffvat__fflib_BatchProcessDetail__cffvat__ApexJobId__c] UNIQUE ([ffvat__ApexJobId__c])
) 
;

CREATE TABLE [ffirule__fflib_BatchProcessDetail__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [ffirule__BatchProcess__c]       VARCHAR(18) NOT NULL,
  [ffirule__ApexJobId__c]          VARCHAR(18),
  [ffirule__ChainNumber__c]        DECIMAL(3,0),
  [ffirule__StatusDetail__c]       VARCHAR(255),
  [ffirule__Status__c]             VARCHAR(255),
CONSTRAINT [pk_ffirule__fflib_BatchProcessDetail__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffirule__fflib_BatchProcessDetail__cffirule__ApexJobId__c] UNIQUE ([ffirule__ApexJobId__c])
) 
;

CREATE TABLE [fferpcore__BillingDocument__c] ( 
  [Id]                                                   VARCHAR(18) NOT NULL,
  [OwnerId]                                              VARCHAR(18) NOT NULL,
  [IsDeleted]                                            BIT NOT NULL,
  [Name]                                                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                      VARCHAR(255),
  [CreatedDate]                                          DATETIME2 NOT NULL,
  [CreatedById]                                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                     DATETIME2 NOT NULL,
  [LastModifiedById]                                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                                       DATETIME2 NOT NULL,
  [LastActivityDate]                                     DATE,
  [LastViewedDate]                                       DATETIME2,
  [LastReferencedDate]                                   DATETIME2,
  [fferpcore__Account__c]                                VARCHAR(18),
  [fferpcore__AllowRebilling__c]                         BIT NOT NULL,
  [fferpcore__AnalysisItem1__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem2__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem3__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem4__c]                          VARCHAR(18),
  [fferpcore__BillingAccountName__c]                     VARCHAR(255),
  [fferpcore__BillingCity__c]                            VARCHAR(40),
  [fferpcore__BillingCountry__c]                         VARCHAR(40),
  [fferpcore__BillingPostalCode__c]                      VARCHAR(20),
  [fferpcore__BillingState__c]                           VARCHAR(80),
  [fferpcore__BillingStreet__c]                          VARCHAR(255),
  [fferpcore__Company__c]                                VARCHAR(18),
  [fferpcore__CompletionProcessTracking__c]              VARCHAR(18),
  [fferpcore__CreditNoteReason__c]                       VARCHAR(255),
  [fferpcore__CustomerReference__c]                      VARCHAR(255),
  [fferpcore__DateIssued__c]                             DATE,
  [fferpcore__Description__c]                            VARCHAR(255),
  [fferpcore__DocumentDate__c]                           DATE NOT NULL,
  [fferpcore__DocumentDueDate__c]                        DATE,
  [fferpcore__DocumentSource__c]                         VARCHAR(255),
  [fferpcore__DocumentStatus__c]                         VARCHAR(255),
  [fferpcore__DocumentTypePrefix__c]                     VARCHAR(1300),
  [fferpcore__DocumentType__c]                           VARCHAR(255),
  [fferpcore__Engagement__c]                             VARCHAR(18),
  [fferpcore__ExternalDocumentNumber__c]                 VARCHAR(255),
  [fferpcore__ExternalTaxStatus__c]                      VARCHAR(255),
  [fferpcore__FooterText__c]                             TEXT,
  [fferpcore__HeaderText__c]                             TEXT,
  [fferpcore__IsBillingAddressValidated__c]              BIT NOT NULL,
  [fferpcore__IsComplete__c]                             BIT NOT NULL,
  [fferpcore__IsShippingAddressValidated__c]             BIT NOT NULL,
  [fferpcore__IsTaxCalculated__c]                        BIT NOT NULL,
  [fferpcore__ProcessingTaxDetails__c]                   BIT NOT NULL,
  [fferpcore__RelatedDocument__c]                        VARCHAR(18),
  [fferpcore__ReportingDocumentTotal__c]                 DECIMAL(16,2),
  [fferpcore__ShippingAccountName__c]                    VARCHAR(255),
  [fferpcore__ShippingCity__c]                           VARCHAR(40),
  [fferpcore__ShippingCountry__c]                        VARCHAR(40),
  [fferpcore__ShippingPostalCode__c]                     VARCHAR(20),
  [fferpcore__ShippingState__c]                          VARCHAR(80),
  [fferpcore__ShippingStreet__c]                         VARCHAR(255),
  [fferpcore__TaxPointDate__c]                           DATE,
  [fferpcore__ValidatedBillingCity__c]                   VARCHAR(40),
  [fferpcore__ValidatedBillingCountry__c]                VARCHAR(40),
  [fferpcore__ValidatedBillingPostalCode__c]             VARCHAR(20),
  [fferpcore__ValidatedBillingState__c]                  VARCHAR(20),
  [fferpcore__ValidatedBillingStreet__c]                 VARCHAR(255),
  [fferpcore__ValidatedShippingCity__c]                  VARCHAR(40),
  [fferpcore__ValidatedShippingCountry__c]               VARCHAR(40),
  [fferpcore__ValidatedShippingPostalCode__c]            VARCHAR(20),
  [fferpcore__ValidatedShippingState__c]                 VARCHAR(20),
  [fferpcore__ValidatedShippingStreet__c]                VARCHAR(255),
  [fferpcore__DiscountTotal__c]                          VARCHAR(30),
  [fferpcore__DocumentTotal__c]                          VARCHAR(30),
  [fferpcore__NetTotal__c]                               VARCHAR(30),
  [fferpcore__NumberOfBillingDocumentLineItems__c]       VARCHAR(30),
  [fferpcore__TaxValueTotal__c]                          VARCHAR(30),
  [ffaci__CongaEmailStatus__c]                           VARCHAR(255),
  [ffaci__CongaPrintStatus__c]                           VARCHAR(255),
  [ffaci__CongaTemplate__c]                              VARCHAR(1300),
  [bcws__ContractName__c]                                VARCHAR(1300),
  [bcws__ContractNumber__c]                              VARCHAR(1300),
  [bcws__DocumentOutstandingValue__c]                    DECIMAL(16,2),
  [bcws__TotalContractValue__c]                          DECIMAL(16,2),
CONSTRAINT [pk_fferpcore__BillingDocument__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__BillingDocument__cfferpcore__ExternalDocumentNumber__c] UNIQUE ([fferpcore__ExternalDocumentNumber__c])
) 
;

CREATE TABLE [fferpcore__BillingDocumentLineItem__c] ( 
  [Id]                                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                            BIT NOT NULL,
  [Name]                                                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                      VARCHAR(255),
  [CreatedDate]                                          DATETIME2 NOT NULL,
  [CreatedById]                                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                     DATETIME2 NOT NULL,
  [LastModifiedById]                                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                                       DATETIME2 NOT NULL,
  [LastActivityDate]                                     DATE,
  [fferpcore__BillingDocument__c]                        VARCHAR(18) NOT NULL,
  [fferpcore__Account__c]                                VARCHAR(18),
  [fferpcore__AnalysisItem1__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem2__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem3__c]                          VARCHAR(18),
  [fferpcore__AnalysisItem4__c]                          VARCHAR(18),
  [fferpcore__BillingDocumentExternalTaxStatus__c]       VARCHAR(1300),
  [fferpcore__BillingDocumentStatus__c]                  VARCHAR(1300),
  [fferpcore__CompanySite__c]                            VARCHAR(18),
  [fferpcore__DiscountTotal__c]                          DECIMAL(16,2),
  [fferpcore__InvalidCompanySite__c]                     BIT NOT NULL,
  [fferpcore__InvalidShippingAccount__c]                 BIT NOT NULL,
  [fferpcore__LineDescription__c]                        VARCHAR(255),
  [fferpcore__ManualAddressOverride__c]                  BIT NOT NULL,
  [fferpcore__NetValueBeforeDiscount__c]                 DECIMAL(16,2),
  [fferpcore__NetValueOverride__c]                       DECIMAL(16,2),
  [fferpcore__NetValue__c]                               DECIMAL(16,2),
  [fferpcore__ProductService__c]                         VARCHAR(18),
  [fferpcore__Quantity__c]                               DECIMAL(12,6) NOT NULL,
  [fferpcore__ReportingNetValueNumber__c]                DECIMAL(16,2),
  [fferpcore__ReportingNetValue__c]                      DECIMAL(16,2),
  [fferpcore__ReportingTaxValue1__c]                     DECIMAL(16,2),
  [fferpcore__ReportingTaxValue2__c]                     DECIMAL(16,2),
  [fferpcore__ReportingTaxValue3__c]                     DECIMAL(16,2),
  [fferpcore__ReportingTaxValueTotal__c]                 DECIMAL(16,2),
  [fferpcore__ReportingTotalValue__c]                    DECIMAL(16,2),
  [fferpcore__ShippingCity__c]                           VARCHAR(40),
  [fferpcore__ShippingCountry__c]                        VARCHAR(40),
  [fferpcore__ShippingPostalCode__c]                     VARCHAR(20),
  [fferpcore__ShippingState__c]                          VARCHAR(80),
  [fferpcore__ShippingStreet__c]                         VARCHAR(255),
  [fferpcore__TaxCode1__c]                               VARCHAR(18),
  [fferpcore__TaxCode2__c]                               VARCHAR(18),
  [fferpcore__TaxCode3__c]                               VARCHAR(18),
  [fferpcore__TaxRate1__c]                               DECIMAL(5,5),
  [fferpcore__TaxRate2__c]                               DECIMAL(5,5),
  [fferpcore__TaxRate3__c]                               DECIMAL(5,5),
  [fferpcore__TaxRateTotal__c]                           DECIMAL(13,5),
  [fferpcore__TaxValue1__c]                              DECIMAL(16,2),
  [fferpcore__TaxValue2__c]                              DECIMAL(16,2),
  [fferpcore__TaxValue3__c]                              DECIMAL(16,2),
  [fferpcore__TaxValueTotal__c]                          DECIMAL(16,2),
  [fferpcore__TotalValue__c]                             DECIMAL(16,2),
  [fferpcore__UnitPrice__c]                              DECIMAL(9,9) NOT NULL,
CONSTRAINT [pk_fferpcore__BillingDocumentLineItem__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Briefing__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(80),
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastActivityDate]         DATE,
  [Active__c]                BIT NOT NULL,
  [BriefingDetails__c]       TEXT,
  [EndDate__c]               DATETIME2,
  [External_ID__c]           VARCHAR(255),
  [PostedDate__c]            DATETIME2,
CONSTRAINT [pk_Briefing__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_Briefing__cExternal_ID__c] UNIQUE ([External_ID__c])
) 
;

CREATE TABLE [BriefingLog__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [Briefing__c]            VARCHAR(18) NOT NULL,
  [BriefingId__c]          VARCHAR(100),
  [User__c]                VARCHAR(18),
CONSTRAINT [pk_BriefingLog__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_BriefingLog__cBriefingId__c] UNIQUE ([BriefingId__c])
) 
;

CREATE TABLE [et4ae5__Business_Unit__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__Business_Unit__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [sc_lightning__Call_Report__c] ( 
  [Id]                                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                                               BIT NOT NULL,
  [Name]                                                    VARCHAR(80),
  [CurrencyIsoCode]                                         VARCHAR(255),
  [CreatedDate]                                             DATETIME2 NOT NULL,
  [CreatedById]                                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                        DATETIME2 NOT NULL,
  [LastModifiedById]                                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                                          DATETIME2 NOT NULL,
  [LastViewedDate]                                          DATETIME2,
  [LastReferencedDate]                                      DATETIME2,
  [sc_lightning__Case__c]                                   VARCHAR(18),
  [sc_lightning__SightcallId__c]                            VARCHAR(50) NOT NULL,
  [sc_lightning__acdProductId__c]                           DECIMAL(18,0),
  [sc_lightning__acdProductName__c]                         VARCHAR(50),
  [sc_lightning__advancedConnectionControlsCount__c]        DECIMAL(3,0),
  [sc_lightning__agentGeoipCountry__c]                      VARCHAR(10),
  [sc_lightning__agentId__c]                                DECIMAL(18,0),
  [sc_lightning__agentLogin__c]                             VARCHAR(80),
  [sc_lightning__agentMobile__c]                            BIT NOT NULL,
  [sc_lightning__agentRealtime__c]                          VARCHAR(10),
  [sc_lightning__agentShareControlsCount__c]                DECIMAL(3,0),
  [sc_lightning__agentTest__c]                              BIT NOT NULL,
  [sc_lightning__annotationControlsCount__c]                DECIMAL(3,0),
  [sc_lightning__attendeesCount__c]                         DECIMAL(3,0),
  [sc_lightning__caseReportsCount__c]                       DECIMAL(2,0),
  [sc_lightning__chatMessagesCount__c]                      DECIMAL(3,0),
  [sc_lightning__closedAt__c]                               DATETIME2,
  [sc_lightning__cobrowsingControlsCount__c]                DECIMAL(3,0),
  [sc_lightning__connectionControlsCount__c]                DECIMAL(3,0),
  [sc_lightning__duration__c]                               DECIMAL(18,0),
  [sc_lightning__endReason__c]                              VARCHAR(30),
  [sc_lightning__endedAt__c]                                DATETIME2,
  [sc_lightning__guestDeviceModel__c]                       VARCHAR(50),
  [sc_lightning__guestDeviceType__c]                        VARCHAR(50),
  [sc_lightning__guestGeoipCountry__c]                      VARCHAR(10),
  [sc_lightning__guestGpsAccuracy__c]                       DECIMAL(10,8),
  [sc_lightning__guestGpsLatitude__c]                       DECIMAL(10,10),
  [sc_lightning__guestGpsLongitude__c]                      DECIMAL(10,10),
  [sc_lightning__guestRealtime__c]                          VARCHAR(10),
  [sc_lightning__noteControlsCount__c]                      DECIMAL(3,0),
  [sc_lightning__ocrControlsCount__c]                       DECIMAL(3,0),
  [sc_lightning__offlineMediaSharingControlsCount__c]       DECIMAL(3,0),
  [sc_lightning__openedAt__c]                               DATETIME2,
  [sc_lightning__pictureControlsCount__c]                   DECIMAL(3,0),
  [sc_lightning__pincodeMedia__c]                           VARCHAR(50),
  [sc_lightning__recordingsCount__c]                        DECIMAL(3,0),
  [sc_lightning__reference__c]                              VARCHAR(255),
  [sc_lightning__savedLiveQrAndBarCodesCount__c]            DECIMAL(3,0),
  [sc_lightning__savedMeasuresCount__c]                     DECIMAL(3,0),
  [sc_lightning__savedPicturesCount__c]                     DECIMAL(3,0),
  [sc_lightning__screencastingControlsCount__c]             DECIMAL(3,0),
  [sc_lightning__snapshotControlsCount__c]                  DECIMAL(3,0),
  [sc_lightning__startedAt__c]                              DATETIME2,
  [sc_lightning__tenantId__c]                               DECIMAL(18,0),
  [sc_lightning__tenantName__c]                             VARCHAR(50),
  [sc_lightning__tenantType__c]                             VARCHAR(50),
  [sc_lightning__uhdSnapshotControlsCount__c]               DECIMAL(3,0),
  [sc_lightning__usecaseCallDistribution__c]                VARCHAR(50),
  [sc_lightning__usecaseId__c]                              DECIMAL(18,0),
  [sc_lightning__usecaseName__c]                            VARCHAR(50),
  [sc_lightning__SightCall_Case__c]                         VARCHAR(18),
  [sc_lightning__callsCount__c]                             DECIMAL(16,2),
  [sc_lightning__longCallsCount__c]                         DECIMAL(18,0),
  [sc_lightning__pincodeContact__c]                         VARCHAR(120),
  [sc_lightning__pincodeValue__c]                           DECIMAL(18,0),
  [sc_lightning__shortCallsCount__c]                        DECIMAL(18,0),
CONSTRAINT [pk_sc_lightning__Call_Report__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_sc_lightning__Call_Report__csc_lightning__SightcallId__c] UNIQUE ([sc_lightning__SightcallId__c])
) 
;

CREATE TABLE [Campaign] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(80) NOT NULL,
  [ParentId]                                VARCHAR(18),
  [Type]                                    VARCHAR(255),
  [RecordTypeId]                            VARCHAR(18),
  [Status]                                  VARCHAR(255),
  [StartDate]                               DATE,
  [EndDate]                                 DATE,
  [CurrencyIsoCode]                         VARCHAR(255),
  [ExpectedRevenue]                         DECIMAL(18,0),
  [BudgetedCost]                            DECIMAL(18,0),
  [ActualCost]                              DECIMAL(18,0),
  [ExpectedResponse]                        DECIMAL(8,2),
  [NumberSent]                              DECIMAL(18,0),
  [IsActive]                                BIT NOT NULL,
  [Description]                             TEXT,
  [NumberOfLeads]                           VARCHAR(255) NOT NULL,
  [NumberOfConvertedLeads]                  VARCHAR(255) NOT NULL,
  [NumberOfContacts]                        VARCHAR(255) NOT NULL,
  [NumberOfResponses]                       VARCHAR(255) NOT NULL,
  [NumberOfOpportunities]                   VARCHAR(255) NOT NULL,
  [NumberOfWonOpportunities]                VARCHAR(255) NOT NULL,
  [AmountAllOpportunities]                  DECIMAL(18,0) NOT NULL,
  [AmountWonOpportunities]                  DECIMAL(18,0) NOT NULL,
  [HierarchyNumberOfLeads]                  VARCHAR(255),
  [HierarchyNumberOfConvertedLeads]         VARCHAR(255),
  [HierarchyNumberOfContacts]               VARCHAR(255),
  [HierarchyNumberOfResponses]              VARCHAR(255),
  [HierarchyNumberOfOpportunities]          VARCHAR(255),
  [HierarchyNumberOfWonOpportunities]       VARCHAR(255),
  [HierarchyAmountAllOpportunities]         DECIMAL(18,0),
  [HierarchyAmountWonOpportunities]         DECIMAL(18,0),
  [HierarchyNumberSent]                     DECIMAL(18,0),
  [HierarchyExpectedRevenue]                DECIMAL(18,0),
  [HierarchyBudgetedCost]                   DECIMAL(18,0),
  [HierarchyActualCost]                     DECIMAL(18,0),
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [LastActivityDate]                        DATE,
  [LastViewedDate]                          DATETIME2,
  [LastReferencedDate]                      DATETIME2,
  [CampaignMemberRecordTypeId]              VARCHAR(18),
  [Channel__c]                              VARCHAR(255),
  [Company__c]                              VARCHAR(255),
  [External_Id__c]                          VARCHAR(255),
  [Language__c]                             VARCHAR(255),
  [Priority__c]                             VARCHAR(255),
  [Promo_Code__c]                           VARCHAR(18),
  [SourceCode_L__c]                         VARCHAR(50),
  [TollFreeNumber__c]                       VARCHAR(18),
  [Audience__c]                             VARCHAR(255),
  [Format__c]                               VARCHAR(255),
  [Location__c]                             VARCHAR(255),
  [Media__c]                                VARCHAR(255),
  [DPNCode__c]                              VARCHAR(30),
  [DWCCode__c]                              VARCHAR(30),
  [DWFCode__c]                              VARCHAR(30),
  [MPNCode__c]                              VARCHAR(30),
  [MWCCode__c]                              VARCHAR(30),
  [MWFCode__c]                              VARCHAR(30),
  [Gleam_Id__c]                             VARCHAR(50),
  [DialerMiscCode__c]                       VARCHAR(1300),
  [Origin__c]                               VARCHAR(255),
  [Dialer_Misc_Code__c]                     VARCHAR(1300),
  [Toll_Free_Desktop__c]                    VARCHAR(18),
  [Toll_Free_Mobile__c]                     VARCHAR(18),
  [DB_Campaign_Tactic__c]                   VARCHAR(255),
  [CampaignSource__c]                       VARCHAR(255),
CONSTRAINT [pk_Campaign] PRIMARY KEY ([Id]),
CONSTRAINT [uk_CampaignExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [CampaignMember] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [CampaignId]                             VARCHAR(18) NOT NULL,
  [LeadId]                                 VARCHAR(18),
  [ContactId]                              VARCHAR(18),
  [Status]                                 VARCHAR(255),
  [HasResponded]                           BIT NOT NULL,
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [FirstRespondedDate]                     DATE,
  [CurrencyIsoCode]                        VARCHAR(255),
  [Salutation]                             VARCHAR(255),
  [Name]                                   VARCHAR(255),
  [FirstName]                              VARCHAR(40),
  [LastName]                               VARCHAR(80),
  [Title]                                  VARCHAR(128),
  [Street]                                 VARCHAR(255),
  [City]                                   VARCHAR(40),
  [State]                                  VARCHAR(80),
  [PostalCode]                             VARCHAR(20),
  [Country]                                VARCHAR(80),
  [Email]                                  VARCHAR(128),
  [Phone]                                  VARCHAR(40),
  [Fax]                                    VARCHAR(40),
  [MobilePhone]                            VARCHAR(40),
  [Description]                            TEXT,
  [DoNotCall]                              BIT NOT NULL,
  [HasOptedOutOfEmail]                     BIT NOT NULL,
  [HasOptedOutOfFax]                       BIT NOT NULL,
  [LeadSource]                             VARCHAR(255),
  [CompanyOrAccount]                       VARCHAR(255),
  [Type]                                   VARCHAR(40),
  [LeadOrContactId]                        VARCHAR(18),
  [LeadOrContactOwnerId]                   VARCHAR(18),
  [Opportunity__c]                         VARCHAR(18),
  [SourceCode__c]                          VARCHAR(255),
  [Device_Type__c]                         VARCHAR(1300),
  [Do_Not_Call_from_Lead_Contact__c]       BIT NOT NULL,
  [Last_Activity_Date__c]                  DATE,
  [Lead_Status__c]                         VARCHAR(1300),
  [Time_Zone__c]                           DATE,
CONSTRAINT [pk_CampaignMember] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__Campaign_Member_Configuration__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__Campaign_Member_Configuration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [CampaignMemberStatus] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [CampaignId]             VARCHAR(18) NOT NULL,
  [Label]                  VARCHAR(765) NOT NULL,
  [SortOrder]              VARCHAR(255),
  [IsDefault]              BIT NOT NULL,
  [HasResponded]           BIT NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_CampaignMemberStatus] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Case] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [MasterRecordId]                     VARCHAR(18),
  [CaseNumber]                         VARCHAR(255) NOT NULL,
  [ContactId]                          VARCHAR(18),
  [AccountId]                          VARCHAR(18),
  [AssetId]                            VARCHAR(18),
  [ProductId]                          VARCHAR(18),
  [EntitlementId]                      VARCHAR(18),
  [SourceId]                           VARCHAR(18),
  [BusinessHoursId]                    VARCHAR(18) NOT NULL,
  [ParentId]                           VARCHAR(18),
  [SuppliedName]                       VARCHAR(80),
  [SuppliedEmail]                      VARCHAR(128),
  [SuppliedPhone]                      VARCHAR(40),
  [SuppliedCompany]                    VARCHAR(80),
  [Type]                               VARCHAR(255),
  [RecordTypeId]                       VARCHAR(18),
  [Status]                             VARCHAR(255),
  [Reason]                             VARCHAR(255),
  [Origin]                             VARCHAR(255),
  [Language]                           VARCHAR(255),
  [Subject]                            VARCHAR(255),
  [Priority]                           VARCHAR(255),
  [Description]                        TEXT,
  [IsClosed]                           BIT NOT NULL,
  [ClosedDate]                         DATETIME2,
  [IsEscalated]                        BIT NOT NULL,
  [CurrencyIsoCode]                    VARCHAR(255),
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [IsClosedOnCreate]                   BIT NOT NULL,
  [SlaStartDate]                       DATETIME2,
  [SlaExitDate]                        DATETIME2,
  [IsStopped]                          BIT NOT NULL,
  [StopStartDate]                      DATETIME2,
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [ContactPhone]                       VARCHAR(40),
  [ContactMobile]                      VARCHAR(40),
  [ContactEmail]                       VARCHAR(128),
  [ContactFax]                         VARCHAR(40),
  [Comments]                           TEXT,
  [LastViewedDate]                     DATETIME2,
  [LastReferencedDate]                 DATETIME2,
  [ServiceContractId]                  VARCHAR(18),
  [MilestoneStatus]                    VARCHAR(30),
  [External_Id__c]                     VARCHAR(255),
  [Accommodation__c]                   VARCHAR(255),
  [AssignedTo__c]                      VARCHAR(255),
  [CallType__c]                        VARCHAR(255),
  [Campaign__c]                        VARCHAR(18),
  [CaseAltPhone__c]                    VARCHAR(40),
  [CaseName__c]                        VARCHAR(255),
  [CasePhone__c]                       VARCHAR(40),
  [Case_Source_Chat__c]                VARCHAR(1300),
  [Category__c]                        VARCHAR(255),
  [CenterEmployee__c]                  VARCHAR(50),
  [Center__c]                          VARCHAR(18),
  [Content__c]                         TEXT,
  [Courteous__c]                       VARCHAR(255),
  [DateofAppointment__c]               DATE,
  [DateofIncident__c]                  DATE,
  [Didyousignup__c]                    VARCHAR(255),
  [Estimated_Completion_Date__c]       DATE,
  [FeedbackType__c]                    VARCHAR(255),
  [LeadEmail__c]                       VARCHAR(1300),
  [LeadId__c]                          VARCHAR(18),
  [LeadPhone__c]                       VARCHAR(1300),
  [OptionOffered__c]                   VARCHAR(50),
  [Points__c]                          VARCHAR(255),
  [PricePlan__c]                       VARCHAR(50),
  [Resolution__c]                      TEXT,
  [SignIn__c]                          VARCHAR(255),
  [TimeofIncident__c]                  VARCHAR(255),
  [Title__c]                           VARCHAR(80),
  [Wereyouontime__c]                   VARCHAR(255),
CONSTRAINT [pk_Case] PRIMARY KEY ([Id]),
CONSTRAINT [uk_CaseExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [CaseMilestone] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [CaseId]                      VARCHAR(18) NOT NULL,
  [StartDate]                   DATETIME2,
  [TargetDate]                  DATETIME2 NOT NULL,
  [CompletionDate]              DATETIME2,
  [MilestoneTypeId]             VARCHAR(18),
  [IsCompleted]                 BIT NOT NULL,
  [IsViolated]                  BIT NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [TargetResponseInMins]        VARCHAR(255),
  [TargetResponseInHrs]         DECIMAL(4,2),
  [TargetResponseInDays]        DECIMAL(4,2),
  [TimeRemainingInMins]         VARCHAR(10),
  [TimeRemainingInHrs]          VARCHAR(10),
  [TimeRemainingInDays]         DECIMAL(4,2),
  [ElapsedTimeInMins]           VARCHAR(255),
  [ElapsedTimeInHrs]            DECIMAL(4,2),
  [ElapsedTimeInDays]           DECIMAL(4,2),
  [TimeSinceTargetInMins]       VARCHAR(10),
  [TimeSinceTargetInHrs]        VARCHAR(10),
  [TimeSinceTargetInDays]       DECIMAL(4,2),
  [BusinessHoursId]             VARCHAR(18),
CONSTRAINT [pk_CaseMilestone] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [LiveAgentSession] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [OwnerId]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [AgentId]                        VARCHAR(18) NOT NULL,
  [LoginTime]                      DATETIME2 NOT NULL,
  [LogoutTime]                     DATETIME2 NOT NULL,
  [TimeInOnlineStatus]             VARCHAR(255),
  [TimeInAwayStatus]               VARCHAR(255),
  [TimeInChats]                    VARCHAR(255),
  [TimeIdle]                       VARCHAR(255),
  [TimeAtCapacity]                 VARCHAR(255),
  [ChatReqAssigned]                VARCHAR(255),
  [ChatReqEngaged]                 VARCHAR(255),
  [ChatReqDeclined]                VARCHAR(255),
  [ChatReqTimedOut]                VARCHAR(255),
  [NumFlagRaised]                  VARCHAR(255),
  [NumFlagLoweredAgent]            VARCHAR(255),
  [NumFlagLoweredSupervisor]       VARCHAR(255),
CONSTRAINT [pk_LiveAgentSession] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [LiveChatTranscript] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [LiveChatVisitorId]                 VARCHAR(18) NOT NULL,
  [Body]                              TEXT,
  [ContactId]                         VARCHAR(18),
  [LeadId]                            VARCHAR(18),
  [CaseId]                            VARCHAR(18),
  [AccountId]                         VARCHAR(18),
  [LiveChatDeploymentId]              VARCHAR(18),
  [LiveChatButtonId]                  VARCHAR(18),
  [SkillId]                           VARCHAR(18),
  [IpAddress]                         VARCHAR(39),
  [Location]                          VARCHAR(200),
  [UserAgent]                         VARCHAR(200),
  [Browser]                           VARCHAR(200),
  [Platform]                          VARCHAR(200),
  [BrowserLanguage]                   VARCHAR(200),
  [ScreenResolution]                  VARCHAR(200),
  [ReferrerUri]                       VARCHAR(200),
  [Status]                            VARCHAR(255),
  [RequestTime]                       DATETIME2,
  [StartTime]                         DATETIME2,
  [EndTime]                           DATETIME2,
  [EndedBy]                           VARCHAR(255),
  [AverageResponseTimeVisitor]        VARCHAR(255),
  [AverageResponseTimeOperator]       VARCHAR(255),
  [OperatorMessageCount]              VARCHAR(255),
  [VisitorMessageCount]               VARCHAR(255),
  [MaxResponseTimeOperator]           VARCHAR(255),
  [ChatKey]                           VARCHAR(200),
  [SupervisorTranscriptBody]          TEXT,
  [MaxResponseTimeVisitor]            VARCHAR(255),
  [VisitorNetwork]                    VARCHAR(200),
  [ChatDuration]                      VARCHAR(30),
  [WaitTime]                          VARCHAR(30),
  [Abandoned]                         VARCHAR(30),
  [IsChatbotSession]                  BIT NOT NULL,
  [Account__c]                        VARCHAR(18),
CONSTRAINT [pk_LiveChatTranscript] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [LiveChatVisitor] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [SessionKey]               VARCHAR(200),
CONSTRAINT [pk_LiveChatVisitor] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__Chunk__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [fferpcore__ScheduledJobRun__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_fferpcore__Chunk__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleAction__c] ( 
  [Id]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                    BIT NOT NULL,
  [Name]                                         VARCHAR(80),
  [CurrencyIsoCode]                              VARCHAR(255),
  [CreatedDate]                                  DATETIME2 NOT NULL,
  [CreatedById]                                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]                             DATETIME2 NOT NULL,
  [LastModifiedById]                             VARCHAR(18) NOT NULL,
  [SystemModstamp]                               DATETIME2 NOT NULL,
  [LastActivityDate]                             DATE,
  [ffirule__IntegrationRule__c]                  VARCHAR(18) NOT NULL,
  [ffirule__ActionMessage__c]                    VARCHAR(250) NOT NULL,
  [ffirule__ActionName__c]                       VARCHAR(250) NOT NULL,
  [ffirule__FeedLinkMessageTargetField__c]       VARCHAR(50),
  [ffirule__FeedLinkMessage__c]                  VARCHAR(50),
  [ffirule__FeedMessageTargetField__c]           VARCHAR(250),
  [ffirule__FeedMessage__c]                      VARCHAR(250),
  [ffirule__VisualForce__c]                      VARCHAR(1300),
CONSTRAINT [pk_ffirule__IntegrationRuleAction__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__ClickLinkAnotherSourceTest__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                               VARCHAR(255),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [ffirule__ClickLinkSourceLineItemTest__c]       VARCHAR(18) NOT NULL,
  [ffirule__ATextField__c]                        VARCHAR(32),
CONSTRAINT [pk_ffirule__ClickLinkAnotherSourceTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleButton__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(80),
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [LastActivityDate]                          DATE,
  [ffirule__IntegrationRule__c]               VARCHAR(18) NOT NULL,
  [ffirule__DetailPageButton__c]              VARCHAR(1300),
  [ffirule__ListButton__c]                    VARCHAR(1300),
  [ffirule__ListObjectSourceIDField__c]       VARCHAR(80),
  [ffirule__ListObject__c]                    VARCHAR(80),
  [ffirule__VisualforcePage__c]               VARCHAR(250),
CONSTRAINT [pk_ffirule__IntegrationRuleButton__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleJob__c] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [Name]                                             VARCHAR(80),
  [CurrencyIsoCode]                                  VARCHAR(255),
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [LastActivityDate]                                 DATE,
  [LastViewedDate]                                   DATETIME2,
  [LastReferencedDate]                               DATETIME2,
  [ffirule__IntegrationRule__c]                      VARCHAR(18) NOT NULL,
  [ffirule__ListViewName__c]                         VARCHAR(80) NOT NULL,
  [ffirule__ListViewObject__c]                       VARCHAR(80),
  [ffirule__ListViewSourceIDField__c]                VARCHAR(80),
  [ffirule__ScheduledApexJobCronExpression__c]       VARCHAR(255),
  [ffirule__ScheduledApexJobID__c]                   VARCHAR(32),
CONSTRAINT [pk_ffirule__IntegrationRuleJob__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleLineLookupTest__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [OwnerId]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(80),
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [ffirule__ClickLinkLookupTest__c]       VARCHAR(18),
CONSTRAINT [pk_ffirule__IntegrationRuleLineLookupTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleLog__c] ( 
  [Id]                                                VARCHAR(18) NOT NULL,
  [OwnerId]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                         BIT NOT NULL,
  [Name]                                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                   VARCHAR(255),
  [CreatedDate]                                       DATETIME2 NOT NULL,
  [CreatedById]                                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                  DATETIME2 NOT NULL,
  [LastModifiedById]                                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                                    DATETIME2 NOT NULL,
  [LastViewedDate]                                    DATETIME2,
  [LastReferencedDate]                                DATETIME2,
  [ffirule__ApexJobID__c]                             VARCHAR(32),
  [ffirule__IntegrationRuleButton__c]                 VARCHAR(18),
  [ffirule__IntegrationRuleJobNoneScheduled__c]       BIT NOT NULL,
  [ffirule__IntegrationRuleJob__c]                    VARCHAR(18),
  [ffirule__IntegrationRule__c]                       VARCHAR(18),
  [ffirule__Summary__c]                               VARCHAR(255),
  [ffirule__User__c]                                  VARCHAR(18),
  [ffirule__Errors__c]                                VARCHAR(30),
  [ffirule__Lines__c]                                 VARCHAR(30),
CONSTRAINT [pk_ffirule__IntegrationRuleLog__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffirule__IntegrationRuleLog__cffirule__ApexJobID__c] UNIQUE ([ffirule__ApexJobID__c])
) 
;

CREATE TABLE [ffirule__IntegrationRuleLogLineItem__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [ffirule__IntegrationRuleLog__c]              VARCHAR(18) NOT NULL,
  [ffirule__CreatedDate__c]                     DATETIME2,
  [ffirule__Message__c]                         TEXT,
  [ffirule__RelatedSourceLineItemTest__c]       VARCHAR(18),
  [ffirule__RelatedSourceTest__c]               VARCHAR(18),
  [ffirule__Severity__c]                        VARCHAR(255),
CONSTRAINT [pk_ffirule__IntegrationRuleLogLineItem__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleLookupTest__c] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [Name]                         VARCHAR(80),
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [ffirule__ATextField__c]       VARCHAR(30),
  [ffirule__ExternalId__c]       VARCHAR(40),
CONSTRAINT [pk_ffirule__IntegrationRuleLookupTest__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffirule__IntegrationRuleLookupTest__cffirule__ExternalId__c] UNIQUE ([ffirule__ExternalId__c])
) 
;

CREATE TABLE [ffirule__ClickLinkManagedJob__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [OwnerId]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [ffirule__ApexJobID__c]          VARCHAR(80),
  [ffirule__ClickLinkJob__c]       VARCHAR(18),
  [ffirule__SourceObject__c]       VARCHAR(80) NOT NULL,
CONSTRAINT [pk_ffirule__ClickLinkManagedJob__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ffirule__ClickLinkManagedJob__cffirule__SourceObject__c] UNIQUE ([ffirule__SourceObject__c])
) 
;

CREATE TABLE [ffirule__IntegrationRuleMapping__c] ( 
  [Id]                                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                                          BIT NOT NULL,
  [Name]                                               VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                    VARCHAR(255),
  [CreatedDate]                                        DATETIME2 NOT NULL,
  [CreatedById]                                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                   DATETIME2 NOT NULL,
  [LastModifiedById]                                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                                     DATETIME2 NOT NULL,
  [LastActivityDate]                                   DATE,
  [ffirule__IntegrationRule__c]                        VARCHAR(18) NOT NULL,
  [ffirule__AllowNewRecordCreationOnLookup__c]         BIT NOT NULL,
  [ffirule__AlternateLookupResolutionField__c]         VARCHAR(80),
  [ffirule__MappingLiteral__c]                         VARCHAR(255),
  [ffirule__MappingType__c]                            VARCHAR(255),
  [ffirule__SourceField__c]                            VARCHAR(80),
  [ffirule__SourceObject__c]                           VARCHAR(80),
  [ffirule__SourceResolutionControlField__c]           VARCHAR(80),
  [ffirule__SourceResolutionControlValueIsId__c]       BIT NOT NULL,
  [ffirule__SourceSync__c]                             BIT NOT NULL,
  [ffirule__SourceValueIsId__c]                        BIT NOT NULL,
  [ffirule__TargetField__c]                            VARCHAR(80) NOT NULL,
  [ffirule__TargetLookupResolutionField__c]            VARCHAR(80),
  [ffirule__TargetRecordBasedOn__c]                    VARCHAR(255),
  [ffirule__TargetRecordType__c]                       VARCHAR(80),
CONSTRAINT [pk_ffirule__IntegrationRuleMapping__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleRelationship__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(80),
  [CurrencyIsoCode]                               VARCHAR(255),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [LastActivityDate]                              DATE,
  [ffirule__IntegrationRule__c]                   VARCHAR(18) NOT NULL,
  [ffirule__RelationshipIntegrationRule__c]       VARCHAR(18),
  [ffirule__RelationshipName__c]                  VARCHAR(80),
  [ffirule__RelationshipSourceObject__c]          VARCHAR(1300),
  [ffirule__RelationshipTargetField__c]           VARCHAR(80) NOT NULL,
  [ffirule__RelationshipTargetObject__c]          VARCHAR(1300),
  [ffirule__SourceRelationshipField__c]           VARCHAR(80),
CONSTRAINT [pk_ffirule__IntegrationRuleRelationship__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRule__c] ( 
  [Id]                                                   VARCHAR(18) NOT NULL,
  [OwnerId]                                              VARCHAR(18) NOT NULL,
  [IsDeleted]                                            BIT NOT NULL,
  [Name]                                                 VARCHAR(80),
  [CurrencyIsoCode]                                      VARCHAR(255),
  [CreatedDate]                                          DATETIME2 NOT NULL,
  [CreatedById]                                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                     DATETIME2 NOT NULL,
  [LastModifiedById]                                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                                       DATETIME2 NOT NULL,
  [LastActivityDate]                                     DATE,
  [LastViewedDate]                                       DATETIME2,
  [LastReferencedDate]                                   DATETIME2,
  [ffirule__EmailTemplate__c]                            VARCHAR(80),
  [ffirule__PartialSave__c]                              BIT NOT NULL,
  [ffirule__RuleExplanation__c]                          VARCHAR(255),
  [ffirule__ScopeSize__c]                                DECIMAL(18,0),
  [ffirule__SourceObjectNameField__c]                    VARCHAR(80) NOT NULL,
  [ffirule__SourceObjectProcessField__c]                 VARCHAR(80),
  [ffirule__SourceObjectProcessedField__c]               VARCHAR(80),
  [ffirule__SourceObjectReferenceToTargetField__c]       VARCHAR(80),
  [ffirule__SourceObject__c]                             VARCHAR(80) NOT NULL,
  [ffirule__SyncEnabled__c]                              BIT NOT NULL,
  [ffirule__SyncIsMaster__c]                             BIT NOT NULL,
  [ffirule__TargetCreationOnSourceInsert__c]             VARCHAR(255),
  [ffirule__TargetObjectNameField__c]                    VARCHAR(80) NOT NULL,
  [ffirule__TargetObjectProcessedField__c]               VARCHAR(80),
  [ffirule__TargetObjectSourceCountField__c]             VARCHAR(80),
  [ffirule__TargetObjectSyncActiveField__c]              VARCHAR(80),
  [ffirule__TargetObjectSyncControlField__c]             VARCHAR(80),
  [ffirule__TargetObjectSyncControlWhen__c]              VARCHAR(255),
  [ffirule__TargetObject__c]                             VARCHAR(80) NOT NULL,
  [ffirule__TargetSourceMaximum__c]                      DECIMAL(18,0),
CONSTRAINT [pk_ffirule__IntegrationRule__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleSourceLineItemTest__c] ( 
  [Id]                                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                                             BIT NOT NULL,
  [Name]                                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                       VARCHAR(255),
  [CreatedDate]                                           DATETIME2 NOT NULL,
  [CreatedById]                                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                      DATETIME2 NOT NULL,
  [LastModifiedById]                                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                                        DATETIME2 NOT NULL,
  [ffirule__IntegrationRuleSourceTest__c]                 VARCHAR(18) NOT NULL,
  [ffirule__ABooleanField__c]                             BIT NOT NULL,
  [ffirule__ANumberField__c]                              DECIMAL(16,2),
  [ffirule__ATextField__c]                                VARCHAR(32),
  [ffirule__AnotherTextField__c]                          VARCHAR(32),
  [ffirule__ProcessFormula__c]                            DECIMAL(18,0),
  [ffirule__Process__c]                                   BIT NOT NULL,
  [ffirule__Processed__c]                                 BIT NOT NULL,
  [ffirule__ClickLinkAnotherSourceLineItemCount__c]       VARCHAR(30),
CONSTRAINT [pk_ffirule__IntegrationRuleSourceLineItemTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleSourceListViewTest__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(80),
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [ffirule__IntegrationRuleSourceTest__c]       VARCHAR(18),
CONSTRAINT [pk_ffirule__IntegrationRuleSourceListViewTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleSourceTest__c] ( 
  [Id]                                                VARCHAR(18) NOT NULL,
  [OwnerId]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                         BIT NOT NULL,
  [Name]                                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                   VARCHAR(255),
  [CreatedDate]                                       DATETIME2 NOT NULL,
  [CreatedById]                                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                  DATETIME2 NOT NULL,
  [LastModifiedById]                                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                                    DATETIME2 NOT NULL,
  [ffirule__ABooleanField__c]                         BIT NOT NULL,
  [ffirule__ADateField__c]                            DATE,
  [ffirule__ALookupField__c]                          VARCHAR(18),
  [ffirule__ANumberField__c]                          DECIMAL(18,0),
  [ffirule__ATextField__c]                            VARCHAR(32),
  [ffirule__AnotherNumberField__c]                    DECIMAL(18,0),
  [ffirule__AnotherProcessFormula__c]                 DECIMAL(18,0),
  [ffirule__AnotherTextField2__c]                     VARCHAR(32),
  [ffirule__AnotherTextField__c]                      VARCHAR(32),
  [ffirule__Currency__c]                              DECIMAL(10,2),
  [ffirule__DateTime__c]                              DATETIME2,
  [ffirule__Email__c]                                 VARCHAR(128),
  [ffirule__FormulaText__c]                           VARCHAR(1300),
  [ffirule__Number16__c]                              DECIMAL(16,2),
  [ffirule__Percent__c]                               DECIMAL(4,4),
  [ffirule__Phone__c]                                 VARCHAR(40),
  [ffirule__PicklistMulti__c]                         VARCHAR(1000),
  [ffirule__Picklist__c]                              VARCHAR(255),
  [ffirule__ProcessFormula__c]                        DECIMAL(18,0),
  [ffirule__Process__c]                               BIT NOT NULL,
  [ffirule__Processed__c]                             BIT NOT NULL,
  [ffirule__TargetRecord__c]                          VARCHAR(18),
  [ffirule__TextAreaLong__c]                          TEXT,
  [ffirule__TextAreaRich__c]                          TEXT,
  [ffirule__TextArea__c]                              VARCHAR(255),
  [ffirule__Time__c]                                  TIME,
  [ffirule__TotalNumberFieldNegative__c]              DECIMAL(16,2),
  [ffirule__URL__c]                                   VARCHAR(1024),
  [ffirule__IntegrationRuleSourceLinesCount__c]       VARCHAR(30),
  [ffirule__ReadyToProcessLinesCount__c]              VARCHAR(30),
  [ffirule__TotalNumberField__c]                      VARCHAR(30),
CONSTRAINT [pk_ffirule__IntegrationRuleSourceTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleTargetLineItemTest__c] ( 
  [Id]                                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                           BIT NOT NULL,
  [Name]                                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                     VARCHAR(255),
  [CreatedDate]                                         DATETIME2 NOT NULL,
  [CreatedById]                                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                    DATETIME2 NOT NULL,
  [LastModifiedById]                                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                                      DATETIME2 NOT NULL,
  [ffirule__IntegrationRuleTargetTest__c]               VARCHAR(18) NOT NULL,
  [ffirule__ABooleanField__c]                           BIT NOT NULL,
  [ffirule__ADateField__c]                              DATE,
  [ffirule__ALookupField__c]                            VARCHAR(18),
  [ffirule__ANumberField__c]                            DECIMAL(18,0),
  [ffirule__ATextField__c]                              VARCHAR(32),
  [ffirule__AnotherNumberField__c]                      DECIMAL(16,2),
  [ffirule__AnotherStatus__c]                           VARCHAR(1300),
  [ffirule__AnotherTextField__c]                        VARCHAR(32),
  [ffirule__IntegrationRuleSourceLineItemTest__c]       VARCHAR(18),
  [ffirule__Number16__c]                                DECIMAL(16,2),
  [ffirule__Status__c]                                  VARCHAR(1300),
  [ffirule__Syncing__c]                                 DECIMAL(18,0),
CONSTRAINT [pk_ffirule__IntegrationRuleTargetLineItemTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__IntegrationRuleTargetTest__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [ffirule__ABooleanField__c]                   BIT NOT NULL,
  [ffirule__ALookupField__c]                    VARCHAR(18),
  [ffirule__ANumberField__c]                    DECIMAL(18,0),
  [ffirule__ATextField__c]                      VARCHAR(32),
  [ffirule__AnotherBooleanField__c]             BIT NOT NULL,
  [ffirule__AnotherLookupField__c]              VARCHAR(18),
  [ffirule__AnotherNumberField__c]              DECIMAL(18,0),
  [ffirule__AnotherStatus__c]                   VARCHAR(255),
  [ffirule__Currency__c]                        DECIMAL(10,2),
  [ffirule__DateTime__c]                        DATETIME2,
  [ffirule__Date__c]                            DATE,
  [ffirule__Email__c]                           VARCHAR(128),
  [ffirule__IntegrationRuleSourceTest__c]       VARCHAR(18),
  [ffirule__Number16__c]                        DECIMAL(16,0),
  [ffirule__Percent2__c]                        DECIMAL(4,2),
  [ffirule__Percent4__c]                        DECIMAL(4,4),
  [ffirule__Phone__c]                           VARCHAR(40),
  [ffirule__PicklistMulti__c]                   VARCHAR(1000),
  [ffirule__Picklist__c]                        VARCHAR(255),
  [ffirule__Status__c]                          VARCHAR(255),
  [ffirule__Syncing__c]                         BIT NOT NULL,
  [ffirule__Text10__c]                          VARCHAR(10),
  [ffirule__TextAreaLong__c]                    TEXT,
  [ffirule__TextAreaRich__c]                    TEXT,
  [ffirule__TextArea__c]                        VARCHAR(255),
  [ffirule__Time__c]                            TIME,
  [ffirule__URL__c]                             VARCHAR(1024),
CONSTRAINT [pk_ffirule__IntegrationRuleTargetTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Commissions_Log__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [LastActivityDate]                       DATE,
  [LastViewedDate]                         DATETIME2,
  [LastReferencedDate]                     DATETIME2,
  [Service_Appointment__c]                 VARCHAR(18) NOT NULL,
  [ACE_Approved__c]                        BIT NOT NULL,
  [Comments__c]                            VARCHAR(255),
  [Commission_To_Proposed_Change__c]       VARCHAR(18),
  [Commission_To__c]                       VARCHAR(18),
  [Commissions_Logic_Details__c]           VARCHAR(255),
  [My_Commission_Log__c]                   BIT NOT NULL,
  [Related_Lead__c]                        VARCHAR(18),
  [Related_Person_Account__c]              VARCHAR(18),
  [System_Generated__c]                    BIT NOT NULL,
  [Commission_To_Manager__c]               VARCHAR(1300),
  [Commission_To_Company__c]               VARCHAR(1300),
CONSTRAINT [pk_Commissions_Log__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__Company__c] ( 
  [Id]                                           VARCHAR(18) NOT NULL,
  [OwnerId]                                      VARCHAR(18) NOT NULL,
  [IsDeleted]                                    BIT NOT NULL,
  [Name]                                         VARCHAR(80),
  [CurrencyIsoCode]                              VARCHAR(255),
  [CreatedDate]                                  DATETIME2 NOT NULL,
  [CreatedById]                                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]                             DATETIME2 NOT NULL,
  [LastModifiedById]                             VARCHAR(18) NOT NULL,
  [SystemModstamp]                               DATETIME2 NOT NULL,
  [LastViewedDate]                               DATETIME2,
  [LastReferencedDate]                           DATETIME2,
  [fferpcore__City__c]                           VARCHAR(40),
  [fferpcore__Code__c]                           VARCHAR(10),
  [fferpcore__CorrelationId__c]                  VARCHAR(32),
  [fferpcore__Country__c]                        VARCHAR(40),
  [fferpcore__Email__c]                          VARCHAR(128),
  [fferpcore__Fax__c]                            VARCHAR(40),
  [fferpcore__IsAddressValidated__c]             BIT NOT NULL,
  [fferpcore__LogoURL__c]                        VARCHAR(255),
  [fferpcore__Logo__c]                           VARCHAR(1300),
  [fferpcore__Phone__c]                          VARCHAR(40),
  [fferpcore__State__c]                          VARCHAR(20),
  [fferpcore__Street__c]                         VARCHAR(255),
  [fferpcore__TaxInformation__c]                 VARCHAR(18),
  [fferpcore__UniquenessConstraint__c]           VARCHAR(255),
  [fferpcore__ValidatedCity__c]                  VARCHAR(40),
  [fferpcore__ValidatedCountry__c]               VARCHAR(40),
  [fferpcore__ValidatedState__c]                 VARCHAR(20),
  [fferpcore__ValidatedStreet__c]                VARCHAR(255),
  [fferpcore__ValidatedZip__c]                   VARCHAR(20),
  [fferpcore__Website__c]                        VARCHAR(1024),
  [fferpcore__Zip__c]                            VARCHAR(20),
  [ffaci__CongaTemplateBillingDocument__c]       VARCHAR(18),
CONSTRAINT [pk_fferpcore__Company__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__Company__cfferpcore__CorrelationId__c] UNIQUE ([fferpcore__CorrelationId__c]),
CONSTRAINT [uk_fferpcore__Company__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [fferpcore__CompanyCreditTerms__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(80),
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [fferpcore__Company__c]            VARCHAR(18) NOT NULL,
  [fferpcore__BaseDate1__c]          VARCHAR(255),
  [fferpcore__BaseDate2__c]          VARCHAR(255),
  [fferpcore__BaseDate3__c]          VARCHAR(255),
  [fferpcore__BaseDate4__c]          VARCHAR(255),
  [fferpcore__DaysOffset1__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset2__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset3__c]        DECIMAL(18,0),
  [fferpcore__DaysOffset4__c]        DECIMAL(18,0),
  [fferpcore__Description1__c]       VARCHAR(80),
  [fferpcore__Description2__c]       VARCHAR(80),
  [fferpcore__Description3__c]       VARCHAR(80),
  [fferpcore__Description4__c]       VARCHAR(80),
  [fferpcore__Discount1__c]          DECIMAL(5,2),
  [fferpcore__Discount2__c]          DECIMAL(5,2),
  [fferpcore__Discount3__c]          DECIMAL(5,2),
  [fferpcore__Discount4__c]          DECIMAL(5,2),
CONSTRAINT [pk_fferpcore__CompanyCreditTerms__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__CompanySite__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(80),
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [fferpcore__Company__c]                   VARCHAR(18) NOT NULL,
  [fferpcore__City__c]                      VARCHAR(40),
  [fferpcore__Country__c]                   VARCHAR(40),
  [fferpcore__IsAddressValidated__c]        BIT NOT NULL,
  [fferpcore__PostalCode__c]                VARCHAR(20),
  [fferpcore__State__c]                     VARCHAR(80),
  [fferpcore__Street__c]                    VARCHAR(255),
  [fferpcore__ValidatedCity__c]             VARCHAR(40),
  [fferpcore__ValidatedCountry__c]          VARCHAR(40),
  [fferpcore__ValidatedPostalCode__c]       VARCHAR(20),
  [fferpcore__ValidatedState__c]            VARCHAR(20),
  [fferpcore__ValidatedStreet__c]           VARCHAR(255),
CONSTRAINT [pk_fferpcore__CompanySite__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__CompanyTaxInformation__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [OwnerId]                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(80),
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [LastViewedDate]                            DATETIME2,
  [LastReferencedDate]                        DATETIME2,
  [fferpcore__TaxCode__c]                     VARCHAR(18),
  [fferpcore__TaxCountryCode__c]              VARCHAR(255),
  [fferpcore__TaxEngine__c]                   VARCHAR(255),
  [fferpcore__TaxType__c]                     VARCHAR(255),
  [fferpcore__VatGstGroup__c]                 BIT NOT NULL,
  [fferpcore__VatRegistrationNumber__c]       VARCHAR(20),
CONSTRAINT [pk_fferpcore__CompanyTaxInformation__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__CompanyTest__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [OwnerId]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(80),
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [ffbf__ByOrderofAddressLine1__c]             VARCHAR(35),
  [ffbf__ByOrderofAddressLine2__c]             VARCHAR(35),
  [ffbf__ByOrderofAddressLine3__c]             VARCHAR(35),
  [ffbf__CompanyIdentificationNumber__c]       DECIMAL(18,0),
  [ffbf__CompanySpecification__c]              VARCHAR(80),
CONSTRAINT [pk_ffbf__CompanyTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Composer_Host_Override__c] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(80),
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [APXTConga4__Hostname__c]       VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Composer_Host_Override__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__Configuration__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__Configuration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__exp_configurationItem__c] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(80),
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [fferpcore__ItemType__c]        VARCHAR(64) NOT NULL,
  [fferpcore__Label__c]           VARCHAR(255) NOT NULL,
  [fferpcore__LargeData__c]       TEXT,
CONSTRAINT [pk_fferpcore__exp_configurationItem__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXT_BPM__Conductor__c] ( 
  [Id]                                              VARCHAR(18) NOT NULL,
  [OwnerId]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                       BIT NOT NULL,
  [Name]                                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                 VARCHAR(255),
  [CreatedDate]                                     DATETIME2 NOT NULL,
  [CreatedById]                                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                DATETIME2 NOT NULL,
  [LastModifiedById]                                VARCHAR(18) NOT NULL,
  [SystemModstamp]                                  DATETIME2 NOT NULL,
  [LastActivityDate]                                DATE,
  [LastViewedDate]                                  DATETIME2,
  [LastReferencedDate]                              DATETIME2,
  [APXT_BPM__Conductor_Environment__c]              VARCHAR(255),
  [APXT_BPM__Consolidated_PDF_Output_File__c]       BIT NOT NULL,
  [APXT_BPM__Content_Workspace_Id__c]               VARCHAR(18),
  [APXT_BPM__Description__c]                        VARCHAR(255),
  [APXT_BPM__Has_Query_Id__c]                       DECIMAL(18,0),
  [APXT_BPM__Has_Record_Id__c]                      DECIMAL(18,0),
  [APXT_BPM__Has_Report_Id__c]                      DECIMAL(18,0),
  [APXT_BPM__Next_Run_Date_Display__c]              DATETIME2,
  [APXT_BPM__Next_Run_Date__c]                      DATETIME2,
  [APXT_BPM__Query_Id__c]                           VARCHAR(18),
  [APXT_BPM__Record_Id__c]                          VARCHAR(18),
  [APXT_BPM__Report_Id__c]                          VARCHAR(18),
  [APXT_BPM__Schedule_Description_Display__c]       VARCHAR(1300),
  [APXT_BPM__Schedule_Description__c]               VARCHAR(255),
  [APXT_BPM__Title__c]                              VARCHAR(50),
  [APXT_BPM__URL_Field_Name__c]                     VARCHAR(255),
  [APXT_BPM__Version__c]                            VARCHAR(255),
CONSTRAINT [pk_APXT_BPM__Conductor__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Collection__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [OwnerId]                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(80),
  [CurrencyIsoCode]                               VARCHAR(255),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [APXTConga4__Description__c]                    TEXT,
  [APXTConga4__Is_SF1_Enabled__c]                 BIT NOT NULL,
  [APXTConga4__SF1_Binding_sObject_Type__c]       VARCHAR(70),
CONSTRAINT [pk_APXTConga4__Conga_Collection__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Collection_Solution__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(80),
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [APXTConga4__Conga_Collection__c]       VARCHAR(18) NOT NULL,
  [APXTConga4__Conga_Solution__c]         VARCHAR(18),
  [APXTConga4__Description__c]            TEXT,
  [APXTConga4__Sort_Order__c]             DECIMAL(4,0),
CONSTRAINT [pk_APXTConga4__Conga_Collection_Solution__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Email_Staging__c] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastActivityDate]              DATE,
  [APXTConga4__HTMLBody__c]       TEXT,
  [APXTConga4__Subject__c]        TEXT,
  [APXTConga4__TextBody__c]       TEXT,
  [APXTConga4__WhatId__c]         VARCHAR(18),
  [APXTConga4__WhoId__c]          VARCHAR(18),
CONSTRAINT [pk_APXTConga4__Conga_Email_Staging__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Email_Template__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [LastActivityDate]                        DATE,
  [LastViewedDate]                          DATETIME2,
  [LastReferencedDate]                      DATETIME2,
  [APXTConga4__Description__c]              VARCHAR(255),
  [APXTConga4__HTMLBody__c]                 TEXT,
  [APXTConga4__Is_Body_Attachment__c]       BIT NOT NULL,
  [APXTConga4__Key__c]                      VARCHAR(15),
  [APXTConga4__Name__c]                     VARCHAR(80),
  [APXTConga4__Subject__c]                  VARCHAR(255),
  [APXTConga4__Template_Group__c]           VARCHAR(80),
  [APXTConga4__TextBody__c]                 TEXT,
CONSTRAINT [pk_APXTConga4__Conga_Email_Template__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_APXTConga4__Conga_Email_Template__cAPXTConga4__Key__c] UNIQUE ([APXTConga4__Key__c])
) 
;

CREATE TABLE [APXTConga4__Composer_QuickMerge__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [OwnerId]                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(80),
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [LastActivityDate]                          DATE,
  [LastViewedDate]                            DATETIME2,
  [LastReferencedDate]                        DATETIME2,
  [APXTConga4__Conga_Solution__c]             VARCHAR(18),
  [APXTConga4__Description__c]                TEXT,
  [APXTConga4__Launch_CM8__c]                 VARCHAR(1300),
  [APXTConga4__Weblink_ID_Formula__c]         VARCHAR(1300),
  [APXTConga4__Weblink_ID__c]                 VARCHAR(18),
  [APXTConga4__Weblink_Name_Formula__c]       VARCHAR(1300),
  [APXTConga4__Weblink_Name__c]               VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Composer_QuickMerge__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Merge_Query__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [LastViewedDate]                   DATETIME2,
  [LastReferencedDate]               DATETIME2,
  [APXTConga4__Description__c]       VARCHAR(255),
  [APXTConga4__Key__c]               VARCHAR(15),
  [APXTConga4__Name__c]              VARCHAR(100),
  [APXTConga4__Query__c]             TEXT,
CONSTRAINT [pk_APXTConga4__Conga_Merge_Query__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_APXTConga4__Conga_Merge_Query__cAPXTConga4__Key__c] UNIQUE ([APXTConga4__Key__c])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution__c] ( 
  [Id]                                                VARCHAR(18) NOT NULL,
  [OwnerId]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                         BIT NOT NULL,
  [Name]                                              VARCHAR(80),
  [CurrencyIsoCode]                                   VARCHAR(255),
  [CreatedDate]                                       DATETIME2 NOT NULL,
  [CreatedById]                                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                  DATETIME2 NOT NULL,
  [LastModifiedById]                                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                                    DATETIME2 NOT NULL,
  [LastViewedDate]                                    DATETIME2,
  [LastReferencedDate]                                DATETIME2,
  [APXTConga4__Button_Link_API_Name__c]               VARCHAR(255),
  [APXTConga4__Button_body_field__c]                  TEXT,
  [APXTConga4__Composer_Parameters__c]                TEXT,
  [APXTConga4__Custom_Object_Id__c]                   VARCHAR(18),
  [APXTConga4__Formula_Field_API_Name__c]             VARCHAR(255),
  [APXTConga4__Formula_body_field__c]                 TEXT,
  [APXTConga4__Is_Quick_Start__c]                     VARCHAR(80),
  [APXTConga4__Launch_C8_Formula_Button__c]           VARCHAR(1300),
  [APXTConga4__Master_Object_Type_Validator__c]       VARCHAR(255),
  [APXTConga4__Master_Object_Type__c]                 VARCHAR(255),
  [APXTConga4__Sample_Record_Id__c]                   VARCHAR(18),
  [APXTConga4__Sample_Record_Name__c]                 VARCHAR(80),
  [APXTConga4__Solution_Description__c]               TEXT,
  [APXTConga4__Solution_Weblink_Syntax__c]            TEXT,
  [APXTConga4__Weblink_Id__c]                         VARCHAR(18),
  [APXTConga4__CongaEmailTemplateCount__c]            VARCHAR(30),
CONSTRAINT [pk_APXTConga4__Conga_Solution__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution_Email_Template__c] ( 
  [Id]                                              VARCHAR(18) NOT NULL,
  [IsDeleted]                                       BIT NOT NULL,
  [Name]                                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                 VARCHAR(255),
  [CreatedDate]                                     DATETIME2 NOT NULL,
  [CreatedById]                                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                DATETIME2 NOT NULL,
  [LastModifiedById]                                VARCHAR(18) NOT NULL,
  [SystemModstamp]                                  DATETIME2 NOT NULL,
  [APXTConga4__Conga_Solution__c]                   VARCHAR(18) NOT NULL,
  [APXTConga4__Comments__c]                         VARCHAR(255),
  [APXTConga4__Conga_Email_Template_Group__c]       VARCHAR(1300),
  [APXTConga4__Conga_Email_Template_Name__c]        VARCHAR(1300),
  [APXTConga4__Conga_Email_Template__c]             VARCHAR(18),
  [APXTConga4__IsDefault__c]                        BIT NOT NULL,
CONSTRAINT [pk_APXTConga4__Conga_Solution_Email_Template__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution_Parameter__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [APXTConga4__Conga_Solution__c]       VARCHAR(18) NOT NULL,
  [APXTConga4__Comments__c]             VARCHAR(255),
  [APXTConga4__Name__c]                 VARCHAR(255),
  [APXTConga4__Value__c]                VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Conga_Solution_Parameter__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution_Query__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [APXTConga4__Conga_Solution__c]         VARCHAR(18) NOT NULL,
  [APXTConga4__Alias__c]                  VARCHAR(20),
  [APXTConga4__Comments__c]               TEXT,
  [APXTConga4__Conga_Query_Name__c]       VARCHAR(1300),
  [APXTConga4__Conga_Query__c]            VARCHAR(18),
  [APXTConga4__pv0__c]                    VARCHAR(255),
  [APXTConga4__pv1__c]                    VARCHAR(255),
  [APXTConga4__pv2__c]                    VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Conga_Solution_Query__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution_Report__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [APXTConga4__Conga_Solution__c]       VARCHAR(18) NOT NULL,
  [APXTConga4__Alias__c]                VARCHAR(20),
  [APXTConga4__Comments__c]             TEXT,
  [APXTConga4__Report_Id_Link__c]       VARCHAR(1300),
  [APXTConga4__Report_Id__c]            VARCHAR(18),
  [APXTConga4__Report_Name__c]          VARCHAR(255),
  [APXTConga4__pv0__c]                  VARCHAR(255),
  [APXTConga4__pv1__c]                  VARCHAR(255),
  [APXTConga4__pv2__c]                  VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Conga_Solution_Report__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Solution_Template__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [APXTConga4__Conga_Solution__c]           VARCHAR(18) NOT NULL,
  [APXTConga4__Comments__c]                 TEXT,
  [APXTConga4__Conga_Template__c]           VARCHAR(18),
  [APXTConga4__Output_File_Name__c]         VARCHAR(255),
  [APXTConga4__Sort_Order__c]               DECIMAL(3,2),
  [APXTConga4__Template_Extension__c]       VARCHAR(10),
  [APXTConga4__Template_Group__c]           VARCHAR(1300),
  [APXTConga4__Template_Name__c]            VARCHAR(1300),
CONSTRAINT [pk_APXTConga4__Conga_Solution_Template__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Conga_Template__c] ( 
  [Id]                                                  VARCHAR(18) NOT NULL,
  [OwnerId]                                             VARCHAR(18) NOT NULL,
  [IsDeleted]                                           BIT NOT NULL,
  [Name]                                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                     VARCHAR(255),
  [CreatedDate]                                         DATETIME2 NOT NULL,
  [CreatedById]                                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                    DATETIME2 NOT NULL,
  [LastModifiedById]                                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                                      DATETIME2 NOT NULL,
  [LastViewedDate]                                      DATETIME2,
  [LastReferencedDate]                                  DATETIME2,
  [APXTConga4__Description__c]                          VARCHAR(255),
  [APXTConga4__Key__c]                                  VARCHAR(15),
  [APXTConga4__Label_Template_Use_Detail_Data__c]       BIT NOT NULL,
  [APXTConga4__Master_Field_to_Set_1__c]                VARCHAR(255),
  [APXTConga4__Master_Field_to_Set_2__c]                VARCHAR(255),
  [APXTConga4__Master_Field_to_Set_3__c]                VARCHAR(255),
  [APXTConga4__Name__c]                                 VARCHAR(80),
  [APXTConga4__Template_Extension__c]                   VARCHAR(10),
  [APXTConga4__Template_Group__c]                       VARCHAR(80),
  [APXTConga4__Template_Type__c]                        VARCHAR(255),
CONSTRAINT [pk_APXTConga4__Conga_Template__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_APXTConga4__Conga_Template__cAPXTConga4__Key__c] UNIQUE ([APXTConga4__Key__c])
) 
;

CREATE TABLE [Contact] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [MasterRecordId]                     VARCHAR(18),
  [AccountId]                          VARCHAR(18),
  [IsPersonAccount]                    BIT NOT NULL,
  [LastName]                           VARCHAR(80) NOT NULL,
  [FirstName]                          VARCHAR(40),
  [Salutation]                         VARCHAR(255),
  [MiddleName]                         VARCHAR(40),
  [Suffix]                             VARCHAR(40),
  [Name]                               VARCHAR(121) NOT NULL,
  [MailingStreet]                      VARCHAR(255),
  [MailingCity]                        VARCHAR(40),
  [MailingState]                       VARCHAR(80),
  [MailingPostalCode]                  VARCHAR(20),
  [MailingCountry]                     VARCHAR(80),
  [MailingStateCode]                   VARCHAR(255),
  [MailingCountryCode]                 VARCHAR(255),
  [MailingLatitude]                    DECIMAL(15,15),
  [MailingLongitude]                   DECIMAL(15,15),
  [MailingGeocodeAccuracy]             VARCHAR(255),
  [MailingAddress]                     VARCHAR(255),
  [Phone]                              VARCHAR(40),
  [Fax]                                VARCHAR(40),
  [MobilePhone]                        VARCHAR(40),
  [HomePhone]                          VARCHAR(40),
  [OtherPhone]                         VARCHAR(40),
  [AssistantPhone]                     VARCHAR(40),
  [ReportsToId]                        VARCHAR(18),
  [Email]                              VARCHAR(128),
  [Title]                              VARCHAR(128),
  [Department]                         VARCHAR(80),
  [CurrencyIsoCode]                    VARCHAR(255),
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [LastActivityDate]                   DATE,
  [LastCURequestDate]                  DATETIME2,
  [LastCUUpdateDate]                   DATETIME2,
  [LastViewedDate]                     DATETIME2,
  [LastReferencedDate]                 DATETIME2,
  [EmailBouncedReason]                 VARCHAR(255),
  [EmailBouncedDate]                   DATETIME2,
  [IsEmailBounced]                     BIT NOT NULL,
  [PhotoUrl]                           VARCHAR(1024),
  [Jigsaw]                             VARCHAR(20),
  [JigsawContactId]                    VARCHAR(20),
  [Age__c]                             DECIMAL(18,0),
  [Birthdate__c]                       DATE,
  [DoNotContact__c]                    BIT NOT NULL,
  [DoNotEmail__c]                      BIT NOT NULL,
  [DoNotMail__c]                       BIT NOT NULL,
  [DoNotText__c]                       BIT NOT NULL,
  [Ethnicity__c]                       VARCHAR(255),
  [Gender__c]                          VARCHAR(255),
  [HairLossExperience__c]              VARCHAR(255),
  [HairLossFamily__c]                  VARCHAR(255),
  [HairLossOrVolume__c]                VARCHAR(255),
  [HairLossProductOther__c]            VARCHAR(255),
  [HairLossProductUsed__c]             VARCHAR(255),
  [HairLossSpot__c]                    VARCHAR(255),
  [HardCopyPreferred__c]               BIT NOT NULL,
  [Language__c]                        VARCHAR(255),
  [MaritalStatus__c]                   VARCHAR(255),
  [Text_Reminder_Opt_In__c]            BIT NOT NULL,
  [rh2__Currency_Test__c]              DECIMAL(18,0),
  [rh2__Describe__c]                   VARCHAR(18),
  [rh2__Formula_Test__c]               DECIMAL(18,0),
  [rh2__Integer_Test__c]               DECIMAL(3,0),
  [Next_Milestone_Event__c]            VARCHAR(255),
  [Next_Milestone_Event_Date__c]       DATE,
  [Bosley_Center_Number__c]            VARCHAR(255),
  [Bosley_Client_Id__c]                VARCHAR(255),
  [Bosley_Legacy_Source_Code__c]       VARCHAR(255),
  [Bosley_Salesforce_Id__c]            VARCHAR(255),
  [Bosley_Siebel_Id__c]                VARCHAR(255),
  [Contact_ID_18_dig__c]               VARCHAR(1300),
CONSTRAINT [pk_Contact] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ContactRequest] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [WhatId]                   VARCHAR(18),
  [WhoId]                    VARCHAR(18),
  [PreferredPhone]           VARCHAR(40),
  [PreferredChannel]         VARCHAR(255) NOT NULL,
  [Status]                   VARCHAR(255) NOT NULL,
  [RequestReason]            VARCHAR(255),
  [RequestDescription]       TEXT,
CONSTRAINT [pk_ContactRequest] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ContentVersion] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [ContentDocumentId]            VARCHAR(18) NOT NULL,
  [IsLatest]                     BIT NOT NULL,
  [ContentUrl]                   VARCHAR(1024),
  [ContentBodyId]                VARCHAR(18),
  [VersionNumber]                VARCHAR(20),
  [Title]                        VARCHAR(255) NOT NULL,
  [Description]                  TEXT,
  [ReasonForChange]              VARCHAR(1000),
  [SharingOption]                VARCHAR(255) NOT NULL,
  [SharingPrivacy]               VARCHAR(255) NOT NULL,
  [PathOnClient]                 VARCHAR(500),
  [RatingCount]                  VARCHAR(255),
  [IsDeleted]                    BIT NOT NULL,
  [ContentModifiedDate]          DATETIME2,
  [ContentModifiedById]          VARCHAR(18),
  [PositiveRatingCount]          VARCHAR(255),
  [NegativeRatingCount]          VARCHAR(255),
  [FeaturedContentBoost]         VARCHAR(255),
  [FeaturedContentDate]          DATE,
  [CurrencyIsoCode]              VARCHAR(255) NOT NULL,
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [CreatedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [TagCsv]                       TEXT,
  [FileType]                     VARCHAR(20) NOT NULL,
  [PublishStatus]                VARCHAR(255) NOT NULL,
  [VersionData]                  VARCHAR(255),
  [ContentSize]                  VARCHAR(255),
  [FileExtension]                VARCHAR(40),
  [FirstPublishLocationId]       VARCHAR(18),
  [Origin]                       VARCHAR(255) NOT NULL,
  [NetworkId]                    VARCHAR(18),
  [ContentLocation]              VARCHAR(255) NOT NULL,
  [TextPreview]                  VARCHAR(255),
  [ExternalDocumentInfo1]        VARCHAR(1000),
  [ExternalDocumentInfo2]        VARCHAR(1000),
  [ExternalDataSourceId]         VARCHAR(18),
  [Checksum]                     VARCHAR(50),
  [IsMajorVersion]               BIT NOT NULL,
  [IsAssetEnabled]               BIT NOT NULL,
CONSTRAINT [pk_ContentVersion] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Contract] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [AccountId]                     VARCHAR(18) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [Pricebook2Id]                  VARCHAR(18),
  [OwnerExpirationNotice]         VARCHAR(255),
  [StartDate]                     DATE,
  [EndDate]                       DATE,
  [BillingStreet]                 VARCHAR(255),
  [BillingCity]                   VARCHAR(40),
  [BillingState]                  VARCHAR(80),
  [BillingPostalCode]             VARCHAR(20),
  [BillingCountry]                VARCHAR(80),
  [BillingStateCode]              VARCHAR(255),
  [BillingCountryCode]            VARCHAR(255),
  [BillingLatitude]               DECIMAL(15,15),
  [BillingLongitude]              DECIMAL(15,15),
  [BillingGeocodeAccuracy]        VARCHAR(255),
  [BillingAddress]                VARCHAR(255),
  [ShippingStreet]                VARCHAR(255),
  [ShippingCity]                  VARCHAR(40),
  [ShippingState]                 VARCHAR(80),
  [ShippingPostalCode]            VARCHAR(20),
  [ShippingCountry]               VARCHAR(80),
  [ShippingStateCode]             VARCHAR(255),
  [ShippingCountryCode]           VARCHAR(255),
  [ShippingLatitude]              DECIMAL(15,15),
  [ShippingLongitude]             DECIMAL(15,15),
  [ShippingGeocodeAccuracy]       VARCHAR(255),
  [ShippingAddress]               VARCHAR(255),
  [ContractTerm]                  VARCHAR(255),
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [Status]                        VARCHAR(255) NOT NULL,
  [CompanySignedId]               VARCHAR(18),
  [CompanySignedDate]             DATE,
  [CustomerSignedId]              VARCHAR(18),
  [CustomerSignedTitle]           VARCHAR(40),
  [CustomerSignedDate]            DATE,
  [SpecialTerms]                  TEXT,
  [ActivatedById]                 VARCHAR(18),
  [ActivatedDate]                 DATETIME2,
  [StatusCode]                    VARCHAR(255) NOT NULL,
  [Description]                   TEXT,
  [IsDeleted]                     BIT NOT NULL,
  [ContractNumber]                VARCHAR(255) NOT NULL,
  [LastApprovedDate]              DATETIME2,
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastActivityDate]              DATE,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
CONSTRAINT [pk_Contract] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ContractLineItem] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [LineItemNumber]                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255) NOT NULL,
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [ServiceContractId]              VARCHAR(18) NOT NULL,
  [Product2Id]                     VARCHAR(18),
  [AssetId]                        VARCHAR(18),
  [StartDate]                      DATE,
  [EndDate]                        DATE,
  [Description]                    TEXT,
  [PricebookEntryId]               VARCHAR(18) NOT NULL,
  [Quantity]                       DECIMAL(10,2) NOT NULL,
  [UnitPrice]                      DECIMAL(16,2) NOT NULL,
  [Discount]                       DECIMAL(3,2),
  [ListPrice]                      DECIMAL(16,2),
  [Subtotal]                       DECIMAL(16,2),
  [TotalPrice]                     DECIMAL(16,2),
  [Status]                         VARCHAR(255),
  [ParentContractLineItemId]       VARCHAR(18),
  [RootContractLineItemId]         VARCHAR(18),
  [LocationId]                     VARCHAR(18),
CONSTRAINT [pk_ContractLineItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__DataTransformation__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [fferpcore__DataTransformationTable__c]       VARCHAR(18) NOT NULL,
  [fferpcore__RequiredSourceValues__c]          DECIMAL(18,0),
  [fferpcore__SourceValue1__c]                  VARCHAR(255),
  [fferpcore__SourceValue2__c]                  VARCHAR(255),
  [fferpcore__TargetValue__c]                   VARCHAR(255),
  [fferpcore__UniquenessConstraint__c]          VARCHAR(255),
CONSTRAINT [pk_fferpcore__DataTransformation__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__DataTransformation__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [fferpcore__DataTransformationTable__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(80),
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [LastViewedDate]                           DATETIME2,
  [LastReferencedDate]                       DATETIME2,
  [fferpcore__DTT_Number__c]                 VARCHAR(255) NOT NULL,
  [fferpcore__Description__c]                VARCHAR(255),
  [fferpcore__RequiredSourceValues__c]       VARCHAR(30),
CONSTRAINT [pk_fferpcore__DataTransformationTable__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__DPNodeDeclaration__c] ( 
  [Id]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                    BIT NOT NULL,
  [Name]                                         VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                              VARCHAR(255),
  [CreatedDate]                                  DATETIME2 NOT NULL,
  [CreatedById]                                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]                             DATETIME2 NOT NULL,
  [LastModifiedById]                             VARCHAR(18) NOT NULL,
  [SystemModstamp]                               DATETIME2 NOT NULL,
  [fferpcore__Publication__c]                    VARCHAR(18) NOT NULL,
  [fferpcore__ErrorMessage__c]                   VARCHAR(255),
  [fferpcore__JsonPath__c]                       VARCHAR(255),
  [fferpcore__LiteralSourceData__c]              VARCHAR(255),
  [fferpcore__LiteralSourceDescription__c]       VARCHAR(128),
  [fferpcore__NodeType__c]                       VARCHAR(255),
  [fferpcore__Sequence__c]                       DECIMAL(18,0),
  [fferpcore__SourceKey__c]                      VARCHAR(255),
  [fferpcore__SourceType__c]                     VARCHAR(255),
  [fferpcore__UniquenessConstraint__c]           VARCHAR(255),
CONSTRAINT [pk_fferpcore__DPNodeDeclaration__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__DPNodeDeclaration__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [fferpcore__DSCustomMapping__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [fferpcore__Subscription__c]                  VARCHAR(18) NOT NULL,
  [fferpcore__AdditionalLookupField__c]         VARCHAR(255),
  [fferpcore__CorrelationField__c]              VARCHAR(255),
  [fferpcore__CorrelationKey__c]                VARCHAR(255),
  [fferpcore__CorrelationStrategy__c]           VARCHAR(255),
  [fferpcore__DataTransformationTable__c]       VARCHAR(18),
  [fferpcore__Filters__c]                       TEXT,
  [fferpcore__JsonPath__c]                      VARCHAR(255) NOT NULL,
  [fferpcore__Sequence__c]                      DECIMAL(18,0),
  [fferpcore__TargetChildType__c]               VARCHAR(255),
  [fferpcore__TargetField__c]                   VARCHAR(255) NOT NULL,
  [fferpcore__Type__c]                          VARCHAR(255),
  [fferpcore__UniquenessConstraint__c]          VARCHAR(255),
CONSTRAINT [pk_fferpcore__DSCustomMapping__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__DSCustomMapping__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [fferpcore__MessagingDelivery__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [fferpcore__Message__c]            VARCHAR(18) NOT NULL,
  [fferpcore__Body01__c]             TEXT,
  [fferpcore__Chunk__c]              VARCHAR(18),
  [fferpcore__State__c]              VARCHAR(255),
  [fferpcore__Subscription__c]       VARCHAR(18),
CONSTRAINT [pk_fferpcore__MessagingDelivery__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SCMFFA__SCM_Product_Mapping__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [OwnerId]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [SCMFFA__Product__c]             VARCHAR(18),
  [SCMFFA__SCM_Line_Type__c]       VARCHAR(255),
CONSTRAINT [pk_SCMFFA__SCM_Product_Mapping__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__PS_Rollup_Dummy__c] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [OwnerId]                    VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [LastActivityDate]           DATE,
  [rh2__Account__c]            VARCHAR(18),
  [rh2__Parent_Dummy__c]       VARCHAR(18),
  [rh2__Test_Numeric__c]       DECIMAL(8,0),
CONSTRAINT [pk_rh2__PS_Rollup_Dummy__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__PS_Describe__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [rh2__Account__c]                         VARCHAR(18),
  [rh2__Asynchronous__c]                    BIT NOT NULL,
  [rh2__Contact2__c]                        VARCHAR(18),
  [rh2__Contact3__c]                        VARCHAR(18),
  [rh2__Contact__c]                         VARCHAR(18),
  [rh2__Data_Type__c]                       VARCHAR(50),
  [rh2__Disable_Realtime__c]                BIT NOT NULL,
  [rh2__Disable_Trigger__c]                 BIT NOT NULL,
  [rh2__Foreign_Key_Test_Currency__c]       DECIMAL(18,0),
  [rh2__Formula_Date_Time_Test__c]          DATETIME2,
  [rh2__Hierarchy_Test_2__c]                VARCHAR(18),
  [rh2__Hierarchy_Test__c]                  VARCHAR(18),
  [rh2__Label__c]                           VARCHAR(255),
  [rh2__Name__c]                            VARCHAR(50),
  [rh2__Object__c]                          VARCHAR(255) NOT NULL,
  [rh2__Real_Time__c]                       BIT NOT NULL,
  [rh2__Rollup_10__c]                       VARCHAR(255),
  [rh2__Rollup_11__c]                       VARCHAR(255),
  [rh2__Rollup_12__c]                       VARCHAR(255),
  [rh2__Rollup_13__c]                       VARCHAR(255),
  [rh2__Rollup_14__c]                       VARCHAR(255),
  [rh2__Rollup_15__c]                       VARCHAR(255),
  [rh2__Rollup_16__c]                       VARCHAR(255),
  [rh2__Rollup_17__c]                       VARCHAR(255),
  [rh2__Rollup_18__c]                       VARCHAR(255),
  [rh2__Rollup_19__c]                       VARCHAR(255),
  [rh2__Rollup_1__c]                        VARCHAR(255),
  [rh2__Rollup_20__c]                       VARCHAR(255),
  [rh2__Rollup_21__c]                       VARCHAR(255),
  [rh2__Rollup_22__c]                       VARCHAR(255),
  [rh2__Rollup_23__c]                       VARCHAR(255),
  [rh2__Rollup_24__c]                       VARCHAR(255),
  [rh2__Rollup_25__c]                       VARCHAR(255),
  [rh2__Rollup_26__c]                       VARCHAR(255),
  [rh2__Rollup_27__c]                       VARCHAR(255),
  [rh2__Rollup_28__c]                       VARCHAR(255),
  [rh2__Rollup_29__c]                       VARCHAR(255),
  [rh2__Rollup_2__c]                        VARCHAR(255),
  [rh2__Rollup_30__c]                       VARCHAR(255),
  [rh2__Rollup_31__c]                       VARCHAR(255),
  [rh2__Rollup_32__c]                       VARCHAR(255),
  [rh2__Rollup_33__c]                       VARCHAR(255),
  [rh2__Rollup_34__c]                       VARCHAR(255),
  [rh2__Rollup_35__c]                       VARCHAR(255),
  [rh2__Rollup_36__c]                       VARCHAR(255),
  [rh2__Rollup_37__c]                       VARCHAR(255),
  [rh2__Rollup_38__c]                       VARCHAR(255),
  [rh2__Rollup_39__c]                       VARCHAR(255),
  [rh2__Rollup_3__c]                        VARCHAR(255),
  [rh2__Rollup_40__c]                       VARCHAR(255),
  [rh2__Rollup_41__c]                       VARCHAR(255),
  [rh2__Rollup_42__c]                       VARCHAR(255),
  [rh2__Rollup_43__c]                       VARCHAR(255),
  [rh2__Rollup_44__c]                       VARCHAR(255),
  [rh2__Rollup_45__c]                       VARCHAR(255),
  [rh2__Rollup_46__c]                       VARCHAR(255),
  [rh2__Rollup_47__c]                       VARCHAR(255),
  [rh2__Rollup_48__c]                       VARCHAR(255),
  [rh2__Rollup_49__c]                       VARCHAR(255),
  [rh2__Rollup_4__c]                        VARCHAR(255),
  [rh2__Rollup_50__c]                       VARCHAR(255),
  [rh2__Rollup_51__c]                       VARCHAR(255),
  [rh2__Rollup_52__c]                       VARCHAR(255),
  [rh2__Rollup_53__c]                       VARCHAR(255),
  [rh2__Rollup_54__c]                       VARCHAR(255),
  [rh2__Rollup_55__c]                       VARCHAR(255),
  [rh2__Rollup_56__c]                       VARCHAR(255),
  [rh2__Rollup_57__c]                       VARCHAR(255),
  [rh2__Rollup_58__c]                       VARCHAR(255),
  [rh2__Rollup_59__c]                       VARCHAR(255),
  [rh2__Rollup_5__c]                        VARCHAR(255),
  [rh2__Rollup_60__c]                       VARCHAR(255),
  [rh2__Rollup_61__c]                       VARCHAR(255),
  [rh2__Rollup_62__c]                       VARCHAR(255),
  [rh2__Rollup_63__c]                       VARCHAR(255),
  [rh2__Rollup_64__c]                       VARCHAR(255),
  [rh2__Rollup_65__c]                       VARCHAR(255),
  [rh2__Rollup_66__c]                       VARCHAR(255),
  [rh2__Rollup_6__c]                        VARCHAR(255),
  [rh2__Rollup_7__c]                        VARCHAR(255),
  [rh2__Rollup_8__c]                        VARCHAR(255),
  [rh2__Rollup_9__c]                        VARCHAR(255),
  [rh2__Selected__c]                        BIT NOT NULL,
  [rh2__Sum_Integer_Double__c]              DECIMAL(18,0),
  [rh2__Test_Checkbox__c]                   BIT NOT NULL,
  [rh2__Test_Currency__c]                   DECIMAL(18,0),
  [rh2__Test_Date_Time__c]                  DATETIME2,
  [rh2__Test_Date__c]                       DATE,
  [rh2__Test_Double__c]                     DECIMAL(16,2),
  [rh2__Test_End_Date__c]                   DATE,
  [rh2__Test_Formula_FK_Currency__c]        DECIMAL(18,0),
  [rh2__Test_Formula__c]                    DECIMAL(18,0),
  [rh2__Test_Integer2__c]                   DECIMAL(18,0),
  [rh2__Test_Integer__c]                    DECIMAL(18,0),
  [rh2__Test_Long_Text__c]                  TEXT,
  [rh2__Test_Multi_Picklist__c]             VARCHAR(1000),
  [rh2__Test_Percent__c]                    DECIMAL(16,2),
  [rh2__Test_Picklist__c]                   VARCHAR(255),
  [rh2__Test_Rich_Text__c]                  TEXT,
  [rh2__Test_Small_Number__c]               DECIMAL(18,0),
  [rh2__User__c]                            VARCHAR(18),
  [rh2__Validation_Test_Int__c]             DECIMAL(18,0),
CONSTRAINT [pk_rh2__PS_Describe__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_rh2__PS_Describe__crh2__Name__c] UNIQUE ([rh2__Name__c]),
CONSTRAINT [uk_rh2__PS_Describe__crh2__Object__c] UNIQUE ([rh2__Object__c])
) 
;

CREATE TABLE [Tigerface5__Display_Configuration__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [LastViewedDate]                           DATETIME2,
  [LastReferencedDate]                       DATETIME2,
  [Tigerface5__API_Name__c]                  VARCHAR(50) NOT NULL,
  [Tigerface5__Config_Name__c]               VARCHAR(150),
  [Tigerface5__Display_Page_Type__c]         VARCHAR(255),
  [Tigerface5__Parent_sObject_Name__c]       VARCHAR(50) NOT NULL,
CONSTRAINT [pk_Tigerface5__Display_Configuration__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_Tigerface5__Display_Configuration__cTigerface5__Config_Name__c] UNIQUE ([Tigerface5__Config_Name__c])
) 
;

CREATE TABLE [Tigerface5__Display_Filter__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [Tigerface5__Display_Configuration__c]       VARCHAR(18) NOT NULL,
  [Tigerface5__Field_Name__c]                  VARCHAR(50) NOT NULL,
  [Tigerface5__Field_Type__c]                  VARCHAR(50) NOT NULL,
  [Tigerface5__Filter_Operator__c]             VARCHAR(50) NOT NULL,
  [Tigerface5__Filter_Value__c]                VARCHAR(50),
CONSTRAINT [pk_Tigerface5__Display_Filter__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Tigerface5__Display_Validation_Field__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [Tigerface5__Display_Configuration__c]       VARCHAR(18) NOT NULL,
  [Tigerface5__Display_Order__c]               DECIMAL(18,0) NOT NULL,
  [Tigerface5__Field_Name__c]                  VARCHAR(50) NOT NULL,
  [Tigerface5__Field_Type__c]                  VARCHAR(255) NOT NULL,
CONSTRAINT [pk_Tigerface5__Display_Validation_Field__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Document_History__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [OwnerId]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [LastViewedDate]                        DATETIME2,
  [LastReferencedDate]                    DATETIME2,
  [APXTConga4__Conga_Solution__c]         VARCHAR(18),
  [APXTConga4__Link_Text__c]              VARCHAR(80) NOT NULL,
  [APXTConga4__Master_Object_ID__c]       VARCHAR(18) NOT NULL,
  [APXTConga4__URL__c]                    VARCHAR(1024) NOT NULL,
  [APXTConga4__Last_Viewed__c]            VARCHAR(30),
  [APXTConga4__Number_of_Views__c]        VARCHAR(30),
CONSTRAINT [pk_APXTConga4__Document_History__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__Document_History_Detail__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [APXTConga4__Document_History__c]       VARCHAR(18) NOT NULL,
  [APXTConga4__Document_Status__c]        VARCHAR(255) NOT NULL,
  [APXTConga4__Email_Address__c]          VARCHAR(128),
  [APXTConga4__Last_Viewed__c]            DATETIME2,
  [APXTConga4__Number_of_Views__c]        DECIMAL(18,0) NOT NULL,
  [APXTConga4__SMS_Number__c]             VARCHAR(40),
CONSTRAINT [pk_APXTConga4__Document_History_Detail__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [DuplicateRecordItem] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [DuplicateRecordSetId]       VARCHAR(18) NOT NULL,
  [RecordId]                   VARCHAR(18) NOT NULL,
CONSTRAINT [pk_DuplicateRecordItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [DuplicateRecordSet] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [DuplicateRuleId]          VARCHAR(18),
  [RecordCount]              VARCHAR(30),
  [ParentId]                 VARCHAR(18),
CONSTRAINT [pk_DuplicateRecordSet] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__Email_Linkage__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__Email_Linkage__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [EmailMessage] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [ParentId]                    VARCHAR(18),
  [ActivityId]                  VARCHAR(18),
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [TextBody]                    TEXT,
  [HtmlBody]                    TEXT,
  [Headers]                     TEXT,
  [Subject]                     VARCHAR(3000),
  [FromName]                    VARCHAR(1000),
  [FromAddress]                 VARCHAR(128),
  [ValidatedFromAddress]        VARCHAR(255),
  [ToAddress]                   VARCHAR(4000),
  [CcAddress]                   VARCHAR(4000),
  [BccAddress]                  VARCHAR(4000),
  [Incoming]                    BIT NOT NULL,
  [HasAttachment]               BIT NOT NULL,
  [Status]                      VARCHAR(255) NOT NULL,
  [MessageDate]                 DATETIME2,
  [IsDeleted]                   BIT NOT NULL,
  [ReplyToEmailMessageId]       VARCHAR(18),
  [IsExternallyVisible]         BIT NOT NULL,
  [MessageIdentifier]           VARCHAR(765),
  [ThreadIdentifier]            VARCHAR(765),
  [IsClientManaged]             BIT NOT NULL,
  [RelatedToId]                 VARCHAR(18),
  [IsTracked]                   BIT NOT NULL,
  [IsOpened]                    BIT NOT NULL,
  [FirstOpenedDate]             DATETIME2,
  [LastOpenedDate]              DATETIME2,
  [IsBounced]                   BIT NOT NULL,
  [EmailTemplateId]             VARCHAR(18),
CONSTRAINT [pk_EmailMessage] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__SendDefinition__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [RecordTypeId]             VARCHAR(18),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
CONSTRAINT [pk_et4ae5__SendDefinition__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ProfileSkillEndorsement] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [ProfileSkillUserId]       VARCHAR(18) NOT NULL,
  [UserId]                   VARCHAR(18),
CONSTRAINT [pk_ProfileSkillEndorsement] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ff_Engagement__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [fferpcore__Account__c]           VARCHAR(18),
  [fferpcore__Description__c]       VARCHAR(255),
  [fferpcore__EndDate__c]           DATE,
  [fferpcore__StartDate__c]         DATE,
CONSTRAINT [pk_fferpcore__ff_Engagement__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [EnhancedLetterhead] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Description]              VARCHAR(255),
  [LetterheadHeader]         TEXT,
  [LetterheadFooter]         TEXT,
CONSTRAINT [pk_EnhancedLetterhead] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Entitlement] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [AccountId]                      VARCHAR(18) NOT NULL,
  [Type]                           VARCHAR(255),
  [ServiceContractId]              VARCHAR(18),
  [ContractLineItemId]             VARCHAR(18),
  [AssetId]                        VARCHAR(18),
  [StartDate]                      DATE,
  [EndDate]                        DATE,
  [SlaProcessId]                   VARCHAR(18),
  [BusinessHoursId]                VARCHAR(18),
  [IsPerIncident]                  BIT NOT NULL,
  [CasesPerEntitlement]            VARCHAR(255),
  [RemainingCases]                 VARCHAR(255),
  [Status]                         VARCHAR(255),
  [SvcApptBookingWindowsId]        VARCHAR(18),
  [LocationId]                     VARCHAR(18),
  [WorkOrdersPerEntitlement]       VARCHAR(255),
  [RemainingWorkOrders]            VARCHAR(255),
CONSTRAINT [pk_Entitlement] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Event] ( 
  [Id]                                                 VARCHAR(18) NOT NULL,
  [WhoId]                                              VARCHAR(18),
  [WhatId]                                             VARCHAR(18),
  [WhoCount]                                           VARCHAR(255),
  [WhatCount]                                          VARCHAR(255),
  [Subject]                                            VARCHAR(255),
  [Location]                                           VARCHAR(255),
  [IsAllDayEvent]                                      BIT NOT NULL,
  [ActivityDateTime]                                   DATETIME2,
  [ActivityDate]                                       DATE,
  [DurationInMinutes]                                  VARCHAR(255),
  [StartDateTime]                                      DATETIME2,
  [EndDateTime]                                        DATETIME2,
  [EndDate]                                            DATE,
  [Description]                                        TEXT,
  [AccountId]                                          VARCHAR(18),
  [OwnerId]                                            VARCHAR(18) NOT NULL,
  [CurrencyIsoCode]                                    VARCHAR(255),
  [Type]                                               VARCHAR(255),
  [IsPrivate]                                          BIT NOT NULL,
  [ShowAs]                                             VARCHAR(255),
  [IsDeleted]                                          BIT NOT NULL,
  [IsChild]                                            BIT NOT NULL,
  [IsGroupEvent]                                       BIT NOT NULL,
  [GroupEventType]                                     VARCHAR(255),
  [CreatedDate]                                        DATETIME2 NOT NULL,
  [CreatedById]                                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                   DATETIME2 NOT NULL,
  [LastModifiedById]                                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                                     DATETIME2 NOT NULL,
  [IsArchived]                                         BIT NOT NULL,
  [RecurrenceActivityId]                               VARCHAR(18),
  [IsRecurrence]                                       BIT NOT NULL,
  [RecurrenceStartDateTime]                            DATETIME2,
  [RecurrenceEndDateOnly]                              DATE,
  [RecurrenceTimeZoneSidKey]                           VARCHAR(255),
  [RecurrenceType]                                     VARCHAR(255),
  [RecurrenceInterval]                                 VARCHAR(255),
  [RecurrenceDayOfWeekMask]                            VARCHAR(255),
  [RecurrenceDayOfMonth]                               VARCHAR(255),
  [RecurrenceInstance]                                 VARCHAR(255),
  [RecurrenceMonthOfYear]                              VARCHAR(255),
  [ReminderDateTime]                                   DATETIME2,
  [IsReminderSet]                                      BIT NOT NULL,
  [EventSubtype]                                       VARCHAR(255),
  [IsRecurrence2Exclusion]                             BIT NOT NULL,
  [Recurrence2PatternText]                             TEXT,
  [Recurrence2PatternVersion]                          VARCHAR(255),
  [IsRecurrence2]                                      BIT NOT NULL,
  [IsRecurrence2Exception]                             BIT NOT NULL,
  [Recurrence2PatternStartDate]                        DATETIME2,
  [Recurrence2PatternTimeZone]                         VARCHAR(255),
  [ServiceAppointmentId]                               VARCHAR(18),
  [BrightPattern__SPRecordingOrTranscriptURL__c]       VARCHAR(1024),
  [Center_Name__c]                                     VARCHAR(1300),
  [Completed_Date__c]                                  DATE,
  [External_ID__c]                                     VARCHAR(255),
  [Lead__c]                                            VARCHAR(18),
  [Meeting_Platform_Id__c]                             VARCHAR(1300),
  [Meeting_Platform__c]                                VARCHAR(1300),
  [Person_Account__c]                                  VARCHAR(18),
  [Recording_Link__c]                                  VARCHAR(1300),
  [Result__c]                                          VARCHAR(255),
  [SPRecordingOrTranscriptURL__c]                      VARCHAR(255),
  [Service_Appointment__c]                             VARCHAR(18),
  [Service_Territory_Caller_Id__c]                     VARCHAR(40),
  [Agent_Link__c]                                      VARCHAR(1300),
  [Guest_Link__c]                                      VARCHAR(1300),
  [Opportunity__c]                                     VARCHAR(18),
  [Center_Phone__c]                                    VARCHAR(1300),
  [DB_Activity_Type__c]                                VARCHAR(1300),
  [CallBackDueDate__c]                                 DATE,
  [Invite__c]                                          VARCHAR(1300),
CONSTRAINT [pk_Event] PRIMARY KEY ([Id]),
CONSTRAINT [uk_EventExternal_ID__c] UNIQUE ([External_ID__c])
) 
;

CREATE TABLE [ffc__Event__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(80),
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [ffc__DateCreated__c]             VARCHAR(10),
  [ffc__Description__c]             VARCHAR(255),
  [ffc__Link__c]                    VARCHAR(200),
  [ffc__Sequence__c]                DECIMAL(5,0),
  [ffc__StartDate__c]               VARCHAR(10),
  [ffc__StartTime__c]               VARCHAR(10),
  [ffc__ThumbnailLargeURI__c]       VARCHAR(255),
  [ffc__ThumbnailSmallURI__c]       VARCHAR(255),
  [ffc__Title__c]                   VARCHAR(200),
  [ffc__Type__c]                    VARCHAR(255),
CONSTRAINT [pk_ffc__Event__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__EventData__c] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [OwnerId]                   VARCHAR(18) NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [Name]                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]           VARCHAR(255),
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [APXTConga4__Kind__c]       VARCHAR(255) NOT NULL,
  [APXTConga4__Raw__c]        TEXT,
CONSTRAINT [pk_APXTConga4__EventData__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ExchangeRateEntry__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [fferpcore__ExchangeRateGroup__c]       VARCHAR(18) NOT NULL,
  [fferpcore__EndDate__c]                 DATE,
  [fferpcore__ExchangeRateType__c]        VARCHAR(255),
  [fferpcore__RelativeCurrency__c]        VARCHAR(1300),
  [fferpcore__StartDate__c]               DATE,
CONSTRAINT [pk_fferpcore__ExchangeRateEntry__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ExchangeRateGroup__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [OwnerId]                                VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(80),
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [LastViewedDate]                         DATETIME2,
  [LastReferencedDate]                     DATETIME2,
  [fferpcore__DefaultCurrency__c]          VARCHAR(255) NOT NULL,
  [fferpcore__SelectedCurrencies__c]       VARCHAR(1000) NOT NULL,
CONSTRAINT [pk_fferpcore__ExchangeRateGroup__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ExchangeRateHistory__c] ( 
  [Id]                                   VARCHAR(18) NOT NULL,
  [OwnerId]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                            BIT NOT NULL,
  [Name]                                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                      VARCHAR(255),
  [CreatedDate]                          DATETIME2 NOT NULL,
  [CreatedById]                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                     DATETIME2 NOT NULL,
  [LastModifiedById]                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                       DATETIME2 NOT NULL,
  [LastViewedDate]                       DATETIME2,
  [LastReferencedDate]                   DATETIME2,
  [fferpcore__EndDate__c]                DATE,
  [fferpcore__Group__c]                  VARCHAR(18) NOT NULL,
  [fferpcore__RateCurrency__c]           VARCHAR(3) NOT NULL,
  [fferpcore__RateType__c]               VARCHAR(255) NOT NULL,
  [fferpcore__Rate__c]                   DECIMAL(9,9),
  [fferpcore__RelativeCurrency__c]       VARCHAR(1300),
  [fferpcore__StartDate__c]              DATE NOT NULL,
CONSTRAINT [pk_fferpcore__ExchangeRateHistory__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__FeatureConsoleActivation__c] ( 
  [Id]                                   VARCHAR(18) NOT NULL,
  [OwnerId]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                            BIT NOT NULL,
  [Name]                                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                      VARCHAR(255),
  [CreatedDate]                          DATETIME2 NOT NULL,
  [CreatedById]                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                     DATETIME2 NOT NULL,
  [LastModifiedById]                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                       DATETIME2 NOT NULL,
  [fferpcore__ActivationNumber__c]       DECIMAL(18,0),
  [fferpcore__Enabled__c]                BIT NOT NULL,
  [fferpcore__Memento__c]                TEXT,
  [fferpcore__Status__c]                 VARCHAR(255),
  [fferpcore__TargetId__c]               VARCHAR(18) NOT NULL,
CONSTRAINT [pk_fferpcore__FeatureConsoleActivation__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__FeatureConsoleActivation__cfferpcore__TargetId__c] UNIQUE ([fferpcore__TargetId__c])
) 
;

CREATE TABLE [fferpcore__FeatureEnablementLog__c] ( 
  [Id]                                   VARCHAR(18) NOT NULL,
  [OwnerId]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                            BIT NOT NULL,
  [Name]                                 VARCHAR(80),
  [CurrencyIsoCode]                      VARCHAR(255),
  [CreatedDate]                          DATETIME2 NOT NULL,
  [CreatedById]                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                     DATETIME2 NOT NULL,
  [LastModifiedById]                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                       DATETIME2 NOT NULL,
  [fferpcore__ActivationNumber__c]       DECIMAL(18,0),
  [fferpcore__FeatureName__c]            VARCHAR(255),
  [fferpcore__IsEnablement__c]           BIT NOT NULL,
  [fferpcore__LogDetail__c]              TEXT,
  [fferpcore__LogSeverity__c]            VARCHAR(255) NOT NULL,
  [fferpcore__StepName__c]               VARCHAR(255),
CONSTRAINT [pk_fferpcore__FeatureEnablementLog__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__HS_Filter__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [rh2__Condition__c]                 VARCHAR(255),
  [rh2__Field__c]                     VARCHAR(255),
  [rh2__ImportId__c]                  VARCHAR(255),
  [rh2__JSON__c]                      TEXT,
  [rh2__Logic__c]                     VARCHAR(50),
  [rh2__Newline_Formula__c]           VARCHAR(1300),
  [rh2__PS_Exception__c]              VARCHAR(18),
  [rh2__Test_Account__c]              VARCHAR(18),
  [rh2__Test_Contact__c]              VARCHAR(18),
  [rh2__Test_Describe__c]             VARCHAR(18),
  [rh2__Test_Multi_Picklist__c]       VARCHAR(1000),
  [rh2__XRef__c]                      VARCHAR(255) NOT NULL,
CONSTRAINT [pk_rh2__HS_Filter__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__Filter__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [rh2__Condition__c]                 VARCHAR(255),
  [rh2__Field__c]                     VARCHAR(255),
  [rh2__ImportId__c]                  VARCHAR(255),
  [rh2__JSON__c]                      TEXT,
  [rh2__Logic__c]                     VARCHAR(50),
  [rh2__Newline_Formula__c]           VARCHAR(1300),
  [rh2__PS_Exception__c]              VARCHAR(18),
  [rh2__Test_Account__c]              VARCHAR(18),
  [rh2__Test_Contact__c]              VARCHAR(18),
  [rh2__Test_Describe__c]             VARCHAR(18),
  [rh2__Test_Multi_Picklist__c]       VARCHAR(1000),
  [rh2__XRef__c]                      VARCHAR(255) NOT NULL,
CONSTRAINT [pk_rh2__Filter__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ff_frb__Financial_Report__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [OwnerId]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(80),
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [LastViewedDate]                        DATETIME2,
  [LastReferencedDate]                    DATETIME2,
  [ff_frb__Description__c]                VARCHAR(255),
  [ff_frb__FilterConfiguration1__c]       TEXT,
  [ff_frb__FilterConfiguration2__c]       TEXT,
  [ff_frb__FilterConfiguration3__c]       TEXT,
  [ff_frb__FilterConfiguration4__c]       TEXT,
  [ff_frb__FilterConfiguration5__c]       TEXT,
  [ff_frb__FilterConfiguration__c]        VARCHAR(255),
  [ff_frb__Report_Type__c]                VARCHAR(255) NOT NULL,
  [ff_frb__TableConfiguration1__c]        TEXT,
  [ff_frb__TableConfiguration2__c]        TEXT,
  [ff_frb__TableConfiguration3__c]        TEXT,
  [ff_frb__TableConfiguration__c]         VARCHAR(255) NOT NULL,
CONSTRAINT [pk_ff_frb__Financial_Report__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ff_frb__Financial_Statement__c] ( 
  [Id]                                            VARCHAR(18) NOT NULL,
  [OwnerId]                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                     BIT NOT NULL,
  [Name]                                          VARCHAR(80),
  [CurrencyIsoCode]                               VARCHAR(255),
  [RecordTypeId]                                  VARCHAR(18),
  [CreatedDate]                                   DATETIME2 NOT NULL,
  [CreatedById]                                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]                              DATETIME2 NOT NULL,
  [LastModifiedById]                              VARCHAR(18) NOT NULL,
  [SystemModstamp]                                DATETIME2 NOT NULL,
  [ff_frb__CompanyFilterConfiguration__c]         TEXT,
  [ff_frb__Description__c]                        VARCHAR(255),
  [ff_frb__ReportComponentConfiguration__c]       TEXT,
  [ff_frb__YearFilterConfiguration__c]            TEXT,
CONSTRAINT [pk_ff_frb__Financial_Statement__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [FlowInterview] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [OwnerId]                   VARCHAR(18) NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [Name]                      VARCHAR(255) NOT NULL,
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [CurrentElement]            VARCHAR(100),
  [InterviewLabel]            VARCHAR(1000),
  [PauseLabel]                VARCHAR(1000),
  [Guid]                      VARCHAR(255),
  [WasPausedFromScreen]       BIT NOT NULL,
  [FlowVersionViewId]         VARCHAR(512),
  [InterviewStatus]           VARCHAR(255) NOT NULL,
CONSTRAINT [pk_FlowInterview] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__fflib_BatchProcess__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [fferpcore__ApexJobClassName__c]              VARCHAR(80),
  [fferpcore__ApexJobID__c]                     VARCHAR(18),
  [fferpcore__BatchControlRecordID__c]          VARCHAR(18),
  [fferpcore__ConcurrencyModeUniqueID__c]       VARCHAR(80),
  [fferpcore__CurrentChainIndex__c]             DECIMAL(3,0),
  [fferpcore__CurrentChainNumber__c]            DECIMAL(3,0),
  [fferpcore__FailedRecordID__c]                VARCHAR(18),
  [fferpcore__FromProgressBar__c]               BIT NOT NULL,
  [fferpcore__NumberofBatchesinChain__c]        DECIMAL(3,0),
  [fferpcore__ProcessName__c]                   VARCHAR(255),
  [fferpcore__ProgressInformation__c]           VARCHAR(255),
  [fferpcore__StatusDetail__c]                  VARCHAR(255),
  [fferpcore__Status__c]                        VARCHAR(255),
  [fferpcore__SuccessfulRecordID__c]            VARCHAR(18),
  [fferpcore__TotalChainNumber__c]              DECIMAL(3,0),
  [fferpcore__UseDefaultConstructor__c]         BIT NOT NULL,
CONSTRAINT [pk_fferpcore__fflib_BatchProcess__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__fflib_BatchProcess__cfferpcore__ApexJobID__c] UNIQUE ([fferpcore__ApexJobID__c]),
CONSTRAINT [uk_fferpcore__fflib_BatchProcess__cfferpcore__ConcurrencyModeUniqueID__c] UNIQUE ([fferpcore__ConcurrencyModeUniqueID__c])
) 
;

CREATE TABLE [fferpcore__fflib_BatchProcessDetail__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [fferpcore__BatchProcess__c]       VARCHAR(18) NOT NULL,
  [fferpcore__ApexJobId__c]          VARCHAR(18),
  [fferpcore__ChainNumber__c]        DECIMAL(3,0),
  [fferpcore__StatusDetail__c]       VARCHAR(255),
  [fferpcore__Status__c]             VARCHAR(255),
CONSTRAINT [pk_fferpcore__fflib_BatchProcessDetail__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__fflib_BatchProcessDetail__cfferpcore__ApexJobId__c] UNIQUE ([fferpcore__ApexJobId__c])
) 
;

CREATE TABLE [fferpcore__fflib_SchedulerConfiguration__c] ( 
  [Id]                                                  VARCHAR(18) NOT NULL,
  [OwnerId]                                             VARCHAR(18) NOT NULL,
  [IsDeleted]                                           BIT NOT NULL,
  [Name]                                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                     VARCHAR(255),
  [CreatedDate]                                         DATETIME2 NOT NULL,
  [CreatedById]                                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                    DATETIME2 NOT NULL,
  [LastModifiedById]                                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                                      DATETIME2 NOT NULL,
  [fferpcore__EndAfterX__c]                             DECIMAL(2,0),
  [fferpcore__EndDate__c]                               DATE,
  [fferpcore__HourlyRecurrenceInterval__c]              DECIMAL(2,0),
  [fferpcore__MonthlyFixedDate__c]                      DECIMAL(2,0),
  [fferpcore__MonthlyRecurMode__c]                      VARCHAR(255),
  [fferpcore__MonthlyRecurRelativeDateFlavor__c]        VARCHAR(255),
  [fferpcore__MonthlyRecurRelativeDateOrdinal__c]       VARCHAR(255),
  [fferpcore__NearestWeekday__c]                        BIT NOT NULL,
  [fferpcore__PreferredStartTimeHour__c]                DECIMAL(2,0),
  [fferpcore__PreferredStartTimeMinute__c]              DECIMAL(2,0),
  [fferpcore__SchedulingFrequency__c]                   VARCHAR(255),
  [fferpcore__StartDate__c]                             DATE,
  [fferpcore__VisibleFields__c]                         VARCHAR(1000),
  [fferpcore__WeeklyRecurOnDays__c]                     VARCHAR(1000),
CONSTRAINT [pk_fferpcore__fflib_SchedulerConfiguration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [CollaborationGroup] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [Name]                         VARCHAR(40) NOT NULL,
  [MemberCount]                  VARCHAR(255),
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [CollaborationType]            VARCHAR(255) NOT NULL,
  [Description]                  TEXT,
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [FullPhotoUrl]                 VARCHAR(1024),
  [MediumPhotoUrl]               VARCHAR(1024),
  [SmallPhotoUrl]                VARCHAR(1024),
  [LastFeedModifiedDate]         DATETIME2 NOT NULL,
  [InformationTitle]             VARCHAR(30),
  [InformationBody]              TEXT,
  [HasPrivateFieldsAccess]       BIT NOT NULL,
  [CanHaveGuests]                BIT NOT NULL,
  [NetworkId]                    VARCHAR(18),
  [LastViewedDate]               DATETIME2,
  [LastReferencedDate]           DATETIME2,
  [IsArchived]                   BIT NOT NULL,
  [IsAutoArchiveDisabled]        BIT NOT NULL,
  [AnnouncementId]               VARCHAR(18),
  [GroupEmail]                   VARCHAR(128),
  [BannerPhotoUrl]               VARCHAR(1024),
  [IsBroadcast]                  BIT NOT NULL,
  [IsActivityGroup]              BIT NOT NULL,
CONSTRAINT [pk_CollaborationGroup] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Idea] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Title]                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [RecordTypeId]               VARCHAR(18),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [LastViewedDate]             DATETIME2,
  [LastReferencedDate]         DATETIME2,
  [CommunityId]                VARCHAR(18) NOT NULL,
  [Body]                       TEXT,
  [NumComments]                VARCHAR(30),
  [VoteScore]                  DECIMAL(14,4),
  [VoteTotal]                  DECIMAL(18,0),
  [Categories]                 VARCHAR(1000),
  [Status]                     VARCHAR(255),
  [LastCommentDate]            VARCHAR(30),
  [LastCommentId]              VARCHAR(18),
  [ParentIdeaId]               VARCHAR(18),
  [IsHtml]                     BIT NOT NULL,
  [IsMerged]                   BIT NOT NULL,
  [CreatorFullPhotoUrl]        VARCHAR(255),
  [CreatorSmallPhotoUrl]       VARCHAR(255),
  [CreatorName]                VARCHAR(121),
CONSTRAINT [pk_Idea] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Image] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [OwnerId]                    VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255),
  [CurrencyIsoCode]            VARCHAR(255),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [LastViewedDate]             DATETIME2,
  [LastReferencedDate]         DATETIME2,
  [ImageViewType]              VARCHAR(80),
  [IsActive]                   BIT NOT NULL,
  [ImageClass]                 VARCHAR(255),
  [ImageClassObjectType]       VARCHAR(255),
  [ContentDocumentId]          VARCHAR(18),
  [CapturedAngle]              VARCHAR(8),
  [Title]                      VARCHAR(255),
  [AlternateText]              VARCHAR(255),
  [Url]                        VARCHAR(1024),
CONSTRAINT [pk_Image] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__IndividualEmailResult__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__IndividualEmailResult__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__IndividualLink__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(80),
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [et4ae5__Unique_Link_ID__c]       VARCHAR(255) NOT NULL,
CONSTRAINT [pk_et4ae5__IndividualLink__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_et4ae5__IndividualLink__cet4ae5__Unique_Link_ID__c] UNIQUE ([et4ae5__Unique_Link_ID__c])
) 
;

CREATE TABLE [Knowledge__kav] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [KnowledgeArticleId]                 VARCHAR(18) NOT NULL,
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [ValidationStatus]                   VARCHAR(255) NOT NULL,
  [PublishStatus]                      VARCHAR(255) NOT NULL,
  [VersionNumber]                      VARCHAR(255) NOT NULL,
  [IsLatestVersion]                    BIT NOT NULL,
  [IsVisibleInApp]                     BIT NOT NULL,
  [IsVisibleInPkb]                     BIT NOT NULL,
  [IsVisibleInCsp]                     BIT NOT NULL,
  [IsVisibleInPrm]                     BIT NOT NULL,
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [Language]                           VARCHAR(255) NOT NULL,
  [Title]                              VARCHAR(255) NOT NULL,
  [UrlName]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                    VARCHAR(255) NOT NULL,
  [ArchivedDate]                       DATETIME2,
  [ArchivedById]                       VARCHAR(18),
  [Summary]                            TEXT,
  [ArticleNumber]                      VARCHAR(255) NOT NULL,
  [FirstPublishedDate]                 DATETIME2,
  [LastPublishedDate]                  DATETIME2,
  [ArticleArchivedById]                VARCHAR(18),
  [ArticleArchivedDate]                DATETIME2,
  [ArticleCaseAttachCount]             VARCHAR(255),
  [ArticleCreatedById]                 VARCHAR(18),
  [ArticleCreatedDate]                 DATETIME2,
  [ArticleTotalViewCount]              VARCHAR(255),
  [SourceId]                           VARCHAR(18),
  [AssignedToId]                       VARCHAR(18),
  [AssignedById]                       VARCHAR(18),
  [AssignmentDate]                     DATETIME2,
  [AssignmentDueDate]                  DATETIME2,
  [AssignmentNote]                     TEXT,
  [MigratedToFromArticleVersion]       VARCHAR(15),
CONSTRAINT [pk_Knowledge__kav] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Lead] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [MasterRecordId]                                   VARCHAR(18),
  [LastName]                                         VARCHAR(80) NOT NULL,
  [FirstName]                                        VARCHAR(40),
  [Salutation]                                       VARCHAR(255),
  [MiddleName]                                       VARCHAR(40),
  [Suffix]                                           VARCHAR(40),
  [Name]                                             VARCHAR(121) NOT NULL,
  [RecordTypeId]                                     VARCHAR(18),
  [Title]                                            VARCHAR(128),
  [Company]                                          VARCHAR(255),
  [Street]                                           VARCHAR(255),
  [City]                                             VARCHAR(40),
  [State]                                            VARCHAR(80),
  [PostalCode]                                       VARCHAR(20),
  [Country]                                          VARCHAR(80),
  [StateCode]                                        VARCHAR(255),
  [CountryCode]                                      VARCHAR(255),
  [Latitude]                                         DECIMAL(15,15),
  [Longitude]                                        DECIMAL(15,15),
  [GeocodeAccuracy]                                  VARCHAR(255),
  [Address]                                          VARCHAR(255),
  [Phone]                                            VARCHAR(40),
  [MobilePhone]                                      VARCHAR(40),
  [Fax]                                              VARCHAR(40),
  [Email]                                            VARCHAR(128),
  [Website]                                          VARCHAR(1024),
  [PhotoUrl]                                         VARCHAR(1024),
  [Description]                                      TEXT,
  [LeadSource]                                       VARCHAR(255),
  [Status]                                           VARCHAR(255) NOT NULL,
  [Industry]                                         VARCHAR(255),
  [Rating]                                           VARCHAR(255),
  [CurrencyIsoCode]                                  VARCHAR(255),
  [AnnualRevenue]                                    DECIMAL(18,0),
  [NumberOfEmployees]                                VARCHAR(255),
  [OwnerId]                                          VARCHAR(18) NOT NULL,
  [HasOptedOutOfEmail]                               BIT NOT NULL,
  [IsConverted]                                      BIT NOT NULL,
  [ConvertedDate]                                    DATE,
  [ConvertedAccountId]                               VARCHAR(18),
  [ConvertedContactId]                               VARCHAR(18),
  [ConvertedOpportunityId]                           VARCHAR(18),
  [IsUnreadByOwner]                                  BIT NOT NULL,
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [LastActivityDate]                                 DATE,
  [DoNotCall]                                        BIT NOT NULL,
  [HasOptedOutOfFax]                                 BIT NOT NULL,
  [LastViewedDate]                                   DATETIME2,
  [LastReferencedDate]                               DATETIME2,
  [LastTransferDate]                                 DATE,
  [Jigsaw]                                           VARCHAR(20),
  [JigsawContactId]                                  VARCHAR(20),
  [EmailBouncedReason]                               VARCHAR(255),
  [EmailBouncedDate]                                 DATETIME2,
  [et4ae5__HasOptedOutOfMobile__c]                   BIT NOT NULL,
  [et4ae5__Mobile_Country_Code__c]                   VARCHAR(255),
  [Age__c]                                           DECIMAL(18,0),
  [Birthdate__c]                                     DATE,
  [Cancellation_Reason__c]                           VARCHAR(255),
  [DoNotContact__c]                                  BIT NOT NULL,
  [DoNotEmail__c]                                    BIT NOT NULL,
  [DoNotMail__c]                                     BIT NOT NULL,
  [DoNotText__c]                                     BIT NOT NULL,
  [Ethnicity__c]                                     VARCHAR(255),
  [External_Id__c]                                   VARCHAR(255),
  [Gender__c]                                        VARCHAR(255),
  [HairLossExperience__c]                            VARCHAR(255),
  [HairLossFamily__c]                                VARCHAR(255),
  [HairLossOrVolume__c]                              VARCHAR(255),
  [HairLossProductOther__c]                          VARCHAR(255),
  [HairLossProductUsed__c]                           VARCHAR(255),
  [HairLossSpot__c]                                  VARCHAR(255),
  [HardCopyPreferred__c]                             BIT NOT NULL,
  [Language__c]                                      VARCHAR(255),
  [Lead_Qualifier__c]                                VARCHAR(18),
  [Lead_Rescheduler__c]                              VARCHAR(18),
  [LudwigScale__c]                                   VARCHAR(255),
  [MaritalStatus__c]                                 VARCHAR(255),
  [MobilePhone_Number_Normalized__c]                 VARCHAR(40),
  [NorwoodScale__c]                                  VARCHAR(255),
  [Promo_Code__c]                                    VARCHAR(18),
  [Referral_Code_Expiration_Date__c]                 DATE,
  [Referral_Code__c]                                 VARCHAR(255),
  [Service_Territory__c]                             VARCHAR(18),
  [SolutionOffered__c]                               VARCHAR(255),
  [Text_Reminer_Opt_In__c]                           BIT NOT NULL,
  [Occupation__c]                                    VARCHAR(255),
  [Ammount__c]                                       DECIMAL(16,2),
  [DNCDateMobilePhone__c]                            DATETIME2,
  [DNCDatePhone__c]                                  DATETIME2,
  [DNCValidationMobilePhone__c]                      BIT NOT NULL,
  [DNCValidationPhone__c]                            BIT NOT NULL,
  [GCLID__c]                                         VARCHAR(255),
  [Goals_Expectations__c]                            TEXT,
  [How_many_times_a_week_do_you_think__c]            VARCHAR(255),
  [How_much_time_a_week_do_you_spend__c]             TEXT,
  [Other_Reason__c]                                  TEXT,
  [What_are_your_main_concerns_today__c]             VARCHAR(255),
  [What_else_would_be_helpful_for_your__c]           TEXT,
  [What_methods_have_you_used_or_currently__c]       VARCHAR(255),
  [RefersionLogId__c]                                VARCHAR(255) NOT NULL,
  [Service_Territory_Time_Zone__c]                   VARCHAR(1300),
  [DB_Created_Date_without_Time__c]                  DATE,
  [DB_Lead_Age__c]                                   DECIMAL(18,0),
  [RecordTypeDeveloperName__c]                       VARCHAR(50),
  [Service_Territory_Area__c]                        VARCHAR(1300),
  [Lead_Owner_Division__c]                           VARCHAR(1300),
  [Service_Territory_Center_Type__c]                 VARCHAR(1300),
  [Service_Territory_Center_Number__c]               VARCHAR(1300),
  [No_Lead__c]                                       DECIMAL(18,0),
  [HCUID__c]                                         VARCHAR(255),
  [GCID__c]                                          VARCHAR(255),
  [MSCLKID__c]                                       VARCHAR(255),
  [FBCLID__c]                                        VARCHAR(255),
  [KUID__c]                                          VARCHAR(255),
  [Campaign_Source_Code__c]                          VARCHAR(255),
  [Service_Territory_Number__c]                      VARCHAR(4),
  [Bosley_Center_Number__c]                          VARCHAR(255),
  [Bosley_Client_Id__c]                              VARCHAR(255),
  [Bosley_Country_Description__c]                    VARCHAR(255),
  [Bosley_Gender_Description__c]                     VARCHAR(255),
  [Bosley_Legacy_Source_Code__c]                     VARCHAR(255),
  [Bosley_Salesforce_Id__c]                          VARCHAR(255),
  [Bosley_Siebel_Id__c]                              VARCHAR(255),
  [Next_Milestone_Event__c]                          VARCHAR(255),
  [Next_Milestone_Event_Date__c]                     DATE,
  [Service_Territory_Center_Owner__c]                VARCHAR(1300),
  [Warm_Welcome_Call__c]                             BIT NOT NULL,
  [Lead_ID_18_dig__c]                                VARCHAR(1300),
CONSTRAINT [pk_Lead] PRIMARY KEY ([Id]),
CONSTRAINT [uk_LeadExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [OpportunityLineItemSchedule] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [OpportunityLineItemId]       VARCHAR(18) NOT NULL,
  [Type]                        VARCHAR(255) NOT NULL,
  [Revenue]                     DECIMAL(16,2),
  [Quantity]                    DECIMAL(16,2),
  [Description]                 VARCHAR(80),
  [ScheduleDate]                DATE NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255) NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
CONSTRAINT [pk_OpportunityLineItemSchedule] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [LinkedArticle] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [KnowledgeArticleVersionId]       VARCHAR(18),
  [LinkedEntityId]                  VARCHAR(18),
  [KnowledgeArticleId]              VARCHAR(18),
  [Type]                            VARCHAR(50),
CONSTRAINT [pk_LinkedArticle] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ListEmail] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Subject]                  TEXT,
  [HtmlBody]                 TEXT,
  [TextBody]                 TEXT,
  [FromName]                 VARCHAR(121),
  [FromAddress]              TEXT NOT NULL,
  [Status]                   VARCHAR(255) NOT NULL,
  [HasAttachment]            BIT NOT NULL,
  [ScheduledDate]            DATETIME2,
  [TotalSent]                VARCHAR(255),
  [CampaignId]               VARCHAR(18),
  [IsTracked]                BIT NOT NULL,
CONSTRAINT [pk_ListEmail] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Location] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [Name]                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255),
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [LocationType]                VARCHAR(255) NOT NULL,
  [Latitude]                    DECIMAL(15,15),
  [Longitude]                   DECIMAL(15,15),
  [Location]                    VARCHAR(255),
  [Description]                 VARCHAR(255),
  [DrivingDirections]           VARCHAR(1000),
  [TimeZone]                    VARCHAR(255),
  [ParentLocationId]            VARCHAR(18),
  [PossessionDate]              DATE,
  [ConstructionStartDate]       DATE,
  [ConstructionEndDate]         DATE,
  [OpenDate]                    DATE,
  [CloseDate]                   DATE,
  [RemodelStartDate]            DATE,
  [RemodelEndDate]              DATE,
  [IsMobile]                    BIT NOT NULL,
  [IsInventoryLocation]         BIT NOT NULL,
  [RootLocationId]              VARCHAR(18),
  [LocationLevel]               VARCHAR(255),
  [ExternalReference]           VARCHAR(255),
  [LogoId]                      VARCHAR(18),
CONSTRAINT [pk_Location] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [LocationTrustMeasure] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [LocationId]                      VARCHAR(18) NOT NULL,
  [Title]                           VARCHAR(40) NOT NULL,
  [IsVisibleInPublic]               BIT NOT NULL,
  [IconUrl]                         VARCHAR(255),
  [Description]                     VARCHAR(255) NOT NULL,
  [SortOrder]                       VARCHAR(255),
  [LocationExternalReference]       VARCHAR(255),
CONSTRAINT [pk_LocationTrustMeasure] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Macro] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [OwnerId]                    VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [LastViewedDate]             DATETIME2,
  [LastReferencedDate]         DATETIME2,
  [Description]                TEXT,
  [IsAlohaSupported]           BIT NOT NULL,
  [IsLightningSupported]       BIT NOT NULL,
  [StartingContext]            VARCHAR(255),
CONSTRAINT [pk_Macro] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ManagedContentVariant] ( 
  [Id]                      VARCHAR(18) NOT NULL,
  [IsDeleted]               BIT NOT NULL,
  [Name]                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]         VARCHAR(255) NOT NULL,
  [CreatedDate]             DATETIME2 NOT NULL,
  [CreatedById]             VARCHAR(18) NOT NULL,
  [LastModifiedDate]        DATETIME2 NOT NULL,
  [LastModifiedById]        VARCHAR(18) NOT NULL,
  [SystemModstamp]          DATETIME2 NOT NULL,
  [VariantType]             VARCHAR(255) NOT NULL,
  [Language]                VARCHAR(255) NOT NULL,
  [UrlName]                 VARCHAR(80),
  [ManagedContentKey]       VARCHAR(80) NOT NULL,
  [IsPublished]             VARCHAR(30) NOT NULL,
CONSTRAINT [pk_ManagedContentVariant] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__Mapping__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [OwnerId]                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [fferpcore__AdditionalLookupField__c]       VARCHAR(255),
  [fferpcore__CorrelationSourceKey__c]        VARCHAR(255),
  [fferpcore__CorrelationStrategy__c]         VARCHAR(255),
  [fferpcore__CorrelationTargetKey__c]        VARCHAR(255),
  [fferpcore__Filters__c]                     TEXT,
  [fferpcore__Identifier__c]                  VARCHAR(255),
  [fferpcore__Process__c]                     VARCHAR(255) NOT NULL,
  [fferpcore__SourceKeys__c]                  VARCHAR(255),
  [fferpcore__SourcePath__c]                  VARCHAR(255),
  [fferpcore__StaticData__c]                  VARCHAR(255),
  [fferpcore__StaticDescription__c]           VARCHAR(255),
  [fferpcore__TargetChildType__c]             VARCHAR(255),
  [fferpcore__TargetKeys__c]                  VARCHAR(255),
  [fferpcore__TargetPath__c]                  VARCHAR(255),
  [fferpcore__TransformationTable__c]         VARCHAR(18),
  [fferpcore__Type__c]                        VARCHAR(255) NOT NULL,
CONSTRAINT [pk_fferpcore__Mapping__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__MC_CDC_Journey__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__MC_CDC_Journey__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__MessagingMessage__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [OwnerId]                                   VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [LastViewedDate]                            DATETIME2,
  [LastReferencedDate]                        DATETIME2,
  [fferpcore__Body01__c]                      TEXT,
  [fferpcore__CorrelationId__c]               VARCHAR(255),
  [fferpcore__Deletable__c]                   BIT NOT NULL,
  [fferpcore__LastAttemptedDelivery__c]       DATETIME2,
  [fferpcore__MessageType2__c]                VARCHAR(18),
  [fferpcore__Sender__c]                      VARCHAR(18),
  [fferpcore__State__c]                       VARCHAR(255),
  [fferpcore__TimeToLive__c]                  DECIMAL(4,0) NOT NULL,
CONSTRAINT [pk_fferpcore__MessagingMessage__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__MessageType__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(80),
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [fferpcore__Description__c]         VARCHAR(255),
  [fferpcore__DeveloperName__c]       VARCHAR(255) NOT NULL,
  [fferpcore__ExpiryCutoff__c]        DATETIME2,
  [fferpcore__Parent__c]              VARCHAR(18),
  [fferpcore__StorageExpiry__c]       VARCHAR(10),
CONSTRAINT [pk_fferpcore__MessageType__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__MessageType__cfferpcore__DeveloperName__c] UNIQUE ([fferpcore__DeveloperName__c])
) 
;

CREATE TABLE [et4ae5__SMSDefinition__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [RecordTypeId]             VARCHAR(18),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
CONSTRAINT [pk_et4ae5__SMSDefinition__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [EntityMilestone] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [Name]                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255),
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [ParentEntityId]              VARCHAR(18) NOT NULL,
  [StartDate]                   DATETIME2,
  [TargetDate]                  DATETIME2,
  [CompletionDate]              DATETIME2,
  [SlaProcessId]                VARCHAR(18),
  [MilestoneTypeId]             VARCHAR(18),
  [IsCompleted]                 BIT NOT NULL,
  [IsViolated]                  BIT NOT NULL,
  [TargetResponseInMins]        VARCHAR(255),
  [TargetResponseInHrs]         DECIMAL(4,2),
  [TargetResponseInDays]        DECIMAL(4,2),
  [TimeRemainingInMins]         VARCHAR(10),
  [TimeRemainingInHrs]          VARCHAR(10),
  [TimeRemainingInDays]         DECIMAL(4,2),
  [ElapsedTimeInMins]           VARCHAR(255),
  [ElapsedTimeInHrs]            DECIMAL(4,2),
  [ElapsedTimeInDays]           DECIMAL(4,2),
  [TimeSinceTargetInMins]       VARCHAR(10),
  [TimeSinceTargetInHrs]        VARCHAR(10),
  [TimeSinceTargetInDays]       DECIMAL(4,2),
  [BusinessHoursId]             VARCHAR(18),
CONSTRAINT [pk_EntityMilestone] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ObjectTerritory2AssignmentRule] ( 
  [Id]                      VARCHAR(18) NOT NULL,
  [IsDeleted]               BIT NOT NULL,
  [Territory2ModelId]       VARCHAR(18) NOT NULL,
  [DeveloperName]           VARCHAR(80) NOT NULL,
  [Language]                VARCHAR(255) NOT NULL,
  [MasterLabel]             VARCHAR(80) NOT NULL,
  [CreatedDate]             DATETIME2 NOT NULL,
  [CreatedById]             VARCHAR(18) NOT NULL,
  [LastModifiedDate]        DATETIME2 NOT NULL,
  [LastModifiedById]        VARCHAR(18) NOT NULL,
  [SystemModstamp]          DATETIME2 NOT NULL,
  [ObjectType]              VARCHAR(255) NOT NULL,
  [IsActive]                BIT NOT NULL,
  [BooleanFilter]           VARCHAR(255),
CONSTRAINT [pk_ObjectTerritory2AssignmentRule] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [OperatingHours] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Description]              TEXT,
  [TimeZone]                 VARCHAR(255) NOT NULL,
  [External_Id__c]           VARCHAR(255),
CONSTRAINT [pk_OperatingHours] PRIMARY KEY ([Id]),
CONSTRAINT [uk_OperatingHoursExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [OperatingHoursHoliday] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [OperatingHoursHolidayNumber]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [OperatingHoursId]                  VARCHAR(18) NOT NULL,
  [HolidayId]                         VARCHAR(18) NOT NULL,
  [DateAndTime]                       VARCHAR(255),
CONSTRAINT [pk_OperatingHoursHoliday] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Opportunity] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [AccountId]                                        VARCHAR(18),
  [RecordTypeId]                                     VARCHAR(18),
  [IsPrivate]                                        BIT NOT NULL,
  [Name]                                             VARCHAR(120) NOT NULL,
  [Description]                                      TEXT,
  [StageName]                                        VARCHAR(255) NOT NULL,
  [Amount]                                           DECIMAL(16,2),
  [Probability]                                      DECIMAL(3,0),
  [ExpectedRevenue]                                  DECIMAL(16,2),
  [TotalOpportunityQuantity]                         DECIMAL(16,2),
  [CloseDate]                                        DATE NOT NULL,
  [Type]                                             VARCHAR(255),
  [NextStep]                                         VARCHAR(255),
  [LeadSource]                                       VARCHAR(255),
  [IsClosed]                                         BIT NOT NULL,
  [IsWon]                                            BIT NOT NULL,
  [ForecastCategory]                                 VARCHAR(255) NOT NULL,
  [ForecastCategoryName]                             VARCHAR(255),
  [CurrencyIsoCode]                                  VARCHAR(255),
  [CampaignId]                                       VARCHAR(18),
  [HasOpportunityLineItem]                           BIT NOT NULL,
  [Pricebook2Id]                                     VARCHAR(18),
  [OwnerId]                                          VARCHAR(18) NOT NULL,
  [Territory2Id]                                     VARCHAR(18),
  [IsExcludedFromTerritory2Filter]                   BIT NOT NULL,
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [LastActivityDate]                                 DATE,
  [PushCount]                                        VARCHAR(255),
  [LastStageChangeDate]                              DATETIME2,
  [FiscalQuarter]                                    VARCHAR(255),
  [FiscalYear]                                       VARCHAR(255),
  [Fiscal]                                           VARCHAR(6),
  [ContactId]                                        VARCHAR(18),
  [LastViewedDate]                                   DATETIME2,
  [LastReferencedDate]                               DATETIME2,
  [SyncedQuoteId]                                    VARCHAR(18),
  [ContractId]                                       VARCHAR(18),
  [HasOpenActivity]                                  BIT NOT NULL,
  [HasOverdueTask]                                   BIT NOT NULL,
  [IqScore]                                          VARCHAR(255),
  [LastAmountChangedHistoryId]                       VARCHAR(18),
  [LastCloseDateChangedHistoryId]                    VARCHAR(18),
  [Budget_Confirmed__c]                              BIT NOT NULL,
  [Discovery_Completed__c]                           BIT NOT NULL,
  [ROI_Analysis_Completed__c]                        BIT NOT NULL,
  [Appointment_Source__c]                            VARCHAR(255),
  [Loss_Reason__c]                                   VARCHAR(255),
  [Cancellation_Reason__c]                           VARCHAR(255),
  [Hair_Loss_Experience__c]                          VARCHAR(255),
  [Hair_Loss_Family__c]                              VARCHAR(255),
  [Hair_Loss_Or_Volume__c]                           VARCHAR(255),
  [Hair_Loss_Product_Other__c]                       VARCHAR(255),
  [Hair_Loss_Product_Used__c]                        VARCHAR(255),
  [Hair_Loss_Spot__c]                                VARCHAR(255),
  [IP_Address__c]                                    VARCHAR(255),
  [Ludwig_Scale__c]                                  VARCHAR(255),
  [Norwood_Scale__c]                                 VARCHAR(255),
  [Referral_Code_Expiration_Date__c]                 DATE,
  [Referral_Code__c]                                 VARCHAR(255),
  [Service_Territory__c]                             VARCHAR(18),
  [DB_Competitor__c]                                 VARCHAR(255),
  [Source_Code__c]                                   VARCHAR(255),
  [Submitted_for_Approval__c]                        BIT NOT NULL,
  [Ammount__c]                                       DECIMAL(16,2),
  [GCLID__c]                                         VARCHAR(255),
  [Promo_Code__c]                                    VARCHAR(18),
  [SolutionOffered__c]                               VARCHAR(255),
  [Approver__c]                                      VARCHAR(18),
  [Email__c]                                         VARCHAR(1300),
  [Goals_Expectations__c]                            TEXT,
  [How_many_times_a_week_do_you_think__c]            VARCHAR(255),
  [How_much_time_a_week_do_you_spend__c]             TEXT,
  [Mobile__c]                                        VARCHAR(1300),
  [Opportunity_Owner__c]                             VARCHAR(1300),
  [Other_Reason__c]                                  TEXT,
  [Owner__c]                                         VARCHAR(18),
  [Phone__c]                                         VARCHAR(1300),
  [What_are_your_main_concerns_today__c]             VARCHAR(255),
  [What_else_would_be_helpful_for_your__c]           TEXT,
  [What_methods_have_you_used_or_currently__c]       VARCHAR(255),
  [RefersionLogId__c]                                VARCHAR(255) NOT NULL,
  [Commission_Paid__c]                               BIT NOT NULL,
  [Owner_Division__c]                                VARCHAR(1300),
  [Service_Territory_Number__c]                      VARCHAR(4),
  [Commission_Override__c]                           VARCHAR(18),
CONSTRAINT [pk_Opportunity] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [OpportunityContactRole] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OpportunityId]          VARCHAR(18) NOT NULL,
  [ContactId]              VARCHAR(18) NOT NULL,
  [Role]                   VARCHAR(255),
  [IsPrimary]              BIT NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
CONSTRAINT [pk_OpportunityContactRole] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [OpportunityLineItem] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OpportunityId]                VARCHAR(18) NOT NULL,
  [SortOrder]                    VARCHAR(255),
  [PricebookEntryId]             VARCHAR(18),
  [Product2Id]                   VARCHAR(18),
  [ProductCode]                  VARCHAR(255),
  [Name]                         VARCHAR(376),
  [CurrencyIsoCode]              VARCHAR(255) NOT NULL,
  [Quantity]                     DECIMAL(10,2) NOT NULL,
  [TotalPrice]                   DECIMAL(16,2),
  [UnitPrice]                    DECIMAL(16,2),
  [ListPrice]                    DECIMAL(16,2),
  [ServiceDate]                  DATE,
  [HasRevenueSchedule]           BIT NOT NULL,
  [HasQuantitySchedule]          BIT NOT NULL,
  [Description]                  VARCHAR(255),
  [HasSchedule]                  BIT NOT NULL,
  [CanUseQuantitySchedule]       BIT NOT NULL,
  [CanUseRevenueSchedule]        BIT NOT NULL,
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [LastViewedDate]               DATETIME2,
  [LastReferencedDate]           DATETIME2,
CONSTRAINT [pk_OpportunityLineItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [OpportunityTeamMember] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OpportunityId]                VARCHAR(18) NOT NULL,
  [UserId]                       VARCHAR(18) NOT NULL,
  [Name]                         VARCHAR(361),
  [PhotoUrl]                     VARCHAR(1024),
  [Title]                        VARCHAR(80),
  [TeamMemberRole]               VARCHAR(255),
  [OpportunityAccessLevel]       VARCHAR(255),
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
CONSTRAINT [pk_OpportunityTeamMember] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [FlowOrchestrationInstance] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [Status]                 VARCHAR(255) NOT NULL,
  [InterviewId]            VARCHAR(18),
CONSTRAINT [pk_FlowOrchestrationInstance] PRIMARY KEY ([Id]),
CONSTRAINT [uk_FlowOrchestrationInstanceInterviewId] UNIQUE ([InterviewId])
) 
;

CREATE TABLE [FlowOrchestrationStageInstance] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255) NOT NULL,
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [OrchestrationInstanceId]       VARCHAR(18) NOT NULL,
  [Status]                        VARCHAR(255) NOT NULL,
  [Position]                      VARCHAR(255) NOT NULL,
  [Label]                         VARCHAR(80) NOT NULL,
CONSTRAINT [pk_FlowOrchestrationStageInstance] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [FlowOrchestrationStepInstance] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255) NOT NULL,
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [OrchestrationInstanceId]       VARCHAR(18) NOT NULL,
  [StageInstanceId]               VARCHAR(18) NOT NULL,
  [StepType]                      VARCHAR(255) NOT NULL,
  [Status]                        VARCHAR(255) NOT NULL,
  [Label]                         VARCHAR(80) NOT NULL,
CONSTRAINT [pk_FlowOrchestrationStepInstance] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Order] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [ContractId]                    VARCHAR(18),
  [AccountId]                     VARCHAR(18),
  [Pricebook2Id]                  VARCHAR(18),
  [OriginalOrderId]               VARCHAR(18),
  [EffectiveDate]                 DATE NOT NULL,
  [EndDate]                       DATE,
  [IsReductionOrder]              BIT NOT NULL,
  [Status]                        VARCHAR(255) NOT NULL,
  [Description]                   TEXT,
  [CustomerAuthorizedById]        VARCHAR(18),
  [CompanyAuthorizedById]         VARCHAR(18),
  [Type]                          VARCHAR(255),
  [BillingStreet]                 VARCHAR(255),
  [BillingCity]                   VARCHAR(40),
  [BillingState]                  VARCHAR(80),
  [BillingPostalCode]             VARCHAR(20),
  [BillingCountry]                VARCHAR(80),
  [BillingStateCode]              VARCHAR(255),
  [BillingCountryCode]            VARCHAR(255),
  [BillingLatitude]               DECIMAL(15,15),
  [BillingLongitude]              DECIMAL(15,15),
  [BillingGeocodeAccuracy]        VARCHAR(255),
  [BillingAddress]                VARCHAR(255),
  [ShippingStreet]                VARCHAR(255),
  [ShippingCity]                  VARCHAR(40),
  [ShippingState]                 VARCHAR(80),
  [ShippingPostalCode]            VARCHAR(20),
  [ShippingCountry]               VARCHAR(80),
  [ShippingStateCode]             VARCHAR(255),
  [ShippingCountryCode]           VARCHAR(255),
  [ShippingLatitude]              DECIMAL(15,15),
  [ShippingLongitude]             DECIMAL(15,15),
  [ShippingGeocodeAccuracy]       VARCHAR(255),
  [ShippingAddress]               VARCHAR(255),
  [ActivatedDate]                 DATETIME2,
  [ActivatedById]                 VARCHAR(18),
  [StatusCode]                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255) NOT NULL,
  [OrderNumber]                   VARCHAR(255) NOT NULL,
  [TotalAmount]                   DECIMAL(16,2) NOT NULL,
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
CONSTRAINT [pk_Order] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [OrderItem] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [Product2Id]                VARCHAR(18),
  [IsDeleted]                 BIT NOT NULL,
  [OrderId]                   VARCHAR(18) NOT NULL,
  [PricebookEntryId]          VARCHAR(18) NOT NULL,
  [OriginalOrderItemId]       VARCHAR(18),
  [AvailableQuantity]         DECIMAL(16,2),
  [Quantity]                  DECIMAL(16,2) NOT NULL,
  [CurrencyIsoCode]           VARCHAR(255) NOT NULL,
  [UnitPrice]                 DECIMAL(16,2),
  [ListPrice]                 DECIMAL(16,2),
  [TotalPrice]                DECIMAL(16,2),
  [ServiceDate]               DATE,
  [EndDate]                   DATE,
  [Description]               VARCHAR(255),
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [OrderItemNumber]           VARCHAR(255) NOT NULL,
CONSTRAINT [pk_OrderItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__PaymentMediaControlTest__c] ( 
  [Id]                                             VARCHAR(18) NOT NULL,
  [OwnerId]                                        VARCHAR(18) NOT NULL,
  [IsDeleted]                                      BIT NOT NULL,
  [Name]                                           VARCHAR(80),
  [CurrencyIsoCode]                                VARCHAR(255),
  [CreatedDate]                                    DATETIME2 NOT NULL,
  [CreatedById]                                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]                               DATETIME2 NOT NULL,
  [LastModifiedById]                               VARCHAR(18) NOT NULL,
  [SystemModstamp]                                 DATETIME2 NOT NULL,
  [ffbf__BankAccountNumber__c]                     VARCHAR(40),
  [ffbf__CompanyName__c]                           VARCHAR(80),
  [ffbf__CreditTotal__c]                           DECIMAL(16,2),
  [ffbf__DebitTotal__c]                            DECIMAL(16,2),
  [ffbf__DestinationBankAccountNumberSum__c]       DECIMAL(16,0),
  [ffbf__DestinationBankAccountTextSum__c]         VARCHAR(45),
  [ffbf__DestinationSortCodeNumberSum2__c]         DECIMAL(18,0),
  [ffbf__DestinationSortCodeNumberSum__c]          DECIMAL(18,0),
  [ffbf__HashTotal2__c]                            VARCHAR(1300),
  [ffbf__HashTotal3__c]                            VARCHAR(1300),
  [ffbf__HashTotalText__c]                         VARCHAR(1300),
  [ffbf__HashTotal__c]                             VARCHAR(1300),
  [ffbf__PaymentDate__c]                           DATE,
  [ffbf__PaymentType__c]                           VARCHAR(255),
  [ffbf__PaymentValue__c]                          DECIMAL(16,2),
  [ffbf__Payment__c]                               VARCHAR(18),
  [ffbf__RecordCounts__c]                          DECIMAL(5,0),
CONSTRAINT [pk_ffbf__PaymentMediaControlTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__PaymentMediaDetailTest__c] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [Name]                               VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                    VARCHAR(255),
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [ffbf__PaymentMediaSummary__c]       VARCHAR(18) NOT NULL,
  [ffbf__DocumentNumber__c]            VARCHAR(80),
  [ffbf__PaymentType__c]               VARCHAR(255),
  [ffbf__Reference__c]                 VARCHAR(1300),
  [ffbf__VendorReference__c]           VARCHAR(40),
CONSTRAINT [pk_ffbf__PaymentMediaDetailTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__PaymentMediaSummaryTest__c] ( 
  [Id]                                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                                          BIT NOT NULL,
  [Name]                                               VARCHAR(80),
  [CurrencyIsoCode]                                    VARCHAR(255),
  [CreatedDate]                                        DATETIME2 NOT NULL,
  [CreatedById]                                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                   DATETIME2 NOT NULL,
  [LastModifiedById]                                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                                     DATETIME2 NOT NULL,
  [ffbf__PaymentMediaControlTest__c]                   VARCHAR(18) NOT NULL,
  [ffbf__AccountBankAccountNumber__c]                  VARCHAR(1300),
  [ffbf__AccountBankSortCode__c]                       VARCHAR(1300),
  [ffbf__AccountBillingAddress__c]                     VARCHAR(1300),
  [ffbf__AccountBillingState__c]                       VARCHAR(1300),
  [ffbf__AccountFax__c]                                VARCHAR(1300),
  [ffbf__AccountInvoiceEmail__c]                       VARCHAR(1300),
  [ffbf__AccountName__c]                               VARCHAR(1300),
  [ffbf__AccountParticulars__c]                        VARCHAR(1300),
  [ffbf__AccountTest__c]                               VARCHAR(18),
  [ffbf__Account__c]                                   VARCHAR(18),
  [ffbf__BankAccountNumber__c]                         VARCHAR(40),
  [ffbf__BankBIC__c]                                   VARCHAR(1300),
  [ffbf__BankCity__c]                                  VARCHAR(1300),
  [ffbf__BankIBANNumber__c]                            VARCHAR(1300),
  [ffbf__BankName__c]                                  VARCHAR(1300),
  [ffbf__BankStateProvince__c]                         VARCHAR(20),
  [ffbf__BankStreet__c]                                VARCHAR(1300),
  [ffbf__BankZipPostalCode__c]                         VARCHAR(1300),
  [ffbf__BillingCity__c]                               VARCHAR(40),
  [ffbf__BillingStateProvince__c]                      VARCHAR(20),
  [ffbf__BillingStreet__c]                             TEXT,
  [ffbf__BillingZipPostCode__c]                        VARCHAR(20),
  [ffbf__DestinationBankAccountName__c]                VARCHAR(255),
  [ffbf__DestinationBankAccountNumberFormula__c]       DECIMAL(18,0),
  [ffbf__PaymentCode__c]                               VARCHAR(1300),
  [ffbf__PaymentCountryISO__c]                         VARCHAR(1300),
  [ffbf__PaymentId__c]                                 VARCHAR(1300),
  [ffbf__PaymentPriority__c]                           VARCHAR(1300),
  [ffbf__PaymentRoutingMethod__c]                      VARCHAR(1300),
  [ffbf__PaymentValue__c]                              DECIMAL(16,2),
  [ffbf__bf_Check_Digit__c]                            VARCHAR(1),
CONSTRAINT [pk_ffbf__PaymentMediaSummaryTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffbf__PaymentTest__c] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [Name]                               VARCHAR(80),
  [CurrencyIsoCode]                    VARCHAR(255),
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [ffbf__AccountCurrency__c]           VARCHAR(18),
  [ffbf__BankAccount__c]               VARCHAR(18),
  [ffbf__PaymentCurrencyName__c]       VARCHAR(1300),
CONSTRAINT [pk_ffbf__PaymentTest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__PermissionErrorLog__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [OwnerId]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [LastViewedDate]                      DATETIME2,
  [LastReferencedDate]                  DATETIME2,
  [fferpcore__LocationName__c]          VARCHAR(255),
  [fferpcore__LocationType__c]          VARCHAR(255),
  [fferpcore__NamespacePrefix__c]       VARCHAR(17),
  [fferpcore__Operation__c]             VARCHAR(255),
  [fferpcore__User__c]                  VARCHAR(18),
CONSTRAINT [pk_fferpcore__PermissionErrorLog__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__PermissionOperationData__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [fferpcore__Data__c]       TEXT,
CONSTRAINT [pk_fferpcore__PermissionOperationData__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Tigerface5__Phone_Validation__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [LastViewedDate]                          DATETIME2,
  [LastReferencedDate]                      DATETIME2,
  [Tigerface5__API_Call_Failed__c]          BIT NOT NULL,
  [Tigerface5__API_Failed_Message__c]       VARCHAR(255),
  [Tigerface5__API_Name__c]                 VARCHAR(50) NOT NULL,
  [Tigerface5__Account__c]                  VARCHAR(18),
  [Tigerface5__Carrier__c]                  VARCHAR(50),
  [Tigerface5__Contact__c]                  VARCHAR(18),
  [Tigerface5__DMA__c]                      VARCHAR(50),
  [Tigerface5__Is_Cell__c]                  VARCHAR(50),
  [Tigerface5__Last_Updated__c]             DATE,
  [Tigerface5__Lead__c]                     VARCHAR(18),
  [Tigerface5__Litigator__c]                VARCHAR(50),
  [Tigerface5__National_DNC__c]             VARCHAR(50),
  [Tigerface5__Phone_Field_Name__c]         VARCHAR(50) NOT NULL,
  [Tigerface5__Phone_Number__c]             VARCHAR(50),
  [Tigerface5__Response_Code__c]            VARCHAR(50),
  [Tigerface5__State_DNC__c]                VARCHAR(50),
  [Tigerface5__Status__c]                   VARCHAR(50),
CONSTRAINT [pk_Tigerface5__Phone_Validation__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Pricebook2] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [IsActive]                 BIT NOT NULL,
  [IsArchived]               BIT NOT NULL,
  [Description]              VARCHAR(255),
  [IsStandard]               BIT NOT NULL,
CONSTRAINT [pk_Pricebook2] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [PricebookEntry] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [Name]                   VARCHAR(255),
  [Pricebook2Id]           VARCHAR(18) NOT NULL,
  [Product2Id]             VARCHAR(18) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255) NOT NULL,
  [UnitPrice]              DECIMAL(16,2) NOT NULL,
  [IsActive]               BIT NOT NULL,
  [UseStandardPrice]       BIT NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [ProductCode]            VARCHAR(255),
  [IsDeleted]              BIT NOT NULL,
  [IsArchived]             BIT NOT NULL,
CONSTRAINT [pk_PricebookEntry] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ProcessException] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [ProcessExceptionNumber]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [LastViewedDate]               DATETIME2,
  [LastReferencedDate]           DATETIME2,
  [AttachedToId]                 VARCHAR(18) NOT NULL,
  [Message]                      VARCHAR(255) NOT NULL,
  [StatusCategory]               VARCHAR(255) NOT NULL,
  [Status]                       VARCHAR(255) NOT NULL,
  [Category]                     VARCHAR(255),
  [Severity]                     VARCHAR(255),
  [Priority]                     VARCHAR(255),
  [CaseId]                       VARCHAR(18),
  [ExternalReference]            VARCHAR(255),
  [SeverityCategory]             VARCHAR(255),
  [Description]                  TEXT,
CONSTRAINT [pk_ProcessException] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ProcessLog__c] ( 
  [Id]                                                     VARCHAR(18) NOT NULL,
  [OwnerId]                                                VARCHAR(18) NOT NULL,
  [IsDeleted]                                              BIT NOT NULL,
  [Name]                                                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                        VARCHAR(255),
  [CreatedDate]                                            DATETIME2 NOT NULL,
  [CreatedById]                                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                       DATETIME2 NOT NULL,
  [LastModifiedById]                                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                                         DATETIME2 NOT NULL,
  [fferpcore__AsyncApexJobId__c]                           VARCHAR(18),
  [fferpcore__GroupingKey__c]                              VARCHAR(255),
  [fferpcore__Message__c]                                  TEXT,
  [fferpcore__ParentProcessRun__c]                         VARCHAR(18),
  [fferpcore__ProcessRun__c]                               VARCHAR(18),
  [fferpcore__ProcessUserGroup__c]                         VARCHAR(18),
  [fferpcore__QueryLocatorResultOrderingSequence__c]       DECIMAL(10,0),
  [fferpcore__RecordId__c]                                 VARCHAR(18),
  [fferpcore__RelatedRecordId__c]                          VARCHAR(18),
  [fferpcore__RelatedRecord__c]                            VARCHAR(1300),
  [fferpcore__Status__c]                                   VARCHAR(255),
CONSTRAINT [pk_fferpcore__ProcessLog__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ProcessRun__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [LastActivityDate]                            DATE,
  [LastViewedDate]                              DATETIME2,
  [LastReferencedDate]                          DATETIME2,
  [fferpcore__AsyncApexJobId__c]                VARCHAR(18),
  [fferpcore__Description__c]                   VARCHAR(255),
  [fferpcore__FinishTime__c]                    DATETIME2,
  [fferpcore__IsParent__c]                      BIT NOT NULL,
  [fferpcore__ParentProcessRun__c]              VARCHAR(18),
  [fferpcore__StartTime__c]                     DATETIME2,
  [fferpcore__StartedBy__c]                     VARCHAR(18),
  [fferpcore__TotalNumberOfErrors__c]           DECIMAL(10,0),
  [fferpcore__TotalNumberOfPending__c]          DECIMAL(10,0),
  [fferpcore__TotalNumberOfSuccesses__c]        DECIMAL(10,0),
  [fferpcore__UsingDetailedMonitoring__c]       BIT NOT NULL,
CONSTRAINT [pk_fferpcore__ProcessRun__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ProcessTracking__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(80),
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [fferpcore__MessageData__c]                TEXT,
  [fferpcore__OutstandingResponses__c]       DECIMAL(4,0) NOT NULL,
  [fferpcore__ProcessToken__c]               VARCHAR(40) NOT NULL,
CONSTRAINT [pk_fferpcore__ProcessTracking__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ProcessUserGroup__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [OwnerId]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [LastActivityDate]                           DATE,
  [fferpcore__ProcessRun__c]                   VARCHAR(18),
  [fferpcore__TotalNumberOfErrors__c]          DECIMAL(10,0),
  [fferpcore__TotalNumberOfPending__c]         DECIMAL(10,0),
  [fferpcore__TotalNumberOfSuccesses__c]       DECIMAL(10,0),
  [fferpcore__UniqueIdentifier__c]             VARCHAR(40) NOT NULL,
  [fferpcore__User__c]                         VARCHAR(18),
CONSTRAINT [pk_fferpcore__ProcessUserGroup__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__ProcessUserGroup__cfferpcore__UniqueIdentifier__c] UNIQUE ([fferpcore__UniqueIdentifier__c])
) 
;

CREATE TABLE [Product2] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [Name]                               VARCHAR(255) NOT NULL,
  [ProductCode]                        VARCHAR(255),
  [Description]                        TEXT,
  [QuantityScheduleType]               VARCHAR(255),
  [QuantityInstallmentPeriod]          VARCHAR(255),
  [NumberOfQuantityInstallments]       VARCHAR(255),
  [RevenueScheduleType]                VARCHAR(255),
  [RevenueInstallmentPeriod]           VARCHAR(255),
  [NumberOfRevenueInstallments]        VARCHAR(255),
  [IsActive]                           BIT NOT NULL,
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [Family]                             VARCHAR(255),
  [CurrencyIsoCode]                    VARCHAR(255) NOT NULL,
  [ExternalDataSourceId]               VARCHAR(18),
  [ExternalId]                         VARCHAR(255),
  [DisplayUrl]                         VARCHAR(1024),
  [QuantityUnitOfMeasure]              VARCHAR(255),
  [IsDeleted]                          BIT NOT NULL,
  [IsArchived]                         BIT NOT NULL,
  [LastViewedDate]                     DATETIME2,
  [LastReferencedDate]                 DATETIME2,
  [StockKeepingUnit]                   VARCHAR(180),
  [fferpcore__SalesTaxStatus__c]       VARCHAR(255),
  [fferpcore__TaxCode__c]              VARCHAR(18),
CONSTRAINT [pk_Product2] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ProductExtension__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [fferpcore__ExternalTaxID__c]       VARCHAR(255),
  [fferpcore__Product__c]             VARCHAR(18),
CONSTRAINT [pk_fferpcore__ProductExtension__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [PromoCode__c] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [OwnerId]                   VARCHAR(18) NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [Name]                      VARCHAR(80),
  [CurrencyIsoCode]           VARCHAR(255),
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [LastActivityDate]          DATE,
  [LastViewedDate]            DATETIME2,
  [LastReferencedDate]        DATETIME2,
  [Active__c]                 BIT NOT NULL,
  [DiscountType__c]           VARCHAR(255),
  [EndDate__c]                DATE,
  [NCCAvailable__c]           BIT NOT NULL,
  [PromoCodeDisplay__c]       VARCHAR(255),
  [PromoCodeSort__c]          DECIMAL(10,0),
  [StartDate__c]              DATE,
  [External_Id__c]            VARCHAR(255),
CONSTRAINT [pk_PromoCode__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_PromoCode__cExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [fferpcore__ProductProxy__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(80),
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [fferpcore__DeveloperName__c]       VARCHAR(255) NOT NULL,
CONSTRAINT [pk_fferpcore__ProductProxy__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__ProductProxy__cfferpcore__DeveloperName__c] UNIQUE ([fferpcore__DeveloperName__c])
) 
;

CREATE TABLE [fferpcore__MessagingPublication__c] ( 
  [Id]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                    BIT NOT NULL,
  [Name]                                         VARCHAR(80),
  [CurrencyIsoCode]                              VARCHAR(255),
  [CreatedDate]                                  DATETIME2 NOT NULL,
  [CreatedById]                                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]                             DATETIME2 NOT NULL,
  [LastModifiedById]                             VARCHAR(18) NOT NULL,
  [SystemModstamp]                               DATETIME2 NOT NULL,
  [fferpcore__OwnerProduct__c]                   VARCHAR(18) NOT NULL,
  [fferpcore__CorrelationField__c]               VARCHAR(255),
  [fferpcore__Custom__c]                         BIT NOT NULL,
  [fferpcore__DeclarativeFields__c]              TEXT,
  [fferpcore__Describer__c]                      VARCHAR(255),
  [fferpcore__Description__c]                    VARCHAR(255),
  [fferpcore__DocumentationURL__c]               VARCHAR(1024),
  [fferpcore__Enabled__c]                        BIT NOT NULL,
  [fferpcore__Identifier__c]                     VARCHAR(255),
  [fferpcore__LinkControlDeveloperName__c]       VARCHAR(20),
  [fferpcore__LinkControlFor__c]                 VARCHAR(18),
  [fferpcore__MessageType__c]                    VARCHAR(18) NOT NULL,
  [fferpcore__Obsolete__c]                       BIT NOT NULL,
  [fferpcore__ProductProxy__c]                   VARCHAR(18) NOT NULL,
  [fferpcore__SendingHook__c]                    VARCHAR(128),
  [fferpcore__SourceObject__c]                   VARCHAR(255),
  [fferpcore__UniquenessConstraint__c]           VARCHAR(255),
  [fferpcore__UseProcessBuilder__c]              BIT NOT NULL,
  [fferpcore__VirtualObjectProvider__c]          VARCHAR(255),
  [fferpcore__VirtualObject__c]                  VARCHAR(255),
  [fferpcore__DeclarativeNodeCount__c]           VARCHAR(30),
CONSTRAINT [pk_fferpcore__MessagingPublication__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__MessagingPublication__cfferpcore__LinkControlDeveloperName__c] UNIQUE ([fferpcore__LinkControlDeveloperName__c]),
CONSTRAINT [uk_fferpcore__MessagingPublication__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [QuickText] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Message]                  TEXT NOT NULL,
  [Category]                 VARCHAR(255),
  [Channel]                  VARCHAR(1000),
  [FolderId]                 VARCHAR(18),
  [FolderName]               VARCHAR(256),
  [IsInsertable]             BIT NOT NULL,
  [SourceType]               VARCHAR(255),
CONSTRAINT [pk_QuickText] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Quote] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [OpportunityId]                   VARCHAR(18) NOT NULL,
  [Pricebook2Id]                    VARCHAR(18),
  [ContactId]                       VARCHAR(18),
  [QuoteNumber]                     VARCHAR(255) NOT NULL,
  [IsSyncing]                       BIT NOT NULL,
  [ShippingHandling]                DECIMAL(16,2),
  [Tax]                             DECIMAL(16,2),
  [Status]                          VARCHAR(255),
  [ExpirationDate]                  DATE,
  [Description]                     TEXT,
  [Subtotal]                        VARCHAR(30),
  [TotalPrice]                      VARCHAR(30),
  [LineItemCount]                   VARCHAR(30),
  [BillingStreet]                   VARCHAR(255),
  [BillingCity]                     VARCHAR(40),
  [BillingState]                    VARCHAR(80),
  [BillingPostalCode]               VARCHAR(20),
  [BillingCountry]                  VARCHAR(80),
  [BillingStateCode]                VARCHAR(255),
  [BillingCountryCode]              VARCHAR(255),
  [BillingLatitude]                 DECIMAL(15,15),
  [BillingLongitude]                DECIMAL(15,15),
  [BillingGeocodeAccuracy]          VARCHAR(255),
  [BillingAddress]                  VARCHAR(255),
  [ShippingStreet]                  VARCHAR(255),
  [ShippingCity]                    VARCHAR(40),
  [ShippingState]                   VARCHAR(80),
  [ShippingPostalCode]              VARCHAR(20),
  [ShippingCountry]                 VARCHAR(80),
  [ShippingStateCode]               VARCHAR(255),
  [ShippingCountryCode]             VARCHAR(255),
  [ShippingLatitude]                DECIMAL(15,15),
  [ShippingLongitude]               DECIMAL(15,15),
  [ShippingGeocodeAccuracy]         VARCHAR(255),
  [ShippingAddress]                 VARCHAR(255),
  [QuoteToStreet]                   VARCHAR(255),
  [QuoteToCity]                     VARCHAR(40),
  [QuoteToState]                    VARCHAR(80),
  [QuoteToPostalCode]               VARCHAR(20),
  [QuoteToCountry]                  VARCHAR(80),
  [QuoteToStateCode]                VARCHAR(255),
  [QuoteToCountryCode]              VARCHAR(255),
  [QuoteToLatitude]                 DECIMAL(15,15),
  [QuoteToLongitude]                DECIMAL(15,15),
  [QuoteToGeocodeAccuracy]          VARCHAR(255),
  [QuoteToAddress]                  VARCHAR(255),
  [AdditionalStreet]                VARCHAR(255),
  [AdditionalCity]                  VARCHAR(40),
  [AdditionalState]                 VARCHAR(80),
  [AdditionalPostalCode]            VARCHAR(20),
  [AdditionalCountry]               VARCHAR(80),
  [AdditionalStateCode]             VARCHAR(255),
  [AdditionalCountryCode]           VARCHAR(255),
  [AdditionalLatitude]              DECIMAL(15,15),
  [AdditionalLongitude]             DECIMAL(15,15),
  [AdditionalGeocodeAccuracy]       VARCHAR(255),
  [AdditionalAddress]               VARCHAR(255),
  [BillingName]                     VARCHAR(255),
  [ShippingName]                    VARCHAR(255),
  [QuoteToName]                     VARCHAR(255),
  [AdditionalName]                  VARCHAR(255),
  [Email]                           VARCHAR(128),
  [Phone]                           VARCHAR(40),
  [Fax]                             VARCHAR(40),
  [ContractId]                      VARCHAR(18),
  [AccountId]                       VARCHAR(18),
  [Discount]                        DECIMAL(3,2),
  [GrandTotal]                      DECIMAL(16,2),
  [CanCreateQuoteLineItems]         BIT NOT NULL,
CONSTRAINT [pk_Quote] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [QuoteLineItem] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [LineNumber]                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255) NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [QuoteId]                     VARCHAR(18) NOT NULL,
  [PricebookEntryId]            VARCHAR(18) NOT NULL,
  [OpportunityLineItemId]       VARCHAR(18),
  [Quantity]                    DECIMAL(10,2) NOT NULL,
  [UnitPrice]                   DECIMAL(16,2) NOT NULL,
  [Discount]                    DECIMAL(3,2),
  [HasRevenueSchedule]          BIT NOT NULL,
  [HasQuantitySchedule]         BIT NOT NULL,
  [Description]                 VARCHAR(255),
  [ServiceDate]                 DATE,
  [Product2Id]                  VARCHAR(18) NOT NULL,
  [SortOrder]                   VARCHAR(255),
  [HasSchedule]                 BIT NOT NULL,
  [ListPrice]                   DECIMAL(16,2),
  [Subtotal]                    DECIMAL(16,2),
  [TotalPrice]                  DECIMAL(16,2),
CONSTRAINT [pk_QuoteLineItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Rebuttal__c] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [Name]                        VARCHAR(80),
  [CurrencyIsoCode]             VARCHAR(255),
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastActivityDate]            DATE,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [Active__c]                   BIT NOT NULL,
  [Description__c]              VARCHAR(100),
  [English__c]                  BIT NOT NULL,
  [External_ID__c]              VARCHAR(255),
  [Female__c]                   BIT NOT NULL,
  [French__c]                   BIT NOT NULL,
  [Is_My_Rebuttal__c]           BIT NOT NULL,
  [Keywords__c]                 VARCHAR(255),
  [Male__c]                     BIT NOT NULL,
  [NotAvailableGender__c]       BIT NOT NULL,
  [Priority__c]                 DECIMAL(3,0),
  [Spanish__c]                  BIT NOT NULL,
  [Text__c]                     TEXT,
  [User__c]                     VARCHAR(18),
CONSTRAINT [pk_Rebuttal__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_Rebuttal__cExternal_ID__c] UNIQUE ([External_ID__c])
) 
;

CREATE TABLE [Recommendation] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [Name]                      VARCHAR(80) NOT NULL,
  [CurrencyIsoCode]           VARCHAR(255),
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [LastViewedDate]            DATETIME2,
  [LastReferencedDate]        DATETIME2,
  [ActionReference]           VARCHAR(255) NOT NULL,
  [Description]               VARCHAR(255) NOT NULL,
  [NetworkId]                 VARCHAR(18),
  [ImageId]                   VARCHAR(18),
  [AcceptanceLabel]           VARCHAR(80) NOT NULL,
  [RejectionLabel]            VARCHAR(80) NOT NULL,
  [IsActionActive]            BIT NOT NULL,
  [ExternalId]                VARCHAR(255),
  [RecommendationMode]        VARCHAR(255),
  [RecommendationScore]       DECIMAL(3,2),
CONSTRAINT [pk_Recommendation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ERPProduct__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(80),
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [fferpcore__Custom__c]              BIT NOT NULL,
  [fferpcore__DeveloperName__c]       VARCHAR(30) NOT NULL,
  [fferpcore__Obsolete__c]            BIT NOT NULL,
  [fferpcore__ServicePack__c]         DECIMAL(18,0) NOT NULL,
  [fferpcore__VersionMajor__c]        DECIMAL(18,0) NOT NULL,
  [fferpcore__VersionMinor__c]        DECIMAL(4,0) NOT NULL,
CONSTRAINT [pk_fferpcore__ERPProduct__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__ERPProduct__cfferpcore__DeveloperName__c] UNIQUE ([fferpcore__DeveloperName__c])
) 
;

CREATE TABLE [ff_frb__Report__c] ( 
  [Id]                                   VARCHAR(18) NOT NULL,
  [OwnerId]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                            BIT NOT NULL,
  [Name]                                 VARCHAR(80),
  [CurrencyIsoCode]                      VARCHAR(255),
  [CreatedDate]                          DATETIME2 NOT NULL,
  [CreatedById]                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                     DATETIME2 NOT NULL,
  [LastModifiedById]                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                       DATETIME2 NOT NULL,
  [ff_frb__FilterConfiguration__c]       VARCHAR(255),
  [ff_frb__TableConfiguration__c]        VARCHAR(255) NOT NULL,
CONSTRAINT [pk_ff_frb__Report__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ff_frb__Reporting_Component_Configuration__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(80),
  [CurrencyIsoCode]          VARCHAR(255),
  [RecordTypeId]             VARCHAR(18),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ff_frb__Json__c]          TEXT,
CONSTRAINT [pk_ff_frb__Reporting_Component_Configuration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ResourceAbsence] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [AbsenceNumber]            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ResourceId]               VARCHAR(18) NOT NULL,
  [Type]                     VARCHAR(255) NOT NULL,
  [Description]              TEXT,
  [Start]                    DATETIME2 NOT NULL,
  [End]                      DATETIME2 NOT NULL,
  [Street]                   VARCHAR(255),
  [City]                     VARCHAR(40),
  [State]                    VARCHAR(80),
  [PostalCode]               VARCHAR(20),
  [Country]                  VARCHAR(80),
  [StateCode]                VARCHAR(255),
  [CountryCode]              VARCHAR(255),
  [Latitude]                 DECIMAL(15,15),
  [Longitude]                DECIMAL(15,15),
  [GeocodeAccuracy]          VARCHAR(255),
  [Address]                  VARCHAR(255),
  [External_Id__c]           VARCHAR(255),
  [Time_Zone__c]             VARCHAR(255) NOT NULL,
CONSTRAINT [pk_ResourceAbsence] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ResourceAbsenceExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ResourcePreference] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [ResourcePreferenceNumber]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [LastViewedDate]                 DATETIME2,
  [LastReferencedDate]             DATETIME2,
  [ServiceResourceId]              VARCHAR(18) NOT NULL,
  [RelatedRecordId]                VARCHAR(18) NOT NULL,
  [PreferenceType]                 VARCHAR(255) NOT NULL,
CONSTRAINT [pk_ResourcePreference] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__PS_Export_Rollups__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [LastActivityDate]                 DATE,
  [rh2__RollupOrFilterData__c]       TEXT,
  [rh2__filterJobRollupKey__c]       VARCHAR(80),
  [rh2__type__c]                     VARCHAR(40) NOT NULL,
CONSTRAINT [pk_rh2__PS_Export_Rollups__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__PS_Rollup_Group__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [rh2__Rollup_Group_Label__c]       VARCHAR(255),
CONSTRAINT [pk_rh2__PS_Rollup_Group__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_rh2__PS_Rollup_Group__crh2__Rollup_Group_Label__c] UNIQUE ([rh2__Rollup_Group_Label__c])
) 
;

CREATE TABLE [rh2__PS_Exception__c] ( 
  [Id]                                             VARCHAR(18) NOT NULL,
  [OwnerId]                                        VARCHAR(18) NOT NULL,
  [IsDeleted]                                      BIT NOT NULL,
  [Name]                                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                VARCHAR(255),
  [CreatedDate]                                    DATETIME2 NOT NULL,
  [CreatedById]                                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]                               DATETIME2 NOT NULL,
  [LastModifiedById]                               VARCHAR(18) NOT NULL,
  [SystemModstamp]                                 DATETIME2 NOT NULL,
  [rh2__DML_Exception_Message__c]                  TEXT,
  [rh2__DML_Failed_Record_Ids__c]                  TEXT,
  [rh2__DML_Failed_Records_Count__c]               DECIMAL(18,0),
  [rh2__DML_Problem_Field_Names__c]                TEXT,
  [rh2__DML_Status_Code__c]                        VARCHAR(255),
  [rh2__Exception_Stack_Trace__c]                  TEXT,
  [rh2__Exception_Type__c]                         VARCHAR(255),
  [rh2__Formatted_Date__c]                         VARCHAR(255),
  [rh2__Line_Number__c]                            DECIMAL(10,0),
  [rh2__Number_of_Occurrences__c]                  DECIMAL(18,0),
  [rh2__Object__c]                                 VARCHAR(255),
  [rh2__Potential_Affected_Target_Fields__c]       TEXT,
  [rh2__Record_Id__c]                              VARCHAR(18),
  [rh2__Record_Link__c]                            VARCHAR(1300),
  [rh2__Rollup_Link__c]                            VARCHAR(1300),
  [rh2__Rollup_Name__c]                            VARCHAR(255),
CONSTRAINT [pk_rh2__PS_Exception__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [rh2__RH_Job__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [OwnerId]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [rh2__Active__c]                 BIT NOT NULL,
  [rh2__ApexClassName__c]          VARCHAR(100) NOT NULL,
  [rh2__BatchSize__c]              DECIMAL(18,0),
  [rh2__Filter__c]                 VARCHAR(255),
  [rh2__Increment__c]              DECIMAL(3,0),
  [rh2__NextFireTime__c]           DATETIME2,
  [rh2__ParentFilter__c]           VARCHAR(255),
  [rh2__PreviousFireTime__c]       DATETIME2,
  [rh2__Rollup_Name__c]            VARCHAR(255),
  [rh2__Rollup_Status__c]          VARCHAR(10),
  [rh2__RunForAllRecords__c]       BIT NOT NULL,
  [rh2__Schedule_Name__c]          VARCHAR(150),
  [rh2__Unit__c]                   VARCHAR(255),
CONSTRAINT [pk_rh2__RH_Job__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_rh2__RH_Job__crh2__Filter__c] UNIQUE ([rh2__Filter__c]),
CONSTRAINT [uk_rh2__RH_Job__crh2__Rollup_Name__c] UNIQUE ([rh2__Rollup_Name__c])
) 
;

CREATE TABLE [rh2__PS_Queue__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [rh2__Batch_Class__c]              VARCHAR(50),
  [rh2__Filter__c]                   VARCHAR(255),
  [rh2__Max_Record_Scope__c]         DECIMAL(4,0),
  [rh2__Notification_Email__c]       VARCHAR(255),
  [rh2__Params__c]                   TEXT,
  [rh2__ParentFilter__c]             VARCHAR(255),
  [rh2__Prevent_Merge__c]            BIT NOT NULL,
  [rh2__Priority__c]                 DECIMAL(2,0) NOT NULL,
  [rh2__Query__c]                    TEXT,
  [rh2__Source_Object__c]            VARCHAR(50),
  [rh2__Status__c]                   VARCHAR(10) NOT NULL,
  [rh2__Step_Class__c]               VARCHAR(50) NOT NULL,
  [rh2__Step_JSON__c]                TEXT,
CONSTRAINT [pk_rh2__PS_Queue__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_rh2__PS_Queue__crh2__Filter__c] UNIQUE ([rh2__Filter__c])
) 
;

CREATE TABLE [APXT_BPM__Scheduled_Conductor_History__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [OwnerId]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(80),
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [APXT_BPM__Conga_Conductor__c]                VARCHAR(18),
  [APXT_BPM__Dashboard_Link__c]                 VARCHAR(1024),
  [APXT_BPM__Date__c]                           DATETIME2,
  [APXT_BPM__Description__c]                    VARCHAR(255),
  [APXT_BPM__Number_of_Failures__c]             DECIMAL(18,0),
  [APXT_BPM__Number_of_Service_Events__c]       DECIMAL(18,0),
  [APXT_BPM__Number_of_Successes__c]            DECIMAL(18,0),
  [APXT_BPM__Output_File_Link__c]               VARCHAR(1024),
  [APXT_BPM__Ran_as__c]                         VARCHAR(18),
  [APXT_BPM__Total_Number_of_Records__c]        DECIMAL(18,0),
CONSTRAINT [pk_APXT_BPM__Scheduled_Conductor_History__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ScheduledJob__c] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [Name]                               VARCHAR(80),
  [CurrencyIsoCode]                    VARCHAR(255),
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [LastViewedDate]                     DATETIME2,
  [LastReferencedDate]                 DATETIME2,
  [fferpcore__CronExpression__c]       VARCHAR(100),
  [fferpcore__DeveloperName__c]        VARCHAR(255) NOT NULL,
  [fferpcore__Implementation__c]       VARCHAR(255) NOT NULL,
  [fferpcore__NotSchedulable__c]       BIT NOT NULL,
  [fferpcore__Schedulable__c]          BIT NOT NULL,
CONSTRAINT [pk_fferpcore__ScheduledJob__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__ScheduledJob__cfferpcore__DeveloperName__c] UNIQUE ([fferpcore__DeveloperName__c]),
CONSTRAINT [uk_fferpcore__ScheduledJob__cfferpcore__Implementation__c] UNIQUE ([fferpcore__Implementation__c])
) 
;

CREATE TABLE [fferpcore__ScheduledJobLog__c] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [fferpcore__BatchRun__c]              VARCHAR(18) NOT NULL,
  [fferpcore__BillingDocument__c]       VARCHAR(18),
  [fferpcore__LogMessage__c]            TEXT,
  [fferpcore__LogType__c]               VARCHAR(255),
CONSTRAINT [pk_fferpcore__ScheduledJobLog__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__ScheduledJobRun__c] ( 
  [Id]                                        VARCHAR(18) NOT NULL,
  [IsDeleted]                                 BIT NOT NULL,
  [Name]                                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                           VARCHAR(255),
  [CreatedDate]                               DATETIME2 NOT NULL,
  [CreatedById]                               VARCHAR(18) NOT NULL,
  [LastModifiedDate]                          DATETIME2 NOT NULL,
  [LastModifiedById]                          VARCHAR(18) NOT NULL,
  [SystemModstamp]                            DATETIME2 NOT NULL,
  [LastViewedDate]                            DATETIME2,
  [LastReferencedDate]                        DATETIME2,
  [fferpcore__Process__c]                     VARCHAR(18) NOT NULL,
  [fferpcore__ApexJobId__c]                   VARCHAR(18),
  [fferpcore__BatchProcessStatus__c]          VARCHAR(1300),
  [fferpcore__BatchProcess__c]                VARCHAR(18),
  [fferpcore__NotificationType__c]            VARCHAR(1300),
  [fferpcore__Status__c]                      VARCHAR(255),
  [fferpcore__TotalNumberOfAborts__c]         VARCHAR(30),
  [fferpcore__TotalNumberOfErrors__c]         VARCHAR(30),
  [fferpcore__TotalNumberOfExternal__c]       VARCHAR(30),
  [fferpcore__TotalNumberOfLogs__c]           VARCHAR(30),
CONSTRAINT [pk_fferpcore__ScheduledJobRun__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__ScheduledJobRun__cfferpcore__ApexJobId__c] UNIQUE ([fferpcore__ApexJobId__c])
) 
;

CREATE TABLE [ffvat__fflib_SchedulerConfiguration__c] ( 
  [Id]                                              VARCHAR(18) NOT NULL,
  [OwnerId]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                       BIT NOT NULL,
  [Name]                                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                 VARCHAR(255),
  [CreatedDate]                                     DATETIME2 NOT NULL,
  [CreatedById]                                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                DATETIME2 NOT NULL,
  [LastModifiedById]                                VARCHAR(18) NOT NULL,
  [SystemModstamp]                                  DATETIME2 NOT NULL,
  [ffvat__EndAfterX__c]                             DECIMAL(2,0),
  [ffvat__EndDate__c]                               DATE,
  [ffvat__HourlyRecurrenceInterval__c]              DECIMAL(2,0),
  [ffvat__MonthlyFixedDate__c]                      DECIMAL(2,0),
  [ffvat__MonthlyRecurMode__c]                      VARCHAR(255),
  [ffvat__MonthlyRecurRelativeDateFlavor__c]        VARCHAR(255),
  [ffvat__MonthlyRecurRelativeDateOrdinal__c]       VARCHAR(255),
  [ffvat__NearestWeekday__c]                        BIT NOT NULL,
  [ffvat__PreferredStartTimeHour__c]                DECIMAL(2,0),
  [ffvat__PreferredStartTimeMinute__c]              DECIMAL(2,0),
  [ffvat__SchedulingFrequency__c]                   VARCHAR(255),
  [ffvat__StartDate__c]                             DATE,
  [ffvat__VisibleFields__c]                         VARCHAR(1000),
  [ffvat__WeeklyRecurOnDays__c]                     VARCHAR(1000),
CONSTRAINT [pk_ffvat__fflib_SchedulerConfiguration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffirule__fflib_SchedulerConfiguration__c] ( 
  [Id]                                                VARCHAR(18) NOT NULL,
  [OwnerId]                                           VARCHAR(18) NOT NULL,
  [IsDeleted]                                         BIT NOT NULL,
  [Name]                                              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                   VARCHAR(255),
  [CreatedDate]                                       DATETIME2 NOT NULL,
  [CreatedById]                                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                  DATETIME2 NOT NULL,
  [LastModifiedById]                                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                                    DATETIME2 NOT NULL,
  [ffirule__EndAfterX__c]                             DECIMAL(2,0),
  [ffirule__EndDate__c]                               DATE,
  [ffirule__HourlyRecurrenceInterval__c]              DECIMAL(2,0),
  [ffirule__MonthlyFixedDate__c]                      DECIMAL(2,0),
  [ffirule__MonthlyRecurMode__c]                      VARCHAR(255),
  [ffirule__MonthlyRecurRelativeDateFlavor__c]        VARCHAR(255),
  [ffirule__MonthlyRecurRelativeDateOrdinal__c]       VARCHAR(255),
  [ffirule__NearestWeekday__c]                        BIT NOT NULL,
  [ffirule__PreferredStartTimeHour__c]                DECIMAL(2,0),
  [ffirule__PreferredStartTimeMinute__c]              DECIMAL(2,0),
  [ffirule__SchedulingFrequency__c]                   VARCHAR(255),
  [ffirule__StartDate__c]                             DATE,
  [ffirule__VisibleFields__c]                         VARCHAR(1000),
  [ffirule__WeeklyRecurOnDays__c]                     VARCHAR(1000),
CONSTRAINT [pk_ffirule__fflib_SchedulerConfiguration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SCMFFA__fflib_BatchProcess__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [SCMFFA__ApexJobClassName__c]              VARCHAR(80),
  [SCMFFA__ApexJobID__c]                     VARCHAR(18),
  [SCMFFA__BatchControlRecordID__c]          VARCHAR(18),
  [SCMFFA__ConcurrencyModeUniqueID__c]       VARCHAR(80),
  [SCMFFA__CurrentChainIndex__c]             DECIMAL(3,0),
  [SCMFFA__CurrentChainNumber__c]            DECIMAL(3,0),
  [SCMFFA__FailedRecordID__c]                VARCHAR(18),
  [SCMFFA__FromProgressBar__c]               BIT NOT NULL,
  [SCMFFA__NumberofBatchesinChain__c]        DECIMAL(3,0),
  [SCMFFA__ProcessName__c]                   VARCHAR(255),
  [SCMFFA__ProgressInformation__c]           VARCHAR(255),
  [SCMFFA__StatusDetail__c]                  VARCHAR(255),
  [SCMFFA__Status__c]                        VARCHAR(255),
  [SCMFFA__SuccessfulRecordID__c]            VARCHAR(18),
  [SCMFFA__TotalChainNumber__c]              DECIMAL(3,0),
  [SCMFFA__UseDefaultConstructor__c]         BIT NOT NULL,
CONSTRAINT [pk_SCMFFA__fflib_BatchProcess__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_SCMFFA__fflib_BatchProcess__cSCMFFA__ApexJobID__c] UNIQUE ([SCMFFA__ApexJobID__c]),
CONSTRAINT [uk_SCMFFA__fflib_BatchProcess__cSCMFFA__ConcurrencyModeUniqueID__c] UNIQUE ([SCMFFA__ConcurrencyModeUniqueID__c])
) 
;

CREATE TABLE [SCMFFA__fflib_BatchProcessDetail__c] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [SCMFFA__BatchProcess__c]       VARCHAR(18) NOT NULL,
  [SCMFFA__ApexJobId__c]          VARCHAR(18),
  [SCMFFA__ChainNumber__c]        DECIMAL(3,0),
  [SCMFFA__StatusDetail__c]       VARCHAR(255),
  [SCMFFA__Status__c]             VARCHAR(255),
CONSTRAINT [pk_SCMFFA__fflib_BatchProcessDetail__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_SCMFFA__fflib_BatchProcessDetail__cSCMFFA__ApexJobId__c] UNIQUE ([SCMFFA__ApexJobId__c])
) 
;

CREATE TABLE [SCMFFA__fflib_SchedulerConfiguration__c] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [OwnerId]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [Name]                                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                  VARCHAR(255),
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [SCMFFA__EndAfterX__c]                             DECIMAL(2,0),
  [SCMFFA__EndDate__c]                               DATE,
  [SCMFFA__HourlyRecurrenceInterval__c]              DECIMAL(2,0),
  [SCMFFA__MonthlyFixedDate__c]                      DECIMAL(2,0),
  [SCMFFA__MonthlyRecurMode__c]                      VARCHAR(255),
  [SCMFFA__MonthlyRecurRelativeDateFlavor__c]        VARCHAR(255),
  [SCMFFA__MonthlyRecurRelativeDateOrdinal__c]       VARCHAR(255),
  [SCMFFA__NearestWeekday__c]                        BIT NOT NULL,
  [SCMFFA__PreferredStartTimeHour__c]                DECIMAL(2,0),
  [SCMFFA__PreferredStartTimeMinute__c]              DECIMAL(2,0),
  [SCMFFA__SchedulingFrequency__c]                   VARCHAR(255),
  [SCMFFA__StartDate__c]                             DATE,
  [SCMFFA__VisibleFields__c]                         VARCHAR(1000),
  [SCMFFA__WeeklyRecurOnDays__c]                     VARCHAR(1000),
CONSTRAINT [pk_SCMFFA__fflib_SchedulerConfiguration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Scorecard] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Description]              VARCHAR(255),
  [TargetEntity]             VARCHAR(255) NOT NULL,
CONSTRAINT [pk_Scorecard] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ScorecardAssociation] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ScorecardId]              VARCHAR(18) NOT NULL,
  [TargetEntityId]           VARCHAR(18) NOT NULL,
CONSTRAINT [pk_ScorecardAssociation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ScorecardMetric] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [ScorecardId]            VARCHAR(18) NOT NULL,
  [Description]            VARCHAR(255),
  [Category]               VARCHAR(255),
  [ReportId]               VARCHAR(18),
CONSTRAINT [pk_ScorecardMetric] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Script__c] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(80),
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastActivityDate]              DATE,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
  [Active__c]                     BIT NOT NULL,
  [Category__c]                   VARCHAR(255),
  [Company__c]                    VARCHAR(255) NOT NULL,
  [DISC__c]                       VARCHAR(255),
  [External_ID__c]                VARCHAR(255),
  [Female__c]                     BIT NOT NULL,
  [Gender__c]                     VARCHAR(1000),
  [Language__c]                   VARCHAR(255),
  [Male__c]                       BIT NOT NULL,
  [NotAvailableGender__c]         BIT NOT NULL,
  [NotAvailableLanguage__c]       BIT NOT NULL,
  [ScriptDetails__c]              TEXT,
CONSTRAINT [pk_Script__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_Script__cExternal_ID__c] UNIQUE ([External_ID__c])
) 
;

CREATE TABLE [et4ae5__SendJunction__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [et4ae5__Campaign__c]             VARCHAR(18) NOT NULL,
  [et4ae5__SendDefinition__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_et4ae5__SendJunction__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__SequenceCounter__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [OwnerId]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(80),
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [fferpcore__Coordinate__c]       VARCHAR(255) NOT NULL,
  [fferpcore__Counter__c]          DECIMAL(18,0) NOT NULL,
CONSTRAINT [pk_fferpcore__SequenceCounter__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__SequenceCounter__cfferpcore__Coordinate__c] UNIQUE ([fferpcore__Coordinate__c])
) 
;

CREATE TABLE [ServiceAppointment] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [OwnerId]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [AppointmentNumber]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [LastViewedDate]                      DATETIME2,
  [LastReferencedDate]                  DATETIME2,
  [ParentRecordId]                      VARCHAR(18),
  [ParentRecordType]                    VARCHAR(50),
  [AccountId]                           VARCHAR(18),
  [WorkTypeId]                          VARCHAR(18),
  [ContactId]                           VARCHAR(18),
  [Street]                              VARCHAR(255),
  [City]                                VARCHAR(40),
  [State]                               VARCHAR(80),
  [PostalCode]                          VARCHAR(20),
  [Country]                             VARCHAR(80),
  [StateCode]                           VARCHAR(255),
  [CountryCode]                         VARCHAR(255),
  [Latitude]                            DECIMAL(15,15),
  [Longitude]                           DECIMAL(15,15),
  [GeocodeAccuracy]                     VARCHAR(255),
  [Address]                             VARCHAR(255) NOT NULL,
  [Description]                         TEXT,
  [EarliestStartTime]                   DATETIME2 NOT NULL,
  [DueDate]                             DATETIME2 NOT NULL,
  [Duration]                            DECIMAL(16,2),
  [ArrivalWindowStartTime]              DATETIME2,
  [ArrivalWindowEndTime]                DATETIME2,
  [Status]                              VARCHAR(255),
  [SchedStartTime]                      DATETIME2,
  [SchedEndTime]                        DATETIME2,
  [ActualStartTime]                     DATETIME2,
  [ActualEndTime]                       DATETIME2,
  [ActualDuration]                      DECIMAL(16,2),
  [DurationType]                        VARCHAR(255),
  [DurationInMinutes]                   DECIMAL(16,2),
  [ServiceTerritoryId]                  VARCHAR(18),
  [Subject]                             VARCHAR(255),
  [ParentRecordStatusCategory]          VARCHAR(255),
  [StatusCategory]                      VARCHAR(255),
  [ServiceNote]                         TEXT,
  [AppointmentType]                     VARCHAR(255),
  [Email]                               VARCHAR(128),
  [Phone]                               VARCHAR(40),
  [CancellationReason]                  VARCHAR(255),
  [AdditionalInformation]               VARCHAR(255),
  [Comments]                            VARCHAR(255),
  [IsAnonymousBooking]                  BIT NOT NULL,
  [IsOffsiteAppointment]                BIT NOT NULL,
  [ApptBookingInfoUrl]                  TEXT,
  [Confirmer_User__c]                   VARCHAR(18),
  [External_Id__c]                      VARCHAR(255),
  [Meeting_Platform_Id__c]              VARCHAR(255),
  [Meeting_Platform__c]                 VARCHAR(255),
  [Service_Appointment__c]              VARCHAR(18),
  [Work_Type_Group__c]                  VARCHAR(18),
  [Appointment_Type__c]                 VARCHAR(1300),
  [Scheduled_End_Text__c]               VARCHAR(255),
  [Scheduled_Start_Text__c]             VARCHAR(255),
  [Agent_Appointment_Link__c]           VARCHAR(1024),
  [Automatic_Trigger__c]                BIT NOT NULL,
  [Guest_Appointment_Link__c]           VARCHAR(1024),
  [Meeting_Point__c]                    BIT NOT NULL,
  [Video_Session_Mode__c]               VARCHAR(255),
  [Agent_Link__c]                       VARCHAR(1300),
  [Guest_Link__c]                       VARCHAR(1300),
  [Is_Video_Appointment__c]             BIT NOT NULL,
  [Sightcall_Appointment__c]            BIT NOT NULL,
  [Test_date__c]                        DATETIME2,
  [Are_you_sure_confirm__c]             VARCHAR(1300),
  [Appointment_Start_Date__c]           DATE,
  [Appointment_End_Date__c]             DATE,
  [Lead__c]                             VARCHAR(18),
  [Person_Account__c]                   VARCHAR(18),
  [Parent_Record_Type__c]               VARCHAR(255),
  [Scheduled_Start_Date_Value__c]       DATE,
  [Service_Territory_Number__c]         VARCHAR(4),
  [Result__c]                           VARCHAR(255),
  [Created_By_Title__c]                 VARCHAR(1300),
  [Bosley_Center_Number__c]             VARCHAR(1300),
  [Gender__c]                           VARCHAR(1300),
  [Previous_Appt_Same_Day__c]           BIT NOT NULL,
CONSTRAINT [pk_ServiceAppointment] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ServiceAppointmentExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ServiceContract] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [Name]                          VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
  [AccountId]                     VARCHAR(18),
  [ContactId]                     VARCHAR(18),
  [Term]                          VARCHAR(255),
  [StartDate]                     DATE,
  [EndDate]                       DATE,
  [ActivationDate]                DATETIME2,
  [ApprovalStatus]                VARCHAR(255),
  [Description]                   TEXT,
  [BillingStreet]                 VARCHAR(255),
  [BillingCity]                   VARCHAR(40),
  [BillingState]                  VARCHAR(80),
  [BillingPostalCode]             VARCHAR(20),
  [BillingCountry]                VARCHAR(80),
  [BillingStateCode]              VARCHAR(255),
  [BillingCountryCode]            VARCHAR(255),
  [BillingLatitude]               DECIMAL(15,15),
  [BillingLongitude]              DECIMAL(15,15),
  [BillingGeocodeAccuracy]        VARCHAR(255),
  [BillingAddress]                VARCHAR(255),
  [ShippingStreet]                VARCHAR(255),
  [ShippingCity]                  VARCHAR(40),
  [ShippingState]                 VARCHAR(80),
  [ShippingPostalCode]            VARCHAR(20),
  [ShippingCountry]               VARCHAR(80),
  [ShippingStateCode]             VARCHAR(255),
  [ShippingCountryCode]           VARCHAR(255),
  [ShippingLatitude]              DECIMAL(15,15),
  [ShippingLongitude]             DECIMAL(15,15),
  [ShippingGeocodeAccuracy]       VARCHAR(255),
  [ShippingAddress]               VARCHAR(255),
  [Pricebook2Id]                  VARCHAR(18),
  [ShippingHandling]              DECIMAL(16,2),
  [Tax]                           DECIMAL(16,2),
  [Subtotal]                      VARCHAR(30),
  [TotalPrice]                    VARCHAR(30),
  [LineItemCount]                 VARCHAR(30),
  [ContractNumber]                VARCHAR(255) NOT NULL,
  [SpecialTerms]                  TEXT,
  [Discount]                      DECIMAL(3,2),
  [GrandTotal]                    DECIMAL(16,2),
  [Status]                        VARCHAR(255),
  [ParentServiceContractId]       VARCHAR(18),
  [RootServiceContractId]         VARCHAR(18),
CONSTRAINT [pk_ServiceContract] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ServiceResource] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [RelatedRecordId]          VARCHAR(18),
  [ResourceType]             VARCHAR(255),
  [Description]              TEXT,
  [IsActive]                 BIT NOT NULL,
  [LocationId]               VARCHAR(18),
  [AccountId]                VARCHAR(18),
  [External_Id__c]           VARCHAR(255),
CONSTRAINT [pk_ServiceResource] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ServiceResourceExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ServiceResourceSkill] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [SkillNumber]              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ServiceResourceId]        VARCHAR(18) NOT NULL,
  [SkillId]                  VARCHAR(18) NOT NULL,
  [SkillLevel]               DECIMAL(2,2),
  [EffectiveStartDate]       DATETIME2 NOT NULL,
  [EffectiveEndDate]         DATETIME2,
  [External_Id__c]           VARCHAR(255),
CONSTRAINT [pk_ServiceResourceSkill] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ServiceResourceSkillExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ServiceTerritory] ( 
  [Id]                                   VARCHAR(18) NOT NULL,
  [OwnerId]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                            BIT NOT NULL,
  [Name]                                 VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                      VARCHAR(255),
  [CreatedDate]                          DATETIME2 NOT NULL,
  [CreatedById]                          VARCHAR(18) NOT NULL,
  [LastModifiedDate]                     DATETIME2 NOT NULL,
  [LastModifiedById]                     VARCHAR(18) NOT NULL,
  [SystemModstamp]                       DATETIME2 NOT NULL,
  [LastViewedDate]                       DATETIME2,
  [LastReferencedDate]                   DATETIME2,
  [ParentTerritoryId]                    VARCHAR(18),
  [TopLevelTerritoryId]                  VARCHAR(18),
  [Description]                          TEXT,
  [OperatingHoursId]                     VARCHAR(18) NOT NULL,
  [Street]                               VARCHAR(255),
  [City]                                 VARCHAR(40),
  [State]                                VARCHAR(80),
  [PostalCode]                           VARCHAR(20),
  [Country]                              VARCHAR(80),
  [StateCode]                            VARCHAR(255),
  [CountryCode]                          VARCHAR(255),
  [Latitude]                             DECIMAL(15,15),
  [Longitude]                            DECIMAL(15,15),
  [GeocodeAccuracy]                      VARCHAR(255),
  [Address]                              VARCHAR(255),
  [IsActive]                             BIT NOT NULL,
  [TypicalInTerritoryTravelTime]         DECIMAL(16,2),
  [Alternative_Phone__c]                 VARCHAR(40),
  [AreaManager__c]                       VARCHAR(100),
  [Area__c]                              VARCHAR(255),
  [AssistantManager__c]                  VARCHAR(100),
  [BackLinePhone__c]                     VARCHAR(40),
  [BestTressedOffered__c]                BIT NOT NULL,
  [Caller_Id__c]                         VARCHAR(40),
  [CenterAlert__c]                       VARCHAR(255),
  [CenterNumber__c]                      VARCHAR(3),
  [CenterOwner__c]                       VARCHAR(80),
  [CenterType__c]                        VARCHAR(255),
  [CompanyID__c]                         VARCHAR(255),
  [Company__c]                           VARCHAR(255),
  [ConfirmationCallerIDEnglish__c]       VARCHAR(30),
  [ConfirmationCallerIDFrench__c]        VARCHAR(30),
  [ConfirmationCallerIDSpanish__c]       VARCHAR(30),
  [CustomerServiceLine__c]               VARCHAR(40),
  [DisplayName__c]                       VARCHAR(255),
  [External_Id__c]                       VARCHAR(20),
  [ImageConsultant__c]                   VARCHAR(100),
  [MDPOffered__c]                        BIT NOT NULL,
  [MDPPerformed__c]                      BIT NOT NULL,
  [Main_Phone__c]                        VARCHAR(40),
  [ManagerName__c]                       VARCHAR(100),
  [Map_Short_Link__c]                    VARCHAR(40),
  [MgrCellPhone__c]                      VARCHAR(40),
  [OfferPRP__c]                          BIT NOT NULL,
  [OtherCallerIDEnglish__c]              VARCHAR(30),
  [OtherCallerIDFrench__c]               VARCHAR(30),
  [OtherCallerIDSpanish__c]              VARCHAR(30),
  [OutboundDialingAllowed__c]            BIT NOT NULL,
  [ProfileCode__c]                       VARCHAR(255),
  [Region__c]                            VARCHAR(255),
  [Status__c]                            VARCHAR(255),
  [Supported_Appointment_Types__c]       VARCHAR(1000) NOT NULL,
  [SurgeryOffered__c]                    BIT NOT NULL,
  [TimeZone__c]                          VARCHAR(255),
  [Type__c]                              VARCHAR(255),
  [WebPhone__c]                          VARCHAR(40),
  [Web_Phone__c]                         VARCHAR(40),
  [X1Apptperslot__c]                     BIT NOT NULL,
  [English_Directions__c]                TEXT,
  [French_Directions__c]                 TEXT,
  [Spanish_Directions__c]                TEXT,
  [Virtual__c]                           BIT NOT NULL,
  [English_Cross_Streets__c]             VARCHAR(255),
  [French_Cross_Streets__c]              VARCHAR(255),
  [Spanish_Cross_Streets__c]             VARCHAR(255),
  [Business_Hours__c]                    VARCHAR(18),
CONSTRAINT [pk_ServiceTerritory] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ServiceTerritoryMember] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [MemberNumber]             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ServiceTerritoryId]       VARCHAR(18) NOT NULL,
  [ServiceResourceId]        VARCHAR(18) NOT NULL,
  [TerritoryType]            VARCHAR(255),
  [EffectiveStartDate]       DATETIME2 NOT NULL,
  [EffectiveEndDate]         DATETIME2,
  [Street]                   VARCHAR(255),
  [City]                     VARCHAR(40),
  [State]                    VARCHAR(80),
  [PostalCode]               VARCHAR(20),
  [Country]                  VARCHAR(80),
  [StateCode]                VARCHAR(255),
  [CountryCode]              VARCHAR(255),
  [Latitude]                 DECIMAL(15,15),
  [Longitude]                DECIMAL(15,15),
  [GeocodeAccuracy]          VARCHAR(255),
  [Address]                  VARCHAR(255),
  [OperatingHoursId]         VARCHAR(18),
  [Role]                     VARCHAR(255),
CONSTRAINT [pk_ServiceTerritoryMember] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ServiceTerritoryWorkType] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [LastViewedDate]                      DATETIME2,
  [LastReferencedDate]                  DATETIME2,
  [WorkTypeId]                          VARCHAR(18) NOT NULL,
  [ServiceTerritoryId]                  VARCHAR(18) NOT NULL,
  [External_Id__c]                      VARCHAR(255),
  [Work_Type_Appointment_Type__c]       VARCHAR(1300),
CONSTRAINT [pk_ServiceTerritoryWorkType] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ServiceTerritoryWorkTypeExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ServiceTerritory_ZipCode__c] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [LastViewedDate]             DATETIME2,
  [LastReferencedDate]         DATETIME2,
  [Zip_Code_Center__c]         VARCHAR(18) NOT NULL,
  [External_Id__c]             VARCHAR(255),
  [Service_Territory__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_ServiceTerritory_ZipCode__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_ServiceTerritory_ZipCode__cExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [Shift] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [ShiftNumber]              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [Label]                    VARCHAR(255),
  [StartTime]                DATETIME2 NOT NULL,
  [EndTime]                  DATETIME2 NOT NULL,
  [ServiceResourceId]        VARCHAR(18),
  [ServiceTerritoryId]       VARCHAR(18),
  [StatusCategory]           VARCHAR(255),
  [Status]                   VARCHAR(255) NOT NULL,
  [TimeSlotType]             VARCHAR(255) NOT NULL,
CONSTRAINT [pk_Shift] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [sc_lightning__SightCall__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [OwnerId]                                VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(80),
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [sc_lightning__custom_endpoint__c]       VARCHAR(80),
  [sc_lightning__environment__c]           VARCHAR(80),
CONSTRAINT [pk_sc_lightning__SightCall__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SightCall_Appointment_Configuration__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [Mode__c]                VARCHAR(80),
  [RecordType__c]          VARCHAR(80),
  [Type__c]                VARCHAR(80),
  [Value__c]               VARCHAR(80),
CONSTRAINT [pk_SightCall_Appointment_Configuration__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [sc_lightning__SightCall_Case__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [OwnerId]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(80),
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [LastActivityDate]                      DATE,
  [sc_lightning__case_report_id__c]       VARCHAR(80),
CONSTRAINT [pk_sc_lightning__SightCall_Case__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_sc_lightning__SightCall_Case__csc_lightning__case_report_id__c] UNIQUE ([sc_lightning__case_report_id__c])
) 
;

CREATE TABLE [sc_lightning__SightCall_Request__c] ( 
  [Id]                                      VARCHAR(18) NOT NULL,
  [OwnerId]                                 VARCHAR(18) NOT NULL,
  [IsDeleted]                               BIT NOT NULL,
  [Name]                                    VARCHAR(80),
  [CurrencyIsoCode]                         VARCHAR(255),
  [CreatedDate]                             DATETIME2 NOT NULL,
  [CreatedById]                             VARCHAR(18) NOT NULL,
  [LastModifiedDate]                        DATETIME2 NOT NULL,
  [LastModifiedById]                        VARCHAR(18) NOT NULL,
  [SystemModstamp]                          DATETIME2 NOT NULL,
  [LastActivityDate]                        DATE,
  [sc_lightning__Status__c]                 VARCHAR(80),
  [sc_lightning__payload__c]                TEXT,
  [sc_lightning__reference_object__c]       VARCHAR(50),
  [sc_lightning__use_case_hash__c]          VARCHAR(80),
CONSTRAINT [pk_sc_lightning__SightCall_Request__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [sc_lightning__SightCall_Session__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(80),
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [LastActivityDate]                       DATE,
  [sc_lightning__case__c]                  VARCHAR(18) NOT NULL,
  [sc_lightning__call_duration__c]         VARCHAR(80),
  [sc_lightning__call_end_date__c]         DATETIME2,
  [sc_lightning__call_start_date__c]       DATETIME2,
  [sc_lightning__case_duration__c]         VARCHAR(80),
  [sc_lightning__case_end_date__c]         DATETIME2,
  [sc_lightning__case_end_reason__c]       VARCHAR(80),
  [sc_lightning__case_report_id__c]        VARCHAR(80),
  [sc_lightning__case_start_date__c]       DATETIME2,
  [sc_lightning__use_case_name__c]         VARCHAR(80),
CONSTRAINT [pk_sc_lightning__SightCall_Session__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ProfileSkill] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(99) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [UserCount]                VARCHAR(30),
  [Description]              TEXT,
CONSTRAINT [pk_ProfileSkill] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SkillRequirement] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [SkillNumber]              VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [RelatedRecordId]          VARCHAR(18) NOT NULL,
  [SkillId]                  VARCHAR(18) NOT NULL,
  [SkillLevel]               DECIMAL(2,2),
CONSTRAINT [pk_SkillRequirement] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ProfileSkillUser] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [ProfileSkillId]         VARCHAR(18) NOT NULL,
  [UserId]                 VARCHAR(18),
  [EndorsementCount]       VARCHAR(30),
CONSTRAINT [pk_ProfileSkillUser] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__SMSJunction__c] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255),
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [et4ae5__Campaign__c]            VARCHAR(18) NOT NULL,
  [et4ae5__SMSDefinition__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_et4ae5__SMSJunction__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SocialPersona] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ParentId]                 VARCHAR(18) NOT NULL,
  [Provider]                 VARCHAR(255) NOT NULL,
  [ExternalId]               VARCHAR(255),
  [IsDefault]                BIT NOT NULL,
  [ExternalPictureURL]       VARCHAR(1024),
  [ProfileUrl]               VARCHAR(1024),
  [TopicType]                VARCHAR(255),
  [IsBlacklisted]            BIT NOT NULL,
  [RealName]                 VARCHAR(255),
  [IsFollowingUs]            BIT NOT NULL,
  [AreWeFollowing]           BIT NOT NULL,
  [MediaType]                VARCHAR(255),
  [Bio]                      TEXT,
  [Followers]                VARCHAR(255),
  [Following]                VARCHAR(255),
  [NumberOfFriends]          VARCHAR(255),
  [ListedCount]              VARCHAR(255),
  [MediaProvider]            VARCHAR(255),
  [ProfileType]              VARCHAR(255),
  [R6SourceId]               VARCHAR(255),
  [NumberOfTweets]           VARCHAR(255),
  [SourceApp]                VARCHAR(255),
  [AuthorLabels]             VARCHAR(255),
  [IsVerified]               BIT NOT NULL,
  [InfluencerScore]          VARCHAR(255),
  [AvatarUrl]                VARCHAR(1024),
CONSTRAINT [pk_SocialPersona] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SocialPost] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [ParentId]                        VARCHAR(18),
  [PersonaId]                       VARCHAR(18),
  [WhoId]                           VARCHAR(18),
  [ReplyToId]                       VARCHAR(18),
  [Headline]                        VARCHAR(255),
  [Content]                         TEXT,
  [Posted]                          DATETIME2 NOT NULL,
  [PostUrl]                         VARCHAR(1024),
  [Provider]                        VARCHAR(255),
  [Handle]                          VARCHAR(255),
  [SpamRating]                      VARCHAR(255),
  [MediaType]                       VARCHAR(255),
  [MediaProvider]                   VARCHAR(255),
  [Sentiment]                       VARCHAR(255),
  [PostPriority]                    VARCHAR(255),
  [Status]                          VARCHAR(255),
  [StatusMessage]                   VARCHAR(255),
  [Recipient]                       VARCHAR(255),
  [RecipientType]                   VARCHAR(255),
  [MessageType]                     VARCHAR(255),
  [R6PostId]                        VARCHAR(255),
  [R6TopicId]                       VARCHAR(255),
  [R6SourceId]                      VARCHAR(255),
  [TopicType]                       VARCHAR(255),
  [ExternalPostId]                  VARCHAR(255),
  [HarvestDate]                     DATETIME2,
  [IsOutbound]                      BIT NOT NULL,
  [PostTags]                        TEXT,
  [SourceTags]                      TEXT,
  [Classification]                  VARCHAR(255),
  [ThreadSize]                      VARCHAR(255),
  [CommentCount]                    VARCHAR(255),
  [Shares]                          VARCHAR(255),
  [ViewCount]                       VARCHAR(255),
  [InboundLinkCount]                VARCHAR(255),
  [UniqueCommentors]                VARCHAR(255),
  [LikesAndVotes]                   VARCHAR(255),
  [TopicProfileName]                VARCHAR(255),
  [KeywordGroupName]                VARCHAR(255),
  [EngagementLevel]                 VARCHAR(255),
  [AssignedTo]                      VARCHAR(255),
  [OutboundSocialAccountId]         VARCHAR(18),
  [ReviewedStatus]                  VARCHAR(255),
  [AttachmentUrl]                   VARCHAR(1024),
  [AttachmentType]                  VARCHAR(255),
  [DeletedById]                     VARCHAR(18),
  [ResponseContextExternalId]       VARCHAR(255),
  [LikedBy]                         VARCHAR(255),
  [AnalyzerScore]                   DECIMAL(15,3),
  [Language]                        VARCHAR(255),
  [ReviewScore]                     DECIMAL(16,2),
  [ReviewScale]                     DECIMAL(16,2),
  [HiddenById]                      VARCHAR(18),
  [Notes]                           TEXT,
  [TruncatedContent]                VARCHAR(255),
CONSTRAINT [pk_SocialPost] PRIMARY KEY ([Id]),
CONSTRAINT [uk_SocialPostR6PostId] UNIQUE ([R6PostId])
) 
;

CREATE TABLE [Solution] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [SolutionNumber]              VARCHAR(255) NOT NULL,
  [SolutionName]                VARCHAR(255) NOT NULL,
  [IsPublished]                 BIT NOT NULL,
  [IsPublishedInPublicKb]       BIT NOT NULL,
  [Status]                      VARCHAR(255) NOT NULL,
  [IsReviewed]                  BIT NOT NULL,
  [SolutionNote]                TEXT,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [TimesUsed]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255),
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [IsHtml]                      BIT NOT NULL,
CONSTRAINT [pk_Solution] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__MessagingSubscription__c] ( 
  [Id]                                                VARCHAR(18) NOT NULL,
  [IsDeleted]                                         BIT NOT NULL,
  [Name]                                              VARCHAR(80),
  [CurrencyIsoCode]                                   VARCHAR(255),
  [CreatedDate]                                       DATETIME2 NOT NULL,
  [CreatedById]                                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                  DATETIME2 NOT NULL,
  [LastModifiedById]                                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                                    DATETIME2 NOT NULL,
  [fferpcore__OwnerProduct__c]                        VARCHAR(18) NOT NULL,
  [fferpcore__BulkCapacity__c]                        DECIMAL(4,0) NOT NULL,
  [fferpcore__CorrelationField__c]                    VARCHAR(255),
  [fferpcore__Custom__c]                              BIT NOT NULL,
  [fferpcore__DeliverUsingBackgroundProcess__c]       VARCHAR(255) NOT NULL,
  [fferpcore__DeliveryOrder__c]                       DECIMAL(4,0),
  [fferpcore__Describer__c]                           VARCHAR(255),
  [fferpcore__Description__c]                         VARCHAR(255),
  [fferpcore__DocumentationURL__c]                    VARCHAR(1024),
  [fferpcore__Enabled__c]                             BIT NOT NULL,
  [fferpcore__ExcludeFromSelf__c]                     BIT NOT NULL,
  [fferpcore__Filters__c]                             TEXT,
  [fferpcore__HandlerData__c]                         TEXT,
  [fferpcore__Handler__c]                             VARCHAR(128) NOT NULL,
  [fferpcore__Identifier__c]                          VARCHAR(255),
  [fferpcore__LinkControlDeveloperName__c]            VARCHAR(20),
  [fferpcore__LinkControlFor__c]                      VARCHAR(18),
  [fferpcore__MessageType__c]                         VARCHAR(18) NOT NULL,
  [fferpcore__Obsolete__c]                            BIT NOT NULL,
  [fferpcore__ProductProxy__c]                        VARCHAR(18) NOT NULL,
  [fferpcore__SynchronousDeliveryCapacity__c]         DECIMAL(4,0) NOT NULL,
  [fferpcore__TargetObject__c]                        VARCHAR(255),
  [fferpcore__UniquenessConstraint__c]                VARCHAR(255),
  [fferpcore__VirtualObjectConsumer__c]               VARCHAR(255),
  [fferpcore__DeclarativeMappingCount__c]             VARCHAR(30),
CONSTRAINT [pk_fferpcore__MessagingSubscription__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__MessagingSubscription__cfferpcore__LinkControlDeveloperName__c] UNIQUE ([fferpcore__LinkControlDeveloperName__c]),
CONSTRAINT [uk_fferpcore__MessagingSubscription__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [fferpcore__SubscriptionMessageType__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [fferpcore__Subscription__c]               VARCHAR(18) NOT NULL,
  [fferpcore__MessageType__c]                VARCHAR(18) NOT NULL,
  [fferpcore__UniquenessConstraint__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__SubscriptionMessageType__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__SubscriptionMessageType__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [et4ae5__SupportRequest__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [et4ae5__Send_Definition__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_et4ae5__SupportRequest__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Survey] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255) NOT NULL,
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [TotalVersionsCount]       VARCHAR(30),
  [DeveloperName]            VARCHAR(80) NOT NULL,
  [Description]              TEXT,
  [ActiveVersionId]          VARCHAR(18),
  [SurveyType]               VARCHAR(255),
  [LatestVersionId]          VARCHAR(18),
  [NamespacePrefix]          VARCHAR(255),
CONSTRAINT [pk_Survey] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyInvitation] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [OwnerId]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [Name]                                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                  VARCHAR(255),
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [LastViewedDate]                                   DATETIME2,
  [LastReferencedDate]                               DATETIME2,
  [SurveyId]                                         VARCHAR(18) NOT NULL,
  [ParticipantId]                                    VARCHAR(18),
  [OptionsAllowParticipantAccessTheirResponse]       BIT NOT NULL,
  [OptionsCollectAnonymousResponse]                  BIT NOT NULL,
  [OptionsAllowGuestUserResponse]                    BIT NOT NULL,
  [InvitationLink]                                   VARCHAR(1024),
  [EmailBrandingId]                                  VARCHAR(18),
  [InviteExpiryDateTime]                             DATETIME2,
  [CommunityId]                                      VARCHAR(18),
  [IsDefault]                                        BIT NOT NULL,
  [UUID]                                             VARCHAR(36),
  [ResponseStatus]                                   VARCHAR(255) NOT NULL,
  [UserId]                                           VARCHAR(18),
  [LeadId]                                           VARCHAR(18),
  [ContactId]                                        VARCHAR(18),
CONSTRAINT [pk_SurveyInvitation] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyQuestion] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255) NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [SurveyVersionId]        VARCHAR(18) NOT NULL,
  [SurveyPageId]           VARCHAR(18) NOT NULL,
  [QuestionType]           VARCHAR(255) NOT NULL,
  [DeveloperName]          VARCHAR(80) NOT NULL,
  [IsDeprecated]           BIT NOT NULL,
  [QuestionName]           TEXT,
  [ValidationType]         VARCHAR(255),
  [QuestionOrder]          VARCHAR(255),
  [PageName]               VARCHAR(80),
CONSTRAINT [pk_SurveyQuestion] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyQuestionChoice] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]        VARCHAR(255) NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [QuestionId]             VARCHAR(18) NOT NULL,
  [SurveyVersionId]        VARCHAR(18),
  [DeveloperName]          VARCHAR(80) NOT NULL,
  [IsDeprecated]           BIT NOT NULL,
CONSTRAINT [pk_SurveyQuestionChoice] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyQuestionResponse] ( 
  [Id]                      VARCHAR(18) NOT NULL,
  [IsDeleted]               BIT NOT NULL,
  [ResponseShortText]       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]         VARCHAR(255) NOT NULL,
  [CreatedDate]             DATETIME2 NOT NULL,
  [CreatedById]             VARCHAR(18) NOT NULL,
  [LastModifiedDate]        DATETIME2 NOT NULL,
  [LastModifiedById]        VARCHAR(18) NOT NULL,
  [SystemModstamp]          DATETIME2 NOT NULL,
  [ResponseId]              VARCHAR(18) NOT NULL,
  [QuestionId]              VARCHAR(18),
  [QuestionChoiceId]        VARCHAR(18),
  [SurveyVersionId]         VARCHAR(18) NOT NULL,
  [InvitationId]            VARCHAR(18),
  [Datatype]                VARCHAR(255),
  [Rank]                    VARCHAR(255),
  [DateValue]               DATE,
  [DateTimeValue]           DATETIME2,
  [ChoiceValue]             TEXT,
  [ResponseValue]           TEXT,
  [IsTrueOrFalse]           BIT NOT NULL,
  [NumberValue]             VARCHAR(255),
CONSTRAINT [pk_SurveyQuestionResponse] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyResponse] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255) NOT NULL,
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [InvitationId]             VARCHAR(18) NOT NULL,
  [InterviewId]              VARCHAR(18),
  [InterviewGuid]            VARCHAR(255),
  [SubmitterId]              VARCHAR(18),
  [Status]                   VARCHAR(255) NOT NULL,
  [Language]                 VARCHAR(255),
  [CompletionDateTime]       DATETIME2,
  [IpAddress]                VARCHAR(39),
  [Latitude]                 DECIMAL(15,15),
  [Longitude]                DECIMAL(15,15),
  [Location]                 VARCHAR(255),
  [SurveyVersionId]          VARCHAR(18) NOT NULL,
  [SurveyId]                 VARCHAR(18) NOT NULL,
CONSTRAINT [pk_SurveyResponse] PRIMARY KEY ([Id]),
CONSTRAINT [uk_SurveyResponseInterviewGuid] UNIQUE ([InterviewGuid])
) 
;

CREATE TABLE [SurveySubject] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [ParentId]                 VARCHAR(18) NOT NULL,
  [SubjectId]                VARCHAR(18) NOT NULL,
  [SurveyId]                 VARCHAR(18) NOT NULL,
  [SubjectEntityType]        VARCHAR(255),
  [SurveyResponseId]         VARCHAR(18),
  [SurveyInvitationId]       VARCHAR(18),
CONSTRAINT [pk_SurveySubject] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [SurveyVersion] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255) NOT NULL,
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [SurveyId]                 VARCHAR(18) NOT NULL,
  [VersionNumber]            VARCHAR(255) NOT NULL,
  [SurveyStatus]             VARCHAR(255),
  [BrandingSetId]            VARCHAR(18),
  [Description]              TEXT,
  [IsTemplate]               BIT NOT NULL,
CONSTRAINT [pk_SurveyVersion] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Task] ( 
  [Id]                                                 VARCHAR(18) NOT NULL,
  [RecordTypeId]                                       VARCHAR(18),
  [WhoId]                                              VARCHAR(18),
  [WhatId]                                             VARCHAR(18),
  [WhoCount]                                           VARCHAR(255),
  [WhatCount]                                          VARCHAR(255),
  [Subject]                                            VARCHAR(255),
  [ActivityDate]                                       DATE,
  [Status]                                             VARCHAR(255) NOT NULL,
  [Priority]                                           VARCHAR(255) NOT NULL,
  [IsHighPriority]                                     BIT NOT NULL,
  [OwnerId]                                            VARCHAR(18) NOT NULL,
  [Description]                                        TEXT,
  [CurrencyIsoCode]                                    VARCHAR(255),
  [Type]                                               VARCHAR(255),
  [IsDeleted]                                          BIT NOT NULL,
  [AccountId]                                          VARCHAR(18),
  [IsClosed]                                           BIT NOT NULL,
  [CreatedDate]                                        DATETIME2 NOT NULL,
  [CreatedById]                                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                   DATETIME2 NOT NULL,
  [LastModifiedById]                                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                                     DATETIME2 NOT NULL,
  [IsArchived]                                         BIT NOT NULL,
  [CallDurationInSeconds]                              VARCHAR(255),
  [CallType]                                           VARCHAR(255),
  [CallDisposition]                                    VARCHAR(255),
  [CallObject]                                         VARCHAR(255),
  [ReminderDateTime]                                   DATETIME2,
  [IsReminderSet]                                      BIT NOT NULL,
  [RecurrenceActivityId]                               VARCHAR(18),
  [IsRecurrence]                                       BIT NOT NULL,
  [RecurrenceStartDateOnly]                            DATE,
  [RecurrenceEndDateOnly]                              DATE,
  [RecurrenceTimeZoneSidKey]                           VARCHAR(255),
  [RecurrenceType]                                     VARCHAR(255),
  [RecurrenceInterval]                                 VARCHAR(255),
  [RecurrenceDayOfWeekMask]                            VARCHAR(255),
  [RecurrenceDayOfMonth]                               VARCHAR(255),
  [RecurrenceInstance]                                 VARCHAR(255),
  [RecurrenceMonthOfYear]                              VARCHAR(255),
  [RecurrenceRegeneratedType]                          VARCHAR(255),
  [TaskSubtype]                                        VARCHAR(255),
  [CompletedDateTime]                                  DATETIME2,
  [BrightPattern__SPRecordingOrTranscriptURL__c]       VARCHAR(1024),
  [Center_Name__c]                                     VARCHAR(1300),
  [Completed_Date__c]                                  DATE,
  [External_ID__c]                                     VARCHAR(255),
  [Lead__c]                                            VARCHAR(18),
  [Meeting_Platform_Id__c]                             VARCHAR(1300),
  [Meeting_Platform__c]                                VARCHAR(1300),
  [Person_Account__c]                                  VARCHAR(18),
  [Recording_Link__c]                                  VARCHAR(1300),
  [Result__c]                                          VARCHAR(255),
  [SPRecordingOrTranscriptURL__c]                      VARCHAR(255),
  [Service_Appointment__c]                             VARCHAR(18),
  [Service_Territory_Caller_Id__c]                     VARCHAR(40),
  [Agent_Link__c]                                      VARCHAR(1300),
  [Guest_Link__c]                                      VARCHAR(1300),
  [Opportunity__c]                                     VARCHAR(18),
  [Center_Phone__c]                                    VARCHAR(1300),
  [DB_Activity_Type__c]                                VARCHAR(1300),
  [CallBackDueDate__c]                                 DATE,
  [Invite__c]                                          VARCHAR(1300),
CONSTRAINT [pk_Task] PRIMARY KEY ([Id]),
CONSTRAINT [uk_TaskExternal_ID__c] UNIQUE ([External_ID__c])
) 
;

CREATE TABLE [fferpcore__TaxDetail__c] ( 
  [Id]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                   BIT NOT NULL,
  [Name]                                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                             VARCHAR(255),
  [CreatedDate]                                 DATETIME2 NOT NULL,
  [CreatedById]                                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]                            DATETIME2 NOT NULL,
  [LastModifiedById]                            VARCHAR(18) NOT NULL,
  [SystemModstamp]                              DATETIME2 NOT NULL,
  [fferpcore__BillingDocumentLineItem__c]       VARCHAR(18) NOT NULL,
  [fferpcore__BillingDocument__c]               VARCHAR(18),
  [fferpcore__Country__c]                       VARCHAR(3),
  [fferpcore__JurisdictionCode__c]              VARCHAR(10),
  [fferpcore__JurisdictionName__c]              VARCHAR(255),
  [fferpcore__JurisdictionType__c]              VARCHAR(255),
  [fferpcore__Rate__c]                          DECIMAL(6,6),
  [fferpcore__Region__c]                        VARCHAR(10),
  [fferpcore__TaxName__c]                       VARCHAR(255),
  [fferpcore__Tax__c]                           DECIMAL(9,9),
  [fferpcore__Taxable__c]                       DECIMAL(9,9),
CONSTRAINT [pk_fferpcore__TaxDetail__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__TaxCode__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(80),
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [fferpcore__Description__c]       VARCHAR(80),
CONSTRAINT [pk_fferpcore__TaxCode__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__TaxRate__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [fferpcore__TaxCode__c]                    VARCHAR(18) NOT NULL,
  [fferpcore__Rate__c]                       DECIMAL(5,5) NOT NULL,
  [fferpcore__StartDate__c]                  DATE NOT NULL,
  [fferpcore__UniquenessConstraint__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__TaxRate__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Territory2] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [Name]                         VARCHAR(80) NOT NULL,
  [Territory2TypeId]             VARCHAR(18) NOT NULL,
  [Territory2ModelId]            VARCHAR(18) NOT NULL,
  [ParentTerritory2Id]           VARCHAR(18),
  [Description]                  VARCHAR(1000),
  [ForecastUserId]               VARCHAR(18),
  [AccountAccessLevel]           VARCHAR(255) NOT NULL,
  [OpportunityAccessLevel]       VARCHAR(255) NOT NULL,
  [CaseAccessLevel]              VARCHAR(255) NOT NULL,
  [ContactAccessLevel]           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]              VARCHAR(255) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [DeveloperName]                VARCHAR(80) NOT NULL,
CONSTRAINT [pk_Territory2] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Territory2Model] ( 
  [Id]                             VARCHAR(18) NOT NULL,
  [IsDeleted]                      BIT NOT NULL,
  [Name]                           VARCHAR(80) NOT NULL,
  [CurrencyIsoCode]                VARCHAR(255) NOT NULL,
  [CreatedDate]                    DATETIME2 NOT NULL,
  [CreatedById]                    VARCHAR(18) NOT NULL,
  [LastModifiedDate]               DATETIME2 NOT NULL,
  [LastModifiedById]               VARCHAR(18) NOT NULL,
  [SystemModstamp]                 DATETIME2 NOT NULL,
  [Description]                    VARCHAR(255),
  [ActivatedDate]                  DATETIME2,
  [DeactivatedDate]                DATETIME2,
  [State]                          VARCHAR(255) NOT NULL,
  [DeveloperName]                  VARCHAR(80) NOT NULL,
  [LastRunRulesEndDate]            DATETIME2,
  [IsCloneSource]                  BIT NOT NULL,
  [LastOppTerrAssignEndDate]       DATETIME2,
  [IsSharingGroupDeleteDone]       BIT NOT NULL,
  [IsOppUnassignmentDone]          BIT NOT NULL,
CONSTRAINT [pk_Territory2Model] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__TestPublication__c] ( 
  [Id]                                VARCHAR(18) NOT NULL,
  [OwnerId]                           VARCHAR(18) NOT NULL,
  [IsDeleted]                         BIT NOT NULL,
  [Name]                              VARCHAR(80),
  [CurrencyIsoCode]                   VARCHAR(255),
  [CreatedDate]                       DATETIME2 NOT NULL,
  [CreatedById]                       VARCHAR(18) NOT NULL,
  [LastModifiedDate]                  DATETIME2 NOT NULL,
  [LastModifiedById]                  VARCHAR(18) NOT NULL,
  [SystemModstamp]                    DATETIME2 NOT NULL,
  [LastViewedDate]                    DATETIME2,
  [LastReferencedDate]                DATETIME2,
  [fferpcore__CorrelationId__c]       VARCHAR(255),
  [fferpcore__MessageBody__c]         TEXT,
  [fferpcore__MessageType__c]         VARCHAR(18) NOT NULL,
  [fferpcore__Publisher__c]           VARCHAR(18),
CONSTRAINT [pk_fferpcore__TestPublication__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__TestSubscription__c] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(80),
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [LastViewedDate]                   DATETIME2,
  [LastReferencedDate]               DATETIME2,
  [fferpcore__MessageType__c]        VARCHAR(18) NOT NULL,
  [fferpcore__ResponseType__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__TestSubscription__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Tigerface5__Test_Table_Custom_Object__c] ( 
  [Id]                                              VARCHAR(18) NOT NULL,
  [OwnerId]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                       BIT NOT NULL,
  [Name]                                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                                 VARCHAR(255),
  [RecordTypeId]                                    VARCHAR(18),
  [CreatedDate]                                     DATETIME2 NOT NULL,
  [CreatedById]                                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                DATETIME2 NOT NULL,
  [LastModifiedById]                                VARCHAR(18) NOT NULL,
  [SystemModstamp]                                  DATETIME2 NOT NULL,
  [LastViewedDate]                                  DATETIME2,
  [LastReferencedDate]                              DATETIME2,
  [Tigerface5__Test_Boolean__c]                     BIT NOT NULL,
  [Tigerface5__Test_Currency__c]                    DECIMAL(16,2),
  [Tigerface5__Test_Custom_Lookup__c]               VARCHAR(18),
  [Tigerface5__Test_Date_Time__c]                   DATETIME2,
  [Tigerface5__Test_Date__c]                        DATE,
  [Tigerface5__Test_Double__c]                      DECIMAL(16,2),
  [Tigerface5__Test_Email__c]                       VARCHAR(128),
  [Tigerface5__Test_Formula_HTML__c]                VARCHAR(1300),
  [Tigerface5__Test_Formula__c]                     DATE,
  [Tigerface5__Test_Geolocation__c]                 VARCHAR(255),
  [Tigerface5__Test_Multi_Select_Picklist__c]       VARCHAR(1000),
  [Tigerface5__Test_Number__c]                      DECIMAL(18,0),
  [Tigerface5__Test_Percent_Fields__c]              DECIMAL(16,2),
  [Tigerface5__Test_Phone__c]                       VARCHAR(40),
  [Tigerface5__Test_Picklist__c]                    VARCHAR(255),
  [Tigerface5__Test_Text_Area_Encrypted__c]         VARCHAR(175),
  [Tigerface5__Test_Text_Area_Rich__c]              TEXT,
  [Tigerface5__Test_Text_Area__c]                   VARCHAR(255),
  [Tigerface5__Test_Text__c]                        VARCHAR(255),
  [Tigerface5__Test_Time__c]                        TIME,
  [Tigerface5__Test_URL__c]                         VARCHAR(1024),
  [Tigerface5__Text_Area_Long__c]                   TEXT,
  [Tigerface5__User__c]                             VARCHAR(18),
CONSTRAINT [pk_Tigerface5__Test_Table_Custom_Object__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [TimeSlot] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [TimeSlotNumber]           VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [OperatingHoursId]         VARCHAR(18) NOT NULL,
  [DayOfWeek]                VARCHAR(255) NOT NULL,
  [Type]                     VARCHAR(255) NOT NULL,
  [MaxAppointments]          VARCHAR(255),
  [WorkTypeGroupId]          VARCHAR(18),
  [StartTime]                TIME NOT NULL,
  [EndTime]                  TIME NOT NULL,
  [External_Id__c]           VARCHAR(255),
CONSTRAINT [pk_TimeSlot] PRIMARY KEY ([Id]),
CONSTRAINT [uk_TimeSlotExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [TollFreeNumbers__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(80),
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastActivityDate]                DATE,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [ACEDescription__c]               VARCHAR(255),
  [ActiveCampaignsDesktop__c]       DECIMAL(3,0),
  [ActiveCampaignsMobile__c]        DECIMAL(3,0),
  [Company__c]                      VARCHAR(255),
  [DNIS__c]                         DECIMAL(4,0),
  [Description__c]                  VARCHAR(255),
  [LanguageCode__c]                 DECIMAL(2,0),
  [LocationCode__c]                 DECIMAL(3,0),
  [Misc_Code__c]                    DECIMAL(4,0) NOT NULL,
  [Notes__c]                        VARCHAR(255),
  [Number__c]                       VARCHAR(40),
  [PDNIS__c]                        DECIMAL(10,0),
  [PromoCode__c]                    VARCHAR(20),
  [SourceCode__c]                   VARCHAR(255),
  [TotalActiveCampaigns__c]         DECIMAL(18,0),
  [TotalCampaignsDesktop__c]        DECIMAL(18,0),
  [TotalCampaignsMobile__c]         DECIMAL(18,0),
  [TotalCampaigns__c]               DECIMAL(18,0),
  [External_Id__c]                  VARCHAR(255),
CONSTRAINT [pk_TollFreeNumbers__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_TollFreeNumbers__cDNIS__c] UNIQUE ([DNIS__c]),
CONSTRAINT [uk_TollFreeNumbers__cExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [Transaction_Log__c] ( 
  [Id]                         VARCHAR(18) NOT NULL,
  [OwnerId]                    VARCHAR(18) NOT NULL,
  [IsDeleted]                  BIT NOT NULL,
  [Name]                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]            VARCHAR(255),
  [RecordTypeId]               VARCHAR(18),
  [CreatedDate]                DATETIME2 NOT NULL,
  [CreatedById]                VARCHAR(18) NOT NULL,
  [LastModifiedDate]           DATETIME2 NOT NULL,
  [LastModifiedById]           VARCHAR(18) NOT NULL,
  [SystemModstamp]             DATETIME2 NOT NULL,
  [Account__c]                 VARCHAR(18),
  [Campaign__c]                VARCHAR(18),
  [Class_Name__c]              VARCHAR(255),
  [Exception_Time__c]          DATETIME2,
  [Lead__c]                    VARCHAR(18),
  [Process_Name__c]            VARCHAR(255),
  [Result_Log__c]              TEXT,
  [Status_Img__c]              VARCHAR(1300),
  [Status__c]                  VARCHAR(255),
  [Request__c]                 TEXT,
  [Response_JSON__c]           TEXT,
  [Service_Territory__c]       VARCHAR(18),
  [identificator__c]           VARCHAR(255),
CONSTRAINT [pk_Transaction_Log__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__Automated_Send__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [OwnerId]                VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [RecordTypeId]           VARCHAR(18),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
CONSTRAINT [pk_et4ae5__Automated_Send__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [et4ae5__Triggered_Send_Execution__c] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [OwnerId]                         VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [Name]                            VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255),
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastActivityDate]                DATE,
  [et4ae5__Triggered_Send__c]       VARCHAR(18) NOT NULL,
CONSTRAINT [pk_et4ae5__Triggered_Send_Execution__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [User] ( 
  [Id]                                                           VARCHAR(18) NOT NULL,
  [Username]                                                     VARCHAR(80) NOT NULL,
  [LastName]                                                     VARCHAR(80) NOT NULL,
  [FirstName]                                                    VARCHAR(40),
  [MiddleName]                                                   VARCHAR(40),
  [Suffix]                                                       VARCHAR(40),
  [Name]                                                         VARCHAR(121) NOT NULL,
  [CompanyName]                                                  VARCHAR(80),
  [Division]                                                     VARCHAR(80),
  [Department]                                                   VARCHAR(80),
  [Title]                                                        VARCHAR(80),
  [Street]                                                       VARCHAR(255),
  [City]                                                         VARCHAR(40),
  [State]                                                        VARCHAR(80),
  [PostalCode]                                                   VARCHAR(20),
  [Country]                                                      VARCHAR(80),
  [StateCode]                                                    VARCHAR(255),
  [CountryCode]                                                  VARCHAR(255),
  [Latitude]                                                     DECIMAL(15,15),
  [Longitude]                                                    DECIMAL(15,15),
  [GeocodeAccuracy]                                              VARCHAR(255),
  [Address]                                                      VARCHAR(255),
  [Email]                                                        VARCHAR(128) NOT NULL,
  [EmailPreferencesAutoBcc]                                      BIT NOT NULL,
  [EmailPreferencesAutoBccStayInTouch]                           BIT NOT NULL,
  [EmailPreferencesStayInTouchReminder]                          BIT NOT NULL,
  [SenderEmail]                                                  VARCHAR(128),
  [SenderName]                                                   VARCHAR(80),
  [Signature]                                                    TEXT,
  [StayInTouchSubject]                                           VARCHAR(80),
  [StayInTouchSignature]                                         TEXT,
  [StayInTouchNote]                                              VARCHAR(512),
  [Phone]                                                        VARCHAR(40),
  [Fax]                                                          VARCHAR(40),
  [MobilePhone]                                                  VARCHAR(40),
  [Alias]                                                        VARCHAR(8) NOT NULL,
  [CommunityNickname]                                            VARCHAR(40) NOT NULL,
  [BadgeText]                                                    VARCHAR(80),
  [IsActive]                                                     BIT NOT NULL,
  [TimeZoneSidKey]                                               VARCHAR(255) NOT NULL,
  [UserRoleId]                                                   VARCHAR(18),
  [LocaleSidKey]                                                 VARCHAR(255) NOT NULL,
  [ReceivesInfoEmails]                                           BIT NOT NULL,
  [ReceivesAdminInfoEmails]                                      BIT NOT NULL,
  [EmailEncodingKey]                                             VARCHAR(255) NOT NULL,
  [DefaultCurrencyIsoCode]                                       VARCHAR(255),
  [CurrencyIsoCode]                                              VARCHAR(255) NOT NULL,
  [ProfileId]                                                    VARCHAR(18) NOT NULL,
  [UserType]                                                     VARCHAR(255),
  [LanguageLocaleKey]                                            VARCHAR(255) NOT NULL,
  [EmployeeNumber]                                               VARCHAR(20),
  [DelegatedApproverId]                                          VARCHAR(18),
  [ManagerId]                                                    VARCHAR(18),
  [LastLoginDate]                                                DATETIME2,
  [LastPasswordChangeDate]                                       DATETIME2,
  [CreatedDate]                                                  DATETIME2 NOT NULL,
  [CreatedById]                                                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                             DATETIME2 NOT NULL,
  [LastModifiedById]                                             VARCHAR(18) NOT NULL,
  [SystemModstamp]                                               DATETIME2 NOT NULL,
  [NumberOfFailedLogins]                                         VARCHAR(255),
  [OfflineTrialExpirationDate]                                   DATETIME2,
  [OfflinePdaTrialExpirationDate]                                DATETIME2,
  [UserPermissionsMarketingUser]                                 BIT NOT NULL,
  [UserPermissionsOfflineUser]                                   BIT NOT NULL,
  [UserPermissionsAvantgoUser]                                   BIT NOT NULL,
  [UserPermissionsCallCenterAutoLogin]                           BIT NOT NULL,
  [UserPermissionsSFContentUser]                                 BIT NOT NULL,
  [UserPermissionsKnowledgeUser]                                 BIT NOT NULL,
  [UserPermissionsInteractionUser]                               BIT NOT NULL,
  [UserPermissionsSupportUser]                                   BIT NOT NULL,
  [UserPermissionsLiveAgentUser]                                 BIT NOT NULL,
  [ForecastEnabled]                                              BIT NOT NULL,
  [UserPreferencesActivityRemindersPopup]                        BIT NOT NULL,
  [UserPreferencesEventRemindersCheckboxDefault]                 BIT NOT NULL,
  [UserPreferencesTaskRemindersCheckboxDefault]                  BIT NOT NULL,
  [UserPreferencesReminderSoundOff]                              BIT NOT NULL,
  [UserPreferencesDisableAllFeedsEmail]                          BIT NOT NULL,
  [UserPreferencesDisableFollowersEmail]                         BIT NOT NULL,
  [UserPreferencesDisableProfilePostEmail]                       BIT NOT NULL,
  [UserPreferencesDisableChangeCommentEmail]                     BIT NOT NULL,
  [UserPreferencesDisableLaterCommentEmail]                      BIT NOT NULL,
  [UserPreferencesDisProfPostCommentEmail]                       BIT NOT NULL,
  [UserPreferencesApexPagesDeveloperMode]                        BIT NOT NULL,
  [UserPreferencesReceiveNoNotificationsAsApprover]              BIT NOT NULL,
  [UserPreferencesReceiveNotificationsAsDelegatedApprover]       BIT NOT NULL,
  [UserPreferencesHideCSNGetChatterMobileTask]                   BIT NOT NULL,
  [UserPreferencesDisableMentionsPostEmail]                      BIT NOT NULL,
  [UserPreferencesDisMentionsCommentEmail]                       BIT NOT NULL,
  [UserPreferencesHideCSNDesktopTask]                            BIT NOT NULL,
  [UserPreferencesHideChatterOnboardingSplash]                   BIT NOT NULL,
  [UserPreferencesHideSecondChatterOnboardingSplash]             BIT NOT NULL,
  [UserPreferencesDisCommentAfterLikeEmail]                      BIT NOT NULL,
  [UserPreferencesDisableLikeEmail]                              BIT NOT NULL,
  [UserPreferencesSortFeedByComment]                             BIT NOT NULL,
  [UserPreferencesDisableMessageEmail]                           BIT NOT NULL,
  [UserPreferencesDisableBookmarkEmail]                          BIT NOT NULL,
  [UserPreferencesDisableSharePostEmail]                         BIT NOT NULL,
  [UserPreferencesEnableAutoSubForFeeds]                         BIT NOT NULL,
  [UserPreferencesDisableFileShareNotificationsForApi]           BIT NOT NULL,
  [UserPreferencesShowTitleToExternalUsers]                      BIT NOT NULL,
  [UserPreferencesShowManagerToExternalUsers]                    BIT NOT NULL,
  [UserPreferencesShowEmailToExternalUsers]                      BIT NOT NULL,
  [UserPreferencesShowWorkPhoneToExternalUsers]                  BIT NOT NULL,
  [UserPreferencesShowMobilePhoneToExternalUsers]                BIT NOT NULL,
  [UserPreferencesShowFaxToExternalUsers]                        BIT NOT NULL,
  [UserPreferencesShowStreetAddressToExternalUsers]              BIT NOT NULL,
  [UserPreferencesShowCityToExternalUsers]                       BIT NOT NULL,
  [UserPreferencesShowStateToExternalUsers]                      BIT NOT NULL,
  [UserPreferencesShowPostalCodeToExternalUsers]                 BIT NOT NULL,
  [UserPreferencesShowCountryToExternalUsers]                    BIT NOT NULL,
  [UserPreferencesShowProfilePicToGuestUsers]                    BIT NOT NULL,
  [UserPreferencesShowTitleToGuestUsers]                         BIT NOT NULL,
  [UserPreferencesShowCityToGuestUsers]                          BIT NOT NULL,
  [UserPreferencesShowStateToGuestUsers]                         BIT NOT NULL,
  [UserPreferencesShowPostalCodeToGuestUsers]                    BIT NOT NULL,
  [UserPreferencesShowCountryToGuestUsers]                       BIT NOT NULL,
  [UserPreferencesHideInvoicesRedirectConfirmation]              BIT NOT NULL,
  [UserPreferencesHideStatementsRedirectConfirmation]            BIT NOT NULL,
  [UserPreferencesHideS1BrowserUI]                               BIT NOT NULL,
  [UserPreferencesDisableEndorsementEmail]                       BIT NOT NULL,
  [UserPreferencesPathAssistantCollapsed]                        BIT NOT NULL,
  [UserPreferencesCacheDiagnostics]                              BIT NOT NULL,
  [UserPreferencesShowEmailToGuestUsers]                         BIT NOT NULL,
  [UserPreferencesShowManagerToGuestUsers]                       BIT NOT NULL,
  [UserPreferencesShowWorkPhoneToGuestUsers]                     BIT NOT NULL,
  [UserPreferencesShowMobilePhoneToGuestUsers]                   BIT NOT NULL,
  [UserPreferencesShowFaxToGuestUsers]                           BIT NOT NULL,
  [UserPreferencesShowStreetAddressToGuestUsers]                 BIT NOT NULL,
  [UserPreferencesLightningExperiencePreferred]                  BIT NOT NULL,
  [UserPreferencesPreviewLightning]                              BIT NOT NULL,
  [UserPreferencesHideEndUserOnboardingAssistantModal]           BIT NOT NULL,
  [UserPreferencesHideLightningMigrationModal]                   BIT NOT NULL,
  [UserPreferencesHideSfxWelcomeMat]                             BIT NOT NULL,
  [UserPreferencesHideBiggerPhotoCallout]                        BIT NOT NULL,
  [UserPreferencesGlobalNavBarWTShown]                           BIT NOT NULL,
  [UserPreferencesGlobalNavGridMenuWTShown]                      BIT NOT NULL,
  [UserPreferencesCreateLEXAppsWTShown]                          BIT NOT NULL,
  [UserPreferencesFavoritesWTShown]                              BIT NOT NULL,
  [UserPreferencesRecordHomeSectionCollapseWTShown]              BIT NOT NULL,
  [UserPreferencesRecordHomeReservedWTShown]                     BIT NOT NULL,
  [UserPreferencesFavoritesShowTopFavorites]                     BIT NOT NULL,
  [UserPreferencesExcludeMailAppAttachments]                     BIT NOT NULL,
  [UserPreferencesSuppressTaskSFXReminders]                      BIT NOT NULL,
  [UserPreferencesSuppressEventSFXReminders]                     BIT NOT NULL,
  [UserPreferencesPreviewCustomTheme]                            BIT NOT NULL,
  [UserPreferencesHasCelebrationBadge]                           BIT NOT NULL,
  [UserPreferencesUserDebugModePref]                             BIT NOT NULL,
  [UserPreferencesSRHOverrideActivities]                         BIT NOT NULL,
  [UserPreferencesNewLightningReportRunPageEnabled]              BIT NOT NULL,
  [UserPreferencesReverseOpenActivitiesView]                     BIT NOT NULL,
  [UserPreferencesShowTerritoryTimeZoneShifts]                   BIT NOT NULL,
  [UserPreferencesNativeEmailClient]                             BIT NOT NULL,
  [UserPreferencesHideBrowseProductRedirectConfirmation]         BIT NOT NULL,
  [UserPreferencesHideOnlineSalesAppWelcomeMat]                  BIT NOT NULL,
  [ContactId]                                                    VARCHAR(18),
  [AccountId]                                                    VARCHAR(18),
  [CallCenterId]                                                 VARCHAR(18),
  [Extension]                                                    VARCHAR(40),
  [FederationIdentifier]                                         VARCHAR(512),
  [AboutMe]                                                      TEXT,
  [FullPhotoUrl]                                                 VARCHAR(1024),
  [SmallPhotoUrl]                                                VARCHAR(1024),
  [IsExtIndicatorVisible]                                        BIT NOT NULL,
  [OutOfOfficeMessage]                                           VARCHAR(40),
  [MediumPhotoUrl]                                               VARCHAR(1024),
  [DigestFrequency]                                              VARCHAR(255) NOT NULL,
  [DefaultGroupNotificationFrequency]                            VARCHAR(255) NOT NULL,
  [LastViewedDate]                                               DATETIME2,
  [LastReferencedDate]                                           DATETIME2,
  [BannerPhotoUrl]                                               VARCHAR(1024),
  [SmallBannerPhotoUrl]                                          VARCHAR(1024),
  [MediumBannerPhotoUrl]                                         VARCHAR(1024),
  [IsProfilePhotoActive]                                         BIT NOT NULL,
  [et4ae5__Default_ET_Page__c]                                   VARCHAR(255),
  [et4ae5__Default_MID__c]                                       VARCHAR(20),
  [et4ae5__ExactTargetForAppExchangeAdmin__c]                    BIT NOT NULL,
  [et4ae5__ExactTargetForAppExchangeUser__c]                     BIT NOT NULL,
  [et4ae5__ExactTargetUsername__c]                               VARCHAR(255),
  [et4ae5__ExactTarget_OAuth_Token__c]                           VARCHAR(175),
  [et4ae5__ValidExactTargetAdmin__c]                             BIT NOT NULL,
  [et4ae5__ValidExactTargetUser__c]                              BIT NOT NULL,
  [Chat_Display_Name__c]                                         VARCHAR(20),
  [Chat_Photo_Small__c]                                          VARCHAR(1024),
  [DialerID__c]                                                  VARCHAR(30),
  [External_Id__c]                                               VARCHAR(255),
  [SightCall_UseCase_Id__c]                                      VARCHAR(20),
  [Mobile_Agent_Login__c]                                        VARCHAR(80),
  [approver__c]                                                  VARCHAR(18),
  [DB_Region__c]                                                 VARCHAR(255),
  [Full_Name__c]                                                 VARCHAR(1300),
  [User_Deactivation_Details__c]                                 TEXT,
  [BannerPhotoId]                                                VARCHAR(18),
  [EndDay]                                                       VARCHAR(255),
  [WorkspaceId]                                                  VARCHAR(18),
  [UserSubtype]                                                  VARCHAR(255),
  [IsSystemControlled]                                           BIT,
  [PasswordResetAttempt]                                         DECIMAL(9,0),
  [PasswordResetLockoutDate]                                     DATETIME2,
  [StartDay]                                                     VARCHAR(255),
CONSTRAINT [pk_User] PRIMARY KEY ([Id]),
CONSTRAINT [uk_UserDialerID__c] UNIQUE ([DialerID__c]),
CONSTRAINT [uk_UserExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [et4ae5__UEBU__c] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [Name]                   VARCHAR(80),
  [CurrencyIsoCode]        VARCHAR(255),
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [et4ae5__BU__c]          VARCHAR(18) NOT NULL,
CONSTRAINT [pk_et4ae5__UEBU__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__UserInformation__c] ( 
  [Id]                                 VARCHAR(18) NOT NULL,
  [OwnerId]                            VARCHAR(18) NOT NULL,
  [IsDeleted]                          BIT NOT NULL,
  [Name]                               VARCHAR(80),
  [CurrencyIsoCode]                    VARCHAR(255),
  [CreatedDate]                        DATETIME2 NOT NULL,
  [CreatedById]                        VARCHAR(18) NOT NULL,
  [LastModifiedDate]                   DATETIME2 NOT NULL,
  [LastModifiedById]                   VARCHAR(18) NOT NULL,
  [SystemModstamp]                     DATETIME2 NOT NULL,
  [LastViewedDate]                     DATETIME2,
  [LastReferencedDate]                 DATETIME2,
  [fferpcore__Alias__c]                VARCHAR(8) NOT NULL,
  [fferpcore__Email__c]                VARCHAR(128) NOT NULL,
  [fferpcore__FirstName__c]            VARCHAR(40),
  [fferpcore__IsUserActive__c]         BIT NOT NULL,
  [fferpcore__LastName__c]             VARCHAR(80) NOT NULL,
  [fferpcore__Message__c]              TEXT,
  [fferpcore__Notified__c]             BIT NOT NULL,
  [fferpcore__ProfileName__c]          VARCHAR(255) NOT NULL,
  [fferpcore__Status__c]               VARCHAR(255) NOT NULL,
  [fferpcore__TimezoneSidKey__c]       VARCHAR(255),
  [fferpcore__User__c]                 VARCHAR(18),
CONSTRAINT [pk_fferpcore__UserInformation__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__UserInformationAssignment__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [fferpcore__UserInformation__c]            VARCHAR(18) NOT NULL,
  [fferpcore__Message__c]                    TEXT,
  [fferpcore__Status__c]                     VARCHAR(255) NOT NULL,
  [fferpcore__TemplateName__c]               VARCHAR(80) NOT NULL,
  [fferpcore__UniquenessConstraint__c]       VARCHAR(255),
CONSTRAINT [pk_fferpcore__UserInformationAssignment__c] PRIMARY KEY ([Id]),
CONSTRAINT [uk_fferpcore__UserInformationAssignment__cfferpcore__UniquenessConstraint__c] UNIQUE ([fferpcore__UniquenessConstraint__c])
) 
;

CREATE TABLE [UserProvisioningRequest] ( 
  [Id]                      VARCHAR(18) NOT NULL,
  [OwnerId]                 VARCHAR(18) NOT NULL,
  [IsDeleted]               BIT NOT NULL,
  [Name]                    VARCHAR(255) NOT NULL,
  [CreatedDate]             DATETIME2 NOT NULL,
  [CreatedById]             VARCHAR(18) NOT NULL,
  [LastModifiedDate]        DATETIME2 NOT NULL,
  [LastModifiedById]        VARCHAR(18) NOT NULL,
  [SystemModstamp]          DATETIME2 NOT NULL,
  [SalesforceUserId]        VARCHAR(18),
  [ExternalUserId]          VARCHAR(150),
  [AppName]                 VARCHAR(150),
  [State]                   VARCHAR(255) NOT NULL,
  [Operation]               VARCHAR(255) NOT NULL,
  [ScheduleDate]            DATETIME2,
  [ConnectedAppId]          VARCHAR(18),
  [UserProvConfigId]        VARCHAR(18),
  [UserProvAccountId]       VARCHAR(18),
  [ApprovalStatus]          VARCHAR(255) NOT NULL,
  [ManagerId]               VARCHAR(18),
  [RetryCount]              VARCHAR(255),
  [ParentId]                VARCHAR(18),
CONSTRAINT [pk_UserProvisioningRequest] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Tigerface5__Validate_Phone_Number__c] ( 
  [Id]                                         VARCHAR(18) NOT NULL,
  [IsDeleted]                                  BIT NOT NULL,
  [Name]                                       VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                            VARCHAR(255),
  [CreatedDate]                                DATETIME2 NOT NULL,
  [CreatedById]                                VARCHAR(18) NOT NULL,
  [LastModifiedDate]                           DATETIME2 NOT NULL,
  [LastModifiedById]                           VARCHAR(18) NOT NULL,
  [SystemModstamp]                             DATETIME2 NOT NULL,
  [LastViewedDate]                             DATETIME2,
  [LastReferencedDate]                         DATETIME2,
  [Tigerface5__Display_Configuration__c]       VARCHAR(18) NOT NULL,
  [Tigerface5__Phone_Field_Name__c]            VARCHAR(50) NOT NULL,
CONSTRAINT [pk_Tigerface5__Validate_Phone_Number__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffvat__VATGroup__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [OwnerId]                               VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(80),
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [LastActivityDate]                      DATE,
  [LastViewedDate]                        DATETIME2,
  [LastReferencedDate]                    DATETIME2,
  [ffvat__VATRegistrationNumber__c]       VARCHAR(1300),
CONSTRAINT [pk_ffvat__VATGroup__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffvat__VATGroupItem__c] ( 
  [Id]                        VARCHAR(18) NOT NULL,
  [IsDeleted]                 BIT NOT NULL,
  [Name]                      VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]           VARCHAR(255),
  [CreatedDate]               DATETIME2 NOT NULL,
  [CreatedById]               VARCHAR(18) NOT NULL,
  [LastModifiedDate]          DATETIME2 NOT NULL,
  [LastModifiedById]          VARCHAR(18) NOT NULL,
  [SystemModstamp]            DATETIME2 NOT NULL,
  [LastActivityDate]          DATE,
  [LastViewedDate]            DATETIME2,
  [LastReferencedDate]        DATETIME2,
  [ffvat__VATGroup__c]        VARCHAR(18) NOT NULL,
  [ffvat__DateAdded__c]       DATE,
CONSTRAINT [pk_ffvat__VATGroupItem__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffvat__VatReportedTransaction__c] ( 
  [Id]                                    VARCHAR(18) NOT NULL,
  [IsDeleted]                             BIT NOT NULL,
  [Name]                                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                       VARCHAR(255),
  [CreatedDate]                           DATETIME2 NOT NULL,
  [CreatedById]                           VARCHAR(18) NOT NULL,
  [LastModifiedDate]                      DATETIME2 NOT NULL,
  [LastModifiedById]                      VARCHAR(18) NOT NULL,
  [SystemModstamp]                        DATETIME2 NOT NULL,
  [ffvat__VatReturn__c]                   VARCHAR(18) NOT NULL,
  [ffvat__AccountValue__c]                DECIMAL(16,2),
  [ffvat__Account__c]                     VARCHAR(18),
  [ffvat__DocumentDate__c]                DATE,
  [ffvat__DocumentNumber__c]              VARCHAR(1300),
  [ffvat__DocumentType__c]                VARCHAR(1300),
  [ffvat__ECCountryCode__c]               VARCHAR(1300),
  [ffvat__FullyVATReported__c]            BIT NOT NULL,
  [ffvat__NetBox__c]                      VARCHAR(255),
  [ffvat__NetReported__c]                 DECIMAL(16,2),
  [ffvat__PaidAccountValue__c]            DECIMAL(16,2),
  [ffvat__Reconciled__c]                  VARCHAR(1300),
  [ffvat__TaxBox__c]                      VARCHAR(255),
  [ffvat__TaxCodeName__c]                 VARCHAR(1300),
  [ffvat__TaxReported__c]                 DECIMAL(16,2),
  [ffvat__VATRegistrationNumber__c]       VARCHAR(1300),
  [ffvat__VATReturnType__c]               VARCHAR(1300),
  [ffvat__VATStatus__c]                   VARCHAR(1300),
  [ffvat__VendorDocumentNumber__c]        VARCHAR(1300),
CONSTRAINT [pk_ffvat__VatReportedTransaction__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ffvat__VatReturn__c] ( 
  [Id]                                               VARCHAR(18) NOT NULL,
  [OwnerId]                                          VARCHAR(18) NOT NULL,
  [IsDeleted]                                        BIT NOT NULL,
  [Name]                                             VARCHAR(80),
  [CurrencyIsoCode]                                  VARCHAR(255),
  [CreatedDate]                                      DATETIME2 NOT NULL,
  [CreatedById]                                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                                 DATETIME2 NOT NULL,
  [LastModifiedById]                                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                                   DATETIME2 NOT NULL,
  [LastViewedDate]                                   DATETIME2,
  [LastReferencedDate]                               DATETIME2,
  [ffvat__Box1__c]                                   DECIMAL(16,2),
  [ffvat__Box2__c]                                   DECIMAL(16,2),
  [ffvat__Box3__c]                                   DECIMAL(16,2),
  [ffvat__Box5__c]                                   DECIMAL(16,2),
  [ffvat__Box6__c]                                   DECIMAL(16,2),
  [ffvat__Box7RoundedDown__c]                        DECIMAL(16,2),
  [ffvat__Box8__c]                                   DECIMAL(16,2),
  [ffvat__Box9RoundedDown__c]                        DECIMAL(16,2),
  [ffvat__DateFrom__c]                               DATE NOT NULL,
  [ffvat__DateTo__c]                                 DATE NOT NULL,
  [ffvat__GroupOfCompanies__c]                       BIT NOT NULL,
  [ffvat__IncludeOutdated__c]                        BIT NOT NULL,
  [ffvat__Status__c]                                 VARCHAR(255),
  [ffvat__SubmissionReceiptReferenceNumber__c]       VARCHAR(255),
  [ffvat__TaxCodeInconsistent__c]                    BIT NOT NULL,
  [ffvat__Timestamp__c]                              DATETIME2,
  [ffvat__Type__c]                                   VARCHAR(255),
  [ffvat__VATGroup__c]                               VARCHAR(18),
  [ffvat__Box1Sum__c]                                VARCHAR(30),
  [ffvat__Box2Sum__c]                                VARCHAR(30),
  [ffvat__Box4__c]                                   VARCHAR(30),
  [ffvat__Box6Sum__c]                                VARCHAR(30),
  [ffvat__Box7__c]                                   VARCHAR(30),
  [ffvat__Box8Sum__c]                                VARCHAR(30),
  [ffvat__Box9__c]                                   VARCHAR(30),
  [ffvat__TotalVATReportedTransactions__c]           VARCHAR(30),
CONSTRAINT [pk_ffvat__VatReturn__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [APXTConga4__VersionedData__c] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [Name]                         VARCHAR(80),
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [APXTConga4__Key__c]           VARCHAR(255) NOT NULL,
  [APXTConga4__Kind__c]          VARCHAR(255) NOT NULL,
  [APXTConga4__Raw__c]           TEXT,
  [APXTConga4__Version__c]       DECIMAL(15,0) NOT NULL,
CONSTRAINT [pk_APXTConga4__VersionedData__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [VideoCall] ( 
  [Id]                           VARCHAR(18) NOT NULL,
  [OwnerId]                      VARCHAR(18) NOT NULL,
  [IsDeleted]                    BIT NOT NULL,
  [Name]                         VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]              VARCHAR(255),
  [CreatedDate]                  DATETIME2 NOT NULL,
  [CreatedById]                  VARCHAR(18) NOT NULL,
  [LastModifiedDate]             DATETIME2 NOT NULL,
  [LastModifiedById]             VARCHAR(18) NOT NULL,
  [SystemModstamp]               DATETIME2 NOT NULL,
  [LastViewedDate]               DATETIME2,
  [LastReferencedDate]           DATETIME2,
  [EventId]                      VARCHAR(18),
  [RelatedRecordId]              VARCHAR(18),
  [VendorMeetingUuid]            VARCHAR(255),
  [ExternalId]                   VARCHAR(255),
  [VendorMeetingKey]             VARCHAR(255) NOT NULL,
  [VendorName]                   VARCHAR(255),
  [StartDateTime]                DATETIME2,
  [EndDateTime]                  DATETIME2,
  [DurationInSeconds]            VARCHAR(255),
  [IsRecorded]                   BIT NOT NULL,
  [Description]                  TEXT,
  [IntelligenceScore]            VARCHAR(255),
  [IsCallCoachingIncluded]       BIT NOT NULL,
  [HostId]                       VARCHAR(18),
CONSTRAINT [pk_VideoCall] PRIMARY KEY ([Id]),
CONSTRAINT [uk_VideoCallExternalId] UNIQUE ([ExternalId])
) 
;

CREATE TABLE [VoiceCall] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [CreatedDate]                 DATETIME2 NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [CallStartDateTime]           DATETIME2 NOT NULL,
  [CallEndDateTime]             DATETIME2 NOT NULL,
  [FromPhoneNumber]             VARCHAR(40) NOT NULL,
  [ToPhoneNumber]               VARCHAR(40) NOT NULL,
  [CallDurationInSeconds]       VARCHAR(255),
  [VendorCallKey]               VARCHAR(255),
  [Price]                       DECIMAL(16,2),
  [CurrencyCode]                VARCHAR(255),
  [CallDisposition]             VARCHAR(255),
  [CallType]                    VARCHAR(255) NOT NULL,
  [VendorParentCallKey]         VARCHAR(255),
  [UserId]                      VARCHAR(18),
  [RelatedRecordId]             VARCHAR(18),
  [VendorType]                  VARCHAR(255),
  [ConferenceKey]               VARCHAR(255),
  [CallerIdType]                VARCHAR(255),
  [ActivityId]                  VARCHAR(18),
  [CallConnectDateTime]         DATETIME2,
  [MediaProviderId]             VARCHAR(18),
  [SourceType]                  VARCHAR(255),
CONSTRAINT [pk_VoiceCall] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [WorkOrder] ( 
  [Id]                            VARCHAR(18) NOT NULL,
  [OwnerId]                       VARCHAR(18) NOT NULL,
  [IsDeleted]                     BIT NOT NULL,
  [WorkOrderNumber]               VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]               VARCHAR(255),
  [CreatedDate]                   DATETIME2 NOT NULL,
  [CreatedById]                   VARCHAR(18) NOT NULL,
  [LastModifiedDate]              DATETIME2 NOT NULL,
  [LastModifiedById]              VARCHAR(18) NOT NULL,
  [SystemModstamp]                DATETIME2 NOT NULL,
  [LastViewedDate]                DATETIME2,
  [LastReferencedDate]            DATETIME2,
  [AccountId]                     VARCHAR(18),
  [ContactId]                     VARCHAR(18),
  [CaseId]                        VARCHAR(18),
  [EntitlementId]                 VARCHAR(18),
  [ServiceContractId]             VARCHAR(18),
  [AssetId]                       VARCHAR(18),
  [Street]                        VARCHAR(255),
  [City]                          VARCHAR(40),
  [State]                         VARCHAR(80),
  [PostalCode]                    VARCHAR(20),
  [Country]                       VARCHAR(80),
  [StateCode]                     VARCHAR(255),
  [CountryCode]                   VARCHAR(255),
  [Latitude]                      DECIMAL(15,15),
  [Longitude]                     DECIMAL(15,15),
  [GeocodeAccuracy]               VARCHAR(255),
  [Address]                       VARCHAR(255),
  [Description]                   TEXT,
  [StartDate]                     DATETIME2,
  [EndDate]                       DATETIME2,
  [Subject]                       VARCHAR(255),
  [RootWorkOrderId]               VARCHAR(18),
  [Status]                        VARCHAR(255),
  [Priority]                      VARCHAR(255),
  [Tax]                           DECIMAL(16,2),
  [Subtotal]                      VARCHAR(30),
  [TotalPrice]                    VARCHAR(30),
  [LineItemCount]                 VARCHAR(30),
  [Pricebook2Id]                  VARCHAR(18),
  [Discount]                      DECIMAL(3,2),
  [GrandTotal]                    DECIMAL(16,2),
  [ParentWorkOrderId]             VARCHAR(18),
  [IsClosed]                      BIT NOT NULL,
  [IsStopped]                     BIT NOT NULL,
  [StopStartDate]                 DATETIME2,
  [SlaStartDate]                  DATETIME2,
  [SlaExitDate]                   DATETIME2,
  [BusinessHoursId]               VARCHAR(18),
  [MilestoneStatus]               VARCHAR(30),
  [Duration]                      DECIMAL(16,2),
  [DurationType]                  VARCHAR(255),
  [DurationInMinutes]             DECIMAL(16,2),
  [ServiceAppointmentCount]       VARCHAR(255),
  [WorkTypeId]                    VARCHAR(18),
  [ServiceTerritoryId]            VARCHAR(18),
  [StatusCategory]                VARCHAR(255),
  [LocationId]                    VARCHAR(18),
CONSTRAINT [pk_WorkOrder] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [WorkOrderLineItem] ( 
  [Id]                              VARCHAR(18) NOT NULL,
  [IsDeleted]                       BIT NOT NULL,
  [LineItemNumber]                  VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                 VARCHAR(255) NOT NULL,
  [CreatedDate]                     DATETIME2 NOT NULL,
  [CreatedById]                     VARCHAR(18) NOT NULL,
  [LastModifiedDate]                DATETIME2 NOT NULL,
  [LastModifiedById]                VARCHAR(18) NOT NULL,
  [SystemModstamp]                  DATETIME2 NOT NULL,
  [LastViewedDate]                  DATETIME2,
  [LastReferencedDate]              DATETIME2,
  [WorkOrderId]                     VARCHAR(18) NOT NULL,
  [ParentWorkOrderLineItemId]       VARCHAR(18),
  [Product2Id]                      VARCHAR(18),
  [AssetId]                         VARCHAR(18),
  [OrderId]                         VARCHAR(18),
  [RootWorkOrderLineItemId]         VARCHAR(18),
  [Description]                     TEXT,
  [StartDate]                       DATETIME2,
  [EndDate]                         DATETIME2,
  [Status]                          VARCHAR(255),
  [PricebookEntryId]                VARCHAR(18),
  [Quantity]                        DECIMAL(10,2),
  [UnitPrice]                       DECIMAL(16,2),
  [Discount]                        DECIMAL(3,2),
  [ListPrice]                       DECIMAL(16,2),
  [Subtotal]                        DECIMAL(16,2),
  [TotalPrice]                      DECIMAL(16,2),
  [Duration]                        DECIMAL(16,2),
  [DurationType]                    VARCHAR(255),
  [DurationInMinutes]               DECIMAL(16,2),
  [WorkTypeId]                      VARCHAR(18),
  [Street]                          VARCHAR(255),
  [City]                            VARCHAR(40),
  [State]                           VARCHAR(80),
  [PostalCode]                      VARCHAR(20),
  [Country]                         VARCHAR(80),
  [StateCode]                       VARCHAR(255),
  [CountryCode]                     VARCHAR(255),
  [Latitude]                        DECIMAL(15,15),
  [Longitude]                       DECIMAL(15,15),
  [GeocodeAccuracy]                 VARCHAR(255),
  [Address]                         VARCHAR(255),
  [ServiceTerritoryId]              VARCHAR(18),
  [Subject]                         VARCHAR(255),
  [StatusCategory]                  VARCHAR(255),
  [IsClosed]                        BIT NOT NULL,
  [Priority]                        VARCHAR(255),
  [ServiceAppointmentCount]         VARCHAR(255),
  [LocationId]                      VARCHAR(18),
CONSTRAINT [pk_WorkOrderLineItem] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [WorkType] ( 
  [Id]                               VARCHAR(18) NOT NULL,
  [OwnerId]                          VARCHAR(18) NOT NULL,
  [IsDeleted]                        BIT NOT NULL,
  [Name]                             VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                  VARCHAR(255),
  [CreatedDate]                      DATETIME2 NOT NULL,
  [CreatedById]                      VARCHAR(18) NOT NULL,
  [LastModifiedDate]                 DATETIME2 NOT NULL,
  [LastModifiedById]                 VARCHAR(18) NOT NULL,
  [SystemModstamp]                   DATETIME2 NOT NULL,
  [LastViewedDate]                   DATETIME2,
  [LastReferencedDate]               DATETIME2,
  [Description]                      TEXT,
  [EstimatedDuration]                DECIMAL(16,2) NOT NULL,
  [DurationType]                     VARCHAR(255) NOT NULL,
  [DurationInMinutes]                DECIMAL(16,2),
  [TimeframeStart]                   VARCHAR(255),
  [TimeframeEnd]                     VARCHAR(255),
  [BlockTimeBeforeAppointment]       VARCHAR(255),
  [BlockTimeAfterAppointment]        VARCHAR(255),
  [DefaultAppointmentType]           VARCHAR(255),
  [TimeFrameStartUnit]               VARCHAR(255),
  [TimeFrameEndUnit]                 VARCHAR(255),
  [BlockTimeBeforeUnit]              VARCHAR(255),
  [BlockTimeAfterUnit]               VARCHAR(255),
  [OperatingHoursId]                 VARCHAR(18),
  [External_Id__c]                   VARCHAR(255),
CONSTRAINT [pk_WorkType] PRIMARY KEY ([Id]),
CONSTRAINT [uk_WorkTypeExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [WorkTypeGroup] ( 
  [Id]                          VARCHAR(18) NOT NULL,
  [OwnerId]                     VARCHAR(18) NOT NULL,
  [IsDeleted]                   BIT NOT NULL,
  [Name]                        VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]             VARCHAR(255),
  [CreatedDate]                 DATETIME2 NOT NULL,
  [CreatedById]                 VARCHAR(18) NOT NULL,
  [LastModifiedDate]            DATETIME2 NOT NULL,
  [LastModifiedById]            VARCHAR(18) NOT NULL,
  [SystemModstamp]              DATETIME2 NOT NULL,
  [LastViewedDate]              DATETIME2,
  [LastReferencedDate]          DATETIME2,
  [Description]                 TEXT,
  [GroupType]                   VARCHAR(255) NOT NULL,
  [IsActive]                    BIT NOT NULL,
  [AdditionalInformation]       VARCHAR(1000),
  [External_Id__c]              VARCHAR(255),
  [Language__c]                 VARCHAR(255),
CONSTRAINT [pk_WorkTypeGroup] PRIMARY KEY ([Id]),
CONSTRAINT [uk_WorkTypeGroupExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [WorkTypeGroupMember] ( 
  [Id]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                           BIT NOT NULL,
  [Name]                                VARCHAR(255) NOT NULL,
  [CurrencyIsoCode]                     VARCHAR(255),
  [CreatedDate]                         DATETIME2 NOT NULL,
  [CreatedById]                         VARCHAR(18) NOT NULL,
  [LastModifiedDate]                    DATETIME2 NOT NULL,
  [LastModifiedById]                    VARCHAR(18) NOT NULL,
  [SystemModstamp]                      DATETIME2 NOT NULL,
  [LastViewedDate]                      DATETIME2,
  [LastReferencedDate]                  DATETIME2,
  [WorkTypeId]                          VARCHAR(18) NOT NULL,
  [WorkTypeGroupId]                     VARCHAR(18) NOT NULL,
  [External_Id__c]                      VARCHAR(255),
  [Work_Type_Appointment_Type__c]       VARCHAR(1300),
CONSTRAINT [pk_WorkTypeGroupMember] PRIMARY KEY ([Id]),
CONSTRAINT [uk_WorkTypeGroupMemberExternal_Id__c] UNIQUE ([External_Id__c])
) 
;

CREATE TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c] ( 
  [Id]                                     VARCHAR(18) NOT NULL,
  [OwnerId]                                VARCHAR(18) NOT NULL,
  [IsDeleted]                              BIT NOT NULL,
  [Name]                                   VARCHAR(80),
  [CurrencyIsoCode]                        VARCHAR(255),
  [CreatedDate]                            DATETIME2 NOT NULL,
  [CreatedById]                            VARCHAR(18) NOT NULL,
  [LastModifiedDate]                       DATETIME2 NOT NULL,
  [LastModifiedById]                       VARCHAR(18) NOT NULL,
  [SystemModstamp]                         DATETIME2 NOT NULL,
  [ffirule__Account__c]                    VARCHAR(18),
  [ffirule__BatchProcess__c]               VARCHAR(18),
  [ffirule__Description__c]                VARCHAR(255),
  [ffirule__ForecastCategoryName__c]       VARCHAR(255),
  [ffirule__NextStep__c]                   VARCHAR(255),
CONSTRAINT [pk_ffirule__fflib_XXXBatchTestOpportunity2__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c] ( 
  [Id]                                       VARCHAR(18) NOT NULL,
  [OwnerId]                                  VARCHAR(18) NOT NULL,
  [IsDeleted]                                BIT NOT NULL,
  [Name]                                     VARCHAR(80),
  [CurrencyIsoCode]                          VARCHAR(255),
  [CreatedDate]                              DATETIME2 NOT NULL,
  [CreatedById]                              VARCHAR(18) NOT NULL,
  [LastModifiedDate]                         DATETIME2 NOT NULL,
  [LastModifiedById]                         VARCHAR(18) NOT NULL,
  [SystemModstamp]                           DATETIME2 NOT NULL,
  [fferpcore__Account__c]                    VARCHAR(18),
  [fferpcore__BatchProcess__c]               VARCHAR(18),
  [fferpcore__Description__c]                VARCHAR(255),
  [fferpcore__ForecastCategoryName__c]       VARCHAR(255),
  [fferpcore__NextStep__c]                   VARCHAR(255),
CONSTRAINT [pk_fferpcore__fflib_XXXBatchTestOpportunity2__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [ZipCode__c] ( 
  [Id]                       VARCHAR(18) NOT NULL,
  [OwnerId]                  VARCHAR(18) NOT NULL,
  [IsDeleted]                BIT NOT NULL,
  [Name]                     VARCHAR(80),
  [CurrencyIsoCode]          VARCHAR(255),
  [CreatedDate]              DATETIME2 NOT NULL,
  [CreatedById]              VARCHAR(18) NOT NULL,
  [LastModifiedDate]         DATETIME2 NOT NULL,
  [LastModifiedById]         VARCHAR(18) NOT NULL,
  [SystemModstamp]           DATETIME2 NOT NULL,
  [LastActivityDate]         DATE,
  [LastViewedDate]           DATETIME2,
  [LastReferencedDate]       DATETIME2,
  [External_Id__c]           VARCHAR(255),
CONSTRAINT [pk_ZipCode__c] PRIMARY KEY ([Id])
) 
;

CREATE TABLE [Announcement] ( 
  [Id]                     VARCHAR(18) NOT NULL,
  [IsDeleted]              BIT NOT NULL,
  [CreatedDate]            DATETIME2 NOT NULL,
  [CreatedById]            VARCHAR(18) NOT NULL,
  [LastModifiedDate]       DATETIME2 NOT NULL,
  [LastModifiedById]       VARCHAR(18) NOT NULL,
  [SystemModstamp]         DATETIME2 NOT NULL,
  [FeedItemId]             VARCHAR(18) NOT NULL,
  [ExpirationDate]         DATETIME2 NOT NULL,
  [SendEmails]             BIT NOT NULL,
  [IsArchived]             BIT NOT NULL,
  [ParentId]               VARCHAR(18),
CONSTRAINT [pk_Announcement] PRIMARY KEY ([Id]),
CONSTRAINT [uk_AnnouncementFeedItemId] UNIQUE ([FeedItemId])
) 
;

/*============================================================================*/
/*                               FOREIGN KEYS                                 */
/*============================================================================*/
ALTER TABLE [et4ae5__abTest__c]
    ADD CONSTRAINT [fk_et4ae5__abTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__abTest__c]
    ADD CONSTRAINT [fk_et4ae5__abTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__abTest__c]
    ADD CONSTRAINT [fk_et4ae5__abTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_Account_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_Contact_PersonContactId]
        FOREIGN KEY ([PersonContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_ServiceTerritory_Service_Territory__c]
        FOREIGN KEY ([Service_Territory__c])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_fferpcore__TaxCode__c_fferpcore__OutputVatCode__c]
        FOREIGN KEY ([fferpcore__OutputVatCode__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_fferpcore__TaxCode__c_fferpcore__TaxCode1__c]
        FOREIGN KEY ([fferpcore__TaxCode1__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_fferpcore__TaxCode__c_fferpcore__TaxCode2__c]
        FOREIGN KEY ([fferpcore__TaxCode2__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_fferpcore__TaxCode__c_fferpcore__TaxCode3__c]
        FOREIGN KEY ([fferpcore__TaxCode3__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_rh2__PS_Describe__c_rh2__Describe__pc]
        FOREIGN KEY ([rh2__Describe__pc])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Account]
    ADD CONSTRAINT [fk_Account_Account_MasterRecordId]
        FOREIGN KEY ([MasterRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [AccountContactRelation]
    ADD CONSTRAINT [fk_AccountContactRelation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AccountContactRelation]
    ADD CONSTRAINT [fk_AccountContactRelation_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [AccountContactRelation]
    ADD CONSTRAINT [fk_AccountContactRelation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AccountContactRelation]
    ADD CONSTRAINT [fk_AccountContactRelation_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [fferpcore__AccountCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__AccountCreditTerms__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__AccountCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__AccountCreditTerms__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AccountCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__AccountCreditTerms__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AccountExtension__c]
    ADD CONSTRAINT [fk_fferpcore__AccountExtension__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__AccountExtension__c]
    ADD CONSTRAINT [fk_fferpcore__AccountExtension__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AccountExtension__c]
    ADD CONSTRAINT [fk_fferpcore__AccountExtension__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountingCurrencyTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountingCurrencyTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountingCurrencyTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountingCurrencyTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__AccountingCurrencyTest__c]
    ADD CONSTRAINT [fk_ffbf__AccountingCurrencyTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__AggregateLink__c]
    ADD CONSTRAINT [fk_et4ae5__AggregateLink__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__AggregateLink__c]
    ADD CONSTRAINT [fk_et4ae5__AggregateLink__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__AggregateLink__c]
    ADD CONSTRAINT [fk_et4ae5__AggregateLink__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AnalysisItem__c]
    ADD CONSTRAINT [fk_fferpcore__AnalysisItem__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AnalysisItem__c]
    ADD CONSTRAINT [fk_fferpcore__AnalysisItem__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__AnalysisItem__c]
    ADD CONSTRAINT [fk_fferpcore__AnalysisItem__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_TimeSlot_TimeSlotId]
        FOREIGN KEY ([TimeSlotId])
            REFERENCES [TimeSlot] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_WorkTypeGroup_WorkTypeGroupId]
        FOREIGN KEY ([WorkTypeGroupId])
            REFERENCES [WorkTypeGroup] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [AppointmentTopicTimeSlot]
    ADD CONSTRAINT [fk_AppointmentTopicTimeSlot_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Account_AssetServicedById]
        FOREIGN KEY ([AssetServicedById])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Account_AssetProvidedById]
        FOREIGN KEY ([AssetProvidedById])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Asset_RootAssetId]
        FOREIGN KEY ([RootAssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Asset_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Asset]
    ADD CONSTRAINT [fk_Asset_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [AssetRelationship]
    ADD CONSTRAINT [fk_AssetRelationship_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AssetRelationship]
    ADD CONSTRAINT [fk_AssetRelationship_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AssetRelationship]
    ADD CONSTRAINT [fk_AssetRelationship_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [AssetRelationship]
    ADD CONSTRAINT [fk_AssetRelationship_Asset_RelatedAssetId]
        FOREIGN KEY ([RelatedAssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [AssignedResource]
    ADD CONSTRAINT [fk_AssignedResource_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AssignedResource]
    ADD CONSTRAINT [fk_AssignedResource_Event_EventId]
        FOREIGN KEY ([EventId])
            REFERENCES [Event] ([Id])
 ;
 
ALTER TABLE [AssignedResource]
    ADD CONSTRAINT [fk_AssignedResource_ServiceResource_ServiceResourceId]
        FOREIGN KEY ([ServiceResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [AssignedResource]
    ADD CONSTRAINT [fk_AssignedResource_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AssignedResource]
    ADD CONSTRAINT [fk_AssignedResource_ServiceAppointment_ServiceAppointmentId]
        FOREIGN KEY ([ServiceAppointmentId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [AssociatedLocation]
    ADD CONSTRAINT [fk_AssociatedLocation_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [AssociatedLocation]
    ADD CONSTRAINT [fk_AssociatedLocation_Account_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [AssociatedLocation]
    ADD CONSTRAINT [fk_AssociatedLocation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [AssociatedLocation]
    ADD CONSTRAINT [fk_AssociatedLocation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BackgroundOperation]
    ADD CONSTRAINT [fk_BackgroundOperation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BackgroundOperation]
    ADD CONSTRAINT [fk_BackgroundOperation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BackgroundOperation]
    ADD CONSTRAINT [fk_BackgroundOperation_BackgroundOperation_GroupLeaderId]
        FOREIGN KEY ([GroupLeaderId])
            REFERENCES [BackgroundOperation] ([Id])
 ;
 
ALTER TABLE [WorkBadgeDefinition]
    ADD CONSTRAINT [fk_WorkBadgeDefinition_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkBadgeDefinition]
    ADD CONSTRAINT [fk_WorkBadgeDefinition_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkBadgeDefinition]
    ADD CONSTRAINT [fk_WorkBadgeDefinition_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankAccountTest__c]
    ADD CONSTRAINT [fk_ffbf__BankAccountTest__c_ffbf__CompanyTest__c_ffbf__OwnerCompany__c]
        FOREIGN KEY ([ffbf__OwnerCompany__c])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__BankAccountTest__c]
    ADD CONSTRAINT [fk_ffbf__BankAccountTest__c_ffbf__AccountingCurrencyTest__c_ffbf__BankAccountCurrency__c]
        FOREIGN KEY ([ffbf__BankAccountCurrency__c])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__BankAccountTest__c]
    ADD CONSTRAINT [fk_ffbf__BankAccountTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankAccountTest__c]
    ADD CONSTRAINT [fk_ffbf__BankAccountTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankAccountTest__c]
    ADD CONSTRAINT [fk_ffbf__BankAccountTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinition__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinition__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinition__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinition__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinition__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinition__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionField__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionField__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionField__c_ffbf__BankFormatDefinitionRecordType__c_ffbf__BankFormatDefinitionRecordType__c]
        FOREIGN KEY ([ffbf__BankFormatDefinitionRecordType__c])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionRecordType__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionRecordType__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDefinitionRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDefinitionRecordType__c_ffbf__BankFormatDefinition__c_ffbf__BankFormatDefinition__c]
        FOREIGN KEY ([ffbf__BankFormatDefinition__c])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__BankFormatDocumentConversion__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDocumentConversion__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDocumentConversion__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDocumentConversion__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatDocumentConversion__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatDocumentConversion__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMapping__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMapping__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMapping__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMapping__c_ffbf__BankFormatDefinition__c_ffbf__BankFormatDefinition__c]
        FOREIGN KEY ([ffbf__BankFormatDefinition__c])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMapping__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMapping__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMapping__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMapping__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingField__c_ffbf__BankFormatDefinitionField__c_ffbf__BankFormatRecordSourceField__c]
        FOREIGN KEY ([ffbf__BankFormatRecordSourceField__c])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingField__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingField__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingField__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingField__c_ffbf__BankFormatMappingRecordType__c_ffbf__BankFormatMappingRecordType__c]
        FOREIGN KEY ([ffbf__BankFormatMappingRecordType__c])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__BankFormatMappingJoin__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingJoin__c_ffbf__BankFormatMapping__c_ffbf__BankFormatMapping__c]
        FOREIGN KEY ([ffbf__BankFormatMapping__c])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__BankFormatMappingJoin__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingJoin__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingJoin__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingJoin__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingRecordType__c_ffbf__BankFormatDefinitionRecordType__c_ffbf__BankFormatDefinitionRecordType__c]
        FOREIGN KEY ([ffbf__BankFormatDefinitionRecordType__c])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingRecordType__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingRecordType__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__BankFormatMappingRecordType__c]
    ADD CONSTRAINT [fk_ffbf__BankFormatMappingRecordType__c_ffbf__BankFormatMapping__c_ffbf__BankFormatMapping__c]
        FOREIGN KEY ([ffbf__BankFormatMapping__c])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffbf__fflib_SchedulerConfiguration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffbf__fflib_SchedulerConfiguration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffbf__fflib_SchedulerConfiguration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcess__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcess__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcess__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcess__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcess__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcess__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcessDetail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcessDetail__c_ffvat__fflib_BatchProcess__c_ffvat__BatchProcess__c]
        FOREIGN KEY ([ffvat__BatchProcess__c])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffvat__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffvat__fflib_BatchProcessDetail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcessDetail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcessDetail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_ffirule__fflib_BatchProcessDetail__c_ffirule__fflib_BatchProcess__c_ffirule__BatchProcess__c]
        FOREIGN KEY ([ffirule__BatchProcess__c])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__BillingDocument__c_fferpcore__RelatedDocument__c]
        FOREIGN KEY ([fferpcore__RelatedDocument__c])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__ff_Engagement__c_fferpcore__Engagement__c]
        FOREIGN KEY ([fferpcore__Engagement__c])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__ProcessTracking__c_fferpcore__CompletionProcessTracking__c]
        FOREIGN KEY ([fferpcore__CompletionProcessTracking__c])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__Company__c_fferpcore__Company__c]
        FOREIGN KEY ([fferpcore__Company__c])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem4__c]
        FOREIGN KEY ([fferpcore__AnalysisItem4__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem3__c]
        FOREIGN KEY ([fferpcore__AnalysisItem3__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem2__c]
        FOREIGN KEY ([fferpcore__AnalysisItem2__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocument__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocument__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem1__c]
        FOREIGN KEY ([fferpcore__AnalysisItem1__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__CompanySite__c_fferpcore__CompanySite__c]
        FOREIGN KEY ([fferpcore__CompanySite__c])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__TaxCode__c_fferpcore__TaxCode1__c]
        FOREIGN KEY ([fferpcore__TaxCode1__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_Product2_fferpcore__ProductService__c]
        FOREIGN KEY ([fferpcore__ProductService__c])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__TaxCode__c_fferpcore__TaxCode2__c]
        FOREIGN KEY ([fferpcore__TaxCode2__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__TaxCode__c_fferpcore__TaxCode3__c]
        FOREIGN KEY ([fferpcore__TaxCode3__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem4__c]
        FOREIGN KEY ([fferpcore__AnalysisItem4__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem3__c]
        FOREIGN KEY ([fferpcore__AnalysisItem3__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem2__c]
        FOREIGN KEY ([fferpcore__AnalysisItem2__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__AnalysisItem__c_fferpcore__AnalysisItem1__c]
        FOREIGN KEY ([fferpcore__AnalysisItem1__c])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [fferpcore__BillingDocumentLineItem__c]
    ADD CONSTRAINT [fk_fferpcore__BillingDocumentLineItem__c_fferpcore__BillingDocument__c_fferpcore__BillingDocument__c]
        FOREIGN KEY ([fferpcore__BillingDocument__c])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [Briefing__c]
    ADD CONSTRAINT [fk_Briefing__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Briefing__c]
    ADD CONSTRAINT [fk_Briefing__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Briefing__c]
    ADD CONSTRAINT [fk_Briefing__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BriefingLog__c]
    ADD CONSTRAINT [fk_BriefingLog__c_User_User__c]
        FOREIGN KEY ([User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BriefingLog__c]
    ADD CONSTRAINT [fk_BriefingLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BriefingLog__c]
    ADD CONSTRAINT [fk_BriefingLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [BriefingLog__c]
    ADD CONSTRAINT [fk_BriefingLog__c_Briefing__c_Briefing__c]
        FOREIGN KEY ([Briefing__c])
            REFERENCES [Briefing__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__Business_Unit__c]
    ADD CONSTRAINT [fk_et4ae5__Business_Unit__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Business_Unit__c]
    ADD CONSTRAINT [fk_et4ae5__Business_Unit__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Business_Unit__c]
    ADD CONSTRAINT [fk_et4ae5__Business_Unit__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__Call_Report__c]
    ADD CONSTRAINT [fk_sc_lightning__Call_Report__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__Call_Report__c]
    ADD CONSTRAINT [fk_sc_lightning__Call_Report__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__Call_Report__c]
    ADD CONSTRAINT [fk_sc_lightning__Call_Report__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__Call_Report__c]
    ADD CONSTRAINT [fk_sc_lightning__Call_Report__c_Case_sc_lightning__Case__c]
        FOREIGN KEY ([sc_lightning__Case__c])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [sc_lightning__Call_Report__c]
    ADD CONSTRAINT [fk_sc_lightning__Call_Report__c_sc_lightning__SightCall_Case__c_sc_lightning__SightCall_Case__c]
        FOREIGN KEY ([sc_lightning__SightCall_Case__c])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_TollFreeNumbers__c_TollFreeNumber__c]
        FOREIGN KEY ([TollFreeNumber__c])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_PromoCode__c_Promo_Code__c]
        FOREIGN KEY ([Promo_Code__c])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_Campaign_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_TollFreeNumbers__c_Toll_Free_Desktop__c]
        FOREIGN KEY ([Toll_Free_Desktop__c])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [Campaign]
    ADD CONSTRAINT [fk_Campaign_TollFreeNumbers__c_Toll_Free_Mobile__c]
        FOREIGN KEY ([Toll_Free_Mobile__c])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Opportunity_Opportunity__c]
        FOREIGN KEY ([Opportunity__c])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_User_LeadOrContactOwnerId]
        FOREIGN KEY ([LeadOrContactOwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Lead_LeadOrContactId]
        FOREIGN KEY ([LeadOrContactId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Contact_LeadOrContactId]
        FOREIGN KEY ([LeadOrContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Account_LeadOrContactId]
        FOREIGN KEY ([LeadOrContactId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Lead_LeadId]
        FOREIGN KEY ([LeadId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Campaign_CampaignId]
        FOREIGN KEY ([CampaignId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [CampaignMember]
    ADD CONSTRAINT [fk_CampaignMember_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [et4ae5__Campaign_Member_Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Campaign_Member_Configuration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Campaign_Member_Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Campaign_Member_Configuration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Campaign_Member_Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Campaign_Member_Configuration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMemberStatus]
    ADD CONSTRAINT [fk_CampaignMemberStatus_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMemberStatus]
    ADD CONSTRAINT [fk_CampaignMemberStatus_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CampaignMemberStatus]
    ADD CONSTRAINT [fk_CampaignMemberStatus_Campaign_CampaignId]
        FOREIGN KEY ([CampaignId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Lead_LeadId__c]
        FOREIGN KEY ([LeadId__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_ServiceContract_ServiceContractId]
        FOREIGN KEY ([ServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Case_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_SocialPost_SourceId]
        FOREIGN KEY ([SourceId])
            REFERENCES [SocialPost] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_LiveChatTranscript_SourceId]
        FOREIGN KEY ([SourceId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_EmailMessage_SourceId]
        FOREIGN KEY ([SourceId])
            REFERENCES [EmailMessage] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Entitlement_EntitlementId]
        FOREIGN KEY ([EntitlementId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Product2_ProductId]
        FOREIGN KEY ([ProductId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Campaign_Campaign__c]
        FOREIGN KEY ([Campaign__c])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Case_MasterRecordId]
        FOREIGN KEY ([MasterRecordId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [Case]
    ADD CONSTRAINT [fk_Case_Account_Center__c]
        FOREIGN KEY ([Center__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [CaseMilestone]
    ADD CONSTRAINT [fk_CaseMilestone_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CaseMilestone]
    ADD CONSTRAINT [fk_CaseMilestone_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CaseMilestone]
    ADD CONSTRAINT [fk_CaseMilestone_Case_CaseId]
        FOREIGN KEY ([CaseId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [LiveAgentSession]
    ADD CONSTRAINT [fk_LiveAgentSession_User_AgentId]
        FOREIGN KEY ([AgentId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveAgentSession]
    ADD CONSTRAINT [fk_LiveAgentSession_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveAgentSession]
    ADD CONSTRAINT [fk_LiveAgentSession_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveAgentSession]
    ADD CONSTRAINT [fk_LiveAgentSession_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_Case_CaseId]
        FOREIGN KEY ([CaseId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_Lead_LeadId]
        FOREIGN KEY ([LeadId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_LiveChatVisitor_LiveChatVisitorId]
        FOREIGN KEY ([LiveChatVisitorId])
            REFERENCES [LiveChatVisitor] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_Account_Account__c]
        FOREIGN KEY ([Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveChatTranscript]
    ADD CONSTRAINT [fk_LiveChatTranscript_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [LiveChatVisitor]
    ADD CONSTRAINT [fk_LiveChatVisitor_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LiveChatVisitor]
    ADD CONSTRAINT [fk_LiveChatVisitor_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Chunk__c]
    ADD CONSTRAINT [fk_fferpcore__Chunk__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Chunk__c]
    ADD CONSTRAINT [fk_fferpcore__Chunk__c_fferpcore__ScheduledJobRun__c_fferpcore__ScheduledJobRun__c]
        FOREIGN KEY ([fferpcore__ScheduledJobRun__c])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__Chunk__c]
    ADD CONSTRAINT [fk_fferpcore__Chunk__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleAction__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleAction__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleAction__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleAction__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleAction__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleAction__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkAnotherSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkAnotherSourceTest__c_ffirule__IntegrationRuleSourceLineItemTest__c_ffirule__ClickLinkSourceLineItemTest__c]
        FOREIGN KEY ([ffirule__ClickLinkSourceLineItemTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__ClickLinkAnotherSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkAnotherSourceTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkAnotherSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkAnotherSourceTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleButton__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleButton__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleButton__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleButton__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleButton__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleButton__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleJob__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleJob__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleJob__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleJob__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleJob__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleJob__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLineLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLineLookupTest__c_ffirule__IntegrationRuleLookupTest__c_ffirule__ClickLinkLookupTest__c]
        FOREIGN KEY ([ffirule__ClickLinkLookupTest__c])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLineLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLineLookupTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLineLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLineLookupTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLineLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLineLookupTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_User_ffirule__User__c]
        FOREIGN KEY ([ffirule__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_ffirule__IntegrationRuleJob__c_ffirule__IntegrationRuleJob__c]
        FOREIGN KEY ([ffirule__IntegrationRuleJob__c])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLog__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLog__c_ffirule__IntegrationRuleButton__c_ffirule__IntegrationRuleButton__c]
        FOREIGN KEY ([ffirule__IntegrationRuleButton__c])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLogLineItem__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLogLineItem__c_ffirule__IntegrationRuleSourceTest__c_ffirule__RelatedSourceTest__c]
        FOREIGN KEY ([ffirule__RelatedSourceTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLogLineItem__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLogLineItem__c_ffirule__IntegrationRuleSourceLineItemTest__c_ffirule__RelatedSourceLineItemTest__c]
        FOREIGN KEY ([ffirule__RelatedSourceLineItemTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLogLineItem__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLogLineItem__c_ffirule__IntegrationRuleLog__c_ffirule__IntegrationRuleLog__c]
        FOREIGN KEY ([ffirule__IntegrationRuleLog__c])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLogLineItem__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLogLineItem__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLogLineItem__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLogLineItem__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLookupTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLookupTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleLookupTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleLookupTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkManagedJob__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkManagedJob__c_ffirule__IntegrationRuleJob__c_ffirule__ClickLinkJob__c]
        FOREIGN KEY ([ffirule__ClickLinkJob__c])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkManagedJob__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkManagedJob__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkManagedJob__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkManagedJob__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__ClickLinkManagedJob__c]
    ADD CONSTRAINT [fk_ffirule__ClickLinkManagedJob__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleMapping__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleMapping__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleMapping__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleMapping__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleMapping__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleMapping__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleRelationship__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleRelationship__c_ffirule__IntegrationRule__c_ffirule__IntegrationRule__c]
        FOREIGN KEY ([ffirule__IntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleRelationship__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleRelationship__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleRelationship__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleRelationship__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleRelationship__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleRelationship__c_ffirule__IntegrationRule__c_ffirule__RelationshipIntegrationRule__c]
        FOREIGN KEY ([ffirule__RelationshipIntegrationRule__c])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRule__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRule__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRule__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRule__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRule__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRule__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceLineItemTest__c_ffirule__IntegrationRuleSourceTest__c_ffirule__IntegrationRuleSourceTest__c]
        FOREIGN KEY ([ffirule__IntegrationRuleSourceTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceLineItemTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceLineItemTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceListViewTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceListViewTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceListViewTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceListViewTest__c_ffirule__IntegrationRuleSourceTest__c_ffirule__IntegrationRuleSourceTest__c]
        FOREIGN KEY ([ffirule__IntegrationRuleSourceTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceListViewTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceListViewTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceListViewTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceListViewTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceTest__c_ffirule__IntegrationRuleTargetTest__c_ffirule__TargetRecord__c]
        FOREIGN KEY ([ffirule__TargetRecord__c])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceTest__c_ffirule__IntegrationRuleLookupTest__c_ffirule__ALookupField__c]
        FOREIGN KEY ([ffirule__ALookupField__c])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleSourceTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleSourceTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetLineItemTest__c_ffirule__IntegrationRuleSourceLineItemTest__c_ffirule__IntegrationRuleSourceL]
        FOREIGN KEY ([ffirule__IntegrationRuleSourceLineItemTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetLineItemTest__c_ffirule__IntegrationRuleLineLookupTest__c_ffirule__ALookupField__c]
        FOREIGN KEY ([ffirule__ALookupField__c])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetLineItemTest__c_ffirule__IntegrationRuleTargetTest__c_ffirule__IntegrationRuleTargetTest__c]
        FOREIGN KEY ([ffirule__IntegrationRuleTargetTest__c])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetLineItemTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetLineItemTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetLineItemTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_ffirule__IntegrationRuleSourceTest__c_ffirule__IntegrationRuleSourceTest__c]
        FOREIGN KEY ([ffirule__IntegrationRuleSourceTest__c])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_ffirule__IntegrationRuleLookupTest__c_ffirule__AnotherLookupField__c]
        FOREIGN KEY ([ffirule__AnotherLookupField__c])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__IntegrationRuleTargetTest__c]
    ADD CONSTRAINT [fk_ffirule__IntegrationRuleTargetTest__c_ffirule__IntegrationRuleLookupTest__c_ffirule__ALookupField__c]
        FOREIGN KEY ([ffirule__ALookupField__c])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_User_Commission_To__c]
        FOREIGN KEY ([Commission_To__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_User_Commission_To_Proposed_Change__c]
        FOREIGN KEY ([Commission_To_Proposed_Change__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_Lead_Related_Lead__c]
        FOREIGN KEY ([Related_Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_Account_Related_Person_Account__c]
        FOREIGN KEY ([Related_Person_Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_ServiceAppointment_Service_Appointment__c]
        FOREIGN KEY ([Service_Appointment__c])
            REFERENCES [ServiceAppointment] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Commissions_Log__c]
    ADD CONSTRAINT [fk_Commissions_Log__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Company__c]
    ADD CONSTRAINT [fk_fferpcore__Company__c_fferpcore__CompanyTaxInformation__c_fferpcore__TaxInformation__c]
        FOREIGN KEY ([fferpcore__TaxInformation__c])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__Company__c]
    ADD CONSTRAINT [fk_fferpcore__Company__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Company__c]
    ADD CONSTRAINT [fk_fferpcore__Company__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Company__c]
    ADD CONSTRAINT [fk_fferpcore__Company__c_APXTConga4__Conga_Template__c_ffaci__CongaTemplateBillingDocument__c]
        FOREIGN KEY ([ffaci__CongaTemplateBillingDocument__c])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__Company__c]
    ADD CONSTRAINT [fk_fferpcore__Company__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyCreditTerms__c_fferpcore__Company__c_fferpcore__Company__c]
        FOREIGN KEY ([fferpcore__Company__c])
            REFERENCES [fferpcore__Company__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__CompanyCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyCreditTerms__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyCreditTerms__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyCreditTerms__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanySite__c]
    ADD CONSTRAINT [fk_fferpcore__CompanySite__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanySite__c]
    ADD CONSTRAINT [fk_fferpcore__CompanySite__c_fferpcore__Company__c_fferpcore__Company__c]
        FOREIGN KEY ([fferpcore__Company__c])
            REFERENCES [fferpcore__Company__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__CompanySite__c]
    ADD CONSTRAINT [fk_fferpcore__CompanySite__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyTaxInformation__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyTaxInformation__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyTaxInformation__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyTaxInformation__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyTaxInformation__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyTaxInformation__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__CompanyTaxInformation__c]
    ADD CONSTRAINT [fk_fferpcore__CompanyTaxInformation__c_fferpcore__TaxCode__c_fferpcore__TaxCode__c]
        FOREIGN KEY ([fferpcore__TaxCode__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [ffbf__CompanyTest__c]
    ADD CONSTRAINT [fk_ffbf__CompanyTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__CompanyTest__c]
    ADD CONSTRAINT [fk_ffbf__CompanyTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__CompanyTest__c]
    ADD CONSTRAINT [fk_ffbf__CompanyTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_Host_Override__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_Host_Override__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_Host_Override__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_Host_Override__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_Host_Override__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_Host_Override__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Configuration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Configuration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Configuration__c]
    ADD CONSTRAINT [fk_et4ae5__Configuration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__exp_configurationItem__c]
    ADD CONSTRAINT [fk_fferpcore__exp_configurationItem__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__exp_configurationItem__c]
    ADD CONSTRAINT [fk_fferpcore__exp_configurationItem__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__exp_configurationItem__c]
    ADD CONSTRAINT [fk_fferpcore__exp_configurationItem__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Conductor__c]
    ADD CONSTRAINT [fk_APXT_BPM__Conductor__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Conductor__c]
    ADD CONSTRAINT [fk_APXT_BPM__Conductor__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Conductor__c]
    ADD CONSTRAINT [fk_APXT_BPM__Conductor__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection_Solution__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection_Solution__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection_Solution__c_APXTConga4__Conga_Collection__c_APXTConga4__Conga_Collection__c]
        FOREIGN KEY ([APXTConga4__Conga_Collection__c])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Collection_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Collection_Solution__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])

 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Staging__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Staging__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Staging__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Staging__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Staging__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Staging__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Template__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Template__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Email_Template__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_QuickMerge__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_QuickMerge__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_QuickMerge__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_QuickMerge__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_QuickMerge__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_QuickMerge__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Composer_QuickMerge__c]
    ADD CONSTRAINT [fk_APXTConga4__Composer_QuickMerge__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Merge_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Merge_Query__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Merge_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Merge_Query__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Merge_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Merge_Query__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Email_Template__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Email_Template__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Email_Template__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Email_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Email_Template__c_APXTConga4__Conga_Email_Template__c_APXTConga4__Conga_Email_Template__c]
        FOREIGN KEY ([APXTConga4__Conga_Email_Template__c])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])

 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Parameter__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Parameter__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Parameter__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Parameter__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Parameter__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Parameter__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Query__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Query__c_APXTConga4__Conga_Merge_Query__c_APXTConga4__Conga_Query__c]
        FOREIGN KEY ([APXTConga4__Conga_Query__c])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])

 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Query__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Query__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Query__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Report__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Report__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Report__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Report__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Report__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Report__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Template__c_APXTConga4__Conga_Template__c_APXTConga4__Conga_Template__c]
        FOREIGN KEY ([APXTConga4__Conga_Template__c])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])

 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Template__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Template__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Solution_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Solution_Template__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Template__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Template__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Conga_Template__c]
    ADD CONSTRAINT [fk_APXTConga4__Conga_Template__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_Contact_ReportsToId]
        FOREIGN KEY ([ReportsToId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_Contact_MasterRecordId]
        FOREIGN KEY ([MasterRecordId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Contact]
    ADD CONSTRAINT [fk_Contact_rh2__PS_Describe__c_rh2__Describe__c]
        FOREIGN KEY ([rh2__Describe__c])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_User_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Rollup_Dummy__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Queue__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Queue__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Export_Rollups__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Exception__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Exception__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Describe__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__HS_Filter__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__HS_Filter__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__Filter__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__Filter__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__fflib_SchedulerConfiguration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__fflib_BatchProcess__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__fflib_BatchProcessDetail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__VatReturn__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VatReturn__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__VatReportedTransaction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VatReportedTransaction__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__VATGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffvat__VATGroupItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__fflib_XXXBatchTestOpportunity2__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__fflib_SchedulerConfiguration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__fflib_BatchProcess__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__fflib_BatchProcessDetail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRule__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__PS_Rollup_Group__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Rollup_Group__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_rh2__RH_Job__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__RH_Job__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_sc_lightning__Call_Report__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__Call_Report__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_sc_lightning__SightCall_Case__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_sc_lightning__SightCall_Request__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_sc_lightning__SightCall_Session__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_sc_lightning__SightCall__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Contact_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Lead_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleTargetTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleTargetLineItemTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleTargetLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleSourceTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleSourceListViewTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleSourceListViewTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleSourceLineItemTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleRelationship__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleMapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleLookupTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleLogLineItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleLogLineItem__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleLineLookupTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleJob__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleButton__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__IntegrationRuleAction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__ClickLinkManagedJob__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__ClickLinkManagedJob__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffirule__ClickLinkAnotherSourceTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__ClickLinkAnotherSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__fflib_XXXBatchTestOpportunity2__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__fflib_SchedulerConfiguration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__fflib_BatchProcess__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__fflib_BatchProcessDetail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ff_Engagement__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__exp_configurationItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__exp_configurationItem__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__UserInformation__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__UserInformationAssignment__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__UserInformationAssignment__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__TestSubscription__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__TestPublication__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__TestPublication__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__TaxRate__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__TaxRate__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__TaxDetail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__TaxDetail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__TaxCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__SubscriptionMessageType__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__SubscriptionMessageType__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__SequenceCounter__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__SequenceCounter__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ScheduledJob__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ScheduledJobRun__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ScheduledJobLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ScheduledJobLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProductProxy__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProductExtension__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProductExtension__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProcessUserGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProcessTracking__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProcessRun__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ProcessLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__PermissionOperationData__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__PermissionOperationData__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__PermissionErrorLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__PermissionErrorLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__MessagingSubscription__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__MessagingPublication__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__MessagingMessage__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__MessagingDelivery__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__MessagingDelivery__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__MessageType__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__Mapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__Mapping__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__FeatureEnablementLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__FeatureEnablementLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__FeatureConsoleActivation__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__FeatureConsoleActivation__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ExchangeRateHistory__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ExchangeRateHistory__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ExchangeRateGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ExchangeRateEntry__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ExchangeRateEntry__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__ERPProduct__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__DataTransformation__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__DataTransformation__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__DataTransformationTable__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__DSCustomMapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__DSCustomMapping__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__DPNodeDeclaration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__DPNodeDeclaration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__Company__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__CompanyTaxInformation__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__CompanySite__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__CompanyCreditTerms__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__CompanyCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__Chunk__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__BillingDocument__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__BillingDocumentLineItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__AnalysisItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__AccountExtension__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__AccountExtension__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_fferpcore__AccountCreditTerms__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__AccountCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffc__Event__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffc__Event__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__fflib_SchedulerConfiguration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__PaymentTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__PaymentMediaSummaryTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__PaymentMediaDetailTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__PaymentMediaDetailTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__PaymentMediaControlTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__CompanyTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatMapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatMappingRecordType__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatMappingJoin__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatMappingJoin__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatMappingField__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatMappingField__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatDocumentConversion__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatDocumentConversion__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatDefinition__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatDefinitionRecordType__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankFormatDefinitionField__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__BankAccountTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__AccountingCurrencyTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ffbf__AccountTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ff_frb__Reporting_Component_Configuration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ff_frb__Reporting_Component_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ff_frb__Report__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ff_frb__Report__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ff_frb__Financial_Statement__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ff_frb__Financial_Statement__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ff_frb__Financial_Report__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ff_frb__Financial_Report__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__abTest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__abTest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__UEBU__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__UEBU__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Triggered_Send_Execution__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__SupportRequest__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__SupportRequest__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__SendJunction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__SendJunction__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__SendDefinition__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__SMSJunction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__SMSJunction__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__SMSDefinition__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__MC_CDC_Journey__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__MC_CDC_Journey__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution_Template__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Composer_Host_Override__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Composer_Host_Override__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Composer_QuickMerge__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Collection_Solution__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Collection_Solution__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Collection__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Email_Staging__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Email_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Merge_Query__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution_Email_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution_Parameter__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution_Parameter__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution_Query__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution_Query__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution_Report__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution_Report__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Phone_Validation__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Phone_Validation__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Solution__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Conga_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Document_History_Detail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Document_History_Detail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__Document_History__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__EventData__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__EventData__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXTConga4__VersionedData__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__VersionedData__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXT_BPM__Conductor__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_APXT_BPM__Scheduled_Conductor_History__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXT_BPM__Scheduled_Conductor_History__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Account_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_BriefingLog__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [BriefingLog__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Briefing__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Case_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Commissions_Log__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Opportunity_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_PromoCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Rebuttal__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_SCMFFA__SCM_Product_Mapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SCMFFA__SCM_Product_Mapping__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_SCMFFA__fflib_BatchProcessDetail__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SCMFFA__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_SCMFFA__fflib_BatchProcess__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_SCMFFA__fflib_SchedulerConfiguration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SCMFFA__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Script__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ServiceTerritory_ZipCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceTerritory_ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_SightCall_Appointment_Configuration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SightCall_Appointment_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Display_Configuration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Display_Filter__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Display_Filter__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Display_Validation_Field__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Display_Validation_Field__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__AggregateLink__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__AggregateLink__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Test_Table_Custom_Object__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Tigerface5__Validate_Phone_Number__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Tigerface5__Validate_Phone_Number__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_TollFreeNumbers__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_Transaction_Log__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Transaction_Log__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_WorkOrder_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_ZipCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Email_Linkage__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Email_Linkage__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Automated_Send__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Business_Unit__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Campaign_Member_Configuration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Campaign_Member_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__Configuration__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__IndividualLink__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__IndividualLink__c] ([Id])
 ;
 
ALTER TABLE [ContactRequest]
    ADD CONSTRAINT [fk_ContactRequest_et4ae5__IndividualEmailResult__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__IndividualEmailResult__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatMappingRecordType__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__fflib_BatchProcessDetail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__fflib_BatchProcess__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__fflib_SchedulerConfiguration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__fflib_XXXBatchTestOpportunity2__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__ClickLinkAnotherSourceTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__ClickLinkAnotherSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__ClickLinkManagedJob__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__ClickLinkManagedJob__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleAction__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleButton__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleJob__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleLineLookupTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleLogLineItem__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleLogLineItem__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleLookupTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleMapping__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleRelationship__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleSourceLineItemTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleSourceListViewTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleSourceListViewTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleSourceTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleTargetLineItemTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleTargetLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRuleTargetTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__IntegrationRule__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__fflib_BatchProcessDetail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__fflib_BatchProcess__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__fflib_SchedulerConfiguration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffirule__fflib_XXXBatchTestOpportunity2__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffirule__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__VATGroupItem__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__VATGroup__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__VatReportedTransaction__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__VatReportedTransaction__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__VatReturn__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__VatReturn__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__fflib_BatchProcessDetail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__fflib_BatchProcess__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffvat__fflib_SchedulerConfiguration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffvat__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__Filter__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__Filter__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__HS_Filter__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__HS_Filter__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Describe__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Exception__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Exception__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Export_Rollups__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Queue__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Queue__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Rollup_Dummy__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__PS_Rollup_Group__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__PS_Rollup_Group__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_rh2__RH_Job__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [rh2__RH_Job__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_sc_lightning__Call_Report__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [sc_lightning__Call_Report__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_sc_lightning__SightCall_Case__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_sc_lightning__SightCall_Request__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_sc_lightning__SightCall_Session__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_sc_lightning__SightCall__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [sc_lightning__SightCall__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ff_Engagement__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__exp_configurationItem__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__exp_configurationItem__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__UserInformation__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__UserInformationAssignment__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__UserInformationAssignment__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__TestSubscription__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__TestPublication__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__TestPublication__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__TaxRate__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__TaxRate__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__TaxDetail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__TaxDetail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__TaxCode__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__SubscriptionMessageType__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__SubscriptionMessageType__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__SequenceCounter__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__SequenceCounter__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ScheduledJob__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ScheduledJobRun__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ScheduledJobLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ScheduledJobLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProductProxy__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProductExtension__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProductExtension__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProcessUserGroup__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProcessTracking__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProcessRun__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ProcessLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ProcessLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__PermissionOperationData__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__PermissionOperationData__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__PermissionErrorLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__PermissionErrorLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__MessagingSubscription__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__MessagingPublication__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__MessagingMessage__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__MessagingDelivery__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__MessagingDelivery__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__MessageType__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__Mapping__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__Mapping__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__FeatureEnablementLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__FeatureEnablementLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__FeatureConsoleActivation__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__FeatureConsoleActivation__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ExchangeRateHistory__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ExchangeRateHistory__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ExchangeRateGroup__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ExchangeRateEntry__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ExchangeRateEntry__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__ERPProduct__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__DataTransformation__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__DataTransformation__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__DataTransformationTable__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__DSCustomMapping__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__DSCustomMapping__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__DPNodeDeclaration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__DPNodeDeclaration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__Company__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__CompanyTaxInformation__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__CompanySite__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__CompanyCreditTerms__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__CompanyCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__Chunk__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__BillingDocument__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__BillingDocumentLineItem__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__AnalysisItem__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__AccountExtension__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__AccountExtension__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_fferpcore__AccountCreditTerms__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [fferpcore__AccountCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffc__Event__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffc__Event__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__fflib_SchedulerConfiguration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__PaymentTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__PaymentMediaSummaryTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__PaymentMediaDetailTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__PaymentMediaDetailTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__PaymentMediaControlTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__CompanyTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatMapping__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatMappingJoin__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatMappingJoin__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_User_ContentModifiedById]
        FOREIGN KEY ([ContentModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Composer_Host_Override__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Composer_Host_Override__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Composer_QuickMerge__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Collection_Solution__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Collection_Solution__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Collection__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Email_Staging__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Email_Template__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Merge_Query__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution_Email_Template__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution_Parameter__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution_Parameter__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution_Query__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution_Query__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution_Report__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution_Report__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution_Template__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution_Template__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Solution__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Conga_Template__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Document_History_Detail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Document_History_Detail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__Document_History__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__EventData__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__EventData__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXTConga4__VersionedData__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXTConga4__VersionedData__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXT_BPM__Conductor__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_APXT_BPM__Scheduled_Conductor_History__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [APXT_BPM__Scheduled_Conductor_History__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Account_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_AppointmentTopicTimeSlot_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [AppointmentTopicTimeSlot] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Asset_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_AssetRelationship_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [AssetRelationship] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_AssignedResource_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [AssignedResource] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_BriefingLog__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [BriefingLog__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Briefing__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Campaign_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Case_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_CollaborationGroup_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [CollaborationGroup] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Commissions_Log__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Contact_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Contract_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ContractLineItem_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_EmailMessage_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [EmailMessage] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_EnhancedLetterhead_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [EnhancedLetterhead] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Entitlement_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_EntityMilestone_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [EntityMilestone] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Event_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Event] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Image_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Image] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Knowledge__kav_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Knowledge__kav] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Lead_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_LinkedArticle_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [LinkedArticle] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ListEmail_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ListEmail] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_LiveChatTranscript_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Location_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_OperatingHours_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_OperatingHoursHoliday_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [OperatingHoursHoliday] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Opportunity_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Order_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_OrderItem_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [OrderItem] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Product2_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ProfileSkill_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ProfileSkill] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ProfileSkillEndorsement_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ProfileSkillEndorsement] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ProfileSkillUser_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ProfileSkillUser] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_PromoCode__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Quote_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Rebuttal__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ResourceAbsence_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ResourceAbsence] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ResourcePreference_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ResourcePreference] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SCMFFA__SCM_Product_Mapping__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SCMFFA__SCM_Product_Mapping__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SCMFFA__fflib_BatchProcessDetail__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SCMFFA__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SCMFFA__fflib_BatchProcess__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SCMFFA__fflib_SchedulerConfiguration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SCMFFA__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Script__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceAppointment_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceContract_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceResource_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceResourceSkill_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceResourceSkill] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceTerritory_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceTerritoryMember_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceTerritoryMember] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceTerritoryWorkType_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceTerritoryWorkType] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ServiceTerritory_ZipCode__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ServiceTerritory_ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Shift_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Shift] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SightCall_Appointment_Configuration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SightCall_Appointment_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SkillRequirement_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SkillRequirement] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SocialPost_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SocialPost] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Solution_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Solution] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Survey_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Survey] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SurveyInvitation_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SurveyInvitation] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SurveyQuestionResponse_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SurveyQuestionResponse] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_SurveyResponse_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [SurveyResponse] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Task_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Task] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Territory2Model_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Territory2Model] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Display_Configuration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Display_Filter__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Display_Filter__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Display_Validation_Field__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Display_Validation_Field__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Phone_Validation__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Phone_Validation__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Test_Table_Custom_Object__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Tigerface5__Validate_Phone_Number__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Tigerface5__Validate_Phone_Number__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_TollFreeNumbers__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_Transaction_Log__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [Transaction_Log__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_User_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_VideoCall_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [VideoCall] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_VoiceCall_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [VoiceCall] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkBadgeDefinition_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkBadgeDefinition] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkOrder_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkOrderLineItem_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkType_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkTypeGroup_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkTypeGroup] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_WorkTypeGroupMember_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [WorkTypeGroupMember] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ZipCode__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__AggregateLink__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__AggregateLink__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Automated_Send__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Business_Unit__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Campaign_Member_Configuration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Campaign_Member_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Configuration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Email_Linkage__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Email_Linkage__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__UEBU__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__UEBU__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__abTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__abTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ff_frb__Financial_Report__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ff_frb__Financial_Report__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatDocumentConversion__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatDocumentConversion__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatMappingField__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatMappingField__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankAccountTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__AccountingCurrencyTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__IndividualEmailResult__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__IndividualEmailResult__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__IndividualLink__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__IndividualLink__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__MC_CDC_Journey__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__MC_CDC_Journey__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__SMSDefinition__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__SMSJunction__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__SMSJunction__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__SendDefinition__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__SendJunction__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__SendJunction__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__SupportRequest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__SupportRequest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_et4ae5__Triggered_Send_Execution__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ff_frb__Financial_Statement__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ff_frb__Financial_Statement__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ff_frb__Report__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ff_frb__Report__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ff_frb__Reporting_Component_Configuration__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ff_frb__Reporting_Component_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__AccountTest__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatDefinitionField__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatDefinitionRecordType__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [ContentVersion]
    ADD CONSTRAINT [fk_ContentVersion_ffbf__BankFormatDefinition__c_FirstPublishLocationId]
        FOREIGN KEY ([FirstPublishLocationId])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_User_ActivatedById]
        FOREIGN KEY ([ActivatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_Contact_CustomerSignedId]
        FOREIGN KEY ([CustomerSignedId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Contract]
    ADD CONSTRAINT [fk_Contract_User_CompanySignedId]
        FOREIGN KEY ([CompanySignedId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_ServiceContract_ServiceContractId]
        FOREIGN KEY ([ServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_PricebookEntry_PricebookEntryId]
        FOREIGN KEY ([PricebookEntryId])
            REFERENCES [PricebookEntry] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_ContractLineItem_ParentContractLineItemId]
        FOREIGN KEY ([ParentContractLineItemId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_ContractLineItem_RootContractLineItemId]
        FOREIGN KEY ([RootContractLineItemId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [ContractLineItem]
    ADD CONSTRAINT [fk_ContractLineItem_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [fferpcore__DataTransformation__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformation__c_fferpcore__DataTransformationTable__c_fferpcore__DataTransformationTable__c]
        FOREIGN KEY ([fferpcore__DataTransformationTable__c])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__DataTransformation__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformation__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DataTransformation__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformation__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DataTransformationTable__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformationTable__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DataTransformationTable__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformationTable__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DataTransformationTable__c]
    ADD CONSTRAINT [fk_fferpcore__DataTransformationTable__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DPNodeDeclaration__c]
    ADD CONSTRAINT [fk_fferpcore__DPNodeDeclaration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DPNodeDeclaration__c]
    ADD CONSTRAINT [fk_fferpcore__DPNodeDeclaration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DPNodeDeclaration__c]
    ADD CONSTRAINT [fk_fferpcore__DPNodeDeclaration__c_fferpcore__MessagingPublication__c_fferpcore__Publication__c]
        FOREIGN KEY ([fferpcore__Publication__c])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__DSCustomMapping__c]
    ADD CONSTRAINT [fk_fferpcore__DSCustomMapping__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DSCustomMapping__c]
    ADD CONSTRAINT [fk_fferpcore__DSCustomMapping__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__DSCustomMapping__c]
    ADD CONSTRAINT [fk_fferpcore__DSCustomMapping__c_fferpcore__MessagingSubscription__c_fferpcore__Subscription__c]
        FOREIGN KEY ([fferpcore__Subscription__c])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__DSCustomMapping__c]
    ADD CONSTRAINT [fk_fferpcore__DSCustomMapping__c_fferpcore__DataTransformationTable__c_fferpcore__DataTransformationTable__c]
        FOREIGN KEY ([fferpcore__DataTransformationTable__c])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__MessagingDelivery__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingDelivery__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingDelivery__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingDelivery__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingDelivery__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingDelivery__c_fferpcore__MessagingSubscription__c_fferpcore__Subscription__c]
        FOREIGN KEY ([fferpcore__Subscription__c])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingDelivery__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingDelivery__c_fferpcore__Chunk__c_fferpcore__Chunk__c]
        FOREIGN KEY ([fferpcore__Chunk__c])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingDelivery__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingDelivery__c_fferpcore__MessagingMessage__c_fferpcore__Message__c]
        FOREIGN KEY ([fferpcore__Message__c])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [SCMFFA__SCM_Product_Mapping__c]
    ADD CONSTRAINT [fk_SCMFFA__SCM_Product_Mapping__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__SCM_Product_Mapping__c]
    ADD CONSTRAINT [fk_SCMFFA__SCM_Product_Mapping__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__SCM_Product_Mapping__c]
    ADD CONSTRAINT [fk_SCMFFA__SCM_Product_Mapping__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__SCM_Product_Mapping__c]
    ADD CONSTRAINT [fk_SCMFFA__SCM_Product_Mapping__c_Product2_SCMFFA__Product__c]
        FOREIGN KEY ([SCMFFA__Product__c])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Dummy__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Dummy__c_Account_rh2__Account__c]
        FOREIGN KEY ([rh2__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Dummy__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Dummy__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Dummy__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Dummy__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Dummy__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Dummy__c_rh2__PS_Rollup_Dummy__c_rh2__Parent_Dummy__c]
        FOREIGN KEY ([rh2__Parent_Dummy__c])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Dummy__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Dummy__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_User_rh2__User__c]
        FOREIGN KEY ([rh2__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_Contact_rh2__Contact__c]
        FOREIGN KEY ([rh2__Contact__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_Contact_rh2__Contact3__c]
        FOREIGN KEY ([rh2__Contact3__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_Account_rh2__Account__c]
        FOREIGN KEY ([rh2__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_Contact_rh2__Contact2__c]
        FOREIGN KEY ([rh2__Contact2__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_rh2__PS_Describe__c_rh2__Hierarchy_Test__c]
        FOREIGN KEY ([rh2__Hierarchy_Test__c])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_rh2__PS_Describe__c_rh2__Hierarchy_Test_2__c]
        FOREIGN KEY ([rh2__Hierarchy_Test_2__c])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Describe__c]
    ADD CONSTRAINT [fk_rh2__PS_Describe__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Configuration__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Configuration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Configuration__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Configuration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Configuration__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Configuration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Filter__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Filter__c_Tigerface5__Display_Configuration__c_Tigerface5__Display_Configuration__c]
        FOREIGN KEY ([Tigerface5__Display_Configuration__c])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [Tigerface5__Display_Filter__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Filter__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Filter__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Filter__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Validation_Field__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Validation_Field__c_Tigerface5__Display_Configuration__c_Tigerface5__Display_Configuration__c]
        FOREIGN KEY ([Tigerface5__Display_Configuration__c])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [Tigerface5__Display_Validation_Field__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Validation_Field__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Display_Validation_Field__c]
    ADD CONSTRAINT [fk_Tigerface5__Display_Validation_Field__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History__c_APXTConga4__Conga_Solution__c_APXTConga4__Conga_Solution__c]
        FOREIGN KEY ([APXTConga4__Conga_Solution__c])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History_Detail__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History_Detail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__Document_History_Detail__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History_Detail__c_APXTConga4__Document_History__c_APXTConga4__Document_History__c]
        FOREIGN KEY ([APXTConga4__Document_History__c])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [APXTConga4__Document_History_Detail__c]
    ADD CONSTRAINT [fk_APXTConga4__Document_History_Detail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__UserInformationAssignment__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__UserInformationAssignment__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__exp_configurationItem__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__exp_configurationItem__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__UserInformation__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ff_Engagement__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__fflib_BatchProcess__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__SequenceCounter__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__SequenceCounter__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__fflib_SchedulerConfiguration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ScheduledJobRun__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__fflib_XXXBatchTestOpportunity2__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleMapping__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__SubscriptionMessageType__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__SubscriptionMessageType__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__TaxCode__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__TaxDetail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__TaxDetail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__TaxRate__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__TaxRate__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__TestPublication__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__TestPublication__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__TestSubscription__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProcessRun__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProcessLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProcessLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__PermissionOperationData__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__PermissionOperationData__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__PermissionErrorLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__PermissionErrorLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__fflib_BatchProcessDetail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ScheduledJob__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__MessagingSubscription__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__MessagingPublication__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__MessagingMessage__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__MessagingDelivery__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__MessagingDelivery__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__MessageType__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__Mapping__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__Mapping__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__FeatureEnablementLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__FeatureEnablementLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__FeatureConsoleActivation__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__FeatureConsoleActivation__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ExchangeRateHistory__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ExchangeRateHistory__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ExchangeRateGroup__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ExchangeRateEntry__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ExchangeRateEntry__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ERPProduct__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__DataTransformation__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__DataTransformation__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__DataTransformationTable__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__DSCustomMapping__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__DSCustomMapping__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__DPNodeDeclaration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__DPNodeDeclaration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__Company__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__CompanyTaxInformation__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__CompanySite__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__CompanyCreditTerms__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__CompanyCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__Chunk__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__BillingDocument__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__BillingDocumentLineItem__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__AnalysisItem__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__AccountExtension__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__AccountExtension__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__AccountCreditTerms__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__AccountCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffc__Event__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffc__Event__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__fflib_SchedulerConfiguration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__PaymentTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__ClickLinkAnotherSourceTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__ClickLinkAnotherSourceTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__ClickLinkManagedJob__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__ClickLinkManagedJob__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleAction__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleTargetLineItemTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleTargetLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleButton__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleJob__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleLineLookupTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleLogLineItem__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleLogLineItem__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleLookupTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProcessTracking__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProcessUserGroup__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProductExtension__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProductExtension__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ProductProxy__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_fferpcore__ScheduledJobLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [fferpcore__ScheduledJobLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__PaymentMediaSummaryTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__PaymentMediaDetailTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__PaymentMediaDetailTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__PaymentMediaControlTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__CompanyTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatMapping__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatMappingRecordType__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatMappingJoin__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatMappingJoin__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatMappingField__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatMappingField__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatDocumentConversion__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatDocumentConversion__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatDefinition__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatDefinitionRecordType__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankFormatDefinitionField__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__BankAccountTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__AccountingCurrencyTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffbf__AccountTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ff_frb__Reporting_Component_Configuration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ff_frb__Reporting_Component_Configuration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ff_frb__Report__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ff_frb__Report__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ff_frb__Financial_Statement__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ff_frb__Financial_Statement__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ff_frb__Financial_Report__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ff_frb__Financial_Report__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__abTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__abTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__UEBU__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__UEBU__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Triggered_Send_Execution__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__SupportRequest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__SupportRequest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__SendJunction__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__SendJunction__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__SendDefinition__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__SMSJunction__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__SMSJunction__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__SMSDefinition__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleRelationship__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleSourceLineItemTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleSourceListViewTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleSourceListViewTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleSourceTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_sc_lightning__SightCall__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [sc_lightning__SightCall__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_sc_lightning__SightCall_Session__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_sc_lightning__SightCall_Request__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_sc_lightning__SightCall_Case__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_sc_lightning__Call_Report__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [sc_lightning__Call_Report__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__RH_Job__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__RH_Job__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Rollup_Group__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Rollup_Group__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Rollup_Dummy__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Queue__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Queue__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Export_Rollups__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Exception__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Exception__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__PS_Describe__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__HS_Filter__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__HS_Filter__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_rh2__Filter__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [rh2__Filter__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__fflib_SchedulerConfiguration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__fflib_BatchProcess__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__fflib_BatchProcessDetail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__VatReturn__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__VatReturn__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__VatReportedTransaction__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__VatReportedTransaction__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__VATGroup__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffvat__VATGroupItem__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__fflib_XXXBatchTestOpportunity2__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__fflib_SchedulerConfiguration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__fflib_BatchProcess__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__fflib_BatchProcessDetail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRule__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ffirule__IntegrationRuleTargetTest__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__MC_CDC_Journey__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__MC_CDC_Journey__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Merge_Query__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution_Email_Template__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__IndividualLink__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__IndividualLink__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__IndividualEmailResult__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__IndividualEmailResult__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Email_Linkage__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Email_Linkage__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Configuration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Configuration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Campaign_Member_Configuration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Campaign_Member_Configuration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Business_Unit__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__Automated_Send__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_et4ae5__AggregateLink__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [et4ae5__AggregateLink__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ZipCode__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Transaction_Log__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Transaction_Log__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_TollFreeNumbers__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Validate_Phone_Number__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Validate_Phone_Number__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Test_Table_Custom_Object__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Phone_Validation__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Phone_Validation__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Display_Validation_Field__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Display_Validation_Field__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_DuplicateRecordSet_DuplicateRecordSetId]
        FOREIGN KEY ([DuplicateRecordSetId])
            REFERENCES [DuplicateRecordSet] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Composer_Host_Override__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Composer_Host_Override__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Composer_QuickMerge__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Collection_Solution__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Collection_Solution__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Collection__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Email_Staging__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Email_Template__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Display_Filter__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Display_Filter__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Tigerface5__Display_Configuration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_SightCall_Appointment_Configuration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [SightCall_Appointment_Configuration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_ServiceTerritory_ZipCode__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [ServiceTerritory_ZipCode__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Script__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_SCMFFA__fflib_SchedulerConfiguration__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [SCMFFA__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_SCMFFA__fflib_BatchProcess__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution_Template__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution_Template__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_SCMFFA__fflib_BatchProcessDetail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [SCMFFA__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_SCMFFA__SCM_Product_Mapping__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [SCMFFA__SCM_Product_Mapping__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Rebuttal__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_PromoCode__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Lead_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Contact_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Commissions_Log__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Briefing__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_BriefingLog__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [BriefingLog__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_Account_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXT_BPM__Scheduled_Conductor_History__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXT_BPM__Scheduled_Conductor_History__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXT_BPM__Conductor__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__VersionedData__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__VersionedData__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__EventData__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__EventData__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Document_History__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Document_History_Detail__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Document_History_Detail__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Template__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution_Parameter__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution_Parameter__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution_Report__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution_Report__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordItem]
    ADD CONSTRAINT [fk_DuplicateRecordItem_APXTConga4__Conga_Solution_Query__c_RecordId]
        FOREIGN KEY ([RecordId])
            REFERENCES [APXTConga4__Conga_Solution_Query__c] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordSet]
    ADD CONSTRAINT [fk_DuplicateRecordSet_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [DuplicateRecordSet]
    ADD CONSTRAINT [fk_DuplicateRecordSet_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Email_Linkage__c]
    ADD CONSTRAINT [fk_et4ae5__Email_Linkage__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Email_Linkage__c]
    ADD CONSTRAINT [fk_et4ae5__Email_Linkage__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Email_Linkage__c]
    ADD CONSTRAINT [fk_et4ae5__Email_Linkage__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Case_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Briefing__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_AssignedResource_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [AssignedResource] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_AssetRelationship_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [AssetRelationship] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Asset_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Account_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Commissions_Log__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ContactRequest_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ContactRequest] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Contract_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ContractLineItem_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Entitlement_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Image_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Image] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ListEmail_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ListEmail] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_LiveAgentSession_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [LiveAgentSession] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_LiveChatTranscript_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Location_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_OperatingHoursHoliday_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [OperatingHoursHoliday] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Opportunity_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Order_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ProcessException_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ProcessException] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Product2_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_APXT_BPM__Conductor__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_APXTConga4__Conga_Email_Template__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_APXTConga4__Conga_Email_Staging__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_APXTConga4__Composer_QuickMerge__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_EmailMessage_ReplyToEmailMessageId]
        FOREIGN KEY ([ReplyToEmailMessageId])
            REFERENCES [EmailMessage] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_PromoCode__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Quote_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Rebuttal__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ResourceAbsence_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ResourceAbsence] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Script__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Task_ActivityId]
        FOREIGN KEY ([ActivityId])
            REFERENCES [Task] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Case_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ServiceAppointment_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ServiceContract_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ServiceResource_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Shift_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Shift] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Solution_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Solution] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_SurveyQuestion_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [SurveyQuestion] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_TollFreeNumbers__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_WorkOrder_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_WorkOrderLineItem_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ZipCode__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_Campaign_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_et4ae5__Triggered_Send_Execution__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_fferpcore__BillingDocumentLineItem__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_fferpcore__BillingDocument__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_fferpcore__ProcessRun__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_fferpcore__ProcessUserGroup__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRuleAction__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRuleButton__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRuleJob__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRuleMapping__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRuleRelationship__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffirule__IntegrationRule__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffvat__VATGroupItem__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_ffvat__VATGroup__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_rh2__PS_Export_Rollups__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_rh2__PS_Rollup_Dummy__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_sc_lightning__SightCall_Case__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_sc_lightning__SightCall_Request__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [EmailMessage]
    ADD CONSTRAINT [fk_EmailMessage_sc_lightning__SightCall_Session__c_RelatedToId]
        FOREIGN KEY ([RelatedToId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [et4ae5__SendDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SendDefinition__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SendDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SendDefinition__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SendDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SendDefinition__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillEndorsement]
    ADD CONSTRAINT [fk_ProfileSkillEndorsement_User_UserId]
        FOREIGN KEY ([UserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillEndorsement]
    ADD CONSTRAINT [fk_ProfileSkillEndorsement_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillEndorsement]
    ADD CONSTRAINT [fk_ProfileSkillEndorsement_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillEndorsement]
    ADD CONSTRAINT [fk_ProfileSkillEndorsement_ProfileSkillUser_ProfileSkillUserId]
        FOREIGN KEY ([ProfileSkillUserId])
            REFERENCES [ProfileSkillUser] ([Id])
 ;
 
ALTER TABLE [fferpcore__ff_Engagement__c]
    ADD CONSTRAINT [fk_fferpcore__ff_Engagement__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ff_Engagement__c]
    ADD CONSTRAINT [fk_fferpcore__ff_Engagement__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [fferpcore__ff_Engagement__c]
    ADD CONSTRAINT [fk_fferpcore__ff_Engagement__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ff_Engagement__c]
    ADD CONSTRAINT [fk_fferpcore__ff_Engagement__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EnhancedLetterhead]
    ADD CONSTRAINT [fk_EnhancedLetterhead_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EnhancedLetterhead]
    ADD CONSTRAINT [fk_EnhancedLetterhead_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_ContractLineItem_ContractLineItemId]
        FOREIGN KEY ([ContractLineItemId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_OperatingHours_SvcApptBookingWindowsId]
        FOREIGN KEY ([SvcApptBookingWindowsId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Entitlement]
    ADD CONSTRAINT [fk_Entitlement_ServiceContract_ServiceContractId]
        FOREIGN KEY ([ServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_WorkOrder_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_fferpcore__BillingDocument__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ZipCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_SurveyQuestion_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SurveyQuestion] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Solution_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Solution] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Contact_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Lead_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_et4ae5__Triggered_Send_Execution__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_fferpcore__ProcessUserGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_fferpcore__ProcessRun__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_TollFreeNumbers__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRuleMapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRuleRelationship__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Script__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ServiceAppointment_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ServiceContract_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ServiceResource_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Shift_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Shift] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Case_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Campaign_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Briefing__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_AssignedResource_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [AssignedResource] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_AssetRelationship_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [AssetRelationship] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_APXT_BPM__Conductor__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Account_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_WorkOrderLineItem_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_OperatingHoursHoliday_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [OperatingHoursHoliday] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRuleButton__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRuleAction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRule__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffvat__VATGroupItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Location_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_fferpcore__BillingDocumentLineItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Asset_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_LiveChatTranscript_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_LiveAgentSession_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [LiveAgentSession] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffvat__VATGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_rh2__PS_Export_Rollups__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ListEmail_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ListEmail] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Image_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Image] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Entitlement_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Opportunity_Opportunity__c]
        FOREIGN KEY ([Opportunity__c])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ServiceAppointment_Service_Appointment__c]
        FOREIGN KEY ([Service_Appointment__c])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Account_Person_Account__c]
        FOREIGN KEY ([Person_Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Lead_Lead__c]
        FOREIGN KEY ([Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ServiceAppointment_ServiceAppointmentId]
        FOREIGN KEY ([ServiceAppointmentId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Event_RecurrenceActivityId]
        FOREIGN KEY ([RecurrenceActivityId])
            REFERENCES [Event] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_sc_lightning__SightCall_Session__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_sc_lightning__SightCall_Request__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_sc_lightning__SightCall_Case__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_rh2__PS_Rollup_Dummy__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ContractLineItem_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Contract_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ContactRequest_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ContactRequest] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Commissions_Log__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Opportunity_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Order_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ProcessException_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ProcessException] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Product2_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_APXTConga4__Conga_Email_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_PromoCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Quote_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_APXTConga4__Composer_QuickMerge__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_APXTConga4__Conga_Email_Staging__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ResourceAbsence_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ResourceAbsence] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_Rebuttal__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [Event]
    ADD CONSTRAINT [fk_Event_ffirule__IntegrationRuleJob__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ffc__Event__c]
    ADD CONSTRAINT [fk_ffc__Event__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffc__Event__c]
    ADD CONSTRAINT [fk_ffc__Event__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffc__Event__c]
    ADD CONSTRAINT [fk_ffc__Event__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__EventData__c]
    ADD CONSTRAINT [fk_APXTConga4__EventData__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__EventData__c]
    ADD CONSTRAINT [fk_APXTConga4__EventData__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__EventData__c]
    ADD CONSTRAINT [fk_APXTConga4__EventData__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateEntry__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateEntry__c_fferpcore__ExchangeRateGroup__c_fferpcore__ExchangeRateGroup__c]
        FOREIGN KEY ([fferpcore__ExchangeRateGroup__c])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__ExchangeRateEntry__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateEntry__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateEntry__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateEntry__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateGroup__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateGroup__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateGroup__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateHistory__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateHistory__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateHistory__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateHistory__c_fferpcore__ExchangeRateGroup__c_fferpcore__Group__c]
        FOREIGN KEY ([fferpcore__Group__c])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__ExchangeRateHistory__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateHistory__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ExchangeRateHistory__c]
    ADD CONSTRAINT [fk_fferpcore__ExchangeRateHistory__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureConsoleActivation__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureConsoleActivation__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureConsoleActivation__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureConsoleActivation__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureConsoleActivation__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureConsoleActivation__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureEnablementLog__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureEnablementLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureEnablementLog__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureEnablementLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__FeatureEnablementLog__c]
    ADD CONSTRAINT [fk_fferpcore__FeatureEnablementLog__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_Contact_rh2__Test_Contact__c]
        FOREIGN KEY ([rh2__Test_Contact__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_Account_rh2__Test_Account__c]
        FOREIGN KEY ([rh2__Test_Account__c])
            REFERENCES [Account] ([Id])

 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_Account_rh2__PS_Exception__c]
        FOREIGN KEY ([rh2__PS_Exception__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_rh2__PS_Describe__c_rh2__Test_Describe__c]
        FOREIGN KEY ([rh2__Test_Describe__c])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [rh2__HS_Filter__c]
    ADD CONSTRAINT [fk_rh2__HS_Filter__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_Contact_rh2__Test_Contact__c]
        FOREIGN KEY ([rh2__Test_Contact__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_rh2__PS_Describe__c_rh2__Test_Describe__c]
        FOREIGN KEY ([rh2__Test_Describe__c])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_Account_rh2__Test_Account__c]
        FOREIGN KEY ([rh2__Test_Account__c])
            REFERENCES [Account] ([Id])

 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_Account_rh2__PS_Exception__c]
        FOREIGN KEY ([rh2__PS_Exception__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__Filter__c]
    ADD CONSTRAINT [fk_rh2__Filter__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Report__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Report__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Report__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Report__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Report__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Report__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Statement__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Statement__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Statement__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Statement__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Financial_Statement__c]
    ADD CONSTRAINT [fk_ff_frb__Financial_Statement__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowInterview]
    ADD CONSTRAINT [fk_FlowInterview_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowInterview]
    ADD CONSTRAINT [fk_FlowInterview_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowInterview]
    ADD CONSTRAINT [fk_FlowInterview_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcess__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcess__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcess__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcessDetail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcessDetail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_BatchProcessDetail__c_fferpcore__fflib_BatchProcess__c_fferpcore__BatchProcess__c]
        FOREIGN KEY ([fferpcore__BatchProcess__c])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_SchedulerConfiguration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_SchedulerConfiguration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_SchedulerConfiguration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CollaborationGroup]
    ADD CONSTRAINT [fk_CollaborationGroup_Announcement_AnnouncementId]
        FOREIGN KEY ([AnnouncementId])
            REFERENCES [Announcement] ([Id])
 ;
 
ALTER TABLE [CollaborationGroup]
    ADD CONSTRAINT [fk_CollaborationGroup_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CollaborationGroup]
    ADD CONSTRAINT [fk_CollaborationGroup_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [CollaborationGroup]
    ADD CONSTRAINT [fk_CollaborationGroup_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Idea]
    ADD CONSTRAINT [fk_Idea_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Idea]
    ADD CONSTRAINT [fk_Idea_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Idea]
    ADD CONSTRAINT [fk_Idea_Idea_ParentIdeaId]
        FOREIGN KEY ([ParentIdeaId])
            REFERENCES [Idea] ([Id])
 ;
 
ALTER TABLE [Image]
    ADD CONSTRAINT [fk_Image_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Image]
    ADD CONSTRAINT [fk_Image_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Image]
    ADD CONSTRAINT [fk_Image_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualEmailResult__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualEmailResult__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualEmailResult__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualEmailResult__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualEmailResult__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualEmailResult__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualLink__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualLink__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualLink__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualLink__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__IndividualLink__c]
    ADD CONSTRAINT [fk_et4ae5__IndividualLink__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_Case_SourceId]
        FOREIGN KEY ([SourceId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_AssignedById]
        FOREIGN KEY ([AssignedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_AssignedToId]
        FOREIGN KEY ([AssignedToId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_ArticleCreatedById]
        FOREIGN KEY ([ArticleCreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_ArticleArchivedById]
        FOREIGN KEY ([ArticleArchivedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_ArchivedById]
        FOREIGN KEY ([ArchivedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Knowledge__kav]
    ADD CONSTRAINT [fk_Knowledge__kav_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_PromoCode__c_Promo_Code__c]
        FOREIGN KEY ([Promo_Code__c])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_User_Lead_Qualifier__c]
        FOREIGN KEY ([Lead_Qualifier__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_User_Lead_Rescheduler__c]
        FOREIGN KEY ([Lead_Rescheduler__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_ServiceTerritory_Service_Territory__c]
        FOREIGN KEY ([Service_Territory__c])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_Opportunity_ConvertedOpportunityId]
        FOREIGN KEY ([ConvertedOpportunityId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_Contact_ConvertedContactId]
        FOREIGN KEY ([ConvertedContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_Account_ConvertedAccountId]
        FOREIGN KEY ([ConvertedAccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Lead]
    ADD CONSTRAINT [fk_Lead_Lead_MasterRecordId]
        FOREIGN KEY ([MasterRecordId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItemSchedule]
    ADD CONSTRAINT [fk_OpportunityLineItemSchedule_OpportunityLineItem_OpportunityLineItemId]
        FOREIGN KEY ([OpportunityLineItemId])
            REFERENCES [OpportunityLineItem] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItemSchedule]
    ADD CONSTRAINT [fk_OpportunityLineItemSchedule_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItemSchedule]
    ADD CONSTRAINT [fk_OpportunityLineItemSchedule_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_LiveChatTranscript_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_SocialPost_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [SocialPost] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_Knowledge__kav_KnowledgeArticleVersionId]
        FOREIGN KEY ([KnowledgeArticleVersionId])
            REFERENCES [Knowledge__kav] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_VoiceCall_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [VoiceCall] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_WorkType_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_WorkOrderLineItem_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_WorkOrder_LinkedEntityId]
        FOREIGN KEY ([LinkedEntityId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LinkedArticle]
    ADD CONSTRAINT [fk_LinkedArticle_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ListEmail]
    ADD CONSTRAINT [fk_ListEmail_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ListEmail]
    ADD CONSTRAINT [fk_ListEmail_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ListEmail]
    ADD CONSTRAINT [fk_ListEmail_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ListEmail]
    ADD CONSTRAINT [fk_ListEmail_Campaign_CampaignId]
        FOREIGN KEY ([CampaignId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Location]
    ADD CONSTRAINT [fk_Location_Location_RootLocationId]
        FOREIGN KEY ([RootLocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [Location]
    ADD CONSTRAINT [fk_Location_Location_ParentLocationId]
        FOREIGN KEY ([ParentLocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [Location]
    ADD CONSTRAINT [fk_Location_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Location]
    ADD CONSTRAINT [fk_Location_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Location]
    ADD CONSTRAINT [fk_Location_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LocationTrustMeasure]
    ADD CONSTRAINT [fk_LocationTrustMeasure_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [LocationTrustMeasure]
    ADD CONSTRAINT [fk_LocationTrustMeasure_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LocationTrustMeasure]
    ADD CONSTRAINT [fk_LocationTrustMeasure_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [LocationTrustMeasure]
    ADD CONSTRAINT [fk_LocationTrustMeasure_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Macro]
    ADD CONSTRAINT [fk_Macro_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Macro]
    ADD CONSTRAINT [fk_Macro_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Macro]
    ADD CONSTRAINT [fk_Macro_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ManagedContentVariant]
    ADD CONSTRAINT [fk_ManagedContentVariant_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ManagedContentVariant]
    ADD CONSTRAINT [fk_ManagedContentVariant_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Mapping__c]
    ADD CONSTRAINT [fk_fferpcore__Mapping__c_fferpcore__DataTransformationTable__c_fferpcore__TransformationTable__c]
        FOREIGN KEY ([fferpcore__TransformationTable__c])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__Mapping__c]
    ADD CONSTRAINT [fk_fferpcore__Mapping__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Mapping__c]
    ADD CONSTRAINT [fk_fferpcore__Mapping__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__Mapping__c]
    ADD CONSTRAINT [fk_fferpcore__Mapping__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__MC_CDC_Journey__c]
    ADD CONSTRAINT [fk_et4ae5__MC_CDC_Journey__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__MC_CDC_Journey__c]
    ADD CONSTRAINT [fk_et4ae5__MC_CDC_Journey__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__MC_CDC_Journey__c]
    ADD CONSTRAINT [fk_et4ae5__MC_CDC_Journey__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingMessage__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingMessage__c_fferpcore__MessageType__c_fferpcore__MessageType2__c]
        FOREIGN KEY ([fferpcore__MessageType2__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingMessage__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingMessage__c_fferpcore__MessagingPublication__c_fferpcore__Sender__c]
        FOREIGN KEY ([fferpcore__Sender__c])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingMessage__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingMessage__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingMessage__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingMessage__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingMessage__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingMessage__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessageType__c]
    ADD CONSTRAINT [fk_fferpcore__MessageType__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessageType__c]
    ADD CONSTRAINT [fk_fferpcore__MessageType__c_fferpcore__MessageType__c_fferpcore__Parent__c]
        FOREIGN KEY ([fferpcore__Parent__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessageType__c]
    ADD CONSTRAINT [fk_fferpcore__MessageType__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessageType__c]
    ADD CONSTRAINT [fk_fferpcore__MessageType__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SMSDefinition__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SMSDefinition__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSDefinition__c]
    ADD CONSTRAINT [fk_et4ae5__SMSDefinition__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EntityMilestone]
    ADD CONSTRAINT [fk_EntityMilestone_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [EntityMilestone]
    ADD CONSTRAINT [fk_EntityMilestone_WorkOrder_ParentEntityId]
        FOREIGN KEY ([ParentEntityId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [EntityMilestone]
    ADD CONSTRAINT [fk_EntityMilestone_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ObjectTerritory2AssignmentRule]
    ADD CONSTRAINT [fk_ObjectTerritory2AssignmentRule_Territory2Model_Territory2ModelId]
        FOREIGN KEY ([Territory2ModelId])
            REFERENCES [Territory2Model] ([Id])
 ;
 
ALTER TABLE [ObjectTerritory2AssignmentRule]
    ADD CONSTRAINT [fk_ObjectTerritory2AssignmentRule_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ObjectTerritory2AssignmentRule]
    ADD CONSTRAINT [fk_ObjectTerritory2AssignmentRule_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OperatingHours]
    ADD CONSTRAINT [fk_OperatingHours_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OperatingHours]
    ADD CONSTRAINT [fk_OperatingHours_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OperatingHoursHoliday]
    ADD CONSTRAINT [fk_OperatingHoursHoliday_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OperatingHoursHoliday]
    ADD CONSTRAINT [fk_OperatingHoursHoliday_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OperatingHoursHoliday]
    ADD CONSTRAINT [fk_OperatingHoursHoliday_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Territory2_Territory2Id]
        FOREIGN KEY ([Territory2Id])
            REFERENCES [Territory2] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Quote_SyncedQuoteId]
        FOREIGN KEY ([SyncedQuoteId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Contract_ContractId]
        FOREIGN KEY ([ContractId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_ServiceTerritory_Service_Territory__c]
        FOREIGN KEY ([Service_Territory__c])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_PromoCode__c_Promo_Code__c]
        FOREIGN KEY ([Promo_Code__c])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_Approver__c]
        FOREIGN KEY ([Approver__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_Owner__c]
        FOREIGN KEY ([Owner__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_Campaign_CampaignId]
        FOREIGN KEY ([CampaignId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Opportunity]
    ADD CONSTRAINT [fk_Opportunity_User_Commission_Override__c]
        FOREIGN KEY ([Commission_Override__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityContactRole]
    ADD CONSTRAINT [fk_OpportunityContactRole_Opportunity_OpportunityId]
        FOREIGN KEY ([OpportunityId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [OpportunityContactRole]
    ADD CONSTRAINT [fk_OpportunityContactRole_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [OpportunityContactRole]
    ADD CONSTRAINT [fk_OpportunityContactRole_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityContactRole]
    ADD CONSTRAINT [fk_OpportunityContactRole_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItem]
    ADD CONSTRAINT [fk_OpportunityLineItem_Opportunity_OpportunityId]
        FOREIGN KEY ([OpportunityId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItem]
    ADD CONSTRAINT [fk_OpportunityLineItem_PricebookEntry_PricebookEntryId]
        FOREIGN KEY ([PricebookEntryId])
            REFERENCES [PricebookEntry] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItem]
    ADD CONSTRAINT [fk_OpportunityLineItem_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItem]
    ADD CONSTRAINT [fk_OpportunityLineItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityLineItem]
    ADD CONSTRAINT [fk_OpportunityLineItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityTeamMember]
    ADD CONSTRAINT [fk_OpportunityTeamMember_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityTeamMember]
    ADD CONSTRAINT [fk_OpportunityTeamMember_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityTeamMember]
    ADD CONSTRAINT [fk_OpportunityTeamMember_User_UserId]
        FOREIGN KEY ([UserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OpportunityTeamMember]
    ADD CONSTRAINT [fk_OpportunityTeamMember_Opportunity_OpportunityId]
        FOREIGN KEY ([OpportunityId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationInstance_FlowInterview_InterviewId]
        FOREIGN KEY ([InterviewId])
            REFERENCES [FlowInterview] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationInstance_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationInstance_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStageInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStageInstance_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStageInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStageInstance_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStageInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStageInstance_FlowOrchestrationInstance_OrchestrationInstanceId]
        FOREIGN KEY ([OrchestrationInstanceId])
            REFERENCES [FlowOrchestrationInstance] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStepInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStepInstance_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStepInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStepInstance_FlowOrchestrationInstance_OrchestrationInstanceId]
        FOREIGN KEY ([OrchestrationInstanceId])
            REFERENCES [FlowOrchestrationInstance] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStepInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStepInstance_FlowOrchestrationStageInstance_StageInstanceId]
        FOREIGN KEY ([StageInstanceId])
            REFERENCES [FlowOrchestrationStageInstance] ([Id])
 ;
 
ALTER TABLE [FlowOrchestrationStepInstance]
    ADD CONSTRAINT [fk_FlowOrchestrationStepInstance_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_User_ActivatedById]
        FOREIGN KEY ([ActivatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_Contract_ContractId]
        FOREIGN KEY ([ContractId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_User_CompanyAuthorizedById]
        FOREIGN KEY ([CompanyAuthorizedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_Order_OriginalOrderId]
        FOREIGN KEY ([OriginalOrderId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Order]
    ADD CONSTRAINT [fk_Order_Contact_CustomerAuthorizedById]
        FOREIGN KEY ([CustomerAuthorizedById])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_Order_OrderId]
        FOREIGN KEY ([OrderId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_PricebookEntry_PricebookEntryId]
        FOREIGN KEY ([PricebookEntryId])
            REFERENCES [PricebookEntry] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_OrderItem_OriginalOrderItemId]
        FOREIGN KEY ([OriginalOrderItemId])
            REFERENCES [OrderItem] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [OrderItem]
    ADD CONSTRAINT [fk_OrderItem_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaControlTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaControlTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaControlTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaControlTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaControlTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaControlTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaControlTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaControlTest__c_ffbf__PaymentTest__c_ffbf__Payment__c]
        FOREIGN KEY ([ffbf__Payment__c])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaDetailTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaDetailTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaDetailTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaDetailTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaDetailTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaDetailTest__c_ffbf__PaymentMediaSummaryTest__c_ffbf__PaymentMediaSummary__c]
        FOREIGN KEY ([ffbf__PaymentMediaSummary__c])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__PaymentMediaSummaryTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaSummaryTest__c_ffbf__PaymentMediaControlTest__c_ffbf__PaymentMediaControlTest__c]
        FOREIGN KEY ([ffbf__PaymentMediaControlTest__c])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffbf__PaymentMediaSummaryTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaSummaryTest__c_ffbf__AccountTest__c_ffbf__AccountTest__c]
        FOREIGN KEY ([ffbf__AccountTest__c])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaSummaryTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaSummaryTest__c_ffbf__AccountTest__c_ffbf__Account__c]
        FOREIGN KEY ([ffbf__Account__c])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaSummaryTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaSummaryTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentMediaSummaryTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentMediaSummaryTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentTest__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentTest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentTest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentTest__c_ffbf__AccountingCurrencyTest__c_ffbf__AccountCurrency__c]
        FOREIGN KEY ([ffbf__AccountCurrency__c])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [ffbf__PaymentTest__c]
    ADD CONSTRAINT [fk_ffbf__PaymentTest__c_ffbf__BankAccountTest__c_ffbf__BankAccount__c]
        FOREIGN KEY ([ffbf__BankAccount__c])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionErrorLog__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionErrorLog__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionErrorLog__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionErrorLog__c_User_fferpcore__User__c]
        FOREIGN KEY ([fferpcore__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionErrorLog__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionErrorLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionErrorLog__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionErrorLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionOperationData__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionOperationData__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionOperationData__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionOperationData__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__PermissionOperationData__c]
    ADD CONSTRAINT [fk_fferpcore__PermissionOperationData__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_Lead_Tigerface5__Lead__c]
        FOREIGN KEY ([Tigerface5__Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_Contact_Tigerface5__Contact__c]
        FOREIGN KEY ([Tigerface5__Contact__c])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_Account_Tigerface5__Account__c]
        FOREIGN KEY ([Tigerface5__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Phone_Validation__c]
    ADD CONSTRAINT [fk_Tigerface5__Phone_Validation__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Pricebook2]
    ADD CONSTRAINT [fk_Pricebook2_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Pricebook2]
    ADD CONSTRAINT [fk_Pricebook2_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [PricebookEntry]
    ADD CONSTRAINT [fk_PricebookEntry_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [PricebookEntry]
    ADD CONSTRAINT [fk_PricebookEntry_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [PricebookEntry]
    ADD CONSTRAINT [fk_PricebookEntry_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [PricebookEntry]
    ADD CONSTRAINT [fk_PricebookEntry_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__MessagingDelivery__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__MessagingDelivery__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__MessagingMessage__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__MessagingPublication__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__PermissionOperationData__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__PermissionOperationData__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProcessLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProcessLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProcessRun__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProcessTracking__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__PermissionErrorLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__PermissionErrorLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__MessagingSubscription__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__Mapping__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__Mapping__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__FeatureEnablementLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__FeatureEnablementLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__FeatureConsoleActivation__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__FeatureConsoleActivation__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ExchangeRateHistory__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ExchangeRateHistory__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ExchangeRateGroup__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__MessageType__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__TaxRate__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__TaxRate__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProcessUserGroup__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProductExtension__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProductExtension__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ProductProxy__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ScheduledJobLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ScheduledJobLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ScheduledJobRun__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ScheduledJob__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__SequenceCounter__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__SequenceCounter__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__SubscriptionMessageType__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__SubscriptionMessageType__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__TaxCode__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__TaxDetail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__TaxDetail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__BillingDocumentLineItem__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__AnalysisItem__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__TestPublication__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__TestPublication__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__TestSubscription__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__UserInformationAssignment__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__UserInformationAssignment__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__UserInformation__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__exp_configurationItem__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__exp_configurationItem__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ff_Engagement__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__fflib_BatchProcessDetail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__fflib_BatchProcess__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__fflib_SchedulerConfiguration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__fflib_XXXBatchTestOpportunity2__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__ClickLinkAnotherSourceTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__ClickLinkAnotherSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__ClickLinkManagedJob__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__ClickLinkManagedJob__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleAction__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleButton__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleJob__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleLineLookupTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleLogLineItem__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleLogLineItem__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleLookupTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleMapping__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleRelationship__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleSourceLineItemTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleSourceListViewTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleSourceListViewTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleSourceTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleTargetLineItemTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleTargetLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRuleTargetTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__IntegrationRule__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__fflib_BatchProcessDetail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__fflib_BatchProcess__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__fflib_SchedulerConfiguration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffirule__fflib_XXXBatchTestOpportunity2__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffirule__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__VATGroupItem__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__VATGroup__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__VatReportedTransaction__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__VatReportedTransaction__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__VatReturn__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__VatReturn__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__fflib_BatchProcessDetail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__fflib_BatchProcess__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffvat__fflib_SchedulerConfiguration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffvat__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__Filter__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__Filter__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__HS_Filter__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__HS_Filter__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Describe__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Exception__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Exception__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Export_Rollups__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Queue__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Queue__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Rollup_Dummy__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__PS_Rollup_Group__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__PS_Rollup_Group__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_rh2__RH_Job__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [rh2__RH_Job__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_sc_lightning__Call_Report__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [sc_lightning__Call_Report__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_sc_lightning__SightCall_Case__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_sc_lightning__SightCall_Request__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_sc_lightning__SightCall_Session__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_sc_lightning__SightCall__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [sc_lightning__SightCall__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Case_CaseId]
        FOREIGN KEY ([CaseId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__BillingDocument__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__Chunk__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__CompanyCreditTerms__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__CompanyCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__CompanySite__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__CompanyTaxInformation__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__Company__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__DPNodeDeclaration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__DPNodeDeclaration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__DSCustomMapping__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__DSCustomMapping__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__DataTransformationTable__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__DataTransformation__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__DataTransformation__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ERPProduct__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__ExchangeRateEntry__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__ExchangeRateEntry__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Composer_Host_Override__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Composer_Host_Override__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Composer_QuickMerge__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Collection_Solution__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Collection_Solution__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Collection__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Email_Staging__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Email_Template__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Merge_Query__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution_Email_Template__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution_Parameter__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution_Parameter__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution_Query__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution_Query__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution_Report__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution_Report__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution_Template__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution_Template__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Solution__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Conga_Template__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Document_History_Detail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Document_History_Detail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__Document_History__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__EventData__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__EventData__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXTConga4__VersionedData__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXTConga4__VersionedData__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXT_BPM__Conductor__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_APXT_BPM__Scheduled_Conductor_History__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [APXT_BPM__Scheduled_Conductor_History__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_BriefingLog__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [BriefingLog__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Briefing__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Commissions_Log__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Order_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_OrderItem_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [OrderItem] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_PromoCode__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Rebuttal__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_SCMFFA__SCM_Product_Mapping__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [SCMFFA__SCM_Product_Mapping__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_SCMFFA__fflib_BatchProcessDetail__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [SCMFFA__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_SCMFFA__fflib_BatchProcess__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_SCMFFA__fflib_SchedulerConfiguration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [SCMFFA__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Script__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ServiceTerritory_ZipCode__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ServiceTerritory_ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_SightCall_Appointment_Configuration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [SightCall_Appointment_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Display_Configuration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Display_Filter__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Display_Filter__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Display_Validation_Field__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Display_Validation_Field__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Phone_Validation__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Phone_Validation__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Test_Table_Custom_Object__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Tigerface5__Validate_Phone_Number__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Tigerface5__Validate_Phone_Number__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_TollFreeNumbers__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_Transaction_Log__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [Transaction_Log__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ZipCode__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__AggregateLink__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__AggregateLink__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Automated_Send__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Business_Unit__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Campaign_Member_Configuration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Campaign_Member_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Configuration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Configuration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Email_Linkage__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Email_Linkage__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__IndividualEmailResult__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__IndividualEmailResult__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__IndividualLink__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__IndividualLink__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__MC_CDC_Journey__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__MC_CDC_Journey__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__SMSDefinition__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__SMSJunction__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__SMSJunction__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__SendDefinition__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__SendJunction__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__SendJunction__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__SupportRequest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__SupportRequest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__Triggered_Send_Execution__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__UEBU__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__UEBU__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_et4ae5__abTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [et4ae5__abTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ff_frb__Financial_Report__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ff_frb__Financial_Report__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ff_frb__Financial_Statement__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ff_frb__Financial_Statement__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ff_frb__Report__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ff_frb__Report__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ff_frb__Reporting_Component_Configuration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ff_frb__Reporting_Component_Configuration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__AccountTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__AccountingCurrencyTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankAccountTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatDefinitionField__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatDefinitionRecordType__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatDefinition__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatDocumentConversion__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatDocumentConversion__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatMappingField__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatMappingField__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatMappingJoin__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatMappingJoin__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatMappingRecordType__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__BankFormatMapping__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__CompanyTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__PaymentMediaControlTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__PaymentMediaDetailTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__PaymentMediaDetailTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__PaymentMediaSummaryTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__PaymentTest__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffbf__fflib_SchedulerConfiguration__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffbf__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_ffc__Event__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [ffc__Event__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__AccountCreditTerms__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__AccountCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [ProcessException]
    ADD CONSTRAINT [fk_ProcessException_fferpcore__AccountExtension__c_AttachedToId]
        FOREIGN KEY ([AttachedToId])
            REFERENCES [fferpcore__AccountExtension__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_fferpcore__ProcessUserGroup__c_fferpcore__ProcessUserGroup__c]
        FOREIGN KEY ([fferpcore__ProcessUserGroup__c])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_fferpcore__ProcessRun__c_fferpcore__ProcessRun__c]
        FOREIGN KEY ([fferpcore__ProcessRun__c])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_fferpcore__ProcessRun__c_fferpcore__ParentProcessRun__c]
        FOREIGN KEY ([fferpcore__ParentProcessRun__c])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessLog__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessLog__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessRun__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessRun__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessRun__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessRun__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessRun__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessRun__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessRun__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessRun__c_fferpcore__ProcessRun__c_fferpcore__ParentProcessRun__c]
        FOREIGN KEY ([fferpcore__ParentProcessRun__c])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessRun__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessRun__c_User_fferpcore__StartedBy__c]
        FOREIGN KEY ([fferpcore__StartedBy__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessTracking__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessTracking__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessTracking__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessTracking__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessTracking__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessTracking__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessUserGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessUserGroup__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessUserGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessUserGroup__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessUserGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessUserGroup__c_fferpcore__ProcessRun__c_fferpcore__ProcessRun__c]
        FOREIGN KEY ([fferpcore__ProcessRun__c])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessUserGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessUserGroup__c_User_fferpcore__User__c]
        FOREIGN KEY ([fferpcore__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProcessUserGroup__c]
    ADD CONSTRAINT [fk_fferpcore__ProcessUserGroup__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Product2]
    ADD CONSTRAINT [fk_Product2_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Product2]
    ADD CONSTRAINT [fk_Product2_fferpcore__TaxCode__c_fferpcore__TaxCode__c]
        FOREIGN KEY ([fferpcore__TaxCode__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [Product2]
    ADD CONSTRAINT [fk_Product2_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductExtension__c]
    ADD CONSTRAINT [fk_fferpcore__ProductExtension__c_Product2_fferpcore__Product__c]
        FOREIGN KEY ([fferpcore__Product__c])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductExtension__c]
    ADD CONSTRAINT [fk_fferpcore__ProductExtension__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductExtension__c]
    ADD CONSTRAINT [fk_fferpcore__ProductExtension__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductExtension__c]
    ADD CONSTRAINT [fk_fferpcore__ProductExtension__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [PromoCode__c]
    ADD CONSTRAINT [fk_PromoCode__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [PromoCode__c]
    ADD CONSTRAINT [fk_PromoCode__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [PromoCode__c]
    ADD CONSTRAINT [fk_PromoCode__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductProxy__c]
    ADD CONSTRAINT [fk_fferpcore__ProductProxy__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductProxy__c]
    ADD CONSTRAINT [fk_fferpcore__ProductProxy__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ProductProxy__c]
    ADD CONSTRAINT [fk_fferpcore__ProductProxy__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_fferpcore__MessagingSubscription__c_fferpcore__LinkControlFor__c]
        FOREIGN KEY ([fferpcore__LinkControlFor__c])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_fferpcore__ERPProduct__c_fferpcore__OwnerProduct__c]
        FOREIGN KEY ([fferpcore__OwnerProduct__c])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_fferpcore__ProductProxy__c_fferpcore__ProductProxy__c]
        FOREIGN KEY ([fferpcore__ProductProxy__c])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__MessagingPublication__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingPublication__c_fferpcore__MessageType__c_fferpcore__MessageType__c]
        FOREIGN KEY ([fferpcore__MessageType__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])

 ;
 
ALTER TABLE [QuickText]
    ADD CONSTRAINT [fk_QuickText_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [QuickText]
    ADD CONSTRAINT [fk_QuickText_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [QuickText]
    ADD CONSTRAINT [fk_QuickText_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_Opportunity_OpportunityId]
        FOREIGN KEY ([OpportunityId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_Contract_ContractId]
        FOREIGN KEY ([ContractId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [Quote]
    ADD CONSTRAINT [fk_Quote_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_OpportunityLineItem_OpportunityLineItemId]
        FOREIGN KEY ([OpportunityLineItemId])
            REFERENCES [OpportunityLineItem] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_PricebookEntry_PricebookEntryId]
        FOREIGN KEY ([PricebookEntryId])
            REFERENCES [PricebookEntry] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [QuoteLineItem]
    ADD CONSTRAINT [fk_QuoteLineItem_Quote_QuoteId]
        FOREIGN KEY ([QuoteId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [Rebuttal__c]
    ADD CONSTRAINT [fk_Rebuttal__c_User_User__c]
        FOREIGN KEY ([User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Rebuttal__c]
    ADD CONSTRAINT [fk_Rebuttal__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Rebuttal__c]
    ADD CONSTRAINT [fk_Rebuttal__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Rebuttal__c]
    ADD CONSTRAINT [fk_Rebuttal__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Recommendation]
    ADD CONSTRAINT [fk_Recommendation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Recommendation]
    ADD CONSTRAINT [fk_Recommendation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ERPProduct__c]
    ADD CONSTRAINT [fk_fferpcore__ERPProduct__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ERPProduct__c]
    ADD CONSTRAINT [fk_fferpcore__ERPProduct__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ERPProduct__c]
    ADD CONSTRAINT [fk_fferpcore__ERPProduct__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Report__c]
    ADD CONSTRAINT [fk_ff_frb__Report__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Report__c]
    ADD CONSTRAINT [fk_ff_frb__Report__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Report__c]
    ADD CONSTRAINT [fk_ff_frb__Report__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Reporting_Component_Configuration__c]
    ADD CONSTRAINT [fk_ff_frb__Reporting_Component_Configuration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Reporting_Component_Configuration__c]
    ADD CONSTRAINT [fk_ff_frb__Reporting_Component_Configuration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ff_frb__Reporting_Component_Configuration__c]
    ADD CONSTRAINT [fk_ff_frb__Reporting_Component_Configuration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ResourceAbsence]
    ADD CONSTRAINT [fk_ResourceAbsence_ServiceResource_ResourceId]
        FOREIGN KEY ([ResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [ResourceAbsence]
    ADD CONSTRAINT [fk_ResourceAbsence_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ResourceAbsence]
    ADD CONSTRAINT [fk_ResourceAbsence_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ResourcePreference]
    ADD CONSTRAINT [fk_ResourcePreference_Account_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ResourcePreference]
    ADD CONSTRAINT [fk_ResourcePreference_ServiceResource_ServiceResourceId]
        FOREIGN KEY ([ServiceResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [ResourcePreference]
    ADD CONSTRAINT [fk_ResourcePreference_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ResourcePreference]
    ADD CONSTRAINT [fk_ResourcePreference_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ResourcePreference]
    ADD CONSTRAINT [fk_ResourcePreference_WorkOrder_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Export_Rollups__c]
    ADD CONSTRAINT [fk_rh2__PS_Export_Rollups__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Export_Rollups__c]
    ADD CONSTRAINT [fk_rh2__PS_Export_Rollups__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Export_Rollups__c]
    ADD CONSTRAINT [fk_rh2__PS_Export_Rollups__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Group__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Group__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Group__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Group__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Rollup_Group__c]
    ADD CONSTRAINT [fk_rh2__PS_Rollup_Group__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Exception__c]
    ADD CONSTRAINT [fk_rh2__PS_Exception__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Exception__c]
    ADD CONSTRAINT [fk_rh2__PS_Exception__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Exception__c]
    ADD CONSTRAINT [fk_rh2__PS_Exception__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__RH_Job__c]
    ADD CONSTRAINT [fk_rh2__RH_Job__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__RH_Job__c]
    ADD CONSTRAINT [fk_rh2__RH_Job__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__RH_Job__c]
    ADD CONSTRAINT [fk_rh2__RH_Job__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Queue__c]
    ADD CONSTRAINT [fk_rh2__PS_Queue__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Queue__c]
    ADD CONSTRAINT [fk_rh2__PS_Queue__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [rh2__PS_Queue__c]
    ADD CONSTRAINT [fk_rh2__PS_Queue__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Scheduled_Conductor_History__c]
    ADD CONSTRAINT [fk_APXT_BPM__Scheduled_Conductor_History__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Scheduled_Conductor_History__c]
    ADD CONSTRAINT [fk_APXT_BPM__Scheduled_Conductor_History__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Scheduled_Conductor_History__c]
    ADD CONSTRAINT [fk_APXT_BPM__Scheduled_Conductor_History__c_APXT_BPM__Conductor__c_APXT_BPM__Conga_Conductor__c]
        FOREIGN KEY ([APXT_BPM__Conga_Conductor__c])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Scheduled_Conductor_History__c]
    ADD CONSTRAINT [fk_APXT_BPM__Scheduled_Conductor_History__c_User_APXT_BPM__Ran_as__c]
        FOREIGN KEY ([APXT_BPM__Ran_as__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXT_BPM__Scheduled_Conductor_History__c]
    ADD CONSTRAINT [fk_APXT_BPM__Scheduled_Conductor_History__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJob__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJob__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJob__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJob__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJob__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJob__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobLog__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobLog__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobLog__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobLog__c_fferpcore__ScheduledJobRun__c_fferpcore__BatchRun__c]
        FOREIGN KEY ([fferpcore__BatchRun__c])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__ScheduledJobLog__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobLog__c_fferpcore__BillingDocument__c_fferpcore__BillingDocument__c]
        FOREIGN KEY ([fferpcore__BillingDocument__c])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobLog__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobLog__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobRun__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobRun__c_fferpcore__fflib_BatchProcess__c_fferpcore__BatchProcess__c]
        FOREIGN KEY ([fferpcore__BatchProcess__c])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobRun__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobRun__c_fferpcore__ScheduledJob__c_fferpcore__Process__c]
        FOREIGN KEY ([fferpcore__Process__c])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__ScheduledJobRun__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobRun__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__ScheduledJobRun__c]
    ADD CONSTRAINT [fk_fferpcore__ScheduledJobRun__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffvat__fflib_SchedulerConfiguration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffvat__fflib_SchedulerConfiguration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffvat__fflib_SchedulerConfiguration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffirule__fflib_SchedulerConfiguration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffirule__fflib_SchedulerConfiguration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_ffirule__fflib_SchedulerConfiguration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcess__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcess__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcess__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcess__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcessDetail__c_SCMFFA__fflib_BatchProcess__c_SCMFFA__BatchProcess__c]
        FOREIGN KEY ([SCMFFA__BatchProcess__c])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcessDetail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_BatchProcessDetail__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_BatchProcessDetail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_SchedulerConfiguration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_SchedulerConfiguration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SCMFFA__fflib_SchedulerConfiguration__c]
    ADD CONSTRAINT [fk_SCMFFA__fflib_SchedulerConfiguration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Scorecard]
    ADD CONSTRAINT [fk_Scorecard_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Scorecard]
    ADD CONSTRAINT [fk_Scorecard_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Scorecard]
    ADD CONSTRAINT [fk_Scorecard_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ScorecardAssociation]
    ADD CONSTRAINT [fk_ScorecardAssociation_Account_TargetEntityId]
        FOREIGN KEY ([TargetEntityId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ScorecardAssociation]
    ADD CONSTRAINT [fk_ScorecardAssociation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ScorecardAssociation]
    ADD CONSTRAINT [fk_ScorecardAssociation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ScorecardAssociation]
    ADD CONSTRAINT [fk_ScorecardAssociation_Scorecard_ScorecardId]
        FOREIGN KEY ([ScorecardId])
            REFERENCES [Scorecard] ([Id])
 ;
 
ALTER TABLE [ScorecardMetric]
    ADD CONSTRAINT [fk_ScorecardMetric_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ScorecardMetric]
    ADD CONSTRAINT [fk_ScorecardMetric_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ScorecardMetric]
    ADD CONSTRAINT [fk_ScorecardMetric_Scorecard_ScorecardId]
        FOREIGN KEY ([ScorecardId])
            REFERENCES [Scorecard] ([Id])
 ;
 
ALTER TABLE [Script__c]
    ADD CONSTRAINT [fk_Script__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Script__c]
    ADD CONSTRAINT [fk_Script__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Script__c]
    ADD CONSTRAINT [fk_Script__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SendJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SendJunction__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SendJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SendJunction__c_et4ae5__SendDefinition__c_et4ae5__SendDefinition__c]
        FOREIGN KEY ([et4ae5__SendDefinition__c])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__SendJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SendJunction__c_Campaign_et4ae5__Campaign__c]
        FOREIGN KEY ([et4ae5__Campaign__c])
            REFERENCES [Campaign] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__SendJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SendJunction__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__SequenceCounter__c]
    ADD CONSTRAINT [fk_fferpcore__SequenceCounter__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__SequenceCounter__c]
    ADD CONSTRAINT [fk_fferpcore__SequenceCounter__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__SequenceCounter__c]
    ADD CONSTRAINT [fk_fferpcore__SequenceCounter__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_WorkOrderLineItem_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_WorkOrder_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_User_Confirmer_User__c]
        FOREIGN KEY ([Confirmer_User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_ServiceAppointment_Service_Appointment__c]
        FOREIGN KEY ([Service_Appointment__c])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_WorkTypeGroup_Work_Type_Group__c]
        FOREIGN KEY ([Work_Type_Group__c])
            REFERENCES [WorkTypeGroup] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Lead_Lead__c]
        FOREIGN KEY ([Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Account_Person_Account__c]
        FOREIGN KEY ([Person_Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Opportunity_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Lead_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Asset_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_Account_ParentRecordId]
        FOREIGN KEY ([ParentRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceAppointment]
    ADD CONSTRAINT [fk_ServiceAppointment_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_ServiceContract_ParentServiceContractId]
        FOREIGN KEY ([ParentServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_ServiceContract_RootServiceContractId]
        FOREIGN KEY ([RootServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [ServiceContract]
    ADD CONSTRAINT [fk_ServiceContract_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_User_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ServiceResource]
    ADD CONSTRAINT [fk_ServiceResource_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResourceSkill]
    ADD CONSTRAINT [fk_ServiceResourceSkill_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResourceSkill]
    ADD CONSTRAINT [fk_ServiceResourceSkill_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceResourceSkill]
    ADD CONSTRAINT [fk_ServiceResourceSkill_ServiceResource_ServiceResourceId]
        FOREIGN KEY ([ServiceResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_ServiceTerritory_ParentTerritoryId]
        FOREIGN KEY ([ParentTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_ServiceTerritory_TopLevelTerritoryId]
        FOREIGN KEY ([TopLevelTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory]
    ADD CONSTRAINT [fk_ServiceTerritory_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryMember]
    ADD CONSTRAINT [fk_ServiceTerritoryMember_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryMember]
    ADD CONSTRAINT [fk_ServiceTerritoryMember_ServiceResource_ServiceResourceId]
        FOREIGN KEY ([ServiceResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryMember]
    ADD CONSTRAINT [fk_ServiceTerritoryMember_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryMember]
    ADD CONSTRAINT [fk_ServiceTerritoryMember_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryMember]
    ADD CONSTRAINT [fk_ServiceTerritoryMember_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryWorkType]
    ADD CONSTRAINT [fk_ServiceTerritoryWorkType_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryWorkType]
    ADD CONSTRAINT [fk_ServiceTerritoryWorkType_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryWorkType]
    ADD CONSTRAINT [fk_ServiceTerritoryWorkType_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritoryWorkType]
    ADD CONSTRAINT [fk_ServiceTerritoryWorkType_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory_ZipCode__c]
    ADD CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory_ZipCode__c]
    ADD CONSTRAINT [fk_ServiceTerritory_ZipCode__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ServiceTerritory_ZipCode__c]
    ADD CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ServiceTerritory_Service_Territory__c]
        FOREIGN KEY ([Service_Territory__c])
            REFERENCES [ServiceTerritory] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ServiceTerritory_ZipCode__c]
    ADD CONSTRAINT [fk_ServiceTerritory_ZipCode__c_ZipCode__c_Zip_Code_Center__c]
        FOREIGN KEY ([Zip_Code_Center__c])
            REFERENCES [ZipCode__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [Shift]
    ADD CONSTRAINT [fk_Shift_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Shift]
    ADD CONSTRAINT [fk_Shift_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Shift]
    ADD CONSTRAINT [fk_Shift_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Shift]
    ADD CONSTRAINT [fk_Shift_ServiceResource_ServiceResourceId]
        FOREIGN KEY ([ServiceResourceId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [Shift]
    ADD CONSTRAINT [fk_Shift_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SightCall_Appointment_Configuration__c]
    ADD CONSTRAINT [fk_SightCall_Appointment_Configuration__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SightCall_Appointment_Configuration__c]
    ADD CONSTRAINT [fk_SightCall_Appointment_Configuration__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SightCall_Appointment_Configuration__c]
    ADD CONSTRAINT [fk_SightCall_Appointment_Configuration__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Case__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Case__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Case__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Case__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Case__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Case__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Request__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Request__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Request__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Request__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Request__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Request__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Session__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Session__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Session__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Session__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [sc_lightning__SightCall_Session__c]
    ADD CONSTRAINT [fk_sc_lightning__SightCall_Session__c_Case_sc_lightning__case__c]
        FOREIGN KEY ([sc_lightning__case__c])
            REFERENCES [Case] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ProfileSkill]
    ADD CONSTRAINT [fk_ProfileSkill_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkill]
    ADD CONSTRAINT [fk_ProfileSkill_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkill]
    ADD CONSTRAINT [fk_ProfileSkill_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SkillRequirement]
    ADD CONSTRAINT [fk_SkillRequirement_WorkOrderLineItem_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [SkillRequirement]
    ADD CONSTRAINT [fk_SkillRequirement_WorkType_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [SkillRequirement]
    ADD CONSTRAINT [fk_SkillRequirement_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SkillRequirement]
    ADD CONSTRAINT [fk_SkillRequirement_WorkOrder_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [SkillRequirement]
    ADD CONSTRAINT [fk_SkillRequirement_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillUser]
    ADD CONSTRAINT [fk_ProfileSkillUser_User_UserId]
        FOREIGN KEY ([UserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillUser]
    ADD CONSTRAINT [fk_ProfileSkillUser_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillUser]
    ADD CONSTRAINT [fk_ProfileSkillUser_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ProfileSkillUser]
    ADD CONSTRAINT [fk_ProfileSkillUser_ProfileSkill_ProfileSkillId]
        FOREIGN KEY ([ProfileSkillId])
            REFERENCES [ProfileSkill] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SMSJunction__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SMSJunction__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SMSJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SMSJunction__c_et4ae5__SMSDefinition__c_et4ae5__SMSDefinition__c]
        FOREIGN KEY ([et4ae5__SMSDefinition__c])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__SMSJunction__c]
    ADD CONSTRAINT [fk_et4ae5__SMSJunction__c_Campaign_et4ae5__Campaign__c]
        FOREIGN KEY ([et4ae5__Campaign__c])
            REFERENCES [Campaign] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_Account_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_Contact_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_Lead_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_SocialPost_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [SocialPost] ([Id])
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPersona]
    ADD CONSTRAINT [fk_SocialPersona_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_SocialPost_ReplyToId]
        FOREIGN KEY ([ReplyToId])
            REFERENCES [SocialPost] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_Contact_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_Lead_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_User_DeletedById]
        FOREIGN KEY ([DeletedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_User_HiddenById]
        FOREIGN KEY ([HiddenById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_Account_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_Case_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [SocialPost]
    ADD CONSTRAINT [fk_SocialPost_SocialPersona_PersonaId]
        FOREIGN KEY ([PersonaId])
            REFERENCES [SocialPersona] ([Id])
 ;
 
ALTER TABLE [Solution]
    ADD CONSTRAINT [fk_Solution_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Solution]
    ADD CONSTRAINT [fk_Solution_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Solution]
    ADD CONSTRAINT [fk_Solution_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_fferpcore__ProductProxy__c_fferpcore__ProductProxy__c]
        FOREIGN KEY ([fferpcore__ProductProxy__c])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_fferpcore__ERPProduct__c_fferpcore__OwnerProduct__c]
        FOREIGN KEY ([fferpcore__OwnerProduct__c])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_fferpcore__MessagingPublication__c_fferpcore__LinkControlFor__c]
        FOREIGN KEY ([fferpcore__LinkControlFor__c])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_fferpcore__MessageType__c_fferpcore__MessageType__c]
        FOREIGN KEY ([fferpcore__MessageType__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__MessagingSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__MessagingSubscription__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__SubscriptionMessageType__c]
    ADD CONSTRAINT [fk_fferpcore__SubscriptionMessageType__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__SubscriptionMessageType__c]
    ADD CONSTRAINT [fk_fferpcore__SubscriptionMessageType__c_fferpcore__MessagingSubscription__c_fferpcore__Subscription__c]
        FOREIGN KEY ([fferpcore__Subscription__c])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__SubscriptionMessageType__c]
    ADD CONSTRAINT [fk_fferpcore__SubscriptionMessageType__c_fferpcore__MessageType__c_fferpcore__MessageType__c]
        FOREIGN KEY ([fferpcore__MessageType__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__SubscriptionMessageType__c]
    ADD CONSTRAINT [fk_fferpcore__SubscriptionMessageType__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SupportRequest__c]
    ADD CONSTRAINT [fk_et4ae5__SupportRequest__c_et4ae5__SendDefinition__c_et4ae5__Send_Definition__c]
        FOREIGN KEY ([et4ae5__Send_Definition__c])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__SupportRequest__c]
    ADD CONSTRAINT [fk_et4ae5__SupportRequest__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__SupportRequest__c]
    ADD CONSTRAINT [fk_et4ae5__SupportRequest__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Survey]
    ADD CONSTRAINT [fk_Survey_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Survey]
    ADD CONSTRAINT [fk_Survey_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Survey]
    ADD CONSTRAINT [fk_Survey_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Survey]
    ADD CONSTRAINT [fk_Survey_SurveyVersion_ActiveVersionId]
        FOREIGN KEY ([ActiveVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [Survey]
    ADD CONSTRAINT [fk_Survey_SurveyVersion_LatestVersionId]
        FOREIGN KEY ([LatestVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_Contact_ParticipantId]
        FOREIGN KEY ([ParticipantId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_Survey_SurveyId]
        FOREIGN KEY ([SurveyId])
            REFERENCES [Survey] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_Lead_ParticipantId]
        FOREIGN KEY ([ParticipantId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_User_ParticipantId]
        FOREIGN KEY ([ParticipantId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_User_UserId]
        FOREIGN KEY ([UserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_Lead_LeadId]
        FOREIGN KEY ([LeadId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SurveyInvitation]
    ADD CONSTRAINT [fk_SurveyInvitation_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SurveyQuestion]
    ADD CONSTRAINT [fk_SurveyQuestion_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestion]
    ADD CONSTRAINT [fk_SurveyQuestion_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestion]
    ADD CONSTRAINT [fk_SurveyQuestion_SurveyVersion_SurveyVersionId]
        FOREIGN KEY ([SurveyVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionChoice]
    ADD CONSTRAINT [fk_SurveyQuestionChoice_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionChoice]
    ADD CONSTRAINT [fk_SurveyQuestionChoice_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionChoice]
    ADD CONSTRAINT [fk_SurveyQuestionChoice_SurveyQuestion_QuestionId]
        FOREIGN KEY ([QuestionId])
            REFERENCES [SurveyQuestion] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionChoice]
    ADD CONSTRAINT [fk_SurveyQuestionChoice_SurveyVersion_SurveyVersionId]
        FOREIGN KEY ([SurveyVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_SurveyResponse_ResponseId]
        FOREIGN KEY ([ResponseId])
            REFERENCES [SurveyResponse] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_SurveyQuestion_QuestionId]
        FOREIGN KEY ([QuestionId])
            REFERENCES [SurveyQuestion] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_SurveyQuestionChoice_QuestionChoiceId]
        FOREIGN KEY ([QuestionChoiceId])
            REFERENCES [SurveyQuestionChoice] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_SurveyVersion_SurveyVersionId]
        FOREIGN KEY ([SurveyVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [SurveyQuestionResponse]
    ADD CONSTRAINT [fk_SurveyQuestionResponse_SurveyInvitation_InvitationId]
        FOREIGN KEY ([InvitationId])
            REFERENCES [SurveyInvitation] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_User_SubmitterId]
        FOREIGN KEY ([SubmitterId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_SurveyVersion_SurveyVersionId]
        FOREIGN KEY ([SurveyVersionId])
            REFERENCES [SurveyVersion] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_Survey_SurveyId]
        FOREIGN KEY ([SurveyId])
            REFERENCES [Survey] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_Lead_SubmitterId]
        FOREIGN KEY ([SubmitterId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_Contact_SubmitterId]
        FOREIGN KEY ([SubmitterId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_FlowInterview_InterviewId]
        FOREIGN KEY ([InterviewId])
            REFERENCES [FlowInterview] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_SurveyInvitation_InvitationId]
        FOREIGN KEY ([InvitationId])
            REFERENCES [SurveyInvitation] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyResponse]
    ADD CONSTRAINT [fk_SurveyResponse_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__RH_Job__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__RH_Job__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_sc_lightning__Call_Report__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [sc_lightning__Call_Report__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_sc_lightning__SightCall_Case__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_sc_lightning__SightCall_Request__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_sc_lightning__SightCall_Session__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_sc_lightning__SightCall__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [sc_lightning__SightCall__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Queue__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Queue__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Export_Rollups__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Exception__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Exception__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Describe__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Describe__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__HS_Filter__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__HS_Filter__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__Filter__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__Filter__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__fflib_SchedulerConfiguration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__fflib_BatchProcess__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__fflib_BatchProcessDetail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__VatReturn__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__VatReturn__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__VatReportedTransaction__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__VatReportedTransaction__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__VATGroup__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffvat__VATGroupItem__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__fflib_XXXBatchTestOpportunity2__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__fflib_SchedulerConfiguration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__fflib_BatchProcess__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__fflib_BatchProcessDetail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Rollup_Dummy__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_rh2__PS_Rollup_Group__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [rh2__PS_Rollup_Group__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SurveyInvitation_SurveyInvitationId]
        FOREIGN KEY ([SurveyInvitationId])
            REFERENCES [SurveyInvitation] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SurveyResponse_SurveyResponseId]
        FOREIGN KEY ([SurveyResponseId])
            REFERENCES [SurveyResponse] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Survey_SurveyId]
        FOREIGN KEY ([SurveyId])
            REFERENCES [Survey] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleSourceLineItemTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleSourceLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleRelationship__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleMapping__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleLookupTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleLookupTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleLogLineItem__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleLogLineItem__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleLineLookupTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleLineLookupTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleJob__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleButton__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleAction__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__ClickLinkManagedJob__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__ClickLinkManagedJob__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleSourceListViewTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleSourceListViewTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleSourceTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleSourceTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleTargetLineItemTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleTargetLineItemTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRuleTargetTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRuleTargetTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__IntegrationRule__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffirule__ClickLinkAnotherSourceTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffirule__ClickLinkAnotherSourceTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__fflib_XXXBatchTestOpportunity2__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__fflib_XXXBatchTestOpportunity2__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__fflib_SchedulerConfiguration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__fflib_BatchProcess__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SurveyInvitation_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [SurveyInvitation] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SurveyResponse_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [SurveyResponse] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Composer_Host_Override__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Composer_Host_Override__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Composer_QuickMerge__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Collection_Solution__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Collection_Solution__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Collection__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Collection__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Email_Staging__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Email_Template__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Merge_Query__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Merge_Query__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution_Email_Template__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution_Parameter__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution_Parameter__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution_Query__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution_Query__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution_Report__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution_Report__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution_Template__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution_Template__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Solution__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Solution__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Conga_Template__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Conga_Template__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Document_History_Detail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Document_History_Detail__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__Document_History__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__Document_History__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__EventData__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__EventData__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXTConga4__VersionedData__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXTConga4__VersionedData__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXT_BPM__Conductor__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_APXT_BPM__Scheduled_Conductor_History__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [APXT_BPM__Scheduled_Conductor_History__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Account_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Asset_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_BriefingLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [BriefingLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Briefing__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Campaign_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Case_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Commissions_Log__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Contact_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Event_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Event] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Lead_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_LiveChatTranscript_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Opportunity_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Order_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Product2_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_PromoCode__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Rebuttal__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SCMFFA__SCM_Product_Mapping__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [SCMFFA__SCM_Product_Mapping__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SCMFFA__fflib_BatchProcessDetail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [SCMFFA__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SCMFFA__fflib_BatchProcess__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [SCMFFA__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SCMFFA__fflib_SchedulerConfiguration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [SCMFFA__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Script__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ServiceAppointment_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ServiceResource_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ServiceTerritory_ZipCode__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ServiceTerritory_ZipCode__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_SightCall_Appointment_Configuration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [SightCall_Appointment_Configuration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Solution_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Solution] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Task_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Task] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Display_Configuration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Display_Filter__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Display_Filter__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Display_Validation_Field__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Display_Validation_Field__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Phone_Validation__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Phone_Validation__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Test_Table_Custom_Object__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Tigerface5__Validate_Phone_Number__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Tigerface5__Validate_Phone_Number__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_TollFreeNumbers__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_Transaction_Log__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [Transaction_Log__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_User_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_VideoCall_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [VideoCall] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_VoiceCall_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [VoiceCall] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_WorkOrder_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ZipCode__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__AggregateLink__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__AggregateLink__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Automated_Send__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Business_Unit__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Campaign_Member_Configuration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Campaign_Member_Configuration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Configuration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Configuration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Email_Linkage__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Email_Linkage__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__IndividualEmailResult__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__IndividualEmailResult__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__IndividualLink__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__IndividualLink__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__MC_CDC_Journey__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__MC_CDC_Journey__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__SMSDefinition__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__SMSDefinition__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__SMSJunction__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__SMSJunction__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__SendDefinition__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__SendDefinition__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__SendJunction__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__SendJunction__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__SupportRequest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__SupportRequest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__Triggered_Send_Execution__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__UEBU__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__UEBU__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_et4ae5__abTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [et4ae5__abTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ff_frb__Financial_Report__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ff_frb__Financial_Report__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ff_frb__Financial_Statement__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ff_frb__Financial_Statement__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ff_frb__Report__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ff_frb__Report__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ff_frb__Reporting_Component_Configuration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ff_frb__Reporting_Component_Configuration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__AccountTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__AccountTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__AccountingCurrencyTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__AccountingCurrencyTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankAccountTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankAccountTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatDefinitionField__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatDefinitionField__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatDefinitionRecordType__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatDefinitionRecordType__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatDefinition__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatDefinition__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatDocumentConversion__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatDocumentConversion__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatMappingField__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatMappingField__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatMappingJoin__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatMappingJoin__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatMappingRecordType__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatMappingRecordType__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__BankFormatMapping__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__BankFormatMapping__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__CompanyTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__CompanyTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__PaymentMediaControlTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__PaymentMediaControlTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__PaymentMediaDetailTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__PaymentMediaDetailTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__PaymentMediaSummaryTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__PaymentMediaSummaryTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__PaymentTest__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__PaymentTest__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffbf__fflib_SchedulerConfiguration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffbf__fflib_SchedulerConfiguration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_ffc__Event__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [ffc__Event__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__AccountCreditTerms__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__AccountCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__AccountExtension__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__AccountExtension__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__AnalysisItem__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__AnalysisItem__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__BillingDocumentLineItem__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__BillingDocument__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__Chunk__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__Chunk__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__CompanyCreditTerms__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__CompanyCreditTerms__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__CompanySite__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__CompanySite__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__CompanyTaxInformation__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__CompanyTaxInformation__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__Company__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__Company__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__DPNodeDeclaration__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__DPNodeDeclaration__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__DSCustomMapping__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__DSCustomMapping__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__DataTransformationTable__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__DataTransformationTable__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__DataTransformation__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__DataTransformation__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ERPProduct__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ERPProduct__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ExchangeRateEntry__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ExchangeRateEntry__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ExchangeRateGroup__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ExchangeRateGroup__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ExchangeRateHistory__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ExchangeRateHistory__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__FeatureConsoleActivation__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__FeatureConsoleActivation__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__FeatureEnablementLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__FeatureEnablementLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__Mapping__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__Mapping__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__MessageType__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__MessageType__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__MessagingDelivery__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__MessagingDelivery__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__MessagingMessage__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__MessagingMessage__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__MessagingPublication__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__MessagingPublication__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__MessagingSubscription__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__MessagingSubscription__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__PermissionErrorLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__PermissionErrorLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__PermissionOperationData__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__PermissionOperationData__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProcessLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProcessLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProcessRun__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProcessTracking__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProcessTracking__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProcessUserGroup__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProductExtension__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProductExtension__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ProductProxy__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ProductProxy__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ScheduledJobLog__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ScheduledJobLog__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ScheduledJobRun__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ScheduledJobRun__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ScheduledJob__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ScheduledJob__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__SequenceCounter__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__SequenceCounter__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__SubscriptionMessageType__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__SubscriptionMessageType__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__TaxCode__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__TaxDetail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__TaxDetail__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__TaxRate__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__TaxRate__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__TestPublication__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__TestPublication__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__TestSubscription__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__UserInformationAssignment__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__UserInformationAssignment__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__UserInformation__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__exp_configurationItem__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__exp_configurationItem__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__ff_Engagement__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__ff_Engagement__c] ([Id])
 ;
 
ALTER TABLE [SurveySubject]
    ADD CONSTRAINT [fk_SurveySubject_fferpcore__fflib_BatchProcessDetail__c_SubjectId]
        FOREIGN KEY ([SubjectId])
            REFERENCES [fferpcore__fflib_BatchProcessDetail__c] ([Id])
 ;
 
ALTER TABLE [SurveyVersion]
    ADD CONSTRAINT [fk_SurveyVersion_Survey_SurveyId]
        FOREIGN KEY ([SurveyId])
            REFERENCES [Survey] ([Id])
 ;
 
ALTER TABLE [SurveyVersion]
    ADD CONSTRAINT [fk_SurveyVersion_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [SurveyVersion]
    ADD CONSTRAINT [fk_SurveyVersion_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Opportunity_Opportunity__c]
        FOREIGN KEY ([Opportunity__c])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Task_RecurrenceActivityId]
        FOREIGN KEY ([RecurrenceActivityId])
            REFERENCES [Task] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_sc_lightning__SightCall_Session__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Session__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_sc_lightning__SightCall_Request__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Request__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_sc_lightning__SightCall_Case__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [sc_lightning__SightCall_Case__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_rh2__PS_Rollup_Dummy__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Rollup_Dummy__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_rh2__PS_Export_Rollups__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [rh2__PS_Export_Rollups__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffvat__VATGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffvat__VATGroupItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffvat__VATGroupItem__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRule__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRule__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRuleRelationship__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleRelationship__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRuleMapping__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleMapping__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRuleJob__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleJob__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRuleButton__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleButton__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ffirule__IntegrationRuleAction__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ffirule__IntegrationRuleAction__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_fferpcore__ProcessUserGroup__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessUserGroup__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_fferpcore__ProcessRun__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__ProcessRun__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_fferpcore__BillingDocument__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_fferpcore__BillingDocumentLineItem__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_et4ae5__Triggered_Send_Execution__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [et4ae5__Triggered_Send_Execution__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Lead_Lead__c]
        FOREIGN KEY ([Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Account_Person_Account__c]
        FOREIGN KEY ([Person_Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ServiceAppointment_Service_Appointment__c]
        FOREIGN KEY ([Service_Appointment__c])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ZipCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ZipCode__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_WorkOrderLineItem_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_WorkOrder_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_TollFreeNumbers__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [TollFreeNumbers__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_SurveyQuestion_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [SurveyQuestion] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Solution_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Solution] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Shift_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Shift] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ServiceResource_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceResource] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ServiceContract_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ServiceAppointment_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Script__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Script__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ResourceAbsence_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ResourceAbsence] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Rebuttal__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Rebuttal__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Quote_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Quote] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_PromoCode__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [PromoCode__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Product2_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ProcessException_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ProcessException] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Order_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Opportunity_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_OperatingHoursHoliday_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [OperatingHoursHoliday] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Location_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Contact_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Lead_WhoId]
        FOREIGN KEY ([WhoId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_APXTConga4__Composer_QuickMerge__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Composer_QuickMerge__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_APXTConga4__Conga_Email_Staging__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Staging__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_APXTConga4__Conga_Email_Template__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXTConga4__Conga_Email_Template__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_APXT_BPM__Conductor__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [APXT_BPM__Conductor__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Account_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Asset_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_AssetRelationship_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [AssetRelationship] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_AssignedResource_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [AssignedResource] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Briefing__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Briefing__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Campaign_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Case_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Commissions_Log__c_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Commissions_Log__c] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ContactRequest_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ContactRequest] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Contract_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Contract] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ContractLineItem_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ContractLineItem] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Entitlement_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_Image_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [Image] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_ListEmail_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [ListEmail] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_LiveAgentSession_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [LiveAgentSession] ([Id])
 ;
 
ALTER TABLE [Task]
    ADD CONSTRAINT [fk_Task_LiveChatTranscript_WhatId]
        FOREIGN KEY ([WhatId])
            REFERENCES [LiveChatTranscript] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxDetail__c]
    ADD CONSTRAINT [fk_fferpcore__TaxDetail__c_fferpcore__BillingDocument__c_fferpcore__BillingDocument__c]
        FOREIGN KEY ([fferpcore__BillingDocument__c])
            REFERENCES [fferpcore__BillingDocument__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxDetail__c]
    ADD CONSTRAINT [fk_fferpcore__TaxDetail__c_fferpcore__BillingDocumentLineItem__c_fferpcore__BillingDocumentLineItem__c]
        FOREIGN KEY ([fferpcore__BillingDocumentLineItem__c])
            REFERENCES [fferpcore__BillingDocumentLineItem__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__TaxDetail__c]
    ADD CONSTRAINT [fk_fferpcore__TaxDetail__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxDetail__c]
    ADD CONSTRAINT [fk_fferpcore__TaxDetail__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxCode__c]
    ADD CONSTRAINT [fk_fferpcore__TaxCode__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxCode__c]
    ADD CONSTRAINT [fk_fferpcore__TaxCode__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxCode__c]
    ADD CONSTRAINT [fk_fferpcore__TaxCode__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxRate__c]
    ADD CONSTRAINT [fk_fferpcore__TaxRate__c_fferpcore__TaxCode__c_fferpcore__TaxCode__c]
        FOREIGN KEY ([fferpcore__TaxCode__c])
            REFERENCES [fferpcore__TaxCode__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__TaxRate__c]
    ADD CONSTRAINT [fk_fferpcore__TaxRate__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TaxRate__c]
    ADD CONSTRAINT [fk_fferpcore__TaxRate__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Territory2]
    ADD CONSTRAINT [fk_Territory2_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Territory2]
    ADD CONSTRAINT [fk_Territory2_User_ForecastUserId]
        FOREIGN KEY ([ForecastUserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Territory2]
    ADD CONSTRAINT [fk_Territory2_Territory2_ParentTerritory2Id]
        FOREIGN KEY ([ParentTerritory2Id])
            REFERENCES [Territory2] ([Id])
 ;
 
ALTER TABLE [Territory2]
    ADD CONSTRAINT [fk_Territory2_Territory2Model_Territory2ModelId]
        FOREIGN KEY ([Territory2ModelId])
            REFERENCES [Territory2Model] ([Id])
 ;
 
ALTER TABLE [Territory2Model]
    ADD CONSTRAINT [fk_Territory2Model_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Territory2Model]
    ADD CONSTRAINT [fk_Territory2Model_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestPublication__c]
    ADD CONSTRAINT [fk_fferpcore__TestPublication__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestPublication__c]
    ADD CONSTRAINT [fk_fferpcore__TestPublication__c_fferpcore__TestSubscription__c_fferpcore__Publisher__c]
        FOREIGN KEY ([fferpcore__Publisher__c])
            REFERENCES [fferpcore__TestSubscription__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestPublication__c]
    ADD CONSTRAINT [fk_fferpcore__TestPublication__c_fferpcore__MessageType__c_fferpcore__MessageType__c]
        FOREIGN KEY ([fferpcore__MessageType__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__TestPublication__c]
    ADD CONSTRAINT [fk_fferpcore__TestPublication__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestPublication__c]
    ADD CONSTRAINT [fk_fferpcore__TestPublication__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__TestSubscription__c_fferpcore__MessageType__c_fferpcore__MessageType__c]
        FOREIGN KEY ([fferpcore__MessageType__c])
            REFERENCES [fferpcore__MessageType__c] ([Id])

 ;
 
ALTER TABLE [fferpcore__TestSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__TestSubscription__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__TestSubscription__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__TestSubscription__c]
    ADD CONSTRAINT [fk_fferpcore__TestSubscription__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Test_Table_Custom_Object__c]
    ADD CONSTRAINT [fk_Tigerface5__Test_Table_Custom_Object__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Test_Table_Custom_Object__c]
    ADD CONSTRAINT [fk_Tigerface5__Test_Table_Custom_Object__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Test_Table_Custom_Object__c]
    ADD CONSTRAINT [fk_Tigerface5__Test_Table_Custom_Object__c_User_Tigerface5__User__c]
        FOREIGN KEY ([Tigerface5__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Test_Table_Custom_Object__c]
    ADD CONSTRAINT [fk_Tigerface5__Test_Table_Custom_Object__c_Tigerface5__Test_Table_Custom_Object__c_Tigerface5__Test_Custom_Lookup__c]
        FOREIGN KEY ([Tigerface5__Test_Custom_Lookup__c])
            REFERENCES [Tigerface5__Test_Table_Custom_Object__c] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Test_Table_Custom_Object__c]
    ADD CONSTRAINT [fk_Tigerface5__Test_Table_Custom_Object__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [TimeSlot]
    ADD CONSTRAINT [fk_TimeSlot_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [TimeSlot]
    ADD CONSTRAINT [fk_TimeSlot_WorkTypeGroup_WorkTypeGroupId]
        FOREIGN KEY ([WorkTypeGroupId])
            REFERENCES [WorkTypeGroup] ([Id])
 ;
 
ALTER TABLE [TimeSlot]
    ADD CONSTRAINT [fk_TimeSlot_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [TimeSlot]
    ADD CONSTRAINT [fk_TimeSlot_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [TollFreeNumbers__c]
    ADD CONSTRAINT [fk_TollFreeNumbers__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [TollFreeNumbers__c]
    ADD CONSTRAINT [fk_TollFreeNumbers__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [TollFreeNumbers__c]
    ADD CONSTRAINT [fk_TollFreeNumbers__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_Account_Account__c]
        FOREIGN KEY ([Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_ServiceTerritory_Service_Territory__c]
        FOREIGN KEY ([Service_Territory__c])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_Campaign_Campaign__c]
        FOREIGN KEY ([Campaign__c])
            REFERENCES [Campaign] ([Id])
 ;
 
ALTER TABLE [Transaction_Log__c]
    ADD CONSTRAINT [fk_Transaction_Log__c_Lead_Lead__c]
        FOREIGN KEY ([Lead__c])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [et4ae5__Automated_Send__c]
    ADD CONSTRAINT [fk_et4ae5__Automated_Send__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Automated_Send__c]
    ADD CONSTRAINT [fk_et4ae5__Automated_Send__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Automated_Send__c]
    ADD CONSTRAINT [fk_et4ae5__Automated_Send__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Triggered_Send_Execution__c]
    ADD CONSTRAINT [fk_et4ae5__Triggered_Send_Execution__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Triggered_Send_Execution__c]
    ADD CONSTRAINT [fk_et4ae5__Triggered_Send_Execution__c_et4ae5__Automated_Send__c_et4ae5__Triggered_Send__c]
        FOREIGN KEY ([et4ae5__Triggered_Send__c])
            REFERENCES [et4ae5__Automated_Send__c] ([Id])

 ;
 
ALTER TABLE [et4ae5__Triggered_Send_Execution__c]
    ADD CONSTRAINT [fk_et4ae5__Triggered_Send_Execution__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__Triggered_Send_Execution__c]
    ADD CONSTRAINT [fk_et4ae5__Triggered_Send_Execution__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_User_approver__c]
        FOREIGN KEY ([approver__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_User_DelegatedApproverId]
        FOREIGN KEY ([DelegatedApproverId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [User]
    ADD CONSTRAINT [fk_User_User_ManagerId]
        FOREIGN KEY ([ManagerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__UEBU__c]
    ADD CONSTRAINT [fk_et4ae5__UEBU__c_et4ae5__Business_Unit__c_et4ae5__BU__c]
        FOREIGN KEY ([et4ae5__BU__c])
            REFERENCES [et4ae5__Business_Unit__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [et4ae5__UEBU__c]
    ADD CONSTRAINT [fk_et4ae5__UEBU__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [et4ae5__UEBU__c]
    ADD CONSTRAINT [fk_et4ae5__UEBU__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformation__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformation__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformation__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformation__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformation__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformation__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformation__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformation__c_User_fferpcore__User__c]
        FOREIGN KEY ([fferpcore__User__c])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformationAssignment__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformationAssignment__c_fferpcore__UserInformation__c_fferpcore__UserInformation__c]
        FOREIGN KEY ([fferpcore__UserInformation__c])
            REFERENCES [fferpcore__UserInformation__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [fferpcore__UserInformationAssignment__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformationAssignment__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__UserInformationAssignment__c]
    ADD CONSTRAINT [fk_fferpcore__UserInformationAssignment__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_UserProvisioningRequest_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [UserProvisioningRequest] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_User_ManagerId]
        FOREIGN KEY ([ManagerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_User_SalesforceUserId]
        FOREIGN KEY ([SalesforceUserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [UserProvisioningRequest]
    ADD CONSTRAINT [fk_UserProvisioningRequest_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Validate_Phone_Number__c]
    ADD CONSTRAINT [fk_Tigerface5__Validate_Phone_Number__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Validate_Phone_Number__c]
    ADD CONSTRAINT [fk_Tigerface5__Validate_Phone_Number__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Tigerface5__Validate_Phone_Number__c]
    ADD CONSTRAINT [fk_Tigerface5__Validate_Phone_Number__c_Tigerface5__Display_Configuration__c_Tigerface5__Display_Configuration__c]
        FOREIGN KEY ([Tigerface5__Display_Configuration__c])
            REFERENCES [Tigerface5__Display_Configuration__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffvat__VATGroup__c]
    ADD CONSTRAINT [fk_ffvat__VATGroup__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VATGroup__c]
    ADD CONSTRAINT [fk_ffvat__VATGroup__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VATGroup__c]
    ADD CONSTRAINT [fk_ffvat__VATGroup__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VATGroupItem__c]
    ADD CONSTRAINT [fk_ffvat__VATGroupItem__c_ffvat__VATGroup__c_ffvat__VATGroup__c]
        FOREIGN KEY ([ffvat__VATGroup__c])
            REFERENCES [ffvat__VATGroup__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffvat__VATGroupItem__c]
    ADD CONSTRAINT [fk_ffvat__VATGroupItem__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VATGroupItem__c]
    ADD CONSTRAINT [fk_ffvat__VATGroupItem__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReportedTransaction__c]
    ADD CONSTRAINT [fk_ffvat__VatReportedTransaction__c_Account_ffvat__Account__c]
        FOREIGN KEY ([ffvat__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReportedTransaction__c]
    ADD CONSTRAINT [fk_ffvat__VatReportedTransaction__c_ffvat__VatReturn__c_ffvat__VatReturn__c]
        FOREIGN KEY ([ffvat__VatReturn__c])
            REFERENCES [ffvat__VatReturn__c] ([Id])
ON DELETE CASCADE
 ;
 
ALTER TABLE [ffvat__VatReportedTransaction__c]
    ADD CONSTRAINT [fk_ffvat__VatReportedTransaction__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReportedTransaction__c]
    ADD CONSTRAINT [fk_ffvat__VatReportedTransaction__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReturn__c]
    ADD CONSTRAINT [fk_ffvat__VatReturn__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReturn__c]
    ADD CONSTRAINT [fk_ffvat__VatReturn__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReturn__c]
    ADD CONSTRAINT [fk_ffvat__VatReturn__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffvat__VatReturn__c]
    ADD CONSTRAINT [fk_ffvat__VatReturn__c_ffvat__VATGroup__c_ffvat__VATGroup__c]
        FOREIGN KEY ([ffvat__VATGroup__c])
            REFERENCES [ffvat__VATGroup__c] ([Id])
 ;
 
ALTER TABLE [APXTConga4__VersionedData__c]
    ADD CONSTRAINT [fk_APXTConga4__VersionedData__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__VersionedData__c]
    ADD CONSTRAINT [fk_APXTConga4__VersionedData__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [APXTConga4__VersionedData__c]
    ADD CONSTRAINT [fk_APXTConga4__VersionedData__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_Event_EventId]
        FOREIGN KEY ([EventId])
            REFERENCES [Event] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_Account_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_ServiceAppointment_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [ServiceAppointment] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_Opportunity_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_User_HostId]
        FOREIGN KEY ([HostId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VideoCall]
    ADD CONSTRAINT [fk_VideoCall_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Contact_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Task_ActivityId]
        FOREIGN KEY ([ActivityId])
            REFERENCES [Task] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Opportunity_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Opportunity] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Lead_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Lead] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Case_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_Account_RelatedRecordId]
        FOREIGN KEY ([RelatedRecordId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [VoiceCall]
    ADD CONSTRAINT [fk_VoiceCall_User_UserId]
        FOREIGN KEY ([UserId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_WorkOrder_ParentWorkOrderId]
        FOREIGN KEY ([ParentWorkOrderId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Pricebook2_Pricebook2Id]
        FOREIGN KEY ([Pricebook2Id])
            REFERENCES [Pricebook2] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_WorkOrder_RootWorkOrderId]
        FOREIGN KEY ([RootWorkOrderId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_ServiceContract_ServiceContractId]
        FOREIGN KEY ([ServiceContractId])
            REFERENCES [ServiceContract] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Entitlement_EntitlementId]
        FOREIGN KEY ([EntitlementId])
            REFERENCES [Entitlement] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Case_CaseId]
        FOREIGN KEY ([CaseId])
            REFERENCES [Case] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Contact_ContactId]
        FOREIGN KEY ([ContactId])
            REFERENCES [Contact] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_Account_AccountId]
        FOREIGN KEY ([AccountId])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkOrder]
    ADD CONSTRAINT [fk_WorkOrder_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_ParentWorkOrderLineItemId]
        FOREIGN KEY ([ParentWorkOrderLineItemId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_Product2_Product2Id]
        FOREIGN KEY ([Product2Id])
            REFERENCES [Product2] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_Asset_AssetId]
        FOREIGN KEY ([AssetId])
            REFERENCES [Asset] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_Order_OrderId]
        FOREIGN KEY ([OrderId])
            REFERENCES [Order] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_WorkOrderLineItem_RootWorkOrderLineItemId]
        FOREIGN KEY ([RootWorkOrderLineItemId])
            REFERENCES [WorkOrderLineItem] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_PricebookEntry_PricebookEntryId]
        FOREIGN KEY ([PricebookEntryId])
            REFERENCES [PricebookEntry] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_ServiceTerritory_ServiceTerritoryId]
        FOREIGN KEY ([ServiceTerritoryId])
            REFERENCES [ServiceTerritory] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_Location_LocationId]
        FOREIGN KEY ([LocationId])
            REFERENCES [Location] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_WorkOrder_WorkOrderId]
        FOREIGN KEY ([WorkOrderId])
            REFERENCES [WorkOrder] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkOrderLineItem]
    ADD CONSTRAINT [fk_WorkOrderLineItem_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkType]
    ADD CONSTRAINT [fk_WorkType_OperatingHours_OperatingHoursId]
        FOREIGN KEY ([OperatingHoursId])
            REFERENCES [OperatingHours] ([Id])
 ;
 
ALTER TABLE [WorkType]
    ADD CONSTRAINT [fk_WorkType_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkType]
    ADD CONSTRAINT [fk_WorkType_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkType]
    ADD CONSTRAINT [fk_WorkType_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroup]
    ADD CONSTRAINT [fk_WorkTypeGroup_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroup]
    ADD CONSTRAINT [fk_WorkTypeGroup_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroup]
    ADD CONSTRAINT [fk_WorkTypeGroup_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroupMember]
    ADD CONSTRAINT [fk_WorkTypeGroupMember_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroupMember]
    ADD CONSTRAINT [fk_WorkTypeGroupMember_WorkType_WorkTypeId]
        FOREIGN KEY ([WorkTypeId])
            REFERENCES [WorkType] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroupMember]
    ADD CONSTRAINT [fk_WorkTypeGroupMember_WorkTypeGroup_WorkTypeGroupId]
        FOREIGN KEY ([WorkTypeGroupId])
            REFERENCES [WorkTypeGroup] ([Id])
 ;
 
ALTER TABLE [WorkTypeGroupMember]
    ADD CONSTRAINT [fk_WorkTypeGroupMember_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_ffirule__fflib_XXXBatchTestOpportunity2__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_ffirule__fflib_XXXBatchTestOpportunity2__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_ffirule__fflib_XXXBatchTestOpportunity2__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_ffirule__fflib_XXXBatchTestOpportunity2__c_Account_ffirule__Account__c]
        FOREIGN KEY ([ffirule__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [ffirule__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_ffirule__fflib_XXXBatchTestOpportunity2__c_ffirule__fflib_BatchProcess__c_ffirule__BatchProcess__c]
        FOREIGN KEY ([ffirule__BatchProcess__c])
            REFERENCES [ffirule__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_XXXBatchTestOpportunity2__c_fferpcore__fflib_BatchProcess__c_fferpcore__BatchProcess__c]
        FOREIGN KEY ([fferpcore__BatchProcess__c])
            REFERENCES [fferpcore__fflib_BatchProcess__c] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_XXXBatchTestOpportunity2__c_Account_fferpcore__Account__c]
        FOREIGN KEY ([fferpcore__Account__c])
            REFERENCES [Account] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_XXXBatchTestOpportunity2__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_XXXBatchTestOpportunity2__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [fferpcore__fflib_XXXBatchTestOpportunity2__c]
    ADD CONSTRAINT [fk_fferpcore__fflib_XXXBatchTestOpportunity2__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ZipCode__c]
    ADD CONSTRAINT [fk_ZipCode__c_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ZipCode__c]
    ADD CONSTRAINT [fk_ZipCode__c_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [ZipCode__c]
    ADD CONSTRAINT [fk_ZipCode__c_User_OwnerId]
        FOREIGN KEY ([OwnerId])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Announcement]
    ADD CONSTRAINT [fk_Announcement_User_CreatedById]
        FOREIGN KEY ([CreatedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Announcement]
    ADD CONSTRAINT [fk_Announcement_User_LastModifiedById]
        FOREIGN KEY ([LastModifiedById])
            REFERENCES [User] ([Id])
 ;
 
ALTER TABLE [Announcement]
    ADD CONSTRAINT [fk_Announcement_CollaborationGroup_ParentId]
        FOREIGN KEY ([ParentId])
            REFERENCES [CollaborationGroup] ([Id])
 ;
COMMIT
