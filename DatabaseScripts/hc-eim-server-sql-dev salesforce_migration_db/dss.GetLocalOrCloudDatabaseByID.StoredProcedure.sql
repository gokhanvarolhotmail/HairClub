/****** Object:  StoredProcedure [dss].[GetLocalOrCloudDatabaseByID]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䰀漀挀愀氀伀爀䌀氀漀甀搀䐀愀琀愀戀愀猀攀䈀礀䤀䐀崀ഀഀ
    @DatabaseId UNIQUEIDENTIFIER,਍    䀀䤀猀伀渀倀爀攀洀椀猀攀 戀椀琀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SELECT਍        嬀椀搀崀Ⰰഀഀ
        [server],਍        嬀搀愀琀愀戀愀猀攀崀Ⰰഀഀ
        [state],਍        嬀猀甀戀猀挀爀椀瀀琀椀漀渀椀搀崀Ⰰഀഀ
        [agentid],਍        嬀挀漀渀渀攀挀琀椀漀渀开猀琀爀椀渀最崀 㴀 渀甀氀氀Ⰰഀഀ
        [db_schema],਍        嬀椀猀开漀渀开瀀爀攀洀椀猀攀崀Ⰰഀഀ
        [sqlazure_info],਍        嬀氀愀猀琀开猀挀栀攀洀愀开甀瀀搀愀琀攀搀崀Ⰰഀഀ
        [last_tombstonecleanup],਍        嬀爀攀最椀漀渀崀Ⰰഀഀ
        [jobId]਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
    WHERE [id] = @DatabaseId and [is_on_premise] = @IsOnPremise਍䔀一䐀ഀഀ
GO਍
