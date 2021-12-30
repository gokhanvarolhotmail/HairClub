/* CreateDate: 05/05/2020 17:42:49.857 , ModifyDate: 05/05/2020 17:43:09.777 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
