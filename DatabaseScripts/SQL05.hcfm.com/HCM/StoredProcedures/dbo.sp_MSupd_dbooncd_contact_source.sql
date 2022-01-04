/* CreateDate: 07/25/2018 13:07:36.260 , ModifyDate: 07/25/2018 13:07:36.260 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_contact_source]     @c1 nchar(10) = NULL,     @c2 nchar(10) = NULL,     @c3 nchar(30) = NULL,     @c4 nchar(10) = NULL,     @c5 int = NULL,     @c6 datetime = NULL,     @c7 datetime = NULL,     @c8 nchar(20) = NULL,     @c9 datetime = NULL,     @c10 nchar(20) = NULL,     @c11 nchar(1) = NULL,     @c12 int = NULL,     @c13 nchar(10) = NULL,     @pkc1 nchar(10) = NULL,     @bitmap binary(2)
as
begin   if (substring(@bitmap,1,1) & 1 = 1)
begin  update [dbo].[oncd_contact_source] set     [contact_source_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_source_id] end,     [contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,     [source_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [source_code] end,     [media_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [media_code] end,     [sort_order] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [sort_order] end,     [assignment_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [assignment_date] end,     [creation_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [creation_date] end,     [created_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [created_by_user_code] end,     [updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,     [updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end,     [primary_flag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [primary_flag] end,     [cst_dnis_number] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [cst_dnis_number] end,     [cst_sub_source_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_sub_source_code] end
where [contact_source_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end   else
begin  update [dbo].[oncd_contact_source] set     [contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,     [source_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [source_code] end,     [media_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [media_code] end,     [sort_order] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [sort_order] end,     [assignment_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [assignment_date] end,     [creation_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [creation_date] end,     [created_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [created_by_user_code] end,     [updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,     [updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end,     [primary_flag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [primary_flag] end,     [cst_dnis_number] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [cst_dnis_number] end,     [cst_sub_source_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_sub_source_code] end
where [contact_source_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end  end   --
GO