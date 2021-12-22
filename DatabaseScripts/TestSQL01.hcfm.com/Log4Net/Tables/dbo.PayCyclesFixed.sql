/* CreateDate: 03/05/2014 17:12:37.460 , ModifyDate: 03/05/2014 17:12:37.460 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayCyclesFixed](
	[PayCycleTransactionGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayCycleTransactionTypeID] [float] NULL,
	[CenterFeeBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterDeclineBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcessorTransactionID] [float] NULL,
	[ApprovalCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeAmount] [float] NULL,
	[TaxAmount] [float] NULL,
	[ChargeAmount] [float] NULL,
	[Verbiage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SoftCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last4Digits] [float] NULL,
	[ExpirationDate] [datetime] NULL,
	[IsTokenUsedFlag] [float] NULL,
	[IsCardPresentFlag] [float] NULL,
	[IsSuccessfulFlag] [float] NULL,
	[IsReprocessFlag] [float] NULL,
	[TransactionErrorMessage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AVSResult] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCStatusCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[F29] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
