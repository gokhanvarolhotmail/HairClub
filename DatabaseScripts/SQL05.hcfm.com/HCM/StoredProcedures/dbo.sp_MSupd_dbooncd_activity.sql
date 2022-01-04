/* CreateDate: 07/25/2018 13:43:17.050 , ModifyDate: 07/25/2018 13:43:17.050 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_activity]     @c1 nchar(10) = NULL,     @c2 nchar(10) = NULL,     @c3 nchar(10) = NULL,     @c4 nchar(10) = NULL,     @c5 datetime = NULL,     @c6 datetime = NULL,     @c7 int = NULL,     @c8 nchar(10) = NULL,     @c9 nchar(50) = NULL,     @c10 datetime = NULL,     @c11 nchar(20) = NULL,     @c12 datetime = NULL,     @c13 datetime = NULL,     @c14 nchar(20) = NULL,     @c15 datetime = NULL,     @c16 nchar(20) = NULL,     @c17 nchar(10) = NULL,     @c18 nchar(10) = NULL,     @c19 nchar(10) = NULL,     @c20 nchar(10) = NULL,     @c21 nchar(10) = NULL,     @c22 nchar(10) = NULL,     @c23 nchar(1) = NULL,     @c24 nchar(10) = NULL,     @c25 nchar(30) = NULL,     @c26 nchar(1) = NULL,     @c27 datetime = NULL,     @c28 datetime = NULL,     @c29 nchar(10) = NULL,     @c30 nchar(10) = NULL,     @c31 nchar(1) = NULL,     @c32 datetime = NULL,     @c33 nchar(20) = NULL,     @c34 nchar(10) = NULL,     @c35 nchar(10) = NULL,     @c36 nchar(1) = NULL,     @c37 datetime = NULL,     @c38 datetime = NULL,     @c39 nchar(10) = NULL,     @c40 nchar(10) = NULL,     @c41 datetime = NULL,     @c42 nchar(1) = NULL,     @c43 nchar(10) = NULL,     @c44 nchar(1) = NULL,     @c45 nvarchar(18) = NULL,     @c46 nchar(1) = NULL,     @c47 nvarchar(2000) = NULL,     @pkc1 nchar(10) = NULL,     @bitmap binary(6)
as
begin   if (substring(@bitmap,1,1) & 1 = 1)
begin  update [dbo].[oncd_activity] set     [activity_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [activity_id] end,     [recur_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [recur_id] end,     [opportunity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [opportunity_id] end,     [incident_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [incident_id] end,     [due_date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [due_date] end,     [start_time] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [start_time] end,     [duration] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [duration] end,     [action_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [action_code] end,     [description] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [description] end,     [creation_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [creation_date] end,     [created_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [created_by_user_code] end,     [completion_date] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [completion_date] end,     [completion_time] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [completion_time] end,     [completed_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [completed_by_user_code] end,     [updated_date] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [updated_date] end,     [updated_by_user_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [updated_by_user_code] end,     [result_code] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [result_code] end,     [batch_status_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [batch_status_code] end,     [batch_result_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [batch_result_code] end,     [batch_address_type_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [batch_address_type_code] end,     [priority] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [priority] end,     [project_code] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [project_code] end,     [notify_when_completed] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [notify_when_completed] end,     [campaign_code] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [campaign_code] end,     [source_code] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [source_code] end,     [confirmed_time] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [confirmed_time] end,     [confirmed_time_from] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [confirmed_time_from] end,     [confirmed_time_to] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [confirmed_time_to] end,     [document_id] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [document_id] end,     [milestone_activity_id] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [milestone_activity_id] end,     [cst_override_time_zone] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [cst_override_time_zone] end,     [cst_lock_date] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [cst_lock_date] end,     [cst_lock_by_user_code] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [cst_lock_by_user_code] end,     [cst_activity_type_code] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [cst_activity_type_code] end,     [cst_promotion_code] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [cst_promotion_code] end,     [cst_no_followup_flag] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [cst_no_followup_flag] end,     [cst_followup_time] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [cst_followup_time] end,     [cst_followup_date] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [cst_followup_date] end,     [cst_time_zone_code] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [cst_time_zone_code] end,     [project_id] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [project_id] end,     [cst_utc_start_date] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [cst_utc_start_date] end,     [cst_brochure_download] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [cst_brochure_download] end,     [cst_queue_id] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [cst_queue_id] end,     [cst_in_noble_queue] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [cst_in_noble_queue] end,     [cst_sfdc_task_id] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [cst_sfdc_task_id] end,     [cst_do_not_export] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [cst_do_not_export] end,     [cst_import_note] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [cst_import_note] end
where [activity_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end   else
begin  update [dbo].[oncd_activity] set     [recur_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [recur_id] end,     [opportunity_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [opportunity_id] end,     [incident_id] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [incident_id] end,     [due_date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [due_date] end,     [start_time] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [start_time] end,     [duration] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [duration] end,     [action_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [action_code] end,     [description] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [description] end,     [creation_date] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [creation_date] end,     [created_by_user_code] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [created_by_user_code] end,     [completion_date] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [completion_date] end,     [completion_time] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [completion_time] end,     [completed_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [completed_by_user_code] end,     [updated_date] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [updated_date] end,     [updated_by_user_code] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [updated_by_user_code] end,     [result_code] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [result_code] end,     [batch_status_code] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [batch_status_code] end,     [batch_result_code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [batch_result_code] end,     [batch_address_type_code] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [batch_address_type_code] end,     [priority] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [priority] end,     [project_code] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [project_code] end,     [notify_when_completed] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [notify_when_completed] end,     [campaign_code] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [campaign_code] end,     [source_code] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [source_code] end,     [confirmed_time] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [confirmed_time] end,     [confirmed_time_from] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [confirmed_time_from] end,     [confirmed_time_to] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [confirmed_time_to] end,     [document_id] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [document_id] end,     [milestone_activity_id] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [milestone_activity_id] end,     [cst_override_time_zone] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [cst_override_time_zone] end,     [cst_lock_date] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [cst_lock_date] end,     [cst_lock_by_user_code] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [cst_lock_by_user_code] end,     [cst_activity_type_code] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [cst_activity_type_code] end,     [cst_promotion_code] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [cst_promotion_code] end,     [cst_no_followup_flag] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [cst_no_followup_flag] end,     [cst_followup_time] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [cst_followup_time] end,     [cst_followup_date] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [cst_followup_date] end,     [cst_time_zone_code] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [cst_time_zone_code] end,     [project_id] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [project_id] end,     [cst_utc_start_date] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [cst_utc_start_date] end,     [cst_brochure_download] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [cst_brochure_download] end,     [cst_queue_id] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [cst_queue_id] end,     [cst_in_noble_queue] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [cst_in_noble_queue] end,     [cst_sfdc_task_id] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [cst_sfdc_task_id] end,     [cst_do_not_export] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [cst_do_not_export] end,     [cst_import_note] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [cst_import_note] end
where [activity_id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end  end   --
GO