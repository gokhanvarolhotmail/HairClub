/****** Object:  View [dbo].[LeadSinCampaignMPhone]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍挀爀攀愀琀攀 瘀椀攀眀 嬀搀戀漀崀⸀嬀䰀攀愀搀匀椀渀䌀愀洀瀀愀椀最渀䴀倀栀漀渀攀崀 愀猀ഀ
WITH LeadSCampaign AS (਍ऀ匀䔀䰀䔀䌀吀 愀⸀䤀搀Ⰰ 䄀⸀一愀洀攀Ⰰ 愀⸀䌀爀攀愀琀攀搀䐀愀琀攀 Ⰰ䈀⸀猀琀愀爀琀开琀椀洀攀ഀഀ
		,ABS(CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float)) * -1 AS DifMin਍ऀऀⴀⴀⰀ䌀䄀匀吀⠀ 䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ愀⸀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ䈀⸀猀琀愀爀琀开琀椀洀攀⤀ 䄀匀 昀氀漀愀琀⤀ ⼀ 䌀䄀匀吀⠀㘀　 䄀匀 昀氀漀愀琀⤀ 䄀匀 匀䐀䘀匀ഀഀ
		,a.Status਍ऀऀⰀ愀⸀䴀漀戀椀氀攀倀栀漀渀攀ഀഀ
		,a.Phone਍ऀऀⰀ䈀⸀嬀昀爀漀洀开瀀栀漀渀攀崀ഀഀ
		,B.[original_destination_phone]਍ऀऀⰀ䈀⸀嬀搀椀猀瀀漀猀椀琀椀漀渀崀ഀ
		, NT.Name AS TOLL_FREE਍ऀऀⰀ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀ 瀀愀爀琀椀琀椀漀渀 戀礀 愀⸀䤀搀 漀爀搀攀爀 戀礀 䄀䈀匀⠀䌀䄀匀吀⠀ 䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ愀⸀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ䈀⸀猀琀愀爀琀开琀椀洀攀⤀ 䄀匀 昀氀漀愀琀⤀ ⼀ 䌀䄀匀吀⠀㘀　 䄀匀 昀氀漀愀琀⤀⤀ ⨀ ⴀ㄀  䐀䔀匀䌀⤀ 䄀匀 刀漀眀一甀洀ഀ
	FROM SFL_NEW_Lead a --100਍ऀ䤀一一䔀刀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䈀倀开䌀愀氀氀䐀攀琀愀椀氀崀 戀 ഀ
		ON TRIM(REPLACE(REPLACE(REPLACE(REPLACE(A.MobilePhone, '(','') ,')',''), ' ', ''), '-','')) = substring([from_phone],2,len([from_phone])) ਍ऀऀ愀渀搀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ猀琀愀爀琀开琀椀洀攀⤀㴀挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ䄀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀ഀ
	LEFT JOIN SLF_NEW_TollFree NT ON NT.Name = substring([original_destination_phone],2,len([original_destination_phone]))਍ऀ䤀一一䔀刀 䨀伀䤀一 匀䰀䘀开一䔀圀开䰀攀愀搀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀 䰀䌀 伀一 䰀䌀⸀䤀搀 㴀 愀⸀䤀搀ഀ
	where ਍ऀऀ挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ䄀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀㸀㴀✀㈀　㈀㄀ⴀ　㘀ⴀ㄀㔀✀ ഀ
		and convert(date,start_time)>='2021-06-15'਍ऀऀ䄀一䐀 䤀匀一唀䴀䔀刀䤀䌀⠀䈀⸀嬀昀爀漀洀开瀀栀漀渀攀崀⤀ 㴀 ㄀ ഀ
		AND a.Name != 'NewCaller'਍ऀⴀⴀ伀刀䐀䔀刀 䈀夀 䄀⸀一愀洀攀 ഀ
)SELECT * ਍䘀刀伀䴀 䰀攀愀搀匀䌀愀洀瀀愀椀最渀ഀ
WHERE RowNum = 1਍ഀഀ
GO਍
