/* CreateDate: 05/05/2020 17:42:44.790 , ModifyDate: 05/05/2020 17:42:44.790 */
GO
create procedure [sp_MSins_dbocfgSalesCodeMembership]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 money,
    @c5 int,
    @c6 int,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 bit
as
begin
	insert into [dbo].[cfgSalesCodeMembership] (
		[SalesCodeMembershipID],
		[SalesCodeCenterID],
		[MembershipID],
		[Price],
		[TaxRate1ID],
		[TaxRate2ID],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsFinancedToARFlag]
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
		default,
		@c12	)
end
GO
