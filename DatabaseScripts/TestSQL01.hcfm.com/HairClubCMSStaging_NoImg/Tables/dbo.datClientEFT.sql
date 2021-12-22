/* CreateDate: 10/04/2010 12:08:45.083 , ModifyDate: 12/03/2021 10:24:48.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientEFT_ClientGUID] ON [dbo].[datClientEFT]
(
	[ClientGUID] ASC
)
INCLUDE([AccountExpiration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientEFT_ClientMembershipGUID] ON [dbo].[datClientEFT]
(
	[ClientMembershipGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientEFT_FeePayCycleID_EFTAccountTypeID_EFTStatusID_ClientGUID_ClientMembershipGUID] ON [dbo].[datClientEFT]
(
	[FeePayCycleID] ASC,
	[EFTAccountTypeID] ASC,
	[EFTStatusID] ASC,
	[ClientGUID] ASC,
	[ClientMembershipGUID] ASC
)
INCLUDE([AccountExpiration],[Freeze_End],[Freeze_Start],[IsActiveFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datClientEFT_ClientGUID_FeePayCycleID_ClientMembershipGUID] ON [dbo].[datClientEFT]
(
	[ClientGUID] ASC,
	[FeePayCycleID] ASC,
	[ClientMembershipGUID] ASC
)
INCLUDE([ClientEFTGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientEFT] ADD  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[datClientEFT] ADD  DEFAULT ((0)) FOR [IsEFTTokenValidFlag]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_datClient]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_datClientMembership]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpCountry] FOREIGN KEY([BankCountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpCountry]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpCreditCardType] FOREIGN KEY([CreditCardTypeID])
REFERENCES [dbo].[lkpCreditCardType] ([CreditCardTypeID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpCreditCardType]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpEFTAccountType] FOREIGN KEY([EFTAccountTypeID])
REFERENCES [dbo].[lkpEFTAccountType] ([EFTAccountTypeID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpEFTAccountType]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpEFTStatus] FOREIGN KEY([EFTStatusID])
REFERENCES [dbo].[lkpEFTStatus] ([EFTStatusID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpEFTStatus]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpFeeFreezeReason] FOREIGN KEY([FeeFreezeReasonId])
REFERENCES [dbo].[lkpFeeFreezeReason] ([FeeFreezeReasonID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpFeeFreezeReason]
GO
ALTER TABLE [dbo].[datClientEFT]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientEFT_lkpFeePayCycle] FOREIGN KEY([FeePayCycleID])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
GO
ALTER TABLE [dbo].[datClientEFT] CHECK CONSTRAINT [FK_datClientEFT_lkpFeePayCycle]
GO
