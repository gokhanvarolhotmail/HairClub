/****** Object:  StoredProcedure [dss].[DeleteSyncGroup]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䐀攀氀攀琀攀匀礀渀挀䜀爀漀甀瀀崀ഀഀ
    @SyncGroupID UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        DECLARE @SyncGroupMemberDatabaseIdList TABLE ([databaseid] UNIQUEIDENTIFIER PRIMARY KEY NOT NULL)਍        䐀䔀䌀䰀䄀刀䔀 䀀䐀愀琀愀戀愀猀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
        DECLARE @IsOnPremise BIT਍ഀഀ
        BEGIN TRANSACTION਍ഀഀ
        DELETE FROM [dss].[ScheduleTask]਍        圀䠀䔀刀䔀 嬀匀礀渀挀䜀爀漀甀瀀䤀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀ഀഀ
਍        ⴀⴀ 䜀攀琀 琀栀攀 氀椀猀琀 漀昀 搀愀琀愀戀愀猀攀 䤀搀猀 昀漀爀 琀栀攀 猀礀渀挀最爀漀甀瀀ഀഀ
        INSERT INTO @SyncGroupMemberDatabaseIdList ([databaseid])਍        ⠀匀䔀䰀䔀䌀吀 嬀搀愀琀愀戀愀猀攀椀搀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀洀攀洀戀攀爀崀 圀䠀䔀刀䔀 嬀猀礀渀挀最爀漀甀瀀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀ഀഀ
         UNION਍         匀䔀䰀䔀䌀吀 嬀栀甀戀开洀攀洀戀攀爀椀搀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀礀渀挀最爀漀甀瀀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀⤀ഀഀ
਍        ⴀⴀ 刀攀洀漀瘀攀 愀氀氀 猀礀渀挀最爀漀甀瀀 洀攀洀戀攀爀猀ഀഀ
        DELETE FROM [dss].[syncgroupmember]਍        圀䠀䔀刀䔀 嬀猀礀渀挀最爀漀甀瀀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀ഀഀ
਍        ⴀⴀ 䴀愀爀欀 搀愀琀愀戀愀猀攀 愀猀 甀渀爀攀最椀猀琀攀爀椀渀最⸀ഀഀ
        DELETE FROM [dss].[syncgroup]਍        圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀匀礀渀挀䜀爀漀甀瀀䤀䐀ഀഀ
਍        圀䠀䤀䰀䔀 䔀堀䤀匀吀匀⠀匀䔀䰀䔀䌀吀 ㄀ 䘀刀伀䴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䐀愀琀愀戀愀猀攀䤀搀䰀椀猀琀⤀ഀഀ
        BEGIN਍            匀䔀吀 䀀䐀愀琀愀戀愀猀攀䤀搀 㴀 ⠀匀䔀䰀䔀䌀吀 吀伀倀 ㄀ 嬀搀愀琀愀戀愀猀攀椀搀崀 䘀刀伀䴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䐀愀琀愀戀愀猀攀䤀搀䰀椀猀琀⤀ഀഀ
਍            䔀堀䔀䌀 嬀搀猀猀崀⸀嬀䌀栀攀挀欀䄀渀搀䐀攀氀攀琀攀唀渀甀猀攀搀䐀愀琀愀戀愀猀攀崀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
਍            䐀䔀䰀䔀吀䔀 䘀刀伀䴀 䀀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䐀愀琀愀戀愀猀攀䤀搀䰀椀猀琀 圀䠀䔀刀䔀 嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀搀ഀഀ
        END਍ഀഀ
        IF @@TRANCOUNT > 0਍        䈀䔀䜀䤀一ഀഀ
            COMMIT TRANSACTION਍        䔀一䐀ഀഀ
਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍        䤀䘀 䀀䀀吀刀䄀一䌀伀唀一吀 㸀 　ഀഀ
        BEGIN਍            刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一匀䄀䌀吀䤀伀一㬀ഀഀ
        END਍ഀഀ
         -- get error infromation and raise error਍        䔀堀䔀䌀唀吀䔀 嬀搀猀猀崀⸀嬀刀攀琀栀爀漀眀䔀爀爀漀爀崀ഀഀ
        RETURN਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
਍䔀一䐀ഀഀ
GO਍
