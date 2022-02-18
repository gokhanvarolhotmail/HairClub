/* CreateDate: 05/03/2010 12:21:09.643 , ModifyDate: 01/27/2022 09:18:11.483 */
GO
CREATE TABLE [bi_mktg_dds].[DimSalesType](
	[SalesTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[LTVMale] [money] NULL,
	[LTVFemale] [money] NULL,
	[LTVMaleYearly] [money] NULL,
	[LTVFemaleYearly] [money] NULL,
	[BusinessSegment] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimSalesType] PRIMARY KEY CLUSTERED
(
	[SalesTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesType_RowIsCurrent_SalesTypeSSID_SalesTypeKey] ON [bi_mktg_dds].[DimSalesType]
(
	[SalesTypeSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesTypeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_mktg_dds].[DimSalesType] ADD  CONSTRAINT [DF_DimSalesType_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimSalesType] ADD  CONSTRAINT [DF_DimSalesType_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimSalesType] ADD  CONSTRAINT [DF_DimSalesType_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
