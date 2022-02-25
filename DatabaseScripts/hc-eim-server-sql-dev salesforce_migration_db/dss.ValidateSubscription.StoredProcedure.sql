/****** Object:  StoredProcedure [dss].[ValidateSubscription]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 嘀愀氀椀搀愀琀攀 眀栀攀琀栀攀爀 愀 猀甀戀猀挀爀椀瀀琀椀漀渀 ⠀搀猀猀匀攀爀瘀攀爀⤀ 椀猀 瘀愀氀椀搀 愀渀搀 椀琀 漀眀渀猀 漀琀栀攀爀 猀甀戀挀漀洀瀀漀渀攀渀琀猀⸀ഀഀ
-- Return 0 if subscription is normal/valid and all other checks pass.਍ⴀⴀ 刀攀琀甀爀渀 ㄀ 椀昀 愀 猀甀戀猀挀爀椀瀀琀椀漀渀 椀猀 搀椀猀愀戀氀攀搀⸀ഀഀ
-- Return 2 if a subscription is not found.਍ⴀⴀ 刀攀琀甀爀渀 ㌀ 椀昀 搀猀猀匀攀爀瘀攀爀 搀漀攀猀 渀漀琀 漀眀渀 琀栀攀 猀礀渀挀 最爀漀甀瀀 眀栀攀渀 猀礀渀挀䜀爀漀甀瀀䤀搀 椀猀 渀漀琀 渀甀氀氀⸀ഀഀ
-- Return 4 if dssServer does not own the sync agent when agentId is not null.਍ⴀⴀ 刀攀琀甀爀渀 㔀 椀昀 搀猀猀匀攀爀瘀攀爀 搀漀攀猀 渀漀琀 漀眀渀 琀栀攀 搀愀琀愀戀愀猀攀猀 眀栀攀渀 搀愀琀愀戀愀猀攀䤀搀猀 椀猀 渀漀琀 渀甀氀氀⸀ഀഀ
਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀嘀愀氀椀搀愀琀攀匀甀戀猀挀爀椀瀀琀椀漀渀崀ഀഀ
    @DssServerId UNIQUEIDENTIFIER,  -- This MUST NOT be null.਍    䀀匀礀渀挀䜀爀漀甀瀀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰ  ⴀⴀ 吀栀椀猀 挀漀甀氀搀 戀攀 渀甀氀氀Ⰰ 椀昀 渀漀琀 渀甀氀氀Ⰰ 椀琀 眀椀氀氀 戀攀 瘀攀爀椀昀椀攀搀 愀最愀椀渀猀琀 䐀猀猀匀攀爀瘀攀爀䤀搀ഀഀ
    @AgentId     UNIQUEIDENTIFIER,  -- This could be null, if not null, it will be verified against DssServerId਍    䀀䐀愀琀愀戀愀猀攀䤀搀猀 嘀䄀刀䌀䠀䄀刀⠀㠀　　　⤀      ⴀⴀ 吀栀椀猀 挀漀甀氀搀 戀攀 渀甀氀氀Ⰰ 椀昀 渀漀琀 渀甀氀氀Ⰰ 椀琀 洀甀猀琀 椀渀 最甀椀搀㄀Ⰰ最甀椀搀㈀Ⰰ ⸀⸀⸀ 挀漀洀洀愀 猀攀瀀愀爀愀琀攀搀 昀漀爀洀愀琀ഀഀ
                                    --   It's possible to just specify one database id guid.਍                                    ⴀⴀ   䄀氀氀 琀栀攀 搀愀琀愀戀愀猀攀 椀搀猀 眀椀氀氀 戀攀 瘀攀爀椀昀椀攀搀 愀最愀椀渀猀琀 琀栀攀 䐀猀猀匀攀爀瘀攀爀䤀搀⸀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    IF @DssServerId IS NULL਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('@DssServerId argument is null.', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    ---- Check dssServer (subscription) is valid.਍    䐀䔀䌀䰀䄀刀䔀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀匀琀愀琀攀 䤀一吀ഀഀ
    SELECT @SubscriptionState = subscriptionstate FROM [dss].[subscription]਍    圀䠀䔀刀䔀 椀搀 㴀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀ഀഀ
਍    ⴀⴀ 䤀昀 猀甀戀猀挀爀椀瀀琀椀漀渀 栀愀猀 戀攀攀渀 搀椀猀愀戀氀攀搀Ⰰ ㄀ 眀椀氀氀 戀攀 爀攀琀甀爀渀攀搀⸀ഀഀ
    -- If subscription does not exist, 2 will be returned,਍    椀昀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀匀琀愀琀攀 䤀匀 一唀䰀䰀 伀刀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀匀琀愀琀攀 㴀 ㄀ഀഀ
    BEGIN਍        匀䔀䰀䔀䌀吀 䤀匀一唀䰀䰀⠀䀀匀甀戀猀挀爀椀瀀琀椀漀渀匀琀愀琀攀Ⰰ ㈀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    ⴀⴀⴀⴀ 䌀栀攀挀欀 猀礀渀挀䜀爀漀甀瀀 戀攀氀漀渀最猀 琀漀 搀猀猀匀攀爀瘀攀爀 椀昀 匀礀渀挀䜀爀漀甀瀀䤀搀 渀漀琀 渀甀氀氀Ⰰ 爀攀琀甀爀渀 ㌀ 椀昀 渀漀琀⸀ഀഀ
    if @SyncGroupId IS NOT NULL਍    䈀䔀䜀䤀一ഀഀ
        if NOT EXISTS (SELECT id FROM dss.syncgroup WHERE id = @SyncGroupId AND subscriptionid = @DssServerId)਍        䈀䔀䜀䤀一ഀഀ
            SELECT 3਍            刀䔀吀唀刀一ഀഀ
        END਍    䔀一䐀ഀഀ
਍    ⴀⴀⴀⴀ 䌀栀攀挀欀 猀礀渀挀 愀最攀渀琀 戀攀氀漀渀最猀 琀漀 搀猀猀匀攀爀瘀攀爀 椀昀 䄀最攀渀琀䤀搀 渀漀琀 渀甀氀氀Ⰰ 爀攀琀甀爀渀 㐀 椀昀 渀漀琀⸀ഀഀ
    if @AgentId IS NOT NULL਍    䈀䔀䜀䤀一ഀഀ
        -- Will not check cloud agent's subscription id਍        椀昀 一伀吀 䔀堀䤀匀吀匀 ⠀匀䔀䰀䔀䌀吀 椀搀 䘀刀伀䴀 搀猀猀⸀愀最攀渀琀 圀䠀䔀刀䔀 椀搀 㴀 䀀䄀最攀渀琀䤀搀 䄀一䐀 ⠀椀猀开漀渀开瀀爀攀洀椀猀攀 㴀 　 伀刀 猀甀戀猀挀爀椀瀀琀椀漀渀椀搀 㴀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀⤀⤀ഀഀ
        BEGIN਍            匀䔀䰀䔀䌀吀 㐀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
    END਍ഀഀ
    ---- Check all database ids belong to dssServer if DatabaseIds not null, return 5 if not.਍    椀昀 䀀䐀愀琀愀戀愀猀攀䤀搀猀 䤀匀 一伀吀 一唀䰀䰀ഀഀ
    BEGIN਍        䐀䔀䌀䰀䄀刀䔀 䀀䐀戀䤀搀吀愀戀氀攀 琀愀戀氀攀 ⠀搀愀琀愀戀愀猀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀⤀ഀഀ
        DECLARE @StartPos INT = 1, @Pos INT਍        䐀䔀䌀䰀䄀刀䔀 䀀䐀攀氀椀洀椀琀攀爀 一嘀䄀刀䌀䠀䄀刀⠀㌀⤀ 㴀 ✀Ⰰ✀ഀഀ
        DECLARE @DbId VARCHAR(128)਍ഀഀ
        -- Trim whole string and append a comma(,) at the end for easier handling.਍        匀䔀吀 䀀䐀愀琀愀戀愀猀攀䤀搀猀 㴀 䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀䀀䐀愀琀愀戀愀猀攀䤀搀猀⤀⤀ ⬀ 䀀䐀攀氀椀洀椀琀攀爀ഀഀ
        SET @Pos = CHARINDEX(@Delimiter, @DatabaseIds)਍        圀䠀䤀䰀䔀 䀀倀漀猀 ℀㴀 　ഀഀ
        BEGIN਍            匀䔀吀 䀀䐀戀䤀搀 㴀 䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀匀唀䈀匀吀刀䤀一䜀⠀䀀䐀愀琀愀戀愀猀攀䤀搀猀Ⰰ 䀀匀琀愀爀琀倀漀猀Ⰰ 䀀倀漀猀 ⴀ 䀀匀琀愀爀琀倀漀猀⤀⤀⤀ഀഀ
            IF @DbId != '' INSERT @DbIdTable(databaseId) values(@DbId)਍            匀䔀吀 䀀匀琀愀爀琀倀漀猀 㴀 䀀倀漀猀 ⬀ ㄀ഀഀ
            SET @pos = CHARINDEX(@Delimiter, @DatabaseIds, @StartPos)਍        䔀一䐀ഀഀ
        -- DEBUG: SELECT * FROM @DbIdTable਍ഀഀ
        DECLARE @inputCount INT, @validCount INT਍        匀䔀䰀䔀䌀吀 䀀椀渀瀀甀琀䌀漀甀渀琀 㴀 䌀伀唀一吀⠀⨀⤀ 䘀刀伀䴀 䀀䐀戀䤀搀吀愀戀氀攀ഀഀ
        SELECT @validCount = COUNT(*) FROM @DbIdTable JOIN dss.userdatabase ud਍                伀一 搀愀琀愀戀愀猀攀䤀搀 㴀 甀搀⸀椀搀ഀഀ
                WHERE subscriptionid = @DssServerId਍        䤀䘀 䀀椀渀瀀甀琀䌀漀甀渀琀 ℀㴀 䀀瘀愀氀椀搀䌀漀甀渀琀ഀഀ
        BEGIN਍            匀䔀䰀䔀䌀吀 㔀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
    END਍ഀഀ
    ---- Everything is normal, return 0.਍    匀䔀䰀䔀䌀吀 　ഀഀ
END਍䜀伀ഀഀ
