/* CreateDate: 05/03/2010 12:08:47.803 , ModifyDate: 01/08/2021 15:21:36.437 */
GO
CREATE TABLE [bi_ent_dds].[DimRevenueGroup](
	[RevenueGroupKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RevenueGroupSSID] [int] NOT NULL,
	[RevenueGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RevenueGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimRevenueGroup] PRIMARY KEY CLUSTERED
(
	[RevenueGroupKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimRevenueGroup_RowIsCurrent_RevenueGroupSSID_RevenueGroupKey] ON [bi_ent_dds].[DimRevenueGroup]
(
	[RevenueGroupSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([RevenueGroupKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimRevenueGroup] ADD  CONSTRAINT [DF_DimRevenueGroup_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimRevenueGroup] ADD  CONSTRAINT [DF_DimRevenueGroup_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimRevenueGroup] ADD  CONSTRAINT [DF_DimRevenueGroup_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimRevenueGroup] ADD  CONSTRAINT [MSrepl_tran_version_default_85ED3013_84EB_43FF_BC38_20D6E429CEA0_325576198]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
