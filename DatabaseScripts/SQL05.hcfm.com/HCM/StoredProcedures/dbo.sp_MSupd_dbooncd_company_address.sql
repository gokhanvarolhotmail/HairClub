/* CreateDate: 01/03/2018 16:31:35.713 , ModifyDate: 01/03/2018 16:31:35.713 */
GO
create procedure [sp_MSupd_dbooncd_company_address]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(60) = NULL,
		@c5 nchar(60) = NULL,
		@c6 nchar(60) = NULL,
		@c7 nchar(60) = NULL,
		@c8 nchar(20) = NULL,
		@c9 nchar(20) = NULL,
		@c10 nchar(60) = NULL,
		@c11 nchar(20) = NULL,
		@c12 nchar(20) = NULL,
		@c13 nchar(15) = NULL,
		@c14 nchar(10) = NULL,
		@c15 nchar(20) = NULL,
		@c16 nchar(10) = NULL,
		@c17 int = NULL,
		@c18 datetime = NULL,
		@c19 nchar(20) = NULL,
		@c20 datetime = NULL,
		@c21 nchar(20) = NULL,
		@c22 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_company_address] set
		[company_address_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [company_address_id] end,
		[company_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_id] end,
		[address_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [address_type_code] end,
		[address_line_1] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [address_line_1] end,
		[address_line_2] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [address_line_2] end,
		[address_line_3] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [address_line_3] end,
		[address_line_4] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [address_line_4] end,
		[address_line_1_soundex] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [address_line_1_soundex] end,
		[address_line_2_soundex] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [address_line_2_soundex] end,
		[city] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [city] end,
		[city_soundex] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [city_soundex] end,
		[state_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [state_code] end,
		[zip_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [zip_code] end,
		[county_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [county_code] end,
		[country_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [country_code] end,
		[time_zone_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [time_zone_code] end,
		[sort_order] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [sort_order] end,
		[creation_date] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [primary_flag] end
where [company_address_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_company_address] set
		[company_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_id] end,
		[address_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [address_type_code] end,
		[address_line_1] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [address_line_1] end,
		[address_line_2] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [address_line_2] end,
		[address_line_3] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [address_line_3] end,
		[address_line_4] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [address_line_4] end,
		[address_line_1_soundex] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [address_line_1_soundex] end,
		[address_line_2_soundex] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [address_line_2_soundex] end,
		[city] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [city] end,
		[city_soundex] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [city_soundex] end,
		[state_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [state_code] end,
		[zip_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [zip_code] end,
		[county_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [county_code] end,
		[country_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [country_code] end,
		[time_zone_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [time_zone_code] end,
		[sort_order] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [sort_order] end,
		[creation_date] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [primary_flag] end
where [company_address_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
