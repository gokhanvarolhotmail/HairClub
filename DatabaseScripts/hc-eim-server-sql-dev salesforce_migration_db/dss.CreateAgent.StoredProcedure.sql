/****** Object:  StoredProcedure [dss].[CreateAgent]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀䄀最攀渀琀崀ഀഀ
    @AgentID	UNIQUEIDENTIFIER,਍    䀀一愀洀攀ऀ嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀Ⰰഀഀ
    @SubscriptionID	UNIQUEIDENTIFIER,਍    䀀䤀猀伀渀倀爀攀洀椀猀攀ऀ䈀䤀吀Ⰰഀഀ
    @Version	[dss].[VERSION]਍䄀匀ഀഀ
BEGIN਍ഀഀ
    BEGIN TRY਍        䤀一匀䔀刀吀 䤀一吀伀ഀഀ
        [dss].[agent]਍        ⠀ഀഀ
            [id],਍            嬀渀愀洀攀崀Ⰰഀഀ
            [subscriptionid],਍            嬀猀琀愀琀攀崀Ⰰഀഀ
            [lastalivetime],਍            嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀Ⰰഀഀ
            [version],਍            嬀瀀愀猀猀眀漀爀搀开栀愀猀栀崀Ⰰഀഀ
            [password_salt]਍        ⤀ഀഀ
        VALUES਍        ⠀ഀഀ
            @AgentID,਍            䀀一愀洀攀Ⰰഀഀ
            @SubscriptionID,਍            ㄀Ⰰ ⴀⴀ ㄀㨀 愀挀琀椀瘀攀ഀഀ
            NULL,਍            䀀䤀猀伀渀倀爀攀洀椀猀攀Ⰰഀഀ
            @Version,਍            一唀䰀䰀Ⰰഀഀ
            NULL਍        ⤀ഀഀ
਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍         䤀䘀 ⠀䔀刀刀伀刀开一唀䴀䈀䔀刀⠀⤀ 㴀 ㈀㘀　㄀⤀ ⴀⴀ 䤀渀搀攀砀 瘀椀漀氀愀琀椀漀渀ഀഀ
         BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䐀唀倀䰀䤀䌀䄀吀䔀开䄀䜀䔀一吀一䄀䴀䔀✀Ⰰ㄀㔀Ⰰ ㄀⤀ഀഀ
         END਍         䔀䰀匀䔀ഀഀ
         BEGIN਍             ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
            EXECUTE [dss].[RethrowError]਍            䔀一䐀ഀഀ
਍        刀䔀吀唀刀一ഀഀ
    END CATCH਍ഀഀ
END਍䜀伀ഀഀ
