/* CreateDate: 05/05/2020 17:42:49.750 , ModifyDate: 05/05/2020 17:43:09.777 */
GO
CREATE TABLE [dbo].[datCreditCardTransactionLog](
	[CreditCardTransactionLogGUID] [uniqueidentifier] NOT NULL,
	[SalesOrderTenderGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[EFTTransactionID] [bigint] NULL,
	[SecureDate] [datetime] NULL,
	[SettleDate] [datetime] NULL,
	[ApprovalCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [money] NOT NULL,
	[Verbiage] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MSoftCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHardCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExpirationDate] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MonetraTransactionId] [bigint] NULL,
	[IsTokenUsedFlag] [bit] NOT NULL,
	[IsCardPresentFlag] [bit] NOT NULL,
	[EmployeeID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MachineTerminalID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IpAddress] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSuccessfulFlag] [bit] NOT NULL,
	[TransactionErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NULL,
	[AVSResult] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datCreditCardTransactionLog] PRIMARY KEY CLUSTERED
(
	[CreditCardTransactionLogGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
