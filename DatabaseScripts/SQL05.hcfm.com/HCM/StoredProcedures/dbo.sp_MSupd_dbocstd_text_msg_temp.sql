/* CreateDate: 01/03/2018 16:31:36.483 , ModifyDate: 01/03/2018 16:31:36.483 */
GO
create procedure [dbo].[sp_MSupd_dbocstd_text_msg_temp]
		@c1 int = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(11) = NULL,
		@c5 nchar(20) = NULL,
		@c6 datetime = NULL,
		@c7 nchar(6) = NULL,
		@c8 nchar(100) = NULL,
		@c9 datetime = NULL,
		@c10 nchar(20) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cstd_text_msg_temp] set
		[temp_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [temp_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[appointment_activity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [appointment_activity_id] end,
		[phone] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [phone] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [created_by_user_code] end,
		[creation_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [creation_date] end,
		[action] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [action] end,
		[status] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [status] end,
		[updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end
where [temp_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[cstd_text_msg_temp] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[appointment_activity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [appointment_activity_id] end,
		[phone] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [phone] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [created_by_user_code] end,
		[creation_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [creation_date] end,
		[action] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [action] end,
		[status] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [status] end,
		[updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end
where [temp_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
