/* CreateDate: 03/21/2022 13:00:03.423 , ModifyDate: 03/21/2022 13:00:05.750 */
GO
CREATE TABLE [dbo].[datRefersionLog](
	[RefersionLogID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RefersionProcessID] [int] NOT NULL,
	[SessionGUID] [uniqueidentifier] NOT NULL,
	[BatchID] [int] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralCodeExpireDate__c] [datetime] NULL,
	[Sku] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[CurrencyCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IPAddress] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JsonData] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseVerbiage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefersionStatusID] [int] NOT NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datRefersionLog] PRIMARY KEY CLUSTERED
(
	[RefersionLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
