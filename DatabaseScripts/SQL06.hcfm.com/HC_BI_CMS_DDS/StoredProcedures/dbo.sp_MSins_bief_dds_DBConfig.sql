/* CreateDate: 03/17/2022 11:57:03.477 , ModifyDate: 03/17/2022 11:57:03.477 */
GO
create procedure [sp_MSins_bief_dds_DBConfig]
    @c1 int,
    @c2 varchar(max),
    @c3 bit,
    @c4 int,
    @c5 varchar(max),
    @c6 datetime,
    @c7 decimal(18,4)
as
begin
	insert into [bief_dds].[_DBConfig] (
		[setting_key],
		[setting_name],
		[setting_value_bit],
		[setting_value_int],
		[setting_value_varchar],
		[setting_value_datatime],
		[setting_value_decimal]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7	)
end
GO
