/* CreateDate: 05/03/2010 12:19:43.037 , ModifyDate: 05/14/2010 13:32:16.133 */
GO
CREATE TABLE [bi_cms_stage].[DimSalesCodeDivision](
	[DataPkgKey] [int] NULL,
	[SalesCodeDivisionKey] [int] NULL,
	[SalesCodeDivisionSSID] [int] NULL,
	[SalesCodeDivisionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDivisionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesCodeDivision_SalesCodeDivisionSSID_DataPkgKey] ON [bi_cms_stage].[DimSalesCodeDivision]
(
	[DataPkgKey] ASC,
	[SalesCodeDivisionSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsNew1]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimSalesCodeDivision] ADD  CONSTRAINT [DF_DimSalesCodeDivision_IsValidated1]  DEFAULT ((0)) FOR [IsLoaded]
GO
