/* CreateDate: 03/03/2022 13:54:33.703 , ModifyDate: 03/08/2022 08:42:59.923 */
GO
CREATE TABLE [SFStaging].[CampaignMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CampaignId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasResponded] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[FirstRespondedDate] [date] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCall] [bit] NULL,
	[HasOptedOutOfEmail] [bit] NULL,
	[HasOptedOutOfFax] [bit] NULL,
	[LeadSource] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompanyOrAccount] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOrContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOrContactOwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Opportunity__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Device_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Do_Not_Call_from_Lead_Contact__c] [bit] NULL,
	[Last_Activity_Date__c] [date] NULL,
	[Lead_Status__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Time_Zone__c] [date] NULL,
 CONSTRAINT [pk_CampaignMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
