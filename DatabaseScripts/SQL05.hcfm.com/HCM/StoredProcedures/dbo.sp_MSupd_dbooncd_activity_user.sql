/* CreateDate: 01/03/2018 16:31:35.583 , ModifyDate: 01/03/2018 16:31:35.583 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_activity_user]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(20) = NULL,
		@c4 datetime = NULL,
		@c5 nchar(1) = NULL,
		@c6 int = NULL,
		@c7 datetime = NULL,
		@c8 nchar(20) = NULL,
		@c9 datetime = NULL,
		@c10 nchar(20) = NULL,
		@c11 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_activity_user] set
		[activity_user_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [activity_user_id] end,
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[user_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [user_code] end,
		[assignment_date] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [assignment_date] end,
		[attendance] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [attendance] end,
		[sort_order] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [primary_flag] end
where [activity_user_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_activity_user] set
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[user_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [user_code] end,
		[assignment_date] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [assignment_date] end,
		[attendance] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [attendance] end,
		[sort_order] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [primary_flag] end
where [activity_user_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
