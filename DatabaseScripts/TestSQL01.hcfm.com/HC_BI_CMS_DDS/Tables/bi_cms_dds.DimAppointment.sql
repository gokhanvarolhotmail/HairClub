/* CreateDate: 06/27/2011 16:01:44.390 , ModifyDate: 09/16/2019 09:33:50.173 */
GO
CREATE TABLE [bi_cms_dds].[DimAppointment](
	[AppointmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[AppointmentDate] [datetime] NULL,
	[ResourceSSID] [int] NULL,
	[ResourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConfirmationTypeSSID] [int] NULL,
	[ConfirmationTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentTypeSSID] [int] NULL,
	[AppointmentTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStartTime] [time](7) NULL,
	[AppointmentEndTime] [time](7) NULL,
	[CheckInTime] [time](7) NULL,
	[CheckOutTime] [time](7) NULL,
	[AppointmentSubject] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatusDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactActivitySSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactContactSSID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanPrinTCommentFlag] [tinyint] NULL,
	[IsNonAppointmentFlag] [tinyint] NULL,
	[IsDeletedFlag] [tinyint] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_FactAppointment] PRIMARY KEY CLUSTERED
(
	[AppointmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_AppointmentDate_AppointmentType] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentDate] ASC,
	[AppointmentTypeSSID] ASC
)
INCLUDE([ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_ClientKey_AppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[ClientKey] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentTypeSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_ClientMembershipKeyAppointmentSubjectAppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[ClientMembershipKey] ASC,
	[AppointmentSubject] ASC,
	[AppointmentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_IsDeletedFlag_AppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_RowIsCurrent_AppointmentSSID] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_DimAppointment_ClientMembershipKey] ON [bi_cms_dds].[DimAppointment]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimAppointment] ADD  CONSTRAINT [DF_FactAppointment_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
