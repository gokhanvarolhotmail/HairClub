/* CreateDate: 05/03/2010 12:19:13.100 , ModifyDate: 12/19/2018 10:04:20.420 */
GO
CREATE TABLE [bi_cms_dqa].[DimClientMembership](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ClientMembershipKey] [bigint] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipSSID] [int] NULL,
	[ClientMembershipStatusSSID] [int] NULL,
	[ClientMembershipStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipContractPrice] [money] NULL,
	[ClientMembershipContractPaidAmount] [money] NULL,
	[ClientMembershipMonthlyFee] [money] NULL,
	[ClientMembershipBeginDate] [datetime] NULL,
	[ClientMembershipEndDate] [datetime] NULL,
	[ClientMembershipCancelDate] [datetime] NULL,
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
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalMonthlyFee] [money] NULL,
 CONSTRAINT [PK_DimClientMembership] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
