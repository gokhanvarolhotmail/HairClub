/* CreateDate: 10/03/2019 22:32:11.750 , ModifyDate: 03/03/2022 23:00:06.913 */
GO
CREATE TABLE [dbo].[dbaClient](
	[ClientID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NULL,
	[CenterDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientKey] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[CMSClientIdentifier] [int] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkPhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CellPhone] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfBirth] [datetime] NULL,
	[EmailAddress] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SiebelID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[Ethinicity] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARBalance] [decimal](20, 2) NULL,
	[InitialSaleDate] [datetime] NULL,
	[MembershipSold] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SoldBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitialApplicationDate] [datetime] NULL,
	[ConversionDate] [datetime] NULL,
	[ConvertedTo] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedBy] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstAppointmentDate] [datetime] NULL,
	[LastAppointmentDate] [datetime] NULL,
	[NextAppointmentDate] [datetime] NULL,
	[BIO_RevenueGroupSSID] [int] NULL,
	[BIO_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_BeginDate] [datetime] NULL,
	[BIO_EndDate] [datetime] NULL,
	[BIO_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BIO_MonthlyFee] [decimal](20, 2) NULL,
	[BIO_ContractPrice] [decimal](20, 2) NULL,
	[BIO_FirstPaymentDate] [datetime] NULL,
	[BIO_LastPaymentDate] [datetime] NULL,
	[BIO_TotalPayments] [decimal](20, 2) NULL,
	[BIO_CancelDate] [datetime] NULL,
	[BIO_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_RevenueGroupSSID] [int] NULL,
	[EXT_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_BeginDate] [datetime] NULL,
	[EXT_EndDate] [datetime] NULL,
	[EXT_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EXT_MonthlyFee] [decimal](20, 2) NULL,
	[EXT_ContractPrice] [decimal](20, 2) NULL,
	[EXT_FirstPaymentDate] [datetime] NULL,
	[EXT_LastPaymentDate] [datetime] NULL,
	[EXT_TotalPayments] [decimal](20, 2) NULL,
	[EXT_CancelDate] [datetime] NULL,
	[EXT_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_RevenueGroupSSID] [int] NULL,
	[SUR_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_BeginDate] [datetime] NULL,
	[SUR_EndDate] [datetime] NULL,
	[SUR_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SUR_MonthlyFee] [decimal](20, 2) NULL,
	[SUR_ContractPrice] [decimal](20, 2) NULL,
	[SUR_FirstPaymentDate] [datetime] NULL,
	[SUR_LastPaymentDate] [datetime] NULL,
	[SUR_TotalPayments] [decimal](20, 2) NULL,
	[SUR_CancelDate] [datetime] NULL,
	[SUR_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_RevenueGroupSSID] [int] NULL,
	[XTR_Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_BeginDate] [datetime] NULL,
	[XTR_EndDate] [datetime] NULL,
	[XTR_MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[XTR_MonthlyFee] [decimal](20, 2) NULL,
	[XTR_ContractPrice] [decimal](20, 2) NULL,
	[XTR_FirstPaymentDate] [datetime] NULL,
	[XTR_LastPaymentDate] [datetime] NULL,
	[XTR_TotalPayments] [decimal](20, 2) NULL,
	[XTR_CancelDate] [datetime] NULL,
	[XTR_CancelReason] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCallFlag] [int] NULL,
	[DoNotContactFlag] [int] NULL,
	[RecordLastUpdate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesforceContactID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanConfirmAppointmentByEmail] [bit] NULL,
	[CanContactForPromotionsByEmail] [bit] NULL,
 CONSTRAINT [PK_dbaClient] PRIMARY KEY CLUSTERED
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaClient_ClientIdentifier_CA8A4] ON [dbo].[dbaClient]
(
	[ClientIdentifier] ASC
)
INCLUDE([BIO_ContractPrice],[BIO_TotalPayments],[EXT_ContractPrice],[EXT_TotalPayments],[SUR_ContractPrice],[SUR_TotalPayments],[XTR_ContractPrice],[XTR_TotalPayments]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
