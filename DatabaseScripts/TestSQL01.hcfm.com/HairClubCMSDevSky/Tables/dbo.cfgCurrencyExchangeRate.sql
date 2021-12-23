/* CreateDate: 10/30/2008 09:06:22.060 , ModifyDate: 12/07/2021 16:20:16.103 */
GO
CREATE TABLE [dbo].[cfgCurrencyExchangeRate](
	[CurrencyExchangeRateID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CurrencyTypeID] [int] NULL,
	[ExchangeRate] [float] NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgCurrencyExchangeRate] PRIMARY KEY CLUSTERED
(
	[CurrencyExchangeRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCurrencyExchangeRate] ADD  CONSTRAINT [DF_cfgCurrencyExchangeRate_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[cfgCurrencyExchangeRate] ADD  CONSTRAINT [DF_cfgCurrencyExchangeRate_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgCurrencyExchangeRate]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgCurrencyExchangeRate_lkpCurrencyType] FOREIGN KEY([CurrencyTypeID])
REFERENCES [dbo].[lkpCurrencyType] ([CurrencyTypeID])
GO
ALTER TABLE [dbo].[cfgCurrencyExchangeRate] CHECK CONSTRAINT [FK_cfgCurrencyExchangeRate_lkpCurrencyType]
GO
