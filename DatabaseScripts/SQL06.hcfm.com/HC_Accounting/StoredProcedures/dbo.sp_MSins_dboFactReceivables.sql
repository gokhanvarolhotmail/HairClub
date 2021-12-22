create procedure [sp_MSins_dboFactReceivables]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 float,
    @c6 money
as
begin
	insert into [dbo].[FactReceivables] (
		[ID],
		[CenterKey],
		[DateKey],
		[ClientKey],
		[Balance],
		[PrePaid]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6	)
end
