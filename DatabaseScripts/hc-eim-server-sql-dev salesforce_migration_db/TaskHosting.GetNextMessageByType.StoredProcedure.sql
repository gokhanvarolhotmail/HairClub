/****** Object:  StoredProcedure [TaskHosting].[GetNextMessageByType]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
-- Create GetNextMessageByType SP.਍ⴀⴀ 䜀攀琀一攀砀琀䴀攀猀猀愀最攀䈀礀吀礀瀀攀 洀愀礀 爀攀琀甀爀渀 漀渀攀 爀漀眀 漀昀 洀攀猀猀愀最攀 椀昀 渀攀砀琀 洀攀猀猀愀最攀 椀猀 愀瘀愀椀氀愀戀氀攀 漀爀 渀漀 爀漀眀 椀昀 渀漀 洀攀猀猀愀最攀 椀猀 愀瘀愀椀氀愀戀氀攀⸀ഀഀ
-- Do not merge this with GetNextMessage. The separation is a result of DB performance tuning਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀吀愀猀欀䠀漀猀琀椀渀最崀⸀嬀䜀攀琀一攀砀琀䴀攀猀猀愀最攀䈀礀吀礀瀀攀崀ഀഀ
  @TaskType INT,                   -- The task type to pick up਍  䀀儀甀攀甀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰ       ⴀⴀ 吀栀攀 眀漀爀欀攀爀 挀愀渀 瀀椀挀欀 甀瀀 洀攀猀猀愀最攀猀 昀爀漀洀 搀椀昀昀攀爀攀渀琀 焀甀攀甀攀⸀ഀഀ
  @WorkerId UNIQUEIDENTIFIER,      -- The dispatchers have different worker id.਍  䀀吀椀洀攀漀甀琀䤀渀匀攀挀漀渀搀猀 䤀一吀Ⰰ           ⴀⴀ 䰀攀琀 琀栀攀 戀甀猀椀渀攀猀猀 氀漀最椀挀 氀愀礀攀爀 搀攀挀椀搀攀猀 眀栀攀渀 愀 洀攀猀猀愀最攀 椀猀 琀椀洀攀搀 漀甀琀Ⰰ 搀漀 渀漀琀 栀愀爀搀挀漀搀攀 椀渀 匀儀䰀 挀漀搀攀⸀ഀഀ
  @MaxExecTimes TINYINT,           -- Let the business logic layer decides when a message is regarded dead, do not hardcode in SQL code.਍  䀀嘀攀爀猀椀漀渀 䈀䤀䜀䤀一吀 㴀 　              ⴀⴀ 伀渀氀礀 爀攀琀爀椀攀瘀攀 愀 洀攀猀猀愀最攀 眀椀琀栀 瘀攀爀猀椀漀渀 猀洀愀氀氀攀爀 琀栀愀渀 漀爀 攀焀甀愀氀 琀漀 琀栀椀猀 瘀愀氀甀攀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    SET XACT_ABORT ON਍ഀഀ
    IF @TimeoutInSeconds IS NULL OR @TimeoutInSeconds <= 0਍    䈀䔀䜀䤀一ഀഀ
      RAISERROR('@TimeoutInSeconds argument is wrong.', 16, 1)਍      刀䔀吀唀刀一ഀഀ
    END਍    䤀䘀 䀀䴀愀砀䔀砀攀挀吀椀洀攀猀 䤀匀 一唀䰀䰀 伀刀 䀀䴀愀砀䔀砀攀挀吀椀洀攀猀 㰀㴀 　ഀഀ
    BEGIN਍      刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䴀愀砀䔀砀攀挀吀椀洀攀猀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
      RETURN਍    䔀一䐀ഀഀ
਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
    DECLARE @MsgId UNIQUEIDENTIFIER, @JobId UNIQUEIDENTIFIER, @MessageType INT, @TracingId UNIQUEIDENTIFIER, @State INT, @ExecTimes TINYINT, @MessageData NVARCHAR(max), @InsertTimeUTC DATETIME, @InitialInsertTimeUTC DATETIME, @UpdateTimeUTC DATETIME, @IsCancelled BIT, @ActualVersion BIGINT਍ഀഀ
    BEGIN TRY਍        䈀䔀䜀䤀一 吀刀䄀一ഀഀ
਍            ⴀⴀ 䜀攀琀 渀攀眀 洀攀猀猀愀最攀 眀栀椀挀栀 栀愀猀 渀甀氀氀 唀瀀搀愀琀攀吀椀洀攀唀琀挀 漀爀 椀琀✀猀 琀椀洀攀搀 漀甀琀 椀渀 唀瀀搀愀琀攀吀椀洀攀唀琀挀 戀甀琀 攀砀攀挀甀琀攀搀 氀攀猀猀 琀栀愀渀 洀愀砀 琀椀洀攀猀⸀ഀഀ
਍            匀䔀䰀䔀䌀吀 吀伀倀 ㄀ഀഀ
                @MsgId=m.MessageId,਍                䀀䨀漀戀䤀搀㴀洀⸀䨀漀戀䤀搀Ⰰഀഀ
                @MessageType=m.MessageType,਍                䀀吀爀愀挀椀渀最䤀搀㴀洀⸀吀爀愀挀椀渀最䤀搀Ⰰഀഀ
                @ExecTimes=m.ExecTimes,਍                䀀䴀攀猀猀愀最攀䐀愀琀愀㴀洀⸀䴀攀猀猀愀最攀䐀愀琀愀Ⰰഀഀ
                @InsertTimeUTC=m.InsertTimeUTC,਍                䀀䤀渀椀琀椀愀氀䤀渀猀攀爀琀吀椀洀攀唀吀䌀 㴀 洀⸀䤀渀椀琀椀愀氀䤀渀猀攀爀琀吀椀洀攀唀吀䌀Ⰰഀഀ
                @UpdateTimeUTC=m.UpdateTimeUTC,਍                䀀䄀挀琀甀愀氀嘀攀爀猀椀漀渀㴀洀⸀嬀嘀攀爀猀椀漀渀崀ഀഀ
            FROM਍            ⠀ഀഀ
                SELECT TOP 1 *਍                䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀 圀䤀吀䠀 ⠀刀䔀䄀䐀倀䄀匀吀Ⰰ 唀倀䐀䰀伀䌀䬀Ⰰ 䘀伀刀䌀䔀匀䔀䔀䬀⤀ഀഀ
                WHERE UpdateTimeUTC IS NULL਍                䄀一䐀 嬀嘀攀爀猀椀漀渀崀 㰀㴀 䀀嘀攀爀猀椀漀渀ഀഀ
                AND [QueueId] = @QueueId਍                䄀一䐀 嬀䴀攀猀猀愀最攀吀礀瀀攀崀 㴀 䀀吀愀猀欀吀礀瀀攀ഀഀ
                ORDER BY InsertTimeUTC਍                唀一䤀伀一ഀഀ
                SELECT TOP 1 *਍                䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀 圀䤀吀䠀 ⠀刀䔀䄀䐀倀䄀匀吀Ⰰ 唀倀䐀䰀伀䌀䬀Ⰰ 䘀伀刀䌀䔀匀䔀䔀䬀⤀ഀഀ
                WHERE UpdateTimeUTC < DATEADD(SECOND, -@TimeoutInSeconds, GETUTCDATE()) AND ExecTimes < @MaxExecTimes਍                䄀一䐀 嬀嘀攀爀猀椀漀渀崀 㰀㴀 䀀嘀攀爀猀椀漀渀ഀഀ
                AND [MessageType] = @TaskType਍                䄀一䐀 嬀儀甀攀甀攀䤀搀崀 㴀 䀀儀甀攀甀攀䤀搀ഀഀ
                ORDER BY InsertTimeUTC਍            ⤀ 洀ഀഀ
            ORDER BY m.InsertTimeUTC਍ഀഀ
            IF @MsgId IS NOT NULL਍            䈀䔀䜀䤀一ഀഀ
                -- New message is found, take ownership of it and return the information.਍                唀倀䐀䄀吀䔀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀ഀഀ
                SET ExecTimes = ExecTimes + 1, UpdateTimeUTC = GETUTCDATE(), WorkerId = @WorkerId਍                圀䠀䔀刀䔀 䴀攀猀猀愀最攀䤀搀 㴀 䀀䴀猀最䤀搀ഀഀ
਍                匀䔀䰀䔀䌀吀 䀀䤀猀䌀愀渀挀攀氀氀攀搀 㴀 樀⸀䤀猀䌀愀渀挀攀氀氀攀搀 䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䨀漀戀 樀 䤀一一䔀刀 䨀伀䤀一 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀 洀 伀一 樀⸀䨀漀戀䤀搀 㴀 洀⸀䨀漀戀䤀搀 圀䠀䔀刀䔀 洀⸀䴀攀猀猀愀最攀䤀搀 㴀 䀀䴀猀最䤀搀ഀഀ
                SELECT਍                    䀀䴀猀最䤀搀 愀猀 䴀攀猀猀愀最攀䤀搀Ⰰഀഀ
                    @JobId as JobId,਍                    䀀䴀攀猀猀愀最攀吀礀瀀攀 愀猀 䴀攀猀猀愀最攀吀礀瀀攀Ⰰഀഀ
                    @MessageData as MessageData,਍                    䀀吀爀愀挀椀渀最䤀搀 愀猀 吀爀愀挀椀渀最䤀搀Ⰰഀഀ
                    @InsertTimeUTC as InsertTimeUTC,਍                    䀀䤀渀椀琀椀愀氀䤀渀猀攀爀琀吀椀洀攀唀吀䌀 愀猀 䤀渀椀琀椀愀氀䤀渀猀攀爀琀吀椀洀攀唀吀䌀Ⰰഀഀ
                    @UpdateTimeUTC as UpdateTimeUTC,਍                    䀀䤀猀䌀愀渀挀攀氀氀攀搀 愀猀 䤀猀䌀愀渀挀攀氀氀攀搀Ⰰഀഀ
                    @QueueId as QueueId,਍                    䀀圀漀爀欀攀爀䤀搀 愀猀 圀漀爀欀攀爀䤀搀Ⰰഀഀ
                    @ActualVersion as [Version]਍            䔀一䐀ഀഀ
਍            ⴀⴀ 䤀昀 渀漀 洀攀猀猀愀最攀 椀猀 昀漀甀渀搀Ⰰ 爀攀琀甀爀渀 渀漀琀栀椀渀最⸀ഀഀ
਍        䌀伀䴀䴀䤀吀 吀刀䄀一ഀഀ
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
਍䜀伀ഀഀ
