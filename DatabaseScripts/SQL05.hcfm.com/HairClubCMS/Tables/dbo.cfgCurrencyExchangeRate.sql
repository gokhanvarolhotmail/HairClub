/* CreateDate: 05/05/2020 17:42:41.580 , ModifyDate: 05/05/2020 17:43:00.143 */
GO
CREATE TABLE [dbo].[cfgCurrencyExchangeRate](
	[CurrencyExchangeRateID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
