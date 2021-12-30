/* CreateDate: 10/05/2010 13:47:24.667 , ModifyDate: 03/22/2017 21:15:46.093 */
GO
CREATE TABLE [bi_cms_dqa].[DimClientMembershipAccum](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ClientMembershipAccumKey] [int] NULL,
	[ClientMembershipAccumSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[AccumulatorKey] [int] NULL,
	[AccumulatorSSID] [int] NULL,
	[AccumulatorDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccumulatorDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UsedAccumQuantity] [int] NULL,
	[AccumMoney] [decimal](21, 6) NULL,
	[AccumDate] [datetime] NULL,
	[TotalAccumQuantity] [int] NULL,
	[AccumQuantityRemaining] [int] NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_DimClientMembershipAccum_1] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_AccumMoney]  DEFAULT ((0)) FOR [AccumMoney]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
