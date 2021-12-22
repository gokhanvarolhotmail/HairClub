/* CreateDate: 10/03/2019 22:32:12.287 , ModifyDate: 10/03/2019 22:32:13.680 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK__Employee__3214EC2739095C7C] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
