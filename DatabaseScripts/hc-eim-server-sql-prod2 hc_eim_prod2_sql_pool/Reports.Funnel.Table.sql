/****** Object:  Table [Reports].[Funnel]    Script Date: 3/1/2022 8:53:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reports].[Funnel]
(
	[FunnelTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [nvarchar](18) NULL,
	[SalesForceTaskID] [nvarchar](18) NULL,
	[BrightPatternID] [nvarchar](18) NULL,
	[LeadFunnelTransactionID] [nvarchar](18) NULL,
	[SaleforceLeadID] [nvarchar](18) NULL,
	[Company] [nvarchar](100) NULL,
	[FunnelStep] [nvarchar](50) NULL,
	[Funnelstatus] [varchar](100) NULL,
	[OriginalGCLID] [nvarchar](100) NULL,
	[LeadCreateDateUTC] [datetime] NULL,
	[LeadCreateDateEST] [datetime] NULL,
	[ActivityDateUTC] [datetime] NULL,
	[ActivityDateEST] [datetime] NULL,
	[AppointmentCreated] [datetime] NULL,
	[AppointmentScheduled] [datetime] NULL,
	[Date] [datetime] NULL,
	[Time] [time](7) NULL,
	[DayPart] [nvarchar](20) NULL,
	[Hour] [varchar](10) NULL,
	[Minute] [smallint] NULL,
	[Seconds] [smallint] NULL,
	[OriginalContactType] [nvarchar](30) NULL,
	[OriginalSourcecode] [nvarchar](30) NULL,
	[OriginalDialedNumber] [nvarchar](50) NULL,
	[OriginalPhoneNumberAreaCode] [nvarchar](10) NULL,
	[OriginalCampaignAgency] [nvarchar](50) NULL,
	[OriginalCampaignChannel] [nvarchar](50) NULL,
	[OriginalCampaignName] [nvarchar](80) NULL,
	[OriginalCampaignFormat] [nvarchar](50) NULL,
	[OriginalCampaignLanguage] [nvarchar](100) NULL,
	[OriginalCampaignPromotionCode] [nvarchar](100) NULL,
	[OriginalCampaignStartDate] [datetime] NULL,
	[OriginalCampaignEndDate] [datetime] NULL,
	[OriginalCampaignStatus] [nvarchar](50) NULL,
	[RecentSourcecode] [nvarchar](30) NULL,
	[RecentDialedNumber] [nvarchar](50) NULL,
	[RecentPhoneNumberAreaCode] [nvarchar](10) NULL,
	[RecentCampaignAgency] [nvarchar](50) NULL,
	[RecentCampaignChannel] [nvarchar](50) NULL,
	[RecentCampaignName] [nvarchar](80) NULL,
	[RecentCampaignFormat] [nvarchar](50) NULL,
	[RecentCampaignLanguage] [nvarchar](100) NULL,
	[RecentCampaignPromotionCode] [nvarchar](100) NULL,
	[RecentCampaignStartDate] [datetime] NULL,
	[RecentCampaignEndDate] [datetime] NULL,
	[RecentCampaignStatus] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[Region] [nvarchar](100) NULL,
	[MarketDMA] [nvarchar](100) NULL,
	[CenterName] [nvarchar](100) NULL,
	[CenterRegion] [nvarchar](100) NULL,
	[CenterDMA] [nvarchar](100) NULL,
	[CenterType] [nvarchar](50) NULL,
	[CenterOwner] [nvarchar](50) NULL,
	[Language] [nvarchar](50) NULL,
	[Gender] [nvarchar](50) NULL,
	[LastName] [nvarchar](250) NULL,
	[FirstName] [nvarchar](250) NULL,
	[Phone] [nvarchar](250) NULL,
	[MobilePhone] [nvarchar](250) NULL,
	[Email] [nvarchar](250) NULL,
	[Ethnicity] [nvarchar](50) NULL,
	[HairLossCondition] [nvarchar](50) NULL,
	[MaritalStatus] [nvarchar](50) NULL,
	[Occupation] [nvarchar](50) NULL,
	[BirthYear] [nvarchar](50) NULL,
	[AgeBands] [nvarchar](50) NULL,
	[NewContact] [int] NULL,
	[NewLead] [int] NULL,
	[NewAppointment] [int] NULL,
	[NewShow] [int] NULL,
	[NewSale] [int] NULL,
	[NewLeadToAppointment] [int] NULL,
	[NewLeadToShow] [int] NULL,
	[NewLeadToSale] [int] NULL,
	[QuotedPrice] [money] NULL,
	[PrimarySolution] [nvarchar](50) NULL,
	[DoNotContactFlag] [nchar](1) NULL,
	[DoNotCallFlag] [nchar](1) NULL,
	[DoNotSMSFlag] [nchar](1) NULL,
	[DoNotEmailFlag] [nchar](1) NULL,
	[DoNotMailFlag] [nchar](1) NULL,
	[LastModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[ReportCreateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
