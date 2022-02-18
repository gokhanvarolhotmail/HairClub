/* CreateDate: 05/03/2010 12:21:09.480 , ModifyDate: 01/27/2022 09:18:11.617 */
GO
CREATE TABLE [bi_mktg_dds].[DimActivityResult](
	[ActivityResultKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActivityResultSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsShow] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsSale] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContractNumber] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContractAmount] [decimal](15, 4) NOT NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InitialPayment] [decimal](15, 4) NOT NULL,
	[NumberOfGraphs] [int] NOT NULL,
	[OrigApptDate] [date] NOT NULL,
	[DateSaved] [date] NOT NULL,
	[RescheduledFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RescheduledDate] [date] NOT NULL,
	[SurgeryOffered] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferredToDoctor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimActivityResult] PRIMARY KEY CLUSTERED
(
	[ActivityResultKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityResult_ActivityResultKey] ON [bi_mktg_dds].[DimActivityResult]
(
	[ActivityResultKey] ASC
)
INCLUDE([ContractNumber],[ContractAmount],[InitialPayment],[NumberOfGraphs]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimActivityResult_RowIsCurrent_ActivityResultSSID_ActivityResultKey] ON [bi_mktg_dds].[DimActivityResult]
(
	[ActivityResultKey] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SFDC_TaskID],[SFDC_LeadID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimActivityResult_ResultCodeSSID] ON [bi_mktg_dds].[DimActivityResult]
(
	[ResultCodeSSID] ASC,
	[OrigApptDate] ASC
)
INCLUDE([ActivityResultKey],[CenterSSID],[SourceSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ActionCodeSSID]  DEFAULT ('') FOR [ActionCodeSSID]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ActionCodeDescription]  DEFAULT ('') FOR [ActionCodeDescription]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ResultCodeSSID]  DEFAULT ('') FOR [ResultCodeSSID]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_ResultCodeDescription]  DEFAULT ('') FOR [ResultCodeDescription]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_SourceSSID]  DEFAULT ('') FOR [SourceSSID]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_SourceDescription]  DEFAULT ('') FOR [SourceDescription]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimActivityResult] ADD  CONSTRAINT [DF_DimActivityResult_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
