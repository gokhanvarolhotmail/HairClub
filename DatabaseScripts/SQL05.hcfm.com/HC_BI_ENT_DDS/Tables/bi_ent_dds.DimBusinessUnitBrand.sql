/* CreateDate: 05/03/2010 12:08:47.610 , ModifyDate: 01/08/2021 15:21:36.090 */
GO
CREATE TABLE [bi_ent_dds].[DimBusinessUnitBrand](
	[BusinessUnitBrandKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessUnitBrandSSID] [int] NOT NULL,
	[BusinessUnitBrandDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitBrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimBusinessUnitBrand] PRIMARY KEY CLUSTERED
(
	[BusinessUnitBrandKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimBusinessUnitBrand_RowIsCurrent_BusinessUnitBrandSSID_BusinessUnitBrandKey] ON [bi_ent_dds].[DimBusinessUnitBrand]
(
	[BusinessUnitBrandSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([BusinessUnitBrandKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitBrand] ADD  CONSTRAINT [DF_DimBusinessUnitBrand_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitBrand] ADD  CONSTRAINT [DF_DimBusinessUnitBrand_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitBrand] ADD  CONSTRAINT [DF_DimBusinessUnitBrand_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitBrand] ADD  CONSTRAINT [MSrepl_tran_version_default_B5999B95_D62F_42A9_B17E_5A4DE146269A_117575457]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
