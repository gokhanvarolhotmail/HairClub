/****** Object:  View [dbo].[LeadWithoutCampaignPhone]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀䰀攀愀搀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀倀栀漀渀攀崀ഀഀ
AS WITH LeadWCampMem AS (਍ऀ匀䔀䰀䔀䌀吀 䐀䤀匀吀䤀一䌀吀 䰀⸀嬀䤀搀崀ഀഀ
	FROM [ODS].[SF_Lead] L਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀匀䘀开䌀愀洀瀀愀椀最渀䴀攀洀戀攀爀崀 䌀䴀 伀一 䌀䴀⸀嬀䰀攀愀搀䤀搀崀  㴀 䰀⸀嬀䤀搀崀ഀഀ
	WHERE CM.[LeadId] IS NULL਍⤀Ⰰ䰀攀愀搀匀䌀愀洀瀀愀椀最渀 䄀匀 ⠀ഀഀ
	SELECT a.Id, A.Name, a.CreatedDate ,B.start_time਍ऀऀⰀ䄀䈀匀⠀䌀䄀匀吀⠀ 䐀䄀吀䔀䐀䤀䘀䘀⠀匀䔀䌀伀一䐀Ⰰ愀⸀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ䈀⸀猀琀愀爀琀开琀椀洀攀⤀ 䄀匀 昀氀漀愀琀⤀ ⼀ 䌀䄀匀吀⠀㘀　 䄀匀 昀氀漀愀琀⤀⤀ ⨀ ⴀ㄀ 䄀匀 䐀椀昀䴀椀渀ഀഀ
		--,CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float) AS SDFS਍ऀऀⰀ愀⸀匀琀愀琀甀猀ഀഀ
		,a.MobilePhone਍ऀऀⰀ愀⸀倀栀漀渀攀ഀഀ
		,B.[from_phone]਍ऀऀⰀ䈀⸀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀ഀഀ
		,B.[disposition]਍ऀऀⰀ 一吀⸀一愀洀攀 䄀匀 吀伀䰀䰀开䘀刀䔀䔀ഀഀ
		, ROW_NUMBER() OVER( partition by a.Id order by ABS(CAST( DATEDIFF(SECOND,a.CreatedDate,B.start_time) AS float) / CAST(60 AS float)) * -1  DESC) AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀开䰀攀愀搀崀 愀 ⴀⴀ㄀　　ഀഀ
	INNER JOIN [ODS].[BP_CallDetail] b ਍ऀऀ伀一 吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䄀⸀倀栀漀渀攀Ⰰ ✀⠀✀Ⰰ✀✀⤀ Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ ✀ ✀Ⰰ ✀✀⤀Ⰰ ✀ⴀ✀Ⰰ✀✀⤀⤀ 㴀 猀甀戀猀琀爀椀渀最⠀嬀昀爀漀洀开瀀栀漀渀攀崀Ⰰ㈀Ⰰ氀攀渀⠀嬀昀爀漀洀开瀀栀漀渀攀崀⤀⤀ ഀഀ
		and convert(date,start_time)=convert(date,A.CreatedDate)਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀匀䘀开吀漀氀氀䘀爀攀攀崀 一吀 伀一 一吀⸀一愀洀攀 㴀 猀甀戀猀琀爀椀渀最⠀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀Ⰰ㈀Ⰰ氀攀渀⠀嬀漀爀椀最椀渀愀氀开搀攀猀琀椀渀愀琀椀漀渀开瀀栀漀渀攀崀⤀⤀ഀഀ
	INNER JOIN LeadWCampMem LC ON LC.Id = a.Id਍ऀ圀䠀䔀刀䔀 ഀഀ
		convert(date,A.CreatedDate)>='2021-06-15' ਍ऀऀ愀渀搀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ猀琀愀爀琀开琀椀洀攀⤀㸀㴀✀㈀　㈀㄀ⴀ　㘀ⴀ㄀㔀✀ഀഀ
		AND ISNUMERIC(B.[from_phone]) = 1 ਍ऀऀⴀⴀ䄀一䐀 愀⸀一愀洀攀 ℀㴀 ✀一攀眀䌀愀氀氀攀爀✀ഀഀ
	--ORDER BY A.Name ਍⤀匀䔀䰀䔀䌀吀 ⨀ ഀഀ
FROM LeadSCampaign਍圀䠀䔀刀䔀 刀漀眀一甀洀 㴀 ㄀㬀ഀഀ
GO਍
