/* CreateDate: 10/03/2019 23:03:41.557 , ModifyDate: 04/27/2021 15:57:58.023 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimSalesCodeDepartment](
	[SalesCodeDepartmentKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDepartment_RowIsCurrent_SalesCodeDepartmentSSID_SalesCodeDepartmentKey] ON [bi_cms_dds].[DimSalesCodeDepartment]
(
	[SalesCodeDepartmentSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesCodeDepartmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDepartment_SalesCodeDepartmentKey] ON [bi_cms_dds].[DimSalesCodeDepartment]
(
	[SalesCodeDepartmentKey] ASC
)
INCLUDE([SalesCodeDepartmentSSID],[SalesCodeDepartmentDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesCodeDepartment_SalesCodeDivisionSSID] ON [bi_cms_dds].[DimSalesCodeDepartment]
(
	[SalesCodeDivisionSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
