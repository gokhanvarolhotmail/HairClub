/****** Object:  StoredProcedure [dss].[UpdateSyncGroupState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀礀渀挀䜀爀漀甀瀀匀琀愀琀攀崀ഀഀ
    @SyncGroupId UNIQUEIDENTIFIER,਍    䀀匀琀愀琀攀ऀऀ 䤀一吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    UPDATE [dss].[syncgroup]਍    匀䔀吀ഀഀ
        [state] = @State਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀搀ഀഀ
END਍䜀伀ഀഀ
