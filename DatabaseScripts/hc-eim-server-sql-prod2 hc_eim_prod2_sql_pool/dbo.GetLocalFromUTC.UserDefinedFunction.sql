/****** Object:  UserDefinedFunction [dbo].[GetLocalFromUTC]    Script Date: 3/7/2022 8:42:18 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀戀漀崀⸀嬀䜀攀琀䰀漀挀愀氀䘀爀漀洀唀吀䌀崀 ⠀䀀䴀礀䐀愀琀攀 嬀䐀䄀吀䔀吀䤀䴀䔀崀Ⰰ䀀唀吀䌀伀昀昀匀攀琀 嬀䤀一吀崀Ⰰ䀀唀猀攀䐀愀礀䰀椀最栀琀匀愀瘀椀渀最猀 嬀䈀䤀吀崀⤀ 刀䔀吀唀刀一匀 䐀䄀吀䔀吀䤀䴀䔀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
	DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)਍ऀഀഀ
	IF @UseDayLightSavings = 1 AND @Local >= [dbo].GetDSTStart(DATEPART(YEAR, @Local)) AND @Local < [dbo].GetDSTEnd(DATEPART(YEAR, @Local))਍ऀ䈀䔀䜀䤀一ഀഀ
		SET @Local = DATEADD(HOUR, 1, @Local)਍ऀ䔀一䐀ഀഀ
਍ऀ刀䔀吀唀刀一 䀀䰀漀挀愀氀ഀഀ
END਍䜀伀ഀഀ
