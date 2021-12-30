/* CreateDate: 05/28/2013 14:10:34.267 , ModifyDate: 05/26/2020 10:49:23.360 */
GO
CREATE TABLE [dbo].[datIncomingRequestLog](
	[IncomingRequestID] [int] IDENTITY(301,1) NOT FOR REPLICATION NOT NULL,
	[ProcessName] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConectID] [int] NULL,
	[ClientMembershipID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyRequestID] [int] NULL,
	[PatientSlipNo] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TreatmentPlanDate] [datetime] NULL,
	[TreatmentPlanNo] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TreatmentPlanGraftCount] [int] NULL,
	[TreatmentPlanContractAmount] [decimal](14, 4) NULL,
	[ProcedureStatus] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureDate] [datetime] NULL,
	[ProcedureGraftCount] [int] NULL,
	[ProcedureAmount] [decimal](14, 4) NULL,
	[PaymentDate] [datetime] NULL,
	[PaymentAmount] [decimal](14, 4) NULL,
	[PaymentType] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NOT NULL,
	[ErrorMessage] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[ConsultantUserName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultationStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultationStatusDate] [datetime] NULL,
	[WarningMessage] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkPhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CellPhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhoneDNC] [bit] NOT NULL,
	[WorkPhoneDNC] [bit] NOT NULL,
	[CellPhoneDNC] [bit] NOT NULL,
	[HomePhoneFTCDNC] [bit] NOT NULL,
	[WorkPhoneFTCDNC] [bit] NOT NULL,
	[CellPhoneFTCDNC] [bit] NOT NULL,
	[MembershipStartDate] [datetime] NULL,
	[SalesUserName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOfficeName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HC_Center] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyProcedureID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRealTimeRequest] [bit] NOT NULL,
	[BosleyRealTimeRequestID] [int] NULL,
	[OnContactContactID] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySalesforceAccountID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCSalesforceLeadID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datIncomingRequestLog] PRIMARY KEY CLUSTERED
(
	[IncomingRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datIncomingRequestLog_BosleyRequestID] ON [dbo].[datIncomingRequestLog]
(
	[BosleyRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datIncomingRequestLog_ConectID_BosleyRequestID] ON [dbo].[datIncomingRequestLog]
(
	[ConectID] ASC,
	[BosleyRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datIncomingRequestLog_CreateDate] ON [dbo].[datIncomingRequestLog]
(
	[CreateDate] ASC
)
INCLUDE([ConectID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datIncomingRequestLog_SiebelID] ON [dbo].[datIncomingRequestLog]
(
	[SiebelID] ASC,
	[IsProcessedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  CONSTRAINT [DF_datIncomingRequestLog_IsProcessedFlag]  DEFAULT ((0)) FOR [IsProcessedFlag]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [HomePhoneDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [WorkPhoneDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [CellPhoneDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [HomePhoneFTCDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [WorkPhoneFTCDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [CellPhoneFTCDNC]
GO
ALTER TABLE [dbo].[datIncomingRequestLog] ADD  DEFAULT ((0)) FOR [IsRealTimeRequest]
GO
