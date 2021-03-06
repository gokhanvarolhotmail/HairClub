/****** Object:  View [dbo].[VWMarketingActivity_GVAROL]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWMarketingActivity_GVAROL]
AS SELECT
    [f].[FactDateKey]
  , [f].[FactDate] AS [MarketingActivityDateUTC]
  , [f].[FactDate] AS [MarketingActivityDateEST]
  , [f].[MarketingActivityDate]
  , [f].[MarketingActivityTime]
  , [f].[LocalAirTime]
  , [f].[TransactionId]
  , CASE WHEN ISNULL([f].[AgencyName], [f].[Agency]) LIKE '%KingStar%' THEN 'Kingstar Media' ELSE ISNULL([f].[AgencyName], [f].[Agency])END AS [AgencyName]
  , [f].[File]
  , [f].[BudgetAmount]
  , CASE WHEN [f].[Agency] = 'Pure Digital' AND [f].[Medium] = 'Shop' THEN 0 ELSE [f].[GrossSpend] END AS [GrossSpend]
  , [f].[Discount]
  , [f].[Fees]
  , CASE WHEN [f].[Agency] = 'Pure Digital' AND [f].[Medium] = 'Shop' THEN 0 ELSE [f].[NetSpend] END AS [NetSpend]
  , [f].[SpotDate]
  , [f].[Spots]
  , [f].[Telephone]
  , [f].[SourceCode]
  , [f].[PromoCode]
  , [f].[Url]
  , [f].[Impressions18-65]
  , [f].[Affiliate]
  , [f].[Station]
  , [f].[Show]
  , [f].[ContentType]
  , [f].[Content]
  , [f].[Isci]
  , [f].[MasterNumber]
  , [f].[DMAkey]
  , [f].[DMA]
  , [f].[AgencyKey]
  , CASE WHEN [f].[Agency] LIKE '%KingStar%' THEN 'Kingstar Media' ELSE [f].[Agency] END AS [Agency]
  , [f].[AudienceKey]
  , [f].[Audience]
  , [f].[ChannelKey]
  , CASE WHEN LOWER([f].[Medium]) = 'ott' THEN 'Television' ELSE [f].[Channel] END AS [Channel]
  , CASE WHEN [f].[Agency] = 'Launch' AND [f].[Channel] IN ('Paid Social', 'Display') THEN 'Paid Social & Display'
        WHEN [f].[Agency] = 'Pure Digital' AND [f].[Channel] IN ('Paid Search', 'Display', 'Shop') THEN 'Paid Search & Display'
        WHEN [f].[Agency] = 'In-House' AND [f].[Channel] IN ('Paid Search', 'Paid Social') THEN 'Multiple'
        WHEN [f].[Agency] = 'In-House' AND [f].[Medium] = 'Sports' THEN 'Poker'
        WHEN LOWER([f].[Medium]) = 'ott' THEN 'Television'
        ELSE [f].[Channel]
    END AS [ChannelGroup]
  , [f].[FormatKey]
  , [f].[Format]
  , [f].[TacticKey]
  , [f].[Tactic]
  , [f].[SourceKey]
  , CASE WHEN [f].[Agency] = 'A360' THEN 'Multiple'
        WHEN [f].[Agency] = 'In-House' AND [f].[Medium] = 'Sports' THEN 'Multiple'
        WHEN [f].[MarketingActivityDate] IS NOT NULL AND [f].[Channel] = 'Television' THEN 'Linear'
        WHEN [f].[Agency] = 'In-House' THEN 'Multiple'
        WHEN [f].[Agency] = 'Pure Digital' AND [f].[Channel] = 'Paid Search' AND [f].[Source] IN ('Bing', 'Google') THEN 'Multiple'
        WHEN [f].[Agency] = 'Valassis' AND [f].[Channel] = 'Display' AND [f].[Source] IN ('Bing', 'Google') THEN 'Multiple'
        WHEN [f].[Agency] = 'Venator' THEN 'Multiple'
        WHEN [f].[Source] = 'Unknown' THEN 'Multiple'
        ELSE [f].[Source]
    END AS [source]
  , [f].[MediumKey]
  , [f].[Medium] AS [Mediumsource]
  , CASE WHEN [f].[Agency] = 'Jane Creative' THEN 'Image & Video'
        WHEN [f].[Agency] = 'Launch' AND [f].[Medium] = 'Unknown' THEN 'Traditional Ads'
        WHEN [f].[Agency] = 'In-House' AND [f].[Medium] = 'Cpc' THEN 'Listings'
        WHEN [f].[Medium] = 'Banner' THEN 'Retargeting'
        WHEN [f].[Agency] = 'In-House' AND [f].[Medium] = 'Sports' THEN 'Poker'
        WHEN [f].[Medium] LIKE 'Short Form%' THEN 'Short Form'
        WHEN [f].[Medium] = 'Sponsored Content' THEN 'Retargeting'
        WHEN [f].[Medium] = 'Localized Ads' THEN 'Localization Ads'
        ELSE [f].[Medium]
    END AS [Medium]
  , [f].[PurposeKey]
  , [f].[Purpose]
  , [f].[MethodKey]
  , [f].[Method]
  , [f].[BudgetTypeKey]
  , [f].[BudgetName]
  , [f].[BudgetType]
  , [f].[CampaignKey]
  , [f].[Campaign]
  , [f].[CompanyKey]
  , [f].[Company]
  , [f].[LocationKey]
  , [f].[Location]
  , [f].[LanguageKey]
  , CASE WHEN [f].[Language] = 'En' THEN 'English' WHEN [f].[Language] = 'Es' THEN 'Spanish' ELSE ISNULL([f].[Language], 'Unknown')END AS [Language]
  , [f].[LogType]
  , [f].[NumberOfLeads]
  , [f].[NumberOfLeadsTarget]
  , [f].[NumertOfOpportunities]
  , [f].[NumberOfOpportunitiesTarget]
  , [f].[NumberOfSales]
  , [f].[NumberOfSalesTarget]
  , [f].[DWH_LoadDate]
  , CASE WHEN [f].[Company] = 'hairclub' AND [f].[BudgetType] = 'Franchise' THEN 'Franchise'
        WHEN [f].[Company] = 'hairclub' AND [f].[BudgetType] <> 'Franchise' THEN 'Corporate'
        WHEN [f].[Company] = 'Hans Wiemann' THEN 'Hans Wiemann'
        ELSE 'Corporate'
    END AS [Centertype]
FROM [dbo].[FactMarketingActivity] AS [f];
GO
