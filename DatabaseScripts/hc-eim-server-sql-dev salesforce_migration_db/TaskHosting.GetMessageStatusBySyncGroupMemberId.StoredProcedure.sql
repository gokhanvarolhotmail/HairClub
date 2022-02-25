/****** Object:  StoredProcedure [TaskHosting].[GetMessageStatusBySyncGroupMemberId]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[GetMessageStatusBySyncGroupMemberId]਍    䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @StartTime DATETIME,਍    䀀䴀愀砀䔀砀攀挀吀椀洀攀猀 吀䤀一夀䤀一吀Ⰰഀഀ
    @TimeoutInSeconds INT,਍    䀀䠀愀猀䴀攀猀猀愀最攀 䈀䤀吀 伀唀吀倀唀吀Ⰰഀഀ
    @HasRunningMessage BIT OUTPUT਍䄀匀ഀഀ
BEGIN਍    䤀䘀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        @HasMessage = COUNT(*),਍        䀀䠀愀猀刀甀渀渀椀渀最䴀攀猀猀愀最攀 㴀ഀഀ
            COUNT਍            ⠀ഀഀ
                CASE WHEN਍                ⴀⴀ 䔀砀攀挀甀琀攀 吀椀洀攀猀 氀攀猀猀 琀栀愀渀 洀愀砀Ⰰ 漀爀 攀砀攀挀甀琀攀 琀椀洀攀猀 攀焀甀愀氀 琀漀 洀愀砀 戀甀琀 椀琀 椀猀 猀琀椀氀氀 爀甀渀渀椀渀最Ⰰ 琀栀攀渀 爀攀琀甀爀渀 ㄀⸀ഀഀ
                    (ExecTimes < @MaxExecTimes) OR (ExecTimes = @MaxExecTimes AND UpdateTimeUTC >= DATEADD(SECOND, -@TimeoutInSeconds, GETUTCDATE()))਍                吀䠀䔀一 ㄀ഀഀ
                END਍            ⤀ഀഀ
    FROM TaskHosting.MessageQueue਍    圀䠀䔀刀䔀ഀഀ
        InsertTimeUTC >= @StartTime਍        䄀一䐀 䴀攀猀猀愀最攀䐀愀琀愀 䰀䤀䬀䔀 ✀─✀ ⬀ 䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀⠀㔀　⤀Ⰰ 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀搀⤀ ⬀ ✀─✀ഀഀ
਍䔀一䐀ഀഀ
਍䜀伀ഀഀ
