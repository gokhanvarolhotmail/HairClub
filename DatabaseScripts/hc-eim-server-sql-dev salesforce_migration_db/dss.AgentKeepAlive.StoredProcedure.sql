/****** Object:  StoredProcedure [dss].[AgentKeepAlive]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䄀最攀渀琀䬀攀攀瀀䄀氀椀瘀攀崀ഀഀ
    @AgentId UNIQUEIDENTIFIER,਍    䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @LastAliveTime DATETIME = GETUTCDATE()਍ഀഀ
    UPDATE [dss].[agent_instance]਍    匀䔀吀ഀഀ
        [lastalivetime] = @LastAliveTime਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀渀猀琀愀渀挀攀䤀搀 䄀一䐀 嬀愀最攀渀琀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀ഀഀ
਍    ⴀⴀ 䘀漀爀 氀漀挀愀氀 愀最攀渀琀猀 愀氀猀漀 甀瀀搀愀琀攀 琀栀攀 愀最攀渀琀 琀愀戀氀攀⸀ഀഀ
    UPDATE [dss].[agent]਍    匀䔀吀ഀഀ
        [lastalivetime] = @LastAliveTime਍    圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䄀最攀渀琀䤀搀 䄀一䐀 嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀 㴀 ㄀ഀഀ
਍䔀一䐀ഀഀ
GO਍
