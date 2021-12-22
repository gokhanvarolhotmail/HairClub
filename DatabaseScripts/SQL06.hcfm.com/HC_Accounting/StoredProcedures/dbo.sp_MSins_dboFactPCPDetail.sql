create procedure [sp_MSins_dboFactPCPDetail]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 datetime,
    @c10 int
as
begin
	insert into [dbo].[FactPCPDetail] (
		[ID],
		[CenterKey],
		[ClientKey],
		[GenderKey],
		[MembershipKey],
		[DateKey],
		[PCP],
		[EXT],
		[Timestamp],
		[XTR]
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
		@c10	)
end
