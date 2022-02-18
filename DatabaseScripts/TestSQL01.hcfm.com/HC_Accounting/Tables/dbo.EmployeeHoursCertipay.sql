/* CreateDate: 03/05/2013 10:16:15.377 , ModifyDate: 01/27/2022 08:32:37.823 */
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
	[TravelEarnings] [bigint] NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
