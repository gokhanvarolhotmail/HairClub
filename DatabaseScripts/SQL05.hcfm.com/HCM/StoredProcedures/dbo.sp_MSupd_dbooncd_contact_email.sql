/* CreateDate: 01/03/2018 16:31:35.937 , ModifyDate: 01/03/2018 16:31:35.937 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_contact_email]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nvarchar(100) = NULL,
		@c5 nchar(50) = NULL,
		@c6 nchar(1) = NULL,
		@c7 int = NULL,
		@c8 datetime = NULL,
		@c9 nchar(20) = NULL,
		@c10 datetime = NULL,
		@c11 nchar(20) = NULL,
		@c12 nchar(1) = NULL,
		@c13 nchar(1) = NULL,
		@c14 nchar(20) = NULL,
		@c15 nvarchar(18) = NULL,
		@c16 nchar(1) = NULL,
		@c17 nvarchar(50) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_contact_email] set
		[contact_email_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_email_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[email_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [email_type_code] end,
		[email] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [email] end,
		[description] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [description] end,
		[active] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [active] end,
		[sort_order] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [primary_flag] end,
		[cst_valid_flag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_valid_flag] end,
		[cst_skip_trace_vendor_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [cst_skip_trace_vendor_code] end,
		[cst_sfdc_leademail_id] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [cst_sfdc_leademail_id] end,
		[cst_do_not_export] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_do_not_export] end,
		[cst_import_note] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_import_note] end
where [contact_email_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_contact_email] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[email_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [email_type_code] end,
		[email] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [email] end,
		[description] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [description] end,
		[active] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [active] end,
		[sort_order] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [primary_flag] end,
		[cst_valid_flag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cst_valid_flag] end,
		[cst_skip_trace_vendor_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [cst_skip_trace_vendor_code] end,
		[cst_sfdc_leademail_id] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [cst_sfdc_leademail_id] end,
		[cst_do_not_export] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_do_not_export] end,
		[cst_import_note] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cst_import_note] end
where [contact_email_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
