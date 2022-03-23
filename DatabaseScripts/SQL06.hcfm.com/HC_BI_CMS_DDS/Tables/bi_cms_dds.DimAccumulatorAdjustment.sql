/* CreateDate: 03/17/2022 11:57:04.450 , ModifyDate: 03/17/2022 11:57:14.093 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
