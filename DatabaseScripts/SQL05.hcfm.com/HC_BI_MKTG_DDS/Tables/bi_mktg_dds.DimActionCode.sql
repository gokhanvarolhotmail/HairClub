/* CreateDate: 05/03/2010 12:21:09.420 , ModifyDate: 09/03/2021 09:35:32.450 */
GO
CREATE TABLE [bi_mktg_dds].[DimActionCode](
	[ActionCodeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimActionCode] PRIMARY KEY CLUSTERED
(
	[ActionCodeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimActionCode_ActionCodeKey] ON [bi_mktg_dds].[DimActionCode]
(
	[ActionCodeKey] ASC
)
INCLUDE([ActionCodeSSID],[ActionCodeDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimActionCode_RowIsCurrent_ActionCodeSSID_ActionCodeKey] ON [bi_mktg_dds].[DimActionCode]
(
	[ActionCodeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([ActionCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_dds].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimActionCode] ADD  CONSTRAINT [DF_DimActionCode_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
