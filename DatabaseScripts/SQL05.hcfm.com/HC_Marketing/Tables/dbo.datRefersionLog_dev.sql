/* CreateDate: 07/16/2021 13:26:06.540 , ModifyDate: 07/16/2021 13:26:06.540 */
GO
CREATE TABLE [dbo].[datRefersionLog_dev](
	[RefersionLogID] [int] IDENTITY(1,1) NOT NULL,
	[RefersionProcessID] [int] NOT NULL,
	[SessionGUID] [uniqueidentifier] NOT NULL,
	[BatchID] [int] NOT NULL,
	[ClientIdentifier] [int] NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralCodeExpireDate__c] [datetime] NULL,
	[Sku] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderKey] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[CurrencyCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IPAddress] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JsonData] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseVerbiage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefersionStatusID] [int] NOT NULL,
	[OriginalRefersionLogID] [int] NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datRefersionLog_dev] PRIMARY KEY CLUSTERED
(
	[RefersionLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datRefersionLog_dev] ADD  CONSTRAINT [DF_datRefersionLog_dev_IsReprocessFlag]  DEFAULT ((0)) FOR [IsReprocessFlag]
GO
ALTER TABLE [dbo].[datRefersionLog_dev]  WITH CHECK ADD  CONSTRAINT [FK_datClientMessageLog_dev_lkpRefersionProcess] FOREIGN KEY([RefersionProcessID])
REFERENCES [dbo].[lkpRefersionProcess] ([RefersionProcessID])
GO
ALTER TABLE [dbo].[datRefersionLog_dev] CHECK CONSTRAINT [FK_datClientMessageLog_dev_lkpRefersionProcess]
GO
ALTER TABLE [dbo].[datRefersionLog_dev]  WITH CHECK ADD  CONSTRAINT [FK_datRefersionLog_dev_lkpRefersionStatus] FOREIGN KEY([RefersionStatusID])
REFERENCES [dbo].[lkpRefersionStatus] ([RefersionStatusID])
GO
ALTER TABLE [dbo].[datRefersionLog_dev] CHECK CONSTRAINT [FK_datRefersionLog_dev_lkpRefersionStatus]
GO
