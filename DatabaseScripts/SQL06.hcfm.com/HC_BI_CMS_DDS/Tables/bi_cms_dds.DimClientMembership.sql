/* CreateDate: 03/17/2022 11:57:04.633 , ModifyDate: 03/17/2022 12:55:47.260 */
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
	[RowTimeStamp] [binary](8) NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalMonthlyFee] [money] NULL
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimClientMembership] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
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
INCLUDE([ClientMembershipKey],[ClientMembershipStatusSSID],[ClientMembershipContractPrice],[ClientMembershipBeginDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembership_ClientSSID] ON [bi_cms_dds].[DimClientMembership]
(
	[ClientSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
