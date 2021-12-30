/* CreateDate: 01/03/2018 17:04:47.660 , ModifyDate: 01/03/2018 17:04:47.660 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_oncd_contact_company]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [contact_company_id], NULL as [contact_id], NULL as [company_id], NULL as [company_role_code], NULL as [description], NULL as [sort_order], NULL as [reports_to_contact_id], NULL as [creation_date], NULL as [created_by_user_code], NULL as [updated_date], NULL as [updated_by_user_code], NULL as [primary_flag], NULL as [title], NULL as [department_code], NULL as [internal_title_code], NULL as [cst_preferred_center_flag]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_company', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_66F5444D
	    when 1 then __$operation
	    else
			case __$min_op_66F5444D
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
		null as __$update_mask , [contact_company_id], [contact_id], [company_id], [company_role_code], [description], [sort_order], [reports_to_contact_id], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [title], [department_code], [internal_title_code], [cst_preferred_center_flag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_66F5444D
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_company_CT] c with (nolock)
			where  ( (c.[contact_company_id] = t.[contact_company_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_66F5444D, __$count_66F5444D, t.[contact_company_id], t.[contact_id], t.[company_id], t.[company_role_code], t.[description], t.[sort_order], t.[reports_to_contact_id], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[title], t.[department_code], t.[internal_title_code], t.[cst_preferred_center_flag]
		from [cdc].[dbo_oncd_contact_company_CT] t with (nolock) inner join
		(	select  r.[contact_company_id], max(r.__$seqval) as __$max_seqval_66F5444D,
		    count(*) as __$count_66F5444D
			from [cdc].[dbo_oncd_contact_company_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_company_id]) m
		on t.__$seqval = m.__$max_seqval_66F5444D and
		    ( (t.[contact_company_id] = m.[contact_company_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_company', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_company_CT] c with (nolock)
							where  ( (c.[contact_company_id] = t.[contact_company_id]) )
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
	    case __$count_66F5444D
	    when 1 then __$operation
	    else
			case __$min_op_66F5444D
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
		case __$count_66F5444D
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_66F5444D
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [contact_company_id], [contact_id], [company_id], [company_role_code], [description], [sort_order], [reports_to_contact_id], [creation_date], [created_by_user_code], [updated_date], [updated_by_user_code], [primary_flag], [title], [department_code], [internal_title_code], [cst_preferred_center_flag]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_66F5444D
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_oncd_contact_company_CT] c with (nolock)
			where  ( (c.[contact_company_id] = t.[contact_company_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_66F5444D, __$count_66F5444D,
		m.__$update_mask , t.[contact_company_id], t.[contact_id], t.[company_id], t.[company_role_code], t.[description], t.[sort_order], t.[reports_to_contact_id], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[title], t.[department_code], t.[internal_title_code], t.[cst_preferred_center_flag]
		from [cdc].[dbo_oncd_contact_company_CT] t with (nolock) inner join
		(	select  r.[contact_company_id], max(r.__$seqval) as __$max_seqval_66F5444D,
		    count(*) as __$count_66F5444D,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_oncd_contact_company_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_company_id]) m
		on t.__$seqval = m.__$max_seqval_66F5444D and
		    ( (t.[contact_company_id] = m.[contact_company_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_company', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_company_CT] c with (nolock)
							where  ( (c.[contact_company_id] = t.[contact_company_id]) )
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
		null as __$update_mask , t.[contact_company_id], t.[contact_id], t.[company_id], t.[company_role_code], t.[description], t.[sort_order], t.[reports_to_contact_id], t.[creation_date], t.[created_by_user_code], t.[updated_date], t.[updated_by_user_code], t.[primary_flag], t.[title], t.[department_code], t.[internal_title_code], t.[cst_preferred_center_flag]
		from [cdc].[dbo_oncd_contact_company_CT] t  with (nolock) inner join
		(	select  r.[contact_company_id], max(r.__$seqval) as __$max_seqval_66F5444D
			from [cdc].[dbo_oncd_contact_company_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[contact_company_id]) m
		on t.__$seqval = m.__$max_seqval_66F5444D and
		    ( (t.[contact_company_id] = m.[contact_company_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_oncd_contact_company', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_oncd_contact_company_CT] c with (nolock)
							where  ( (c.[contact_company_id] = t.[contact_company_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
