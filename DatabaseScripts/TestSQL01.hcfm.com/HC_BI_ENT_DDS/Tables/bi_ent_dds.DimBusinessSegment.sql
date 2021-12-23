/* CreateDate: 05/03/2010 12:08:47.580 , ModifyDate: 09/16/2019 09:25:18.143 */
GO
CREATE TABLE [bi_ent_dds].[DimBusinessSegment](
	[BusinessSegmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessSegmentSSID] [int] NOT NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitKey] [int] NOT NULL,
	[BusinessUnitSSID] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimBusinessSegment] PRIMARY KEY CLUSTERED
(
	[BusinessSegmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimBusinessSegment_RowIsCurrent_BusinessSegmentSSID_BusinessSegmentKey] ON [bi_ent_dds].[DimBusinessSegment]
(
	[BusinessSegmentSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([BusinessSegmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_BusinessUnitSSID]  DEFAULT ((-2)) FOR [BusinessUnitSSID]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] ADD  CONSTRAINT [DF_DimBusinessSegment_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] ADD  CONSTRAINT [MSrepl_tran_version_default_584745EB_0BD6_437F_A9DB_0C4FD2FEA8EA_85575343]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment]  WITH NOCHECK ADD  CONSTRAINT [FK_DimBusinessSegment_DimBusinessUnit_BusinessUnitKey] FOREIGN KEY([BusinessUnitKey])
REFERENCES [bi_ent_dds].[DimBusinessUnit] ([BusinessUnitKey])
GO
ALTER TABLE [bi_ent_dds].[DimBusinessSegment] CHECK CONSTRAINT [FK_DimBusinessSegment_DimBusinessUnit_BusinessUnitKey]
GO
