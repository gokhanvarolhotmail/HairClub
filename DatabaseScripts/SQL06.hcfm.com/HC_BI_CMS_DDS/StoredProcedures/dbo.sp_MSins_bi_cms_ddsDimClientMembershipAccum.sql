/* CreateDate: 10/03/2019 23:03:40.277 , ModifyDate: 10/03/2019 23:03:40.277 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsDimClientMembershipAccum]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 int,
    @c6 int,
    @c7 varchar(50),
    @c8 varchar(10),
    @c9 int,
    @c10 money,
    @c11 datetime,
    @c12 int,
    @c13 int,
    @c14 tinyint,
    @c15 datetime,
    @c16 datetime,
    @c17 varchar(200),
    @c18 tinyint,
    @c19 int,
    @c20 int
as
begin
	insert into [bi_cms_dds].[DimClientMembershipAccum] (
		[ClientMembershipAccumKey],
		[ClientMembershipAccumSSID],
		[ClientMembershipKey],
		[ClientMembershipSSID],
		[AccumulatorKey],
		[AccumulatorSSID],
		[AccumulatorDescription],
		[AccumulatorDescriptionShort],
		[UsedAccumQuantity],
		[AccumMoney],
		[AccumDate],
		[TotalAccumQuantity],
		[AccumQuantityRemaining],
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
		default	)
end
GO
