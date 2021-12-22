create procedure [sp_MSins_dbo_DataFlowInterval]
    @c1 int,
    @c2 varchar(50),
    @c3 int,
    @c4 bit
as
begin
	insert into [dbo].[_DataFlowInterval] (
		[DataFlowIntervalKey],
		[IntervalType],
		[Interval],
		[IsActiveFlag]
	) values (
		@c1,
		@c2,
		@c3,
		@c4	)
end
