/****** Object:  View [dbo].[VWMarketingActivity_20220204]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWMarketingActivity_20220204]
AS SELECT [FactDateKey]
      ,[FactDate] MarketingActivityDateUTC
	 , FactDate MarketingActivityDateEST
      ,[MarketingActivityDate]
      ,[MarketingActivityTime]
      ,[LocalAirTime]
      ,[TransactionId]
      ,Case when isnull([AgencyName],agency) like '%KingStar%' then 'Kingstar Media'
	  else isnull([AgencyName],agency) end AgencyName
      ,[File]
      ,[BudgetAmount]
      ,Case when agency='Pure Digital' and medium='Shop' then 0 else [GrossSpend] end [GrossSpend]
      ,[Discount]
      ,[Fees]
      ,Case when agency='Pure Digital' and medium='Shop' then 0 else [NetSpend] end [NetSpend]
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
      ,Case when [Agency] like '%KingStar%' then 'Kingstar Media'
	  else [Agency] end Agency
      ,[AudienceKey]
      ,[Audience]
      ,[ChannelKey]
      ,case when lower([medium])='ott' then 'Television'
	   else [Channel] end Channel
	   ,Case
	  When Agency='Launch' and Channel in ('Paid Social','Display') Then 'Paid Social & Display'
	  When Agency='Pure Digital' and Channel in ('Paid Search','Display','Shop') Then 'Paid Search & Display'
	  When Agency='In-House' and Channel in ('Paid Search','Paid Social') Then 'Multiple'
	  When Agency='In-House' and Medium='Sports' then 'Poker'
	  When lower([medium])='ott' then 'Television'
	  else Channel end ChannelGroup
	  ,[FormatKey]
      ,[Format]
      ,[TacticKey]
      ,[Tactic]
      ,[SourceKey]
      ,case
	  when agency='A360' then 'Multiple'
	  When Agency='In-House' and Medium='Sports' then 'Multiple'
	  when marketingactivitydate is not  null and channel='Television' then 'Linear'
	  when agency='In-House'  then 'Multiple'
	  When agency='Pure Digital' and channel='Paid Search' and source in ('Bing','Google') then 'Multiple'
	   When agency='Valassis' and channel='Display' and source in ('Bing','Google') then 'Multiple'
	 when agency='Venator' then 'Multiple'
	  When source='Unknown' then 'Multiple'
	   else source end source
      ,[MediumKey]
	  ,Medium Mediumsource
      ,Case When Agency='Jane Creative' then 'Image & Video'
	   When Agency='Launch' and medium='Unknown' then 'Traditional Ads'
	   When Agency='In-House' and medium='Cpc' then 'Listings'
	   when  medium='Banner' then 'Retargeting'
	   When Agency='In-House' and Medium='Sports' then 'Poker'
	   When medium like 'Short Form%' then 'Short Form'
	   When medium='Sponsored Content' then 'Retargeting'
	   When medium='Localized Ads' then 'Localization Ads'
	  else [medium] end Medium
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
      ,case
	  when [Language]='En' then 'English'
	  when [Language]='Es' then 'Spanish'
	  else isnull([Language],'Unknown') end [Language]
	  ,LogType
      ,[NumberOfLeads]
      ,[NumberOfLeadsTarget]
      ,[NumertOfOpportunities]
      ,[NumberOfOpportunitiesTarget]
      ,[NumberOfSales]
      ,[NumberOfSalesTarget]
      ,[DWH_LoadDate]
	  ,case when company='hairclub' and budgettype='Franchise' then 'Franchise'
	   when company='hairclub' and budgettype!='Franchise' then 'Corporate'
	   when company='Hans Wiemann'  then 'Hans Wiemann'
	   else 'Corporate' end Centertype
  FROM [dbo].[FactMarketingActivity];
GO
