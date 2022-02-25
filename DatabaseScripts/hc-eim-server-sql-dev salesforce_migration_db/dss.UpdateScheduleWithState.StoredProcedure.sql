/****** Object:  StoredProcedure [dss].[UpdateScheduleWithState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀挀栀攀搀甀氀攀圀椀琀栀匀琀愀琀攀崀ഀഀ
    @Id UNIQUEIDENTIFIER,਍    䀀倀漀瀀吀椀挀欀攀琀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @state int਍䄀匀ഀഀ
BEGIN TRY਍䈀䔀䜀䤀一 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
    IF(@PopTicket = NULL )਍    䈀䔀䜀䤀一ഀഀ
            RAISERROR('INVALID Pop Ticket', 15, 1)਍    䔀一䐀ഀഀ
    IF @state=4਍    䈀䔀䜀䤀一ഀഀ
        UPDATE [dss].[ScheduleTask]਍        匀䔀吀ഀഀ
        State = @state,਍        倀漀瀀刀攀挀攀椀瀀琀 㴀 一唀䰀䰀Ⰰഀഀ
        DequeueCount = 0,਍        䔀砀瀀椀爀愀琀椀漀渀吀椀洀攀 㴀 䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ 䤀渀琀攀爀瘀愀氀Ⰰ䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ഀഀ
        WHERE [Id] = @Id਍        䄀一䐀 倀漀瀀刀攀挀攀椀瀀琀 㴀 䀀倀漀瀀吀椀挀欀攀琀ഀഀ
    END਍    䔀䰀匀䔀 䤀䘀 䀀猀琀愀琀攀 㴀㔀ഀഀ
    BEGIN਍        唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀匀挀栀攀搀甀氀攀吀愀猀欀崀ഀഀ
        SET਍        猀琀愀琀攀 㴀 䀀猀琀愀琀攀Ⰰഀഀ
        [DequeueCount] =਍            䌀䄀匀䔀ഀഀ
                WHEN [DequeueCount] < 254 -- This is a tinyint, so make sure we don't overflow਍                    吀䠀䔀一 嬀䐀攀焀甀攀甀攀䌀漀甀渀琀崀 ⬀ ㄀ഀഀ
                ELSE਍                    嬀䐀攀焀甀攀甀攀䌀漀甀渀琀崀ഀഀ
                END,਍        䔀砀瀀椀爀愀琀椀漀渀吀椀洀攀 㴀 䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ 䤀渀琀攀爀瘀愀氀Ⰰ䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ഀഀ
        WHERE [id] = @Id਍        䄀一䐀 倀漀瀀刀攀挀攀椀瀀琀 㴀 䀀倀漀瀀吀椀挀欀攀琀ഀഀ
    END਍    䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍ഀഀ
਍䔀一䐀 吀刀夀ഀഀ
BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
         -- get error infromation and raise error਍            䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍䔀一䐀 䌀䄀吀䌀䠀ഀഀ
GO਍
