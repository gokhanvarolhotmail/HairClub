/* CreateDate: 07/11/2011 15:45:17.340 , ModifyDate: 06/18/2014 01:38:25.257 */
GO
CREATE TABLE [dbo].[EmployeeHoursCertipay](
	[LastName] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomeDepartment] [int] NULL,
	[EmployeeNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PeriodBegin] [datetime] NULL,
	[PeriodEnd] [datetime] NULL,
	[CheckDate] [datetime] NULL,
	[SalaryHours] [real] NULL,
	[RegularHours] [real] NULL,
	[OverTimeHours] [real] NULL,
	[PTO_Hours] [real] NULL,
	[PerformerHomeCenter] [int] NULL,
	[ImportDate] [datetime] NULL,
	[GeneralLedger] [int] NULL,
	[PTHours] [real] NULL,
	[FuneralHours] [real] NULL,
	[JuryHours] [real] NULL,
	[SalaryEarnings] [bigint] NULL,
	[RegularEarnings] [bigint] NULL,
	[OTEarnings] [bigint] NULL,
	[PTEarnings] [bigint] NULL,
	[PTOEarnings] [bigint] NULL,
	[FuneralEarnings] [bigint] NULL,
	[JuryEarnings] [bigint] NULL,
	[TravelHours] [real] NULL,
	[TravelEarnings] [bigint] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EmployeeHoursCertipay_PeriodEndINCL] ON [dbo].[EmployeeHoursCertipay]
(
	[PeriodEnd] ASC
)
INCLUDE([EmployeeID],[SalaryHours],[RegularHours],[TravelHours]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
