/****** Object:  StoredProcedure [dss].[GetUIHistoryRecords]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀唀䤀䠀椀猀琀漀爀礀刀攀挀漀爀搀猀崀ഀഀ
  @TimeRangeStart DATETIME = null,਍  䀀吀椀洀攀刀愀渀最攀䔀渀搀 䐀䄀吀䔀吀䤀䴀䔀 㴀 渀甀氀氀Ⰰഀഀ
  @RecordType int = null,਍  䀀匀攀爀瘀攀爀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 渀甀氀氀Ⰰഀഀ
  @AgentId UNIQUEIDENTIFIER = null,਍  䀀䐀愀琀愀戀愀猀攀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 渀甀氀氀Ⰰഀഀ
  @SyncGroupId UNIQUEIDENTIFIER = null,਍  䀀一甀洀戀攀爀伀昀刀攀猀甀氀琀猀 椀渀琀 㴀 ㄀　　Ⰰഀഀ
  @ContinuationTokenCompletionTime DATETIME = null,਍  䀀䌀漀渀琀椀渀甀愀琀椀漀渀吀漀欀攀渀䔀渀搀吀愀猀欀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀 㴀 渀甀氀氀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
  SET NOCOUNT ON਍  匀䔀吀 刀伀圀䌀伀唀一吀 䀀一甀洀戀攀爀伀昀刀攀猀甀氀琀猀ഀഀ
਍  䤀䘀ഀഀ
    @TimeRangeStart is NULL AND਍    䀀吀椀洀攀刀愀渀最攀䔀渀搀 椀猀 一唀䰀䰀 䄀一䐀ഀഀ
    @AgentId is NULL AND਍    䀀䐀愀琀愀戀愀猀攀䤀搀 椀猀 一唀䰀䰀 䄀一䐀ഀഀ
    @SyncGroupId is NULL AND਍    䀀刀攀挀漀爀搀吀礀瀀攀 椀猀 一唀䰀䰀ഀഀ
  BEGIN਍    匀䔀䰀䔀䌀吀ഀഀ
        [id],਍        嬀挀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀Ⰰഀഀ
        [recordType],਍        嬀猀攀爀瘀攀爀椀搀崀Ⰰഀഀ
        [agentid],਍        嬀搀愀琀愀戀愀猀攀椀搀崀Ⰰഀഀ
        [syncgroupId],਍        嬀搀攀琀愀椀氀䔀渀甀洀䤀搀崀Ⰰഀഀ
        [detailStringParameters]਍      䘀刀伀䴀 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀ഀഀ
      WHERE [serverid] = @ServerId AND਍       ⴀⴀ 匀欀椀瀀 瀀爀攀瘀椀漀甀猀 爀攀琀甀爀渀攀搀 氀漀最 爀攀挀漀爀搀猀Ⰰ 愀猀猀甀洀攀 挀氀椀攀渀琀 焀甀攀爀礀 氀漀最猀 戀愀猀攀搀 漀渀 䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 搀攀猀挀攀渀搀椀渀最 漀爀搀攀爀ഀഀ
      (@ContinuationTokenCompletionTime IS NULL OR NOT ([completionTime] = @ContinuationTokenCompletionTime AND [id] <= @ContinuationTokenEndTaskId))਍      伀刀䐀䔀刀 䈀夀 䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 䐀䔀匀䌀Ⰰ 椀搀ഀഀ
    END਍  䔀䰀匀䔀ഀഀ
  BEGIN਍    椀昀 䀀刀攀挀漀爀搀吀礀瀀攀 椀猀 一唀䰀䰀ഀഀ
      SELECT਍        嬀椀搀崀Ⰰഀഀ
        [completionTime],਍        嬀爀攀挀漀爀搀吀礀瀀攀崀Ⰰഀഀ
        [serverid],਍        嬀愀最攀渀琀椀搀崀Ⰰഀഀ
        [databaseid],਍        嬀猀礀渀挀最爀漀甀瀀䤀搀崀Ⰰഀഀ
        [detailEnumId],਍        嬀搀攀琀愀椀氀匀琀爀椀渀最倀愀爀愀洀攀琀攀爀猀崀ഀഀ
     FROM [dss].[UIHistory]਍     圀䠀䔀刀䔀ഀഀ
        [serverid] = @ServerId AND਍        嬀挀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀 䈀䔀吀圀䔀䔀一 ⴀⴀ䈀䔀吀圀䔀䔀一 椀猀 愀渀 椀渀挀氀甀猀椀瘀攀 漀瀀攀爀愀琀漀爀ഀഀ
           ISNULL(@TimeRangeStart, CONVERT(datetime, '1/1/1753')) AND਍           䤀匀一唀䰀䰀⠀䀀吀椀洀攀刀愀渀最攀䔀渀搀Ⰰ 最攀琀甀琀挀搀愀琀攀⠀⤀⤀ 䄀一䐀ഀഀ
        [agentid] = ISNULL(@AgentId, [dss].[UIHistory].[agentid]) AND਍        嬀搀愀琀愀戀愀猀攀椀搀崀 㴀 䤀匀一唀䰀䰀⠀䀀䐀愀琀愀戀愀猀攀䤀搀Ⰰ 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀⸀嬀搀愀琀愀戀愀猀攀椀搀崀⤀ 䄀一䐀ഀഀ
        [syncgroupId] = ISNULL(@SyncGroupId, [dss].[UIHistory].[syncgroupId]) AND਍        ⠀䀀䌀漀渀琀椀渀甀愀琀椀漀渀吀漀欀攀渀䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 䤀匀 一唀䰀䰀 伀刀 一伀吀 ⠀嬀挀漀洀瀀氀攀琀椀漀渀吀椀洀攀崀 㴀 䀀䌀漀渀琀椀渀甀愀琀椀漀渀吀漀欀攀渀䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 䄀一䐀 嬀椀搀崀 㰀㴀 䀀䌀漀渀琀椀渀甀愀琀椀漀渀吀漀欀攀渀䔀渀搀吀愀猀欀䤀搀⤀⤀ഀഀ
        ORDER BY CompletionTime DESC, id਍  䔀䰀匀䔀ഀഀ
     SELECT਍       嬀椀搀崀Ⰰഀഀ
       [completionTime],਍       嬀爀攀挀漀爀搀吀礀瀀攀崀Ⰰഀഀ
       [serverid],਍       嬀愀最攀渀琀椀搀崀Ⰰഀഀ
       [databaseid],਍       嬀猀礀渀挀最爀漀甀瀀䤀搀崀Ⰰഀഀ
       [detailEnumId],਍       嬀搀攀琀愀椀氀匀琀爀椀渀最倀愀爀愀洀攀琀攀爀猀崀ഀഀ
     FROM [dss].[UIHistory]਍     圀䠀䔀刀䔀ഀഀ
       [serverid] = @ServerId AND਍       嬀爀攀挀漀爀搀吀礀瀀攀崀 㴀 䀀刀攀挀漀爀搀吀礀瀀攀 䄀一䐀ഀഀ
       [completionTime] BETWEEN --BETWEEN is an inclusive operator਍          䤀匀一唀䰀䰀⠀䀀吀椀洀攀刀愀渀最攀匀琀愀爀琀Ⰰ 䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ ✀㄀⼀㄀⼀㄀㜀㔀㌀✀⤀⤀ 䄀一䐀ഀഀ
          ISNULL(@TimeRangeEnd, getutcdate()) AND਍       嬀愀最攀渀琀椀搀崀 㴀 䤀匀一唀䰀䰀⠀䀀䄀最攀渀琀䤀搀Ⰰ 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀⸀嬀愀最攀渀琀椀搀崀⤀ 䄀一䐀ഀഀ
       [databaseid] = ISNULL(@DatabaseId, [dss].[UIHistory].[databaseid]) AND਍       嬀猀礀渀挀最爀漀甀瀀䤀搀崀 㴀 䤀匀一唀䰀䰀⠀䀀匀礀渀挀䜀爀漀甀瀀䤀搀Ⰰ 嬀搀猀猀崀⸀嬀唀䤀䠀椀猀琀漀爀礀崀⸀嬀猀礀渀挀最爀漀甀瀀䤀搀崀⤀ 䄀一䐀ഀഀ
        (@ContinuationTokenCompletionTime IS NULL OR NOT ([completionTime] = @ContinuationTokenCompletionTime AND [id] <= @ContinuationTokenEndTaskId))਍       伀刀䐀䔀刀 䈀夀 䌀漀洀瀀氀攀琀椀漀渀吀椀洀攀 䐀䔀匀䌀Ⰰ 椀搀ഀഀ
  END਍䔀一䐀ഀഀ
GO਍
