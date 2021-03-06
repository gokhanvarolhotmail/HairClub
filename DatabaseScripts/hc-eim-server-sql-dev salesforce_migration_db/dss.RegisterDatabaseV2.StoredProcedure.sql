/****** Object:  StoredProcedure [dss].[RegisterDatabaseV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀刀攀最椀猀琀攀爀䐀愀琀愀戀愀猀攀嘀㈀崀ഀഀ
    @SubscriptionID UNIQUEIDENTIFIER,਍    䀀匀攀爀瘀攀爀一愀洀攀ऀऀ一嘀䄀刀䌀䠀䄀刀⠀㈀㔀㘀⤀Ⰰഀഀ
    @DatabaseName	NVARCHAR(256),਍    䀀䄀最攀渀琀䤀䐀ऀऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @ConnectionString NVARCHAR(MAX),਍    䀀刀攀最椀漀渀         一嘀䄀刀䌀䠀䄀刀⠀㈀㔀㘀⤀Ⰰഀഀ
    @IsOnPremise	BIT,਍    䀀䌀攀爀琀椀昀椀挀愀琀攀一愀洀攀 一嘀䄀刀䌀䠀䄀刀⠀㄀㈀㠀⤀Ⰰഀഀ
    @EncryptionKeyName NVARCHAR(128),਍    䀀䐀愀琀愀戀愀猀攀䤀䐀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 一唀䰀䰀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @InternalSubscriptionID UNIQUEIDENTIFIER਍    䐀䔀䌀䰀䄀刀䔀 䀀䤀渀琀攀爀渀愀氀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 䈀䤀吀ഀഀ
਍    匀䔀吀 䀀䤀渀琀攀爀渀愀氀匀甀戀猀挀爀椀瀀琀椀漀渀䤀䐀 㴀 䀀匀甀戀猀挀爀椀瀀琀椀漀渀䤀䐀ഀഀ
਍    䤀䘀 ⠀䀀䤀猀伀渀倀爀攀洀椀猀攀 㴀 ㄀⤀ ⴀⴀ 氀漀挀愀氀 搀愀琀愀戀愀猀攀 爀攀最椀猀琀爀愀琀椀漀渀ഀഀ
    BEGIN਍        匀䔀䰀䔀䌀吀ഀഀ
            @InternalSubscriptionID = [subscriptionid],਍            䀀䤀渀琀攀爀渀愀氀䄀最攀渀琀伀渀倀爀攀洀椀猀攀 㴀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀ഀഀ
        FROM [dss].[agent]਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀䐀ഀഀ
਍        ⴀⴀ 䌀栀攀挀欀 眀栀攀琀栀攀爀 琀栀攀 氀漀挀愀氀 愀最攀渀琀 攀砀椀猀琀猀ഀഀ
        IF (@InternalSubscriptionID IS NULL)਍        䈀䔀䜀䤀一ഀഀ
            RAISERROR('LOCAL_AGENT_NOT_EXISTS', 15, 1);਍            刀䔀吀唀刀一㬀ഀഀ
        END਍ഀഀ
        IF (@InternalAgentOnPremise <> 1) -- 1: local agent਍        䈀䔀䜀䤀一ഀഀ
            RAISERROR('LOCAL_AGENT_NOT_LOCAL', 15, 1)਍            刀䔀吀唀刀一ഀഀ
        END਍    䔀一䐀ഀഀ
਍    䤀䘀 ⠀䀀䤀猀伀渀倀爀攀洀椀猀攀 㴀 　⤀ഀഀ
    BEGIN਍        䤀䘀 一伀吀 䔀堀䤀匀吀匀ഀഀ
            (SELECT * FROM sys.certificates WHERE name = @CertificateName)਍        䈀䔀䜀䤀一ഀഀ
            RAISERROR('CERTIFICATE_NOT_EXIST', 16, 1)਍            刀䔀吀唀刀一ഀഀ
        END਍ഀഀ
        IF NOT EXISTS਍            ⠀匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 猀礀猀⸀猀礀洀洀攀琀爀椀挀开欀攀礀猀 圀䠀䔀刀䔀 渀愀洀攀 㴀 䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀⤀ഀഀ
        BEGIN਍            刀䄀䤀匀䔀刀刀伀刀⠀✀䔀一䌀刀夀倀吀䤀伀一开䬀䔀夀开一伀吀开䔀堀䤀匀吀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
            RETURN਍        䔀一䐀ഀഀ
    END਍ഀഀ
    IF (@DatabaseID IS NULL)਍        匀䔀吀 䀀䐀愀琀愀戀愀猀攀䤀䐀 㴀 一䔀圀䤀䐀⠀⤀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        IF (@IsOnPremise = 0)਍            䔀堀䔀䌀⠀✀伀倀䔀一 匀夀䴀䴀䔀吀刀䤀䌀 䬀䔀夀 ✀⬀ 䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀 ⬀ ✀ 䐀䔀䌀刀夀倀吀䤀伀一 䈀夀 䌀䔀刀吀䤀䘀䤀䌀䄀吀䔀 ✀ ⬀ 䀀䌀攀爀琀椀昀椀挀愀琀攀一愀洀攀⤀ഀഀ
਍        䤀一匀䔀刀吀 䤀一吀伀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
        (਍            嬀椀搀崀Ⰰഀഀ
            [server],਍            嬀搀愀琀愀戀愀猀攀崀Ⰰഀഀ
            [subscriptionid],਍            嬀愀最攀渀琀椀搀崀Ⰰഀഀ
            [connection_string],਍            嬀搀戀开猀挀栀攀洀愀崀Ⰰഀഀ
            [is_on_premise],਍            嬀爀攀最椀漀渀崀Ⰰഀഀ
            [sqlazure_info],਍            嬀氀愀猀琀开猀挀栀攀洀愀开甀瀀搀愀琀攀搀崀Ⰰഀഀ
            [last_tombstonecleanup]਍        ⤀ഀഀ
        VALUES਍        ⠀ഀഀ
            @DatabaseID,਍            䀀匀攀爀瘀攀爀一愀洀攀Ⰰഀഀ
            @DatabaseName,਍            䀀䤀渀琀攀爀渀愀氀匀甀戀猀挀爀椀瀀琀椀漀渀䤀䐀Ⰰഀഀ
            @AgentID,਍            䌀䄀匀䔀 圀䠀䔀一 䀀䤀猀伀渀倀爀攀洀椀猀攀 㴀 　 吀䠀䔀一ഀഀ
                EncryptByKey(Key_GUID(@EncryptionKeyName), @ConnectionString)਍            䔀䰀匀䔀ഀഀ
                NULL਍            䔀一䐀Ⰰഀഀ
            NULL,਍            䀀䤀猀伀渀倀爀攀洀椀猀攀Ⰰഀഀ
            @Region,਍            一唀䰀䰀Ⰰഀഀ
            GETUTCDATE(),਍            䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀ഀഀ
        )਍ഀഀ
        IF (@IsOnPremise = 0)਍            䔀堀䔀䌀⠀✀䌀䰀伀匀䔀 匀夀䴀䴀䔀吀刀䤀䌀 䬀䔀夀 ✀ ⬀ 䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀⤀ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF(ERROR_NUMBER() = 2601) -- Unique Index Violation਍            䈀䔀䜀䤀一ഀഀ
                RAISERROR('DUPLICATE_DATABASE_REFERENCE_NAME', 15, 1)਍            䔀一䐀ഀഀ
        ELSE਍            䈀䔀䜀䤀一ഀഀ
                -- get error infromation and raise error਍                䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
            END਍        刀䔀吀唀刀一ഀഀ
    END CATCH਍ഀഀ
    SELECT @DatabaseID AS [DatabaseId]਍䔀一䐀ഀഀ
GO਍
