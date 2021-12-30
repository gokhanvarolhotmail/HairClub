/* CreateDate: 01/03/2018 16:31:36.050 , ModifyDate: 01/03/2018 16:31:36.050 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_contact_phone]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nchar(10) = NULL,
		@c6 nchar(20) = NULL,
		@c7 nchar(10) = NULL,
		@c8 nchar(50) = NULL,
		@c9 nchar(1) = NULL,
		@c10 int = NULL,
		@c11 datetime = NULL,
		@c12 nchar(20) = NULL,
		@c13 datetime = NULL,
		@c14 nchar(20) = NULL,
		@c15 nchar(1) = NULL,
		@c16 nchar(1) = NULL,
		@c17 nchar(10) = NULL,
		@c18 datetime = NULL,
		@c19 nchar(20) = NULL,
		@c20 datetime = NULL,
		@c21 nchar(20) = NULL,
		@c22 nvarchar(18) = NULL,
		@c23 nchar(1) = NULL,
		@c24 nvarchar(50) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_contact_phone] set
		[contact_phone_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_phone_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[phone_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [phone_type_code] end,
		[country_code_prefix] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code_prefix] end,
		[area_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [area_code] end,
		[phone_number] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [phone_number] end,
		[extension] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [extension] end,
		[description] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [description] end,
		[active] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [active] end,
		[sort_order] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [sort_order] end,
		[creation_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [primary_flag] end,
		[cst_valid_flag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_valid_flag] end,
		[cst_dnc_code] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_dnc_code] end,
		[cst_last_dnc_date] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [cst_last_dnc_date] end,
		[cst_phone_type_updated_by_user_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [cst_phone_type_updated_by_user_code] end,
		[cst_phone_type_updated_date] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [cst_phone_type_updated_date] end,
		[cst_skip_trace_vendor_code] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [cst_skip_trace_vendor_code] end,
		[cst_sfdc_leadphone_id] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [cst_sfdc_leadphone_id] end,
		[cst_do_not_export] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [cst_do_not_export] end,
		[cst_import_note] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [cst_import_note] end
where [contact_phone_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_contact_phone] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[phone_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [phone_type_code] end,
		[country_code_prefix] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code_prefix] end,
		[area_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [area_code] end,
		[phone_number] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [phone_number] end,
		[extension] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [extension] end,
		[description] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [description] end,
		[active] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [active] end,
		[sort_order] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [sort_order] end,
		[creation_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [primary_flag] end,
		[cst_valid_flag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_valid_flag] end,
		[cst_dnc_code] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_dnc_code] end,
		[cst_last_dnc_date] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [cst_last_dnc_date] end,
		[cst_phone_type_updated_by_user_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [cst_phone_type_updated_by_user_code] end,
		[cst_phone_type_updated_date] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [cst_phone_type_updated_date] end,
		[cst_skip_trace_vendor_code] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [cst_skip_trace_vendor_code] end,
		[cst_sfdc_leadphone_id] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [cst_sfdc_leadphone_id] end,
		[cst_do_not_export] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [cst_do_not_export] end,
		[cst_import_note] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [cst_import_note] end
where [contact_phone_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
