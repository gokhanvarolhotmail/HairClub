/****** Object:  View [dbo].[LeadSinCampaignPhone]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ 挀爀攀愀琀攀 瘀椀攀眀 嬀搀戀漀崀⸀嬀䰀攀愀搀匀椀渀䌀愀洀瀀愀椀最渀倀栀漀渀攀崀 愀猀ഀ
 ਍圀䤀吀䠀 䰀攀愀搀匀䌀愀洀瀀愀椀最渀 䄀匀 ⠀ഀ
	SELECT a.Id, A.Name, a.CreatedDate ,B.start_time਍ऀऀⰀ䄀䈀匀⠀䌀䄀匀吀⠀ 䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ愀⸀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ䈀⸀猀琀愀爀琀开琀椀洀攀⤀ 䄀匀 昀氀漀愀琀⤀ ⼀ 䌀䄀匀吀⠀㘀　 䄀匀 昀氀漀愀琀⤀⤀ ⨀ ⴀ㄀ 䄀匀 䐀椀昀䴀椀渀ഀഀ
		--,CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float) AS SDFS਍ऀऀⰀ愀⸀匀琀愀琀甀猀ഀഀ
		,a.MobilePhone਍ऀऀⰀ愀⸀倀栀漀渀攀ഀഀ
		,B.[from_phone]਍ऀऀⰀ䈀⸀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀ഀഀ
		,B.[disposition]਍ऀऀⰀ 一吀⸀一愀洀攀 䄀匀 吀伀䰀䰀开䘀刀䔀䔀ഀ
		, ROW_NUMBER() OVER( partition by a.Id order by ABS(CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float)) * -1  DESC) AS RowNum਍ऀ䘀刀伀䴀 匀䘀䰀开一䔀圀开䰀攀愀搀 愀 ⴀⴀ㄀　　ഀ
	INNER JOIN [dbo].[BP_CallDetail] b ਍ऀऀ伀一 吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䄀⸀倀栀漀渀攀Ⰰ ✀⠀✀Ⰰ✀✀⤀ Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ ✀ ✀Ⰰ ✀✀⤀Ⰰ ✀ⴀ✀Ⰰ✀✀⤀⤀ 㴀 猀甀戀猀琀爀椀渀最⠀嬀昀爀漀洀开瀀栀漀渀攀崀Ⰰ㈀Ⰰ氀攀渀⠀嬀昀爀漀洀开瀀栀漀渀攀崀⤀⤀ ഀ
		and convert(date,start_time)=convert(date,A.CreatedDate)਍ऀ䰀䔀䘀吀 䨀伀䤀一 匀䰀䘀开一䔀圀开吀漀氀氀䘀爀攀攀 一吀 伀一 一吀⸀一愀洀攀 㴀 猀甀戀猀琀爀椀渀最⠀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀Ⰰ㈀Ⰰ氀攀渀⠀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀⤀⤀ഀ
	INNER JOIN SLF_NEW_LeadWithoutCampaign LC ON LC.Id = a.Id਍ऀ眀栀攀爀攀 ഀ
		convert(date,A.CreatedDate)>='2021-06-15' ਍ऀऀ愀渀搀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ猀琀愀爀琀开琀椀洀攀⤀㸀㴀✀㈀　㈀㄀ⴀ　㘀ⴀ㄀㔀✀ഀ
		AND ISNUMERIC(B.[from_phone]) = 1 ਍ऀऀ䄀一䐀 愀⸀一愀洀攀 ℀㴀 ✀一攀眀䌀愀氀氀攀爀✀ഀ
	--ORDER BY A.Name ਍⤀匀䔀䰀䔀䌀吀 ⨀ ഀ
FROM LeadSCampaign਍圀䠀䔀刀䔀 刀漀眀一甀洀 㴀 ㄀ഀ
਍䜀伀ഀഀ
