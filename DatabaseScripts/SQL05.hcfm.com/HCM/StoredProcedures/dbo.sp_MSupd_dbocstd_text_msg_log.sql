/* CreateDate: 01/03/2018 16:31:36.540 , ModifyDate: 01/03/2018 16:31:36.540 */
GO
create procedure [dbo].[sp_MSupd_dbocstd_text_msg_log]
		@c1 int = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nchar(20) = NULL,
		@c6 nchar(20) = NULL,
		@c7 nchar(20) = NULL,
		@c8 nchar(20) = NULL,
		@c9 nchar(20) = NULL,
		@c10 nchar(11) = NULL,
		@c11 datetime = NULL,
		@c12 nchar(255) = NULL,
		@c13 nchar(100) = NULL,
		@c14 nchar(10) = NULL,
		@c15 nchar(10) = NULL,
		@c16 nchar(6) = NULL,
		@c17 datetime = NULL,
		@c18 nchar(20) = NULL,
		@c19 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cstd_text_msg_log] set
		[log_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [log_id] end,
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[appointment_activity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [appointment_activity_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [contact_id] end,
		[reference] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [reference] end,
		[customer_id] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [customer_id] end,
		[message_log_id] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [message_log_id] end,
		[message_id] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [message_id] end,
		[result_status] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [result_status] end,
		[phone] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [phone] end,
		[appt_date_time] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [appt_date_time] end,
		[return_text] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [return_text] end,
		[company_name_1] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [company_name_1] end,
		[time_zone_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [time_zone_code] end,
		[language_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [language_code] end,
		[action] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [action] end,
		[creation_date] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [created_by_user_code] end,
		[process_date] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [process_date] end
where [log_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[cstd_text_msg_log] set
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[appointment_activity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [appointment_activity_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [contact_id] end,
		[reference] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [reference] end,
		[customer_id] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [customer_id] end,
		[message_log_id] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [message_log_id] end,
		[message_id] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [message_id] end,
		[result_status] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [result_status] end,
		[phone] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [phone] end,
		[appt_date_time] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [appt_date_time] end,
		[return_text] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [return_text] end,
		[company_name_1] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [company_name_1] end,
		[time_zone_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [time_zone_code] end,
		[language_code] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [language_code] end,
		[action] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [action] end,
		[creation_date] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [created_by_user_code] end,
		[process_date] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [process_date] end
where [log_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
