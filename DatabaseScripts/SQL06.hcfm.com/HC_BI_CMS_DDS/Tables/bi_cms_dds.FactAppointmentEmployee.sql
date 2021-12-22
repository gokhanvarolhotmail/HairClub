/* CreateDate: 10/03/2019 23:03:42.183 , ModifyDate: 10/04/2019 00:23:39.490 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[FactAppointmentEmployee](
	[AppointmentEmployeeKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [ix_FactAppointmentEmployee_AppointmentKey] ON [bi_cms_dds].[FactAppointmentEmployee]
(
	[AppointmentKey] ASC
)
INCLUDE([EmployeeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
