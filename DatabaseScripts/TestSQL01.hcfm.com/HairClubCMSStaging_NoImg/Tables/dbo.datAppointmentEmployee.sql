/* CreateDate: 09/22/2008 06:29:40.160 , ModifyDate: 01/31/2022 08:32:31.877 */
GO
CREATE TABLE [dbo].[datAppointmentEmployee](
	[AppointmentEmployeeGUID] [uniqueidentifier] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datAppointmentEmployee] PRIMARY KEY CLUSTERED
(
	[AppointmentEmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_EmployeeGUID] ON [dbo].[datAppointmentEmployee]
(
	[EmployeeGUID] ASC
)
INCLUDE([AppointmentGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datAppointmentEmployee_AppointmentGUID] ON [dbo].[datAppointmentEmployee]
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datAppointmentEmployee_AppointmentGuid_EmployeeGuid] ON [dbo].[datAppointmentEmployee]
(
	[AppointmentGUID] ASC,
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datAppointmentEmployee_Keys] ON [dbo].[datAppointmentEmployee]
(
	[AppointmentGUID] ASC,
	[EmployeeGUID] ASC,
	[AppointmentEmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentEmployee]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentEmployee_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[datAppointmentEmployee] CHECK CONSTRAINT [FK_datAppointmentEmployee_datAppointment]
GO
ALTER TABLE [dbo].[datAppointmentEmployee]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentEmployee_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datAppointmentEmployee] CHECK CONSTRAINT [FK_datAppointmentEmployee_datEmployee]
GO
