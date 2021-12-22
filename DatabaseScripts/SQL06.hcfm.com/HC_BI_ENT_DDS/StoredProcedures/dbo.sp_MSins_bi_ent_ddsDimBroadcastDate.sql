/* CreateDate: 01/08/2021 15:21:53.310 , ModifyDate: 01/08/2021 15:21:53.310 */
GO
create procedure [sp_MSins_bi_ent_ddsDimBroadcastDate]
    @c1 int,
    @c2 smalldatetime,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 varchar(50),
    @c7 int,
    @c8 int,
    @c9 uniqueidentifier
as
begin
	insert into [bi_ent_dds].[DimBroadcastDate] (
		[DateKey],
		[Date],
		[Year],
		[Quarter],
		[Month],
		[MonthName],
		[Week],
		[Day],
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
		@c9	)
end
GO
