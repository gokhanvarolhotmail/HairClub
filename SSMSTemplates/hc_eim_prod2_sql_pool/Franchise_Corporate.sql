SELECT *
FROM [ODS].[MA_Targets]
WHERE [Date] = '2/1/2022' AND [Agency] IN ('Pure Digital', 'Jane Creative') ;

SELECT *
FROM [dbo].[FactMarketingBudget]
WHERE [FactDate] = '2/1/2022' AND [Agency] IN ('Pure Digital', 'Jane Creative') ;

SELECT
    CASE WHEN [Budget] = 'Barth' OR [Budget] = 'Strepman' THEN 'Franchise' WHEN [Channel] = 'Direct to Site' OR [Channel] = 'Other' THEN '' ELSE 'Corporate' END AS [Franchise_Corporate]
  , *
FROM [ODS].[MA_Targets]
WHERE CAST([Date] AS DATE)= '20220201' AND [Agency] IN ('Pure Digital', 'Jane Creative') ;

SELECT
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
FROM [dbo].[FactMarketingBudget] AS [f]
WHERE 1 = 0 ;

----------------------------------
SELECT
    CASE WHEN [Budget] = 'Barth' OR [Budget] = 'Strepman' THEN 'Franchise' WHEN [Channel] = 'Direct to Site' OR [Channel] = 'Other' THEN '' ELSE 'Corporate' END AS [Franchise_Corporate]
  , *
FROM [dbo].[VWFactMarketingBudget]
WHERE [FactDate] = '2/1/2022' AND [Agency] IN ('Pure Digital', 'Jane Creative') ;

DROP TABLE [#temp] ;

SELECT
    [BudgetType]
  , [Budget]
  , [Agency]
  , [Channel]
  , COUNT(*) AS [Cnt]
INTO [#temp]
FROM [dbo].[FactMarketingBudget]
WHERE CAST([FactDate] AS DATE) = '20220201'
GROUP BY [BudgetType]
       , [Budget]
       , [Agency]
       , [Channel] ;

DROP TABLE [#temp] ;

SELECT *
FROM [dbo].[FactMarketingBudget]
WHERE [DWH_LoadDate] > DATEADD(WEEK, -1, GETDATE()) ;

SELECT
    *
  , CASE WHEN [k].[Budget] = 'Barth' OR [k].[Budget] = 'Strepman' THEN 'Franchise' WHEN [k].[Channel] = 'Direct to Site' OR [k].[Channel] = 'Other' THEN '' ELSE
                                                                                                                                                            'Corporate' END AS [Franchise_Corporate]

FROM( SELECT
          [f].[BudgetType]
        , [f].[Budget]
        , [f].[Channel] AS [Channel_Old]
        , [f].[Agency]
        , CASE WHEN [f].[Agency] = 'In-house' AND [f].[Channel] = 'Sweepstakes' THEN 'Paid Social' ELSE [f].[Channel] END AS [Channel]
        , [f].[Cnt]
      FROM [#temp] AS [f] ) AS [k]
ORDER BY [k].[Agency]
       , [k].[BudgetType]
       , [k].[Budget]
       , [k].[Channel]
       , [k].[Cnt] DESC ;


SELECT
    [f].[FactDate]
  , [f].[Month]
  , [f].[BudgetType]
  , [f].[Agency]
  , [f].[Channel]
  , [f].[Medium]
  , [f].[Source]
  , [f].[Budget]
  , [f].[Location]
  , [f].[BudgetAmount]
  , [f].[TargetLeads]
  , [f].[CurrencyConversion]
  --, [f].[DWH_LoadDate]
  --, [f].[DWH_UpdatedDate]
  --, [f].[Fee]
  --, [f].[DataStreamID]
  --, [f].[DataStreamName]
  , CASE WHEN [f].[Budget] = 'Barth' OR [f].[Budget] = 'Strepman' THEN 'Franchise' WHEN [f].[Channel_Calc] = 'Direct to Site' OR [f].[Channel_Calc] = 'Other' THEN
                                                                                   '' ELSE 'Corporate' END AS [Franchise_Corporate]
FROM( SELECT
          [f].[FactDate]
        , [f].[Month]
        , [f].[BudgetType]
        , [f].[Agency]
        , [f].[Channel]
        , [f].[Medium]
        , [f].[Source]
        , [f].[Budget]
        , [f].[Location]
        , [f].[BudgetAmount]
        , [f].[TargetLeads]
        , [f].[CurrencyConversion]
        , [f].[DWH_LoadDate]
        , [f].[DWH_UpdatedDate]
        , [f].[Fee]
        , [f].[DataStreamID]
        , [f].[DataStreamName]
        , CASE WHEN [f].[Agency] = 'In-house' AND [f].[Channel] = 'Sweepstakes' THEN 'Paid Social' ELSE [f].[Channel] END AS [Channel_Calc]
      FROM [dbo].[FactMarketingBudget] AS [f]
      WHERE CAST([f].[FactDate] AS DATE) = '20220201' ) AS [f]
ORDER BY [f].[Agency]
       , [f].[Channel]
       , [f].[Medium] ;
