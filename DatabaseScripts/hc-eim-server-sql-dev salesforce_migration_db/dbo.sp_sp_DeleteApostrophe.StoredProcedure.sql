/****** Object:  StoredProcedure [dbo].[sp_sp_DeleteApostrophe]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀戀漀崀⸀嬀猀瀀开猀瀀开䐀攀氀攀琀攀䄀瀀漀猀琀爀漀瀀栀攀崀⠀䀀匀挀栀攀洀愀一愀洀攀 嘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰ 䀀吀愀戀氀攀一愀洀攀 嘀愀爀挀栀愀爀⠀㄀　　⤀⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍䐀䔀䌀䰀䄀刀䔀 䀀䄀䰀䰀开吀䄀䈀䰀䔀匀 嘀䄀刀䌀䠀䄀刀⠀䴀䄀堀⤀ 㴀 ✀✀ഀഀ
DECLARE @SQL VARCHAR(MAX) = ''਍ഀഀ
SELECT @ALL_TABLES = @ALL_TABLES + C.TABLE_NAME + ', '਍ऀ䘀刀伀䴀 䤀一䘀伀刀䴀䄀吀䤀伀一开匀䌀䠀䔀䴀䄀⸀䌀伀䰀唀䴀一匀 挀ഀഀ
	WHERE C.TABLE_NAME = @TableName਍ഀഀ
SELECT @SQL = @SQL	+ ' UPDATE ' + @SchemaName + '.' + C.TABLE_NAME ਍ऀऀऀऀऀ⬀ ✀ 匀䔀吀 ✀ ⬀ 挀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀ ✀ 㴀 刀䔀倀䰀䄀䌀䔀⠀ ✀ ⬀ 挀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀ ✀Ⰰ ✀✀ ✀✀ ✀✀ Ⰰ ✀✀✀✀ ⤀✀ ഀഀ
					+ ' WHERE TRY_CAST(TRIM(' + c.COLUMN_NAME + ') as VARCHAR(250)) like "''%" ' ਍ऀऀऀऀऀ⬀ ✀ 伀刀 吀刀夀开䌀䄀匀吀⠀吀刀䤀䴀⠀✀ ⬀ 挀⸀䌀伀䰀唀䴀一开一䄀䴀䔀 ⬀ ✀⤀ 愀猀 嘀䄀刀䌀䠀䄀刀⠀㈀㔀　⤀⤀ 氀椀欀攀 ∀ ─✀✀ ∀㬀✀ ഀഀ
	FROM INFORMATION_SCHEMA.COLUMNS c਍ऀ圀䠀䔀刀䔀 䌀⸀吀䄀䈀䰀䔀开一䄀䴀䔀  㴀 䀀吀愀戀氀攀一愀洀攀ഀഀ
print @SQL਍䔀堀䔀䌀 ⠀䀀匀儀䰀⤀ഀഀ
਍䔀一䐀ഀഀ
GO਍
