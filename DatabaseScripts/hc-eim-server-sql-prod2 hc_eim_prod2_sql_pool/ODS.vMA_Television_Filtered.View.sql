/****** Object:  View [ODS].[vMA_Television_Filtered]    Script Date: 3/12/2022 7:09:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[vMA_Television_Filtered] AS SELECT
    [d].[transactionid]
  , [d].[calendardateest]
  , [d].[calendartimeest]
  , [d].[broadcastdateest]
  , [d].[localairtime]
  , [d].[purpose]
  , [d].[method]
  , [d].[channel]
  , [d].[medium]
  , [d].[company]
  , [d].[location]
  , [d].[budgettype]
  , [d].[budgetname]
  , [d].[source]
  , [d].[affiliate]
  , [d].[station]
  , [d].[show]
  , [d].[contenttype]
  , [d].[content]
  , [d].[campaigntype]
  , [d].[campaign]
  , [d].[isci]
  , [d].[masternumber]
  , [d].[tfn]
  , [d].[sourcecode]
  , [d].[promocode]
  , [d].[url]
  , [d].[agency]
  , [d].[region]
  , [d].[dmacode]
  , [d].[dmaname]
  , [d].[audiene]
  , [d].[tactic]
  , [d].[placement]
  , [d].[format]
  , [d].[language]
  , [d].[grossspend]
  , [d].[netspend]
  , [d].[impressions18-65]
  , [d].[grp]
  , [d].[spots]
  , [d].[logtype]
  , [d].[impressions35+]
  , [d].[trp]
  , [d].[DWH_LoadDate]
  , [d].[FilePath]
  , [d].[CADPrice]
  , [d].[Impressions]
FROM( SELECT
          [d].[transactionid]
        , [d].[calendardateest]
        , [d].[calendartimeest]
        , [d].[broadcastdateest]
        , [d].[localairtime]
        , [d].[purpose]
        , [d].[method]
        , [d].[channel]
        , [d].[medium]
        , [d].[company]
        , [d].[location]
        , [d].[budgettype]
        , [d].[budgetname]
        , [d].[source]
        , [d].[affiliate]
        , [d].[station]
        , [d].[show]
        , [d].[contenttype]
        , [d].[content]
        , [d].[campaigntype]
        , [d].[campaign]
        , [d].[isci]
        , [d].[masternumber]
        , [d].[tfn]
        , [d].[sourcecode]
        , [d].[promocode]
        , [d].[url]
        , [d].[agency]
        , [d].[region]
        , [d].[dmacode]
        , [d].[dmaname]
        , [d].[audiene]
        , [d].[tactic]
        , [d].[placement]
        , [d].[format]
        , [d].[language]
        , [d].[grossspend]
        , [d].[netspend]
        , [d].[impressions18-65]
        , [d].[grp]
        , [d].[spots]
        , [d].[logtype]
        , [d].[impressions35+]
        , [d].[trp]
        , [d].[DWH_LoadDate]
        , [d].[FilePath]
        , [d].[CADPrice]
        , [d].[Impressions]
        , ROW_NUMBER() OVER ( PARTITION BY [d].[transactionid], [d].[agency], [d].[calendardateest], [d].[calendartimeest] ORDER BY [d].[DWH_LoadDate] DESC ) AS [Row]
      FROM [ODS].[MA_Television] AS [d]
      WHERE [d].[DWH_LoadDate] > DATEADD(DAY, -3, GETUTCDATE()) AND [d].[DWH_LoadDate] <= GETUTCDATE()) AS [d]
WHERE [d].[Row] = 1;
GO
