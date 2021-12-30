/* CreateDate: 06/27/2011 16:44:15.977 , ModifyDate: 06/27/2011 16:45:47.390 */
GO
CREATE TABLE [bi_cms_stage].[DimHairSystemOrderStatus](
	[DataPkgKey] [int] NULL,
	[HairSystemOrderStatusKey] [int] NULL,
	[HairSystemOrderStatusSortOrder] [int] NULL,
	[HairSystemOrderStatusSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanApplyFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanTransferFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanEditFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanCancelFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPreallocationFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanRedoFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanRepairFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShowInHistoryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanAddToStockFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IncludeInMembershipCountFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanRequestCreditFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimHairSystemOrderStatus] ADD  CONSTRAINT [DF_DimHairSystemOrderStatus_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
