/* CreateDate: 08/29/2008 09:17:12.750 , ModifyDate: 05/26/2020 10:49:16.973 */
GO
CREATE TABLE [dbo].[datAppointmentDetail](
	[AppointmentDetailGUID] [uniqueidentifier] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[SalesCodeID] [int] NULL,
	[AppointmentDetailDuration] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Quantity] [int] NULL,
	[Price] [money] NULL,
 CONSTRAINT [PK_datAppointmentDetail] PRIMARY KEY CLUSTERED
(
	[AppointmentDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointmentDetail_AppointmentGUID_SalesCodeID] ON [dbo].[datAppointmentDetail]
(
	[AppointmentGUID] ASC,
	[SalesCodeID] ASC
)
INCLUDE([AppointmentDetailDuration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datAppointmentDetail_AppointmentGUID] ON [dbo].[datAppointmentDetail]
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datAppointmentDetail_AppointmentGuid_AppointmentDetailGuid] ON [dbo].[datAppointmentDetail]
(
	[AppointmentGUID] ASC,
	[AppointmentDetailGUID] ASC
)
INCLUDE([AppointmentDetailDuration],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[Price],[Quantity],[SalesCodeID],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentDetail_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datAppointmentDetail] CHECK CONSTRAINT [FK_datAppointmentDetail_cfgSalesCode]
GO
ALTER TABLE [dbo].[datAppointmentDetail]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentDetail_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[datAppointmentDetail] CHECK CONSTRAINT [FK_datAppointmentDetail_datAppointment]
GO
