/* CreateDate: 01/03/2018 17:04:44.383 , ModifyDate: 01/03/2018 17:04:44.383 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cstd_contact_completion]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_completion_id], NULL as [company_id], NULL as [created_by_user_code], NULL as [updated_by_user_code], NULL as [contact_id], NULL as [sale_type_code], NULL as [sale_type_description], NULL as [show_no_show_flag], NULL as [sale_no_sale_flag], NULL as [contract_number], NULL as [contract_amount], NULL as [client_number], NULL as [initial_payment], NULL as [systems], NULL as [services], NULL as [number_of_graphs], NULL as [original_appointment_date], NULL as [date_saved], NULL as [status_line], NULL as [head_size], NULL as [base_price], NULL as [discount_amount], NULL as [discount_percentage], NULL as [balance_amount], NULL as [balance_percentage], NULL as [hair_length], NULL as [reschedule_flag], NULL as [date_rescheduled], NULL as [time_rescheduled], NULL as [discount_markup_flag], NULL as [comment], NULL as [followup_result_id], NULL as [followup_result], NULL as [surgery_offered_flag], NULL as [referred_to_doctor_flag], NULL as [creation_date], NULL as [updated_date], NULL as [activity_id], NULL as [length_price], NULL as [surgery_consultation_flag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_CB37ABE6
	    when 1 then __$operation
	    else
			case __$min_op_CB37ABE6
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
		null as __$update_mask , [contact_completion_id], [company_id], [created_by_user_code], [updated_by_user_code], [contact_id], [sale_type_code], [sale_type_description], [show_no_show_flag], [sale_no_sale_flag], [contract_number], [contract_amount], [client_number], [initial_payment], [systems], [services], [number_of_graphs], [original_appointment_date], [date_saved], [status_line], [head_size], [base_price], [discount_amount], [discount_percentage], [balance_amount], [balance_percentage], [hair_length], [reschedule_flag], [date_rescheduled], [time_rescheduled], [discount_markup_flag], [comment], [followup_result_id], [followup_result], [surgery_offered_flag], [referred_to_doctor_flag], [creation_date], [updated_date], [activity_id], [length_price], [surgery_consultation_flag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CB37ABE6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_contact_completion_CT] c with (nolock)
			where  ( (c.[contact_completion_id] = t.[contact_completion_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CB37ABE6, __$count_CB37ABE6, t.[contact_completion_id], t.[company_id], t.[created_by_user_code], t.[updated_by_user_code], t.[contact_id], t.[sale_type_code], t.[sale_type_description], t.[show_no_show_flag], t.[sale_no_sale_flag], t.[contract_number], t.[contract_amount], t.[client_number], t.[initial_payment], t.[systems], t.[services], t.[number_of_graphs], t.[original_appointment_date], t.[date_saved], t.[status_line], t.[head_size], t.[base_price], t.[discount_amount], t.[discount_percentage], t.[balance_amount], t.[balance_percentage], t.[hair_length], t.[reschedule_flag], t.[date_rescheduled], t.[time_rescheduled], t.[discount_markup_flag], t.[comment], t.[followup_result_id], t.[followup_result], t.[surgery_offered_flag], t.[referred_to_doctor_flag], t.[creation_date], t.[updated_date], t.[activity_id], t.[length_price], t.[surgery_consultation_flag]
		from [cdc].[dbo_cstd_contact_completion_CT] t with (nolock) inner join
		(	select  r.[contact_completion_id], max(r.__$seqval) as __$max_seqval_CB37ABE6,
		    count(*) as __$count_CB37ABE6
			from [cdc].[dbo_cstd_contact_completion_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_completion_id]) m
		on t.__$seqval = m.__$max_seqval_CB37ABE6 and
		    ( (t.[contact_completion_id] = m.[contact_completion_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_completion_CT] c with (nolock)
							where  ( (c.[contact_completion_id] = t.[contact_completion_id]) )
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
	    case __$count_CB37ABE6
	    when 1 then __$operation
	    else
			case __$min_op_CB37ABE6
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
		case __$count_CB37ABE6
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_CB37ABE6
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_completion_id], [company_id], [created_by_user_code], [updated_by_user_code], [contact_id], [sale_type_code], [sale_type_description], [show_no_show_flag], [sale_no_sale_flag], [contract_number], [contract_amount], [client_number], [initial_payment], [systems], [services], [number_of_graphs], [original_appointment_date], [date_saved], [status_line], [head_size], [base_price], [discount_amount], [discount_percentage], [balance_amount], [balance_percentage], [hair_length], [reschedule_flag], [date_rescheduled], [time_rescheduled], [discount_markup_flag], [comment], [followup_result_id], [followup_result], [surgery_offered_flag], [referred_to_doctor_flag], [creation_date], [updated_date], [activity_id], [length_price], [surgery_consultation_flag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CB37ABE6
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cstd_contact_completion_CT] c with (nolock)
			where  ( (c.[contact_completion_id] = t.[contact_completion_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CB37ABE6, __$count_CB37ABE6,
		m.__$update_mask , t.[contact_completion_id], t.[company_id], t.[created_by_user_code], t.[updated_by_user_code], t.[contact_id], t.[sale_type_code], t.[sale_type_description], t.[show_no_show_flag], t.[sale_no_sale_flag], t.[contract_number], t.[contract_amount], t.[client_number], t.[initial_payment], t.[systems], t.[services], t.[number_of_graphs], t.[original_appointment_date], t.[date_saved], t.[status_line], t.[head_size], t.[base_price], t.[discount_amount], t.[discount_percentage], t.[balance_amount], t.[balance_percentage], t.[hair_length], t.[reschedule_flag], t.[date_rescheduled], t.[time_rescheduled], t.[discount_markup_flag], t.[comment], t.[followup_result_id], t.[followup_result], t.[surgery_offered_flag], t.[referred_to_doctor_flag], t.[creation_date], t.[updated_date], t.[activity_id], t.[length_price], t.[surgery_consultation_flag]
		from [cdc].[dbo_cstd_contact_completion_CT] t with (nolock) inner join
		(	select  r.[contact_completion_id], max(r.__$seqval) as __$max_seqval_CB37ABE6,
		    count(*) as __$count_CB37ABE6,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cstd_contact_completion_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_completion_id]) m
		on t.__$seqval = m.__$max_seqval_CB37ABE6 and
		    ( (t.[contact_completion_id] = m.[contact_completion_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_completion_CT] c with (nolock)
							where  ( (c.[contact_completion_id] = t.[contact_completion_id]) )
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
		null as __$update_mask , t.[contact_completion_id], t.[company_id], t.[created_by_user_code], t.[updated_by_user_code], t.[contact_id], t.[sale_type_code], t.[sale_type_description], t.[show_no_show_flag], t.[sale_no_sale_flag], t.[contract_number], t.[contract_amount], t.[client_number], t.[initial_payment], t.[systems], t.[services], t.[number_of_graphs], t.[original_appointment_date], t.[date_saved], t.[status_line], t.[head_size], t.[base_price], t.[discount_amount], t.[discount_percentage], t.[balance_amount], t.[balance_percentage], t.[hair_length], t.[reschedule_flag], t.[date_rescheduled], t.[time_rescheduled], t.[discount_markup_flag], t.[comment], t.[followup_result_id], t.[followup_result], t.[surgery_offered_flag], t.[referred_to_doctor_flag], t.[creation_date], t.[updated_date], t.[activity_id], t.[length_price], t.[surgery_consultation_flag]
		from [cdc].[dbo_cstd_contact_completion_CT] t  with (nolock) inner join
		(	select  r.[contact_completion_id], max(r.__$seqval) as __$max_seqval_CB37ABE6
			from [cdc].[dbo_cstd_contact_completion_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_completion_id]) m
		on t.__$seqval = m.__$max_seqval_CB37ABE6 and
		    ( (t.[contact_completion_id] = m.[contact_completion_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cstd_contact_completion', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cstd_contact_completion_CT] c with (nolock)
							where  ( (c.[contact_completion_id] = t.[contact_completion_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
