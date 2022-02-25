/****** Object:  StoredProcedure [dss].[CreateSubscriptionV2]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀爀攀愀琀攀匀甀戀猀挀爀椀瀀琀椀漀渀嘀㈀崀ഀഀ
    @Name [dss].[DISPLAY_NAME],਍    䀀吀漀洀戀猀琀漀渀攀刀攀琀攀渀琀椀漀渀䤀渀䐀愀礀猀 椀渀琀Ⰰഀഀ
    @WindowsAzureSubscriptionId	UNIQUEIDENTIFIER,਍    䀀䐀猀猀匀攀爀瘀攀爀䤀搀ऀ唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @SyncServerUniqueName nvarchar(256) = NULL,਍    䀀嘀攀爀猀椀漀渀 嬀搀猀猀崀⸀嬀嘀䔀刀匀䤀伀一崀 㴀 一唀䰀䰀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        INSERT INTO [dss].[subscription]਍        ⠀ഀഀ
            [id],਍            嬀渀愀洀攀崀Ⰰഀഀ
            [creationtime],਍            嬀氀愀猀琀氀漀最椀渀琀椀洀攀崀Ⰰഀഀ
            [policyid],਍            嬀琀漀洀戀猀琀漀渀攀爀攀琀攀渀琀椀漀渀瀀攀爀椀漀搀椀渀搀愀礀猀崀Ⰰഀഀ
            [WindowsAzureSubscriptionId],਍            嬀猀礀渀挀猀攀爀瘀攀爀甀渀椀焀甀攀渀愀洀攀崀Ⰰഀഀ
            [version]਍        ⤀ഀഀ
        VALUES਍        ⠀ഀഀ
            @DssServerId,਍            䀀一愀洀攀Ⰰഀഀ
            GETUTCDATE(),਍            一唀䰀䰀Ⰰഀഀ
            0, -- 0:v1਍            䀀吀漀洀戀猀琀漀渀攀刀攀琀攀渀琀椀漀渀䤀渀䐀愀礀猀Ⰰഀഀ
            @WindowsAzureSubscriptionId,਍            䀀匀礀渀挀匀攀爀瘀攀爀唀渀椀焀甀攀一愀洀攀Ⰰഀഀ
            @Version਍        ⤀ഀഀ
਍        匀䔀䰀䔀䌀吀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀 䄀匀 嬀匀甀戀猀挀爀椀瀀琀椀漀渀䤀搀崀ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF(ERROR_NUMBER() = 2627) -- Primary Key Violation਍            䈀䔀䜀䤀一ഀഀ
                RAISERROR('DUPLICATE_SYNC_SERVER_ID', 15, 1)਍            䔀一䐀ഀഀ
        ELSE IF(ERROR_NUMBER() = 2601) -- Unique Index Violation਍            䈀䔀䜀䤀一ഀഀ
                RAISERROR('DUPLICATE_SYNC_SERVER_UNIQUE_NAME', 15, 1)਍            䔀一䐀ഀഀ
        ELSE਍            䈀䔀䜀䤀一ഀഀ
                -- get error infromation and raise error਍                䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
            END਍    刀䔀吀唀刀一ഀഀ
    END CATCH਍䔀一䐀ഀഀ
GO਍
