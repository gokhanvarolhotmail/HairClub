/****** Object:  StoredProcedure [dbo].[sp_CountKeysNull]    Script Date: 2/22/2022 9:20:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开䌀漀甀渀琀䬀攀礀猀一甀氀氀崀 䀀匀挀栀攀洀愀 嬀嘀䄀刀䌀䠀䄀刀崀⠀㄀　　⤀ 䄀匀          ഀഀ
BEGIN      ਍ऀ匀䔀吀 一伀䌀伀唀一吀 伀一㬀  ഀഀ
	DECLARE @SQL	NVARCHAR(MAX)਍    倀刀䤀一吀⠀ ✀匀䔀䰀䔀䌀吀ऀ  ✀✀匀䔀䰀䔀䌀吀 ✀✀✀✀✀✀ऀ⬀ 䌀⸀吀䄀䈀䰀䔀开一䄀䴀䔀 ⬀ऀ✀✀✀✀✀✀ 䄀匀 吀䄀䈀䰀䔀开一䄀䴀䔀Ⰰ ✀✀✀✀✀✀ ⬀ 䌀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀✀✀✀✀✀✀ 䄀匀 䌀伀䰀唀䴀一开一䄀䴀䔀Ⰰ ✀✀ ⬀ 䌀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀ ✀✀Ⰰ 䌀伀唀一吀⠀⨀⤀ 䄀匀 吀伀吀䄀䰀开一唀䰀䰀✀✀ഀഀ
							+ '' FROM ''		+ C.TABLE_SCHEMA +	''.'' + C.TABLE_NAME +  ਍ऀऀऀऀऀऀऀ⬀ ✀✀ 圀䠀䔀刀䔀 ✀✀ऀऀ⬀ 䌀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀ऀ✀✀ 䤀匀 一唀䰀䰀✀✀ഀഀ
							+ '' GROUP BY ''	+ C.COLUMN_NAME ਍ऀऀऀऀऀऀऀ⬀ ✀✀ 䠀䄀嘀䤀一䜀 䌀伀唀一吀⠀⨀⤀ 㸀㴀㄀㬀 ✀✀ ഀഀ
							FROM INFORMATION_SCHEMA.TABLES T ਍ऀऀऀऀऀऀऀ䤀一一䔀刀 䨀伀䤀一 䤀一䘀伀刀䴀䄀吀䤀伀一开匀䌀䠀䔀䴀䄀⸀䌀伀䰀唀䴀一匀 䌀ഀഀ
								 ON T.TABLE_NAME = C.TABLE_NAME਍ऀऀऀऀऀऀऀ圀䠀䔀刀䔀 唀倀倀䔀刀⠀䌀⸀䌀伀䰀唀䴀一开一䄀䴀䔀⤀ 䰀䤀䬀䔀 ✀✀─䬀䔀夀✀✀㬀 ✀⤀㬀ഀഀ
਍䔀一䐀ഀഀ
GO਍
