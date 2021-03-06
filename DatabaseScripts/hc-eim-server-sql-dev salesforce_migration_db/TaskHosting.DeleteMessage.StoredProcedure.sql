/****** Object:  StoredProcedure [TaskHosting].[DeleteMessage]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE PROCEDURE [TaskHosting].[DeleteMessage]਍  䀀䴀攀猀猀愀最攀䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰഀഀ
  @JobId uniqueidentifier OUTPUT,਍  䀀倀漀猀琀䄀挀琀椀漀渀匀琀愀琀攀 椀渀琀 伀唀吀倀唀吀Ⰰഀഀ
  @JobType int OUTPUT,਍  䀀䨀漀戀䤀渀瀀甀琀䐀愀琀愀 渀瘀愀爀挀栀愀爀⠀洀愀砀⤀ 伀唀吀倀唀吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
  SET NOCOUNT ON਍  匀䔀吀 堀䄀䌀吀开䄀䈀伀刀吀 伀一ഀഀ
਍  䤀䘀 䀀䴀攀猀猀愀最攀䤀搀 䤀匀 一唀䰀䰀ഀഀ
  BEGIN਍     刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䴀攀猀猀愀最攀䤀搀 愀爀最甀洀攀渀琀 椀猀 眀爀漀渀最⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
     RETURN਍  䔀一䐀ഀഀ
਍  䐀䔀䌀䰀䄀刀䔀 䀀䨀漀戀刀攀猀甀氀琀 吀䄀䈀䰀䔀⠀䨀漀戀䤀搀 甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀Ⰰ 䨀漀戀吀礀瀀攀 椀渀琀Ⰰ 䌀漀洀瀀氀攀琀攀搀吀愀猀欀䌀漀甀渀琀 椀渀琀Ⰰ 吀愀猀欀䌀漀甀渀琀 椀渀琀Ⰰ 䤀渀瀀甀琀䐀愀琀愀 渀瘀愀爀挀栀愀爀⠀洀愀砀⤀⤀ഀഀ
    BEGIN TRY਍        䈀䔀䜀䤀一 吀刀䄀一ഀഀ
          UPDATE TaskHosting.Job਍          匀䔀吀 䌀漀洀瀀氀攀琀攀搀吀愀猀欀䌀漀甀渀琀 㴀 䌀漀洀瀀氀攀琀攀搀吀愀猀欀䌀漀甀渀琀 ⬀ ㄀ഀഀ
          OUTPUT inserted.JobId, inserted.JobType, inserted.CompletedTaskCount, inserted.TaskCount, inserted.InputData਍          䤀一吀伀 䀀䨀漀戀刀攀猀甀氀琀ഀഀ
          FROM TaskHosting.Job j INNER JOIN TaskHosting.MessageQueue m਍          伀一 樀⸀䨀漀戀䤀搀 㴀 洀⸀䨀漀戀䤀搀ഀഀ
          WHERE m.MessageId = @MessageId਍ഀഀ
          SELECT @JobType = JobType, @JobInputData = InputData, @JobId = JobId,਍          䀀倀漀猀琀䄀挀琀椀漀渀匀琀愀琀攀 㴀ഀഀ
            CASE WHEN CompletedTaskCount = TaskCount THEN 1਍            䔀䰀匀䔀 　ഀഀ
            END਍          䘀刀伀䴀 䀀䨀漀戀刀攀猀甀氀琀ഀഀ
਍          䐀䔀䰀䔀吀䔀 䘀刀伀䴀 吀愀猀欀䠀漀猀琀椀渀最⸀䴀攀猀猀愀最攀儀甀攀甀攀ഀഀ
          WHERE MessageId = @MessageId਍ഀഀ
        COMMIT TRAN਍    䔀一䐀 吀刀夀ഀഀ
    BEGIN CATCH਍      䤀䘀 堀䄀䌀吀开匀吀䄀吀䔀⠀⤀ ℀㴀 　ഀഀ
      BEGIN਍        刀伀䰀䰀䈀䄀䌀䬀 吀刀䄀一ഀഀ
      END਍ഀഀ
      -- Now raiserror for the error details.਍      ⴀⴀ 一漀琀攀㨀 戀甀猀椀渀攀猀猀 氀漀最椀挀 猀栀漀甀氀搀 挀愀琀挀栀 琀栀攀 攀爀爀漀爀 愀渀搀 瀀漀猀猀椀戀氀礀 爀攀琀爀礀⸀ഀഀ
      DECLARE @Error_Severity INT = ERROR_SEVERITY(),਍              䀀䔀爀爀漀爀开匀琀愀琀攀 䤀一吀 㴀 䔀刀刀伀刀开匀吀䄀吀䔀⠀⤀Ⰰഀഀ
              @Error_Number INT = ERROR_NUMBER(),਍              䀀䔀爀爀漀爀开䰀椀渀攀 䤀一吀 㴀 䔀刀刀伀刀开䰀䤀一䔀⠀⤀Ⰰഀഀ
              @Error_Message NVARCHAR(2048) = ERROR_MESSAGE();਍ഀഀ
      RAISERROR ('Msg %d, Line %d: %s',਍                䀀䔀爀爀漀爀开匀攀瘀攀爀椀琀礀Ⰰ 䀀䔀爀爀漀爀开匀琀愀琀攀Ⰰഀഀ
                @Error_Number, @Error_Line, @Error_Message);਍    䔀一䐀 䌀䄀吀䌀䠀ഀഀ
END਍ഀഀ
GO਍
