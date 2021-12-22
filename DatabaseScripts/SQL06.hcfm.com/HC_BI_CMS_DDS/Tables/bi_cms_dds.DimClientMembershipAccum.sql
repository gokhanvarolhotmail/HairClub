/* CreateDate: 10/03/2019 23:03:40.270 , ModifyDate: 10/04/2019 00:14:16.047 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembershipAccum_AccumulatorDescriptionShort] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[AccumulatorDescriptionShort] ASC
)
INCLUDE([ClientMembershipKey],[AccumQuantityRemaining]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembershipAccum_AccumulatorSSID_IncludeQuantities] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[AccumulatorSSID] ASC
)
INCLUDE([ClientMembershipKey],[UsedAccumQuantity],[TotalAccumQuantity]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimClientMembershipAccum_ClientMembershipKeyAccumulatorKeyAccumDate] ON [bi_cms_dds].[DimClientMembershipAccum]
(
	[ClientMembershipKey] ASC,
	[AccumulatorKey] ASC,
	[AccumDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
