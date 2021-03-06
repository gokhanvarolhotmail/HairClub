/****** Object:  StoredProcedure [TaskHosting].[CleanupCompletedJobs]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
--Job will not be deleted automatically like message. Upload/Download job will be removed when clean up blob.਍ⴀⴀ吀栀椀猀 匀倀 椀猀 琀漀 爀攀洀漀瘀攀 漀琀栀攀爀 琀礀瀀攀 漀昀 樀漀戀猀 眀栀椀挀栀 栀愀猀 戀攀攀渀 挀漀洀瀀氀攀琀攀搀⸀ 䤀琀 眀椀氀氀 戀攀 椀渀瘀漀欀攀搀 椀渀 匀挀栀攀搀甀氀攀爀⸀ഀഀ
CREATE PROCEDURE [TaskHosting].[CleanupCompletedJobs]਍䄀匀ഀഀ
BEGIN਍ഀഀ
    DECLARE @RowsAffected BIGINT਍    䐀䔀䌀䰀䄀刀䔀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀 䈀䤀䜀䤀一吀ഀഀ
਍    匀䔀吀 䀀䐀攀氀攀琀攀䈀愀琀挀栀匀椀稀攀 㴀 ㄀　　　ഀഀ
    SET @RowsAffected = @DeleteBatchSize਍ഀഀ
    WHILE (@RowsAffected = @DeleteBatchSize)਍    䈀䔀䜀䤀一ഀഀ
        DELETE TOP (@DeleteBatchSize) [TaskHosting].[Job] FROM [TaskHosting].[Job] AS j WHERE DATEADD(Hour, 1, j.InitialInsertTimeUTC) < GETDATE()਍        䄀一䐀 樀⸀䨀漀戀吀礀瀀攀㰀㸀㜀 ⴀⴀ䔀砀挀氀甀搀攀 甀瀀氀漀愀搀 愀渀搀 搀漀眀渀氀漀愀搀 琀愀猀欀猀ഀഀ
        AND NOT EXISTS਍        ⠀匀䔀䰀䔀䌀吀 ㄀ 䘀刀伀䴀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀儀甀攀甀攀崀 洀 圀䠀䔀刀䔀 洀⸀樀漀戀䤀搀 㴀 樀⸀樀漀戀䤀搀⤀ഀഀ
        SET @RowsAffected = @@ROWCOUNT਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
