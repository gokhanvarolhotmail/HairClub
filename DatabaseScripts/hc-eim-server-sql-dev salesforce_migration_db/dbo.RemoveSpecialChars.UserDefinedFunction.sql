/****** Object:  UserDefinedFunction [dbo].[RemoveSpecialChars]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍挀爀攀愀琀攀 昀甀渀挀琀椀漀渀 嬀搀戀漀崀⸀嬀刀攀洀漀瘀攀匀瀀攀挀椀愀氀䌀栀愀爀猀崀 ⠀䀀猀 瘀愀爀挀栀愀爀⠀㈀㔀㔀⤀⤀ ഀഀ
returns varchar(255)਍戀攀最椀渀ഀഀ
	declare @str varchar(255)਍ऀ搀攀挀氀愀爀攀 䀀氀 椀渀琀ഀഀ
	declare @i int਍ഀഀ
	set @i = 0਍ऀ猀攀琀 䀀氀 㴀 氀攀渀⠀䀀猀⤀ഀഀ
਍圀䠀䤀䰀䔀 䀀椀 㰀 䀀氀ഀ
    SET @str = Replace(@s, Substring(@s, PatIndex('%[!@#$%^&*(),.?:{}|<>\/]%', @s), 1), '')਍ഀ
RETURN @str਍䔀一䐀ഀഀ
GO਍
