/****** Object:  StoredProcedure [dss].[CreateSyncGroupMember]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀崀ഀഀ
    @SyncGroupMemberID	UNIQUEIDENTIFIER,਍    䀀一愀洀攀ऀऀऀऀ嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀Ⰰഀഀ
    @SyncGroupID		UNIQUEIDENTIFIER,਍    䀀匀礀渀挀䐀椀爀攀挀琀椀漀渀ऀऀ䤀一吀Ⰰഀഀ
    @DatabaseID			UNIQUEIDENTIFIER,਍    䀀一漀䤀渀椀琀匀礀渀挀ऀऀऀ䈀䤀吀 㴀 　ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF (([dss].[IsSyncGroupActiveOrNotReady] (@SyncGroupID)) = 0)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('SYNCGROUP_DOES_NOT_EXIST_OR_NOT_ACTIVE', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF (([dss].[IsDatabaseInDeletingState] (@DatabaseID)) = 1)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('DATABASE_IN_DELETING_STATE', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    DECLARE @IsOnPremiseDatabase INT਍    匀䔀吀 䀀䤀猀伀渀倀爀攀洀椀猀攀䐀愀琀愀戀愀猀攀 㴀 ⠀匀䔀䰀䔀䌀吀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀䐀⤀ഀഀ
਍    ⴀⴀ 䌀栀攀挀欀 猀挀愀氀攀 甀渀椀琀 氀椀洀椀琀猀ഀഀ
਍    ⴀⴀ ㄀⸀ 搀愀琀愀戀愀猀攀 氀椀洀椀琀ഀഀ
    IF (([dss].[IsDatabaseSyncGroupMemberLimitExceeded] (@DatabaseID)) = 1)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('QUOTA_EXCEEDED_DATABASE_GROUPMEMBER_LIMIT', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    -- 2. max on-premises members਍    䤀䘀 ⠀䀀䤀猀伀渀倀爀攀洀椀猀攀䐀愀琀愀戀愀猀攀 㴀 ㄀ 䄀一䐀 ⠀嬀搀猀猀崀⸀嬀䌀栀攀挀欀伀渀倀爀攀洀椀猀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䰀椀洀椀琀崀 ⠀䀀匀礀渀挀䜀爀漀甀瀀䤀䐀⤀⤀ 㴀 ㄀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀儀唀伀吀䄀开䔀堀䌀䔀䔀䐀䔀䐀开伀一倀刀䔀䴀䤀匀䔀开䜀刀伀唀倀䴀䔀䴀䈀䔀刀开䰀䤀䴀䤀吀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ ㌀⸀ 洀愀砀 洀攀洀戀攀爀猀 愀挀爀漀猀猀 猀礀渀挀最爀漀甀瀀猀ഀഀ
    DECLARE @SubscriptionId UNIQUEIDENTIFIER਍    匀䔀吀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀搀 㴀 ⠀匀䔀䰀䔀䌀吀 嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀⤀ഀഀ
਍    䤀䘀 ⠀⠀嬀搀猀猀崀⸀嬀䌀栀攀挀欀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䰀椀洀椀琀崀 ⠀䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀搀⤀⤀ 㴀 ㄀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀儀唀伀吀䄀开䔀堀䌀䔀䔀䐀䔀䐀开䜀刀伀唀倀䴀䔀䴀䈀䔀刀开倀䔀刀匀䔀刀嘀䔀刀开䰀䤀䴀䤀吀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
਍        䤀一匀䔀刀吀 䤀一吀伀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
        (਍            嬀椀搀崀Ⰰഀഀ
            [name],਍            嬀猀礀渀挀最爀漀甀瀀椀搀崀Ⰰഀഀ
            [syncdirection],਍            嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
            [noinitsync]਍        ⤀ഀഀ
        VALUES਍        ⠀ഀഀ
            @SyncGroupMemberID,਍            䀀一愀洀攀Ⰰഀഀ
            @SyncGroupID,਍            䀀匀礀渀挀䐀椀爀攀挀琀椀漀渀Ⰰഀഀ
            @DatabaseID,਍            䀀一漀䤀渀椀琀匀礀渀挀ഀഀ
        )਍ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF(ERROR_NUMBER() = 2627) -- Unique Index Violation਍            䈀䔀䜀䤀一ഀഀ
                RAISERROR('DUPLICATE_SYNC_GROUP_MEMBER', 15, 1)਍            䔀一䐀ഀഀ
            ELSE਍            䈀䔀䜀䤀一ഀഀ
                -- get error infromation and raise error਍                䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
            END਍        刀䔀吀唀刀一ഀഀ
    END CATCH਍ഀഀ
END਍䜀伀ഀഀ
