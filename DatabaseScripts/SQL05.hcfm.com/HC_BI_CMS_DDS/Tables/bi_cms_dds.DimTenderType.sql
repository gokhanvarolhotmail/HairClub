/* CreateDate: 05/03/2010 12:17:23.233 , ModifyDate: 11/21/2019 15:17:45.923 */
GO
CREATE TABLE [bi_cms_dds].[DimTenderType](
	[TenderTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TenderTypeSSID] [int] NOT NULL,
	[TenderTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TenderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaxOccurrences] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimTenderType] PRIMARY KEY CLUSTERED
(
	[TenderTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimTenderType_RowIsCurrent_TenderTypeSSID_TenderTypeKey] ON [bi_cms_dds].[DimTenderType]
(
	[TenderTypeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([TenderTypeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimTenderType_TenderTypeKey] ON [bi_cms_dds].[DimTenderType]
(
	[TenderTypeKey] ASC
)
INCLUDE([TenderTypeSSID],[TenderTypeDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimTenderType] ADD  CONSTRAINT [MSrepl_tran_version_default_C591EBE5_4F4B_4120_80F0_72312A716CA2_245575913]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
