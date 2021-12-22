/* CreateDate: 01/09/2009 09:39:53.913 , ModifyDate: 04/27/2011 10:38:34.320 */
GO
CREATE TABLE [dbo].[CampaignResults](
	[ResultsID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignID] [int] NULL,
	[Center] [int] NULL,
	[CenterName] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionID] [int] NULL,
	[Region] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApptDate] [smalldatetime] NULL,
	[Gender] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderID] [tinyint] NULL,
	[RecordID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityID] [tinyint] NULL,
	[Age] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeID] [tinyint] NULL,
	[MaritalStatus] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusID] [tinyint] NULL,
	[Email] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member1] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member2] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [smalldatetime] NULL,
	[CancelTrxDate] [smalldatetime] NULL,
	[NoSaleReason] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CancelReasonID] [int] NULL,
	[CancelReason] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ludwig] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Norwood] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_No] [int] NULL,
 CONSTRAINT [PK_ResultsID] PRIMARY KEY CLUSTERED
(
	[ResultsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CampaignResults_CampaignID] ON [dbo].[CampaignResults]
(
	[CampaignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
