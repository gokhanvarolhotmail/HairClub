/****** Object:  StoredProcedure [dss].[CreateSyncGroupV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀匀礀渀挀䜀爀漀甀瀀嘀㈀崀ഀഀ
    @SyncGroupID	UNIQUEIDENTIFIER,਍    䀀一愀洀攀ऀ嬀搀猀猀崀⸀嬀䐀䤀匀倀䰀䄀夀开一䄀䴀䔀崀Ⰰഀഀ
    @SubscriptionID UNIQUEIDENTIFIER,਍    䀀匀挀栀攀洀愀䐀攀猀挀爀椀瀀琀椀漀渀 堀䴀䰀Ⰰഀഀ
    @HubMemberID	UNIQUEIDENTIFIER,਍    䀀䌀漀渀昀氀椀挀琀刀攀猀漀氀甀琀椀漀渀倀漀氀椀挀礀 䤀一吀Ⰰഀഀ
    @SyncInterval	INT = 0,਍    䀀伀䌀匀匀挀栀攀洀愀䐀攀昀椀渀椀琀椀漀渀 一嘀䄀刀䌀䠀䄀刀⠀䴀䄀堀⤀Ⰰഀഀ
    @Version dss.VERSION = null,਍    䀀䌀漀渀昀氀椀挀琀䰀漀最最椀渀最䔀渀愀戀氀攀搀 戀椀琀 㴀 　Ⰰഀഀ
    @ConflictTableRetentionInDays int = 30਍䄀匀ഀഀ
BEGIN਍    ⴀⴀ 一漀琀攀㨀 䌀愀氀氀 琀栀椀猀 瀀爀漀挀攀搀甀爀攀 昀爀漀洀 愀 琀爀愀渀猀愀挀琀椀漀渀ഀഀ
    -- This proc does not have transaction since the caller has transactions and nested transactions਍    ⴀⴀ 挀愀甀猀攀 愀 瀀爀漀戀氀攀洀 眀椀琀栀 爀漀氀氀戀愀挀欀⸀ 圀攀 挀漀甀氀搀 甀猀攀 猀愀瘀攀 瀀漀椀渀琀猀 戀甀琀 眀攀 挀愀渀 愀搀搀 琀栀攀洀 椀昀 眀攀 渀攀攀搀 琀栀攀洀⸀ഀഀ
਍    ⴀⴀ 挀栀攀挀欀 猀挀愀氀攀 甀渀椀琀 氀椀洀椀琀 昀漀爀 猀礀渀挀最爀漀甀瀀⸀ഀഀ
    IF (([dss].[CheckSyncGroupLimit] (@SubscriptionID)) = 1)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('QUOTA_EXCEEDED_SYNCGROUP_LIMIT', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    DECLARE @SyncGroupState INT਍ഀഀ
    IF (@SchemaDescription IS NULL)਍        匀䔀吀 䀀匀礀渀挀䜀爀漀甀瀀匀琀愀琀攀 㴀 ㌀ ⴀⴀ ㌀㨀 一漀琀刀攀愀搀礀ഀഀ
    ELSE਍        匀䔀吀 䀀匀礀渀挀䜀爀漀甀瀀匀琀愀琀攀 㴀 　 ⴀⴀ 　㨀 䄀挀琀椀瘀攀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
਍        䤀一匀䔀刀吀 䤀一吀伀ഀഀ
        [dss].[syncgroup]਍        ⠀ഀഀ
            [id],਍            嬀渀愀洀攀崀Ⰰഀഀ
            [subscriptionid],਍            嬀猀挀栀攀洀愀开搀攀猀挀爀椀瀀琀椀漀渀崀Ⰰഀഀ
            [hub_memberid],਍            嬀挀漀渀昀氀椀挀琀开爀攀猀漀氀甀琀椀漀渀开瀀漀氀椀挀礀崀Ⰰഀഀ
            [sync_interval],਍            嬀氀愀猀琀甀瀀搀愀琀攀琀椀洀攀崀Ⰰഀഀ
            [ocsschemadefinition],਍            嬀猀琀愀琀攀崀Ⰰഀഀ
            [ConflictLoggingEnabled],਍            嬀䌀漀渀昀氀椀挀琀吀愀戀氀攀刀攀琀攀渀琀椀漀渀䤀渀䐀愀礀猀崀ഀഀ
        )਍        嘀䄀䰀唀䔀匀ഀഀ
        (਍            䀀匀礀渀挀䜀爀漀甀瀀䤀䐀Ⰰഀഀ
            @Name,਍            䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀䐀Ⰰഀഀ
            @SchemaDescription,਍            䀀䠀甀戀䴀攀洀戀攀爀䤀䐀Ⰰഀഀ
            @ConflictResolutionPolicy,਍            䀀匀礀渀挀䤀渀琀攀爀瘀愀氀Ⰰഀഀ
            GETUTCDATE(),਍            䀀伀䌀匀匀挀栀攀洀愀䐀攀昀椀渀椀琀椀漀渀Ⰰഀഀ
            @SyncGroupState,਍            䀀䌀漀渀昀氀椀挀琀䰀漀最最椀渀最䔀渀愀戀氀攀搀Ⰰഀഀ
            @ConflictTableRetentionInDays਍        ⤀ഀഀ
਍        䤀䘀 ⠀䀀匀礀渀挀䜀爀漀甀瀀匀琀愀琀攀 㴀 　⤀ഀഀ
            IF (@Version is NULL)਍                䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀䌀爀攀愀琀攀匀挀栀攀搀甀氀攀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀Ⰰ䀀匀礀渀挀䤀渀琀攀爀瘀愀氀Ⰰ　 ⴀⴀ　㴀㴀 刀攀挀甀爀爀椀渀最 匀礀渀挀 吀愀猀欀 昀漀爀 䐀匀匀ഀഀ
            ELSE਍                䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀䌀爀攀愀琀攀匀挀栀攀搀甀氀攀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀Ⰰ䀀匀礀渀挀䤀渀琀攀爀瘀愀氀Ⰰ㈀ ⴀⴀ㈀㴀㴀 刀攀挀甀爀爀椀渀最 匀礀渀挀 吀愀猀欀 昀漀爀 䄀䐀䴀匀ഀഀ
਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀⠀䔀刀刀伀刀开一唀䴀䈀䔀刀⠀⤀ 㴀 ㈀㘀㈀㜀⤀ ⴀⴀ 倀爀椀洀愀爀礀 䬀攀礀 嘀椀漀氀愀琀椀漀渀ഀഀ
            BEGIN਍                刀䄀䤀匀䔀刀刀伀刀⠀✀䐀唀倀䰀䤀䌀䄀吀䔀开匀夀一䌀开䜀刀伀唀倀开一䄀䴀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
            END਍            䔀䰀匀䔀ഀഀ
            BEGIN਍                ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
                EXECUTE [dss].[RethrowError]਍            䔀一䐀ഀഀ
        RETURN਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
END਍䜀伀ഀഀ
