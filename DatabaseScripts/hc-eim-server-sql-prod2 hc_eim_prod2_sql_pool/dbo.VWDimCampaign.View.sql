/****** Object:  View [dbo].[VWDimCampaign]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䐀椀洀䌀愀洀瀀愀椀最渀崀 䄀匀 圀䤀吀䠀 嬀挀崀ഀഀ
AS (਍   匀䔀䰀䔀䌀吀ഀഀ
       [d].[CampaignKey]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䤀搀崀 䄀匀 嬀椀搀崀ഀഀ
     , [d].[CampaignName]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
     , [d].[AgencyKey]਍     Ⰰ 䌀䄀匀䔀ഀഀ
           WHEN [d].[CampaignMedia] = 'Organic' THEN 'Non Paid Media'਍ऀऀ   圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀刀愀搀椀漀✀Ⰰ ✀匀琀爀攀愀洀椀渀最✀⤀ 吀䠀䔀一 ✀倀愀椀搀 䴀攀搀椀愀✀ ⼀⨀䜀嘀䄀刀伀䰀 ㈀　㈀㈀　㈀㄀　⨀⼀ഀഀ
		   WHEN [d].[AgencyName] = 'Gleam' OR [d].[CampaignName] LIKE '%Gleam%' THEN 'Paid Media' /*GVAROL 20220210*/਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀伀刀䜀䄀一䤀䌀✀ 吀䠀䔀一 ✀倀愀椀搀 䴀攀搀椀愀✀ഀഀ
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignName] LIKE '%google local search advertising%' THEN 'Paid Media'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─瀀漀欀攀爀─✀ 吀䠀䔀一 ✀倀愀椀搀 䴀攀搀椀愀✀ഀഀ
           WHEN [d].[CampaignName] LIKE '%Gleam%' THEN 'Paid Media'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䤀一 ⠀✀䠀愀瘀愀猀✀Ⰰ ✀䌀愀渀渀攀氀氀愀✀Ⰰ ✀䤀渀琀攀爀洀攀搀椀愀✀Ⰰ ✀倀甀爀攀 䐀椀最椀琀愀氀✀Ⰰ ✀䈀愀爀琀栀ⴀ倀甀爀攀䐀椀最椀琀愀氀✀Ⰰ ✀䬀椀渀最猀琀愀爀✀Ⰰ ✀䬀椀渀最猀琀愀爀 䴀攀搀椀愀✀Ⰰ ✀䰀愀甀渀挀栀䐀刀吀嘀✀ഀഀ
                                   , 'Mediapoint', 'Venator', 'Advance360', 'Advanced360', 'Jane Creative', 'Valassis', 'Outfront') THEN 'Paid Media'਍           䔀䰀匀䔀 ✀一漀渀 倀愀椀搀 䴀攀搀椀愀✀ഀഀ
       END AS [PayMediaType]਍     Ⰰ 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀ഀഀ
     , CASE WHEN [d].[AgencyName] = 'Barth-Zimmerman' THEN 'Zimmerman'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀刀愀搀椀漀✀Ⰰ ✀匀琀爀攀愀洀椀渀最✀⤀ 吀䠀䔀一 ✀䤀渀ⴀ䠀漀甀猀攀✀ ⼀⨀䜀嘀䄀刀伀䰀 ㈀　㈀㈀　㈀㄀　⨀⼀ഀഀ
           WHEN [d].[AgencyName] = 'Gleam' OR [d].[CampaignName] LIKE '%Gleam%' THEN 'In-House' /*GVAROL 20220210*/਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─最漀漀最氀攀 氀漀挀愀氀 猀攀愀爀挀栀 愀搀瘀攀爀琀椀猀椀渀最─✀ 吀䠀䔀一 ✀䤀渀ⴀ䠀漀甀猀攀✀ഀഀ
           WHEN [d].[AgencyName] IN ('Advance360', 'Advanced360') THEN 'A360'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 吀䠀䔀一 ✀䤀渀ⴀ䠀漀甀猀攀✀ ⼀⨀䜀嘀䄀刀伀䰀 ㈀　㈀㈀　㈀㄀　⨀⼀ഀഀ
           --WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'In-House' /*GVAROL 20220210*/਍           ⴀⴀ圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─瀀漀欀攀爀─✀ 吀䠀䔀一 ✀䤀渀ⴀ䠀漀甀猀攀✀ ⼀⨀䜀嘀䄀刀伀䰀 ㈀　㈀㈀　㈀㄀　⨀⼀ഀഀ
           WHEN [d].[AgencyName] = 'Barth-PureDigital' THEN 'Pure Digital'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䰀愀甀渀挀栀䐀刀吀嘀✀ 吀䠀䔀一 ✀䰀愀甀渀挀栀✀ഀഀ
           WHEN [d].[AgencyName] = 'Kingstar' THEN 'Kingstar Media'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─䜀氀攀愀洀─✀ 吀䠀䔀一 ✀䤀渀ⴀ䠀漀甀猀攀✀ഀഀ
           ELSE ISNULL([d].[AgencyName], 'Unknown')਍       䔀一䐀 䄀匀 嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀ഀഀ
	 , [d].[CampaignStatus]਍     Ⰰ 嬀搀崀⸀嬀匀琀愀琀甀猀䬀攀礀崀ഀഀ
     , [d].[StartDate]਍     Ⰰ 嬀搀崀⸀嬀䔀渀搀䐀愀琀攀崀ഀഀ
     , [d].[CurrencyIsoCode]਍     Ⰰ 嬀搀崀⸀嬀䌀甀爀爀攀渀挀礀䬀攀礀崀ഀഀ
     , [d].[PromoCode]਍     Ⰰ 嬀搀崀⸀嬀倀爀漀洀漀琀椀漀䬀攀礀崀 䄀匀 嬀倀爀漀洀漀琀椀漀渀䬀攀礀崀ഀഀ
     , [d].[CampaignChannel]਍     Ⰰ 嬀搀崀⸀嬀䌀栀愀渀渀攀氀䬀攀礀崀ഀഀ
     , [d].[CampaignLocation]਍     Ⰰ 䌀䄀匀䔀 圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䈀愀爀琀栀─✀ 吀䠀䔀一 ✀䈀愀爀琀栀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Jane Creative%' THEN 'Barth'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䈀愀爀琀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䨀愀渀攀 䌀爀攀愀琀椀瘀攀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─唀匀─✀ 吀䠀䔀一 ✀唀匀䄀✀ഀഀ
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[AgencyName] NOT LIKE '%Jane Creative%' AND [d].[CampaignLocation] LIKE '%Canada%' THEN 'CAN'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䈀愀爀琀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䨀愀渀攀 䌀爀攀愀琀椀瘀攀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─倀甀攀爀琀漀 刀椀挀漀─✀ 吀䠀䔀一 ✀唀匀䄀✀ഀഀ
           ELSE 'Unknown'਍       䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀崀ഀഀ
     , CASE WHEN [d].[AgencyName] LIKE '%Barth%' THEN 'Franchise'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䈀愀爀琀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─䰀漀挀愀氀─✀ 吀䠀䔀一 ✀䰀漀挀愀氀✀ഀഀ
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[CampaignLocation] LIKE '%National%' THEN 'National'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䈀愀爀琀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀 䰀䤀䬀䔀 ✀─倀甀攀爀琀漀 刀椀挀漀─✀ 吀䠀䔀一 ✀倀甀攀爀琀漀 刀椀挀漀✀ഀഀ
           ELSE 'Unknown'਍       䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀吀礀瀀攀崀ഀഀ
     , [d].[CampaignLanguage]਍     Ⰰ 嬀搀崀⸀嬀䰀愀渀最甀愀最攀䬀攀礀崀ഀഀ
     , [d].[CampaignMedia]਍     Ⰰ 䌀䄀匀䔀 圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀洀攀搀椀愀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀㨀㌀　✀ 吀䠀䔀一 ✀伀吀吀✀ഀഀ
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'Gleam'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─瀀漀欀攀爀─✀ 吀䠀䔀一 ✀倀漀欀攀爀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%King%' AND [d].[CampaignFormat] = 'Video' THEN 'Traditional Ads'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─倀甀爀攀 䐀椀最椀琀愀氀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀嘀椀搀攀漀✀ 吀䠀䔀一 ✀刀攀琀愀爀最攀琀椀渀最✀ഀഀ
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'Listings'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䴀攀搀椀愀瀀漀椀渀琀✀ 吀䠀䔀一 ✀倀愀椀搀 䤀渀焀甀椀爀礀✀ഀഀ
           WHEN [d].[AgencyName] = 'Venator' THEN 'Lead Gen'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀䈀愀渀渀攀爀 䄀搀✀ 吀䠀䔀一 ✀䈀愀渀渀攀爀✀ഀഀ
           WHEN [d].[CampaignFormat] = 'Mailer' THEN 'Direct Mail'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䤀一 ⠀✀一漀渀ⴀ戀爀愀渀搀攀搀 倀瀀挀✀Ⰰ ✀䈀爀愀渀搀攀搀 倀瀀挀✀Ⰰ ✀吀攀砀琀 䄀搀✀⤀ 吀䠀䔀一 ✀䌀瀀挀✀ഀഀ
           WHEN [d].[CampaignFormat] IN ('Video Ad', 'Video Paid') THEN 'Video'਍           ⴀⴀ圀栀攀渀 䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀 椀渀 ⠀✀䤀洀愀最攀✀Ⰰ✀䤀洀愀最攀 䄀搀✀⤀ 愀渀搀 ⠀䌀愀洀瀀愀椀最渀一愀洀攀 渀漀琀 氀椀欀攀 ✀─最氀攀愀洀─✀⤀ 琀栀攀渀 ✀䤀洀愀最攀✀ഀഀ
           WHEN ( [d].[CampaignFormat] = ':30' AND [d].[AgencyName] <> 'Intermedia' ) OR ( [d].[CampaignFormat] IN (':10', ':60', ':120')) THEN 'Short Form'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䤀一 ⠀✀㨀㄀㠀　✀Ⰰ ✀㈀㐀　✀Ⰰ ✀㔀㨀　　✀⤀ 吀䠀䔀一 ✀䴀椀搀 䘀漀爀洀✀ഀഀ
           WHEN [d].[CampaignFormat] IN ('28:30', '28:30:00') THEN 'Long Form'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀攀愀搀猀─愀搀猀─✀ 吀䠀䔀一 ✀䰀攀愀搀 䄀搀猀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%local%' THEN 'Localization Ads'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─琀爀愀搀─愀搀猀─✀ 吀䠀䔀一 ✀吀爀愀搀椀琀椀漀渀愀氀 䄀搀猀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%LiveConsultant%' THEN 'Lead Ads'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䬀椀渀最猀琀愀爀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䰀䤀䬀䔀 ✀䤀洀愀最攀 䄀搀✀ 吀䠀䔀一 ✀吀爀愀搀椀琀椀漀渀愀氀 䄀搀猀✀ ⴀⴀ一䔀圀ഀഀ
           ELSE ISNULL([d].[CampaignFormat], 'Unknown')਍       䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀ഀഀ
     , CASE WHEN [d].[AgencyName] = 'Venator' THEN 'Affiliate'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㰀㸀 ✀嘀攀渀愀琀漀爀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䰀䤀䬀䔀 ✀䄀昀昀椀氀椀愀琀攀─✀ 吀䠀䔀一 ✀伀琀栀攀爀✀ഀഀ
           WHEN ( [d].[AgencyName] IN ('Havas', 'Cannella', 'Intermedia', 'Kingstar', 'Kingstar Media', 'Mediapoint') AND [d].[CampaignMedia] = 'TV' )਍             伀刀 ⠀ 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀洀攀搀椀愀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀匀琀爀攀愀洀椀渀最✀ ⤀ 吀䠀䔀一 ✀吀攀氀攀瘀椀猀椀漀渀✀ഀഀ
           WHEN ( [d].[AgencyName] NOT IN ('Havas', 'Cannella', 'Intermedia', 'Kingstar', 'Kingstar Media', 'Mediapoint') AND [d].[CampaignMedia] = 'TV' ) THEN਍               ✀伀琀栀攀爀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%launch%' AND [d].[CampaignName] LIKE '%youtube%' THEN 'Display'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─瀀甀爀攀─搀椀最椀琀愀氀─✀ഀഀ
            AND [d].[CampaignMedia] IN ('SEM', 'Display')਍            䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䤀一 ⠀✀嘀椀搀攀漀 䄀搀✀Ⰰ ✀刀攀洀愀爀攀欀琀椀渀最 䐀椀猀瀀氀愀礀✀Ⰰ ✀䈀愀渀渀攀爀 䄀搀✀⤀ 吀䠀䔀一 ✀䐀椀猀瀀氀愀礀✀ഀഀ
           WHEN [d].[CampaignName] LIKE '%gleam%' AND [d].[CampaignMedia] = 'Paid Social' THEN 'Paid Social'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─最氀攀愀洀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀䐀椀猀瀀氀愀礀✀ 吀䠀䔀一 ✀䐀椀猀瀀氀愀礀✀ഀഀ
           WHEN [d].[CampaignName] LIKE '%poker%' THEN 'Local Activation'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─礀漀甀琀甀戀攀─✀ 吀䠀䔀一 ✀倀愀椀搀 匀漀挀椀愀氀✀ഀഀ
           WHEN [d].[AgencyName] IN ('KingStar', 'Kingstar Media', 'Jane Creative', 'Internal Corporate', 'Hans Wiemann')਍            䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀倀愀椀搀 匀漀挀椀愀氀✀ 吀䠀䔀一 ✀倀愀椀搀 匀漀挀椀愀氀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Hans Wiemann%'਍            䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀匀䔀䴀✀ഀഀ
            AND [d].[CampaignFormat] IN ('Branded PPC', 'Non-Branded PPC', 'Digital Referral', 'Text Ad') THEN 'Paid Search'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─瀀甀爀攀─搀椀最椀琀愀氀─✀ഀഀ
            AND [d].[CampaignMedia] = 'SEM'਍            䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䤀一 ⠀✀䈀爀愀渀搀攀搀 倀倀䌀✀Ⰰ ✀一漀渀ⴀ䈀爀愀渀搀攀搀 倀倀䌀✀Ⰰ ✀䐀椀最椀琀愀氀 刀攀昀攀爀爀愀氀✀Ⰰ ✀吀攀砀琀 䄀搀✀⤀ 吀䠀䔀一 ✀倀愀椀搀 匀攀愀爀挀栀✀ഀഀ
           WHEN [d].[AgencyName] NOT LIKE '%Hans Wiemann%' AND [d].[AgencyName] NOT LIKE '%pure%digital%' AND [d].[CampaignMedia] = 'SEM' THEN 'Other'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀䔀嘀䔀一吀✀Ⰰ ✀刀䔀䘀䔀刀刀䄀䰀✀Ⰰ ✀圀䄀䰀䬀ⴀ䤀一✀Ⰰ ✀圀漀爀搀伀昀䴀漀甀琀栀✀Ⰰ ✀圀漀爀搀ⴀ伀昀ⴀ䴀漀甀琀栀✀Ⰰ ✀圀愀氀欀 䤀渀✀⤀ 吀䠀䔀一 ✀圀漀爀搀ⴀ伀昀ⴀ䴀漀甀琀栀✀ഀഀ
           WHEN [d].[CampaignMedia] = 'ORGANIC' THEN 'Local Search'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀匀䔀伀⼀伀爀最愀渀椀挀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─䜀漀漀最氀攀 䰀漀挀愀氀 匀攀愀爀挀栀 䄀搀瘀攀爀琀椀猀椀渀最─✀ 吀䠀䔀一 ✀䰀漀挀愀氀 匀攀愀爀挀栀✀ഀഀ
           WHEN [d].[CampaignMedia] = 'SEO/Organic' THEN 'Organic Search'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀䈀爀漀挀栀甀爀攀✀Ⰰ ✀䌀漀氀氀愀琀攀爀愀氀✀Ⰰ ✀䐀椀爀攀挀琀 䴀愀椀氀✀Ⰰ ✀䘀氀礀攀爀✀Ⰰ ✀䴀愀最愀稀椀渀攀✀Ⰰ ✀一攀眀猀瀀愀瀀攀爀✀Ⰰ ✀倀爀椀渀琀✀⤀ 吀䠀䔀一 ✀倀爀椀渀琀✀ഀഀ
           WHEN [d].[CampaignMedia] IN ('PRESS RELEASE', 'Earned Social') THEN 'Earned Social'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀圀䔀䈀匀䤀吀䔀✀Ⰰ ✀圀䔀䈀✀⤀ 吀䠀䔀一 ✀䐀椀爀攀挀琀✀ഀഀ
           WHEN [d].[CampaignMedia] IN ('SEO/ORGANIC') THEN 'Other'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀䔀洀愀椀氀✀Ⰰ ✀匀䴀匀⼀吀䔀堀吀✀Ⰰ ✀䤀一䈀伀唀一䐀✀Ⰰ ✀伀唀吀䈀伀唀一䐀✀⤀ 吀䠀䔀一 ✀䔀洀愀椀氀✀ഀഀ
           WHEN [d].[CampaignMedia] IN ('SPONSORSHIP/CHARITY', 'Out of Home', 'Sports') THEN 'Local Activation'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀匀吀刀䔀䄀䴀䤀一䜀✀ 吀䠀䔀一 ✀䐀椀猀瀀氀愀礀✀ഀഀ
           WHEN [d].[CampaignMedia] IN ('UNKNOWN', 'THIRD PARTY') THEN 'Other'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀䐀椀爀攀挀琀䴀愀椀氀✀Ⰰ ✀䐀椀爀攀挀琀 䴀愀椀氀✀⤀ 吀䠀䔀一 ✀䐀椀爀攀挀琀 䴀愀椀氀✀ഀഀ
           WHEN [d].[CampaignMedia] = 'Radio' OR [d].[CampaignFormat] IN ('Radio', 'Radio Ad', 'Radio Spot :10', 'Radio Spot :30', 'Radio Spot :60') THEN਍               ✀䄀甀搀椀漀✀ഀഀ
           WHEN [d].[AgencyName] IN ('Havas', 'Intermedia', 'Cannella') THEN 'Television'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䬀椀渀最匀琀愀爀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 䤀一 ⠀✀吀攀氀攀瘀椀猀椀漀渀✀Ⰰ ✀吀嘀✀⤀ 吀䠀䔀一 ✀吀攀氀攀瘀椀猀椀漀渀✀ഀഀ
           ELSE ISNULL([d].[CampaignMedia], 'Other')਍       䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀䐀攀爀椀瘀攀搀崀ഀഀ
     , [d].[MediaKey]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀ഀഀ
     , CASE WHEN [d].[CampaignMedia] = 'TV' THEN 'Linear'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䬀椀渀最─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀嘀椀搀攀漀✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Jane Creative%' THEN 'Facebook'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀洀攀搀椀愀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀㨀㌀　✀ 吀䠀䔀一 ✀䠀甀氀甀✀ഀഀ
           WHEN [d].[AgencyName] = 'Intermedia' AND [d].[CampaignFormat] <> ':30' THEN 'Linear'਍           圀䠀䔀一 吀刀䤀䴀⠀嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀⤀ 㴀 ✀䈀爀漀愀搀 刀攀愀挀栀✀ 䄀一䐀 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㰀㸀 ✀䤀渀琀攀爀洀攀搀椀愀✀ 吀䠀䔀一 ✀䰀椀渀攀愀爀✀ഀഀ
           WHEN [d].[AgencyName] = 'Advance360' THEN 'Multiple'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䴀攀搀椀愀倀漀椀渀琀✀ 吀䠀䔀一 ✀䴀甀氀琀椀瀀氀攀✀ഀഀ
           WHEN [d].[CampaignSource] LIKE 'Adroll%' THEN 'Ad Roll'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀䤀渀琀攀爀渀愀氀 䌀漀爀瀀漀爀愀琀攀✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀愀崀 㴀 ✀伀刀䜀䄀一䤀䌀✀ 吀䠀䔀一 ✀䴀甀氀琀椀瀀氀攀✀ഀഀ
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignName] LIKE '%poker%' THEN 'Multiple'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─倀甀爀攀─䐀椀最椀琀愀氀─✀ 䄀一䐀 吀刀䤀䴀⠀嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀⤀ 䤀一 ⠀✀一漀渀ⴀ戀爀愀渀搀攀搀 倀瀀挀✀Ⰰ ✀䈀爀愀渀搀攀搀 倀瀀挀✀Ⰰ ✀吀攀砀琀 䄀搀✀⤀ 吀䠀䔀一 ✀䴀甀氀琀椀瀀氀攀✀ഀഀ
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'Multiple'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 㴀 ✀嘀攀渀愀琀漀爀✀ 吀䠀䔀一 ✀䴀甀氀琀椀瀀氀攀✀ഀഀ
           WHEN [d].[AgencyName] = 'Valassis' THEN 'Multiple'਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 㴀 ✀䘀愀挀攀戀漀漀欀ⴀ椀渀猀琀愀最爀愀洀✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Banner Ad' THEN 'Ad Roll'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─倀甀爀攀 䐀椀最椀琀愀氀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀刀攀洀愀爀欀攀琀椀渀最 䐀椀猀瀀氀愀礀✀ 吀䠀䔀一 ✀䜀漀漀最氀攀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Video Ad' THEN 'Youtube'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀攀愀搀猀─愀搀猀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%local%' THEN 'Facebook'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─琀爀愀搀─愀搀猀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%youtube%' THEN 'Youtube'਍           圀䠀䔀一 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀愀甀渀挀栀─✀ 䄀一䐀 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─䘀愀挀攀戀漀漀欀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ഀഀ
           WHEN [d].[AgencyName] LIKE '%Kingstar%' AND [d].[CampaignFormat] LIKE 'Image Ad' THEN 'Facebook' --NEW਍           圀䠀䔀一 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 䤀一 ⠀✀嘀椀搀攀漀 䄀搀✀Ⰰ ✀嘀椀搀攀漀 倀愀椀搀✀⤀ 䄀一䐀 嬀搀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀 䰀䤀䬀䔀 ✀─䬀椀渀最猀琀愀爀─✀ 吀䠀䔀一 ✀䘀愀挀攀戀漀漀欀✀ ⴀⴀ一䔀圀ഀഀ
           ELSE [d].[CampaignSource]਍       䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀䐀攀爀椀瘀攀搀崀ഀഀ
     , [d].[SourceKey]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀最攀渀搀攀爀崀ഀഀ
     , [d].[GenderKey]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀吀礀瀀攀崀ഀഀ
     , [d].[BudgetedCost]਍     Ⰰ 嬀搀崀⸀嬀䄀挀琀甀愀氀䌀漀猀琀崀ഀഀ
     , [d].[DNIS]਍     Ⰰ 嬀搀崀⸀嬀刀攀昀攀爀爀攀爀崀ഀഀ
     , [d].[ReferralFlag]਍     Ⰰ 嬀搀崀⸀嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀ഀഀ
     , [d].[DWH_LastUpdateDate]਍     Ⰰ 嬀搀崀⸀嬀䤀猀䄀挀琀椀瘀攀崀ഀഀ
     , [d].[SourceSystem]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
     , [d].[CampaignDeviceType]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀䐀一䤀匀崀ഀഀ
     , [d].[CampaignTactic]਍     Ⰰ 嬀搀崀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
     , [d].[SourceCode]਍     Ⰰ 嬀搀崀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀崀ഀഀ
     , [d].[TollFreeMobileName]਍   䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䌀愀洀瀀愀椀最渀崀 䄀匀 嬀搀崀 ⤀ഀഀ
SELECT਍    嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䬀攀礀崀ഀഀ
  , [c].[id]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀ഀഀ
  , [c].[CampaignDescription]਍  Ⰰ 嬀挀崀⸀嬀䄀最攀渀挀礀䬀攀礀崀ഀഀ
  , [c].[PayMediaType]਍  Ⰰ 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀崀ഀഀ
  , CASE WHEN [c].[PayMediaType] = 'Paid Media' THEN [c].[AgencyNameDerived] ELSE 'Other' END AS [AgencyNameDerived]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
  , [c].[StatusKey]਍  Ⰰ 嬀挀崀⸀嬀匀琀愀爀琀䐀愀琀攀崀ഀഀ
  , [c].[EndDate]਍  Ⰰ 嬀挀崀⸀嬀䌀甀爀爀攀渀挀礀䤀猀漀䌀漀搀攀崀ഀഀ
  , [c].[CurrencyKey]਍  Ⰰ 嬀挀崀⸀嬀倀爀漀洀漀䌀漀搀攀崀ഀഀ
  , [c].[PromotionKey]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀഀ
  , CASE WHEN [c].[AgencyNameDerived] = 'Launch' AND [c].[CampaignChannelDerived] IN ('Paid Social', 'Display', 'Email') THEN 'Paid Social & Display'਍        圀䠀䔀一 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀 㴀 ✀倀甀爀攀 䐀椀最椀琀愀氀✀ 䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀䐀攀爀椀瘀攀搀崀 䤀一 ⠀✀倀愀椀搀 匀攀愀爀挀栀✀Ⰰ ✀䐀椀猀瀀氀愀礀✀⤀ 吀䠀䔀一 ✀倀愀椀搀 匀攀愀爀挀栀 ☀ 䐀椀猀瀀氀愀礀✀ഀഀ
        WHEN [c].[AgencyNameDerived] = 'In-House' AND [c].[CampaignChannelDerived] IN ('Paid Search', 'Paid Social') THEN 'Multiple'਍        圀䠀䔀一 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀 㴀 ✀䤀渀ⴀ䠀漀甀猀攀✀ 䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─最氀攀愀洀─✀ 吀䠀䔀一 ✀䴀甀氀琀椀瀀氀攀✀ഀഀ
        ELSE [c].[CampaignChannelDerived]਍    䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀䜀爀漀甀瀀崀ഀഀ
  , [c].[ChannelKey]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀崀ഀഀ
  , [c].[CampaignBudget]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀吀礀瀀攀崀ഀഀ
  , [c].[CampaignLanguage]਍  Ⰰ 嬀挀崀⸀嬀䰀愀渀最甀愀最攀䬀攀礀崀ഀഀ
  , [c].[CampaignMedia]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀ഀഀ
  , CASE WHEN [c].[AgencyNameDerived] = 'Launch'਍          䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 一伀吀 䰀䤀䬀䔀 ✀─䰀攀愀搀猀ⴀ䄀搀猀─✀ഀഀ
          AND [c].[CampaignName] NOT LIKE '%Localized%'਍          䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 一伀吀 䰀䤀䬀䔀 ✀夀漀甀琀甀戀攀─✀ 吀䠀䔀一 ✀吀爀愀搀椀琀椀漀渀愀氀 䄀搀猀✀ഀഀ
        WHEN [c].[AgencyNameDerived] = 'Launch'਍         䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀一愀洀攀崀 䰀䤀䬀䔀 ✀─䰀攀愀搀猀ⴀ䄀搀猀─✀ഀഀ
         AND [c].[CampaignSource] = 'Facebook'਍         䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 ✀䤀洀愀最攀✀ 吀䠀䔀一 ✀䰀攀愀搀 䄀搀猀✀ഀഀ
        WHEN [c].[CampaignMedium] IN ('Banner', 'Remarketing Display') THEN 'Retargeting'਍        圀䠀䔀一 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀 㴀 ✀䄀㌀㘀　✀ 䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀崀 㴀 ✀䤀洀愀最攀✀ 吀䠀䔀一 ✀刀攀琀愀爀最攀琀椀渀最✀ഀഀ
        WHEN [c].[AgencyNameDerived] LIKE '%Kingstar%' AND [c].[CampaignMedium] = 'Image' THEN 'Traditional Ads'਍        圀䠀䔀一 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀 㴀 ✀䰀愀甀渀挀栀✀ഀഀ
         AND [c].[CampaignName] LIKE '%Localized%'਍         䄀一䐀 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀崀 㴀 ✀䘀愀挀攀戀漀漀欀ⴀ䤀渀猀琀愀最爀愀洀✀ഀഀ
         AND [c].[CampaignFormat] = 'Video' THEN 'Localization Ads'਍        圀䠀䔀一 嬀挀崀⸀嬀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀崀 㴀 ✀䨀愀渀攀 䌀爀攀愀琀椀瘀攀✀ 吀䠀䔀一 ✀䤀洀愀最攀 ☀ 嘀椀搀攀漀✀ഀഀ
        ELSE [c].[CampaignMedium]਍    䔀一䐀 䄀匀 嬀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀最爀漀甀瀀崀ഀഀ
  , [c].[CampaignChannelDerived]਍  Ⰰ 嬀挀崀⸀嬀䴀攀搀椀愀䬀攀礀崀ഀഀ
  , [c].[CampaignSource]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀䐀攀爀椀瘀攀搀崀ഀഀ
  , [c].[SourceKey]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀最攀渀搀攀爀崀ഀഀ
  , [c].[GenderKey]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀吀礀瀀攀崀ഀഀ
  , [c].[BudgetedCost]਍  Ⰰ 嬀挀崀⸀嬀䄀挀琀甀愀氀䌀漀猀琀崀ഀഀ
  , [c].[DNIS]਍  Ⰰ 嬀挀崀⸀嬀刀攀昀攀爀爀攀爀崀ഀഀ
  , [c].[ReferralFlag]਍  Ⰰ 嬀挀崀⸀嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀ഀഀ
  , [c].[DWH_LastUpdateDate]਍  Ⰰ 嬀挀崀⸀嬀䤀猀䄀挀琀椀瘀攀崀ഀഀ
  , [c].[SourceSystem]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
  , [c].[CampaignDeviceType]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀䐀一䤀匀崀ഀഀ
  , [c].[CampaignTactic]਍  Ⰰ 嬀挀崀⸀嬀䌀愀洀瀀愀椀最渀倀爀漀洀漀䐀攀猀挀爀椀瀀琀椀漀渀崀ഀഀ
  , [c].[SourceCode]਍  Ⰰ 嬀挀崀⸀嬀吀漀氀氀䘀爀攀攀一愀洀攀崀ഀഀ
  , [c].[TollFreeMobileName]਍䘀刀伀䴀 嬀挀崀㬀ഀഀ
GO਍
