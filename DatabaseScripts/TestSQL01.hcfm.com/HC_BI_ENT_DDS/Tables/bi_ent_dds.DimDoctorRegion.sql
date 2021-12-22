/* CreateDate: 05/03/2010 12:08:47.687 , ModifyDate: 09/16/2019 09:25:18.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimDoctorRegion](
	[DoctorRegionKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DoctorRegionSSID] [int] NOT NULL,
	[DoctorRegionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DoctorRegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimDoctorRegion] PRIMARY KEY CLUSTERED
(
	[DoctorRegionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimDoctorRegion_RowIsCurrent_DoctorRegionSSID_DoctorRegionKey] ON [bi_ent_dds].[DimDoctorRegion]
(
	[DoctorRegionSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([DoctorRegionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimDoctorRegion] ADD  CONSTRAINT [DF_DimDoctorRegion_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimDoctorRegion] ADD  CONSTRAINT [DF_DimDoctorRegion_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimDoctorRegion] ADD  CONSTRAINT [DF_DimDoctorRegion_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimDoctorRegion] ADD  CONSTRAINT [MSrepl_tran_version_default_035EE3EB_0048_4717_9CBA_2DA6FE2DA015_181575685]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
