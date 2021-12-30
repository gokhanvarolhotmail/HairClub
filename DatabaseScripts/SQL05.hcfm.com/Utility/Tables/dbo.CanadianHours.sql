/* CreateDate: 09/14/2017 19:30:47.140 , ModifyDate: 09/14/2017 19:30:47.140 */
GO
CREATE TABLE [dbo].[CanadianHours](
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[eeEEnum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomeDepartment] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayPeriodStartDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayPeriodEndDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalaryHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegularHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TravelHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OTHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoubleOTHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTOHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NonStatutoryHolidayHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BereavementHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JuryHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatutoryHoliday] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
