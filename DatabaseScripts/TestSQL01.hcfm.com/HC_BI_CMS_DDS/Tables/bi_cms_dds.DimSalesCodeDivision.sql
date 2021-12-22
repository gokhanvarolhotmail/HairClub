/* CreateDate: 05/03/2010 12:17:23.100 , ModifyDate: 09/16/2019 09:33:49.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimSalesCodeDivision](
	[SalesCodeDivisionKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeDivisionSSID] [int] NOT NULL,
	[SalesCodeDivisionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDivisionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimSalesCodeDivision] PRIMARY KEY CLUSTERED
(
	[SalesCodeDivisionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDivision_RowIsCurrent_SalesCodeDivisionSSID_SalesCodeDivisionKey] ON [bi_cms_dds].[DimSalesCodeDivision]
(
	[SalesCodeDivisionSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesCodeDivisionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDivision_SalesCodeDivisionKey] ON [bi_cms_dds].[DimSalesCodeDivision]
(
	[SalesCodeDivisionKey] ASC
)
INCLUDE([SalesCodeDivisionSSID],[SalesCodeDivisionDescription]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimSalesCodeDivision] ADD  CONSTRAINT [MSrepl_tran_version_default_D06F12A5_A0DB_4C47_8151_BBF89ADB7BE3_165575628]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
