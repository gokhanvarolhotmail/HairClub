/* CreateDate: 10/03/2019 23:03:39.870 , ModifyDate: 10/03/2019 23:03:39.870 */
GO
create procedure [sp_MSins_bi_cms_ddsDimAccumulatorAdjustment]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 int,
    @c6 uniqueidentifier,
    @c7 int,
    @c8 uniqueidentifier,
    @c9 int,
    @c10 int,
    @c11 varchar(50),
    @c12 varchar(10),
    @c13 int,
    @c14 int,
    @c15 int,
    @c16 int,
    @c17 money,
    @c18 money,
    @c19 date,
    @c20 date,
    @c21 int,
    @c22 int,
    @c23 int,
    @c24 int,
    @c25 money,
    @c26 money,
    @c27 tinyint,
    @c28 datetime,
    @c29 datetime,
    @c30 varchar(200),
    @c31 tinyint,
    @c32 int,
    @c33 int
as
begin
	insert into [bi_cms_dds].[DimAccumulatorAdjustment] (
		[AccumulatorAdjustmentKey],
		[AccumulatorAdjustmentSSID],
		[ClientMembershipKey],
		[ClientMembershipSSID],
		[SalesOrderDetailKey],
		[SalesOrderDetailSSID],
		[AppointmentKey],
		[AppointmentSSID],
		[AccumulatorKey],
		[AccumulatorSSID],
		[AccumulatorDescription],
		[AccumulatorDescriptionShort],
		[QuantityUsedOriginal],
		[QuantityUsedAdjustment],
		[QuantityTotalOriginal],
		[QuantityTotalAdjustment],
		[MoneyOriginal],
		[MoneyAdjustment],
		[DateOriginal],
		[DateAdjustment],
		[QuantityUsedNew],
		[QuantityUsedChange],
		[QuantityTotalNew],
		[QuantityTotalChange],
		[MoneyNew],
		[MoneyChange],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		default	)
end
GO