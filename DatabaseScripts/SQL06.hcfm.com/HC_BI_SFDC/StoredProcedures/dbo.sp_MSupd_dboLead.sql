/* CreateDate: 04/23/2021 08:07:54.373 , ModifyDate: 04/23/2021 08:07:54.373 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboLead]     @c1 nvarchar(18) = NULL,     @c2 nchar(10) = NULL,     @c3 nvarchar(50) = NULL,     @c4 nvarchar(50) = NULL,     @c5 nvarchar(50) = NULL,     @c6 nvarchar(80) = NULL,     @c7 int = NULL,     @c8 nvarchar(50) = NULL,     @c9 datetime = NULL,     @c10 nvarchar(50) = NULL,     @c11 nvarchar(50) = NULL,     @c12 nvarchar(50) = NULL,     @c13 nvarchar(50) = NULL,     @c14 nvarchar(250) = NULL,     @c15 nvarchar(50) = NULL,     @c16 nvarchar(50) = NULL,     @c17 nvarchar(50) = NULL,     @c18 nvarchar(250) = NULL,     @c19 nvarchar(100) = NULL,     @c20 nvarchar(100) = NULL,     @c21 nvarchar(150) = NULL,     @c22 nvarchar(100) = NULL,     @c23 nvarchar(100) = NULL,     @c24 nvarchar(18) = NULL,     @c25 nvarchar(18) = NULL,     @c26 nvarchar(50) = NULL,     @c27 nvarchar(50) = NULL,     @c28 bit = NULL,     @c29 bit = NULL,     @c30 bit = NULL,     @c31 bit = NULL,     @c32 bit = NULL,     @c33 nvarchar(50) = NULL,     @c34 nvarchar(4000) = NULL,     @c35 nvarchar(150) = NULL,     @c36 bit = NULL,     @c37 nvarchar(50) = NULL,     @c38 nvarchar(50) = NULL,     @c39 bit = NULL,     @c40 datetime = NULL,     @c41 datetime = NULL,     @c42 nvarchar(18) = NULL,     @c43 datetime = NULL,     @c44 nvarchar(18) = NULL,     @c45 datetime = NULL,     @c46 nvarchar(50) = NULL,     @c47 datetime = NULL,     @c48 bit = NULL,     @c49 nvarchar(50) = NULL,     @c50 nvarchar(50) = NULL,     @c51 nvarchar(255) = NULL,     @c52 nvarchar(50) = NULL,     @c53 nvarchar(80) = NULL,     @c54 nvarchar(50) = NULL,     @c55 nvarchar(80) = NULL,     @c56 nvarchar(50) = NULL,     @c57 nvarchar(20) = NULL,     @c58 ntext = NULL,     @c59 nvarchar(18) = NULL,     @c60 nvarchar(18) = NULL,     @c61 nvarchar(18) = NULL,     @c62 nvarchar(50) = NULL,     @c63 nvarchar(80) = NULL,     @c64 nvarchar(105) = NULL,     @c65 nvarchar(80) = NULL,     @c66 nvarchar(80) = NULL,     @c67 nvarchar(50) = NULL,     @pkc1 nvarchar(18) = NULL,     @bitmap binary(9)
as
begin   if (substring(@bitmap,1,1) & 1 = 1)
begin  update [dbo].[Lead] set     [Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,     [ContactID__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactID__c] end,     [CenterNumber__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterNumber__c] end,     [CenterID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID__c] end,     [FirstName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FirstName] end,     [LastName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastName] end,     [Age__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Age__c] end,     [AgeRange__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AgeRange__c] end,     [Birthday__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Birthday__c] end,     [Gender__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Gender__c] end,     [Language__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Language__c] end,     [Ethnicity__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Ethnicity__c] end,     [MaritalStatus__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MaritalStatus__c] end,     [Occupation__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Occupation__c] end,     [DISC__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [DISC__c] end,     [NorwoodScale__c] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [NorwoodScale__c] end,     [LudwigScale__c] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LudwigScale__c] end,     [SolutionOffered__c] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SolutionOffered__c] end,     [HairLossExperience__c] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [HairLossExperience__c] end,     [HairLossFamily__c] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [HairLossFamily__c] end,     [HairLossProductOther__c] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [HairLossProductOther__c] end,     [HairLossProductUsed__c] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [HairLossProductUsed__c] end,     [HairLossSpot__c] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [HairLossSpot__c] end,     [OriginalCampaignID__c] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [OriginalCampaignID__c] end,     [RecentCampaignID__c] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RecentCampaignID__c] end,     [Source_Code_Legacy__c] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Source_Code_Legacy__c] end,     [Promo_Code_Legacy__c] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [Promo_Code_Legacy__c] end,     [DoNotContact__c] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [DoNotContact__c] end,     [DoNotCall] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [DoNotCall] end,     [DoNotEmail__c] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [DoNotEmail__c] end,     [DoNotMail__c] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [DoNotMail__c] end,     [DoNotText__c] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [DoNotText__c] end,     [SiebelID__c] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [SiebelID__c] end,     [GCLID__c] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [GCLID__c] end,     [OnCAffiliateID__c] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [OnCAffiliateID__c] end,     [IsConverted] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [IsConverted] end,     [ContactStatus__c] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [ContactStatus__c] end,     [Status] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [Status] end,     [IsDeleted] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [IsDeleted] end,     [OnCtCreatedDate__c] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [OnCtCreatedDate__c] end,     [ReportCreateDate__c] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [ReportCreateDate__c] end,     [CreatedById] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [CreatedById] end,     [CreatedDate] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [CreatedDate] end,     [LastModifiedById] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [LastModifiedById] end,     [LastModifiedDate] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [LastModifiedDate] end,     [ReferralCode__c] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [ReferralCode__c] end,     [ReferralCodeExpireDate__c] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [ReferralCodeExpireDate__c] end,     [HardCopyPreferred__c] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [HardCopyPreferred__c] end,     [RecentSourceCode__c] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [RecentSourceCode__c] end,     [ZipCode__c] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [ZipCode__c] end,     [Street] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [Street] end,     [City] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [City] end,     [State] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [State] end,     [StateCode] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [StateCode] end,     [Country] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [Country] end,     [CountryCode] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [CountryCode] end,     [PostalCode] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [PostalCode] end,     [HTTPReferrer__c] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [HTTPReferrer__c] end,     [ConvertedAccountId] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [ConvertedAccountId] end,     [ConvertedContactId] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [ConvertedContactId] end,     [ConvertedOpportunityId] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [ConvertedOpportunityId] end,     [Lead_Activity_Status__c] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [Lead_Activity_Status__c] end,     [LeadSource] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [LeadSource] end,     [Email] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [Email] end,     [Phone] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [Phone] end,     [MobilePhone] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [MobilePhone] end,     [BosleySFID__c] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [BosleySFID__c] end
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end   else
begin  update [dbo].[Lead] set     [ContactID__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactID__c] end,     [CenterNumber__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterNumber__c] end,     [CenterID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterID__c] end,     [FirstName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FirstName] end,     [LastName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastName] end,     [Age__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Age__c] end,     [AgeRange__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AgeRange__c] end,     [Birthday__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Birthday__c] end,     [Gender__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Gender__c] end,     [Language__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Language__c] end,     [Ethnicity__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Ethnicity__c] end,     [MaritalStatus__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MaritalStatus__c] end,     [Occupation__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Occupation__c] end,     [DISC__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [DISC__c] end,     [NorwoodScale__c] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [NorwoodScale__c] end,     [LudwigScale__c] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LudwigScale__c] end,     [SolutionOffered__c] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SolutionOffered__c] end,     [HairLossExperience__c] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [HairLossExperience__c] end,     [HairLossFamily__c] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [HairLossFamily__c] end,     [HairLossProductOther__c] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [HairLossProductOther__c] end,     [HairLossProductUsed__c] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [HairLossProductUsed__c] end,     [HairLossSpot__c] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [HairLossSpot__c] end,     [OriginalCampaignID__c] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [OriginalCampaignID__c] end,     [RecentCampaignID__c] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RecentCampaignID__c] end,     [Source_Code_Legacy__c] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Source_Code_Legacy__c] end,     [Promo_Code_Legacy__c] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [Promo_Code_Legacy__c] end,     [DoNotContact__c] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [DoNotContact__c] end,     [DoNotCall] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [DoNotCall] end,     [DoNotEmail__c] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [DoNotEmail__c] end,     [DoNotMail__c] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [DoNotMail__c] end,     [DoNotText__c] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [DoNotText__c] end,     [SiebelID__c] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [SiebelID__c] end,     [GCLID__c] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [GCLID__c] end,     [OnCAffiliateID__c] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [OnCAffiliateID__c] end,     [IsConverted] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [IsConverted] end,     [ContactStatus__c] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [ContactStatus__c] end,     [Status] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [Status] end,     [IsDeleted] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [IsDeleted] end,     [OnCtCreatedDate__c] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [OnCtCreatedDate__c] end,     [ReportCreateDate__c] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [ReportCreateDate__c] end,     [CreatedById] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [CreatedById] end,     [CreatedDate] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [CreatedDate] end,     [LastModifiedById] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [LastModifiedById] end,     [LastModifiedDate] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [LastModifiedDate] end,     [ReferralCode__c] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [ReferralCode__c] end,     [ReferralCodeExpireDate__c] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [ReferralCodeExpireDate__c] end,     [HardCopyPreferred__c] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [HardCopyPreferred__c] end,     [RecentSourceCode__c] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [RecentSourceCode__c] end,     [ZipCode__c] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [ZipCode__c] end,     [Street] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [Street] end,     [City] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [City] end,     [State] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [State] end,     [StateCode] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [StateCode] end,     [Country] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [Country] end,     [CountryCode] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [CountryCode] end,     [PostalCode] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [PostalCode] end,     [HTTPReferrer__c] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [HTTPReferrer__c] end,     [ConvertedAccountId] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [ConvertedAccountId] end,     [ConvertedContactId] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [ConvertedContactId] end,     [ConvertedOpportunityId] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [ConvertedOpportunityId] end,     [Lead_Activity_Status__c] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [Lead_Activity_Status__c] end,     [LeadSource] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [LeadSource] end,     [Email] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [Email] end,     [Phone] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [Phone] end,     [MobilePhone] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [MobilePhone] end,     [BosleySFID__c] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [BosleySFID__c] end
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end  end   --
GO
