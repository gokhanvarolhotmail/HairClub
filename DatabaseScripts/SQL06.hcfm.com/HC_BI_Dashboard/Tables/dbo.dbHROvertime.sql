CREATE TABLE [dbo].[dbHROvertime](
	[CenterNumber] [int] NULL,
	[TotalHours] [decimal](18, 2) NULL,
	[DoubleOvertimeHours] [decimal](18, 2) NULL,
	[PayDate] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbHROvertime_PayDate] ON [dbo].[dbHROvertime]
(
	[PayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
