/* CreateDate: 01/03/2018 16:31:35.843 , ModifyDate: 01/03/2018 16:31:35.843 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_contact_company]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nchar(50) = NULL,
		@c6 int = NULL,
		@c7 nchar(10) = NULL,
		@c8 datetime = NULL,
		@c9 nchar(20) = NULL,
		@c10 datetime = NULL,
		@c11 nchar(20) = NULL,
		@c12 nchar(1) = NULL,
		@c13 nchar(50) = NULL,
		@c14 nchar(10) = NULL,
		@c15 nchar(10) = NULL,
		@c16 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_contact_company] set
		[contact_company_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_company_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[company_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [company_id] end,
		[company_role_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [company_role_code] end,
		[description] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [description] end,
		[sort_order] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [sort_order] end,
		[reports_to_contact_id] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [reports_to_contact_id] end,
		[creation_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [primary_flag] end,
		[title] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [title] end,
		[department_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [department_code] end,
		[internal_title_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [internal_title_code] end,
		[cst_preferred_center_flag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_preferred_center_flag] end
where [contact_company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_contact_company] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[company_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [company_id] end,
		[company_role_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [company_role_code] end,
		[description] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [description] end,
		[sort_order] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [sort_order] end,
		[reports_to_contact_id] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [reports_to_contact_id] end,
		[creation_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [primary_flag] end,
		[title] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [title] end,
		[department_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [department_code] end,
		[internal_title_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [internal_title_code] end,
		[cst_preferred_center_flag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cst_preferred_center_flag] end
where [contact_company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
