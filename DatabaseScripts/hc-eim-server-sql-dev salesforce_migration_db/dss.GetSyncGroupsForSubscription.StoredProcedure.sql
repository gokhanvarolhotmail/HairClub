/****** Object:  StoredProcedure [dss].[GetSyncGroupsForSubscription]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀匀礀渀挀䜀爀漀甀瀀猀䘀漀爀匀甀戀猀挀爀椀瀀琀椀漀渀崀ഀഀ
    @SubscriptionId UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀渀愀洀攀崀Ⰰഀഀ
        [subscriptionid],਍        嬀猀挀栀攀洀愀开搀攀猀挀爀椀瀀琀椀漀渀崀Ⰰഀഀ
        [state],਍        嬀栀甀戀开洀攀洀戀攀爀椀搀崀Ⰰഀഀ
        [conflict_resolution_policy],਍        嬀猀礀渀挀开椀渀琀攀爀瘀愀氀崀Ⰰഀഀ
        [lastupdatetime],਍        嬀漀挀猀猀挀栀攀洀愀搀攀昀椀渀椀琀椀漀渀崀Ⰰഀഀ
        [hubhasdata]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀ഀഀ
    WHERE [subscriptionid] = @SubscriptionId਍䔀一䐀ഀഀ
GO਍
