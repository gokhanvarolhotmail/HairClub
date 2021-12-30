/* CreateDate: 01/03/2018 16:31:36.427 , ModifyDate: 01/03/2018 16:31:36.427 */
GO
create procedure [dbo].[sp_MSupd_dbocstd_company_zip_code]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(20) = NULL,
		@c4 nchar(20) = NULL,
		@c5 nchar(10) = NULL,
		@c6 nchar(10) = NULL,
		@c7 nchar(1) = NULL,
		@c8 int = NULL,
		@c9 nchar(50) = NULL,
		@c10 datetime = NULL,
		@c11 nchar(20) = NULL,
		@c12 datetime = NULL,
		@c13 nchar(20) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cstd_company_zip_code] set
		[company_zip_code_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [company_zip_code_id] end,
		[company_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_id] end,
		[zip_from] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [zip_from] end,
		[zip_to] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [zip_to] end,
		[type_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [type_code] end,
		[dma_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [dma_code] end,
		[adi_flag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [adi_flag] end,
		[sort_order] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [sort_order] end,
		[county] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [county] end,
		[creation_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_by_user_code] end
where [company_zip_code_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[cstd_company_zip_code] set
		[company_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_id] end,
		[zip_from] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [zip_from] end,
		[zip_to] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [zip_to] end,
		[type_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [type_code] end,
		[dma_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [dma_code] end,
		[adi_flag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [adi_flag] end,
		[sort_order] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [sort_order] end,
		[county] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [county] end,
		[creation_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_by_user_code] end
where [company_zip_code_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
