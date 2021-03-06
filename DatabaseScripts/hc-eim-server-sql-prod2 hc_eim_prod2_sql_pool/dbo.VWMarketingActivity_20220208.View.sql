/****** Object:  View [dbo].[VWMarketingActivity_20220208]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWMarketingActivity_20220208]
AS SELECT [FactDateKey]
      ,[FactDate] MarketingActivityDateUTC
	 , FactDate MarketingActivityDateEST
      ,[MarketingActivityDate]
      ,[MarketingActivityTime]
      ,[LocalAirTime]
      ,[TransactionId]
      ,CASE WHEN ISNULL([AgencyName],agency) LIKE '%KingStar%' THEN 'Kingstar Media'
	  ELSE ISNULL([AgencyName],agency) END AgencyName
      ,[File]
      ,[BudgetAmount]
      ,CASE WHEN agency='Pure Digital' AND medium='Shop' THEN 0 ELSE [GrossSpend] END [GrossSpend]
      ,[Discount]
      ,[Fees]
      ,CASE WHEN agency='Pure Digital' AND medium='Shop' THEN 0 ELSE [NetSpend] END [NetSpend]
      ,[SpotDate]
      ,[Spots]
      ,[Telephone]
      ,[SourceCode]
      ,[PromoCode]
      ,[Url]
      ,[Impressions18-65]
      ,[Affiliate]
      ,[Station]
      ,[Show]
      ,[ContentType]
      ,[Content]
      ,[Isci]
      ,[MasterNumber]
      ,[DMAkey]
      ,[DMA]
      ,[AgencyKey]
      ,CASE WHEN [Agency] LIKE '%KingStar%' THEN 'Kingstar Media'
	  ELSE [Agency] END Agency
      ,[AudienceKey]
      ,[Audience]
      ,[ChannelKey]
      ,CASE WHEN LOWER([medium])='ott' THEN 'Television'
	   ELSE [Channel] END Channel
	   ,CASE
	  WHEN Agency='Launch' AND Channel IN ('Paid Social','Display') THEN 'Paid Social & Display'
	  WHEN Agency='Pure Digital' AND Channel IN ('Paid Search','Display','Shop') THEN 'Paid Search & Display'
	  WHEN Agency='In-House' AND Channel IN ('Paid Search','Paid Social') THEN 'Multiple'
	  WHEN Agency='In-House' AND Medium='Sports' THEN 'Poker'
	  WHEN LOWER([medium])='ott' THEN 'Television'
	  ELSE Channel END ChannelGroup
	  ,[FormatKey]
      ,[Format]
      ,[TacticKey]
      ,[Tactic]
      ,[SourceKey]
      ,CASE
	  WHEN agency='A360' THEN 'Multiple'
	  WHEN Agency='In-House' AND Medium='Sports' THEN 'Multiple'
	  WHEN marketingactivitydate IS NOT  NULL AND channel='Television' THEN 'Linear'
	  WHEN agency='In-House'  THEN 'Multiple'
	  WHEN agency='Pure Digital' AND channel='Paid Search' AND source IN ('Bing','Google') THEN 'Multiple'
	   WHEN agency='Valassis' AND channel='Display' AND source IN ('Bing','Google') THEN 'Multiple'
	 WHEN agency='Venator' THEN 'Multiple'
	  WHEN source='Unknown' THEN 'Multiple'
	   ELSE source END source
      ,[MediumKey]
	  ,Medium Mediumsource
      ,CASE WHEN Agency='Jane Creative' THEN 'Image & Video'
	   WHEN Agency='Launch' AND medium='Unknown' THEN 'Traditional Ads'
	   WHEN Agency='In-House' AND medium='Cpc' THEN 'Listings'
	   WHEN  medium='Banner' THEN 'Retargeting'
	   WHEN Agency='In-House' AND Medium='Sports' THEN 'Poker'
	   WHEN medium LIKE 'Short Form%' THEN 'Short Form'
	   WHEN medium='Sponsored Content' THEN 'Retargeting'
	   WHEN medium='Localized Ads' THEN 'Localization Ads'
	  ELSE [medium] END Medium
      ,[PurposeKey]
      ,[Purpose]
      ,[MethodKey]
      ,[Method]
      ,[BudgetTypeKey]
      ,  BudgetName
      ,[BudgetType]
      ,[CampaignKey]
      ,[Campaign]
      ,[CompanyKey]
      ,[Company]
      ,[LocationKey]
      ,[Location]
      ,[LanguageKey]
      ,CASE
	  WHEN [Language]='En' THEN 'English'
	  WHEN [Language]='Es' THEN 'Spanish'
	  ELSE ISNULL([Language],'Unknown') END [Language]
	  ,LogType
      ,[NumberOfLeads]
      ,[NumberOfLeadsTarget]
      ,[NumertOfOpportunities]
      ,[NumberOfOpportunitiesTarget]
      ,[NumberOfSales]
      ,[NumberOfSalesTarget]
      ,[DWH_LoadDate]
	  ,CASE WHEN company='hairclub' AND budgettype='Franchise' THEN 'Franchise'
	   WHEN company='hairclub' AND budgettype!='Franchise' THEN 'Corporate'
	   WHEN company='Hans Wiemann'  THEN 'Hans Wiemann'
	   ELSE 'Corporate' END Centertype
  FROM [dbo].[FactMarketingActivity];
GO
