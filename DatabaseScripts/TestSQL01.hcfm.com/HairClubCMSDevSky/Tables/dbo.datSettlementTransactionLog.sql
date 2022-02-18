/* CreateDate: 11/11/2021 21:52:26.703 , ModifyDate: 02/02/2022 10:05:08.343 */
GO
CREATE TABLE [dbo].[datSettlementTransactionLog](
	[SettlementTransactionLogId] [int] IDENTITY(1,1) NOT NULL,
	[CenterNumber] [int] NOT NULL,
	[LoanNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PayDate] [datetime] NOT NULL,
	[SalesForceId] [nvarchar](36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [money] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[ResultProcess] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultMessage] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[SettlementTransactionLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
