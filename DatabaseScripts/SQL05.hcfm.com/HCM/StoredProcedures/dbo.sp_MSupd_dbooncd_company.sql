/* CreateDate: 01/03/2018 16:31:35.643 , ModifyDate: 01/03/2018 16:31:35.643 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_company]
		@c1 nchar(10) = NULL,
		@c2 nchar(100) = NULL,
		@c3 nchar(100) = NULL,
		@c4 nchar(100) = NULL,
		@c5 nchar(100) = NULL,
		@c6 nchar(20) = NULL,
		@c7 nchar(20) = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 nchar(10) = NULL,
		@c11 nchar(20) = NULL,
		@c12 nchar(10) = NULL,
		@c13 nchar(10) = NULL,
		@c14 nchar(1) = NULL,
		@c15 nchar(10) = NULL,
		@c16 nchar(1) = NULL,
		@c17 datetime = NULL,
		@c18 nchar(20) = NULL,
		@c19 datetime = NULL,
		@c20 nchar(20) = NULL,
		@c21 datetime = NULL,
		@c22 nchar(20) = NULL,
		@c23 nchar(10) = NULL,
		@c24 nchar(10) = NULL,
		@c25 nvarchar(500) = NULL,
		@c26 nchar(50) = NULL,
		@c27 nchar(50) = NULL,
		@c28 nchar(20) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(4)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_company] set
		[company_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [company_id] end,
		[company_name_1] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_name_1] end,
		[company_name_2] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [company_name_2] end,
		[company_name_1_search] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [company_name_1_search] end,
		[company_name_2_search] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [company_name_2_search] end,
		[company_name_1_soundex] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [company_name_1_soundex] end,
		[company_name_2_soundex] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [company_name_2_soundex] end,
		[annual_sales] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [annual_sales] end,
		[number_of_employees] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [number_of_employees] end,
		[profile_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [profile_code] end,
		[external_id] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [external_id] end,
		[company_type_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [company_type_code] end,
		[contact_method_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [contact_method_code] end,
		[do_not_solicit] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [do_not_solicit] end,
		[company_status_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [company_status_code] end,
		[duplicate_check] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [duplicate_check] end,
		[creation_date] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [updated_by_user_code] end,
		[status_updated_date] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [status_updated_date] end,
		[status_updated_by_user_code] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [status_updated_by_user_code] end,
		[parent_company_id] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [parent_company_id] end,
		[cst_center_number] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [cst_center_number] end,
		[cst_company_map_link] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cst_company_map_link] end,
		[cst_center_manager_name] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [cst_center_manager_name] end,
		[cst_director_name] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [cst_director_name] end,
		[cst_dma] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [cst_dma] end
where [company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_company] set
		[company_name_1] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [company_name_1] end,
		[company_name_2] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [company_name_2] end,
		[company_name_1_search] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [company_name_1_search] end,
		[company_name_2_search] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [company_name_2_search] end,
		[company_name_1_soundex] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [company_name_1_soundex] end,
		[company_name_2_soundex] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [company_name_2_soundex] end,
		[annual_sales] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [annual_sales] end,
		[number_of_employees] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [number_of_employees] end,
		[profile_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [profile_code] end,
		[external_id] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [external_id] end,
		[company_type_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [company_type_code] end,
		[contact_method_code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [contact_method_code] end,
		[do_not_solicit] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [do_not_solicit] end,
		[company_status_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [company_status_code] end,
		[duplicate_check] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [duplicate_check] end,
		[creation_date] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [updated_by_user_code] end,
		[status_updated_date] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [status_updated_date] end,
		[status_updated_by_user_code] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [status_updated_by_user_code] end,
		[parent_company_id] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [parent_company_id] end,
		[cst_center_number] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [cst_center_number] end,
		[cst_company_map_link] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cst_company_map_link] end,
		[cst_center_manager_name] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [cst_center_manager_name] end,
		[cst_director_name] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [cst_director_name] end,
		[cst_dma] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [cst_dma] end
where [company_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
