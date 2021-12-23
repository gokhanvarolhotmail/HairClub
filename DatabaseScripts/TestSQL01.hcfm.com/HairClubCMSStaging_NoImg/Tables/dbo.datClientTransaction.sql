/* CreateDate: 05/14/2012 17:34:57.913 , ModifyDate: 12/03/2021 10:24:48.577 */
GO
CREATE TABLE [dbo].[datClientTransaction](
	[ClientTransactionGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[ClientProcessID] [int] NOT NULL,
	[EFTFreezeStartDate] [datetime] NULL,
	[PreviousEFTFreezeStartDate] [datetime] NULL,
	[EFTFreezeEndDate] [datetime] NULL,
	[PreviousEFTFreezeEndDate] [datetime] NULL,
	[EFTHoldStartDate] [datetime] NULL,
	[PreviousEFTHoldStartDate] [datetime] NULL,
	[EFTHoldEndDate] [datetime] NULL,
	[PreviousEFTHoldEndDate] [datetime] NULL,
	[CCNumber] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PreviousCCNumber] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CCExpirationDate] [date] NULL,
	[PreviousCCExpirationDate] [date] NULL,
	[FeePayCycleId] [int] NULL,
	[PreviousFeePayCycleId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthlyFeeAmount] [money] NULL,
	[PreviousMonthlyFeeAmount] [money] NULL,
	[PreviousFeeFreezeReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeFreezeReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankAccountNumber] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PreviousBankAccountNumber] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeFreezeReasonID] [int] NULL,
	[PreviousFeeFreezeReasonID] [int] NULL,
 CONSTRAINT [PK_ClientTransaction] PRIMARY KEY NONCLUSTERED
(
	[ClientTransactionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_datClientTransaction_ClusteredKey] UNIQUE CLUSTERED
(
	[TransactionDate] ASC,
	[ClientProcessID] ASC,
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientTransaction_ClientGUID] ON [dbo].[datClientTransaction]
(
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_datClient]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_lkpClientProcess] FOREIGN KEY([ClientProcessID])
REFERENCES [dbo].[lkpClientProcess] ([ClientProcessID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_lkpClientProcess]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_lkpFeeFreezeReason] FOREIGN KEY([FeeFreezeReasonID])
REFERENCES [dbo].[lkpFeeFreezeReason] ([FeeFreezeReasonID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_lkpFeeFreezeReason]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_lkpFeeFreezeReasonPrevious] FOREIGN KEY([PreviousFeeFreezeReasonID])
REFERENCES [dbo].[lkpFeeFreezeReason] ([FeeFreezeReasonID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_lkpFeeFreezeReasonPrevious]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_lkpFeePayCycle] FOREIGN KEY([FeePayCycleId])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_lkpFeePayCycle]
GO
ALTER TABLE [dbo].[datClientTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientTransaction_lkpFeePayCyclePrevious] FOREIGN KEY([PreviousFeePayCycleId])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
GO
ALTER TABLE [dbo].[datClientTransaction] CHECK CONSTRAINT [FK_datClientTransaction_lkpFeePayCyclePrevious]
GO
