/* CreateDate: 01/03/2018 17:04:45.860 , ModifyDate: 01/03/2018 17:04:45.860 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_contact]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_id], NULL as [greeting], NULL as [first_name], NULL as [middle_name], NULL as [last_name], NULL as [suffix], NULL as [first_name_search], NULL as [last_name_search], NULL as [first_name_soundex], NULL as [last_name_soundex], NULL as [salutation_code], NULL as [contact_status_code], NULL as [external_id], NULL as [contact_method_code], NULL as [do_not_solicit], NULL as [duplicate_check], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [status_updated_date], NULL as [status_updated_by_user_code], NULL as [cst_gender_code], NULL as [cst_call_time], NULL as [cst_complete_sale], NULL as [cst_research], NULL as [cst_dnc_flag], NULL as [cst_referring_store], NULL as [cst_referring_stylist], NULL as [cst_do_not_call], NULL as [cst_language_code], NULL as [cst_promotion_code], NULL as [cst_request_code], NULL as [cst_age_range_code], NULL as [cst_hair_loss_code], NULL as [cst_dnc_date], NULL as [cst_sessionid], NULL as [cst_affiliateid], NULL as [alt_center], NULL as [cst_loginid], NULL as [cst_do_not_email], NULL as [cst_do_not_mail], NULL as [cst_do_not_text], NULL as [surgery_consultation_flag], NULL as [cst_age], NULL as [cst_hair_loss_spot_code], NULL as [cst_hair_loss_experience_code], NULL as [cst_hair_loss_product], NULL as [cst_hair_loss_in_family_code], NULL as [cst_hair_loss_family_code], NULL as [cst_has_valid_cell_phone], NULL as [cst_has_open_confirmation_call], NULL as [cst_siebel_id], NULL as [cst_previous_first_name], NULL as [cst_previous_last_name], NULL as [cst_updated_by_user_code], NULL as [cst_contact_accomodation_code], NULL as [cst_sfdc_lead_id], NULL as [cst_do_not_export], NULL as [cst_import_note]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_4277689C
	    when 1 then __$operation
	    else
			case __$min_op_4277689C
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
		null as __$update_mask , [contact_id], [greeting], [first_name], [middle_name], [last_name], [suffix], [first_name_search], [last_name_search], [first_name_soundex], [last_name_soundex], [salutation_code], [contact_status_code], [external_id], [contact_method_code], [do_not_solicit], [duplicate_check], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [status_updated_date], [status_updated_by_user_code], [cst_gender_code], [cst_call_time], [cst_complete_sale], [cst_research], [cst_dnc_flag], [cst_referring_store], [cst_referring_stylist], [cst_do_not_call], [cst_language_code], [cst_promotion_code], [cst_request_code], [cst_age_range_code], [cst_hair_loss_code], [cst_dnc_date], [cst_sessionid], [cst_affiliateid], [alt_center], [cst_loginid], [cst_do_not_email], [cst_do_not_mail], [cst_do_not_text], [surgery_consultation_flag], [cst_age], [cst_hair_loss_spot_code], [cst_hair_loss_experience_code], [cst_hair_loss_product], [cst_hair_loss_in_family_code], [cst_hair_loss_family_code], [cst_has_valid_cell_phone], [cst_has_open_confirmation_call], [cst_siebel_id], [cst_previous_first_name], [cst_previous_last_name], [cst_updated_by_user_code], [cst_contact_accomodation_code], [cst_sfdc_lead_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_4277689C
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_CT] c with (nolock)
			where  ( (c.[contact_id] = t.[contact_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_4277689C, __$count_4277689C, t.[contact_id], t.[greeting], t.[first_name], t.[middle_name], t.[last_name], t.[suffix], t.[first_name_search], t.[last_name_search], t.[first_name_soundex], t.[last_name_soundex], t.[salutation_code], t.[contact_status_code], t.[external_id], t.[contact_method_code], t.[do_not_solicit], t.[duplicate_check], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[status_updated_date], t.[status_updated_by_user_code], t.[cst_gender_code], t.[cst_call_time], t.[cst_complete_sale], t.[cst_research], t.[cst_dnc_flag], t.[cst_referring_store], t.[cst_referring_stylist], t.[cst_do_not_call], t.[cst_language_code], t.[cst_promotion_code], t.[cst_request_code], t.[cst_age_range_code], t.[cst_hair_loss_code], t.[cst_dnc_date], t.[cst_sessionid], t.[cst_affiliateid], t.[alt_center], t.[cst_loginid], t.[cst_do_not_email], t.[cst_do_not_mail], t.[cst_do_not_text], t.[surgery_consultation_flag], t.[cst_age], t.[cst_hair_loss_spot_code], t.[cst_hair_loss_experience_code], t.[cst_hair_loss_product], t.[cst_hair_loss_in_family_code], t.[cst_hair_loss_family_code], t.[cst_has_valid_cell_phone], t.[cst_has_open_confirmation_call], t.[cst_siebel_id], t.[cst_previous_first_name], t.[cst_previous_last_name], t.[cst_updated_by_user_code], t.[cst_contact_accomodation_code], t.[cst_sfdc_lead_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_CT] t with (nolock) inner join
		(	select  r.[contact_id], max(r.__$seqval) as __$max_seqval_4277689C,
		    count(*) as __$count_4277689C
			from [cdc].[dbo_oncd_contact_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_id]) m
		on t.__$seqval = m.__$max_seqval_4277689C and
		    ( (t.[contact_id] = m.[contact_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_CT] c with (nolock)
							where  ( (c.[contact_id] = t.[contact_id]) )
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
	    case __$count_4277689C
	    when 1 then __$operation
	    else
			case __$min_op_4277689C
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
		case __$count_4277689C
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_4277689C
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_id], [greeting], [first_name], [middle_name], [last_name], [suffix], [first_name_search], [last_name_search], [first_name_soundex], [last_name_soundex], [salutation_code], [contact_status_code], [external_id], [contact_method_code], [do_not_solicit], [duplicate_check], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [status_updated_date], [status_updated_by_user_code], [cst_gender_code], [cst_call_time], [cst_complete_sale], [cst_research], [cst_dnc_flag], [cst_referring_store], [cst_referring_stylist], [cst_do_not_call], [cst_language_code], [cst_promotion_code], [cst_request_code], [cst_age_range_code], [cst_hair_loss_code], [cst_dnc_date], [cst_sessionid], [cst_affiliateid], [alt_center], [cst_loginid], [cst_do_not_email], [cst_do_not_mail], [cst_do_not_text], [surgery_consultation_flag], [cst_age], [cst_hair_loss_spot_code], [cst_hair_loss_experience_code], [cst_hair_loss_product], [cst_hair_loss_in_family_code], [cst_hair_loss_family_code], [cst_has_valid_cell_phone], [cst_has_open_confirmation_call], [cst_siebel_id], [cst_previous_first_name], [cst_previous_last_name], [cst_updated_by_user_code], [cst_contact_accomodation_code], [cst_sfdc_lead_id], [cst_do_not_export], [cst_import_note]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_4277689C
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_CT] c with (nolock)
			where  ( (c.[contact_id] = t.[contact_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_4277689C, __$count_4277689C,
		m.__$update_mask , t.[contact_id], t.[greeting], t.[first_name], t.[middle_name], t.[last_name], t.[suffix], t.[first_name_search], t.[last_name_search], t.[first_name_soundex], t.[last_name_soundex], t.[salutation_code], t.[contact_status_code], t.[external_id], t.[contact_method_code], t.[do_not_solicit], t.[duplicate_check], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[status_updated_date], t.[status_updated_by_user_code], t.[cst_gender_code], t.[cst_call_time], t.[cst_complete_sale], t.[cst_research], t.[cst_dnc_flag], t.[cst_referring_store], t.[cst_referring_stylist], t.[cst_do_not_call], t.[cst_language_code], t.[cst_promotion_code], t.[cst_request_code], t.[cst_age_range_code], t.[cst_hair_loss_code], t.[cst_dnc_date], t.[cst_sessionid], t.[cst_affiliateid], t.[alt_center], t.[cst_loginid], t.[cst_do_not_email], t.[cst_do_not_mail], t.[cst_do_not_text], t.[surgery_consultation_flag], t.[cst_age], t.[cst_hair_loss_spot_code], t.[cst_hair_loss_experience_code], t.[cst_hair_loss_product], t.[cst_hair_loss_in_family_code], t.[cst_hair_loss_family_code], t.[cst_has_valid_cell_phone], t.[cst_has_open_confirmation_call], t.[cst_siebel_id], t.[cst_previous_first_name], t.[cst_previous_last_name], t.[cst_updated_by_user_code], t.[cst_contact_accomodation_code], t.[cst_sfdc_lead_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_CT] t with (nolock) inner join
		(	select  r.[contact_id], max(r.__$seqval) as __$max_seqval_4277689C,
		    count(*) as __$count_4277689C,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_contact_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_id]) m
		on t.__$seqval = m.__$max_seqval_4277689C and
		    ( (t.[contact_id] = m.[contact_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_CT] c with (nolock)
							where  ( (c.[contact_id] = t.[contact_id]) )
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
		null as __$update_mask , t.[contact_id], t.[greeting], t.[first_name], t.[middle_name], t.[last_name], t.[suffix], t.[first_name_search], t.[last_name_search], t.[first_name_soundex], t.[last_name_soundex], t.[salutation_code], t.[contact_status_code], t.[external_id], t.[contact_method_code], t.[do_not_solicit], t.[duplicate_check], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[status_updated_date], t.[status_updated_by_user_code], t.[cst_gender_code], t.[cst_call_time], t.[cst_complete_sale], t.[cst_research], t.[cst_dnc_flag], t.[cst_referring_store], t.[cst_referring_stylist], t.[cst_do_not_call], t.[cst_language_code], t.[cst_promotion_code], t.[cst_request_code], t.[cst_age_range_code], t.[cst_hair_loss_code], t.[cst_dnc_date], t.[cst_sessionid], t.[cst_affiliateid], t.[alt_center], t.[cst_loginid], t.[cst_do_not_email], t.[cst_do_not_mail], t.[cst_do_not_text], t.[surgery_consultation_flag], t.[cst_age], t.[cst_hair_loss_spot_code], t.[cst_hair_loss_experience_code], t.[cst_hair_loss_product], t.[cst_hair_loss_in_family_code], t.[cst_hair_loss_family_code], t.[cst_has_valid_cell_phone], t.[cst_has_open_confirmation_call], t.[cst_siebel_id], t.[cst_previous_first_name], t.[cst_previous_last_name], t.[cst_updated_by_user_code], t.[cst_contact_accomodation_code], t.[cst_sfdc_lead_id], t.[cst_do_not_export], t.[cst_import_note]
		from [cdc].[dbo_oncd_contact_CT] t  with (nolock) inner join
		(	select  r.[contact_id], max(r.__$seqval) as __$max_seqval_4277689C
			from [cdc].[dbo_oncd_contact_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_id]) m
		on t.__$seqval = m.__$max_seqval_4277689C and
		    ( (t.[contact_id] = m.[contact_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_CT] c with (nolock)
							where  ( (c.[contact_id] = t.[contact_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
