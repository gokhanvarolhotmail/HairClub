/* CreateDate: 01/03/2018 17:04:45.490 , ModifyDate: 01/03/2018 17:04:45.490 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_oncd_activity]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [activity_id], NULL as [recur_id], NULL as [opportunity_id], NULL as [incident_id], NULL as [due_date], NULL as [start_time], NULL as [duration], NULL as [action_code], NULL as [description], NULL as [creation_date], NULL as [created_by_user_code], NULL as [completion_date], NULL as [completion_time], NULL as [completed_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [result_code], NULL as [batch_status_code], NULL as [batch_result_code], NULL as [batch_address_type_code], NULL as [priority], NULL as [project_code], NULL as [notify_when_completed], NULL as [campaign_code], NULL as [source_code], NULL as [confirmed_time], NULL as [confirmed_time_from], NULL as [confirmed_time_to], NULL as [document_id], NULL as [milestone_activity_id], NULL as [cst_override_time_zone], NULL as [cst_lock_date], NULL as [cst_lock_by_user_code], NULL as [cst_activity_type_code], NULL as [cst_promotion_code], NULL as [cst_no_followup_flag], NULL as [cst_followup_time], NULL as [cst_followup_date], NULL as [cst_time_zone_code], NULL as [project_id], NULL as [cst_utc_start_date], NULL as [cst_brochure_download], NULL as [cst_queue_id], NULL as [cst_in_noble_queue], NULL as [cst_language_code], NULL as [cst_sfdc_task_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[activity_id], t.[recur_id], t.[opportunity_id], t.[incident_id], t.[due_date], t.[start_time], t.[duration], t.[action_code], t.[description], t.[creation_date], t.[created_by_user_code], t.[completion_date], t.[completion_time], t.[completed_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[result_code], t.[batch_status_code], t.[batch_result_code], t.[batch_address_type_code], t.[priority], t.[project_code], t.[notify_when_completed], t.[campaign_code], t.[source_code], t.[confirmed_time], t.[confirmed_time_from], t.[confirmed_time_to], t.[document_id], t.[milestone_activity_id], t.[cst_override_time_zone], t.[cst_lock_date], t.[cst_lock_by_user_code], t.[cst_activity_type_code], t.[cst_promotion_code], t.[cst_no_followup_flag], t.[cst_followup_time], t.[cst_followup_date], t.[cst_time_zone_code], t.[project_id], t.[cst_utc_start_date], t.[cst_brochure_download], t.[cst_queue_id], t.[cst_in_noble_queue], t.[cst_language_code], t.[cst_sfdc_task_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_activity_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[activity_id], t.[recur_id], t.[opportunity_id], t.[incident_id], t.[due_date], t.[start_time], t.[duration], t.[action_code], t.[description], t.[creation_date], t.[created_by_user_code], t.[completion_date], t.[completion_time], t.[completed_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[result_code], t.[batch_status_code], t.[batch_result_code], t.[batch_address_type_code], t.[priority], t.[project_code], t.[notify_when_completed], t.[campaign_code], t.[source_code], t.[confirmed_time], t.[confirmed_time_from], t.[confirmed_time_to], t.[document_id], t.[milestone_activity_id], t.[cst_override_time_zone], t.[cst_lock_date], t.[cst_lock_by_user_code], t.[cst_activity_type_code], t.[cst_promotion_code], t.[cst_no_followup_flag], t.[cst_followup_time], t.[cst_followup_date], t.[cst_time_zone_code], t.[project_id], t.[cst_utc_start_date], t.[cst_brochure_download], t.[cst_queue_id], t.[cst_in_noble_queue], t.[cst_language_code], t.[cst_sfdc_task_id], t.[cst_do_not_export], t.[cst_import_note]
	from [cdc].[dbo_oncd_activity_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
