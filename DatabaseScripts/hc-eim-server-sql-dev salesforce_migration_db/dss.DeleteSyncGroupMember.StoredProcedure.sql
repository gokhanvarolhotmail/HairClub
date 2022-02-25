/****** Object:  StoredProcedure [dss].[DeleteSyncGroupMember]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䐀攀氀攀琀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀崀ഀഀ
    @SyncGroupMemberID	UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        DECLARE @DatabaseId UNIQUEIDENTIFIER਍ഀഀ
        SELECT @DatabaseId = [databaseid]਍        䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀ഀഀ
        WHERE [id] = @SyncGroupMemberID਍ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        DELETE FROM [dss].[syncgroupmember]਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䤀䐀ഀഀ
਍        䔀堀䔀䌀 嬀搀猀猀崀⸀嬀䌀栀攀挀欀䄀渀搀䐀攀氀攀琀攀唀渀甀猀攀搀䐀愀琀愀戀愀猀攀崀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            䌀伀䴀䴀䤀吀 吀刀䄀一匀䄀䌀吀䤀伀一ഀഀ
        END਍ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            ROLLBACK TRANSACTION;਍        䔀一䐀ഀഀ
਍         ⴀⴀ 最攀琀 攀爀爀漀爀 椀渀昀爀漀洀愀琀椀漀渀 愀渀搀 爀愀椀猀攀 攀爀爀漀爀ഀഀ
        EXECUTE [dss].[RethrowError]਍        刀䔀吀唀刀一ഀഀ
    END CATCH਍䔀一䐀ഀഀ
GO਍
