/* CreateDate: 06/27/2011 16:10:51.227 , ModifyDate: 09/16/2019 09:33:49.863 */
GO
CREATE TABLE [bi_cms_dds].[FactAppointmentEmployee](
	[AppointmentEmployeeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[AppointmentEmployeeSSID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_FactAppointmentEmployee] PRIMARY KEY CLUSTERED
(
	[AppointmentEmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentEmployee_AppointmentDetailKeyINCL] ON [bi_cms_dds].[FactAppointmentEmployee]
(
	[AppointmentEmployeeKey] ASC
)
INCLUDE([AppointmentKey],[EmployeeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactAppointmentEmployee_EmployeeKey] ON [bi_cms_dds].[FactAppointmentEmployee]
(
	[EmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[FactAppointmentEmployee] ADD  CONSTRAINT [DF_FactAppointmentEmployee_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
