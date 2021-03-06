/****** Object:  StoredProcedure [TaskHosting].[InsertJobAndMessages]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[InsertJobAndMessages]਍    䀀䨀漀戀䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰഀഀ
    @JobType int,਍    䀀䨀漀戀䤀渀瀀甀琀䐀愀琀愀 渀瘀愀爀挀栀愀爀⠀洀愀砀⤀Ⰰഀഀ
    @TracingId uniqueidentifier,਍    䀀䴀攀猀猀愀最攀䰀椀猀琀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䴀攀猀猀愀最攀䰀椀猀琀吀礀瀀攀崀 刀䔀䄀䐀伀一䰀夀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SET XACT_ABORT ON਍ഀഀ
    DECLARE @TaskCount int਍    匀䔀䰀䔀䌀吀 䀀吀愀猀欀䌀漀甀渀琀 㴀 䌀伀唀一吀⠀⨀⤀ 䘀刀伀䴀 䀀䴀攀猀猀愀最攀䰀椀猀琀ഀഀ
਍    䈀䔀䜀䤀一 吀刀夀ഀഀ
        BEGIN TRAN਍            䤀一匀䔀刀吀 吀愀猀欀䠀漀猀琀椀渀最⸀䨀漀戀⠀嬀䨀漀戀䤀搀崀Ⰰ 嬀䨀漀戀吀礀瀀攀崀Ⰰ 嬀䤀渀瀀甀琀䐀愀琀愀崀Ⰰ 嬀吀爀愀挀椀渀最䤀搀崀Ⰰ 嬀吀愀猀欀䌀漀甀渀琀崀⤀ഀഀ
            VALUES (@JobId, @JobType, @JobInputData, @TracingId, @TaskCount)਍ഀഀ
            INSERT INTO TaskHosting.MessageQueue਍            ⠀ഀഀ
                [MessageId],਍                嬀䨀漀戀䤀搀崀Ⰰഀഀ
                [QueueId],਍                嬀䴀攀猀猀愀最攀吀礀瀀攀崀Ⰰഀഀ
                [MessageData],਍                嬀吀爀愀挀椀渀最䤀搀崀Ⰰഀഀ
                [InitialInsertTimeUTC],਍                嬀䤀渀猀攀爀琀吀椀洀攀唀吀䌀崀Ⰰഀഀ
                [Version]਍            ⤀ഀഀ
            SELECT਍                嬀䴀攀猀猀愀最攀䤀搀崀Ⰰഀഀ
                [JobId],਍                嬀儀甀攀甀攀䤀搀崀Ⰰഀഀ
                [MessageType],਍                嬀䴀攀猀猀愀最攀䐀愀琀愀崀Ⰰഀഀ
                [TracingId],਍                䜀䔀吀唀吀䌀䐀䄀吀䔀⠀⤀Ⰰഀഀ
                GETUTCDATE(),਍                嬀嘀攀爀猀椀漀渀崀ഀഀ
            FROM @MessageList਍        䌀伀䴀䴀䤀吀 吀刀䄀一ഀഀ
    END TRY਍    䈀䔀䜀䤀一 䌀䄀吀䌀䠀ഀഀ
      IF XACT_STATE() != 0਍      䈀䔀䜀䤀一ഀഀ
        ROLLBACK TRAN਍      䔀一䐀ഀഀ
਍      ⴀⴀ 一漀眀 爀愀椀猀攀爀爀漀爀 昀漀爀 琀栀攀 攀爀爀漀爀 搀攀琀愀椀氀猀⸀ഀഀ
      -- Note: business logic should catch the error and possibly retry.਍      䐀䔀䌀䰀䄀刀䔀 䀀䔀爀爀漀爀开匀攀瘀攀爀椀琀礀 䤀一吀 㴀 䔀刀刀伀刀开匀䔀嘀䔀刀䤀吀夀⠀⤀Ⰰഀഀ
              @Error_State INT = ERROR_STATE(),਍              䀀䔀爀爀漀爀开一甀洀戀攀爀 䤀一吀 㴀 䔀刀刀伀刀开一唀䴀䈀䔀刀⠀⤀Ⰰഀഀ
              @Error_Line INT = ERROR_LINE(),਍              䀀䔀爀爀漀爀开䴀攀猀猀愀最攀 一嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ 㴀 䔀刀刀伀刀开䴀䔀匀匀䄀䜀䔀⠀⤀㬀ഀഀ
਍      刀䄀䤀匀䔀刀刀伀刀 ⠀✀䴀猀最 ─搀Ⰰ 䰀椀渀攀 ─搀㨀 ─猀✀Ⰰഀഀ
                @Error_Severity, @Error_State,਍                䀀䔀爀爀漀爀开一甀洀戀攀爀Ⰰ 䀀䔀爀爀漀爀开䰀椀渀攀Ⰰ 䀀䔀爀爀漀爀开䴀攀猀猀愀最攀⤀㬀ഀഀ
    END CATCH਍䔀一䐀ഀഀ
਍ഀഀ
GO਍
