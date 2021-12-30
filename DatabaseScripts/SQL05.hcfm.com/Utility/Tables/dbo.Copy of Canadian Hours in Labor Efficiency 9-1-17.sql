/* CreateDate: 09/14/2017 19:14:58.720 , ModifyDate: 09/14/2017 19:14:58.720 */
GO
CREATE TABLE [dbo].[Copy of Canadian Hours in Labor Efficiency 9-1-17](
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomeDepartment] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayPeriodStartDate] [datetime] NULL,
	[PayPeriodEndDate] [datetime] NULL,
	[CheckDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalaryHours] [real] NULL,
	[RegularHours] [real] NULL,
	[TravelHours] [real] NULL,
	[OTHours] [real] NULL,
	[DoubleOTHours] [real] NULL,
	[PTOHours] [real] NULL,
	[NonStatutoryHolidayHours] [real] NULL,
	[BereavementHours] [real] NULL,
	[JuryHours] [real] NULL,
	[StatutoryHoliday] [real] NULL
) ON [PRIMARY]
GO
