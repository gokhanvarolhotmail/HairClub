/* CreateDate: 04/27/2016 15:56:51.357 , ModifyDate: 04/27/2016 15:56:51.497 */
GO
CREATE TABLE [dbo].[datActivityUpload](
	[ActivityUploadID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignID] [int] NULL,
	[RegionID] [int] NULL,
	[RegionDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[CenterDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkPhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCallFlag] [bit] NOT NULL,
	[DoNotContactFlag] [bit] NOT NULL,
	[InitialSaleDate] [datetime] NULL,
	[InitialApplicationDate] [datetime] NULL,
	[ConversionDate] [datetime] NULL,
	[LastAppointmentDate] [datetime] NULL,
	[BIO_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_BeginDate] [datetime] NULL,
	[BIO_EndDate] [datetime] NULL,
	[BIO_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_MonthlyFee] [money] NULL,
	[BIO_ContractBalance] [money] NULL,
	[BIO_CancelDate] [datetime] NULL,
	[BIO_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_BeginDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_EndDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_MonthlyFee] [money] NULL,
	[EXT_ContractBalance] [money] NULL,
	[EXT_CancelDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_BeginDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_EndDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_MonthlyFee] [money] NULL,
	[XTR_ContractBalance] [money] NULL,
	[XTR_CancelDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_BeginDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_EndDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_ContractBalance] [money] NULL,
	[SUR_CancelDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NBC_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NBC_Email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CRM_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CRM_Email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STY_Name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STY_Email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsImportedFlag] [bit] NOT NULL,
	[ImportDate] [datetime] NULL,
	[ActivityID] [int] NULL,
	[OfferType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datActivityUpload] PRIMARY KEY CLUSTERED
(
	[ActivityUploadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_ActivityID] ON [dbo].[datActivityUpload]
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_CampaignID] ON [dbo].[datActivityUpload]
(
	[CampaignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_CenterID] ON [dbo].[datActivityUpload]
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_ClientIdentifier] ON [dbo].[datActivityUpload]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_IsImportedFlag] ON [dbo].[datActivityUpload]
(
	[IsImportedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivityUpload_RegionID] ON [dbo].[datActivityUpload]
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datActivityUpload] ADD  CONSTRAINT [DF_datActivityUpload_IsImportedFlag]  DEFAULT ((0)) FOR [IsImportedFlag]
GO
ALTER TABLE [dbo].[datActivityUpload] ADD  CONSTRAINT [DF_datActivityUpload_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[datActivityUpload] ADD  CONSTRAINT [DF_datActivityUpload_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
