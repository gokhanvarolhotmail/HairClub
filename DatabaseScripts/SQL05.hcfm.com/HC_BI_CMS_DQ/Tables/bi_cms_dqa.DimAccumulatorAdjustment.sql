/* CreateDate: 10/05/2010 13:47:24.450 , ModifyDate: 10/05/2010 13:47:24.793 */
GO
CREATE TABLE [bi_cms_dqa].[DimAccumulatorAdjustment](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[AccumulatorAdjustmentKey] [int] NULL,
	[AccumulatorAdjustmentSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[SalesOrderDetailKey] [int] NULL,
	[SalesOrderDetailSSID] [uniqueidentifier] NULL,
	[AppointmentKey] [int] NULL,
	[AppointmentSSID] [uniqueidentifier] NULL,
	[AccumulatorKey] [int] NULL,
	[AccumulatorSSID] [int] NULL,
	[AccumulatorDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityUsedOriginal] [int] NULL,
	[QuantityUsedAdjustment] [int] NULL,
	[QuantityTotalOriginal] [int] NULL,
	[QuantityTotalAdjustment] [int] NULL,
	[MoneyOriginal] [money] NULL,
	[MoneyAdjustment] [money] NULL,
	[DateOriginal] [date] NULL,
	[DateAdjustment] [date] NULL,
	[QuantityUsedNew] [int] NULL,
	[QuantityUsedChange] [int] NULL,
	[QuantityTotalNew] [int] NULL,
	[QuantityTotalChange] [int] NULL,
	[MoneyNew] [money] NULL,
	[MoneyChange] [money] NULL,
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
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimAccumulatorAdjustment] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_dqa].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
