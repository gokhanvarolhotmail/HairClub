/****** Object:  UserDefinedFunction [TaskHosting].[GetNextRunTime]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create function to calculate the next run time of the schedule.਍ഀഀ
CREATE FUNCTION [TaskHosting].[GetNextRunTime]਍    ⠀䀀匀挀栀攀搀甀氀攀䤀搀 椀渀琀⤀ഀഀ
    RETURNS DateTime਍䄀匀ഀഀ
BEGIN਍ഀഀ
DECLARE @type int਍䐀䔀䌀䰀䄀刀䔀 䀀椀渀琀攀爀瘀愀氀 椀渀琀ഀഀ
਍匀䔀䰀䔀䌀吀 䀀吀礀瀀攀 㴀 猀⸀䘀爀攀焀吀礀瀀攀Ⰰ 䀀椀渀琀攀爀瘀愀氀 㴀 猀⸀䘀爀攀焀䤀渀琀攀爀瘀愀氀ഀഀ
FROM TaskHosting.Schedule AS s਍圀䠀䔀刀䔀 猀⸀匀挀栀攀搀甀氀攀䤀搀 㴀 䀀匀挀栀攀搀甀氀攀䤀搀ഀഀ
਍䤀䘀 ⠀䀀䀀刀伀圀䌀伀唀一吀 㰀㴀 　⤀ഀഀ
BEGIN਍    爀攀琀甀爀渀 挀愀猀琀⠀✀一漀 匀甀挀栀 愀渀 䤀䐀⸀✀ 愀猀 椀渀琀⤀㬀ഀഀ
END਍ഀഀ
DECLARE @NextRunTime DATETIME਍䤀䘀 ⠀䀀吀礀瀀攀 㴀 ㈀⤀ഀഀ
BEGIN਍    匀䔀吀 䀀一攀砀琀刀甀渀吀椀洀攀㴀䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ 䀀椀渀琀攀爀瘀愀氀Ⰰ 䜀䔀吀唀吀䌀䐀愀琀攀⠀⤀⤀ഀഀ
END਍䔀䰀匀䔀 䤀䘀 ⠀䀀吀礀瀀攀 㴀 㐀⤀ഀഀ
BEGIN਍    匀䔀吀 䀀一攀砀琀刀甀渀吀椀洀攀㴀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 䀀椀渀琀攀爀瘀愀氀Ⰰ 䜀䔀吀唀吀䌀䐀愀琀攀⠀⤀⤀ഀഀ
END਍䔀䰀匀䔀 䤀䘀 ⠀䀀吀礀瀀攀㴀㠀⤀ഀഀ
BEGIN਍    匀䔀吀 䀀一攀砀琀刀甀渀吀椀洀攀㴀䐀䄀吀䔀䄀䐀䐀⠀䠀伀唀刀Ⰰ 䀀椀渀琀攀爀瘀愀氀Ⰰ 䜀䔀吀唀吀䌀䐀愀琀攀⠀⤀⤀ഀഀ
END਍䔀䰀匀䔀ഀഀ
BEGIN਍    爀攀琀甀爀渀 挀愀猀琀⠀✀一漀 匀甀挀栀 愀渀 琀礀瀀攀⸀✀ 愀猀 椀渀琀⤀㬀ഀഀ
END਍ഀഀ
਍刀䔀吀唀刀一 䀀一攀砀琀刀甀渀吀椀洀攀ഀഀ
਍ഀഀ
END਍ഀഀ
਍ഀഀ
GO਍
