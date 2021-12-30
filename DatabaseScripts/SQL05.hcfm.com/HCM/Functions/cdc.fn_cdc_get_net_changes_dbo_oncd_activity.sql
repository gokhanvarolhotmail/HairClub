/* CreateDate: 01/03/2018 17:04:45.500 , ModifyDate: 01/03/2018 17:04:45.500 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_activity]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [activity_id], NULL as [recur_id], NULL as [opportunity_id], NULL as [incident_id], NULL as [due_date], NULL as [start_time], NULL as [duration], NULL as [action_code], NULL as [description], NULL as [creation_date], NULL as [created_by_user_code], NULL as [completion_date], NULL as [completion_time], NULL as [completed_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [result_code], NULL as [batch_status_code], NULL as [batch_result_code], NULL as [batch_address_type_code], NULL as [priority], NULL as [project_code], NULL as [notify_when_completed], NULL as [campaign_code], NULL as [source_code], NULL as [confirmed_time], NULL as [confirmed_time_from], NULL as [confirmed_time_to], NULL as [document_id], NULL as [milestone_activity_id], NULL as [cst_override_time_zone], NULL as [cst_lock_date], NULL as [cst_lock_by_user_code], NULL as [cst_activity_type_code], NULL as [cst_promotion_code], NULL as [cst_no_followup_flag], NULL as [cst_followup_time], NULL as [cst_followup_date], NULL as [cst_time_zone_code], NULL as [project_id], NULL as [cst_utc_start_date], NULL as [cst_brochure_download], NULL as [cst_queue_id], NULL as [cst_in_noble_queue], NULL as [cst_language_code], NULL as [cst_sfdc_task_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_68D6C2DA
	    when 1 then __$operation
	    else
			case __$min_op_68D6C2DA
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [activity_id], [recur_id], [opportunity_id], [incident_id], [due_date], [start_time], [duration], [action_code], [description], [creation_date], [created_by_user_code], [completion_date], [completion_time], [completed_by_user_code], [updated_date], [updated_by_user_code], [result_code], [batch_status_code], [batch_result_code], [batch_address_type_code], [priority], [project_code], [notify_when_completed], [campaign_code], [source_code], [confirmed_time], [confirmed_time_from], [confirmed_time_to], [document_id], [milestone_activity_id], [cst_override_time_zone], [cst_lock_date], [cst_lock_by_user_code], [cst_activity_type_code], [cst_promotion_code], [cst_no_followup_flag], [cst_followup_time], [cst_followup_date], [cst_time_zone_code], [project_id], [cst_utc_start_date], [cst_brochure_download], [cst_queue_id], [cst_in_noble_queue], [cst_language_code], [cst_sfdc_task_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_68D6C2DA
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_activity_CT] c with (nolock)
			where  ( (c.[activity_id] = t.[activity_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_68D6C2DA, __$count_68D6C2DA, t.[activity_id], t.[recur_id], t.[opportunity_id], t.[incident_id], t.[due_date], t.[start_time], t.[duration], t.[action_code], t.[description], t.[creation_date], t.[created_by_user_code], t.[completion_date], t.[completion_time], t.[completed_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[result_code], t.[batch_status_code], t.[batch_result_code], t.[batch_address_type_code], t.[priority], t.[project_code], t.[notify_when_completed], t.[campaign_code], t.[source_code], t.[confirmed_time], t.[confirmed_time_from], t.[confirmed_time_to], t.[document_id], t.[milestone_activity_id], t.[cst_override_time_zone], t.[cst_lock_date], t.[cst_lock_by_user_code], t.[cst_activity_type_code], t.[cst_promotion_code], t.[cst_no_followup_flag], t.[cst_followup_time], t.[cst_followup_date], t.[cst_time_zone_code], t.[project_id], t.[cst_utc_start_date], t.[cst_brochure_download], t.[cst_queue_id], t.[cst_in_noble_queue], t.[cst_language_code], t.[cst_sfdc_task_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_activity_CT] t with (nolock) inner join
		(	select  r.[activity_id], max(r.__$seqval) as __$max_seqval_68D6C2DA,
		    count(*) as __$count_68D6C2DA
			from [cdc].[dbo_oncd_activity_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_id]) m
		on t.__$seqval = m.__$max_seqval_68D6C2DA and
		    ( (t.[activity_id] = m.[activity_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_activity_CT] c with (nolock)
							where  ( (c.[activity_id] = t.[activity_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

	select __$start_lsn,
	    case __$count_68D6C2DA
	    when 1 then __$operation
	    else
			case __$min_op_68D6C2DA
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_68D6C2DA
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_68D6C2DA
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [activity_id], [recur_id], [opportunity_id], [incident_id], [due_date], [start_time], [duration], [action_code], [description], [creation_date], [created_by_user_code], [completion_date], [completion_time], [completed_by_user_code], [updated_date], [updated_by_user_code], [result_code], [batch_status_code], [batch_result_code], [batch_address_type_code], [priority], [project_code], [notify_when_completed], [campaign_code], [source_code], [confirmed_time], [confirmed_time_from], [confirmed_time_to], [document_id], [milestone_activity_id], [cst_override_time_zone], [cst_lock_date], [cst_lock_by_user_code], [cst_activity_type_code], [cst_promotion_code], [cst_no_followup_flag], [cst_followup_time], [cst_followup_date], [cst_time_zone_code], [project_id], [cst_utc_start_date], [cst_brochure_download], [cst_queue_id], [cst_in_noble_queue], [cst_language_code], [cst_sfdc_task_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_68D6C2DA
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_activity_CT] c with (nolock)
			where  ( (c.[activity_id] = t.[activity_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_68D6C2DA, __$count_68D6C2DA,
		m.__$update_mask , t.[activity_id], t.[recur_id], t.[opportunity_id], t.[incident_id], t.[due_date], t.[start_time], t.[duration], t.[action_code], t.[description], t.[creation_date], t.[created_by_user_code], t.[completion_date], t.[completion_time], t.[completed_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[result_code], t.[batch_status_code], t.[batch_result_code], t.[batch_address_type_code], t.[priority], t.[project_code], t.[notify_when_completed], t.[campaign_code], t.[source_code], t.[confirmed_time], t.[confirmed_time_from], t.[confirmed_time_to], t.[document_id], t.[milestone_activity_id], t.[cst_override_time_zone], t.[cst_lock_date], t.[cst_lock_by_user_code], t.[cst_activity_type_code], t.[cst_promotion_code], t.[cst_no_followup_flag], t.[cst_followup_time], t.[cst_followup_date], t.[cst_time_zone_code], t.[project_id], t.[cst_utc_start_date], t.[cst_brochure_download], t.[cst_queue_id], t.[cst_in_noble_queue], t.[cst_language_code], t.[cst_sfdc_task_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_activity_CT] t with (nolock) inner join
		(	select  r.[activity_id], max(r.__$seqval) as __$max_seqval_68D6C2DA,
		    count(*) as __$count_68D6C2DA,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_activity_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_id]) m
		on t.__$seqval = m.__$max_seqval_68D6C2DA and
		    ( (t.[activity_id] = m.[activity_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_activity_CT] c with (nolock)
							where  ( (c.[activity_id] = t.[activity_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[activity_id], t.[recur_id], t.[opportunity_id], t.[incident_id], t.[due_date], t.[start_time], t.[duration], t.[action_code], t.[description], t.[creation_date], t.[created_by_user_code], t.[completion_date], t.[completion_time], t.[completed_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[result_code], t.[batch_status_code], t.[batch_result_code], t.[batch_address_type_code], t.[priority], t.[project_code], t.[notify_when_completed], t.[campaign_code], t.[source_code], t.[confirmed_time], t.[confirmed_time_from], t.[confirmed_time_to], t.[document_id], t.[milestone_activity_id], t.[cst_override_time_zone], t.[cst_lock_date], t.[cst_lock_by_user_code], t.[cst_activity_type_code], t.[cst_promotion_code], t.[cst_no_followup_flag], t.[cst_followup_time], t.[cst_followup_date], t.[cst_time_zone_code], t.[project_id], t.[cst_utc_start_date], t.[cst_brochure_download], t.[cst_queue_id], t.[cst_in_noble_queue], t.[cst_language_code], t.[cst_sfdc_task_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_activity_CT] t  with (nolock) inner join
		(	select  r.[activity_id], max(r.__$seqval) as __$max_seqval_68D6C2DA
			from [cdc].[dbo_oncd_activity_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[activity_id]) m
		on t.__$seqval = m.__$max_seqval_68D6C2DA and
		    ( (t.[activity_id] = m.[activity_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_activity', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_activity_CT] c with (nolock)
							where  ( (c.[activity_id] = t.[activity_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
