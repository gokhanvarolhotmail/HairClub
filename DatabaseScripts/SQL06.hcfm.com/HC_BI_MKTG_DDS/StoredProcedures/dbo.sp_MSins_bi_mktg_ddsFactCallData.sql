create procedure [dbo].[sp_MSins_bi_mktg_ddsFactCallData]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 binary(8)
as
begin
	insert into [bi_mktg_dds].[FactCallData] (
		[CallRecordKey],
		[CallDateKey],
		[CallTimeKey],
		[InboundSourceKey],
		[ContactKey],
		[ActivityKey],
		[IsViableCall],
		[CallLength],
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
		@c9	)
end
