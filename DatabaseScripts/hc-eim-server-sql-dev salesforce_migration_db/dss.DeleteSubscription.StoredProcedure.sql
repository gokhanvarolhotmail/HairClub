/****** Object:  StoredProcedure [dss].[DeleteSubscription]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䐀攀氀攀琀攀匀甀戀猀挀爀椀瀀琀椀漀渀崀ഀഀ
    @SubscriptionID UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        -- Remove agent instances਍        䐀䔀䰀䔀吀䔀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀愀最攀渀琀开椀渀猀琀愀渀挀攀崀ഀഀ
        WHERE [agentid] IN (SELECT [id] FROM [dss].[agent] WHERE [subscriptionid] = @SubscriptionID)਍ഀഀ
        -- delete the userdatabase records਍        ⴀⴀ 琀栀椀猀 眀椀氀氀 爀愀椀猀攀 愀渀搀 攀爀爀漀爀 椀昀 愀渀礀 漀昀 琀栀攀洀 愀爀攀 爀攀昀攀爀攀渀挀攀搀 戀礀 愀 猀礀渀挀最爀漀甀瀀ഀഀ
        DELETE FROM [dss].[userdatabase] WHERE [subscriptionid] = @SubscriptionID਍ഀഀ
        -- Remove agents਍        䐀䔀䰀䔀吀䔀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀愀最攀渀琀崀ഀഀ
        WHERE [subscriptionid] = @SubscriptionID਍ഀഀ
        -- Delete subscription਍        䐀䔀䰀䔀吀䔀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀䐀ഀഀ
਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
        IF (ERROR_NUMBER() = 547) -- FK/constraint violation਍        䈀䔀䜀䤀一ഀഀ
            -- some dependant tables are not cleaned up yet.਍            刀䄀䤀匀䔀刀刀伀刀⠀✀匀䔀刀嘀䔀刀开䐀䔀䰀䔀吀䔀开䌀伀一匀吀刀䄀䤀一吀开嘀䤀伀䰀䄀吀䤀伀一✀Ⰰ㄀㔀Ⰰ ㄀⤀ഀഀ
        END਍        䔀䰀匀䔀ഀഀ
        BEGIN਍             ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
            EXECUTE [dss].[RethrowError]਍        䔀一䐀ഀഀ
਍        刀䔀吀唀刀一ഀഀ
਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
਍䔀一䐀ഀഀ
GO਍
