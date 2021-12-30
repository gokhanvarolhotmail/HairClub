/* CreateDate: 05/05/2020 17:42:49.450 , ModifyDate: 04/30/2021 19:11:30.650 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC],
 CONSTRAINT [IX_datClientTransaction_ClusteredKey] UNIQUE CLUSTERED
(
	[TransactionDate] ASC,
	[ClientProcessID] ASC,
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
