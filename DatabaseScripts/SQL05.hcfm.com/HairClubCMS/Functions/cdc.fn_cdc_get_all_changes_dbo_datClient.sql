/* CreateDate: 05/05/2020 18:40:59.450 , ModifyDate: 05/05/2020 18:40:59.450 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datClient]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ClientGUID], NULL as [ClientIdentifier], NULL as [ClientNumber_Temp], NULL as [CenterID], NULL as [CountryID], NULL as [SalutationID], NULL as [ContactID], NULL as [FirstName], NULL as [MiddleName], NULL as [LastName], NULL as [Address1], NULL as [Address2], NULL as [Address3], NULL as [City], NULL as [StateID], NULL as [PostalCode], NULL as [ARBalance], NULL as [GenderID], NULL as [DateOfBirth], NULL as [DoNotCallFlag], NULL as [DoNotContactFlag], NULL as [IsHairModelFlag], NULL as [IsTaxExemptFlag], NULL as [EMailAddress], NULL as [TextMessageAddress], NULL as [Phone1], NULL as [Phone2], NULL as [Phone3], NULL as [Phone1TypeID], NULL as [Phone2TypeID], NULL as [Phone3TypeID], NULL as [IsPhone1PrimaryFlag], NULL as [IsPhone2PrimaryFlag], NULL as [IsPhone3PrimaryFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsHairSystemClientFlag], NULL as [TaxExemptNumber], NULL as [CurrentBioMatrixClientMembershipGUID], NULL as [CurrentSurgeryClientMembershipGUID], NULL as [CurrentExtremeTherapyClientMembershipGUID], NULL as [IsAutoConfirmTextPhone1], NULL as [IsAutoConfirmTextPhone2], NULL as [IsAutoConfirmTextPhone3], NULL as [ImportCreateDate], NULL as [ImportLastUpdate], NULL as [ClientMembershipCounter], NULL as [RequiredNoteReview], NULL as [SiebelID], NULL as [EmergencyContactPhone], NULL as [BosleyProcedureOffice], NULL as [BosleyConsultOffice], NULL as [IsAutoConfirmEmail], NULL as [IsEmailUndeliverable], NULL as [AcquiredDate], NULL as [CurrentXtrandsClientMembershipGUID], NULL as [ExpectedConversionDate], NULL as [LanguageID], NULL as [IsConfirmCallPhone1], NULL as [IsConfirmCallPhone2], NULL as [IsConfirmCallPhone3], NULL as [AnniversaryDate], NULL as [CanConfirmAppointmentByEmail], NULL as [CanContactForPromotionsByEmail], NULL as [DoNotVisitInRoom], NULL as [DoNotMoveAppointments], NULL as [IsAutoRenewDisabled], NULL as [KorvueID], NULL as [SalesforceContactID], NULL as [ClientFullNameAltCalc], NULL as [ClientFullNameCalc], NULL as [ClientFullNameAlt2Calc], NULL as [ClientFullNameAlt3Calc], NULL as [AgeCalc], NULL as [IsBioGraftClient], NULL as [CurrentMDPClientMembershipGUID], NULL as [LeadCreateDate], NULL as [BosleySalesforceAccountID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientGUID], t.[ClientIdentifier], t.[ClientNumber_Temp], t.[CenterID], t.[CountryID], t.[SalutationID], t.[ContactID], t.[FirstName], t.[MiddleName], t.[LastName], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[ARBalance], t.[GenderID], t.[DateOfBirth], t.[DoNotCallFlag], t.[DoNotContactFlag], t.[IsHairModelFlag], t.[IsTaxExemptFlag], t.[EMailAddress], t.[TextMessageAddress], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemClientFlag], t.[TaxExemptNumber], t.[CurrentBioMatrixClientMembershipGUID], t.[CurrentSurgeryClientMembershipGUID], t.[CurrentExtremeTherapyClientMembershipGUID], t.[IsAutoConfirmTextPhone1], t.[IsAutoConfirmTextPhone2], t.[IsAutoConfirmTextPhone3], t.[ImportCreateDate], t.[ImportLastUpdate], t.[ClientMembershipCounter], t.[RequiredNoteReview], t.[SiebelID], t.[EmergencyContactPhone], t.[BosleyProcedureOffice], t.[BosleyConsultOffice], t.[IsAutoConfirmEmail], t.[IsEmailUndeliverable], t.[AcquiredDate], t.[CurrentXtrandsClientMembershipGUID], t.[ExpectedConversionDate], t.[LanguageID], t.[IsConfirmCallPhone1], t.[IsConfirmCallPhone2], t.[IsConfirmCallPhone3], t.[AnniversaryDate], t.[CanConfirmAppointmentByEmail], t.[CanContactForPromotionsByEmail], t.[DoNotVisitInRoom], t.[DoNotMoveAppointments], t.[IsAutoRenewDisabled], t.[KorvueID], t.[SalesforceContactID], t.[ClientFullNameAltCalc], t.[ClientFullNameCalc], t.[ClientFullNameAlt2Calc], t.[ClientFullNameAlt3Calc], t.[AgeCalc], t.[IsBioGraftClient], t.[CurrentMDPClientMembershipGUID], t.[LeadCreateDate], t.[BosleySalesforceAccountID]
	from [cdc].[dbo_datClient_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ClientGUID], t.[ClientIdentifier], t.[ClientNumber_Temp], t.[CenterID], t.[CountryID], t.[SalutationID], t.[ContactID], t.[FirstName], t.[MiddleName], t.[LastName], t.[Address1], t.[Address2], t.[Address3], t.[City], t.[StateID], t.[PostalCode], t.[ARBalance], t.[GenderID], t.[DateOfBirth], t.[DoNotCallFlag], t.[DoNotContactFlag], t.[IsHairModelFlag], t.[IsTaxExemptFlag], t.[EMailAddress], t.[TextMessageAddress], t.[Phone1], t.[Phone2], t.[Phone3], t.[Phone1TypeID], t.[Phone2TypeID], t.[Phone3TypeID], t.[IsPhone1PrimaryFlag], t.[IsPhone2PrimaryFlag], t.[IsPhone3PrimaryFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsHairSystemClientFlag], t.[TaxExemptNumber], t.[CurrentBioMatrixClientMembershipGUID], t.[CurrentSurgeryClientMembershipGUID], t.[CurrentExtremeTherapyClientMembershipGUID], t.[IsAutoConfirmTextPhone1], t.[IsAutoConfirmTextPhone2], t.[IsAutoConfirmTextPhone3], t.[ImportCreateDate], t.[ImportLastUpdate], t.[ClientMembershipCounter], t.[RequiredNoteReview], t.[SiebelID], t.[EmergencyContactPhone], t.[BosleyProcedureOffice], t.[BosleyConsultOffice], t.[IsAutoConfirmEmail], t.[IsEmailUndeliverable], t.[AcquiredDate], t.[CurrentXtrandsClientMembershipGUID], t.[ExpectedConversionDate], t.[LanguageID], t.[IsConfirmCallPhone1], t.[IsConfirmCallPhone2], t.[IsConfirmCallPhone3], t.[AnniversaryDate], t.[CanConfirmAppointmentByEmail], t.[CanContactForPromotionsByEmail], t.[DoNotVisitInRoom], t.[DoNotMoveAppointments], t.[IsAutoRenewDisabled], t.[KorvueID], t.[SalesforceContactID], t.[ClientFullNameAltCalc], t.[ClientFullNameCalc], t.[ClientFullNameAlt2Calc], t.[ClientFullNameAlt3Calc], t.[AgeCalc], t.[IsBioGraftClient], t.[CurrentMDPClientMembershipGUID], t.[LeadCreateDate], t.[BosleySalesforceAccountID]
	from [cdc].[dbo_datClient_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datClient', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
