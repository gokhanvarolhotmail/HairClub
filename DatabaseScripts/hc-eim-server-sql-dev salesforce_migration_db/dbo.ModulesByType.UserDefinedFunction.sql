/****** Object:  UserDefinedFunction [dbo].[ModulesByType]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀戀漀崀⸀嬀䴀漀搀甀氀攀猀䈀礀吀礀瀀攀崀 ⠀䀀漀戀樀攀挀琀吀礀瀀攀 嬀䌀䠀䄀刀崀⠀㈀⤀ 㴀 ✀──✀⤀ 刀䔀吀唀刀一匀 吀䄀䈀䰀䔀ഀഀ
AS਍刀䔀吀唀刀一 ⠀ഀഀ
	SELECT ਍ऀऀ猀洀⸀漀戀樀攀挀琀开椀搀 䄀匀 ✀伀戀樀攀挀琀 䤀搀✀Ⰰഀഀ
		o.create_date AS 'Date Created',਍ऀऀ伀䈀䨀䔀䌀吀开一䄀䴀䔀⠀猀洀⸀漀戀樀攀挀琀开椀搀⤀ 䄀匀 ✀一愀洀攀✀Ⰰഀഀ
		o.type AS 'Type',਍ऀऀ漀⸀琀礀瀀攀开搀攀猀挀 䄀匀 ✀吀礀瀀攀 䐀攀猀挀爀椀瀀琀椀漀渀✀Ⰰ ഀഀ
		sm.definition AS 'Module Description'਍ऀ䘀刀伀䴀 猀礀猀⸀猀焀氀开洀漀搀甀氀攀猀 䄀匀 猀洀  ഀഀ
	JOIN sys.objects AS o ON sm.object_id = o.object_id਍ऀ圀䠀䔀刀䔀 漀⸀琀礀瀀攀 氀椀欀攀 ✀─✀ ⬀ 䀀漀戀樀攀挀琀吀礀瀀攀 ⬀ ✀─✀ഀഀ
)਍䜀伀ഀഀ
