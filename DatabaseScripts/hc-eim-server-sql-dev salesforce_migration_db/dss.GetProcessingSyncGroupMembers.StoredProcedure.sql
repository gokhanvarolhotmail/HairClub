/****** Object:  StoredProcedure [dss].[GetProcessingSyncGroupMembers]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀倀爀漀挀攀猀猀椀渀最匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀猀崀ഀഀ
    @startTime DATETIME,਍    䀀攀渀搀吀椀洀攀 䐀䄀吀䔀吀䤀䴀䔀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @startTime > @endTime਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('@startTime is bigger than @endTime', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀渀愀洀攀崀Ⰰഀഀ
        [scopename],਍        嬀猀礀渀挀最爀漀甀瀀椀搀崀Ⰰഀഀ
        [syncdirection],਍        嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
        [memberstate],਍        嬀栀甀戀猀琀愀琀攀崀Ⰰഀഀ
        [memberstate_lastupdated],਍        嬀栀甀戀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀Ⰰഀഀ
        [lastsynctime],਍        嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀Ⰰഀഀ
        [lastsynctime_zerofailures_hub],਍        嬀樀漀戀䤀搀崀Ⰰഀഀ
        [noinitsync],਍        嬀洀攀洀戀攀爀栀愀猀搀愀琀愀崀ഀഀ
    FROM਍        嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀 圀䤀吀䠀 ⠀唀倀䐀䰀伀䌀䬀⤀ഀഀ
    WHERE਍        ⠀ഀഀ
            ([memberstate_lastupdated] >= @startTime AND [memberstate_lastupdated] < @endTime਍                䄀一䐀 ⠀嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 ㄀ 伀刀 嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 㐀 伀刀 嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 㜀 伀刀 嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 ㄀㌀ 伀刀 嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 ㄀㔀⤀ഀഀ
                AND jobId IS NOT NULL)਍            伀刀ഀഀ
            ([hubstate_lastupdated] >= @startTime AND [hubstate_lastupdated] < @endTime਍                䄀一䐀 ⠀嬀栀甀戀猀琀愀琀攀崀 㴀 ㄀ 伀刀 嬀栀甀戀猀琀愀琀攀崀 㴀 㜀 伀刀 嬀栀甀戀猀琀愀琀攀崀 㴀 ㄀㌀⤀ഀഀ
                AND hubJobId IS NOT NULL)਍        ⤀ഀഀ
END਍䜀伀ഀഀ
