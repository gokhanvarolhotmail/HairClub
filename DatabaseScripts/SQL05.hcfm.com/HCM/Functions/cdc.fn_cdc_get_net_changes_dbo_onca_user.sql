/* CreateDate: 01/03/2018 17:04:45.007 , ModifyDate: 01/03/2018 17:04:45.007 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_onca_user]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [user_code], NULL as [department_code], NULL as [job_function_code], NULL as [login_id], NULL as [password_value], NULL as [password_date], NULL as [password_expires], NULL as [change_password], NULL as [first_name], NULL as [middle_name], NULL as [last_name], NULL as [full_name], NULL as [description], NULL as [title], NULL as [cti_server], NULL as [cti_user_code], NULL as [cti_password], NULL as [cti_station], NULL as [cti_extension], NULL as [action_set_code], NULL as [startup_object_id], NULL as [clear_cache], NULL as [active], NULL as [display_name], NULL as [license_type], NULL as [outlook_sync_frequency], NULL as [outlook_sync_confirm], NULL as [cst_is_queue_user]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_11DF8FD5
	    when 1 then __$operation
	    else
			case __$min_op_11DF8FD5
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
		null as __$update_mask , [user_code], [department_code], [job_function_code], [login_id], [password_value], [password_date], [password_expires], [change_password], [first_name], [middle_name], [last_name], [full_name], [description], [title], [cti_server], [cti_user_code], [cti_password], [cti_station], [cti_extension], [action_set_code], [startup_object_id], [clear_cache], [active], [display_name], [license_type], [outlook_sync_frequency], [outlook_sync_confirm], [cst_is_queue_user]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_11DF8FD5
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_user_CT] c with (nolock)
			where  ( (c.[user_code] = t.[user_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_11DF8FD5, __$count_11DF8FD5, t.[user_code], t.[department_code], t.[job_function_code], t.[login_id], t.[password_value], t.[password_date], t.[password_expires], t.[change_password], t.[first_name], t.[middle_name], t.[last_name], t.[full_name], t.[description], t.[title], t.[cti_server], t.[cti_user_code], t.[cti_password], t.[cti_station], t.[cti_extension], t.[action_set_code], t.[startup_object_id], t.[clear_cache], t.[active], t.[display_name], t.[license_type], t.[outlook_sync_frequency], t.[outlook_sync_confirm], t.[cst_is_queue_user]
		from [cdc].[dbo_onca_user_CT] t with (nolock) inner join
		(	select  r.[user_code], max(r.__$seqval) as __$max_seqval_11DF8FD5,
		    count(*) as __$count_11DF8FD5
			from [cdc].[dbo_onca_user_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[user_code]) m
		on t.__$seqval = m.__$max_seqval_11DF8FD5 and
		    ( (t.[user_code] = m.[user_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_user_CT] c with (nolock)
							where  ( (c.[user_code] = t.[user_code]) )
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
	    case __$count_11DF8FD5
	    when 1 then __$operation
	    else
			case __$min_op_11DF8FD5
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
		case __$count_11DF8FD5
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_11DF8FD5
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [user_code], [department_code], [job_function_code], [login_id], [password_value], [password_date], [password_expires], [change_password], [first_name], [middle_name], [last_name], [full_name], [description], [title], [cti_server], [cti_user_code], [cti_password], [cti_station], [cti_extension], [action_set_code], [startup_object_id], [clear_cache], [active], [display_name], [license_type], [outlook_sync_frequency], [outlook_sync_confirm], [cst_is_queue_user]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_11DF8FD5
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_user_CT] c with (nolock)
			where  ( (c.[user_code] = t.[user_code]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_11DF8FD5, __$count_11DF8FD5,
		m.__$update_mask , t.[user_code], t.[department_code], t.[job_function_code], t.[login_id], t.[password_value], t.[password_date], t.[password_expires], t.[change_password], t.[first_name], t.[middle_name], t.[last_name], t.[full_name], t.[description], t.[title], t.[cti_server], t.[cti_user_code], t.[cti_password], t.[cti_station], t.[cti_extension], t.[action_set_code], t.[startup_object_id], t.[clear_cache], t.[active], t.[display_name], t.[license_type], t.[outlook_sync_frequency], t.[outlook_sync_confirm], t.[cst_is_queue_user]
		from [cdc].[dbo_onca_user_CT] t with (nolock) inner join
		(	select  r.[user_code], max(r.__$seqval) as __$max_seqval_11DF8FD5,
		    count(*) as __$count_11DF8FD5,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_onca_user_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[user_code]) m
		on t.__$seqval = m.__$max_seqval_11DF8FD5 and
		    ( (t.[user_code] = m.[user_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_user_CT] c with (nolock)
							where  ( (c.[user_code] = t.[user_code]) )
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
		null as __$update_mask , t.[user_code], t.[department_code], t.[job_function_code], t.[login_id], t.[password_value], t.[password_date], t.[password_expires], t.[change_password], t.[first_name], t.[middle_name], t.[last_name], t.[full_name], t.[description], t.[title], t.[cti_server], t.[cti_user_code], t.[cti_password], t.[cti_station], t.[cti_extension], t.[action_set_code], t.[startup_object_id], t.[clear_cache], t.[active], t.[display_name], t.[license_type], t.[outlook_sync_frequency], t.[outlook_sync_confirm], t.[cst_is_queue_user]
		from [cdc].[dbo_onca_user_CT] t  with (nolock) inner join
		(	select  r.[user_code], max(r.__$seqval) as __$max_seqval_11DF8FD5
			from [cdc].[dbo_onca_user_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[user_code]) m
		on t.__$seqval = m.__$max_seqval_11DF8FD5 and
		    ( (t.[user_code] = m.[user_code]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_user', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_user_CT] c with (nolock)
							where  ( (c.[user_code] = t.[user_code]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
