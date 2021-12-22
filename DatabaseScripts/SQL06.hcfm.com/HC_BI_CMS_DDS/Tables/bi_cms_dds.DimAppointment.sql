/* CreateDate: 10/03/2019 23:03:40.067 , ModifyDate: 12/04/2019 23:17:08.803 */
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
	[RowTimeStamp] [binary](8) NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_FactAppointment] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_AppointmentDate_AppointmentType] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentDate] ASC,
	[AppointmentTypeSSID] ASC
)
INCLUDE([ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_AppointmentDate_INCLUDEClientKeyCheckOutTime] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentDate] ASC
)
INCLUDE([ClientKey],[CheckOutTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_CenterSSID_ClientKey_ApptDate] ON [bi_cms_dds].[DimAppointment]
(
	[CenterSSID] ASC,
	[ClientKey] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentKey],[AppointmentSSID],[CenterKey],[ClientMembershipKey],[AppointmentStartTime],[AppointmentEndTime],[IsDeletedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_ClientKey_AppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[ClientKey] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentTypeSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_ClientKeyIsDeletedFlagAppointmentDate_INCLUDEAppointmentKey] ON [bi_cms_dds].[DimAppointment]
(
	[ClientKey] ASC,
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_ClientMembershipKeyAppointmentSubjectAppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[ClientMembershipKey] ASC,
	[AppointmentSubject] ASC,
	[AppointmentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_IsDeletedFlag_AppointmentDate] ON [bi_cms_dds].[DimAppointment]
(
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_IsDeletedFlagAppointmentDate_INCLUDEClientKeyCheckOutTime] ON [bi_cms_dds].[DimAppointment]
(
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([ClientKey],[CheckOutTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_OnContactActivitySSID_INCLUDEAppointmentKey] ON [bi_cms_dds].[DimAppointment]
(
	[OnContactActivitySSID] ASC
)
INCLUDE([AppointmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimAppointment_RowIsCurrent_AppointmentSSID] ON [bi_cms_dds].[DimAppointment]
(
	[AppointmentSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [Temp_DimAppointment_ClientMembershipKey] ON [bi_cms_dds].[DimAppointment]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
