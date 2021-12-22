CREATE TABLE [dbo].[lkpPayPeriods](
	[PayPeriodID] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PayDate] [datetime] NULL,
	[PayGroup] [smallint] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
