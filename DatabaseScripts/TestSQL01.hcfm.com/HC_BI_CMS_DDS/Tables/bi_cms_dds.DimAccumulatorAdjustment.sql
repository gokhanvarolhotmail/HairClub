/* CreateDate: 10/05/2010 13:44:08.257 , ModifyDate: 09/16/2019 09:33:49.807 */
GO
CREATE TABLE [bi_cms_dds].[DimAccumulatorAdjustment](
	[AccumulatorAdjustmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AccumulatorAdjustmentSSID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDetailSSID] [uniqueidentifier] NOT NULL,
	[AppointmentKey] [int] NOT NULL,
	[AppointmentSSID] [uniqueidentifier] NOT NULL,
	[AccumulatorKey] [int] NOT NULL,
	[AccumulatorSSID] [int] NOT NULL,
	[AccumulatorDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[QuantityUsedOriginal] [int] NOT NULL,
	[QuantityUsedAdjustment] [int] NOT NULL,
	[QuantityTotalOriginal] [int] NOT NULL,
	[QuantityTotalAdjustment] [int] NOT NULL,
	[MoneyOriginal] [money] NOT NULL,
	[MoneyAdjustment] [money] NOT NULL,
	[DateOriginal] [date] NOT NULL,
	[DateAdjustment] [date] NOT NULL,
	[QuantityUsedNew] [int] NOT NULL,
	[QuantityUsedChange] [int] NOT NULL,
	[QuantityTotalNew] [int] NOT NULL,
	[QuantityTotalChange] [int] NOT NULL,
	[MoneyNew] [money] NOT NULL,
	[MoneyChange] [money] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimAccumulatorAdjustment] PRIMARY KEY CLUSTERED
(
	[AccumulatorAdjustmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_AccumulatorSSIDDateAdj] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[AccumulatorSSID] ASC,
	[DateAdjustment] ASC
)
INCLUDE([SalesOrderDetailKey],[AccumulatorKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_AccumulatorSSIDINCL] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[AccumulatorSSID] ASC
)
INCLUDE([SalesOrderDetailKey],[AccumulatorKey],[MoneyChange]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_ClientMembershipKeyAccumulatorSSIDDateAdjustment] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[ClientMembershipKey] ASC,
	[AccumulatorSSID] ASC,
	[DateAdjustment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_ClientMembershipSSID] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[ClientMembershipSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_RowIsCurrent_AccumulatorAdjustmentSSID] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[RowIsCurrent] ASC,
	[AccumulatorAdjustmentSSID] ASC
)
INCLUDE([AccumulatorAdjustmentKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_SalesOrderDetailKeyAccumulatorSSID] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[SalesOrderDetailKey] ASC,
	[AccumulatorSSID] ASC
)
INCLUDE([AccumulatorKey],[MoneyChange]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimAccumulatorAdjustment_SalesOrderDetailSSID] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[SalesOrderDetailSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_DimAccumulatorAdjustment_ClientMembershipKey] ON [bi_cms_dds].[DimAccumulatorAdjustment]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimAccumulatorAdjustment] ADD  CONSTRAINT [DF_DimAccumulatorAdjustment_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
