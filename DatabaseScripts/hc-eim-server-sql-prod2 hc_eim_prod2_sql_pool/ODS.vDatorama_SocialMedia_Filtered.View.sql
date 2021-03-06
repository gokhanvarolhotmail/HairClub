/****** Object:  View [ODS].[vDatorama_SocialMedia_Filtered]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[vDatorama_SocialMedia_Filtered] AS SELECT
    [d].[DataStream]
  , [d].[CRMDay]
  , [d].[CampaignAdvertiserID]
  , [d].[CampaignAdvertaiser]
  , [d].[MediaCost]
  , [d].[Clicks]
  , [d].[FilePath]
  , [d].[DWH_LoadDate]
  , [d].[MediaSpend]
FROM( SELECT
          [d].[DataStream]
        , [d].[CRMDay]
        , [d].[CampaignAdvertiserID]
        , [d].[CampaignAdvertaiser]
        , [d].[MediaCost]
        , [d].[Clicks]
        , [d].[FilePath]
        , [d].[DWH_LoadDate]
        , [d].[MediaSpend]
        , ROW_NUMBER() OVER ( PARTITION BY [d].[DataStream], [d].[CRMDay] ORDER BY [d].[DWH_LoadDate] DESC ) AS [Row]
      FROM [ODS].[Datorama_SocialMedia] AS [d]
      WHERE [d].[DWH_LoadDate] > DATEADD(DAY, -3, GETUTCDATE()) AND [d].[DWH_LoadDate] <= GETUTCDATE()) AS [d]
WHERE [d].[Row] = 1;
GO
