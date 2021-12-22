/* CreateDate: 05/03/2010 12:08:47.673 , ModifyDate: 09/16/2019 09:25:18.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimCenterType](
	[CenterTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterTypeSSID] [int] NOT NULL,
	[CenterTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimCenterType] PRIMARY KEY CLUSTERED
(
	[CenterTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimCenterType_RowIsCurrent_CenterTypeSSID_CenterTypeKey] ON [bi_ent_dds].[DimCenterType]
(
	[CenterTypeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([CenterTypeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimCenterType] ADD  CONSTRAINT [DF_DimCenterType_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimCenterType] ADD  CONSTRAINT [DF_DimCenterType_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimCenterType] ADD  CONSTRAINT [DF_DimCenterType_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimCenterType] ADD  CONSTRAINT [MSrepl_tran_version_default_A8BE0FB4_2C5A_49FB_9206_63970B849C00_165575628]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
