create procedure [sp_MSins_bief_ddsDimTimeOfDay]
    @c1 int,
    @c2 varchar(12),
    @c3 varchar(8),
    @c4 smallint,
    @c5 varchar(10),
    @c6 smallint,
    @c7 smallint,
    @c8 varchar(20),
    @c9 smallint,
    @c10 smallint,
    @c11 char(2),
    @c12 uniqueidentifier
as
begin
	insert into [bief_dds].[DimTimeOfDay] (
		[TimeOfDayKey],
		[Time],
		[Time24],
		[Hour],
		[HourName],
		[Minute],
		[MinuteKey],
		[MinuteName],
		[Second],
		[Hour24],
		[AM],
		[msrepl_tran_version]
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
		@c12	)
end
