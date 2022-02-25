/****** Object:  StoredProcedure [dss].[CleanupUIHistoryRecord]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 䌀爀攀愀琀攀 琀栀攀 䤀渀猀攀爀琀椀漀渀 匀倀ഀഀ
-- Make sure this file is in ANSI format਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䌀氀攀愀渀甀瀀唀䤀䠀椀猀琀漀爀礀刀攀挀漀爀搀崀ഀഀ
        @CompletionTime	DateTime਍䄀匀ഀഀ
BEGIN਍ഀഀ
    DECLARE @RowsAffected BIGINT਍    䐀䔀䌀䰀䄀刀䔀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀 䈀䤀䜀䤀一吀ഀഀ
    SET @DeleteBatchSize = 1000  --Set the batch size to 1000 so that everytime, we will delete 1000 rows together.਍ഀഀ
    SET @RowsAffected = @DeleteBatchSize਍ഀഀ
    WHILE (@RowsAffected = @DeleteBatchSize)਍    䈀䔀䜀䤀一ഀഀ
        DELETE TOP(@DeleteBatchSize) FROM [dss].[UIHistory] WHERE [completionTime] < @CompletionTime਍        匀䔀吀 䀀刀漀眀猀䄀昀昀攀挀琀攀搀 㴀 䀀䀀刀伀圀䌀伀唀一吀ഀഀ
    END਍䔀一䐀ഀഀ
GO਍
