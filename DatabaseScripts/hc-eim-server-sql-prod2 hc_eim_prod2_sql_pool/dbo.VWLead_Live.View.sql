/****** Object:  View [dbo].[VWLead_Live]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀开䰀椀瘀攀崀ഀഀ
AS With dimLead_CTE as਍⠀猀攀氀攀挀琀 䰀攀愀搀䬀攀礀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀Ⰰ 挀爀攀愀琀攀搀䐀愀琀攀䬀攀礀Ⰰ 愀⸀䰀攀愀搀䤀搀Ⰰ愀⸀䰀攀愀搀䘀椀爀猀琀一愀洀攀 䰀攀愀搀一愀洀攀Ⰰ䰀攀愀搀䰀愀猀琀一愀洀攀 䰀攀愀搀䰀愀猀琀一愀洀攀Ⰰ ഀഀ
LeadFullName LeadFullName,a.LeadEmail,a.LeadPhone,a.LeadMobilephone, OriginalCampaignKey,geographykey,centerkey,LeadCreatedDate,LeadFirstName,LeadLastActivityDate,Isactive, Isvalid, Isdeleted,IsConsultFormComplete,਍䰀攀愀搀匀琀愀琀甀猀Ⰰ匀漀甀爀挀攀䬀攀礀Ⰰ伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀Ⰰ䰀攀愀搀匀漀甀爀挀攀Ⰰ䌀爀攀愀琀攀唀猀攀爀Ⰰ䰀攀愀搀䔀砀琀攀爀渀愀氀䤀搀Ⰰ䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀䬀攀礀Ⰰഀഀ
  LeadBirthday,datediff(year,LeadBirthday,getdate())Age,GCLID,LeadLanguage,LeadGender,LeadEthnicity,NorwoodScale,LudwigScale,LeadMaritalStatus,਍ 䰀攀愀搀伀挀挀甀瀀愀琀椀漀渀Ⰰ䐀漀一漀琀䌀漀渀琀愀挀琀Ⰰ䐀漀一漀琀䌀愀氀氀Ⰰ䐀漀一漀琀吀攀砀琀Ⰰ䐀漀一漀琀䔀洀愀椀氀Ⰰ䐀漀一漀琀䴀愀椀氀Ⰰ伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀Ⰰ挀漀渀瘀攀爀琀攀搀愀挀挀漀甀渀琀椀搀Ⰰ䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀Ⰰ椀猀搀甀瀀氀椀挀愀琀攀戀礀攀洀愀椀氀Ⰰ椀猀搀甀瀀氀椀挀愀琀攀戀礀渀愀洀攀Ⰰ愀⸀愀挀挀漀甀渀琀椀搀 昀爀漀洀 搀椀洀氀攀愀搀 愀ഀഀ
  )਍ 猀攀氀攀挀琀   䰀攀愀搀䬀攀礀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀Ⰰ 愀⸀挀爀攀愀琀攀搀䐀愀琀攀䬀攀礀Ⰰ 愀⸀䰀攀愀搀䤀搀Ⰰ愀⸀䰀攀愀搀䘀椀爀猀琀一愀洀攀 䰀攀愀搀一愀洀攀Ⰰ䰀攀愀搀䰀愀猀琀一愀洀攀 䰀攀愀搀䰀愀猀琀一愀洀攀Ⰰ ഀഀ
LeadFullName LeadFullName,a.LeadEmail,a.LeadPhone,a.LeadMobilephone, ਍  䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ搀愀琀攀搀椀昀昀⠀礀攀愀爀Ⰰ䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ最攀琀搀愀琀攀⠀⤀⤀䄀最攀Ⰰ欀⸀䌀攀渀琀攀爀欀攀礀ഀഀ
      ,k.[CenterID]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀倀愀礀䜀爀漀甀瀀䤀䐀崀ഀഀ
      ,k.[CenterDescription]਍      Ⰰ欀⸀嬀䄀搀搀爀攀猀猀㄀崀ഀഀ
      ,k.[Address2]਍      Ⰰ欀⸀嬀䄀搀搀爀攀猀猀㌀崀ഀഀ
      ,k.[CenterGeographykey]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
      ,k.[CenterPhone1]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀倀栀漀渀攀㈀崀ഀഀ
      ,k.[CenterPhone3]਍      Ⰰ欀⸀嬀倀栀漀渀攀㄀吀礀瀀攀䤀䐀崀ഀഀ
      ,k.[Phone2TypeID]਍      Ⰰ欀⸀嬀倀栀漀渀攀㌀吀礀瀀攀䤀䐀崀ഀഀ
      ,k.[IsActiveFlag]਍      Ⰰ欀⸀嬀䌀爀攀愀琀攀䐀愀琀攀崀ഀഀ
      ,k.[LastUpdate]਍      Ⰰ欀⸀嬀唀瀀搀愀琀攀匀琀愀洀瀀崀ഀഀ
      ,k.[CenterNumber]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀崀ഀഀ
      ,k.[CenterOwnershipSortOrder]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
      ,k.[CenterOwnershipDescriptionShort]਍      Ⰰ欀⸀嬀伀眀渀攀爀䰀愀猀琀一愀洀攀崀ഀഀ
      ,k.[OwnerFirstName]਍      Ⰰ欀⸀嬀䌀漀爀瀀漀爀愀琀攀一愀洀攀崀ഀഀ
      ,k.[OwnershipAddress1]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䤀䐀崀ഀഀ
      ,k.[CenterTypeSortOrder]਍      Ⰰ欀⸀嬀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
      ,k.[CenterTypeDescriptionShort],isnull(b.CampaignKey,-1) OriginalCampaignKey,b.CampaignName OriginalCampaignName,b.SourceCode Originalsourcecode,਍  戀⸀䌀愀洀瀀愀椀最渀吀礀瀀攀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀吀礀瀀攀Ⰰ戀⸀䌀愀洀瀀愀椀最渀䴀攀搀椀愀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䴀攀搀椀愀Ⰰ戀⸀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀伀爀椀最椀渀Ⰰ戀⸀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀 伀爀椀最椀渀愀氀挀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀Ⰰഀഀ
  '' OriginalCampaignFormat,LeadLastActivityDate,LastActivityDateKey, e.country LeadCountry,cg.country CenterCountry,cg.DMADescription,cg.DMACode,cg.DMAMarketRegion,cg.Geographykey,e.[NameOfCityOrORG] LeadCity,e.[FullNameOfStateOrTerritory] LeadState, ਍  愀⸀䤀猀愀挀琀椀瘀攀Ⰰ愀⸀䤀猀瘀愀氀椀搀Ⰰ愀⸀䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀Ⰰ䰀攀愀搀匀琀愀琀甀猀Ⰰ愀⸀䤀猀䐀攀氀攀琀攀搀Ⰰ椀猀渀甀氀氀⠀愀最⸀䄀最攀渀挀礀䬀攀礀Ⰰⴀ㄀⤀ 䄀最攀渀挀礀欀攀礀Ⰰ愀最⸀䄀最攀渀挀礀一愀洀攀Ⰰ椀猀渀甀氀氀⠀愀⸀匀漀甀爀挀攀䬀攀礀Ⰰⴀ㄀⤀ 匀漀甀爀挀攀䬀攀礀Ⰰ猀挀⸀匀漀甀爀挀攀一愀洀攀Ⰰ椀猀渀甀氀氀⠀愀⸀嬀伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀崀Ⰰⴀ㄀⤀ 伀爀椀最椀渀愀氀䌀漀洀䴀攀琀栀漀搀䬀攀礀Ⰰഀഀ
	  case ਍ऀ眀栀攀渀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 氀椀欀攀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀  琀栀攀渀 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
	when lower(b.[CampaignName]) like '%gleam%'  then 'Gleam Form'਍ऀ眀栀攀渀 戀⸀嬀匀漀甀爀挀攀䌀漀搀攀崀 氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 琀栀攀渀 ✀匀栀漀瀀椀昀礀✀ഀഀ
	when lower(sc.SourceName) in ('call','phone','call center') then 'Phone Call'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀戀漀猀爀攀昀✀Ⰰ✀漀琀栀攀爀ⴀ戀漀猀✀⤀ 琀栀攀渀 ✀䈀漀猀氀攀礀 䄀倀䤀✀ഀഀ
	when b.[SourceCode] like 'DGPDSFACEIMAD14097%' then 'Facebook Messenger'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀眀攀戀 昀漀爀洀✀⤀ 愀渀搀 戀⸀匀漀甀爀挀攀䌀漀搀攀 渀漀琀  氀椀欀攀 ✀䐀䜀䔀䴀䄀䔀䌀伀䴀䔀䌀伀䴀㄀㐀　　　─✀ 愀渀搀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 渀漀琀 氀椀欀攀 ✀─氀攀愀搀猀ⴀ愀搀猀─✀ 愀渀搀 氀漀眀攀爀⠀戀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀⤀ 渀漀琀 氀椀欀攀 ✀─最氀攀愀洀─✀   琀栀攀渀 ✀䄀瀀瀀琀 䘀漀爀洀✀ഀഀ
	when (a.LeadSource is null and lower(a.CreateUser)='bosleyintegration@hairclub.com') or sc.SourceName='Bosref' then 'Bosley API'਍ऀ眀栀攀渀 氀漀眀攀爀⠀猀挀⸀匀漀甀爀挀攀一愀洀攀⤀ 椀渀 ⠀✀眀攀戀 挀栀愀琀✀Ⰰ✀栀愀椀爀戀漀琀✀Ⰰ✀栀愀椀爀挀氀甀戀 愀瀀瀀✀⤀ 琀栀攀渀 猀挀⸀匀漀甀爀挀攀一愀洀攀ഀഀ
	else 'Other'਍攀渀搀 䴀愀爀欀攀琀椀渀最匀漀甀爀挀攀  Ⰰ 䰀攀愀搀䔀砀琀攀爀渀愀氀䤀搀Ⰰ 愀⸀䜀䌀䰀䤀䐀Ⰰ愀⸀䰀攀愀搀䰀愀渀最甀愀最攀Ⰰ愀⸀䰀攀愀搀䜀攀渀搀攀爀Ⰰ愀⸀䰀攀愀搀䔀琀栀渀椀挀椀琀礀Ⰰ愀⸀一漀爀眀漀漀搀匀挀愀氀攀Ⰰ愀⸀䰀甀搀眀椀最匀挀愀氀攀Ⰰ愀⸀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀Ⰰഀഀ
 a.LeadOccupation,a.DoNotContact,a.DoNotCall,a.DoNotText,a.DoNotEmail,a.DoNotMail,a.OriginalCampaignId,a.convertedaccountid,LeadPostalCode,LeadSource,LeadFirstName,[TimeOfDayKey] as TimeOfDayESTKey,isduplicatebyemail,isduplicatebyname,isnull(a.LeadId,d.AccountExternalId) as LeadIdExternal	 ਍    昀爀漀洀 䐀椀洀䰀攀愀搀开䌀吀䔀 愀ഀഀ
  left join dimCampaign b on a.originalcampaignkey=b.campaignkey਍  ⴀⴀ氀攀昀琀 樀漀椀渀 搀椀洀搀愀琀攀 搀 漀渀 愀⸀氀攀愀搀开挀爀攀愀琀攀搀搀愀琀攀㴀搀⸀搀愀琀攀欀攀礀ഀഀ
  left join dimgeography e on a.geographykey=e.geographykey਍  氀攀昀琀 樀漀椀渀 搀椀洀䌀攀渀琀攀爀 欀 漀渀 愀⸀挀攀渀琀攀爀欀攀礀㴀欀⸀挀攀渀琀攀爀欀攀礀ഀഀ
  left join dimgeography cg on k.Centergeographykey=cg.geographykey਍  氀攀昀琀 樀漀椀渀 搀椀洀䄀最攀渀挀礀 䄀最 漀渀 戀⸀䄀最攀渀挀礀䬀攀礀㴀愀最⸀䄀最攀渀挀礀䬀攀礀ഀഀ
  left join dimSource  sc on a.sourceKey=sc.sourcekey਍  氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀 搀琀 漀渀 搀琀⸀嬀吀椀洀攀㈀㐀崀 㴀 挀漀渀瘀攀爀琀⠀琀椀洀攀Ⰰ䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀䔀匀吀⤀ഀഀ
  left join dimaccount d on a.accountid = d.accountid;਍䜀伀ഀഀ
