/****** Object:  StoredProcedure [dss].[UpdateScheduleWithInterval]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀唀瀀搀愀琀攀匀挀栀攀搀甀氀攀圀椀琀栀䤀渀琀攀爀瘀愀氀崀ഀഀ
    @SyncGroupId UNIQUEIDENTIFIER,਍    䀀䤀渀琀攀爀瘀愀氀 戀椀最椀渀琀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    UPDATE [dss].[ScheduleTask]਍    匀䔀吀ഀഀ
        Interval = @Interval,਍        嬀䔀砀瀀椀爀愀琀椀漀渀吀椀洀攀崀 㴀 䐀䄀吀䔀䄀䐀䐀⠀匀䔀䌀伀一䐀Ⰰ 䀀䤀渀琀攀爀瘀愀氀Ⰰ 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀⤀ ⴀⴀ 䄀氀猀漀 甀瀀搀愀琀攀 琀栀攀 搀甀攀 琀椀洀攀 昀漀爀 琀栀攀 琀愀猀欀 眀栀攀渀 琀栀攀 椀渀琀攀爀瘀愀氀 椀猀 甀瀀搀愀琀攀搀⸀ഀഀ
    WHERE [SyncGroupId] = @SyncGroupId਍䔀一䐀ഀഀ
GO਍
