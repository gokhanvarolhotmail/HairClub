/****** Object:  StoredProcedure [dss].[GetLocalAgentsForSubscription]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䰀漀挀愀氀䄀最攀渀琀猀䘀漀爀匀甀戀猀挀爀椀瀀琀椀漀渀崀ഀഀ
    @SubscriptionId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    ⴀⴀ 儀㨀 䄀挀琀椀瘀攀⼀䤀渀愀挀琀椀瘀攀㼀ഀഀ
    SELECT਍        愀⸀嬀椀搀崀Ⰰഀഀ
        a.[name],਍        愀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀Ⰰഀഀ
        a.[state],਍        愀⸀嬀氀愀猀琀愀氀椀瘀攀琀椀洀攀崀Ⰰഀഀ
        a.[is_on_premise],਍        愀⸀嬀瘀攀爀猀椀漀渀崀Ⰰഀഀ
        a.[password_hash],਍        愀⸀嬀瀀愀猀猀眀漀爀搀开猀愀氀琀崀ഀഀ
    FROM [dss].[agent] a਍    圀䠀䔀刀䔀 愀⸀嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀 㴀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀搀 䄀一䐀 愀⸀嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀 㴀 ㄀ഀഀ
਍䔀一䐀ഀഀ
GO਍
