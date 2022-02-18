/* CreateDate: 02/03/2009 07:03:59.257 , ModifyDate: 01/31/2022 08:32:31.770 */
GO
CREATE TABLE [dbo].[datSurgeryCloseoutEmployee](
	[SurgeryCloseoutEmployeeGUID] [uniqueidentifier] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[CutCount] [int] NULL,
	[PlaceCount] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_SurgeryCloseoutEmployee] PRIMARY KEY CLUSTERED
(
	[SurgeryCloseoutEmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSurgeryCloseoutEmployee]  WITH CHECK ADD  CONSTRAINT [FK_datSurgeryCloseoutEmployee_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datSurgeryCloseoutEmployee] CHECK CONSTRAINT [FK_datSurgeryCloseoutEmployee_datAppointment]
GO
ALTER TABLE [dbo].[datSurgeryCloseoutEmployee]  WITH CHECK ADD  CONSTRAINT [FK_datSurgeryCloseoutEmployee_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSurgeryCloseoutEmployee] CHECK CONSTRAINT [FK_datSurgeryCloseoutEmployee_datEmployee]
GO
