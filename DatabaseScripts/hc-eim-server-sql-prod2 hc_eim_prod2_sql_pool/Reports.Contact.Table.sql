/****** Object:  Table [Reports].[Contact]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Reports].[Contact]
(
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[Company] [nvarchar](18) NULL,
	[LeadID] [nvarchar](18) NULL,
	[GCLID] [nvarchar](100) NULL,
	[HashedEmail] [varchar](4000) NULL,
	[Start_Date] [datetime] NULL,
	[Date] [date] NULL,
	[Time] [time](7) NULL,
	[DayPart] [nvarchar](20) NULL,
	[Hour] [varchar](10) NULL,
	[Minute] [smallint] NULL,
	[Seconds] [smallint] NULL,
	[LastName] [nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NULL,
	[Phone] [nvarchar](100) NULL,
	[MobilePhone] [nvarchar](100) NULL,
	[Email] [nvarchar](200) NULL,
	[Sourcecode] [nvarchar](500) NULL,
	[DialedNumber] [nvarchar](100) NULL,
	[PhoneNumberAreaCode] [nvarchar](10) NULL,
	[CampaignAgency] [nvarchar](50) NULL,
	[CampaignChannel] [nvarchar](50) NULL,
	[CampaignMedium] [nvarchar](50) NULL,
	[CampaignName] [nvarchar](80) NULL,
	[CampaignFormat] [nvarchar](50) NULL,
	[CampaignCompany] [nvarchar](50) NULL,
	[CampaignLocation] [nvarchar](50) NULL,
	[CampaignBudgetName] [nvarchar](50) NULL,
	[CampaignLanguage] [nvarchar](100) NULL,
	[CampaignPromotionCode] [nvarchar](100) NULL,
	[CampaignLandingPageURL] [nvarchar](1250) NULL,
	[CampaignStartDate] [datetime] NULL,
	[CampaignEndDate] [datetime] NULL,
	[CampaignStatus] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[TotalTime] [bigint] NULL,
	[IVRTime] [bigint] NULL,
	[TalkTime] [bigint] NULL,
	[RawContact] [int] NULL,
	[AbandonedContact] [int] NULL,
	[Contact] [int] NULL,
	[QualifiedContact] [int] NULL,
	[NonQualifiedContact] [int] NULL,
	[Pkid] [varchar](1024) NULL,
	[TaskId] [varchar](1024) NULL,
	[TollFreeName] [varchar](1024) NULL,
	[TollFreeMobileName] [varchar](1024) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
