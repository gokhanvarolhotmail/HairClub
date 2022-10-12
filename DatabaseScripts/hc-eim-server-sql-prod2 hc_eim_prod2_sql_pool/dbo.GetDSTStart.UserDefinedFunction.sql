/****** Object:  UserDefinedFunction [dbo].[GetDSTStart]    Script Date: 3/23/2022 10:16:55 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀戀漀崀⸀嬀䜀攀琀䐀匀吀匀琀愀爀琀崀 ⠀䀀夀攀愀爀 嬀䤀一吀崀⤀ 刀䔀吀唀刀一匀 䐀䄀吀䔀吀䤀䴀䔀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @StartOfMonth DATETIME਍    Ⰰ       䀀䐀猀琀匀琀愀爀琀 䐀䄀吀䔀吀䤀䴀䔀 ഀഀ
਍ഀഀ
	IF @Year < 1987਍ऀ䈀䔀䜀䤀一ഀഀ
		DECLARE @DaysToSubtract INT਍ഀഀ
		-- Last Sunday of April਍ऀऀ匀䔀吀 䀀匀琀愀爀琀伀昀䴀漀渀琀栀 㴀 䐀䄀吀䔀䄀䐀䐀⠀䴀伀一吀䠀Ⰰ 㐀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀夀䔀䄀刀Ⰰ 䀀夀攀愀爀 ⴀ ㄀㤀　　Ⰰ 　⤀⤀ഀഀ
		SET @DaysToSubtract = DATEPART(dw, @StartOfMonth) - 1਍ഀഀ
		IF @DaysToSubtract = 0਍ऀऀ䈀䔀䜀䤀一ഀഀ
			SET @DaysToSubtract = 7਍ऀऀ䔀一䐀ഀഀ
਍ऀऀ匀䔀吀 䀀䐀猀琀匀琀愀爀琀 㴀 䐀䄀吀䔀䄀䐀䐀⠀䠀伀唀刀Ⰰ ㈀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀䐀䄀夀Ⰰ ⠀ 䀀䐀愀礀猀吀漀匀甀戀琀爀愀挀琀 ⨀ ⴀ㄀ ⤀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀⤀ऀഀഀ
	END਍ऀഀഀ
	ELSE IF ( @Year >= 1987 AND @Year <= 2006 )਍ऀ䈀䔀䜀䤀一ഀഀ
		-- First Sunday of April਍ऀऀ匀䔀吀 䀀匀琀愀爀琀伀昀䴀漀渀琀栀 㴀 䐀䄀吀䔀䄀䐀䐀⠀䴀伀一吀䠀Ⰰ ㌀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀夀䔀䄀刀Ⰰ 䀀夀攀愀爀 ⴀ ㄀㤀　　Ⰰ 　⤀⤀ഀഀ
		SET @DstStart = DATEADD(HOUR, 2, DATEADD(DAY, ( ( 8 - DATEPART(dw, @StartOfMonth) ) % 7 ), @StartOfMonth))਍ऀ䔀一䐀ഀഀ
	਍ऀ䔀䰀匀䔀ഀഀ
	BEGIN਍ऀऀⴀⴀ 匀攀挀漀渀搀 匀甀渀搀愀礀 漀昀 䴀愀爀挀栀ഀഀ
		SET @StartOfMonth = DATEADD(MONTH, 2, DATEADD(YEAR, @Year - 1900, 0))਍ऀऀ匀䔀吀 䀀䐀猀琀匀琀愀爀琀 㴀 䐀䄀吀䔀䄀䐀䐀⠀䠀伀唀刀Ⰰ ㈀Ⰰ 䐀䄀吀䔀䄀䐀䐀⠀䐀䄀夀Ⰰ ⠀ ⠀ 㠀 ⴀ 䐀䄀吀䔀倀䄀刀吀⠀搀眀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀ ⤀ ─ 㜀 ⤀ ⬀ 㜀Ⰰ 䀀匀琀愀爀琀伀昀䴀漀渀琀栀⤀⤀ഀഀ
	END    ਍ഀഀ
    RETURN @DstStart਍䔀一䐀ഀഀ
GO਍
