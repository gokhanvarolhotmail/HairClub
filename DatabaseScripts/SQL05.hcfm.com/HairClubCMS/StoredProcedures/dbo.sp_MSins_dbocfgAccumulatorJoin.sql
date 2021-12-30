/* CreateDate: 05/05/2020 17:42:38.253 , ModifyDate: 05/05/2020 17:42:38.253 */
GO
create procedure [sp_MSins_dbocfgAccumulatorJoin]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 bit,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 int,
    @c15 bit
as
begin
	insert into [dbo].[cfgAccumulatorJoin] (
		[AccumulatorJoinID],
		[AccumulatorJoinSortOrder],
		[AccumulatorJoinTypeID],
		[SalesCodeID],
		[AccumulatorID],
		[AccumulatorDataTypeID],
		[AccumulatorActionTypeID],
		[AccumulatorAdjustmentTypeID],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[HairSystemOrderProcessID],
		[IsEligibleForInterCompanyTransaction]
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
		default,
		@c14,
		@c15	)
end
GO
