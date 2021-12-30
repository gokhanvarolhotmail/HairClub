/* CreateDate: 12/11/2012 16:21:19.507 , ModifyDate: 12/14/2012 14:30:31.113 */
GO
CREATE TABLE [dbo].[AuditStatusDetail](
	[asdId] [int] IDENTITY(1,1) NOT NULL,
	[AuditProcessName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TableName] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IN_FieldKey] [bigint] NULL,
	[IN_FieldSSID] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MI_MissingDate] [datetime] NULL,
	[MI_RecordID] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MI_CreatedDate] [datetime] NULL,
	[MI_UpdateDate] [datetime] NULL,
	[EX_FieldKey] [bigint] NULL,
	[EX_FieldSSID] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RI_DimensionName] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RI_FieldName] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RI_FieldKey] [bigint] NULL,
	[AB_DataPkgKey] [int] NULL,
	[AB_ProcessDate] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AB_NumRecordsInTable] [int] NULL,
	[AB_NumRecordsWithExceptions] [int] NULL,
	[AB_Status] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[SB_Date] [date] NULL,
	[SB_Center] [int] NULL,
	[SB_SourceCount] [bigint] NULL,
	[SB_WarehouseCount] [bigint] NULL,
	[SB_SourceMoney] [money] NULL,
	[SB_WarehouseMoney] [money] NULL,
	[SB_CountDifference]  AS ([SB_SourceCount]-[SB_WarehouseCount]),
	[SB_MoneyDifference]  AS ([SB_SourceMoney]-[SB_WarehouseMoney]),
	[CC_MinCDCDate] [datetime] NULL,
	[CC_DataFlowDate] [datetime] NULL,
	[AuditSystem] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_AuditStatusDetail] PRIMARY KEY CLUSTERED
(
	[asdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditStatusDetail] ADD  CONSTRAINT [DF_AuditStatusDetail_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
