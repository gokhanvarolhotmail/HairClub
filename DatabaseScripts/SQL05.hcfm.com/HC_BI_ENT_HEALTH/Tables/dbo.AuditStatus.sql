/* CreateDate: 11/29/2012 10:32:28.750 , ModifyDate: 11/29/2012 10:32:28.750 */
GO
CREATE TABLE [dbo].[AuditStatus](
	[asId] [int] IDENTITY(1,1) NOT NULL,
	[AuditProcessName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TableName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AB_DataPkgKey] [int] NULL,
	[AB_NumRecordsInTable] [int] NULL,
	[AB_NumRecordsWithExceptions] [int] NULL,
	[CT_NumRecordsinSource] [int] NULL,
	[CT_NumRecordsinReplicatedSource] [int] NULL,
	[CT_NumRecordsinWarehouse] [int] NULL,
	[IN_NumOfRecords] [int] NULL,
	[MI_NumOfRecords] [int] NULL,
	[EX_NumOfRecords] [int] NULL,
	[RI_NumOfRecords] [int] NULL,
	[AuditProcessStatus] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SB_NumOfRecords] [int] NULL,
	[JF_RunDate] [datetime] NULL,
 CONSTRAINT [PK_AuditStatus] PRIMARY KEY CLUSTERED
(
	[asId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
