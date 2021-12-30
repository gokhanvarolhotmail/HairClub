/* CreateDate: 02/21/2013 10:59:30.830 , ModifyDate: 02/21/2013 10:59:30.880 */
GO
CREATE TABLE [dbo].[lkpCanadianExchangeRates](
	[ExchangeRateID] [int] IDENTITY(1,1) NOT NULL,
	[ExchangeRate] [float] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
