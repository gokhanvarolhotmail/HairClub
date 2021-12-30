/* CreateDate: 01/03/2018 16:31:35.310 , ModifyDate: 01/03/2018 16:31:35.310 */
GO
create procedure [dbo].[sp_MSupd_dboonca_county]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(20) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nchar(1) = NULL,
		@c6 nchar(60) = NULL,
		@c7 nchar(1) = NULL,
		@c8 int = NULL,
		@c9 decimal(15,4) = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 nchar(20) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_county] set
		[county_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [county_code] end,
		[county_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [county_name] end,
		[state_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [state_code] end,
		[time_zone_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [time_zone_code] end,
		[county_type] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [county_type] end,
		[county_seat] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [county_seat] end,
		[name_type] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [name_type] end,
		[elevation] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [elevation] end,
		[persons_per_house] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [persons_per_house] end,
		[population] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [population] end,
		[area] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [area] end,
		[households] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [households] end,
		[country_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [country_code] end
where [county_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_county] set
		[county_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [county_name] end,
		[state_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [state_code] end,
		[time_zone_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [time_zone_code] end,
		[county_type] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [county_type] end,
		[county_seat] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [county_seat] end,
		[name_type] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [name_type] end,
		[elevation] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [elevation] end,
		[persons_per_house] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [persons_per_house] end,
		[population] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [population] end,
		[area] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [area] end,
		[households] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [households] end,
		[country_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [country_code] end
where [county_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
