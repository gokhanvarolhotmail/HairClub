/* CreateDate: 12/21/2015 07:09:15.250 , ModifyDate: 12/28/2021 09:20:54.650 */
GO
CREATE TABLE [dbo].[datClientCreditCard](
	[ClientCreditCardID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[CreditCardTypeID] [int] NOT NULL,
	[AccountNumberLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountExpiration] [date] NOT NULL,
	[CardHolderName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Token] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsTokenValidFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientCreditCard] PRIMARY KEY CLUSTERED
(
	[ClientCreditCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientCreditCard_ClientGUID] ON [dbo].[datClientCreditCard]
(
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientCreditCard]  WITH CHECK ADD  CONSTRAINT [FK_datClientCreditCard_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientCreditCard] CHECK CONSTRAINT [FK_datClientCreditCard_datClient]
GO
ALTER TABLE [dbo].[datClientCreditCard]  WITH CHECK ADD  CONSTRAINT [FK_datClientCreditCard_lkpCreditCardType] FOREIGN KEY([CreditCardTypeID])
REFERENCES [dbo].[lkpCreditCardType] ([CreditCardTypeID])
GO
ALTER TABLE [dbo].[datClientCreditCard] CHECK CONSTRAINT [FK_datClientCreditCard_lkpCreditCardType]
GO
