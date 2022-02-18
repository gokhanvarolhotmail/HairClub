/* CreateDate: 02/14/2022 15:02:45.640 , ModifyDate: 02/14/2022 15:02:45.640 */
GO
CREATE TABLE [dbo].[SFDC_HCM_Lead](
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[BatchID] [int] NULL,
	[CenterID] [int] NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Salutation] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[AgeRange] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [datetime] NULL,
	[HairLossExperience] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SessionID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AffiliateID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Suffix] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accommodation] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[LeadCreateDate] [datetime] NULL,
	[LeadCreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadLastUpdate] [datetime] NULL,
	[LeadLastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsReprocessFlag] [bit] NULL,
	[IsProcessedFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
