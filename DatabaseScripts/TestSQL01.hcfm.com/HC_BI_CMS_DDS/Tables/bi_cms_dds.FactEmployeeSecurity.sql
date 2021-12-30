/* CreateDate: 08/02/2012 10:19:49.890 , ModifyDate: 09/16/2019 09:33:49.860 */
GO
CREATE TABLE [bi_cms_dds].[FactEmployeeSecurity](
	[EmployeeSecurityKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmployeeKey] [int] NULL,
	[EmployeePositionKey] [int] NULL,
	[ActiveDirectoryGroupKey] [int] NULL,
	[HasAccess] [int] NULL,
	[SecurityElementKey] [int] NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[AppointmentEmployeeSSID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_FactEmployeeSecurity] PRIMARY KEY CLUSTERED
(
	[EmployeeSecurityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[FactEmployeeSecurity] ADD  CONSTRAINT [DF_FactEmployeeSecurity_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
