/****** Object:  View [dbo].[VWMarketingActivity]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWMarketingActivity] AS SELECT
    [FactDateKey]
  , [FactDate] AS [MarketingActivityDateUTC]
  , [FactDate] AS [MarketingActivityDateEST]
  , [MarketingActivityDate]
  , [MarketingActivityTime]
  , [LocalAirTime]
  , [TransactionId]
  , CASE WHEN ISNULL([AgencyName], [Agency]) LIKE '%KingStar%' THEN 'Kingstar Media' ELSE ISNULL([AgencyName], [Agency])END AS [AgencyName]
  , [File]
  , [BudgetAmount]
  , CASE WHEN [Agency] = 'Pure Digital' AND [Medium] = 'Shop' THEN 0 ELSE [GrossSpend] END AS [GrossSpend]
  , [Discount]
  , [Fees]
  , CASE WHEN [Agency] = 'Pure Digital' AND [Medium] = 'Shop' THEN 0 ELSE [NetSpend] END AS [NetSpend]
  , [SpotDate]
  , [Spots]
  , [Telephone]
  , [SourceCode]
  , [PromoCode]
  , [Url]
  , [Impressions18-65]
  , [Affiliate]
  , [Station]
  , [Show]
  , [ContentType]
  , [Content]
  , [Isci]
  , [MasterNumber]
  , [DMAkey]
  , [DMA]
  , [AgencyKey]
  , CASE WHEN [Agency] LIKE '%KingStar%' THEN 'Kingstar Media' ELSE [Agency] END AS [Agency]
  , [AudienceKey]
  , [Audience]
  , [ChannelKey]
  , CASE WHEN LOWER([Medium]) = 'ott' THEN 'Television' ELSE [Channel] END AS [Channel]
  , CASE WHEN [Agency] = 'Launch' AND [Channel] IN ('Paid Social', 'Display') THEN 'Paid Social & Display'
        WHEN [Agency] = 'Pure Digital' AND [Channel] IN ('Paid Search', 'Display', 'Shop') THEN 'Paid Search & Display'
        WHEN [Agency] = 'In-House' AND [Channel] IN ('Paid Search', 'Paid Social') THEN 'Multiple'
        WHEN [Agency] = 'In-House' AND [Medium] = 'Sports' THEN 'Poker'
        WHEN LOWER([Medium]) = 'ott' THEN 'Television'
        ELSE [Channel]
    END AS [ChannelGroup]
  , [FormatKey]
  , [Format]
  , [TacticKey]
  , [Tactic]
  , [SourceKey]
  , CASE WHEN [Agency] = 'A360' THEN 'Multiple'
        WHEN [Agency] = 'In-House' AND [Medium] = 'Sports' THEN 'Multiple'
        WHEN [MarketingActivityDate] IS NOT NULL AND [Channel] = 'Television' THEN 'Linear'
        WHEN [Agency] = 'In-House' THEN 'Multiple'
        WHEN [Agency] = 'Pure Digital' AND [Channel] = 'Paid Search' AND [Source] IN ('Bing', 'Google') THEN 'Multiple'
        WHEN [Agency] = 'Valassis' AND [Channel] = 'Display' AND [Source] IN ('Bing', 'Google') THEN 'Multiple'
        WHEN [Agency] = 'Venator' THEN 'Multiple'
        WHEN [Source] = 'Unknown' THEN 'Multiple'
        ELSE [Source]
    END AS [source]
  , [MediumKey]
  , [Medium] AS [Mediumsource]
  , CASE WHEN [Agency] = 'Jane Creative' THEN 'Image & Video'
        WHEN [Agency] = 'Launch' AND [Medium] = 'Unknown' THEN 'Traditional Ads'
        WHEN [Agency] = 'In-House' AND [Medium] = 'Cpc' THEN 'Listings'
        WHEN [Medium] = 'Banner' THEN 'Retargeting'
        WHEN [Agency] = 'In-House' AND [Medium] = 'Sports' THEN 'Poker'
        WHEN [Medium] LIKE 'Short Form%' THEN 'Short Form'
        WHEN [Medium] = 'Sponsored Content' THEN 'Retargeting'
        WHEN [Medium] = 'Localized Ads' THEN 'Localization Ads'
        ELSE [Medium]
    END AS [Medium]
  , [PurposeKey]
  , [Purpose]
  , [MethodKey]
  , [Method]
  , [BudgetTypeKey]
  , [BudgetName]
  , [BudgetType]
  , [CampaignKey]
  , [Campaign]
  , [CompanyKey]
  , [Company]
  , [LocationKey]
  , [Location]
  , [LanguageKey]
  , CASE WHEN [Language] = 'En' THEN 'English' WHEN [Language] = 'Es' THEN 'Spanish' ELSE ISNULL([Language], 'Unknown')END AS [Language]
  , [LogType]
  , [NumberOfLeads]
  , [NumberOfLeadsTarget]
  , [NumertOfOpportunities]
  , [NumberOfOpportunitiesTarget]
  , [NumberOfSales]
  , [NumberOfSalesTarget]
  , [DWH_LoadDate]
  , CASE WHEN [Company] = 'hairclub' AND [BudgetType] = 'Franchise' THEN 'Franchise' WHEN [Company] = 'hairclub' AND [BudgetType] != 'Franchise' THEN
                                                                                     'Corporate' WHEN [Company] = 'Hans Wiemann' THEN 'Hans Wiemann' ELSE
                                                                                                                                                     'Corporate' END AS [Centertype]
FROM [dbo].[FactMarketingActivity];
GO
