/****** Object:  View [dbo].[VWFactMarketingBudget_20220214]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactMarketingBudget_20220214]
AS SELECT
    [FactDate]
  , [Month]
  , [BudgetType]
  , CASE WHEN [Agency] = 'Non Agency' THEN 'Other' WHEN [Agency] LIKE 'KingStar%' THEN 'Kingstar Media' WHEN [Agency] LIKE 'In%house%' THEN 'In-house' ELSE
                                                                                                                                                       [agency] END AS [Agency]
  , CASE WHEN [budgettype] = 'Other' THEN 'Non Paid Media' ELSE 'PaidMedia' END AS [PaidMedia]
  , CASE WHEN [Agency] = 'In-house' AND [channel] = 'Sweepstakes' THEN 'Paid Social' ELSE [Channel] END AS [Channel]
  , CASE WHEN [Agency] = 'Launch' AND [Channel] IN ('Paid Social', 'Display') THEN 'Paid Social & Display'
        WHEN [Agency] = 'Pure Digital' AND [Channel] IN ('Paid Search', 'Display') THEN 'Paid Search & Display'
        WHEN [Agency] = 'In-House' AND [Channel] IN ('Paid Search', 'Paid Social', 'Local Search', 'Sweepstakes') THEN 'Multiple'
        WHEN [Agency] = 'Other' THEN 'Multiple'
        ELSE [Channel]
    END AS [ChannelGroup]
  , CASE WHEN [medium] = 'Localized Ads' THEN 'Localization Ads' ELSE [Medium] END AS [Medium]
  , CASE WHEN [agency] = 'MediaPoint' THEN 'Linear' WHEN [medium] = 'Ott' THEN 'Linear' ELSE [Source] END AS [Source]
  , [Budget]
  , [Location]
  , [BudgetAmount]
  , [TargetLeads] AS [TaregetLeads]
  , [CurrencyConversion]
  , [DWH_LoadDate]
  , [DWH_UpdatedDate]
FROM [dbo].[FactMarketingBudget] AS [f];
GO
