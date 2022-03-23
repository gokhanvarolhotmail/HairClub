/* CreateDate: 03/17/2022 11:57:07.640 , ModifyDate: 03/17/2022 11:57:17.607 */
GO
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
