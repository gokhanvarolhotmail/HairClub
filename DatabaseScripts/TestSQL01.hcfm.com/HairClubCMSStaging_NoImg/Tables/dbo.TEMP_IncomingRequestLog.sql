/* CreateDate: 06/14/2017 11:18:26.563 , ModifyDate: 06/14/2017 11:18:26.563 */
GO
CREATE TABLE [dbo].[TEMP_IncomingRequestLog](
	[IncomingRequestID] [int] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[ProcessName] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[OnContactContactID] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO