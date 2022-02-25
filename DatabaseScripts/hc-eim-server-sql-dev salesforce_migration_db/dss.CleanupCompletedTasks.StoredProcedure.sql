/****** Object:  StoredProcedure [dss].[CleanupCompletedTasks]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀氀攀愀渀甀瀀䌀漀洀瀀氀攀琀攀搀吀愀猀欀猀崀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @ActionsToDelete TABLE ([id] UNIQUEIDENTIFIER PRIMARY KEY NOT NULL)਍ഀഀ
    INSERT INTO @ActionsToDelete ([id])਍    匀䔀䰀䔀䌀吀 嬀椀搀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀愀挀琀椀漀渀崀 圀䠀䔀刀䔀 嬀猀琀愀琀攀崀 㴀 ㄀ ⴀⴀ ㄀㨀匀甀挀挀攀攀搀攀搀ഀഀ
਍    ⴀⴀ 䌀氀攀愀渀甀瀀 琀愀猀欀猀 愀渀搀 愀挀琀椀漀渀猀 琀栀愀琀 栀愀瘀攀 戀攀攀渀 挀漀洀瀀氀攀琀攀搀 猀甀挀挀攀猀猀昀甀氀氀礀⸀ഀഀ
    -- An action can be in [state]=1 only when all tasks are in [state]=1਍ഀഀ
    DECLARE @RowsAffected BIGINT਍    䐀䔀䌀䰀䄀刀䔀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀 䈀䤀䜀䤀一吀ഀഀ
    SET @DeleteBatchSize = 1000਍ഀഀ
    SET @RowsAffected = @DeleteBatchSize਍ഀഀ
    WHILE (@RowsAffected = @DeleteBatchSize)਍    䈀䔀䜀䤀一ഀഀ
        DELETE TOP (@DeleteBatchSize) [dss].[task]਍        䘀刀伀䴀 嬀搀猀猀崀⸀嬀琀愀猀欀崀 圀䤀吀䠀 ⠀䘀伀刀䌀䔀匀䔀䔀䬀⤀ 圀䠀䔀刀䔀 嬀愀挀琀椀漀渀椀搀崀 䤀一 ⠀匀䔀䰀䔀䌀吀 嬀椀搀崀 䘀刀伀䴀 䀀䄀挀琀椀漀渀猀吀漀䐀攀氀攀琀攀⤀ഀഀ
        SET @RowsAffected = @@ROWCOUNT਍    䔀一䐀ഀഀ
਍    匀䔀吀 䀀刀漀眀猀䄀昀昀攀挀琀攀搀 㴀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀ഀഀ
਍    圀䠀䤀䰀䔀 ⠀䀀刀漀眀猀䄀昀昀攀挀琀攀搀 㴀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀⤀ഀഀ
    BEGIN਍        䐀䔀䰀䔀吀䔀 吀伀倀 ⠀䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀⤀ 嬀搀猀猀崀⸀嬀愀挀琀椀漀渀崀ഀഀ
        FROM [dss].[action] WITH (FORCESEEK) WHERE [id] IN (SELECT [id] FROM @ActionsToDelete)਍        匀䔀吀 䀀刀漀眀猀䄀昀昀攀挀琀攀搀 㴀 䀀䀀刀伀圀䌀伀唀一吀ഀഀ
    END਍ഀഀ
END਍䜀伀ഀഀ
