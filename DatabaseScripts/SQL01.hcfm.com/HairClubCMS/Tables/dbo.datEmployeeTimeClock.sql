/* CreateDate: 08/05/2008 13:30:40.100 , ModifyDate: 05/26/2020 10:49:39.987 */
GO
CREATE TABLE [dbo].[datEmployeeTimeClock](
	[EmployeeTimeClockGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CheckInDate] [datetime] NULL,
	[CheckinTime] [datetime] NULL,
	[CheckOutDate] [datetime] NULL,
	[CheckOutTime] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datEmployeeTimeClock] PRIMARY KEY CLUSTERED
(
	[EmployeeTimeClockGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEmployeeTimeClock]  WITH NOCHECK ADD  CONSTRAINT [FK_datEmployeeTimeClock_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datEmployeeTimeClock] CHECK CONSTRAINT [FK_datEmployeeTimeClock_datEmployee]
GO
