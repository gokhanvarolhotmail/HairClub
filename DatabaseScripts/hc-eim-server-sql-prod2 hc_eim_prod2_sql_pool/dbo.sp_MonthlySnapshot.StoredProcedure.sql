/****** Object:  StoredProcedure [dbo].[sp_MonthlySnapshot]    Script Date: 3/1/2022 8:53:37 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开䴀漀渀琀栀氀礀匀渀愀瀀猀栀漀琀崀 䄀匀ഀഀ
INSERT INTO [dbo].[FactLeadTracking]( [LeadKey]਍                                    Ⰰ 嬀䰀攀愀搀䤀搀崀ഀഀ
                                    , [LeadFirstName]਍                                    Ⰰ 嬀䰀攀愀搀䰀愀猀琀渀愀洀攀崀ഀഀ
                                    , [LeadFullName]਍                                    Ⰰ 嬀䰀攀愀搀䈀椀爀琀栀搀愀礀崀ഀഀ
                                    , [LeadAddress]਍                                    Ⰰ 嬀䤀猀䄀挀琀椀瘀攀崀ഀഀ
                                    , [IsConsultFormComplete]਍                                    Ⰰ 嬀䤀猀瘀愀氀椀搀崀ഀഀ
                                    , [LeadEmail]਍                                    Ⰰ 嬀䰀攀愀搀倀栀漀渀攀崀ഀഀ
                                    , [LeadMobilePhone]਍                                    Ⰰ 嬀一漀爀眀漀漀搀匀挀愀氀攀崀ഀഀ
                                    , [LudwigScale]਍                                    Ⰰ 嬀䠀愀椀爀䰀漀猀猀䤀渀䘀愀洀椀氀礀崀ഀഀ
                                    , [HairLossProductUsed]਍                                    Ⰰ 嬀䠀愀椀爀䰀漀猀猀匀瀀漀琀崀ഀഀ
                                    , [GeographyKey]਍                                    Ⰰ 嬀䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
                                    , [EthnicityKey]਍                                    Ⰰ 嬀䰀攀愀搀䔀琀栀渀椀挀椀琀礀崀ഀഀ
                                    , [GenderKey]਍                                    Ⰰ 嬀䰀攀愀搀䜀攀渀搀攀爀崀ഀഀ
                                    , [CenterKey]਍                                    Ⰰ 嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
                                    , [LanguageKey]਍                                    Ⰰ 嬀䰀攀愀搀䰀愀渀最甀愀最攀崀ഀഀ
                                    , [StatusKey]਍                                    Ⰰ 嬀䰀攀愀搀匀琀愀琀甀猀崀ഀഀ
                                    , [LeadCreatedDate]਍                                    Ⰰ 嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀ഀഀ
                                    , [CreatedTimeKey]਍                                    Ⰰ 嬀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀ഀഀ
                                    , [LastActivityDateKey]਍                                    Ⰰ 嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀吀椀洀攀欀攀礀崀ഀഀ
                                    , [DISCStyle]਍                                    Ⰰ 嬀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀ഀഀ
                                    , [LeadConsultReady]਍                                    Ⰰ 嬀䌀漀渀猀甀氀琀愀琀椀漀渀䘀漀爀洀刀攀愀搀礀崀ഀഀ
                                    , [IsDeleted]਍                                    Ⰰ 嬀䐀漀一漀琀䌀愀氀氀崀ഀഀ
                                    , [DoNotContact]਍                                    Ⰰ 嬀䐀漀一漀琀䔀洀愀椀氀崀ഀഀ
                                    , [DoNotMail]਍                                    Ⰰ 嬀䐀漀一漀琀吀攀砀琀崀ഀഀ
                                    , [CreateUser]਍                                    Ⰰ 嬀唀瀀搀愀琀攀唀猀攀爀崀ഀഀ
                                    , [City]਍                                    Ⰰ 嬀匀琀愀琀攀崀ഀഀ
                                    , [MaritalStatusKey]਍                                    Ⰰ 嬀䰀攀愀搀匀漀甀爀挀攀崀ഀഀ
                                    , [SourceKey]਍                                    Ⰰ 嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀ഀഀ
                                    , [RecentCommMethodKey]਍                                    Ⰰ 嬀䌀漀洀洀甀渀椀挀愀琀椀漀渀䴀攀琀栀漀搀崀ഀഀ
                                    , [IsValidLeadName]਍                                    Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀䰀愀猀琀一愀洀攀崀ഀഀ
                                    , [IsValidLeadFullName]਍                                    Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀倀栀漀渀攀崀ഀഀ
                                    , [IsValidLeadMobilePhone]਍                                    Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀䔀洀愀椀氀崀ഀഀ
                                    , [ReviewNeeded]਍                                    Ⰰ 嬀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀崀ഀഀ
                                    , [ConvertedAccountId]਍                                    Ⰰ 嬀䌀漀渀瘀攀爀琀攀搀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀ഀഀ
                                    , [ConvertedDate]਍                                    Ⰰ 嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀ഀഀ
                                    , [SourceSystem]਍                                    Ⰰ 嬀䐀圀䠀开䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
                                    , [DWH_LastUpdateDate]਍                                    Ⰰ 嬀䰀攀愀搀䔀砀琀攀爀渀愀氀䤀䐀崀ഀഀ
                                    , [ServiceTerritoryID]਍                                    Ⰰ 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀崀ഀഀ
                                    , [OriginalCampaignKey]਍                                    Ⰰ 嬀䄀挀挀漀甀渀琀䤀䐀崀ഀഀ
                                    , [LeadOccupation]਍                                    Ⰰ 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀ഀഀ
                                    , [GCLID]਍                                    Ⰰ 嬀刀攀愀氀䌀爀攀愀琀攀搀䐀愀琀攀崀 ⤀ഀഀ
SELECT਍    嬀䰀攀愀搀䬀攀礀崀ഀഀ
  , [LeadId]਍  Ⰰ 嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀崀ഀഀ
  , [LeadLastname]਍  Ⰰ 嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀ഀഀ
  , [LeadBirthday]਍  Ⰰ 嬀䰀攀愀搀䄀搀搀爀攀猀猀崀ഀഀ
  , [IsActive]਍  Ⰰ 嬀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀崀ഀഀ
  , [Isvalid]਍  Ⰰ 嬀䰀攀愀搀䔀洀愀椀氀崀ഀഀ
  , [LeadPhone]਍  Ⰰ 嬀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀ഀഀ
  , [NorwoodScale]਍  Ⰰ 嬀䰀甀搀眀椀最匀挀愀氀攀崀ഀഀ
  , [HairLossInFamily]਍  Ⰰ 嬀䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀唀猀攀搀崀ഀഀ
  , [HairLossSpot]਍  Ⰰ 嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀ഀഀ
  , [LeadPostalCode]਍  Ⰰ 嬀䔀琀栀渀椀挀椀琀礀䬀攀礀崀ഀഀ
  , [LeadEthnicity]਍  Ⰰ 嬀䜀攀渀搀攀爀䬀攀礀崀ഀഀ
  , [LeadGender]਍  Ⰰ 嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
  , [CenterNumber]਍  Ⰰ 嬀䰀愀渀最甀愀最攀䬀攀礀崀ഀഀ
  , [LeadLanguage]਍  Ⰰ 嬀匀琀愀琀甀猀䬀攀礀崀ഀഀ
  , [LeadStatus]਍  Ⰰ 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
  , [CreatedDateKey]਍  Ⰰ 嬀䌀爀攀愀琀攀搀吀椀洀攀䬀攀礀崀ഀഀ
  , [LeadLastActivityDate]਍  Ⰰ 嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀崀ഀഀ
  , [LastActivityTimekey]਍  Ⰰ 嬀䐀䤀匀䌀匀琀礀氀攀崀ഀഀ
  , [LeadMaritalStatus]਍  Ⰰ 嬀䰀攀愀搀䌀漀渀猀甀氀琀刀攀愀搀礀崀ഀഀ
  , [ConsultationFormReady]਍  Ⰰ 嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
  , [DoNotCall]਍  Ⰰ 嬀䐀漀一漀琀䌀漀渀琀愀挀琀崀ഀഀ
  , [DoNotEmail]਍  Ⰰ 嬀䐀漀一漀琀䴀愀椀氀崀ഀഀ
  , [DoNotText]਍  Ⰰ 嬀䌀爀攀愀琀攀唀猀攀爀崀ഀഀ
  , [UpdateUser]਍  Ⰰ 嬀䌀椀琀礀崀ഀഀ
  , [State]਍  Ⰰ 嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀䬀攀礀崀ഀഀ
  , [LeadSource]਍  Ⰰ 嬀匀漀甀爀挀攀䬀攀礀崀ഀഀ
  , [OriginalCommMethodkey]਍  Ⰰ 嬀刀攀挀攀渀琀䌀漀洀洀䴀攀琀栀漀搀䬀攀礀崀ഀഀ
  , [CommunicationMethod]਍  Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀一愀洀攀崀ഀഀ
  , [IsValidLeadLastName]਍  Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀䘀甀氀氀一愀洀攀崀ഀഀ
  , [IsValidLeadPhone]਍  Ⰰ 嬀䤀猀嘀愀氀椀搀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀ഀഀ
  , [IsValidLeadEmail]਍  Ⰰ 嬀刀攀瘀椀攀眀一攀攀搀攀搀崀ഀഀ
  , [ConvertedContactId]਍  Ⰰ 嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
  , [ConvertedOpportunityId]਍  Ⰰ 嬀䌀漀渀瘀攀爀琀攀搀䐀愀琀攀崀ഀഀ
  , [LastModifiedDate]਍  Ⰰ 嬀匀漀甀爀挀攀匀礀猀琀攀洀崀ഀഀ
  , [DWH_CreatedDate]਍  Ⰰ 嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀ഀഀ
  , [LeadExternalID]਍  Ⰰ 嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀䐀崀ഀഀ
  , [OriginalCampaignId]਍  Ⰰ 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
  , [AccountID]਍  Ⰰ 嬀䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀崀ഀഀ
  , [OriginalCampaignSource]਍  Ⰰ 嬀䜀䌀䰀䤀䐀崀ഀഀ
  , [RealCreatedDate]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀ഀഀ
WHERE MONTH(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [LeadCreatedDate]))) = MONTH(਍                                                                                                                                                         䐀䄀吀䔀䄀䐀䐀⠀ഀഀ
                                                                                                                                                         DAY਍                                                                                                                                                         Ⰰ ⴀ㄀ഀഀ
                                                                                                                                                         , GETDATE()))਍  䄀一䐀 夀䔀䄀刀⠀䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀⤀⤀ 㴀 夀䔀䄀刀⠀ഀഀ
                                                                                                                                                        DATEADD(਍                                                                                                                                                        䐀䄀夀 Ⰰ ⴀ㄀ഀഀ
                                                                                                                                                        , GETDATE())) ;਍ഀഀ
INSERT INTO [dbo].[FactOpportunityTracking]( [FactDate]਍                                           Ⰰ 嬀䘀愀挀琀䐀愀琀攀欀攀礀崀ഀഀ
                                           , [OpportunityId]਍                                           Ⰰ 嬀䰀攀愀搀䬀攀礀崀ഀഀ
                                           , [LeadId]਍                                           Ⰰ 嬀䄀挀挀漀甀渀琀䬀攀礀崀ഀഀ
                                           , [AccountId]਍                                           Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀一愀洀攀崀ഀഀ
                                           , [OpportunityDescription]਍                                           Ⰰ 嬀匀琀愀琀甀猀䬀攀礀崀ഀഀ
                                           , [OpportunityStatus]਍                                           Ⰰ 嬀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
                                           , [OpportunityCampaign]਍                                           Ⰰ 嬀䌀氀漀猀攀䐀愀琀攀崀ഀഀ
                                           , [CloseDateKey]਍                                           Ⰰ 嬀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
                                           , [CreatedUserKey]਍                                           Ⰰ 嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀ഀഀ
                                           , [LastModifiedDate]਍                                           Ⰰ 嬀唀瀀搀愀琀攀唀猀攀爀䬀攀礀崀ഀഀ
                                           , [LastModifiedById]਍                                           Ⰰ 嬀䰀漀猀猀刀攀愀猀漀渀䬀攀礀崀ഀഀ
                                           , [OpportunityLossReason]਍                                           Ⰰ 嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
                                           , [IsClosed]਍                                           Ⰰ 嬀䤀猀圀漀渀崀ഀഀ
                                           , [OpportunityReferralCode]਍                                           Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀匀漀甀爀挀攀䌀漀搀攀崀ഀഀ
                                           , [OpportunitySolutionOffered]਍                                           Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
                                           , [BeBackFlag]਍                                           Ⰰ 嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
                                           , [CenterNumber]਍                                           Ⰰ 嬀䤀猀伀氀搀崀ഀഀ
                                           , [Ammount] )਍匀䔀䰀䔀䌀吀ഀഀ
    [FactDate]਍  Ⰰ 嬀䘀愀挀琀䐀愀琀攀欀攀礀崀ഀഀ
  , [OpportunityId]਍  Ⰰ 嬀䰀攀愀搀䬀攀礀崀ഀഀ
  , [LeadId]਍  Ⰰ 嬀䄀挀挀漀甀渀琀䬀攀礀崀ഀഀ
  , [AccountId]਍  Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀一愀洀攀崀ഀഀ
  , [OpportunityDescription]਍  Ⰰ 嬀匀琀愀琀甀猀䬀攀礀崀ഀഀ
  , [OpportunityStatus]਍  Ⰰ 嬀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
  , [OpportunityCampaign]਍  Ⰰ 嬀䌀氀漀猀攀䐀愀琀攀崀ഀഀ
  , [CloseDateKey]਍  Ⰰ 嬀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
  , [CreatedUserKey]਍  Ⰰ 嬀䌀爀攀愀琀攀搀䈀礀䤀搀崀ഀഀ
  , [LastModifiedDate]਍  Ⰰ 嬀唀瀀搀愀琀攀唀猀攀爀䬀攀礀崀ഀഀ
  , [LastModifiedById]਍  Ⰰ 嬀䰀漀猀猀刀攀愀猀漀渀䬀攀礀崀ഀഀ
  , [OpportunityLossReason]਍  Ⰰ 嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
  , [IsClosed]਍  Ⰰ 嬀䤀猀圀漀渀崀ഀഀ
  , [OpportunityReferralCode]਍  Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀匀漀甀爀挀攀䌀漀搀攀崀ഀഀ
  , [OpportunitySolutionOffered]਍  Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
  , [BeBackFlag]਍  Ⰰ 嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
  , [CenterNumber]਍  Ⰰ 嬀䤀猀伀氀搀崀ഀഀ
  , [Ammount]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀崀ഀഀ
WHERE MONTH(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [FactDate])AT TIME ZONE 'Eastern Standard Time'), [FactDate]))) = MONTH(਍                                                                                                                                           䐀䄀吀䔀䄀䐀䐀⠀ഀഀ
                                                                                                                                           DAY , -1, GETDATE()))਍  䄀一䐀 夀䔀䄀刀⠀䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀䘀愀挀琀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀䘀愀挀琀䐀愀琀攀崀⤀⤀⤀ 㴀 夀䔀䄀刀⠀ഀഀ
                                                                                                                                          DATEADD(਍                                                                                                                                          䐀䄀夀 Ⰰ ⴀ㄀Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀⤀ 㬀ഀഀ
਍䤀一匀䔀刀吀 䤀一吀伀 嬀搀戀漀崀⸀嬀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀吀爀愀挀欀椀渀最崀⠀ 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
                                           , [FactTimeKey]਍                                           Ⰰ 嬀䘀愀挀琀䐀愀琀攀䬀攀礀崀ഀഀ
                                           , [AppointmentDate]਍                                           Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀崀ഀഀ
                                           , [AppointmentDateKey]਍                                           Ⰰ 嬀䰀攀愀搀䬀攀礀崀ഀഀ
                                           , [LeadId]਍                                           Ⰰ 嬀䄀挀挀漀甀渀琀䬀攀礀崀ഀഀ
                                           , [AccountId]਍                                           Ⰰ 嬀䌀漀渀琀愀挀琀䬀攀礀崀ഀഀ
                                           , [ContactId]਍                                           Ⰰ 嬀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀崀ഀഀ
                                           , [WorkTypeKey]਍                                           Ⰰ 嬀圀漀爀欀吀礀瀀攀䤀搀崀ഀഀ
                                           , [AccountAddress]਍                                           Ⰰ 嬀䄀挀挀漀甀渀琀䌀椀琀礀崀ഀഀ
                                           , [AccountState]਍                                           Ⰰ 嬀䄀挀挀漀甀渀琀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
                                           , [AccountCountry]਍                                           Ⰰ 嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀ഀഀ
                                           , [AppointmentDescription]਍                                           Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
                                           , [CenterKey]਍                                           Ⰰ 嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀崀ഀഀ
                                           , [CenterNumber]਍                                           Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀崀ഀഀ
                                           , [AppointmentType]਍                                           Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䌀攀渀琀攀爀吀礀瀀攀崀ഀഀ
                                           , [ExternalId]਍                                           Ⰰ 嬀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
                                           , [MeetingPlatformKey]਍                                           Ⰰ 嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䤀搀崀ഀഀ
                                           , [MeetingPlatform]਍                                           Ⰰ 嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀ഀഀ
                                           , [DWH_LastUpdateDate]਍                                           Ⰰ 嬀倀愀爀攀渀琀刀攀挀漀爀搀䤀搀崀ഀഀ
                                           , [AppointmentId]਍                                           Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
                                           , [StatusKey]਍                                           Ⰰ 嬀䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀崀ഀഀ
                                           , [BeBackFlag]਍                                           Ⰰ 嬀伀氀搀匀琀愀琀甀猀崀ഀഀ
                                           , [AppoinmentStatusCategory]਍                                           Ⰰ 嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
                                           , [IsOld]਍                                           Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀ഀഀ
                                           , [OpportunityStatus]਍                                           Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀崀ഀഀ
                                           , [OpportunityReferralCode]਍                                           Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀崀ഀഀ
                                           , [OpportunityAmount] )਍匀䔀䰀䔀䌀吀ഀഀ
    [FactDate]਍  Ⰰ 嬀䘀愀挀琀吀椀洀攀䬀攀礀崀ഀഀ
  , [FactDateKey]਍  Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀ഀഀ
  , [AppointmentTimeKey]਍  Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀崀ഀഀ
  , [LeadKey]਍  Ⰰ 嬀䰀攀愀搀䤀搀崀ഀഀ
  , [AccountKey]਍  Ⰰ 嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
  , [ContactKey]਍  Ⰰ 嬀䌀漀渀琀愀挀琀䤀搀崀ഀഀ
  , [ParentRecordType]਍  Ⰰ 嬀圀漀爀欀吀礀瀀攀䬀攀礀崀ഀഀ
  , [WorkTypeId]਍  Ⰰ 嬀䄀挀挀漀甀渀琀䄀搀搀爀攀猀猀崀ഀഀ
  , [AccountCity]਍  Ⰰ 嬀䄀挀挀漀甀渀琀匀琀愀琀攀崀ഀഀ
  , [AccountPostalCode]਍  Ⰰ 嬀䄀挀挀漀甀渀琀䌀漀甀渀琀爀礀崀ഀഀ
  , [GeographyKey]਍  Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [AppointmentStatus]਍  Ⰰ 嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
  , [ServiceTerritoryId]਍  Ⰰ 嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
  , [AppointmentTypeKey]਍  Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀崀ഀഀ
  , [AppointmentCenterType]਍  Ⰰ 嬀䔀砀琀攀爀渀愀氀䤀搀崀ഀഀ
  , [ServiceAppointment]਍  Ⰰ 嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䬀攀礀崀ഀഀ
  , [MeetingPlatformId]਍  Ⰰ 嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀崀ഀഀ
  , [DWH_LoadDate]਍  Ⰰ 嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀ഀഀ
  , [ParentRecordId]਍  Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀ഀഀ
  , [ExternalTaskId]਍  Ⰰ 嬀匀琀愀琀甀猀䬀攀礀崀ഀഀ
  , [CancellationReason]਍  Ⰰ 嬀䈀攀䈀愀挀欀䘀氀愀最崀ഀഀ
  , [OldStatus]਍  Ⰰ 嬀䄀瀀瀀漀椀渀洀攀渀琀匀琀愀琀甀猀䌀愀琀攀最漀爀礀崀ഀഀ
  , [IsDeleted]਍  Ⰰ 嬀䤀猀伀氀搀崀ഀഀ
  , [OpportunityId]਍  Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀崀ഀഀ
  , [OpportunityDate]਍  Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀崀ഀഀ
  , [OpportunityReferralCodeExpirationDate]਍  Ⰰ 嬀伀瀀瀀漀爀琀甀渀椀琀礀䄀洀洀漀甀渀琀崀ഀഀ
FROM [dbo].[FactAppointment]਍圀䠀䔀刀䔀 䴀伀一吀䠀⠀䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀⤀⤀⤀ 㴀 䴀伀一吀䠀⠀ഀഀ
                                                                                                                                                         DATEADD(਍                                                                                                                                                         䐀䄀夀ഀഀ
                                                                                                                                                         , -1਍                                                                                                                                                         Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀⤀ഀഀ
  AND YEAR(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [AppointmentDate])AT TIME ZONE 'Eastern Standard Time'), [AppointmentDate]))) = YEAR(਍                                                                                                                                                        䐀䄀吀䔀䄀䐀䐀⠀ഀഀ
                                                                                                                                                        DAY , -1਍                                                                                                                                                        Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀⤀ 㬀ഀഀ
GO਍
