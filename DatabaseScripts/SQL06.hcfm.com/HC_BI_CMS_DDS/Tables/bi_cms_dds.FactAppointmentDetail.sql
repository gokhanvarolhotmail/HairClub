CREATE TABLE [bi_cms_dds].[FactAppointmentDetail](
	[AppointmentDetailKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactAppointmentDetail_AppointmentKey_SalesCodeKey] ON [bi_cms_dds].[FactAppointmentDetail]
(
	[AppointmentKey] ASC
)
INCLUDE([SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
