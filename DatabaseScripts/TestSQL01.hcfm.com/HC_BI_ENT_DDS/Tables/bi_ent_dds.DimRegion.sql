/* CreateDate: 07/11/2011 12:13:52.040 , ModifyDate: 09/16/2019 09:25:18.143 */
GO
CREATE TABLE [bi_ent_dds].[DimRegion](
	[RegionKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RegionSSID] [int] NOT NULL,
	[RegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RegionSortOrder] [int] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[RegionNumber] [int] NULL,
 CONSTRAINT [PK_DimRegion] PRIMARY KEY CLUSTERED
(
	[RegionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimRegion_RowIsCurrent_RegionSSID_RegionKey] ON [bi_ent_dds].[DimRegion]
(
	[RegionSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([RegionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimRegion] ADD  CONSTRAINT [DF_DimRegion_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimRegion] ADD  CONSTRAINT [MSrepl_tran_version_default_24316ED3_E06D_4B6D_8004_E113F115578C_309576141]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
