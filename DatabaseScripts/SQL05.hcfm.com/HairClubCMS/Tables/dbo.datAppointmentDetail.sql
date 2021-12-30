/* CreateDate: 05/05/2020 17:42:48.490 , ModifyDate: 06/12/2020 19:13:10.530 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointmentDetail_SalesCodeID_INCL] ON [dbo].[datAppointmentDetail]
(
	[SalesCodeID] ASC
)
INCLUDE([AppointmentGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datAppointmentDetail_AppointmentGUID] ON [dbo].[datAppointmentDetail]
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
