/****** Object:  StoredProcedure [dss].[UpdateSyncGroupMemberHubState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䠀甀戀匀琀愀琀攀崀ഀഀ
    @SyncGroupMemberID	UNIQUEIDENTIFIER,਍    䀀䠀甀戀匀琀愀琀攀ऀऀऀ䤀一吀Ⰰഀഀ
    @JobId             UNIQUEIDENTIFIER = NULL਍䄀匀ഀഀ
BEGIN਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
    SET਍        嬀栀甀戀猀琀愀琀攀崀 㴀 䀀䠀甀戀匀琀愀琀攀Ⰰഀഀ
        [hubstate_lastupdated] = GETUTCDATE(),਍        嬀栀甀戀䨀漀戀䤀搀崀 㴀 䀀䨀漀戀䤀搀ഀഀ
    WHERE [id] = @SyncGroupMemberID਍ഀഀ
END਍䜀伀ഀഀ
