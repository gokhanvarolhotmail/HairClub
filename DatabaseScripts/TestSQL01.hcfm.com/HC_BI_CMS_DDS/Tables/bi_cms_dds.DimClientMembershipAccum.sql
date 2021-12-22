/* CreateDate: 10/05/2010 13:44:08.323 , ModifyDate: 09/16/2019 09:33:49.810 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimClientMembershipAccum](
	[ClientMembershipAccumKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientMembershipAccumSSID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[AccumulatorKey] [int] NOT NULL,
	[AccumulatorSSID] [int] NOT NULL,
	[AccumulatorDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UsedAccumQuantity] [int] NOT NULL,
	[AccumMoney] [money] NOT NULL,
	[AccumDate] [datetime] NOT NULL,
	[TotalAccumQuantity] [int] NOT NULL,
	[AccumQuantityRemaining] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimClientMembershipAccum] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAccumKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembershipAccum_ClientMembershipKeyAccumulatorKeyAccumDate] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[ClientMembershipKey] ASC,
	[AccumulatorKey] ASC,
	[AccumDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dimClientMemberShipAccum_ClientMembershipSSID] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[ClientMembershipSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembershipAccum_RowIsCurrent_ClientMembershipAccumSSID] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[RowIsCurrent] ASC,
	[ClientMembershipAccumSSID] ASC
)
INCLUDE([ClientMembershipAccumKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_DimClientMembershipAccum_ClientMembershipKey] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_AccumMoney]  DEFAULT ((0)) FOR [AccumMoney]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimClientMembershipAccum] ADD  CONSTRAINT [DF_DimClientMembershipAccum_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
