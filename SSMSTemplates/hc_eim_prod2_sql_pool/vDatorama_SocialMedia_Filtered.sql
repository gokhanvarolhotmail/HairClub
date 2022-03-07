ALTER VIEW [ODS].[vDatorama_SocialMedia_Filtered]
AS
SELECT
    [d].[DataStream]
  , [d].[CRMDay]
  , [d].[CampaignAdvertiserID]
  , [d].[CampaignAdvertaiser]
  , [d].[MediaCost]
  , [d].[Clicks]
  , [d].[FilePath]
  , [d].[DWH_LoadDate]
  , [d].[MediaSpend]
FROM [ODS].[Datorama_SocialMedia] AS [d]
WHERE [d].[DWH_LoadDate] > DATEADD(DAY, -3, GETUTCDATE()) AND [d].[DWH_LoadDate] <= GETUTCDATE() ;
GO
