/* CreateDate: 01/13/2014 15:03:53.023 , ModifyDate: 03/04/2014 14:15:09.990 */
GO
CREATE TABLE [dbo].[tmpCertipay](
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DepartmentNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PeriodStart] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PeriodEnd] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalaryHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegularHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OTHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTOHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FuneralHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JuryHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalaryEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegularEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OTEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PTOEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FuneralEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[JuryEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TravelHours] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TravelEarnings] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpCertipay] ADD  CONSTRAINT [DF_tmpCertipay_IsProcessedFlag]  DEFAULT ((0)) FOR [IsProcessedFlag]
GO
