/****** Object:  StoredProcedure [TaskHosting].[IsJobRunning]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Detect whether the job is running by checking the messages਍ഀഀ
CREATE PROCEDURE [TaskHosting].[IsJobRunning]਍    䀀䨀漀戀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍    䤀䘀 䀀䨀漀戀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䨀漀戀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    䤀䘀 䔀堀䤀匀吀匀ഀഀ
        (SELECT *਍        䘀刀伀䴀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀ഀഀ
        WHERE JobId = @JobId਍        ⤀ഀഀ
        SELECT 1਍    䔀䰀匀䔀ഀഀ
        SELECT 0਍ഀഀ
RETURN 0਍ഀഀ
GO਍
