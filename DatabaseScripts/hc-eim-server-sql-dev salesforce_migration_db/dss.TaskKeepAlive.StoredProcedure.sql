/****** Object:  StoredProcedure [dss].[TaskKeepAlive]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀吀愀猀欀䬀攀攀瀀䄀氀椀瘀攀崀ഀഀ
    @TaskId	UNIQUEIDENTIFIER਍䄀匀ഀഀ
BEGIN਍ഀഀ
    DECLARE @State INT਍    匀䔀䰀䔀䌀吀 䀀匀琀愀琀攀 㴀 　ഀഀ
    SET NOCOUNT ON਍ഀഀ
    UPDATE [dss].[task]਍    匀䔀吀 嬀氀愀猀琀栀攀愀爀琀戀攀愀琀崀 㴀 䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
        @State = [state]਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀吀愀猀欀䤀搀ഀഀ
਍    ⴀⴀ 挀栀攀挀欀 椀昀 琀栀攀 琀愀猀欀 椀猀 挀愀渀挀攀氀氀椀渀最ഀഀ
    IF (@State <> -4) -- -4: cancelling਍        匀䔀䰀䔀䌀吀 ㄀ഀഀ
    ELSE਍        匀䔀䰀䔀䌀吀 　ഀഀ
਍䔀一䐀ഀഀ
GO਍
