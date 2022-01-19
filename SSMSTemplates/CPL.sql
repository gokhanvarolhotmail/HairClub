SELECT *
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID('VWFactMarketingBudget') AND [name] IN ('Leads', 'NetSpend', 'AgencyName')
ORDER BY [name] ;

SELECT *
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID('VWLead') AND [name] IN ('Leads', 'NetSpend', 'AgencyName')
ORDER BY [name] ;

SELECT *
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID('VWMarketingActivity') AND [name] IN ('Leads', 'NetSpend', 'AgencyName')
ORDER BY [name] ;

IF OBJECT_ID('[tempdb]..[#Leads]') IS NOT NULL
    DROP TABLE [#Leads] ;

IF OBJECT_ID('[tempdb]..[#NetSpend]') IS NOT NULL
    DROP TABLE [#NetSpend] ;

IF OBJECT_ID('[tempdb]..[#Step2]') IS NOT NULL
    DROP TABLE [#Step2] ;

SELECT
    [AgencyName]
  , CAST([LeadCreatedDateEST] AS DATE) AS [dt]
  , COUNT(1) AS [Cnt]
INTO [#Leads]
FROM [dbo].[VWLead]
WHERE [Isvalid] = 1 AND [IsDeleted] = 0
GROUP BY CAST([LeadCreatedDateEST] AS DATE)
       , [AgencyName] ;

SELECT
    [AgencyName]
  , CAST([MarketingActivityDateEST] AS DATE) AS [Dt]
  , SUM([NetSpend]) AS [NetSpend]
  , COUNT(1) AS [Cnt]
INTO [#NetSpend]
FROM [dbo].[VWMarketingActivity]
WHERE ISNULL([Company], '') <> 'Hans Wiemann'
GROUP BY CAST([MarketingActivityDateEST] AS DATE)
       , [AgencyName] ;

SELECT
    [k].[Dt]
  --, [k].[AgencyName]
  , SUM([k].[NetSpend]) AS [NetSpend]
  , SUM(CASE WHEN [k].[AgencyName] = 'MediaPoint' THEN 200 * [k].[Leads] WHEN [k].[AgencyName] = 'Venator' THEN 125 * [k].[Leads] ELSE [k].[NetSpend] END) AS [NetSpend2]
  , SUM([k].[SpendCnt]) AS [SpendCnt]
  , SUM([k].[Leads]) AS [Leads]
  , CAST(SUM([k].[NetSpend]) / SUM([k].[Leads]) AS MONEY) AS [SpendPerLead]
  , CAST(SUM(CASE WHEN [k].[AgencyName] = 'MediaPoint' THEN 200 * [k].[Leads] WHEN [k].[AgencyName] = 'Venator' THEN 125 * [k].[Leads] ELSE [k].[NetSpend] END) / SUM([k].[Leads]) AS MONEY) AS [SpendPerLead2]
INTO [#Step2]
FROM( SELECT
          [Dt]
        , [AgencyName]
        , [NetSpend]
        , [Cnt] AS [SpendCnt]
        , NULL AS [Leads]
      FROM [#NetSpend]
      UNION ALL
      SELECT
          [dt]
        , [AgencyName]
        , NULL AS [NetSpend]
        , 0 AS [SpendCnt]
        , [Cnt] AS [Leads]
      FROM [#Leads] ) AS [k]
GROUP BY [k].[Dt] ;

--       , [k].[AgencyName] ;
SELECT *
FROM [#Step2]
WHERE dt <= GETDATE()
ORDER BY [Dt] DESC ;
