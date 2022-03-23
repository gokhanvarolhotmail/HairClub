/* CreateDate: 03/17/2022 11:57:07.717 , ModifyDate: 03/17/2022 11:57:17.927 */
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
