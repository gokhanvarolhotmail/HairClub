/****** Object:  View [dbo].[VWLead]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀ഀഀ
AS select   LeadKey,LeadCreatedDate LeadCreatedDateUTC,dateadd(mi,datepart(tz,CONVERT(datetime,LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),LeadCreatedDate) LeadCreatedDateEST, createdDateKey, a.LeadId,a.LeadName LeadName,LeadLastName LeadLastName, ਍䰀攀愀搀䘀甀氀氀一愀洀攀 䰀攀愀搀䘀甀氀氀一愀洀攀Ⰰ愀⸀䰀攀愀搀䔀洀愀椀氀Ⰰ愀⸀䰀攀愀搀倀栀漀渀攀Ⰰ愀⸀䰀攀愀搀䴀漀戀椀氀攀瀀栀漀渀攀Ⰰ ഀഀ
  LeadBirthday,datediff(year,LeadBirthday,getdate())Age,k.Centerkey਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
      ,k.[CenterPayGroupID]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
      ,k.[Address1]਍      Ⰰ欀⸀嬀䄀搀搀爀攀猀猀㈀崀ഀഀ
      ,k.[Address3]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀䜀攀漀最爀愀瀀栀礀欀攀礀崀ഀഀ
      ,k.[CenterPostalCode]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㄀崀ഀഀ
      ,k.[CenterPhone2]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㌀崀ഀഀ
      ,k.[Phone1TypeID]਍      Ⰰ欀⸀嬀倀栀漀渀攀㈀吀礀瀀攀䤀䐀崀ഀഀ
      ,k.[Phone3TypeID]਍      Ⰰ欀⸀嬀䤀猀䄀挀琀椀瘀攀䘀氀愀最崀ഀഀ
      ,k.[CreateDate]਍      Ⰰ欀⸀嬀䰀愀猀琀唀瀀搀愀琀攀崀ഀഀ
      ,k.[UpdateStamp]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
      ,k.[CenterOwnershipID]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀匀漀爀琀伀爀搀攀爀崀ഀഀ
      ,k.[CenterOwnershipDescription]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀ഀഀ
      ,k.[OwnerLastName]਍      Ⰰ欀⸀嬀伀眀渀攀爀䘀椀爀猀琀一愀洀攀崀ഀഀ
      ,k.[CorporateName]਍      Ⰰ欀⸀嬀伀眀渀攀爀猀栀椀瀀䄀搀搀爀攀猀猀㄀崀ഀഀ
      ,k.[CenterTypeID]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀匀漀爀琀伀爀搀攀爀崀ഀഀ
      ,k.[CenterTypeDescription]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀Ⰰ椀猀渀甀氀氀⠀戀⸀䌀愀洀瀀愀椀最渀䬀攀礀Ⰰⴀ㄀⤀ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䬀攀礀Ⰰ戀⸀䌀愀洀瀀愀椀最渀一愀洀攀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀Ⰰ伀爀椀最椀渀愀氀匀漀甀爀挀攀䌀漀搀攀Ⰰഀഀ
  b.CampaignType OriginalCampaignType,b.CampaignMedia OriginalCampaignMedia,b.CampaignSource OriginalCampaignOrigin,b.CampaignLocation OriginalcampaignLocation,਍  戀⸀挀愀洀瀀愀椀最渀昀漀爀洀愀琀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀Ⰰ䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀Ⰰ ഀഀ
  c.CampaignKey RecentCampaignKey,c.CampaignName RecentCampaignName, c.CampaignType RecentCampaignType,c.CampaignMedia RecentCampaignMedia,c.CampaignSource RecentCampaignOrigin,c.CampaignLocation RecentCampaignLocation,਍  挀⸀挀愀洀瀀愀椀最渀昀漀爀洀愀琀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀Ⰰഀഀ
  e.country LeadCountry,cg.country CenterCountry,cg.DMADescription,cg.DMACode,cg.DMAMarketRegion,cg.Geographykey,e.[NameOfCityOrORG] LeadCity,e.[FullNameOfStateOrTerritory] LeadState, ਍  愀⸀䤀猀愀挀琀椀瘀攀Ⰰ愀⸀䤀猀瘀愀氀椀搀Ⰰ愀⸀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀Ⰰ䰀攀愀搀匀琀愀琀甀猀Ⰰ愀⸀䤀猀䐀攀氀攀琀攀搀Ⰰ椀猀渀甀氀氀⠀愀最⸀䄀最攀渀挀礀䬀攀礀Ⰰⴀ㄀⤀ 䄀最攀渀挀礀欀攀礀Ⰰ愀最⸀䄀最攀渀挀礀一愀洀攀Ⰰ椀猀渀甀氀氀⠀愀⸀匀漀甀爀挀攀䬀攀礀Ⰰⴀ㄀⤀ 匀漀甀爀挀攀䬀攀礀Ⰰ猀挀⸀匀漀甀爀挀攀一愀洀攀Ⰰ椀猀渀甀氀氀⠀愀⸀嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀Ⰰⴀ㄀⤀ 伀爀椀最椀渀愀氀䌀漀洀䴀攀琀栀漀搀䬀攀礀Ⰰഀഀ
	  case ਍ऀ眀栀攀渀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 氀椀欀攀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀  琀栀攀渀 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
	when lower(b.[CampaignName]) like '%gleam%'  then 'Gleam Form'਍ऀ眀栀攀渀 戀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 琀栀攀渀 ✀匀栀漀瀀椀昀礀✀ഀഀ
	when lower(sc.SourceName) in ('call','phone','call center') then 'Phone Call'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀戀漀猀爀攀昀✀Ⰰ✀漀琀栀攀爀ⴀ戀漀猀✀⤀ 琀栀攀渀 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
	when b.[SourceCode] like 'DGPDSFACEIMAD14097%' then 'Facebook Messenger'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀眀攀戀 昀漀爀洀✀⤀ 愀渀搀 戀⸀匀漀甀爀挀攀䌀漀搀攀 渀漀琀  氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 愀渀搀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 渀漀琀 氀椀欀攀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀ 愀渀搀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 渀漀琀 氀椀欀攀 ✀─最氀攀愀洀─✀   琀栀攀渀 ✀䄀瀀瀀琀 䘀漀爀洀✀ഀഀ
	when (a.LeadSource is null and lower(a.CreateUser)='bosleyintegration@hairclub.com') or sc.SourceName='Bosref' then 'Bosley API'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀眀攀戀 挀栀愀琀✀Ⰰ✀栀愀椀爀戀漀琀✀Ⰰ✀栀愀椀爀挀氀甀戀 愀瀀瀀✀⤀ 琀栀攀渀 猀挀⸀匀漀甀爀挀攀一愀洀攀ഀഀ
	else 'Other'਍攀渀搀 䴀愀爀欀攀琀椀渀最匀漀甀爀挀攀   ऀ ഀഀ
    from dbo.dimLead a਍  氀攀昀琀 樀漀椀渀 搀椀洀䌀愀洀瀀愀椀最渀 戀 漀渀 愀⸀漀爀椀最椀渀愀氀挀愀洀瀀愀椀最渀欀攀礀㴀戀⸀挀愀洀瀀愀椀最渀欀攀礀ഀഀ
  left join dimCampaign c on a.recentcampaignkey=c.campaignkey਍  ⴀⴀ氀攀昀琀 樀漀椀渀 搀椀洀搀愀琀攀 搀 漀渀 愀⸀氀攀愀搀开挀爀攀愀琀攀搀搀愀琀攀㴀搀⸀搀愀琀攀欀攀礀ഀഀ
  left join dimgeography e on a.geographykey=e.geographykey਍  氀攀昀琀 樀漀椀渀 搀椀洀䌀攀渀琀攀爀 欀 漀渀 愀⸀挀攀渀琀攀爀欀攀礀㴀欀⸀挀攀渀琀攀爀欀攀礀ഀഀ
  left join dimgeography cg on k.Centergeographykey=cg.geographykey਍  氀攀昀琀 樀漀椀渀 搀椀洀䄀最攀渀挀礀 䄀最 漀渀 戀⸀䄀最攀渀挀礀䬀攀礀㴀愀最⸀䄀最攀渀挀礀䬀攀礀ഀഀ
  left join dimSource  sc on a.sourceKey=sc.sourcekey;਍䜀伀ഀഀ
