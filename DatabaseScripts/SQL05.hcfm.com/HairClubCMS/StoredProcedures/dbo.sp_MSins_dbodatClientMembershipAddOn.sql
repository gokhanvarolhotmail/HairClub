/* CreateDate: 05/05/2020 17:42:48.027 , ModifyDate: 05/05/2020 17:42:48.027 */
GO
create procedure [dbo].[sp_MSins_dbodatClientMembershipAddOn]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 money,
    @c6 int,
    @c7 money,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 binary(8),
    @c13 int,
    @c14 money,
    @c15 money
as
begin
	insert into [dbo].[datClientMembershipAddOn] (
		[ClientMembershipAddOnID],
		[ClientMembershipGUID],
		[AddOnID],
		[ClientMembershipAddOnStatusID],
		[Price],
		[Quantity],
		[MonthlyFee],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[Term],
		[ContractPrice],
		[ContractPaidAmount]
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
		@c15	)
end
GO
