/****** Object:  StoredProcedure [dss].[UpdateSyncMemberNoInitSync]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀礀渀挀䴀攀洀戀攀爀一漀䤀渀椀琀匀礀渀挀崀ഀഀ
    @syncMemberId uniqueidentifier,਍    䀀渀漀䤀渀椀琀匀礀渀挀 戀椀琀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SET NOCOUNT ON਍ഀഀ
    UPDATE [dss].[syncgroupmember]਍    匀䔀吀ഀഀ
        [noinitsync] = @noInitSync਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀猀礀渀挀䴀攀洀戀攀爀䤀搀ഀഀ
਍䔀一䐀ഀഀ
GO਍
