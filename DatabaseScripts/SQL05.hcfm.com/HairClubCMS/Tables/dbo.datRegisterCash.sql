/* CreateDate: 05/05/2020 17:42:51.887 , ModifyDate: 05/05/2020 17:43:13.343 */
GO
CREATE TABLE [dbo].[datRegisterCash](
	[RegisterCashGUID] [uniqueidentifier] NOT NULL,
	[RegisterTenderGUID] [uniqueidentifier] NOT NULL,
	[HundredCount] [int] NOT NULL,
	[FiftyCount] [int] NOT NULL,
	[TwentyCount] [int] NOT NULL,
	[TenCount] [int] NOT NULL,
	[FiveCount] [int] NOT NULL,
	[OneCount] [int] NOT NULL,
	[DollarCount] [int] NOT NULL,
	[HalfDollarCount] [int] NOT NULL,
	[QuarterCount] [int] NOT NULL,
	[DimeCount] [int] NOT NULL,
	[NickelCount] [int] NOT NULL,
	[PennyCount] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterCash] PRIMARY KEY CLUSTERED
(
	[RegisterCashGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
