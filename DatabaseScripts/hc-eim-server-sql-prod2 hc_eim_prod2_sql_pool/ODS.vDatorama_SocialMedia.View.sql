/****** Object:  View [ODS].[vDatorama_SocialMedia]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[vDatorama_SocialMedia] AS SELECT
    [b].[Company]
  , [b].[Agency]
  , [b].[SourceMedia]
  , [b].[Location]
  , [b].[BudgetType]
  , [b].[BudgetName]
  , [b].[Channel]
  , [b].[Medium]
  , [a].[CRMDay]
  , [a].[CampaignAdvertiserID]
  , [a].[CampaignAdvertaiser]
  , [a].[MediaCost]
  , [a].[Clicks]
  , [a].[FilePath]
  , [a].[DWH_LoadDate]
  , [a].[MediaSpend]
  , [a].[DataStream]
FROM( SELECT
          [a].[DataStream]
        , [a].[CRMDay]
        , [a].[CampaignAdvertiserID]
        , [a].[CampaignAdvertaiser]
        , [a].[MediaCost]
        , [a].[Clicks]
        , [a].[FilePath]
        , [a].[DWH_LoadDate]
        , [a].[MediaSpend]
      FROM [ODS].[Datorama_SocialMedia] AS [a] ) AS [a]
CROSS APPLY( SELECT
                 MAX(CASE WHEN [b].[Id] = 1 THEN [b].[Val] END) AS [Company]
               , MAX(CASE WHEN [b].[Id] = 2 THEN [b].[Val] END) AS [Agency]
               , MAX(CASE WHEN [b].[Id] = 3 THEN [b].[Val] END) AS [SourceMedia]
               , MAX(CASE WHEN [b].[Id] = 4 THEN [b].[Val] END) AS [Location]
               , MAX(CASE WHEN [b].[Id] = 5 THEN [b].[Val] END) AS [BudgetType]
               , MAX(CASE WHEN [b].[Id] = 6 THEN [b].[Val] END) AS [BudgetName]
               , MAX(CASE WHEN [b].[Id] = 7 THEN [b].[Val] END) AS [Channel]
               , MAX(CASE WHEN [b].[Id] = 8 THEN [b].[Val] END) AS [Medium]
             FROM( SELECT ROW_NUMBER() OVER ( ORDER BY( SELECT 0 )) AS [Id], TRIM([b].[value]) AS [Val] FROM STRING_SPLIT([a].[DataStream], '|') AS [b] ) AS [b] ) AS [b];
GO
