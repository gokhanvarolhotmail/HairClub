/* CreateDate: 06/27/2011 16:11:09.607 , ModifyDate: 03/17/2022 11:56:42.660 */
GO
CREATE TABLE [bi_cms_dds].[FactAppointmentDetail](
	[AppointmentDetailKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentKey] [int] NULL,
	[SalesCodeKey] [int] NULL,
	[AppointmentDetailDuration] [int] NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[AppointmentDetailSSID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_FactAppointmentDetail] PRIMARY KEY CLUSTERED
(
	[AppointmentDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentDetail_AppointmentKey] ON [bi_cms_dds].[FactAppointmentDetail]
(
	[AppointmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentDetail_INCL] ON [bi_cms_dds].[FactAppointmentDetail]
(
	[AppointmentDetailKey] ASC
)
INCLUDE([SalesCodeKey],[AppointmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[FactAppointmentDetail] ADD  CONSTRAINT [DF_FactAppointmentDetail_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
