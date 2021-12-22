CREATE TABLE [bi_cms_dds].[FactSurgeryCloseoutEmployee](
	[SurgeryCloseOutEmployeeKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
