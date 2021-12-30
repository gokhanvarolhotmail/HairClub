/* CreateDate: 01/03/2018 16:31:35.473 , ModifyDate: 01/03/2018 16:31:35.473 */
GO
create procedure [dbo].[sp_MSupd_dboonca_zip]
		@c1 nchar(10) = NULL,
		@c2 nchar(20) = NULL,
		@c3 nchar(60) = NULL,
		@c4 nchar(20) = NULL,
		@c5 nchar(20) = NULL,
		@c6 nchar(1) = NULL,
		@c7 nchar(10) = NULL,
		@c8 decimal(15,4) = NULL,
		@c9 decimal(15,4) = NULL,
		@c10 nchar(10) = NULL,
		@c11 nchar(6) = NULL,
		@c12 nchar(1) = NULL,
		@c13 nchar(1) = NULL,
		@c14 nchar(4) = NULL,
		@c15 nchar(4) = NULL,
		@c16 nchar(50) = NULL,
		@c17 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_zip] set
		[zip_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [zip_id] end,
		[zip_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [zip_code] end,
		[city] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [city] end,
		[country_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code] end,
		[state_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [state_code] end,
		[zip_code_type] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [zip_code_type] end,
		[county_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [county_code] end,
		[latitude] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [latitude] end,
		[longitude] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [longitude] end,
		[area_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [area_code] end,
		[finance_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [finance_code] end,
		[last_line] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [last_line] end,
		[facility_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [facility_code] end,
		[msa_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [msa_code] end,
		[pmsa_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pmsa_code] end,
		[cst_dma] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_dma] end,
		[cst_city_type] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_city_type] end
where [zip_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_zip] set
		[zip_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [zip_code] end,
		[city] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [city] end,
		[country_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code] end,
		[state_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [state_code] end,
		[zip_code_type] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [zip_code_type] end,
		[county_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [county_code] end,
		[latitude] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [latitude] end,
		[longitude] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [longitude] end,
		[area_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [area_code] end,
		[finance_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [finance_code] end,
		[last_line] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [last_line] end,
		[facility_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [facility_code] end,
		[msa_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [msa_code] end,
		[pmsa_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pmsa_code] end,
		[cst_dma] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_dma] end,
		[cst_city_type] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_city_type] end
where [zip_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
