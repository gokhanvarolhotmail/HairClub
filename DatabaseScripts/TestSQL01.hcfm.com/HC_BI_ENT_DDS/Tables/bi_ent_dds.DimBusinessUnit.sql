/* CreateDate: 05/03/2010 12:08:47.600 , ModifyDate: 09/16/2019 09:25:18.143 */
GO
CREATE TABLE [bi_ent_dds].[DimBusinessUnit](
	[BusinessUnitKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessUnitSSID] [int] NOT NULL,
	[BusinessUnitDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitBrandKey] [int] NOT NULL,
	[BusinessUnitBrandSSID] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimBusinessUnit] PRIMARY KEY CLUSTERED
(
	[BusinessUnitKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimBusinessUnit_RowIsCurrent_BusinessUnitSSID_BusinessUnitKey] ON [bi_ent_dds].[DimBusinessUnit]
(
	[BusinessUnitSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([BusinessUnitKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_BusinessUnitBrandSSID]  DEFAULT ((-2)) FOR [BusinessUnitBrandSSID]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] ADD  CONSTRAINT [DF_DimBusinessUnit_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] ADD  CONSTRAINT [MSrepl_tran_version_default_D837A145_C6AA_4929_AB44_34D8EEBEC4B7_101575400]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit]  WITH CHECK ADD  CONSTRAINT [FK_DimBusinessUnit_DimBusinessUnitBrand_BusinessUnitBrandKey] FOREIGN KEY([BusinessUnitBrandKey])
REFERENCES [bi_ent_dds].[DimBusinessUnitBrand] ([BusinessUnitBrandKey])
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnit] CHECK CONSTRAINT [FK_DimBusinessUnit_DimBusinessUnitBrand_BusinessUnitBrandKey]
GO
