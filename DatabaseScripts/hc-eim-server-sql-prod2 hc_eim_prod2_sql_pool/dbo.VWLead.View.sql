/****** Object:  View [dbo].[VWLead]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 圀䤀吀䠀 嬀搀椀洀䰀攀愀搀开䌀吀䔀崀ഀഀ
AS (਍   匀䔀䰀䔀䌀吀ഀഀ
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
     , [a].[IsDuplicateByEmail]਍     Ⰰ 嬀愀崀⸀嬀䤀猀䐀甀瀀氀椀挀愀琀攀䈀礀一愀洀攀崀ഀഀ
     , [a].[AccountID]਍   䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 䄀匀 嬀愀崀ഀഀ
   WHERE DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) >= CONVERT(਍                                                                                                                                               䐀䄀吀䔀ഀഀ
                                                                                                                                               , DATEADD(਍                                                                                                                                                搀ഀഀ
                                                                                                                                                , -( DAY(਍                                                                                                                                                    䜀䔀吀䐀䄀吀䔀⠀⤀ഀഀ
                                                                                                                                                    - 1))਍                                                                                                                                                Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀ഀഀ
                                                                                                                                               , 106)਍   唀一䤀伀一 䄀䰀䰀ഀഀ
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
     , [a].[LeadPostalCode]਍     Ⰰ 　ഀഀ
     , 0਍     Ⰰ 嬀愀崀⸀嬀䄀挀挀漀甀渀琀䤀䐀崀ഀഀ
   FROM [dbo].[FactLeadTracking] AS [a]਍   圀䠀䔀刀䔀 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀ 㰀 䌀伀一嘀䔀刀吀⠀ഀഀ
                                                                                                                                              DATE਍                                                                                                                                              Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀ഀഀ
                                                                                                                                               d਍                                                                                                                                               Ⰰ ⴀ⠀ 䐀䄀夀⠀ഀഀ
                                                                                                                                                   GETDATE()਍                                                                                                                                                   ⴀ ㄀⤀⤀ഀഀ
                                                                                                                                               , GETDATE())਍                                                                                                                                              Ⰰ ㄀　㘀⤀⤀ഀഀ
SELECT਍    嬀愀崀⸀嬀䰀攀愀搀䬀攀礀崀ഀഀ
  , [a].[LeadCreatedDate] AS [LeadCreatedDateUTC]਍  Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀洀椀Ⰰ 䐀䄀吀䔀倀䄀刀吀⠀琀稀Ⰰ 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀ 䄀匀 嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀崀ഀഀ
  , [a].[CreatedDateKey] AS [createdDateKey]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
  , [a].[LeadFirstName] AS [LeadName]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䰀愀猀琀一愀洀攀崀 䄀匀 嬀䰀攀愀搀䰀愀猀琀一愀洀攀崀ഀഀ
  , [a].[LeadFullName] AS [LeadFullName]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀洀愀椀氀崀ഀഀ
  , [a].[LeadPhone]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀崀 䄀匀 嬀䰀攀愀搀䴀漀戀椀氀攀瀀栀漀渀攀崀ഀഀ
  , [a].[LeadBirthday]਍  Ⰰ 䐀䄀吀䔀䐀䤀䘀䘀⠀夀䔀䄀刀Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䈀椀爀琀栀搀愀礀崀Ⰰ 䜀䔀吀䐀䄀吀䔀⠀⤀⤀ 䄀匀 嬀䄀最攀崀ഀഀ
  , [k].[CenterKey] AS [Centerkey]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
  , [k].[CenterPayGroupID]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [k].[Address1]਍  Ⰰ 嬀欀崀⸀嬀䄀搀搀爀攀猀猀㈀崀ഀഀ
  , [k].[Address3]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀䜀攀漀最爀愀瀀栀礀欀攀礀崀ഀഀ
  , [k].[CenterPostalCode]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㄀崀ഀഀ
  , [k].[CenterPhone2]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㌀崀ഀഀ
  , [k].[Phone1TypeID]਍  Ⰰ 嬀欀崀⸀嬀倀栀漀渀攀㈀吀礀瀀攀䤀䐀崀ഀഀ
  , [k].[Phone3TypeID]਍  Ⰰ 嬀欀崀⸀嬀䤀猀䄀挀琀椀瘀攀䘀氀愀最崀ഀഀ
  , [k].[CreateDate]਍  Ⰰ 嬀欀崀⸀嬀䰀愀猀琀唀瀀搀愀琀攀崀ഀഀ
  , [k].[UpdateStamp]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
  , [k].[CenterOwnershipID]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀匀漀爀琀伀爀搀攀爀崀ഀഀ
  , [k].[CenterOwnershipDescription]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀ഀഀ
  , [k].[OwnerLastName]਍  Ⰰ 嬀欀崀⸀嬀伀眀渀攀爀䘀椀爀猀琀一愀洀攀崀ഀഀ
  , [k].[CorporateName]਍  Ⰰ 嬀欀崀⸀嬀伀眀渀攀爀猀栀椀瀀䄀搀搀爀攀猀猀㄀崀ഀഀ
  , [k].[CenterTypeID]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀吀礀瀀攀匀漀爀琀伀爀搀攀爀崀ഀഀ
  , [k].[CenterTypeDescription]਍  Ⰰ 嬀欀崀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀ഀഀ
  , ISNULL([b].[CampaignKey], -1) AS [OriginalCampaignKey]਍  Ⰰ 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀崀ഀഀ
  , [b].[SourceCode] AS [Originalsourcecode]਍  Ⰰ 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀吀礀瀀攀崀 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀吀礀瀀攀崀ഀഀ
  , [b].[CampaignMedia] AS [OriginalCampaignMedia]਍  Ⰰ 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀伀爀椀最椀渀崀ഀഀ
  , [b].[CampaignLocation] AS [OriginalcampaignLocation]਍  Ⰰ ✀✀ 䄀匀 嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
  , [a].[LeadLastActivityDate]਍  Ⰰ 嬀愀崀⸀嬀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀崀ഀഀ
  , [e].[Country] AS [LeadCountry]਍  Ⰰ 嬀挀最崀⸀嬀䌀漀甀渀琀爀礀崀 䄀匀 嬀䌀攀渀琀攀爀䌀漀甀渀琀爀礀崀ഀഀ
  , [cg].[DMADescription]਍  Ⰰ 嬀挀最崀⸀嬀䐀䴀䄀䌀漀搀攀崀ഀഀ
  , [cg].[DMAMarketRegion]਍  Ⰰ 嬀挀最崀⸀嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀 䄀匀 嬀䜀攀漀最爀愀瀀栀礀欀攀礀崀ഀഀ
  , [e].[NameOfCityOrORG] AS [LeadCity]਍  Ⰰ 嬀攀崀⸀嬀䘀甀氀氀一愀洀攀伀昀匀琀愀琀攀伀爀吀攀爀爀椀琀漀爀礀崀 䄀匀 嬀䰀攀愀搀匀琀愀琀攀崀ഀഀ
  , [a].[IsActive] AS [Isactive]਍  Ⰰ 嬀愀崀⸀嬀䤀猀瘀愀氀椀搀崀ഀഀ
  , [a].[IsConsultFormComplete]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀匀琀愀琀甀猀崀ഀഀ
  , [a].[IsDeleted]਍  Ⰰ 䤀匀一唀䰀䰀⠀嬀䄀最崀⸀嬀䄀最攀渀挀礀䬀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀䄀最攀渀挀礀欀攀礀崀ഀഀ
  , [Ag].[AgencyName]਍  Ⰰ 䤀匀一唀䰀䰀⠀嬀愀崀⸀嬀匀漀甀爀挀攀䬀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀匀漀甀爀挀攀䬀攀礀崀ഀഀ
  , [sc].[SourceName]਍  Ⰰ 䤀匀一唀䰀䰀⠀嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀Ⰰ ⴀ㄀⤀ 䄀匀 嬀伀爀椀最椀渀愀氀䌀漀洀䴀攀琀栀漀搀䬀攀礀崀ഀഀ
  , CASE WHEN LOWER([b].[CampaignName]) LIKE '%leads-ads%' THEN 'Facebook'਍        圀䠀䔀一 䰀伀圀䔀刀⠀嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 䰀䤀䬀䔀 ✀─最氀攀愀洀─✀ 吀䠀䔀一 ✀䜀氀攀愀洀 䘀漀爀洀✀ഀഀ
        WHEN [b].[SourceCode] LIKE 'DGEMAECOMECOM14000%' THEN 'Shopify'਍        圀䠀䔀一 䰀伀圀䔀刀⠀嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀⤀ 䤀一 ⠀✀挀愀氀氀✀Ⰰ ✀瀀栀漀渀攀✀Ⰰ ✀挀愀氀氀 挀攀渀琀攀爀✀⤀ 吀䠀䔀一 ✀倀栀漀渀攀 䌀愀氀氀✀ഀഀ
        WHEN LOWER([sc].[SourceName]) IN ('bosref', 'other-bos') THEN 'Bosley API'਍        圀䠀䔀一 嬀戀崀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 䰀䤀䬀䔀 ✀䐀䜀倀䐀匀䘀䄀䌀䔀䤀䴀䄀䐀㄀㐀　㤀㜀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀 䴀攀猀猀攀渀最攀爀✀ഀഀ
        WHEN LOWER([sc].[SourceName]) IN ('web form')਍         䄀一䐀 嬀戀崀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 一伀吀 䰀䤀䬀䔀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ഀഀ
         AND LOWER([b].[CampaignName])NOT LIKE '%leads-ads%'਍         䄀一䐀 䰀伀圀䔀刀⠀嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀一伀吀 䰀䤀䬀䔀 ✀─最氀攀愀洀─✀ 吀䠀䔀一 ✀䄀瀀瀀琀 䘀漀爀洀✀ഀഀ
        WHEN ( [a].[LeadSource] IS NULL AND LOWER([a].[CreateUser]) = 'bosleyintegration@hairclub.com' ) OR [sc].[SourceName] = 'Bosref' THEN 'Bosley API'਍        圀䠀䔀一 䰀伀圀䔀刀⠀嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀⤀ 䤀一 ⠀✀眀攀戀 挀栀愀琀✀Ⰰ ✀栀愀椀爀戀漀琀✀Ⰰ ✀栀愀椀爀挀氀甀戀 愀瀀瀀✀⤀ 吀䠀䔀一 嬀猀挀崀⸀嬀匀漀甀爀挀攀一愀洀攀崀ഀഀ
        ELSE 'Other'਍    䔀一䐀 䄀匀 嬀䴀愀爀欀攀琀椀渀最匀漀甀爀挀攀崀ഀഀ
  , [a].[LeadExternalID] AS [LeadExternalId]਍  Ⰰ 嬀愀崀⸀嬀䜀䌀䰀䤀䐀崀ഀഀ
  , [a].[LeadLanguage]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䜀攀渀搀攀爀崀ഀഀ
  , [a].[LeadEthnicity]਍  Ⰰ 嬀愀崀⸀嬀一漀爀眀漀漀搀匀挀愀氀攀崀ഀഀ
  , [a].[LudwigScale]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀ഀഀ
  , [a].[LeadOccupation]਍  Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䌀漀渀琀愀挀琀崀ഀഀ
  , [a].[DoNotCall]਍  Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀吀攀砀琀崀ഀഀ
  , [a].[DoNotEmail]਍  Ⰰ 嬀愀崀⸀嬀䐀漀一漀琀䴀愀椀氀崀ഀഀ
  , [a].[OriginalCampaignId]਍  Ⰰ 嬀愀崀⸀嬀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀崀 䄀匀 嬀挀漀渀瘀攀爀琀攀搀愀挀挀漀甀渀琀椀搀崀ഀഀ
  , [a].[LeadPostalCode]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀匀漀甀爀挀攀崀ഀഀ
  , [a].[LeadFirstName]਍  Ⰰ 嬀搀琀崀⸀嬀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 䄀匀 嬀吀椀洀攀伀昀䐀愀礀䔀匀吀䬀攀礀崀ഀഀ
  , [a].[IsDuplicateByEmail] AS [isduplicatebyemail]਍  Ⰰ 嬀愀崀⸀嬀䤀猀䐀甀瀀氀椀挀愀琀攀䈀礀一愀洀攀崀 䄀匀 嬀椀猀搀甀瀀氀椀挀愀琀攀戀礀渀愀洀攀崀ഀഀ
  , ISNULL([a].[LeadId], [d].[AccountExternalId]) AS [LeadIdExternal]਍  Ⰰ 嬀愀崀⸀嬀䰀攀愀搀䔀砀琀攀爀渀愀氀䤀䐀崀 䄀匀 嬀刀攀愀氀䔀砀琀攀爀渀愀氀䤀搀崀ഀഀ
FROM [dimLead_CTE] AS [a]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀愀洀瀀愀椀最渀崀 䄀匀 嬀戀崀 伀一 嬀愀崀⸀嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀崀 㴀 嬀戀崀⸀嬀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
--left join dimdate d on a.lead_createddate=d.datekey਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䜀攀漀最爀愀瀀栀礀崀 䄀匀 嬀攀崀 伀一 嬀愀崀⸀嬀最攀漀最爀愀瀀栀礀欀攀礀崀 㴀 嬀攀崀⸀嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀ഀഀ
LEFT JOIN [dbo].[DimCenter] AS [k] ON [a].[centerkey] = [k].[CenterKey]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䜀攀漀最爀愀瀀栀礀崀 䄀匀 嬀挀最崀 伀一 嬀欀崀⸀嬀䌀攀渀琀攀爀䜀攀漀最爀愀瀀栀礀欀攀礀崀 㴀 嬀挀最崀⸀嬀䜀攀漀最爀愀瀀栀礀䬀攀礀崀ഀഀ
LEFT JOIN [dbo].[DimAgency] AS [Ag] ON [b].[AgencyKey] = [Ag].[AgencyKey]਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀匀漀甀爀挀攀崀 䄀匀 嬀猀挀崀 伀一 嬀愀崀⸀嬀匀漀甀爀挀攀䬀攀礀崀 㴀 嬀猀挀崀⸀嬀匀漀甀爀挀攀䬀攀礀崀ഀഀ
LEFT JOIN [dbo].[DimTimeOfDay] AS [dt] ON [dt].[Time24] = CONVERT(TIME, [a].[LeadCreatedDateEST])਍䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䄀挀挀漀甀渀琀崀 䄀匀 嬀搀崀 伀一 嬀愀崀⸀嬀䄀挀挀漀甀渀琀䤀䐀崀 㴀 嬀搀崀⸀嬀䄀挀挀漀甀渀琀䤀搀崀㬀ഀഀ
GO਍
