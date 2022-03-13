/* CreateDate: 05/03/2010 12:17:23.087 , ModifyDate: 03/10/2022 14:15:13.803 */
GO
CREATE TABLE [bi_cms_dds].[DimSalesCodeDepartment](
	[SalesCodeDepartmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeDepartmentSSID] [int] NOT NULL,
	[SalesCodeDepartmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDepartmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDivisionKey] [int] NOT NULL,
	[SalesCodeDivisionSSID] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimSalesCodeDepartment] PRIMARY KEY CLUSTERED
(
	[SalesCodeDepartmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDepartment_RowIsCurrent_SalesCodeDepartmentSSID_SalesCodeDepartmentKey] ON [bi_cms_dds].[DimSalesCodeDepartment]
(
	[SalesCodeDepartmentSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesCodeDepartmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDepartment_SalesCodeDepartmentKey] ON [bi_cms_dds].[DimSalesCodeDepartment]
(
	[SalesCodeDepartmentKey] ASC
)
INCLUDE([SalesCodeDepartmentSSID],[SalesCodeDepartmentDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDepartment] ADD  CONSTRAINT [DF_DimSalesCodeDepartment_SalesCodeDivisionSSID]  DEFAULT ((-2)) FOR [SalesCodeDivisionSSID]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDepartment] ADD  CONSTRAINT [DF_DimSalesCodeDepartment_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDepartment] ADD  CONSTRAINT [DF_DimSalesCodeDepartment_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDepartment] ADD  CONSTRAINT [DF_DimSalesCodeDepartment_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDepartment] ADD  CONSTRAINT [MSrepl_tran_version_default_CC53FF30_C023_4696_BD20_8BB1536FAFBA_149575571]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
