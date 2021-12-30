/* CreateDate: 01/03/2018 17:04:45.287 , ModifyDate: 01/03/2018 17:04:45.287 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_onca_zip]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [zip_id], NULL as [zip_code], NULL as [city], NULL as [country_code], NULL as [state_code], NULL as [zip_code_type], NULL as [county_code], NULL as [latitude], NULL as [longitude], NULL as [area_code], NULL as [finance_code], NULL as [last_line], NULL as [facility_code], NULL as [msa_code], NULL as [pmsa_code], NULL as [cst_dma], NULL as [cst_city_type]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_EADF27BC
	    when 1 then __$operation
	    else
			case __$min_op_EADF27BC
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
		null as __$update_mask , [zip_id], [zip_code], [city], [country_code], [state_code], [zip_code_type], [county_code], [latitude], [longitude], [area_code], [finance_code], [last_line], [facility_code], [msa_code], [pmsa_code], [cst_dma], [cst_city_type]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_EADF27BC
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_zip_CT] c with (nolock)
			where  ( (c.[zip_id] = t.[zip_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_EADF27BC, __$count_EADF27BC, t.[zip_id], t.[zip_code], t.[city], t.[country_code], t.[state_code], t.[zip_code_type], t.[county_code], t.[latitude], t.[longitude], t.[area_code], t.[finance_code], t.[last_line], t.[facility_code], t.[msa_code], t.[pmsa_code], t.[cst_dma], t.[cst_city_type]
		from [cdc].[dbo_onca_zip_CT] t with (nolock) inner join
		(	select  r.[zip_id], max(r.__$seqval) as __$max_seqval_EADF27BC,
		    count(*) as __$count_EADF27BC
			from [cdc].[dbo_onca_zip_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[zip_id]) m
		on t.__$seqval = m.__$max_seqval_EADF27BC and
		    ( (t.[zip_id] = m.[zip_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_zip_CT] c with (nolock)
							where  ( (c.[zip_id] = t.[zip_id]) )
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
	    case __$count_EADF27BC
	    when 1 then __$operation
	    else
			case __$min_op_EADF27BC
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
		case __$count_EADF27BC
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_EADF27BC
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [zip_id], [zip_code], [city], [country_code], [state_code], [zip_code_type], [county_code], [latitude], [longitude], [area_code], [finance_code], [last_line], [facility_code], [msa_code], [pmsa_code], [cst_dma], [cst_city_type]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_EADF27BC
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_onca_zip_CT] c with (nolock)
			where  ( (c.[zip_id] = t.[zip_id]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_EADF27BC, __$count_EADF27BC,
		m.__$update_mask , t.[zip_id], t.[zip_code], t.[city], t.[country_code], t.[state_code], t.[zip_code_type], t.[county_code], t.[latitude], t.[longitude], t.[area_code], t.[finance_code], t.[last_line], t.[facility_code], t.[msa_code], t.[pmsa_code], t.[cst_dma], t.[cst_city_type]
		from [cdc].[dbo_onca_zip_CT] t with (nolock) inner join
		(	select  r.[zip_id], max(r.__$seqval) as __$max_seqval_EADF27BC,
		    count(*) as __$count_EADF27BC,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_onca_zip_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[zip_id]) m
		on t.__$seqval = m.__$max_seqval_EADF27BC and
		    ( (t.[zip_id] = m.[zip_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_zip_CT] c with (nolock)
							where  ( (c.[zip_id] = t.[zip_id]) )
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
		null as __$update_mask , t.[zip_id], t.[zip_code], t.[city], t.[country_code], t.[state_code], t.[zip_code_type], t.[county_code], t.[latitude], t.[longitude], t.[area_code], t.[finance_code], t.[last_line], t.[facility_code], t.[msa_code], t.[pmsa_code], t.[cst_dma], t.[cst_city_type]
		from [cdc].[dbo_onca_zip_CT] t  with (nolock) inner join
		(	select  r.[zip_id], max(r.__$seqval) as __$max_seqval_EADF27BC
			from [cdc].[dbo_onca_zip_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[zip_id]) m
		on t.__$seqval = m.__$max_seqval_EADF27BC and
		    ( (t.[zip_id] = m.[zip_id]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_onca_zip', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_onca_zip_CT] c with (nolock)
							where  ( (c.[zip_id] = t.[zip_id]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
