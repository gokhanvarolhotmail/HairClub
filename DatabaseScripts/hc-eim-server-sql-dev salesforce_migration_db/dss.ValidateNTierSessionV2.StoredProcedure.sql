/****** Object:  StoredProcedure [dss].[ValidateNTierSessionV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 吀伀䐀伀㨀 刀攀洀漀瘀攀 琀栀椀猀 匀倀 愀昀琀攀爀 匀唀　㈀ⴀ㈀　㄀㌀ഀഀ
CREATE PROCEDURE [dss].[ValidateNTierSessionV2]਍    䀀䐀猀猀匀攀爀瘀攀爀䤀搀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @AgentId		UNIQUEIDENTIFIER,਍    䀀匀礀渀挀䜀爀漀甀瀀䤀搀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @LocalDatabaseId	UNIQUEIDENTIFIER,਍    䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀䤀搀ऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @TaskId				UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䐀䔀䌀䰀䄀刀䔀 䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀ऀ䈀䤀吀 㴀 一唀䰀䰀ഀഀ
    DECLARE @InternalServerId		UNIQUEIDENTIFIER = NULL਍    䐀䔀䌀䰀䄀刀䔀 䀀䄀最攀渀琀匀琀愀琀攀ऀऀऀऀ䤀一吀 㴀 一唀䰀䰀ഀഀ
    DECLARE @InternalHubDatabaseId	UNIQUEIDENTIFIER = NULL਍    䐀䔀䌀䰀䄀刀䔀 䀀䤀渀琀攀爀渀愀氀匀礀渀挀䜀爀漀甀瀀匀攀爀瘀攀爀䤀搀ऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 一唀䰀䰀ഀഀ
    DECLARE	@SyncGroupState			INT = NULL਍ഀഀ
    DECLARE @LocalDatabaseServerId		UNIQUEIDENTIFIER = NULL਍    䐀䔀䌀䰀䄀刀䔀 䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀䄀最攀渀琀䤀搀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 一唀䰀䰀ഀഀ
    DECLARE @LocalDatabaseOnPremise	BIT = NULL਍    䐀䔀䌀䰀䄀刀䔀 䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀匀琀愀琀攀ऀऀ䤀一吀 㴀 一唀䰀䰀ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 一唀䰀䰀ഀഀ
    DECLARE @RemoteDatabaseOnPremise	BIT = NULL਍    䐀䔀䌀䰀䄀刀䔀 䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀琀愀琀攀ऀऀ䤀一吀 㴀 一唀䰀䰀ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀吀愀猀欀匀琀愀琀攀ऀ䤀一吀 㴀 一唀䰀䰀ഀഀ
    DECLARE @TaskAgentId	UNIQUEIDENTIFIER = NULL਍ഀഀ
    SELECT਍            䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀Ⰰഀഀ
            @InternalServerId = [subscriptionid],਍            䀀䄀最攀渀琀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀ഀഀ
        FROM [dss].[agent]਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀ഀഀ
਍    䤀䘀 䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 ㄀ഀഀ
    BEGIN਍        䤀䘀 ⠀䀀䤀渀琀攀爀渀愀氀匀攀爀瘀攀爀䤀搀 䤀匀 一唀䰀䰀⤀ഀഀ
        BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䄀䜀䔀一吀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
਍        䤀䘀 ⠀䀀䤀渀琀攀爀渀愀氀匀攀爀瘀攀爀䤀搀 㰀㸀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀⤀ഀഀ
        BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䰀伀䌀䄀䰀开䄀䜀䔀一吀开一伀吀开䤀一开䐀匀匀匀䔀刀嘀䔀刀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
਍        䤀䘀 ⠀䀀䄀最攀渀琀匀琀愀琀攀 㰀㸀 ㄀⤀ ⴀⴀ ㄀㨀 愀挀琀椀瘀攀ഀഀ
        BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䰀伀䌀䄀䰀开䄀䜀䔀一吀开一伀吀开䄀䌀吀䤀嘀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
    END਍ഀഀ
    SELECT਍        䀀吀愀猀欀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀Ⰰഀഀ
        @TaskAgentId = [agentid]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀ഀഀ
    WHERE [id] = @TaskId਍ഀഀ
    IF (@TaskState IS NULL)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('INVALID_TASK', 15, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    -- Check Agent਍    䤀䘀 ⠀䀀䄀最攀渀琀䤀搀 㰀㸀 䀀吀愀猀欀䄀最攀渀琀䤀搀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀吀䄀匀䬀开䄀䜀䔀一吀开䴀䤀匀䴀䄀吀䌀䠀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀ 䌀栀攀挀欀 猀琀愀琀攀ഀഀ
    -- Raise error when the task is processing or cancelling਍    䤀䘀 ⠀䀀吀愀猀欀匀琀愀琀攀 㰀㸀 ⴀ㄀ 䄀一䐀 䀀吀愀猀欀匀琀愀琀攀 㰀㸀 ⴀ㐀⤀ ⴀⴀ ⴀ㄀㨀 瀀爀漀挀攀猀猀椀渀最 ⴀ㐀㨀 挀愀渀挀攀氀氀椀渀最ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀吀䄀匀䬀开一伀吀开䤀一开倀刀伀䌀䔀匀匀䤀一䜀开匀吀䄀吀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        @LocalDatabaseServerId = [subscriptionid],਍        䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀䄀最攀渀琀䤀搀 㴀 嬀愀最攀渀琀椀搀崀Ⰰഀഀ
        @LocalDatabaseOnPremise = [is_on_premise],਍        䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀ഀഀ
    FROM [dss].[userdatabase]਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍    䤀䘀 ⠀䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀 䤀匀 一唀䰀䰀⤀ ⴀⴀ 渀漀渀 渀甀氀氀愀戀氀攀 挀漀氀甀洀渀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䰀伀䌀䄀䰀开䐀䄀吀䄀䈀䄀匀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀 㰀㸀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䰀伀䌀䄀䰀开䐀䄀吀䄀䈀䄀匀䔀开一伀吀开䤀一开䐀匀匀匀䔀刀嘀䔀刀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 䀀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 ㄀ഀഀ
    BEGIN਍        䤀䘀 ⠀䀀䰀漀挀愀氀䐀愀琀愀戀愀猀攀伀渀倀爀攀洀椀猀攀 㰀㸀 ㄀⤀ ⴀⴀ ㄀㨀 漀渀瀀爀攀洀椀猀攀ഀഀ
        BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䰀伀䌀䄀䰀开䐀䄀吀䄀䈀䄀匀䔀开一伀吀开䰀伀䌀䄀䰀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
    END਍ഀഀ
    IF (@LocalDatabaseState = 5) -- 5: SuspendedDueToWrongCredentials਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('LOCAL_DATABASE_SUSPENDED', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF (@LocalDatabaseAgentId <> @AgentId)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('LOCAL_DATABASE_AGENT_MISMATCH', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    SELECT਍        䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀 㴀 嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀Ⰰഀഀ
        @RemoteDatabaseOnPremise = [is_on_premise],਍        䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀ഀഀ
    FROM [dss].[userdatabase]਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍    䤀䘀 ⠀䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀 䤀匀 一唀䰀䰀⤀ ⴀⴀ 渀漀渀 渀甀氀氀愀戀氀攀 挀漀氀甀洀渀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䤀一嘀䄀䰀䤀䐀开䌀䰀伀唀䐀开䐀䄀吀䄀䈀䄀匀䔀✀Ⰰ ㄀㔀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀攀爀瘀攀爀䤀搀 㰀㸀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䌀䰀伀唀䐀开䐀䄀吀䄀䈀䄀匀䔀开一伀吀开䤀一开䐀匀匀匀䔀刀嘀䔀刀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀伀渀倀爀攀洀椀猀攀 㰀㸀 　⤀ ⴀⴀ 　㨀 挀氀漀甀搀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䌀䰀伀唀䐀开䐀䄀吀䄀䈀䄀匀䔀开一伀吀开䌀䰀伀唀䐀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀刀攀洀漀琀攀䐀愀琀愀戀愀猀攀匀琀愀琀攀 㴀 㔀⤀ ⴀⴀ 㔀㨀 匀甀猀瀀攀渀搀攀搀䐀甀攀吀漀圀爀漀渀最䌀爀攀搀攀渀琀椀愀氀猀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䌀䰀伀唀䐀开䐀䄀吀䄀䈀䄀匀䔀开匀唀匀倀䔀一䐀䔀䐀✀Ⰰ ㄀㔀Ⰰ ㄀⤀㬀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    匀䔀䰀䔀䌀吀ഀഀ
        @InternalSyncGroupServerId = [subscriptionid],਍        䀀匀礀渀挀䜀爀漀甀瀀匀琀愀琀攀 㴀 嬀猀琀愀琀攀崀Ⰰഀഀ
        @InternalHubDatabaseId = [hub_memberid]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀ഀഀ
    WHERE [id] = @SyncGroupId਍ഀഀ
    IF (@InternalSyncGroupServerId IS NULL)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('INVALID_SYNC_GROUP', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF (@InternalSyncGroupServerId <> @DssServerId)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('SYNC_GROUP_NOT_IN_DSSSERVER', 15, 1);਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF @AgentOnPremise = 1਍    䈀䔀䜀䤀一ഀഀ
        IF (@InternalHubDatabaseId <> @RemoteDatabaseId)਍        䈀䔀䜀䤀一ഀഀ
            RAISERROR('CLOUD_DATABASE_NOT_HUB', 15, 1);਍            刀䔀吀唀刀一ഀഀ
        END਍ഀഀ
        IF NOT EXISTS (SELECT 1 FROM [dss].[syncgroupmember] WHERE [syncgroupid] = @SyncGroupId AND [databaseid] = @LocalDatabaseId)਍        䈀䔀䜀䤀一ഀഀ
            RAISERROR('INVALID_SYNC_GROUP_MEMBER', 15, 1);਍            刀䔀吀唀刀一ഀഀ
        END਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
