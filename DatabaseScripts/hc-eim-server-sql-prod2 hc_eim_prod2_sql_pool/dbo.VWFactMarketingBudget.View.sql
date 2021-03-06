/****** Object:  View [dbo].[VWFactMarketingBudget]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactMarketingBudget] AS SELECT
    [f].[FactDate]
  , [f].[Month]
  , [f].[BudgetType]
  , CASE WHEN [f].[Agency] = 'Non Agency' THEN 'Other' WHEN [f].[Agency] LIKE 'KingStar%' THEN 'Kingstar Media' WHEN [f].[Agency] LIKE 'In%house%' THEN
                                                                                                                'In-house' ELSE [f].[Agency] END AS [Agency]
  , CASE WHEN [f].[BudgetType] = 'Other' THEN 'Non Paid Media' ELSE 'PaidMedia' END AS [PaidMedia]
  , CASE WHEN [f].[Agency] = 'In-house' AND [f].[Channel] = 'Sweepstakes' THEN 'Paid Social' ELSE [f].[Channel] END AS [Channel]
  , CASE WHEN [f].[Agency] = 'Launch' AND [f].[Channel] IN ('Paid Social', 'Display') THEN 'Paid Social & Display'
        WHEN [f].[Agency] = 'Pure Digital' AND [f].[Channel] IN ('Paid Search', 'Display') THEN 'Paid Search & Display'
        WHEN [f].[Agency] = 'In-House' AND [f].[Channel] IN ('Paid Search', 'Paid Social', 'Local Search', 'Sweepstakes') THEN 'Multiple'
        WHEN [f].[Agency] = 'Other' THEN 'Multiple'
        ELSE [f].[Channel]
    END AS [ChannelGroup]
  , CASE WHEN [f].[Medium] = 'Localized Ads' THEN 'Localization Ads' ELSE [f].[Medium] END AS [Medium]
  , CASE WHEN [f].[Agency] = 'MediaPoint' THEN 'Linear' WHEN [f].[Medium] = 'Ott' THEN 'Linear' ELSE [f].[Source] END AS [Source]
  , [f].[Budget]
  , [f].[Location]
  , [f].[BudgetAmount]
  , [f].[TargetLeads] AS [TaregetLeads]
  , [f].[CurrencyConversion]
  , [f].[DWH_LoadDate]
  , [f].[DWH_UpdatedDate]
FROM [dbo].[FactMarketingBudget] AS [f];
GO
