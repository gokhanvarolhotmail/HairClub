/****** Object:  UserDefinedFunction [dbo].[GetDSTEnd]    Script Date: 3/7/2022 8:42:18 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀戀漀崀⸀嬀䜀攀琀䐀匀吀䔀渀搀崀 ⠀䀀夀攀愀爀 嬀䤀一吀崀⤀ 刀䔀吀唀刀一匀 䐀䄀吀䔀吀䤀䴀䔀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @StartOfMonth DATETIME਍    Ⰰ       䀀䐀猀琀䔀渀搀 䐀䄀吀䔀吀䤀䴀䔀ഀഀ
਍ऀ䤀䘀 䀀夀攀愀爀 㰀㴀 ㈀　　㘀ഀഀ
	BEGIN਍ऀऀ䐀䔀䌀䰀䄀刀䔀 䀀䐀愀礀猀吀漀匀甀戀琀爀愀挀琀 䤀一吀ഀഀ
਍ऀऀⴀⴀ 䰀愀猀琀 匀甀渀搀愀礀 漀昀 伀挀琀漀戀攀爀ഀഀ
		SET @StartOfMonth = DATEADD(MONTH, 10, DATEADD(YEAR, @Year - 1900, 0))਍ऀऀ匀䔀吀 䀀䐀愀礀猀吀漀匀甀戀琀爀愀挀琀 㴀 䐀䄀吀䔀倀䄀刀吀⠀搀眀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀ ⴀ ㄀ഀഀ
਍ऀऀ䤀䘀 䀀䐀愀礀猀吀漀匀甀戀琀爀愀挀琀 㴀 　ഀഀ
		BEGIN਍ऀऀऀ匀䔀吀 䀀䐀愀礀猀吀漀匀甀戀琀爀愀挀琀 㴀 㜀ഀഀ
		END਍ഀഀ
		SET @DstEnd = DATEADD(HOUR, 2, DATEADD(DAY, ( @DaysToSubtract * -1 ), @StartOfMonth))	਍ऀ䔀一䐀ഀഀ
	਍ऀ䔀䰀匀䔀ഀഀ
	BEGIN਍ऀऀⴀⴀ 䘀椀爀猀琀 匀甀渀搀愀礀 漀昀 一漀瘀攀洀戀攀爀ഀഀ
		SET @StartOfMonth = DATEADD(MONTH, 10, DATEADD(YEAR, @Year - 1900, 0))਍ऀऀ匀䔀吀 䀀䐀猀琀䔀渀搀 㴀 䐀䄀吀䔀䄀䐀䐀⠀䠀伀唀刀Ⰰ ㈀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀䐀䄀夀Ⰰ ⠀ ⠀ 㠀 ⴀ 䐀䄀吀䔀倀䄀刀吀⠀搀眀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀ ⤀ ─ 㜀 ⤀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀⤀ഀഀ
	END਍    ഀഀ
    RETURN @DstEnd਍䔀一䐀ഀഀ
GO਍
