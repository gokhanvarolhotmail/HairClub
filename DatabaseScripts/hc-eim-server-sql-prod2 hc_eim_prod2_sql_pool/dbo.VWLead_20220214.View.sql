/****** Object:  View [dbo].[VWLead_20220214]    Script Date: 3/7/2022 8:42:20 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀开㈀　㈀㈀　㈀㄀㐀崀ഀഀ
AS With dimLead_CTE as਍         ⠀匀䔀䰀䔀䌀吀 䰀攀愀搀䬀攀礀ഀഀ
               , LeadCreatedDate                         LeadCreatedDateUTC਍               Ⰰ 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰഀഀ
                         LeadCreatedDate)                LeadCreatedDateEST਍               Ⰰ 挀爀攀愀琀攀搀䐀愀琀攀䬀攀礀ഀഀ
               , a.LeadId਍               Ⰰ 愀⸀䰀攀愀搀䘀椀爀猀琀一愀洀攀                         䰀攀愀搀一愀洀攀ഀഀ
               , LeadLastName                            LeadLastName਍               Ⰰ 䰀攀愀搀䘀甀氀氀一愀洀攀                            䰀攀愀搀䘀甀氀氀一愀洀攀ഀഀ
               , a.LeadEmail਍               Ⰰ 愀⸀䰀攀愀搀倀栀漀渀攀ഀഀ
               , a.LeadMobilephone਍               Ⰰ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀ഀഀ
               , isnull(geographykey, -1) as             geographykey਍               Ⰰ 椀猀渀甀氀氀⠀挀攀渀琀攀爀欀攀礀Ⰰ ⴀ㄀⤀    愀猀             挀攀渀琀攀爀欀攀礀ഀഀ
               , LeadCreatedDate਍               Ⰰ 䰀攀愀搀䘀椀爀猀琀一愀洀攀ഀഀ
               , LeadLastActivityDate਍               Ⰰ 䤀猀愀挀琀椀瘀攀ഀഀ
               , Isvalid਍               Ⰰ 䤀猀搀攀氀攀琀攀搀ഀഀ
               , IsConsultFormComplete਍               Ⰰ 䰀攀愀搀匀琀愀琀甀猀ഀഀ
               , SourceKey਍               Ⰰ 伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀ഀഀ
               , LeadSource਍               Ⰰ 䌀爀攀愀琀攀唀猀攀爀ഀഀ
               , LeadExternalId਍               Ⰰ 䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀ഀഀ
               , LeadBirthday਍               Ⰰ 搀愀琀攀搀椀昀昀⠀礀攀愀爀Ⰰ 䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀最攀ഀഀ
               , GCLID਍               Ⰰ 䰀攀愀搀䰀愀渀最甀愀最攀ഀഀ
               , LeadGender਍               Ⰰ 䰀攀愀搀䔀琀栀渀椀挀椀琀礀ഀഀ
               , NorwoodScale਍               Ⰰ 䰀甀搀眀椀最匀挀愀氀攀ഀഀ
               , LeadMaritalStatus਍               Ⰰ 䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀ഀഀ
               , DoNotContact਍               Ⰰ 䐀漀一漀琀䌀愀氀氀ഀഀ
               , DoNotText਍               Ⰰ 䐀漀一漀琀䔀洀愀椀氀ഀഀ
               , DoNotMail਍               Ⰰ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀഀ
               , convertedaccountid਍               Ⰰ 䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀ഀഀ
               , isduplicatebyemail਍               Ⰰ 椀猀搀甀瀀氀椀挀愀琀攀戀礀渀愀洀攀ഀഀ
               , a.accountid਍          䘀刀伀䴀 搀椀洀氀攀愀搀 愀ഀഀ
          WHERE dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),਍                        䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 㸀㴀 䌀伀一嘀䔀刀吀⠀搀愀琀攀Ⰰ 搀愀琀攀愀搀搀⠀搀Ⰰ ⴀ⠀搀愀礀⠀最攀琀搀愀琀攀⠀⤀ ⴀ ㄀⤀⤀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀Ⰰ ㄀　㘀⤀ഀഀ
਍          唀一䤀伀一 䄀䰀䰀ഀഀ
਍          匀䔀䰀䔀䌀吀 䰀攀愀搀䬀攀礀ഀഀ
               , LeadCreatedDate                         LeadCreatedDateUTC਍               Ⰰ 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰഀഀ
                         LeadCreatedDate)                LeadCreatedDateEST਍               Ⰰ 挀爀攀愀琀攀搀䐀愀琀攀䬀攀礀ഀഀ
               , a.LeadId਍               Ⰰ 愀⸀䰀攀愀搀䘀椀爀猀琀一愀洀攀                         䰀攀愀搀一愀洀攀ഀഀ
               , LeadLastName                            LeadLastName਍               Ⰰ 䰀攀愀搀䘀甀氀氀一愀洀攀                            䰀攀愀搀䘀甀氀氀一愀洀攀ഀഀ
               , a.LeadEmail਍               Ⰰ 愀⸀䰀攀愀搀倀栀漀渀攀ഀഀ
               , a.LeadMobilephone਍               Ⰰ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀ഀഀ
               , isnull(geographykey, -1) as             geographykey਍               Ⰰ 椀猀渀甀氀氀⠀挀攀渀琀攀爀欀攀礀Ⰰ ⴀ㄀⤀    愀猀             挀攀渀琀攀爀欀攀礀ഀഀ
               , LeadCreatedDate਍               Ⰰ 䰀攀愀搀䘀椀爀猀琀一愀洀攀ഀഀ
               , LeadLastActivityDate਍               Ⰰ 䤀猀愀挀琀椀瘀攀ഀഀ
               , Isvalid਍               Ⰰ 䤀猀搀攀氀攀琀攀搀ഀഀ
               , IsConsultFormComplete਍               Ⰰ 䰀攀愀搀匀琀愀琀甀猀ഀഀ
               , SourceKey਍               Ⰰ 伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀ഀഀ
               , LeadSource਍               Ⰰ 䌀爀攀愀琀攀唀猀攀爀ഀഀ
               , LeadExternalId਍               Ⰰ 䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀ഀഀ
               , LeadBirthday਍               Ⰰ 搀愀琀攀搀椀昀昀⠀礀攀愀爀Ⰰ 䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀最攀ഀഀ
               , GCLID਍               Ⰰ 䰀攀愀搀䰀愀渀最甀愀最攀ഀഀ
               , LeadGender਍               Ⰰ 䰀攀愀搀䔀琀栀渀椀挀椀琀礀ഀഀ
               , NorwoodScale਍               Ⰰ 䰀甀搀眀椀最匀挀愀氀攀ഀഀ
               , LeadMaritalStatus਍               Ⰰ 䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀ഀഀ
               , DoNotContact਍               Ⰰ 䐀漀一漀琀䌀愀氀氀ഀഀ
               , DoNotText਍               Ⰰ 䐀漀一漀琀䔀洀愀椀氀ഀഀ
               , DoNotMail਍               Ⰰ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀഀ
               , convertedaccountid਍               Ⰰ 䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀ഀഀ
               , 0਍               Ⰰ 　ഀഀ
               , a.accountid਍          䘀刀伀䴀 䘀愀挀琀䰀攀愀搀吀爀愀挀欀椀渀最 愀ഀഀ
             WHERE dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),਍                        䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 㰀 䌀伀一嘀䔀刀吀⠀搀愀琀攀Ⰰ 搀愀琀攀愀搀搀⠀搀Ⰰ ⴀ⠀搀愀礀⠀最攀琀搀愀琀攀⠀⤀ ⴀ ㄀⤀⤀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀Ⰰ ㄀　㘀⤀ഀഀ
         )਍ഀഀ
select LeadKey਍     Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀                          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀ഀഀ
     , dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),਍               䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀                 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀ഀഀ
     , a.createdDateKey਍     Ⰰ 愀⸀䰀攀愀搀䤀搀ഀഀ
     , a.LeadFirstName                          LeadName਍     Ⰰ 䰀攀愀搀䰀愀猀琀一愀洀攀                             䰀攀愀搀䰀愀猀琀一愀洀攀ഀഀ
     , LeadFullName                             LeadFullName਍     Ⰰ 愀⸀䰀攀愀搀䔀洀愀椀氀ഀഀ
     , a.LeadPhone਍     Ⰰ 愀⸀䰀攀愀搀䴀漀戀椀氀攀瀀栀漀渀攀ഀഀ
     , LeadBirthday਍     Ⰰ 搀愀琀攀搀椀昀昀⠀礀攀愀爀Ⰰ 䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀  䄀最攀ഀഀ
     , k.Centerkey਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
     , k.[CenterPayGroupID]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
     , k.[Address1]਍     Ⰰ 欀⸀嬀䄀搀搀爀攀猀猀㈀崀ഀഀ
     , k.[Address3]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀䜀攀漀最爀愀瀀栀礀欀攀礀崀ഀഀ
     , k.[CenterPostalCode]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㄀崀ഀഀ
     , k.[CenterPhone2]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㌀崀ഀഀ
     , k.[Phone1TypeID]਍     Ⰰ 欀⸀嬀倀栀漀渀攀㈀吀礀瀀攀䤀䐀崀ഀഀ
     , k.[Phone3TypeID]਍     Ⰰ 欀⸀嬀䤀猀䄀挀琀椀瘀攀䘀氀愀最崀ഀഀ
     , k.[CreateDate]਍     Ⰰ 欀⸀嬀䰀愀猀琀唀瀀搀愀琀攀崀ഀഀ
     , k.[UpdateStamp]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
     , k.[CenterOwnershipID]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀匀漀爀琀伀爀搀攀爀崀ഀഀ
     , k.[CenterOwnershipDescription]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀ഀഀ
     , k.[OwnerLastName]਍     Ⰰ 欀⸀嬀伀眀渀攀爀䘀椀爀猀琀一愀洀攀崀ഀഀ
     , k.[CorporateName]਍     Ⰰ 欀⸀嬀伀眀渀攀爀猀栀椀瀀䄀搀搀爀攀猀猀㄀崀ഀഀ
     , k.[CenterTypeID]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀匀漀爀琀伀爀搀攀爀崀ഀഀ
     , k.[CenterTypeDescription]਍     Ⰰ 欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀ഀഀ
     , isnull(b.CampaignKey, -1)                OriginalCampaignKey਍     Ⰰ 戀⸀䌀愀洀瀀愀椀最渀一愀洀攀                           伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀ഀഀ
     , b.SourceCode                             Originalsourcecode਍     Ⰰ 戀⸀䌀愀洀瀀愀椀最渀吀礀瀀攀                           伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀吀礀瀀攀ഀഀ
     , b.CampaignMedia                          OriginalCampaignMedia਍     Ⰰ 戀⸀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀                         伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀伀爀椀最椀渀ഀഀ
     , b.CampaignLocation                       OriginalcampaignLocation਍     Ⰰ ✀✀                                       伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀ഀഀ
     , LeadLastActivityDate਍     Ⰰ 䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀ഀഀ
     , e.country                                LeadCountry਍     Ⰰ 挀最⸀挀漀甀渀琀爀礀                               䌀攀渀琀攀爀䌀漀甀渀琀爀礀ഀഀ
     , cg.DMADescription਍     Ⰰ 挀最⸀䐀䴀䄀䌀漀搀攀ഀഀ
     , cg.DMAMarketRegion਍     Ⰰ 挀最⸀䜀攀漀最爀愀瀀栀礀欀攀礀ഀഀ
     , e.[NameOfCityOrORG]                      LeadCity਍     Ⰰ 攀⸀嬀䘀甀氀氀一愀洀攀伀昀匀琀愀琀攀伀爀吀攀爀爀椀琀漀爀礀崀           䰀攀愀搀匀琀愀琀攀ഀഀ
     , a.Isactive਍     Ⰰ 愀⸀䤀猀瘀愀氀椀搀ഀഀ
     , a.IsConsultFormComplete਍     Ⰰ 䰀攀愀搀匀琀愀琀甀猀ഀഀ
     , a.IsDeleted਍     Ⰰ 椀猀渀甀氀氀⠀愀最⸀䄀最攀渀挀礀䬀攀礀Ⰰ ⴀ㄀⤀                 䄀最攀渀挀礀欀攀礀ഀഀ
     , ag.AgencyName਍     Ⰰ 椀猀渀甀氀氀⠀愀⸀匀漀甀爀挀攀䬀攀礀Ⰰ ⴀ㄀⤀                  匀漀甀爀挀攀䬀攀礀ഀഀ
     , sc.SourceName਍     Ⰰ 椀猀渀甀氀氀⠀愀⸀嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀Ⰰ ⴀ㄀⤀    伀爀椀最椀渀愀氀䌀漀洀䴀攀琀栀漀搀䬀攀礀ഀഀ
     , case਍           眀栀攀渀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 氀椀欀攀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀ 琀栀攀渀 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           when lower(b.[CampaignName]) like '%gleam%' then 'Gleam Form'਍           眀栀攀渀 戀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 琀栀攀渀 ✀匀栀漀瀀椀昀礀✀ഀഀ
           when lower(sc.SourceName) in ('call', 'phone', 'call center') then 'Phone Call'਍           眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀戀漀猀爀攀昀✀Ⰰ ✀漀琀栀攀爀ⴀ戀漀猀✀⤀ 琀栀攀渀 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
           when b.[SourceCode] like 'DGPDSFACEIMAD14097%' then 'Facebook Messenger'਍           眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀眀攀戀 昀漀爀洀✀⤀ 愀渀搀 戀⸀匀漀甀爀挀攀䌀漀搀攀 渀漀琀 氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 愀渀搀ഀഀ
                lower(b.[CampaignName]) not like '%leads-ads%' and lower(b.[CampaignName]) not like '%gleam%'਍               琀栀攀渀 ✀䄀瀀瀀琀 䘀漀爀洀✀ഀഀ
           when (a.LeadSource is null and lower(a.CreateUser) = 'bosleyintegration@hairclub.com') or਍                猀挀⸀匀漀甀爀挀攀一愀洀攀 㴀 ✀䈀漀猀爀攀昀✀ 琀栀攀渀 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
           when lower(sc.SourceName) in ('web chat', 'hairbot', 'hairclub app') then sc.SourceName਍           攀氀猀攀 ✀伀琀栀攀爀✀ഀഀ
    end                                         MarketingSource਍     Ⰰ 䰀攀愀搀䔀砀琀攀爀渀愀氀䤀搀ഀഀ
     , a.GCLID਍     Ⰰ 愀⸀䰀攀愀搀䰀愀渀最甀愀最攀ഀഀ
     , a.LeadGender਍     Ⰰ 愀⸀䰀攀愀搀䔀琀栀渀椀挀椀琀礀ഀഀ
     , a.NorwoodScale਍     Ⰰ 愀⸀䰀甀搀眀椀最匀挀愀氀攀ഀഀ
     , a.LeadMaritalStatus਍     Ⰰ 愀⸀䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀ഀഀ
     , a.DoNotContact਍     Ⰰ 愀⸀䐀漀一漀琀䌀愀氀氀ഀഀ
     , a.DoNotText਍     Ⰰ 愀⸀䐀漀一漀琀䔀洀愀椀氀ഀഀ
     , a.DoNotMail਍     Ⰰ 愀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀഀ
     , a.convertedaccountid਍     Ⰰ 䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀ഀഀ
     , LeadSource਍     Ⰰ 䰀攀愀搀䘀椀爀猀琀一愀洀攀ഀഀ
     , [TimeOfDayKey]                        as TimeOfDayESTKey਍     Ⰰ 椀猀搀甀瀀氀椀挀愀琀攀戀礀攀洀愀椀氀ഀഀ
     , isduplicatebyname਍     Ⰰ 椀猀渀甀氀氀⠀愀⸀䰀攀愀搀䤀搀Ⰰ 搀⸀䄀挀挀漀甀渀琀䔀砀琀攀爀渀愀氀䤀搀⤀ 愀猀 䰀攀愀搀䤀搀䔀砀琀攀爀渀愀氀ഀഀ
     , a.LeadExternalId                      as 'RealExternalId'਍䘀刀伀䴀 䐀椀洀䰀攀愀搀开䌀吀䔀 愀ഀഀ
         LEFT JOIN dimCampaign b on a.originalcampaignkey = b.campaignkey਍    ⴀⴀ氀攀昀琀 樀漀椀渀 搀椀洀搀愀琀攀 搀 漀渀 愀⸀氀攀愀搀开挀爀攀愀琀攀搀搀愀琀攀㴀搀⸀搀愀琀攀欀攀礀ഀഀ
         LEFT JOIN dimgeography e on a.geographykey = e.geographykey਍         䰀䔀䘀吀 䨀伀䤀一 搀椀洀䌀攀渀琀攀爀 欀 漀渀 愀⸀挀攀渀琀攀爀欀攀礀 㴀 欀⸀挀攀渀琀攀爀欀攀礀ഀഀ
         LEFT JOIN dimgeography cg on k.Centergeographykey = cg.geographykey਍         䰀䔀䘀吀 䨀伀䤀一 搀椀洀䄀最攀渀挀礀 䄀最 漀渀 戀⸀䄀最攀渀挀礀䬀攀礀 㴀 愀最⸀䄀最攀渀挀礀䬀攀礀ഀഀ
         LEFT JOIN dimSource sc on a.sourceKey = sc.sourcekey਍         䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀 搀琀 漀渀 搀琀⸀嬀吀椀洀攀㈀㐀崀 㴀 挀漀渀瘀攀爀琀⠀琀椀洀攀Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀⤀ഀഀ
         LEFT JOIN dimaccount d on a.accountid = d.accountid;਍䜀伀ഀഀ
