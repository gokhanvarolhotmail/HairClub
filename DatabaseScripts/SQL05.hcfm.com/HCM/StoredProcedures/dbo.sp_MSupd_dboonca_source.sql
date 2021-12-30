/* CreateDate: 07/25/2018 14:51:34.080 , ModifyDate: 07/25/2018 14:51:34.080 */
GO
create procedure [dbo].[sp_MSupd_dboonca_source]
		@c1 nchar(30) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(1) = NULL,
		@c5 int = NULL,
		@c6 nchar(10) = NULL,
		@c7 nchar(10) = NULL,
		@c8 nchar(10) = NULL,
		@c9 nchar(10) = NULL,
		@c10 nchar(20) = NULL,
		@c11 datetime = NULL,
		@c12 nchar(20) = NULL,
		@c13 datetime = NULL,
		@c14 nchar(1) = NULL,
		@pkc1 nchar(30) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_source] set
		[source_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [source_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[campaign_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [campaign_code] end,
		[active] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active] end,
		[cst_dnis_number] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [cst_dnis_number] end,
		[cst_promotion_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [cst_promotion_code] end,
		[cst_age_range_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [cst_age_range_code] end,
		[cst_hair_loss_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [cst_hair_loss_code] end,
		[cst_language_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [cst_language_code] end,
		[cst_created_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [cst_created_by_user_code] end,
		[cst_created_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [cst_created_date] end,
		[cst_updated_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [cst_updated_by_user_code] end,
		[cst_updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_updated_date] end,
		[publish] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [publish] end
where [source_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_source] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[campaign_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [campaign_code] end,
		[active] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active] end,
		[cst_dnis_number] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [cst_dnis_number] end,
		[cst_promotion_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [cst_promotion_code] end,
		[cst_age_range_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [cst_age_range_code] end,
		[cst_hair_loss_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [cst_hair_loss_code] end,
		[cst_language_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [cst_language_code] end,
		[cst_created_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [cst_created_by_user_code] end,
		[cst_created_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [cst_created_date] end,
		[cst_updated_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [cst_updated_by_user_code] end,
		[cst_updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_updated_date] end,
		[publish] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [publish] end
where [source_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
