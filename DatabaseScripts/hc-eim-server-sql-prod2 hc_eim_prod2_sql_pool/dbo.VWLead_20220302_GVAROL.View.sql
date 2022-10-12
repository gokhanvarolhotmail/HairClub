/****** Object:  View [dbo].[VWLead_20220302_GVAROL]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀开㈀　㈀㈀　㌀　㈀开䜀嘀䄀刀伀䰀崀ഀഀ
AS WITH [dimLead_CTE]਍䄀匀 ⠀ഀഀ
   SELECT਍       嬀愀崀⸀嬀䰀攀愀搀䬀攀礀崀ഀഀ
     , [a].[LeadCreatedDate] AS [LeadCreatedDateUTC]਍     Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀ 䄀匀 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀崀ഀഀ
     , [a].[CreatedDateKey]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
     , [a].[LeadFirstName] AS [LeadName]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀猀琀渀愀洀攀崀 䄀匀 嬀䰀攀愀搀䰀愀猀琀一愀洀攀崀ഀഀ
     , [a].[LeadFullName] AS [LeadFullName]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀洀愀椀氀崀ഀഀ
     , [a].[LeadPhone]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀ഀഀ
     , [a].[OriginalCampaignKey]਍     Ⰰ 䤀匀一唀䰀䰀⠀嬀愀崀⸀嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀最攀漀最爀愀瀀栀礀欀攀礀崀ഀഀ
     , ISNULL([a].[CenterKey], -1) AS [centerkey]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
     , [a].[LeadFirstName]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀ഀഀ
     , [a].[IsActive]਍     Ⰰ 嬀愀崀⸀嬀䤀猀瘀愀氀椀搀崀ഀഀ
     , [a].[IsDeleted]਍     Ⰰ 嬀愀崀⸀嬀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀崀ഀഀ
     , [a].[LeadStatus]਍     Ⰰ 嬀愀崀⸀嬀匀漀甀爀挀攀䬀攀礀崀ഀഀ
     , [a].[OriginalCommMethodkey]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀匀漀甀爀挀攀崀ഀഀ
     , [a].[CreateUser]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀砀琀攀爀渀愀氀䤀䐀崀ഀഀ
     , [a].[LastActivityDateKey]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䈀椀爀琀栀搀愀礀崀ഀഀ
     , DATEDIFF(YEAR, [a].[LeadBirthday], GETDATE()) AS [Age]਍     Ⰰ 嬀愀崀⸀嬀䜀䌀䰀䤀䐀崀ഀഀ
     , [a].[LeadLanguage]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䜀攀渀搀攀爀崀ഀഀ
     , [a].[LeadEthnicity]਍     Ⰰ 嬀愀崀⸀嬀一漀爀眀漀漀搀匀挀愀氀攀崀ഀഀ
     , [a].[LudwigScale]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀ഀഀ
     , [a].[LeadOccupation]਍     Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䌀漀渀琀愀挀琀崀ഀഀ
     , [a].[DoNotCall]਍     Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀吀攀砀琀崀ഀഀ
     , [a].[DoNotEmail]਍     Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䴀愀椀氀崀ഀഀ
     , [a].[OriginalCampaignId]਍     Ⰰ 嬀愀崀⸀嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
     , [a].[LeadPostalCode]਍     Ⰰ 嬀愀崀⸀嬀䤀猀䐀甀瀀氀椀挀愀琀攀䈀礀䔀洀愀椀氀崀ഀഀ
     , [a].[IsDuplicateByName]਍     Ⰰ 嬀愀崀⸀嬀䄀挀挀漀甀渀琀䤀䐀崀ഀഀ
   FROM [dbo].[DimLead] AS [a]਍   圀䠀䔀刀䔀 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀ 㸀㴀 䌀伀一嘀䔀刀吀⠀ഀഀ
                                                                                                                                               DATE਍                                                                                                                                               Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀ഀഀ
                                                                                                                                                d਍                                                                                                                                                Ⰰ ⴀ⠀ 䐀䄀夀⠀ഀഀ
                                                                                                                                                    GETDATE()਍                                                                                                                                                    ⴀ ㄀⤀⤀ഀഀ
                                                                                                                                                , GETDATE())਍                                                                                                                                               Ⰰ ㄀　㘀⤀ഀഀ
   UNION ALL਍   匀䔀䰀䔀䌀吀ഀഀ
       [a].[LeadKey]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 䄀匀 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀ഀഀ
     , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) AS [LeadCreatedDateEST]਍     Ⰰ 嬀愀崀⸀嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀ഀഀ
     , [a].[LeadId]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀崀 䄀匀 嬀䰀攀愀搀一愀洀攀崀ഀഀ
     , [a].[LeadLastname] AS [LeadLastName]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀 䄀匀 嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀ഀഀ
     , [a].[LeadEmail]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀倀栀漀渀攀崀ഀഀ
     , [a].[LeadMobilePhone]਍     Ⰰ 嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
     , ISNULL([a].[GeographyKey], -1) AS [geographykey]਍     Ⰰ 䤀匀一唀䰀䰀⠀嬀愀崀⸀嬀䌀攀渀琀攀爀䬀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀挀攀渀琀攀爀欀攀礀崀ഀഀ
     , [a].[LeadCreatedDate]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀崀ഀഀ
     , [a].[LeadLastActivityDate]਍     Ⰰ 嬀愀崀⸀嬀䤀猀䄀挀琀椀瘀攀崀ഀഀ
     , [a].[Isvalid]਍     Ⰰ 嬀愀崀⸀嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
     , [a].[IsConsultFormComplete]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀匀琀愀琀甀猀崀ഀഀ
     , [a].[SourceKey]਍     Ⰰ 嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀ഀഀ
     , [a].[LeadSource]਍     Ⰰ 嬀愀崀⸀嬀䌀爀攀愀琀攀唀猀攀爀崀ഀഀ
     , [a].[LeadExternalID]਍     Ⰰ 嬀愀崀⸀嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀崀ഀഀ
     , [a].[LeadBirthday]਍     Ⰰ 䐀䄀吀䔀䐀䤀䘀䘀⠀夀䔀䄀刀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䈀椀爀琀栀搀愀礀崀Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀ 䄀匀 嬀䄀最攀崀ഀഀ
     , [a].[GCLID]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀渀最甀愀最攀崀ഀഀ
     , [a].[LeadGender]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀琀栀渀椀挀椀琀礀崀ഀഀ
     , [a].[NorwoodScale]਍     Ⰰ 嬀愀崀⸀嬀䰀甀搀眀椀最匀挀愀氀攀崀ഀഀ
     , [a].[LeadMaritalStatus]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀崀ഀഀ
     , [a].[DoNotContact]਍     Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䌀愀氀氀崀ഀഀ
     , [a].[DoNotText]਍     Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䔀洀愀椀氀崀ഀഀ
     , [a].[DoNotMail]਍     Ⰰ 嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀崀ഀഀ
     , [a].[ConvertedAccountId]਍     Ⰰ 嬀愀崀⸀嬀䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
     , 0਍     Ⰰ 　ഀഀ
     , [a].[AccountID]਍   䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䰀攀愀搀吀爀愀挀欀椀渀最崀 䄀匀 嬀愀崀ഀഀ
   WHERE DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) < CONVERT(਍                                                                                                                                              䐀䄀吀䔀ഀഀ
                                                                                                                                              , DATEADD(਍                                                                                                                                               搀ഀഀ
                                                                                                                                               , -( DAY(਍                                                                                                                                                   䜀䔀吀䐀䄀吀䔀⠀⤀ഀഀ
                                                                                                                                                   - 1))਍                                                                                                                                               Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀ഀഀ
                                                                                                                                              , 106))਍匀䔀䰀䔀䌀吀ഀഀ
    [a].[LeadKey]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 䄀匀 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀ഀഀ
  , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) AS [LeadCreatedDateEST]਍  Ⰰ 嬀愀崀⸀嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀 䄀匀 嬀挀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀ഀഀ
  , [a].[LeadId]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀崀 䄀匀 嬀䰀攀愀搀一愀洀攀崀ഀഀ
  , [a].[LeadLastName] AS [LeadLastName]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀 䄀匀 嬀䰀攀愀搀䘀甀氀氀一愀洀攀崀ഀഀ
  , [a].[LeadEmail]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀倀栀漀渀攀崀ഀഀ
  , [a].[LeadMobilePhone] AS [LeadMobilephone]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䈀椀爀琀栀搀愀礀崀ഀഀ
  , DATEDIFF(YEAR, [a].[LeadBirthday], GETDATE()) AS [Age]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀䬀攀礀崀 䄀匀 嬀䌀攀渀琀攀爀欀攀礀崀ഀഀ
  , [k].[CenterID]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀倀愀礀䜀爀漀甀瀀䤀䐀崀ഀഀ
  , [k].[CenterDescription]਍  Ⰰ 嬀欀崀⸀嬀䄀搀搀爀攀猀猀㄀崀ഀഀ
  , [k].[Address2]਍  Ⰰ 嬀欀崀⸀嬀䄀搀搀爀攀猀猀㌀崀ഀഀ
  , [k].[CenterGeographykey]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
  , [k].[CenterPhone1]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㈀崀ഀഀ
  , [k].[CenterPhone3]਍  Ⰰ 嬀欀崀⸀嬀倀栀漀渀攀㄀吀礀瀀攀䤀䐀崀ഀഀ
  , [k].[Phone2TypeID]਍  Ⰰ 嬀欀崀⸀嬀倀栀漀渀攀㌀吀礀瀀攀䤀䐀崀ഀഀ
  , [k].[IsActiveFlag]਍  Ⰰ 嬀欀崀⸀嬀䌀爀攀愀琀攀䐀愀琀攀崀ഀഀ
  , [k].[LastUpdate]਍  Ⰰ 嬀欀崀⸀嬀唀瀀搀愀琀攀匀琀愀洀瀀崀ഀഀ
  , [k].[CenterNumber]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀崀ഀഀ
  , [k].[CenterOwnershipSortOrder]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [k].[CenterOwnershipDescriptionShort]਍  Ⰰ 嬀欀崀⸀嬀伀眀渀攀爀䰀愀猀琀一愀洀攀崀ഀഀ
  , [k].[OwnerFirstName]਍  Ⰰ 嬀欀崀⸀嬀䌀漀爀瀀漀爀愀琀攀一愀洀攀崀ഀഀ
  , [k].[OwnershipAddress1]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䤀䐀崀ഀഀ
  , [k].[CenterTypeSortOrder]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [k].[CenterTypeDescriptionShort]਍  Ⰰ 䤀匀一唀䰀䰀⠀嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀䬀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
  , [b].[CampaignName] AS [OriginalCampaignName]਍  Ⰰ 嬀戀崀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 䄀匀 嬀伀爀椀最椀渀愀氀猀漀甀爀挀攀挀漀搀攀崀ഀഀ
  , [b].[CampaignType] AS [OriginalCampaignType]਍  Ⰰ 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀ഀഀ
  , [b].[CampaignSource] AS [OriginalCampaignOrigin]਍  Ⰰ 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䄀匀 嬀伀爀椀最椀渀愀氀挀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀ഀഀ
  , '' AS [OriginalCampaignFormat]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀ഀഀ
  , [a].[LastActivityDateKey]਍  Ⰰ 嬀攀崀⸀嬀䌀漀甀渀琀爀礀崀 䄀匀 嬀䰀攀愀搀䌀漀甀渀琀爀礀崀ഀഀ
  , [cg].[Country] AS [CenterCountry]਍  Ⰰ 嬀挀最崀⸀嬀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [cg].[DMACode]਍  Ⰰ 嬀挀最崀⸀嬀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀崀ഀഀ
  , [cg].[GeographyKey] AS [Geographykey]਍  Ⰰ 嬀攀崀⸀嬀一愀洀攀伀昀䌀椀琀礀伀爀伀刀䜀崀 䄀匀 嬀䰀攀愀搀䌀椀琀礀崀ഀഀ
  , [e].[FullNameOfStateOrTerritory] AS [LeadState]਍  Ⰰ 嬀愀崀⸀嬀䤀猀䄀挀琀椀瘀攀崀 䄀匀 嬀䤀猀愀挀琀椀瘀攀崀ഀഀ
  , [a].[Isvalid]਍  Ⰰ 嬀愀崀⸀嬀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀崀ഀഀ
  , [a].[LeadStatus]਍  Ⰰ 嬀愀崀⸀嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
  , ISNULL([Ag].[AgencyKey], -1) AS [Agencykey]਍  Ⰰ 嬀䄀最崀⸀嬀䄀最攀渀挀礀一愀洀攀崀ഀഀ
  , ISNULL([a].[SourceKey], -1) AS [SourceKey]਍  Ⰰ 嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀ഀഀ
  , ISNULL([a].[OriginalCommMethodkey], -1) AS [OriginalComMethodKey]਍  Ⰰ 䌀䄀匀䔀 圀䠀䔀一 䰀伀圀䔀刀⠀嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 䰀䤀䬀䔀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
        WHEN LOWER([b].[CampaignName]) LIKE '%gleam%' THEN 'Gleam Form'਍        圀䠀䔀一 嬀戀崀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 䰀䤀䬀䔀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 吀䠀䔀一 ✀匀栀漀瀀椀昀礀✀ഀഀ
        WHEN LOWER([sc].[SourceName]) IN ('call', 'phone', 'call center') THEN 'Phone Call'਍        圀䠀䔀一 䰀伀圀䔀刀⠀嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀⤀ 䤀一 ⠀✀戀漀猀爀攀昀✀Ⰰ ✀漀琀栀攀爀ⴀ戀漀猀✀⤀ 吀䠀䔀一 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
        WHEN [b].[SourceCode] LIKE 'DGPDSFACEIMAD14097%' THEN 'Facebook Messenger'਍        圀䠀䔀一 䰀伀圀䔀刀⠀嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀⤀ 䤀一 ⠀✀眀攀戀 昀漀爀洀✀⤀ഀഀ
         AND [b].[SourceCode] NOT LIKE 'DGEMAECOMECOM14000%'਍         䄀一䐀 䰀伀圀䔀刀⠀嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀一伀吀 䰀䤀䬀䔀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀ഀഀ
         AND LOWER([b].[CampaignName])NOT LIKE '%gleam%' THEN 'Appt Form'਍        圀䠀䔀一 ⠀ 嬀愀崀⸀嬀䰀攀愀搀匀漀甀爀挀攀崀 䤀匀 一唀䰀䰀 䄀一䐀 䰀伀圀䔀刀⠀嬀愀崀⸀嬀䌀爀攀愀琀攀唀猀攀爀崀⤀ 㴀 ✀戀漀猀氀攀礀椀渀琀攀最爀愀琀椀漀渀䀀栀愀椀爀挀氀甀戀⸀挀漀洀✀ ⤀ 伀刀 嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀 㴀 ✀䈀漀猀爀攀昀✀ 吀䠀䔀一 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
        WHEN LOWER([sc].[SourceName]) IN ('web chat', 'hairbot', 'hairclub app') THEN [sc].[SourceName]਍        䔀䰀匀䔀 ✀伀琀栀攀爀✀ഀഀ
    END AS [MarketingSource]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀砀琀攀爀渀愀氀䤀䐀崀 䄀匀 嬀䰀攀愀搀䔀砀琀攀爀渀愀氀䤀搀崀ഀഀ
  , [a].[GCLID]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀渀最甀愀最攀崀ഀഀ
  , [a].[LeadGender]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀琀栀渀椀挀椀琀礀崀ഀഀ
  , [a].[NorwoodScale]਍  Ⰰ 嬀愀崀⸀嬀䰀甀搀眀椀最匀挀愀氀攀崀ഀഀ
  , [a].[LeadMaritalStatus]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀崀ഀഀ
  , [a].[DoNotContact]਍  Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䌀愀氀氀崀ഀഀ
  , [a].[DoNotText]਍  Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䔀洀愀椀氀崀ഀഀ
  , [a].[DoNotMail]਍  Ⰰ 嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀崀ഀഀ
  , [a].[ConvertedAccountId] AS [convertedaccountid]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
  , [a].[LeadSource]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䘀椀爀猀琀一愀洀攀崀ഀഀ
  , [dt].[TimeOfDayKey] AS [TimeOfDayESTKey]਍  Ⰰ 嬀愀崀⸀嬀䤀猀䐀甀瀀氀椀挀愀琀攀䈀礀䔀洀愀椀氀崀 䄀匀 嬀椀猀搀甀瀀氀椀挀愀琀攀戀礀攀洀愀椀氀崀ഀഀ
  , [a].[IsDuplicateByName] AS [isduplicatebyname]਍  Ⰰ 䤀匀一唀䰀䰀⠀嬀愀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀搀崀⸀嬀䄀挀挀漀甀渀琀䔀砀琀攀爀渀愀氀䤀搀崀⤀ 䄀匀 嬀䰀攀愀搀䤀搀䔀砀琀攀爀渀愀氀崀ഀഀ
  , [a].[LeadExternalID] AS [RealExternalId]਍䘀刀伀䴀 嬀搀椀洀䰀攀愀搀开䌀吀䔀崀 䄀匀 嬀愀崀ഀഀ
LEFT JOIN [dbo].[DimCampaign] AS [b] ON [a].[OriginalCampaignKey] = [b].[CampaignKey]਍ⴀⴀ氀攀昀琀 樀漀椀渀 搀椀洀搀愀琀攀 搀 漀渀 愀⸀氀攀愀搀开挀爀攀愀琀攀搀搀愀琀攀㴀搀⸀搀愀琀攀欀攀礀ഀഀ
LEFT JOIN [dbo].[DimGeography] AS [e] ON [a].[geographykey] = [e].[GeographyKey]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 䄀匀 嬀欀崀 伀一 嬀愀崀⸀嬀挀攀渀琀攀爀欀攀礀崀 㴀 嬀欀崀⸀嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
LEFT JOIN [dbo].[DimGeography] AS [cg] ON [k].[CenterGeographykey] = [cg].[GeographyKey]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䄀最攀渀挀礀崀 䄀匀 嬀䄀最崀 伀一 嬀戀崀⸀嬀䄀最攀渀挀礀䬀攀礀崀 㴀 嬀䄀最崀⸀嬀䄀最攀渀挀礀䬀攀礀崀ഀഀ
LEFT JOIN [dbo].[DimSource] AS [sc] ON [a].[SourceKey] = [sc].[SourceKey]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀 䄀匀 嬀搀琀崀 伀一 嬀搀琀崀⸀嬀吀椀洀攀㈀㐀崀 㴀 䌀伀一嘀䔀刀吀⠀吀䤀䴀䔀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀崀⤀ഀഀ
LEFT JOIN [dbo].[DimAccount] AS [d] ON [a].[AccountID] = [d].[AccountId];਍䜀伀ഀഀ
