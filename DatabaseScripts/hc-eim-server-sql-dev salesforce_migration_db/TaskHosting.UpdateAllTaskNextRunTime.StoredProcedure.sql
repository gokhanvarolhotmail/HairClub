/****** Object:  StoredProcedure [TaskHosting].[UpdateAllTaskNextRunTime]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- create stored procedure to get the next the due schedule tasks.਍ഀഀ
CREATE PROCEDURE [TaskHosting].[UpdateAllTaskNextRunTime]਍䄀匀ഀഀ
BEGIN -- stored procedure਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    ⴀⴀ 甀瀀搀愀琀攀 渀攀砀琀 爀甀渀 琀椀洀攀ഀഀ
    UPDATE TaskHosting.ScheduleTask WITH (UPDLOCK, READPAST)਍    匀䔀吀 一攀砀琀刀甀渀吀椀洀攀 㴀 吀愀猀欀䠀漀猀琀椀渀最⸀䜀攀琀一攀砀琀刀甀渀吀椀洀攀⠀匀挀栀攀搀甀氀攀⤀Ⰰ 䨀漀戀䤀搀㴀✀　　　　　　　　ⴀ　　　　ⴀ　　　　ⴀ　　　　ⴀ　　　　　　　　　　　　✀ഀഀ
    WHERE State = 1	-- enabled task.਍䔀一䐀  ⴀⴀ 猀琀漀爀攀搀 瀀爀漀挀攀搀甀爀攀ഀഀ
GO਍
