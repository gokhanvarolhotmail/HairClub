/* CreateDate: 08/01/2012 15:46:29.727 , ModifyDate: 08/01/2012 15:46:30.117 */
GO
CREATE TABLE [bi_cms_stage].[DimSecurityElement](
	[DataPkgKey] [int] NULL,
	[SecurityElementKey] [int] NULL,
	[SecurityElementSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SecurityElementDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SecurityElementDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SecurityElementSortOrder] [int] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
