create procedure [dbo].[sp_MSupd_bi_mktg_ddsDimContactAppend]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 nvarchar(10) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(10) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(10) = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 nvarchar(10) = NULL,
		@c15 nvarchar(10) = NULL,
		@c16 nvarchar(10) = NULL,
		@c17 nvarchar(10) = NULL,
		@c18 nvarchar(50) = NULL,
		@c19 nvarchar(10) = NULL,
		@c20 nvarchar(10) = NULL,
		@c21 nvarchar(10) = NULL,
		@c22 nvarchar(10) = NULL,
		@c23 nvarchar(10) = NULL,
		@c24 nvarchar(10) = NULL,
		@c25 nvarchar(10) = NULL,
		@c26 nvarchar(10) = NULL,
		@c27 nvarchar(10) = NULL,
		@c28 nvarchar(10) = NULL,
		@c29 nvarchar(10) = NULL,
		@c30 nvarchar(10) = NULL,
		@c31 nvarchar(10) = NULL,
		@c32 nvarchar(10) = NULL,
		@c33 varchar(50) = NULL,
		@c34 varchar(50) = NULL,
		@c35 varchar(50) = NULL,
		@c36 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[DimContactAppend] set
		[ContactAppendKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ContactAppendKey] end,
		[ContactKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactKey] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactSSID] end,
		[CenterKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterKey] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CenterSSID] end,
		[HouseholdMosaicGroupID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HouseholdMosaicGroupID] end,
		[HouseholdMosaicGroup] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HouseholdMosaicGroup] end,
		[HouseholdMosaicTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HouseholdMosaicTypeID] end,
		[HouseholdMosaicType] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HouseholdMosaicType] end,
		[ZipCodeMosaicGroupID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ZipCodeMosaicGroupID] end,
		[ZipCodeMosaicGroup] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ZipCodeMosaicGroup] end,
		[ZipCodeMosaicTypeID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ZipCodeMosaicTypeID] end,
		[ZipCodeMosaicType] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ZipCodeMosaicType] end,
		[Combined_Age] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Combined_Age] end,
		[Education_Model] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Education_Model] end,
		[Occupation_Group] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Occupation_Group] end,
		[Match_Level_for_GEOData] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Match_Level_for_GEOData] end,
		[Est_HouseHold_Income] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Est_HouseHold_Income] end,
		[NCOA_Move_Update_Code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [NCOA_Move_Update_Code] end,
		[Mail_Responder] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Mail_Responder] end,
		[MOR_Bank_Upscale_Merchandise_Buyer] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [MOR_Bank_Upscale_Merchandise_Buyer] end,
		[MOR_Bank_HealthandFitness_Magazine] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [MOR_Bank_HealthandFitness_Magazine] end,
		[CAPE_Ethnic_Pop_White_Only] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CAPE_Ethnic_Pop_White_Only] end,
		[CAPE_Ethnic_Pop_Black_Only] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CAPE_Ethnic_Pop_Black_Only] end,
		[CAPE_Ethnic_Pop_Asian_Only] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CAPE_Ethnic_Pop_Asian_Only] end,
		[CAPE_Ethnic_Pop_Hispanic] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [CAPE_Ethnic_Pop_Hispanic] end,
		[CAPE_Lang_HH_Spanish_Speaking] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CAPE_Lang_HH_Spanish_Speaking] end,
		[CAPE_Income_HH_Median_Family] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CAPE_Income_HH_Median_Family] end,
		[MatchStatus] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [MatchStatus] end,
		[CE_Selected_Individual_Vendor_Ethnicity_Code] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CE_Selected_Individual_Vendor_Ethnicity_Code] end,
		[CE_Selected_Individual_Vendor_Ethnic_Group_Code] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CE_Selected_Individual_Vendor_Ethnic_Group_Code] end,
		[CE_Selected_Individual_Vendor_Spoken_Language_Code] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CE_Selected_Individual_Vendor_Spoken_Language_Code] end,
		[Latitude] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Latitude] end,
		[Longitude] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Longitude] end,
		[LeadMatchStatus] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [LeadMatchStatus] end,
		[LeadScore] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [LeadScore] end
	where [ContactAppendKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactAppendKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimContactAppend]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[DimContactAppend] set
		[ContactKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactKey] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactSSID] end,
		[CenterKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterKey] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CenterSSID] end,
		[HouseholdMosaicGroupID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HouseholdMosaicGroupID] end,
		[HouseholdMosaicGroup] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HouseholdMosaicGroup] end,
		[HouseholdMosaicTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HouseholdMosaicTypeID] end,
		[HouseholdMosaicType] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HouseholdMosaicType] end,
		[ZipCodeMosaicGroupID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ZipCodeMosaicGroupID] end,
		[ZipCodeMosaicGroup] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ZipCodeMosaicGroup] end,
		[ZipCodeMosaicTypeID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ZipCodeMosaicTypeID] end,
		[ZipCodeMosaicType] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ZipCodeMosaicType] end,
		[Combined_Age] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Combined_Age] end,
		[Education_Model] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Education_Model] end,
		[Occupation_Group] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Occupation_Group] end,
		[Match_Level_for_GEOData] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Match_Level_for_GEOData] end,
		[Est_HouseHold_Income] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Est_HouseHold_Income] end,
		[NCOA_Move_Update_Code] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [NCOA_Move_Update_Code] end,
		[Mail_Responder] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Mail_Responder] end,
		[MOR_Bank_Upscale_Merchandise_Buyer] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [MOR_Bank_Upscale_Merchandise_Buyer] end,
		[MOR_Bank_HealthandFitness_Magazine] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [MOR_Bank_HealthandFitness_Magazine] end,
		[CAPE_Ethnic_Pop_White_Only] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CAPE_Ethnic_Pop_White_Only] end,
		[CAPE_Ethnic_Pop_Black_Only] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CAPE_Ethnic_Pop_Black_Only] end,
		[CAPE_Ethnic_Pop_Asian_Only] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CAPE_Ethnic_Pop_Asian_Only] end,
		[CAPE_Ethnic_Pop_Hispanic] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [CAPE_Ethnic_Pop_Hispanic] end,
		[CAPE_Lang_HH_Spanish_Speaking] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CAPE_Lang_HH_Spanish_Speaking] end,
		[CAPE_Income_HH_Median_Family] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CAPE_Income_HH_Median_Family] end,
		[MatchStatus] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [MatchStatus] end,
		[CE_Selected_Individual_Vendor_Ethnicity_Code] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CE_Selected_Individual_Vendor_Ethnicity_Code] end,
		[CE_Selected_Individual_Vendor_Ethnic_Group_Code] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CE_Selected_Individual_Vendor_Ethnic_Group_Code] end,
		[CE_Selected_Individual_Vendor_Spoken_Language_Code] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CE_Selected_Individual_Vendor_Spoken_Language_Code] end,
		[Latitude] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Latitude] end,
		[Longitude] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Longitude] end,
		[LeadMatchStatus] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [LeadMatchStatus] end,
		[LeadScore] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [LeadScore] end
	where [ContactAppendKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactAppendKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimContactAppend]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
