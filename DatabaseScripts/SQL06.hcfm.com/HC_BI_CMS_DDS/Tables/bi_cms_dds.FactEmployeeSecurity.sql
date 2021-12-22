CREATE TABLE [bi_cms_dds].[FactEmployeeSecurity](
	[EmployeeSecurityKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
