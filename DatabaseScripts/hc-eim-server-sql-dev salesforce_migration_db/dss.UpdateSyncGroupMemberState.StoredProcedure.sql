/****** Object:  StoredProcedure [dss].[UpdateSyncGroupMemberState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀匀琀愀琀攀崀ഀഀ
    @SyncGroupMemberID	UNIQUEIDENTIFIER    ,਍    䀀䴀攀洀戀攀爀匀琀愀琀攀ऀऀ䤀一吀Ⰰഀഀ
    @DownloadChangesFailed	INT = NULL,਍    䀀唀瀀氀漀愀搀䌀栀愀渀最攀猀䘀愀椀氀攀搀 䤀一吀 㴀 一唀䰀䰀Ⰰഀഀ
    @JobId             UNIQUEIDENTIFIER = NULL਍䄀匀ഀഀ
BEGIN਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    䤀䘀 ⠀䀀䴀攀洀戀攀爀匀琀愀琀攀 㰀㸀 㔀⤀ ⴀⴀ 㔀㨀 匀礀渀挀匀甀挀挀攀攀搀攀搀⸀ഀഀ
    BEGIN਍        唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
        SET਍            嬀洀攀洀戀攀爀猀琀愀琀攀崀 㴀 䀀䴀攀洀戀攀爀匀琀愀琀攀Ⰰഀഀ
            [memberstate_lastupdated] = GETUTCDATE(),਍            嬀樀漀戀䤀搀崀 㴀 䀀䨀漀戀䤀搀ഀഀ
        WHERE [id] = @SyncGroupMemberID਍    䔀一䐀ഀഀ
    ELSE -- If SyncSucceeded then update [lastsynctime]਍    䈀䔀䜀䤀一ഀഀ
        UPDATE [dss].[syncgroupmember]਍        匀䔀吀ഀഀ
            [memberstate] = @MemberState,਍            嬀洀攀洀戀攀爀猀琀愀琀攀开氀愀猀琀甀瀀搀愀琀攀搀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
            [JobId] = @JobId,਍            嬀氀愀猀琀猀礀渀挀琀椀洀攀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀ഀഀ
        WHERE [id] = @SyncGroupMemberID਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀䴀攀洀戀攀爀匀琀愀琀攀 䤀一 ⠀㔀Ⰰ ㄀㈀⤀⤀ ⴀⴀ 㔀㨀 匀礀渀挀匀甀挀挀攀攀搀攀搀⸀ ㄀㈀㨀 匀礀渀挀匀甀挀挀攀攀搀攀搀圀椀琀栀圀愀爀渀椀渀最猀ഀഀ
    BEGIN਍        唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
        SET਍            嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀 㴀 䌀䄀匀䔀 圀䠀䔀一 䀀䐀漀眀渀氀漀愀搀䌀栀愀渀最攀猀䘀愀椀氀攀搀 㴀 　 吀䠀䔀一 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀ 䔀䰀匀䔀 嬀氀愀猀琀猀礀渀挀琀椀洀攀开稀攀爀漀昀愀椀氀甀爀攀猀开洀攀洀戀攀爀崀 䔀一䐀Ⰰഀഀ
            [lastsynctime_zerofailures_hub] = CASE WHEN @UploadChangesFailed = 0 THEN GETUTCDATE() ELSE [lastsynctime_zerofailures_hub] END਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀䐀ഀഀ
    END਍䔀一䐀ഀഀ
GO਍
