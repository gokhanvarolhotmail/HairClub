/* CreateDate: 05/03/2010 12:17:23.023 , ModifyDate: 03/17/2022 11:56:40.923 */
GO
CREATE TABLE [bi_cms_dds].[DimClientMembership](
	[ClientMembershipKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientKey] [int] NOT NULL,
	[ClientSSID] [uniqueidentifier] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipSSID] [int] NOT NULL,
	[ClientMembershipStatusSSID] [int] NOT NULL,
	[ClientMembershipStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipContractPrice] [money] NOT NULL,
	[ClientMembershipContractPaidAmount] [money] NOT NULL,
	[ClientMembershipMonthlyFee] [money] NOT NULL,
	[ClientMembershipBeginDate] [datetime] NOT NULL,
	[ClientMembershipEndDate] [datetime] NOT NULL,
	[ClientMembershipCancelDate] [datetime] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalMonthlyFee] [money] NULL,
 CONSTRAINT [PK_DimClientMembership] PRIMARY KEY CLUSTERED
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClientMembership_ClientMembershipKey] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientMembershipKey] ASC
)
INCLUDE([ClientMembershipSSID],[ClientMembershipStatusDescription],[ClientMembershipContractPrice],[ClientMembershipContractPaidAmount],[ClientMembershipMonthlyFee]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClientMembership_ClientMembershipKey_MembershipKey_ClientKey_CenterKey] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientMembershipKey] ASC
)
INCLUDE([MembershipKey],[ClientKey],[CenterKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimClientMembership_RowIsCurrent_ClientMembershipSSID_MembershipKey] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientMembershipSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([MembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembership_ClientKeyINCL] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientKey] ASC
)
INCLUDE([ClientMembershipKey],[ClientMembershipStatusSSID],[ClientMembershipContractPrice],[ClientMembershipBeginDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembership_ClientSSID] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembership] ADD  CONSTRAINT [DF_DimClientMembership_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembership] ADD  CONSTRAINT [MSrepl_tran_version_default_9B21D088_1EDA_482D_AF66_7666E1B855AF_69575286]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
