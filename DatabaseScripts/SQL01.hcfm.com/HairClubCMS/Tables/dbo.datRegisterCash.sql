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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datRegisterCash_RegisterTenderGUID] ON [dbo].[datRegisterCash]
(
	[RegisterTenderGUID] ASC
)
INCLUDE([HundredCount],[FiftyCount],[TwentyCount],[TenCount],[FiveCount],[OneCount],[DollarCount],[HalfDollarCount],[QuarterCount],[DimeCount],[NickelCount],[PennyCount],[LastUpdate],[LastUpdateUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_HundredCount]  DEFAULT ((0)) FOR [HundredCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_FiftyCount]  DEFAULT ((0)) FOR [FiftyCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_TwentyCount]  DEFAULT ((0)) FOR [TwentyCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_TenCount]  DEFAULT ((0)) FOR [TenCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_FiveCount]  DEFAULT ((0)) FOR [FiveCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_OneCount]  DEFAULT ((0)) FOR [OneCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_DollarCount]  DEFAULT ((0)) FOR [DollarCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_HalfDollarCount]  DEFAULT ((0)) FOR [HalfDollarCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_QuarterCount]  DEFAULT ((0)) FOR [QuarterCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_DimeCount]  DEFAULT ((0)) FOR [DimeCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_NickelCount]  DEFAULT ((0)) FOR [NickelCount]
GO
ALTER TABLE [dbo].[datRegisterCash] ADD  CONSTRAINT [DF_datRegisterCash_PennyCount]  DEFAULT ((0)) FOR [PennyCount]
GO
ALTER TABLE [dbo].[datRegisterCash]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterCash_datRegisterTender] FOREIGN KEY([RegisterTenderGUID])
REFERENCES [dbo].[datRegisterTender] ([RegisterTenderGUID])
GO
ALTER TABLE [dbo].[datRegisterCash] CHECK CONSTRAINT [FK_datRegisterCash_datRegisterTender]
