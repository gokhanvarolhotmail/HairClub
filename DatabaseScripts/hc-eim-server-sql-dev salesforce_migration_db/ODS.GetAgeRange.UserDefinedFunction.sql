/****** Object:  UserDefinedFunction [ODS].[GetAgeRange]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀伀䐀匀崀⸀嬀䜀攀琀䄀最攀刀愀渀最攀崀 ⠀䀀䴀礀嘀愀氀甀攀䤀渀 嬀椀渀琀崀Ⰰ䀀礀攀愀爀 嬀椀渀琀崀⤀ 刀䔀吀唀刀一匀 瘀愀爀挀栀愀爀⠀㄀㔀⤀ഀഀ
AS਍䈀䔀䜀䤀一  ഀഀ
    DECLARE @MyValueOut varchar(15);਍ऀ䐀䔀䌀䰀䄀刀䔀 䀀䄀最攀刀愀渀最攀 椀渀琀㬀ഀഀ
	SET @AgeRange = @year - @MyValueIn;਍ऀ匀䔀吀 䀀䴀礀嘀愀氀甀攀伀甀琀 㴀ഀഀ
			CASE ਍ऀ  ऀऀऀ 圀䠀䔀一 ⠀䀀䄀最攀刀愀渀最攀 㸀㴀 ㄀ 䄀一䐀 䀀䄀最攀刀愀渀最攀 㰀㴀 ㄀㜀⤀ 吀䠀䔀一 ✀唀渀搀攀爀 ㄀㠀✀ഀഀ
				 WHEN @AgeRange >= 18 AND @AgeRange <= 24 THEN '18 to 24'਍ऀऀऀऀ 圀䠀䔀一 䀀䄀最攀刀愀渀最攀 㸀㴀 ㈀㔀 䄀一䐀 䀀䄀最攀刀愀渀最攀 㰀㴀 ㌀㐀 吀䠀䔀一 ✀㈀㔀 琀漀 ㌀㐀✀ഀഀ
				 WHEN @AgeRange >= 35 AND @AgeRange <= 44 THEN '35 to 44'਍ऀऀऀऀ 圀䠀䔀一 䀀䄀最攀刀愀渀最攀 㸀㴀 㐀㔀 䄀一䐀 䀀䄀最攀刀愀渀最攀 㰀㴀 㔀㐀 吀䠀䔀一 ✀㐀㔀 琀漀 㔀㐀✀ഀഀ
				 WHEN @AgeRange >= 55 AND @AgeRange <= 64 THEN '55 to 64'਍ऀऀऀऀ 圀䠀䔀一 䀀䄀最攀刀愀渀最攀 㸀㴀 㘀㔀 䄀一䐀 䀀䄀最攀刀愀渀最攀 㰀㴀 ㄀㈀　 吀䠀䔀一 ✀㘀㔀 ⬀✀ഀഀ
				 ELSE 'Uknown'਍ऀऀऀऀ 䔀一䐀㬀ഀഀ
    RETURN(@MyValueOut);  ਍䔀一䐀ഀഀ
GO਍
