/* CreateDate: 05/05/2020 17:42:49.250 , ModifyDate: 03/05/2022 19:13:20.413 */
GO
CREATE TABLE [dbo].[datClientEFT](
	[ClientEFTGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[EFTAccountTypeID] [int] NULL,
	[EFTStatusID] [int] NULL,
	[FeePayCycleID] [int] NULL,
	[CreditCardTypeID] [int] NULL,
	[AccountNumberLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountExpiration] [date] NULL,
	[BankName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankPhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankRoutingNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankAccountNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EFTProcessorToken] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastRun] [datetime] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Freeze_Start] [datetime] NULL,
	[Freeze_End] [datetime] NULL,
	[LastPaymentDate] [datetime] NULL,
	[FeeFreezeReasonId] [int] NULL,
	[CardHolderName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsEFTTokenValidFlag] [bit] NOT NULL,
	[BankCountryID] [int] NULL,
	[FeeFreezeReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datClientEFT] PRIMARY KEY CLUSTERED
(
	[ClientEFTGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClientEFT_ClientGUID_FeePayCycleID_INCL] ON [dbo].[datClientEFT]
(
	[ClientGUID] ASC,
	[FeePayCycleID] ASC
)
INCLUDE([ClientEFTGUID],[ClientMembershipGUID],[EFTAccountTypeID],[EFTStatusID],[AccountExpiration],[IsActiveFlag],[Freeze_Start],[Freeze_End]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClientEFT_FeePayCycleID_INCL] ON [dbo].[datClientEFT]
(
	[FeePayCycleID] ASC
)
INCLUDE([ClientEFTGUID],[ClientGUID],[ClientMembershipGUID],[EFTAccountTypeID],[EFTStatusID],[AccountExpiration],[IsActiveFlag],[Freeze_Start],[Freeze_End]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
