/****** Object:  StoredProcedure [dss].[ResetSyncGroupMemberHubState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀刀攀猀攀琀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䠀甀戀匀琀愀琀攀崀ഀഀ
    @SyncGroupMemberID	UNIQUEIDENTIFIER,਍    䀀䴀攀洀戀攀爀䠀甀戀匀琀愀琀攀ऀऀ䤀一吀Ⰰഀഀ
    @ConditionalMemberHubState INT਍䄀匀ഀഀ
BEGIN਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
    SET਍        嬀栀甀戀猀琀愀琀攀崀 㴀 䀀䴀攀洀戀攀爀䠀甀戀匀琀愀琀攀Ⰰഀഀ
        [hubstate_lastupdated] = GETUTCDATE()਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀䐀 䄀一䐀 嬀栀甀戀猀琀愀琀攀崀 㴀 䀀䌀漀渀搀椀琀椀漀渀愀氀䴀攀洀戀攀爀䠀甀戀匀琀愀琀攀ഀഀ
਍    匀䔀䰀䔀䌀吀 䀀䀀刀伀圀䌀伀唀一吀ഀഀ
END਍䜀伀ഀഀ
