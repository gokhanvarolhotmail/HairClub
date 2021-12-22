/* CreateDate: 06/27/2011 16:01:43.417 , ModifyDate: 09/16/2019 09:33:49.837 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[FactSurgeryCloseoutEmployee](
	[SurgeryCloseOutEmployeeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentKey] [int] NULL,
	[EmployeeKey] [int] NULL,
	[CutCount] [int] NULL,
	[PlaceCount] [int] NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[SurgeryCloseOutEmployeeSSID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_FactSurgeryCloseoutEmployee] PRIMARY KEY CLUSTERED
(
	[SurgeryCloseOutEmployeeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[FactSurgeryCloseoutEmployee] ADD  CONSTRAINT [DF_FactSurgeryCloseoutEmployee_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
