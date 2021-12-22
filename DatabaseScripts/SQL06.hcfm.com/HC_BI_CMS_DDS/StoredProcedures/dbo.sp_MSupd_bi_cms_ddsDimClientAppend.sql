/* CreateDate: 01/02/2017 09:06:12.367 , ModifyDate: 01/02/2017 09:06:12.367 */
GO
create procedure [dbo].[sp_MSupd_bi_cms_ddsDimClientAppend]     @c1 int = NULL,     @c2 int = NULL,     @c3 uniqueidentifier = NULL,     @c4 int = NULL,     @c5 int = NULL,     @c6 int = NULL,     @c7 int = NULL,     @c8 nvarchar(10) = NULL,     @c9 nvarchar(50) = NULL,     @c10 nvarchar(10) = NULL,     @c11 nvarchar(50) = NULL,     @c12 nvarchar(10) = NULL,     @c13 nvarchar(50) = NULL,     @c14 nvarchar(10) = NULL,     @c15 nvarchar(50) = NULL,     @c16 int = NULL,     @c17 nvarchar(10) = NULL,     @c18 nvarchar(10) = NULL,     @c19 nvarchar(10) = NULL,     @c20 nvarchar(10) = NULL,     @c21 nvarchar(10) = NULL,     @c22 nvarchar(50) = NULL,     @c23 nvarchar(10) = NULL,     @c24 nvarchar(10) = NULL,     @c25 nvarchar(10) = NULL,     @c26 nvarchar(10) = NULL,     @c27 nvarchar(10) = NULL,     @c28 nvarchar(10) = NULL,     @c29 nvarchar(10) = NULL,     @c30 nvarchar(10) = NULL,     @c31 nvarchar(10) = NULL,     @c32 nvarchar(10) = NULL,     @c33 nvarchar(10) = NULL,     @c34 nvarchar(10) = NULL,     @c35 nvarchar(10) = NULL,     @c36 nvarchar(10) = NULL,     @c37 varchar(50) = NULL,     @c38 varchar(50) = NULL,     @pkc1 int = NULL,     @bitmap binary(5)
as
begin   if (substring(@bitmap,1,1) & 1 = 1)
begin  update [bi_cms_dds].[DimClientAppend] set     [ClientAppendKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientAppendKey] end,     [ClientKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientKey] end,     [ClientSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientSSID] end,     [ClientNumber_Temp] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientNumber_Temp] end,     [ClientIdentifier] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientIdentifier] end,     [CenterKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterKey] end,     [CenterSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterSSID] end,     [HouseholdMosaicGroupID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HouseholdMosaicGroupID] end,     [HouseholdMosaicGroup] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HouseholdMosaicGroup] end,     [HouseholdMosaicTypeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HouseholdMosaicTypeID] end,     [HouseholdMosaicType] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HouseholdMosaicType] end,     [ZipCodeMosaicGroupID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ZipCodeMosaicGroupID] end,     [ZipCodeMosaicGroup] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ZipCodeMosaicGroup] end,     [ZipCodeMosaicTypeID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ZipCodeMosaicTypeID] end,     [ZipCodeMosaicType] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ZipCodeMosaicType] end,     [ContactKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ContactKey] end,     [Combined_Age] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Combined_Age] end,     [Education_Model] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Education_Model] end,     [Occupation_Group] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Occupation_Group] end,     [Match_Level_for_GEOData] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Match_Level_for_GEOData] end,     [Latitude] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Latitude] end,     [Est_HouseHold_Income] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Est_HouseHold_Income] end,     [NCOA_Move_Update_Code] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [NCOA_Move_Update_Code] end,     [Mail_Responder] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Mail_Responder] end,     [MOR_Bank_Upscale_Merchandise_Buyer] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MOR_Bank_Upscale_Merchandise_Buyer] end,     [MOR_Bank_HealthandFitness_Magazine] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [MOR_Bank_HealthandFitness_Magazine] end,     [CAPE_Ethnic_Pop_White_Only] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CAPE_Ethnic_Pop_White_Only] end,     [CAPE_Ethnic_Pop_Black_Only] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CAPE_Ethnic_Pop_Black_Only] end,     [CAPE_Ethnic_Pop_Asian_Only] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [CAPE_Ethnic_Pop_Asian_Only] end,     [CAPE_Ethnic_Pop_Hispanic] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CAPE_Ethnic_Pop_Hispanic] end,     [CAPE_Lang_HH_Spanish_Speaking] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CAPE_Lang_HH_Spanish_Speaking] end,     [CAPE_Income_HH_Median_Family] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CAPE_Income_HH_Median_Family] end,     [MatchStatus] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [MatchStatus] end,     [CE_Selected_Individual_Vendor_Ethnicity_Code] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [CE_Selected_Individual_Vendor_Ethnicity_Code] end,     [CE_Selected_Individual_Vendor_Ethnic_Group_Code] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [CE_Selected_Individual_Vendor_Ethnic_Group_Code] end,     [CE_Selected_Individual_Vendor_Spoken_Language_Code] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [CE_Selected_Individual_Vendor_Spoken_Language_Code] end,     [LeadMatchStatus] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [LeadMatchStatus] end,     [LeadScore] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [LeadScore] end
where [ClientAppendKey] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end   else
begin  update [bi_cms_dds].[DimClientAppend] set     [ClientKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientKey] end,     [ClientSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientSSID] end,     [ClientNumber_Temp] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientNumber_Temp] end,     [ClientIdentifier] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientIdentifier] end,     [CenterKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterKey] end,     [CenterSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterSSID] end,     [HouseholdMosaicGroupID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HouseholdMosaicGroupID] end,     [HouseholdMosaicGroup] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HouseholdMosaicGroup] end,     [HouseholdMosaicTypeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HouseholdMosaicTypeID] end,     [HouseholdMosaicType] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HouseholdMosaicType] end,     [ZipCodeMosaicGroupID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ZipCodeMosaicGroupID] end,     [ZipCodeMosaicGroup] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ZipCodeMosaicGroup] end,     [ZipCodeMosaicTypeID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ZipCodeMosaicTypeID] end,     [ZipCodeMosaicType] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ZipCodeMosaicType] end,     [ContactKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ContactKey] end,     [Combined_Age] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Combined_Age] end,     [Education_Model] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Education_Model] end,     [Occupation_Group] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Occupation_Group] end,     [Match_Level_for_GEOData] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Match_Level_for_GEOData] end,     [Latitude] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Latitude] end,     [Est_HouseHold_Income] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Est_HouseHold_Income] end,     [NCOA_Move_Update_Code] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [NCOA_Move_Update_Code] end,     [Mail_Responder] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Mail_Responder] end,     [MOR_Bank_Upscale_Merchandise_Buyer] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MOR_Bank_Upscale_Merchandise_Buyer] end,     [MOR_Bank_HealthandFitness_Magazine] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [MOR_Bank_HealthandFitness_Magazine] end,     [CAPE_Ethnic_Pop_White_Only] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CAPE_Ethnic_Pop_White_Only] end,     [CAPE_Ethnic_Pop_Black_Only] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CAPE_Ethnic_Pop_Black_Only] end,     [CAPE_Ethnic_Pop_Asian_Only] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [CAPE_Ethnic_Pop_Asian_Only] end,     [CAPE_Ethnic_Pop_Hispanic] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CAPE_Ethnic_Pop_Hispanic] end,     [CAPE_Lang_HH_Spanish_Speaking] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CAPE_Lang_HH_Spanish_Speaking] end,     [CAPE_Income_HH_Median_Family] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CAPE_Income_HH_Median_Family] end,     [MatchStatus] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [MatchStatus] end,     [CE_Selected_Individual_Vendor_Ethnicity_Code] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [CE_Selected_Individual_Vendor_Ethnicity_Code] end,     [CE_Selected_Individual_Vendor_Ethnic_Group_Code] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [CE_Selected_Individual_Vendor_Ethnic_Group_Code] end,     [CE_Selected_Individual_Vendor_Spoken_Language_Code] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [CE_Selected_Individual_Vendor_Spoken_Language_Code] end,     [LeadMatchStatus] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [LeadMatchStatus] end,     [LeadScore] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [LeadScore] end
where [ClientAppendKey] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end  end   --
GO
