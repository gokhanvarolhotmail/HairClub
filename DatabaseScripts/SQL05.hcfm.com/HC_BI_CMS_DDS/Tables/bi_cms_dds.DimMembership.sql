/* CreateDate: 05/03/2010 12:17:23.060 , ModifyDate: 03/10/2022 14:15:13.650 */
GO
CREATE TABLE [bi_cms_dds].[DimMembership](
	[MembershipKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MembershipSSID] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentKey] [int] NOT NULL,
	[BusinessSegmentSSID] [int] NOT NULL,
	[RevenueGroupSSID] [int] NOT NULL,
	[RevenueGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RevenueGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderSSID] [int] NOT NULL,
	[GenderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipDurationMonths] [int] NOT NULL,
	[MembershipContractPrice] [money] NULL,
	[MembershipMonthlyFee] [money] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[MembershipSortOrder] [int] NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimMembership] PRIMARY KEY CLUSTERED
(
	[MembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimMembership_MembershipKey] ON [bi_cms_dds].[DimMembership]
(
	[MembershipKey] ASC
)
INCLUDE([MembershipSSID],[MembershipDescription],[RevenueGroupDescription],[GenderDescription],[MembershipDurationMonths],[MembershipContractPrice],[MembershipMonthlyFee]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimMembership_RowIsCurrent_MembershipSSID_MembershipKey] ON [bi_cms_dds].[DimMembership]
(
	[MembershipSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([MembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
ALTER TABLE [bi_cms_dds].[DimMembership] ADD  CONSTRAINT [DF_DimMembership_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimMembership] ADD  CONSTRAINT [DF_DimMembership_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimMembership] ADD  CONSTRAINT [DF_DimMembership_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimMembership] ADD  CONSTRAINT [MSrepl_tran_version_default_12D6E07D_685B_4E9D_9765_959FA7FD467B_117575457]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
