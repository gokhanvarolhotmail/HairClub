/* CreateDate: 01/03/2018 16:31:33.883 , ModifyDate: 01/03/2018 16:31:33.883 */
GO
create procedure [dbo].[sp_MSupd_dboonca_user]
		@c1 nchar(20) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(20) = NULL,
		@c5 nchar(50) = NULL,
		@c6 datetime = NULL,
		@c7 nchar(1) = NULL,
		@c8 nchar(1) = NULL,
		@c9 nchar(50) = NULL,
		@c10 nchar(50) = NULL,
		@c11 nchar(50) = NULL,
		@c12 nchar(150) = NULL,
		@c13 nchar(50) = NULL,
		@c14 nchar(50) = NULL,
		@c15 nchar(50) = NULL,
		@c16 nchar(50) = NULL,
		@c17 nchar(50) = NULL,
		@c18 nchar(10) = NULL,
		@c19 nchar(10) = NULL,
		@c20 nchar(10) = NULL,
		@c21 nchar(10) = NULL,
		@c22 nchar(1) = NULL,
		@c23 nchar(1) = NULL,
		@c24 nchar(100) = NULL,
		@c25 nchar(1) = NULL,
		@c26 nchar(10) = NULL,
		@c27 nchar(1) = NULL,
		@c28 nchar(1) = NULL,
		@pkc1 nchar(20) = NULL,
		@bitmap binary(4)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_user] set
		[user_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [user_code] end,
		[department_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [department_code] end,
		[job_function_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [job_function_code] end,
		[login_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [login_id] end,
		[password_value] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [password_value] end,
		[password_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [password_date] end,
		[password_expires] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [password_expires] end,
		[change_password] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [change_password] end,
		[first_name] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [first_name] end,
		[middle_name] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [middle_name] end,
		[last_name] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [last_name] end,
		[full_name] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [full_name] end,
		[description] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [description] end,
		[title] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [title] end,
		[cti_server] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [cti_server] end,
		[cti_user_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cti_user_code] end,
		[cti_password] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cti_password] end,
		[cti_station] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [cti_station] end,
		[cti_extension] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [cti_extension] end,
		[action_set_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [action_set_code] end,
		[startup_object_id] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [startup_object_id] end,
		[clear_cache] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [clear_cache] end,
		[active] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [active] end,
		[display_name] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [display_name] end,
		[license_type] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [license_type] end,
		[outlook_sync_frequency] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [outlook_sync_frequency] end,
		[outlook_sync_confirm] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [outlook_sync_confirm] end,
		[cst_is_queue_user] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [cst_is_queue_user] end
where [user_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_user] set
		[department_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [department_code] end,
		[job_function_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [job_function_code] end,
		[login_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [login_id] end,
		[password_value] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [password_value] end,
		[password_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [password_date] end,
		[password_expires] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [password_expires] end,
		[change_password] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [change_password] end,
		[first_name] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [first_name] end,
		[middle_name] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [middle_name] end,
		[last_name] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [last_name] end,
		[full_name] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [full_name] end,
		[description] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [description] end,
		[title] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [title] end,
		[cti_server] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [cti_server] end,
		[cti_user_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [cti_user_code] end,
		[cti_password] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [cti_password] end,
		[cti_station] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [cti_station] end,
		[cti_extension] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [cti_extension] end,
		[action_set_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [action_set_code] end,
		[startup_object_id] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [startup_object_id] end,
		[clear_cache] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [clear_cache] end,
		[active] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [active] end,
		[display_name] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [display_name] end,
		[license_type] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [license_type] end,
		[outlook_sync_frequency] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [outlook_sync_frequency] end,
		[outlook_sync_confirm] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [outlook_sync_confirm] end,
		[cst_is_queue_user] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [cst_is_queue_user] end
where [user_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
