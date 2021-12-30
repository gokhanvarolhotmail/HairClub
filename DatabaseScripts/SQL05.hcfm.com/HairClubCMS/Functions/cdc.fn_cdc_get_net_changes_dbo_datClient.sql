/* CreateDate: 05/05/2020 18:40:59.460 , ModifyDate: 05/05/2020 18:40:59.460 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datClient]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientGUID], NULL as [ClientIdentifier], NULL as [ClientNumber_Temp], NULL as [CenterID], NULL as [CountryID], NULL as [SalutationID], NULL as [ContactID], NULL as [FirstName], NULL as [MiddleName], NULL as [LastName], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [ARBalance], NULL as [GenderID], NULL as [DateOfBirth], NULL as [DoNotCallFlag], NULL as [DoNotContactFlag], NULL as [IsHairModelFlag], NULL as [IsTaxExemptFlag], NULL as [EMailAddress], NULL as [TextMessageAddress], NULL as [Phone1], NULL as [Phone2], NULL as [Phone3], NULL as [Phone1TypeID], NULL as [Phone2TypeID], NULL as [Phone3TypeID], NULL as [IsPhone1PrimaryFlag], NULL as [IsPhone2PrimaryFlag], NULL as [IsPhone3PrimaryFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsHairSystemClientFlag], NULL as [TaxExemptNumber], NULL as [CurrentBioMatrixClientMembershipGUID], NULL as [CurrentSurgeryClientMembershipGUID], NULL as [CurrentExtremeTherapyClientMembershipGUID], NULL as [IsAutoConfirmTextPhone1], NULL as [IsAutoConfirmTextPhone2], NULL as [IsAutoConfirmTextPhone3], NULL as [ImportCreateDate], NULL as [ImportLastUpdate], NULL as [ClientMembershipCounter], NULL as [RequiredNoteReview], NULL as [SiebelID], NULL as [EmergencyContactPhone], NULL as [BosleyProcedureOffice], NULL as [BosleyConsultOffice], NULL as [IsAutoConfirmEmail], NULL as [IsEmailUndeliverable], NULL as [AcquiredDate], NULL as [CurrentXtrandsClientMembershipGUID], NULL as [ExpectedConversionDate], NULL as [LanguageID], NULL as [IsConfirmCallPhone1], NULL as [IsConfirmCallPhone2], NULL as [IsConfirmCallPhone3], NULL as [AnniversaryDate], NULL as [CanConfirmAppointmentByEmail], NULL as [CanContactForPromotionsByEmail], NULL as [DoNotVisitInRoom], NULL as [DoNotMoveAppointments], NULL as [IsAutoRenewDisabled], NULL as [KorvueID], NULL as [SalesforceContactID], NULL as [ClientFullNameAltCalc], NULL as [ClientFullNameCalc], NULL as [ClientFullNameAlt2Calc], NULL as [ClientFullNameAlt3Calc], NULL as [AgeCalc], NULL as [IsBioGraftClient], NULL as [CurrentMDPClientMembershipGUID], NULL as [LeadCreateDate], NULL as [BosleySalesforceAccountID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_CA0B7A24
	    when 1 then __$operation
	    else
			case __$min_op_CA0B7A24
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
		null as __$update_mask , [ClientGUID], [ClientIdentifier], [ClientNumber_Temp], [CenterID], [CountryID], [SalutationID], [ContactID], [FirstName], [MiddleName], [LastName], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [ARBalance], [GenderID], [DateOfBirth], [DoNotCallFlag], [DoNotContactFlag], [IsHairModelFlag], [IsTaxExemptFlag], [EMailAddress], [TextMessageAddress], [Phone1], [Phone2], [Phone3], [Phone1TypeID], [Phone2TypeID], [Phone3TypeID], [IsPhone1PrimaryFlag], [IsPhone2PrimaryFlag], [IsPhone3PrimaryFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsHairSystemClientFlag], [TaxExemptNumber], [CurrentBioMatrixClientMembershipGUID], [CurrentSurgeryClientMembershipGUID], [CurrentExtremeTherapyClientMembershipGUID], [IsAutoConfirmTextPhone1], [IsAutoConfirmTextPhone2], [IsAutoConfirmTextPhone3], [ImportCreateDate], [ImportLastUpdate], [ClientMembershipCounter], [RequiredNoteReview], [SiebelID], [EmergencyContactPhone], [BosleyProcedureOffice], [BosleyConsultOffice], [IsAutoConfirmEmail], [IsEmailUndeliverable], [AcquiredDate], [CurrentXtrandsClientMembershipGUID], [ExpectedConversionDate], [LanguageID], [IsConfirmCallPhone1], [IsConfirmCallPhone2], [IsConfirmCallPhone3], [AnniversaryDate], [CanConfirmAppointmentByEmail], [CanContactForPromotionsByEmail], [DoNotVisitInRoom], [DoNotMoveAppointments], [IsAutoRenewDisabled], [KorvueID], [SalesforceContactID], [ClientFullNameAltCalc], [ClientFullNameCalc], [ClientFullNameAlt2Calc], [ClientFullNameAlt3Calc], [AgeCalc], [IsBioGraftClient], [CurrentMDPClientMembershipGUID], [LeadCreateDate], [BosleySalesforceAccountID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CA0B7A24
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datClient_CT] c with (nolock)
			where  ( (c.[ClientGUID] = t.[ClientGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CA0B7A24, __$count_CA0B7A24, t.[ClientGUID], t.[ClientIdentifier], t.[ClientNumber_Temp], t.[CenterID], t.[CountryID], t.[SalutationID], t.[ContactID], t.[FirstName], t.[MiddleName], t.[LastName], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[ARBalance], t.[GenderID], t.[DateOfBirth], t.[DoNotCallFlag], t.[DoNotContactFlag], t.[IsHairModelFlag], t.[IsTaxExemptFlag], t.[EMailAddress], t.[TextMessageAddress], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemClientFlag], t.[TaxExemptNumber], t.[CurrentBioMatrixClientMembershipGUID], t.[CurrentSurgeryClientMembershipGUID], t.[CurrentExtremeTherapyClientMembershipGUID], t.[IsAutoConfirmTextPhone1], t.[IsAutoConfirmTextPhone2], t.[IsAutoConfirmTextPhone3], t.[ImportCreateDate], t.[ImportLastUpdate], t.[ClientMembershipCounter], t.[RequiredNoteReview], t.[SiebelID], t.[EmergencyContactPhone], t.[BosleyProcedureOffice], t.[BosleyConsultOffice], t.[IsAutoConfirmEmail], t.[IsEmailUndeliverable], t.[AcquiredDate], t.[CurrentXtrandsClientMembershipGUID], t.[ExpectedConversionDate], t.[LanguageID], t.[IsConfirmCallPhone1], t.[IsConfirmCallPhone2], t.[IsConfirmCallPhone3], t.[AnniversaryDate], t.[CanConfirmAppointmentByEmail], t.[CanContactForPromotionsByEmail], t.[DoNotVisitInRoom], t.[DoNotMoveAppointments], t.[IsAutoRenewDisabled], t.[KorvueID], t.[SalesforceContactID], t.[ClientFullNameAltCalc], t.[ClientFullNameCalc], t.[ClientFullNameAlt2Calc], t.[ClientFullNameAlt3Calc], t.[AgeCalc], t.[IsBioGraftClient], t.[CurrentMDPClientMembershipGUID], t.[LeadCreateDate], t.[BosleySalesforceAccountID]
		from [cdc].[dbo_datClient_CT] t with (nolock) inner join
		(	select  r.[ClientGUID], max(r.__$seqval) as __$max_seqval_CA0B7A24,
		    count(*) as __$count_CA0B7A24
			from [cdc].[dbo_datClient_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientGUID]) m
		on t.__$seqval = m.__$max_seqval_CA0B7A24 and
		    ( (t.[ClientGUID] = m.[ClientGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClient_CT] c with (nolock)
							where  ( (c.[ClientGUID] = t.[ClientGUID]) )
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
	    case __$count_CA0B7A24
	    when 1 then __$operation
	    else
			case __$min_op_CA0B7A24
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
		case __$count_CA0B7A24
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_CA0B7A24
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [ClientGUID], [ClientIdentifier], [ClientNumber_Temp], [CenterID], [CountryID], [SalutationID], [ContactID], [FirstName], [MiddleName], [LastName], [Address1], [Address2], [Address3], [City], [StateID], [PostalCode], [ARBalance], [GenderID], [DateOfBirth], [DoNotCallFlag], [DoNotContactFlag], [IsHairModelFlag], [IsTaxExemptFlag], [EMailAddress], [TextMessageAddress], [Phone1], [Phone2], [Phone3], [Phone1TypeID], [Phone2TypeID], [Phone3TypeID], [IsPhone1PrimaryFlag], [IsPhone2PrimaryFlag], [IsPhone3PrimaryFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsHairSystemClientFlag], [TaxExemptNumber], [CurrentBioMatrixClientMembershipGUID], [CurrentSurgeryClientMembershipGUID], [CurrentExtremeTherapyClientMembershipGUID], [IsAutoConfirmTextPhone1], [IsAutoConfirmTextPhone2], [IsAutoConfirmTextPhone3], [ImportCreateDate], [ImportLastUpdate], [ClientMembershipCounter], [RequiredNoteReview], [SiebelID], [EmergencyContactPhone], [BosleyProcedureOffice], [BosleyConsultOffice], [IsAutoConfirmEmail], [IsEmailUndeliverable], [AcquiredDate], [CurrentXtrandsClientMembershipGUID], [ExpectedConversionDate], [LanguageID], [IsConfirmCallPhone1], [IsConfirmCallPhone2], [IsConfirmCallPhone3], [AnniversaryDate], [CanConfirmAppointmentByEmail], [CanContactForPromotionsByEmail], [DoNotVisitInRoom], [DoNotMoveAppointments], [IsAutoRenewDisabled], [KorvueID], [SalesforceContactID], [ClientFullNameAltCalc], [ClientFullNameCalc], [ClientFullNameAlt2Calc], [ClientFullNameAlt3Calc], [AgeCalc], [IsBioGraftClient], [CurrentMDPClientMembershipGUID], [LeadCreateDate], [BosleySalesforceAccountID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_CA0B7A24
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datClient_CT] c with (nolock)
			where  ( (c.[ClientGUID] = t.[ClientGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_CA0B7A24, __$count_CA0B7A24,
		m.__$update_mask , t.[ClientGUID], t.[ClientIdentifier], t.[ClientNumber_Temp], t.[CenterID], t.[CountryID], t.[SalutationID], t.[ContactID], t.[FirstName], t.[MiddleName], t.[LastName], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[ARBalance], t.[GenderID], t.[DateOfBirth], t.[DoNotCallFlag], t.[DoNotContactFlag], t.[IsHairModelFlag], t.[IsTaxExemptFlag], t.[EMailAddress], t.[TextMessageAddress], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemClientFlag], t.[TaxExemptNumber], t.[CurrentBioMatrixClientMembershipGUID], t.[CurrentSurgeryClientMembershipGUID], t.[CurrentExtremeTherapyClientMembershipGUID], t.[IsAutoConfirmTextPhone1], t.[IsAutoConfirmTextPhone2], t.[IsAutoConfirmTextPhone3], t.[ImportCreateDate], t.[ImportLastUpdate], t.[ClientMembershipCounter], t.[RequiredNoteReview], t.[SiebelID], t.[EmergencyContactPhone], t.[BosleyProcedureOffice], t.[BosleyConsultOffice], t.[IsAutoConfirmEmail], t.[IsEmailUndeliverable], t.[AcquiredDate], t.[CurrentXtrandsClientMembershipGUID], t.[ExpectedConversionDate], t.[LanguageID], t.[IsConfirmCallPhone1], t.[IsConfirmCallPhone2], t.[IsConfirmCallPhone3], t.[AnniversaryDate], t.[CanConfirmAppointmentByEmail], t.[CanContactForPromotionsByEmail], t.[DoNotVisitInRoom], t.[DoNotMoveAppointments], t.[IsAutoRenewDisabled], t.[KorvueID], t.[SalesforceContactID], t.[ClientFullNameAltCalc], t.[ClientFullNameCalc], t.[ClientFullNameAlt2Calc], t.[ClientFullNameAlt3Calc], t.[AgeCalc], t.[IsBioGraftClient], t.[CurrentMDPClientMembershipGUID], t.[LeadCreateDate], t.[BosleySalesforceAccountID]
		from [cdc].[dbo_datClient_CT] t with (nolock) inner join
		(	select  r.[ClientGUID], max(r.__$seqval) as __$max_seqval_CA0B7A24,
		    count(*) as __$count_CA0B7A24,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datClient_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientGUID]) m
		on t.__$seqval = m.__$max_seqval_CA0B7A24 and
		    ( (t.[ClientGUID] = m.[ClientGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClient_CT] c with (nolock)
							where  ( (c.[ClientGUID] = t.[ClientGUID]) )
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
		null as __$update_mask , t.[ClientGUID], t.[ClientIdentifier], t.[ClientNumber_Temp], t.[CenterID], t.[CountryID], t.[SalutationID], t.[ContactID], t.[FirstName], t.[MiddleName], t.[LastName], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[ARBalance], t.[GenderID], t.[DateOfBirth], t.[DoNotCallFlag], t.[DoNotContactFlag], t.[IsHairModelFlag], t.[IsTaxExemptFlag], t.[EMailAddress], t.[TextMessageAddress], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemClientFlag], t.[TaxExemptNumber], t.[CurrentBioMatrixClientMembershipGUID], t.[CurrentSurgeryClientMembershipGUID], t.[CurrentExtremeTherapyClientMembershipGUID], t.[IsAutoConfirmTextPhone1], t.[IsAutoConfirmTextPhone2], t.[IsAutoConfirmTextPhone3], t.[ImportCreateDate], t.[ImportLastUpdate], t.[ClientMembershipCounter], t.[RequiredNoteReview], t.[SiebelID], t.[EmergencyContactPhone], t.[BosleyProcedureOffice], t.[BosleyConsultOffice], t.[IsAutoConfirmEmail], t.[IsEmailUndeliverable], t.[AcquiredDate], t.[CurrentXtrandsClientMembershipGUID], t.[ExpectedConversionDate], t.[LanguageID], t.[IsConfirmCallPhone1], t.[IsConfirmCallPhone2], t.[IsConfirmCallPhone3], t.[AnniversaryDate], t.[CanConfirmAppointmentByEmail], t.[CanContactForPromotionsByEmail], t.[DoNotVisitInRoom], t.[DoNotMoveAppointments], t.[IsAutoRenewDisabled], t.[KorvueID], t.[SalesforceContactID], t.[ClientFullNameAltCalc], t.[ClientFullNameCalc], t.[ClientFullNameAlt2Calc], t.[ClientFullNameAlt3Calc], t.[AgeCalc], t.[IsBioGraftClient], t.[CurrentMDPClientMembershipGUID], t.[LeadCreateDate], t.[BosleySalesforceAccountID]
		from [cdc].[dbo_datClient_CT] t  with (nolock) inner join
		(	select  r.[ClientGUID], max(r.__$seqval) as __$max_seqval_CA0B7A24
			from [cdc].[dbo_datClient_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[ClientGUID]) m
		on t.__$seqval = m.__$max_seqval_CA0B7A24 and
		    ( (t.[ClientGUID] = m.[ClientGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datClient_CT] c with (nolock)
							where  ( (c.[ClientGUID] = t.[ClientGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
