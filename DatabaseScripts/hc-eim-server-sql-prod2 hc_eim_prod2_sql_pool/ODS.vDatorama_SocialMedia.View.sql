/****** Object:  View [ODS].[vDatorama_SocialMedia]    Script Date: 3/1/2022 8:53:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀伀䐀匀崀⸀嬀瘀䐀愀琀漀爀愀洀愀开匀漀挀椀愀氀䴀攀搀椀愀崀 䄀匀 匀䔀䰀䔀䌀吀ഀഀ
    [b].[Company]਍  Ⰰ 嬀戀崀⸀嬀䄀最攀渀挀礀崀ഀഀ
  , [b].[SourceMedia]਍  Ⰰ 嬀戀崀⸀嬀䰀漀挀愀琀椀漀渀崀ഀഀ
  , [b].[BudgetType]਍  Ⰰ 嬀戀崀⸀嬀䈀甀搀最攀琀一愀洀攀崀ഀഀ
  , [b].[Channel]਍  Ⰰ 嬀戀崀⸀嬀䴀攀搀椀甀洀崀ഀഀ
  , [a].[CRMDay]਍  Ⰰ 嬀愀崀⸀嬀䌀愀洀瀀愀椀最渀䄀搀瘀攀爀琀椀猀攀爀䤀䐀崀ഀഀ
  , [a].[CampaignAdvertaiser]਍  Ⰰ 嬀愀崀⸀嬀䴀攀搀椀愀䌀漀猀琀崀ഀഀ
  , [a].[Clicks]਍  Ⰰ 嬀愀崀⸀嬀䘀椀氀攀倀愀琀栀崀ഀഀ
  , [a].[DWH_LoadDate]਍  Ⰰ 嬀愀崀⸀嬀䴀攀搀椀愀匀瀀攀渀搀崀ഀഀ
  , [a].[DataStream]਍䘀刀伀䴀⠀ 匀䔀䰀䔀䌀吀ഀഀ
          [a].[DataStream]਍        Ⰰ 嬀愀崀⸀嬀䌀刀䴀䐀愀礀崀ഀഀ
        , [a].[CampaignAdvertiserID]਍        Ⰰ 嬀愀崀⸀嬀䌀愀洀瀀愀椀最渀䄀搀瘀攀爀琀愀椀猀攀爀崀ഀഀ
        , [a].[MediaCost]਍        Ⰰ 嬀愀崀⸀嬀䌀氀椀挀欀猀崀ഀഀ
        , [a].[FilePath]਍        Ⰰ 嬀愀崀⸀嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀ഀഀ
        , [a].[MediaSpend]਍      䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䐀愀琀漀爀愀洀愀开匀漀挀椀愀氀䴀攀搀椀愀崀 䄀匀 嬀愀崀 ⤀ 䄀匀 嬀愀崀ഀഀ
CROSS APPLY( SELECT਍                 䴀䄀堀⠀䌀䄀匀䔀 圀䠀䔀一 嬀戀崀⸀嬀䤀搀崀 㴀 ㄀ 吀䠀䔀一 嬀戀崀⸀嬀嘀愀氀崀 䔀一䐀⤀ 䄀匀 嬀䌀漀洀瀀愀渀礀崀ഀഀ
               , MAX(CASE WHEN [b].[Id] = 2 THEN [b].[Val] END) AS [Agency]਍               Ⰰ 䴀䄀堀⠀䌀䄀匀䔀 圀䠀䔀一 嬀戀崀⸀嬀䤀搀崀 㴀 ㌀ 吀䠀䔀一 嬀戀崀⸀嬀嘀愀氀崀 䔀一䐀⤀ 䄀匀 嬀匀漀甀爀挀攀䴀攀搀椀愀崀ഀഀ
               , MAX(CASE WHEN [b].[Id] = 4 THEN [b].[Val] END) AS [Location]਍               Ⰰ 䴀䄀堀⠀䌀䄀匀䔀 圀䠀䔀一 嬀戀崀⸀嬀䤀搀崀 㴀 㔀 吀䠀䔀一 嬀戀崀⸀嬀嘀愀氀崀 䔀一䐀⤀ 䄀匀 嬀䈀甀搀最攀琀吀礀瀀攀崀ഀഀ
               , MAX(CASE WHEN [b].[Id] = 6 THEN [b].[Val] END) AS [BudgetName]਍               Ⰰ 䴀䄀堀⠀䌀䄀匀䔀 圀䠀䔀一 嬀戀崀⸀嬀䤀搀崀 㴀 㜀 吀䠀䔀一 嬀戀崀⸀嬀嘀愀氀崀 䔀一䐀⤀ 䄀匀 嬀䌀栀愀渀渀攀氀崀ഀഀ
               , MAX(CASE WHEN [b].[Id] = 8 THEN [b].[Val] END) AS [Medium]਍             䘀刀伀䴀⠀ 匀䔀䰀䔀䌀吀 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 伀刀䐀䔀刀 䈀夀⠀ 匀䔀䰀䔀䌀吀 　 ⤀⤀ 䄀匀 嬀䤀搀崀Ⰰ 吀刀䤀䴀⠀嬀戀崀⸀嬀瘀愀氀甀攀崀⤀ 䄀匀 嬀嘀愀氀崀 䘀刀伀䴀 匀吀刀䤀一䜀开匀倀䰀䤀吀⠀嬀愀崀⸀嬀䐀愀琀愀匀琀爀攀愀洀崀Ⰰ ✀簀✀⤀ 䄀匀 嬀戀崀 ⤀ 䄀匀 嬀戀崀 ⤀ 䄀匀 嬀戀崀㬀ഀഀ
GO਍
