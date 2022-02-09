SET ANSI_NULLS ON ;
GO
SET QUOTED_IDENTIFIER ON ;
GO
ALTER VIEW [dbo].[VWDimCampaign_GVAROL]
AS
WITH [c]
AS (
   SELECT
       [d].[CampaignKey]
     , [d].[CampaignId] AS [id]
     , [d].[CampaignName]
     , [d].[CampaignDescription]
     , [d].[AgencyKey]
     , CASE WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'Paid Media'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignName] LIKE '%poker%' THEN 'Paid Media'
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'Paid Media'
           WHEN [d].[AgencyName] IN ('Havas', 'Cannella', 'Intermedia', 'Pure Digital', 'Barth-PureDigital', 'Kingstar', 'Kingstar Media', 'LaunchDRTV'
                                   , 'Mediapoint', 'Venator', 'Advance360', 'Advanced360', 'Jane Creative', 'Valassis', 'Outfront') THEN 'Paid Media'
           ELSE 'Non Paid Media'
       END AS [PayMediaType]
     , [d].[AgencyName]
     , CASE WHEN [d].[AgencyName] = 'Barth-Zimmerman' THEN 'Zimmerman'
           WHEN [d].[AgencyName] IN ('Advance360', 'Advanced360') THEN 'A360'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'In-House'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignName] LIKE '%poker%' THEN 'In-House'
           WHEN [d].[AgencyName] = 'Barth-PureDigital' THEN 'Pure Digital'
           WHEN [d].[AgencyName] = 'LaunchDRTV' THEN 'Launch'
           WHEN [d].[AgencyName] = 'Kingstar' THEN 'Kingstar Media'
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'In-House'
           ELSE ISNULL([d].[AgencyName], 'Unknown')
       END AS [AgencyNameDerived]
     , [d].[CampaignStatus]
     , [d].[StatusKey]
     , [d].[StartDate]
     , [d].[EndDate]
     , [d].[CurrencyIsoCode]
     , [d].[CurrencyKey]
     , [d].[PromoCode]
     , [d].[PromotioKey] AS [PromotionKey]
     , [d].[CampaignChannel]
     , [d].[ChannelKey]
     , [d].[CampaignLocation]
     , CASE WHEN [d].[AgencyName] LIKE '%Barth%' THEN 'Barth'
           WHEN [d].[AgencyName] LIKE '%Jane Creative%' THEN 'Barth'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[AgencyName] NOT LIKE '%Jane Creative%' AND [d].[CampaignLocation] LIKE '%US%' THEN 'USA'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[AgencyName] NOT LIKE '%Jane Creative%' AND [d].[CampaignLocation] LIKE '%Canada%' THEN 'CAN'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[AgencyName] NOT LIKE '%Jane Creative%' AND [d].[CampaignLocation] LIKE '%Puerto Rico%' THEN 'USA'
           ELSE 'Unknown'
       END AS [CampaignBudget]
     , CASE WHEN [d].[AgencyName] LIKE '%Barth%' THEN 'Franchise'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[CampaignLocation] LIKE '%Local%' THEN 'Local'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[CampaignLocation] LIKE '%National%' THEN 'National'
           WHEN [d].[AgencyName] NOT LIKE '%Barth%' AND [d].[CampaignLocation] LIKE '%Puerto Rico%' THEN 'Puerto Rico'
           ELSE 'Unknown'
       END AS [CampaignBudgetType]
     , [d].[CampaignLanguage]
     , [d].[LanguageKey]
     , [d].[CampaignMedia]
     , CASE WHEN [d].[AgencyName] = 'Intermedia' AND [d].[CampaignFormat] = ':30' THEN 'OTT'
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'Gleam'
           WHEN [d].[CampaignName] LIKE '%poker%' THEN 'Poker'
           WHEN [d].[AgencyName] LIKE '%King%' AND [d].[CampaignFormat] = 'Video' THEN 'Traditional Ads'
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Video' THEN 'Retargeting'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'Listings'
           WHEN [d].[AgencyName] = 'Mediapoint' THEN 'Paid Inquiry'
           WHEN [d].[AgencyName] = 'Venator' THEN 'Lead Gen'
           WHEN [d].[CampaignFormat] = 'Banner Ad' THEN 'Banner'
           WHEN [d].[CampaignFormat] = 'Mailer' THEN 'Direct Mail'
           WHEN [d].[CampaignFormat] IN ('Non-branded Ppc', 'Branded Ppc', 'Text Ad') THEN 'Cpc'
           WHEN [d].[CampaignFormat] IN ('Video Ad', 'Video Paid') THEN 'Video'
           --When CampaignFormat in ('Image','Image Ad') and (CampaignName not like '%gleam%') then 'Image'
           WHEN ( [d].[CampaignFormat] = ':30' AND [d].[AgencyName] <> 'Intermedia' ) OR ( [d].[CampaignFormat] IN (':10', ':60', ':120')) THEN 'Short Form'
           WHEN [d].[CampaignFormat] IN (':180', '240', '5:00') THEN 'Mid Form'
           WHEN [d].[CampaignFormat] IN ('28:30', '28:30:00') THEN 'Long Form'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%leads%ads%' THEN 'Lead Ads'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%local%' THEN 'Localization Ads'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%trad%ads%' THEN 'Traditional Ads'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%LiveConsultant%' THEN 'Lead Ads'
           WHEN [d].[AgencyName] LIKE '%Kingstar%' AND [d].[CampaignFormat] LIKE 'Image Ad' THEN 'Traditional Ads' --NEW
           ELSE ISNULL([d].[CampaignFormat], 'Unknown')
       END AS [CampaignMedium]
     , CASE WHEN [d].[AgencyName] = 'Venator' THEN 'Affiliate'
           WHEN [d].[AgencyName] <> 'Venator' AND [d].[CampaignMedia] LIKE 'Affiliate%' THEN 'Other'
           WHEN ( [d].[AgencyName] IN ('Havas', 'Cannella', 'Intermedia', 'Kingstar', 'Kingstar Media', 'Mediapoint') AND [d].[CampaignMedia] = 'TV' )
             OR ( [d].[AgencyName] = 'Intermedia' AND [d].[CampaignMedia] = 'Streaming' ) THEN 'Television'
           WHEN ( [d].[AgencyName] NOT IN ('Havas', 'Cannella', 'Intermedia', 'Kingstar', 'Kingstar Media', 'Mediapoint') AND [d].[CampaignMedia] = 'TV' ) THEN
               'Other'
           WHEN [d].[AgencyName] LIKE '%launch%' AND [d].[CampaignName] LIKE '%youtube%' THEN 'Display'
           WHEN [d].[AgencyName] LIKE '%pure%digital%'
            AND [d].[CampaignMedia] IN ('SEM', 'Display')
            AND [d].[CampaignFormat] IN ('Video Ad', 'Remarekting Display', 'Banner Ad') THEN 'Display'
           WHEN [d].[CampaignName] LIKE '%gleam%' AND [d].[CampaignMedia] = 'Paid Social' THEN 'Paid Social'
           WHEN [d].[CampaignName] LIKE '%gleam%' AND [d].[CampaignMedia] = 'Display' THEN 'Display'
           WHEN [d].[CampaignName] LIKE '%poker%' THEN 'Local Activation'
           WHEN [d].[AgencyName] LIKE '%launch%' AND [d].[CampaignName] NOT LIKE '%youtube%' THEN 'Paid Social'
           WHEN [d].[AgencyName] IN ('KingStar', 'Kingstar Media', 'Jane Creative', 'Internal Corporate', 'Hans Wiemann')
            AND [d].[CampaignMedia] = 'Paid Social' THEN 'Paid Social'
           WHEN [d].[AgencyName] LIKE '%Hans Wiemann%'
            AND [d].[CampaignMedia] = 'SEM'
            AND [d].[CampaignFormat] IN ('Branded PPC', 'Non-Branded PPC', 'Digital Referral', 'Text Ad') THEN 'Paid Search'
           WHEN [d].[AgencyName] LIKE '%pure%digital%'
            AND [d].[CampaignMedia] = 'SEM'
            AND [d].[CampaignFormat] IN ('Branded PPC', 'Non-Branded PPC', 'Digital Referral', 'Text Ad') THEN 'Paid Search'
           WHEN [d].[AgencyName] NOT LIKE '%Hans Wiemann%' AND [d].[AgencyName] NOT LIKE '%pure%digital%' AND [d].[CampaignMedia] = 'SEM' THEN 'Other'
           WHEN [d].[CampaignMedia] IN ('EVENT', 'REFERRAL', 'WALK-IN', 'WordOfMouth', 'Word-Of-Mouth', 'Walk In') THEN 'Word-Of-Mouth'
           WHEN [d].[CampaignMedia] = 'ORGANIC' THEN 'Local Search'
           WHEN [d].[CampaignMedia] = 'SEO/Organic' THEN 'Organic Search'
           WHEN [d].[CampaignMedia] IN ('Brochure', 'Collateral', 'Direct Mail', 'Flyer', 'Magazine', 'Newspaper', 'Print') THEN 'Print'
           WHEN [d].[CampaignMedia] IN ('PRESS RELEASE', 'Earned Social') THEN 'Earned Social'
           WHEN [d].[CampaignMedia] IN ('WEBSITE', 'WEB') THEN 'Direct'
           WHEN [d].[CampaignMedia] IN ('SEO/ORGANIC') THEN 'Other'
           WHEN [d].[CampaignMedia] IN ('Email', 'SMS/TEXT', 'INBOUND', 'OUTBOUND') THEN 'Email'
           WHEN [d].[CampaignMedia] IN ('SPONSORSHIP/CHARITY', 'Out of Home', 'Sports') THEN 'Local Activation'
           WHEN [d].[CampaignMedia] = 'STREAMING' THEN 'Display'
           WHEN [d].[CampaignMedia] IN ('UNKNOWN', 'THIRD PARTY') THEN 'Other'
           WHEN [d].[CampaignMedia] IN ('DirectMail', 'Direct Mail') THEN 'Direct Mail'
           WHEN [d].[CampaignMedia] = 'Radio' OR [d].[CampaignFormat] IN ('Radio', 'Radio Ad', 'Radio Spot :10', 'Radio Spot :30', 'Radio Spot :60') THEN
               'Audio'
           WHEN [d].[AgencyName] IN ('Havas', 'Intermedia', 'Cannella') THEN 'Television'
           WHEN [d].[AgencyName] LIKE '%KingStar%' AND [d].[CampaignMedia] IN ('Television', 'TV') THEN 'Television'
           ELSE ISNULL([d].[CampaignMedia], 'Other')
       END AS [CampaignChannelDerived]
     , [d].[MediaKey]
     , [d].[CampaignSource]
     , CASE WHEN [d].[CampaignMedia] = 'TV' THEN 'Linear'
           WHEN [d].[AgencyName] LIKE '%King%' AND [d].[CampaignFormat] = 'Video' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Jane Creative%' THEN 'Facebook'
           WHEN [d].[AgencyName] = 'Intermedia' AND [d].[CampaignFormat] = ':30' THEN 'Hulu'
           WHEN [d].[AgencyName] = 'Intermedia' AND [d].[CampaignFormat] <> ':30' THEN 'Linear'
           WHEN TRIM([d].[CampaignSource]) = 'Broad Reach' AND [d].[AgencyName] <> 'Intermedia' THEN 'Linear'
           WHEN [d].[AgencyName] = 'Advance360' THEN 'Multiple'
           WHEN [d].[AgencyName] = 'MediaPoint' THEN 'Multiple'
           WHEN [d].[CampaignSource] LIKE 'Adroll%' THEN 'Ad Roll'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignMedia] = 'ORGANIC' THEN 'Multiple'
           WHEN [d].[AgencyName] = 'Internal Corporate' AND [d].[CampaignName] LIKE '%poker%' THEN 'Multiple'
           WHEN [d].[AgencyName] LIKE '%Pure%Digital%' AND TRIM([d].[CampaignFormat]) IN ('Non-branded Ppc', 'Branded Ppc', 'Text Ad') THEN 'Multiple'
           WHEN [d].[CampaignName] LIKE '%gleam%' THEN 'Multiple'
           WHEN [d].[AgencyName] = 'Venator' THEN 'Multiple'
           WHEN [d].[AgencyName] = 'Valassis' THEN 'Multiple'
           WHEN [d].[CampaignSource] = 'Facebook-instagram' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Banner Ad' THEN 'Ad Roll'
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Remarketing Display' THEN 'Google'
           WHEN [d].[AgencyName] LIKE '%Pure Digital%' AND [d].[CampaignFormat] = 'Video Ad' THEN 'Youtube'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%leads%ads%' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%local%' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%trad%ads%' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%youtube%' THEN 'Youtube'
           WHEN [d].[AgencyName] LIKE '%Launch%' AND [d].[CampaignName] LIKE '%Facebook%' THEN 'Facebook'
           WHEN [d].[AgencyName] LIKE '%Kingstar%' AND [d].[CampaignFormat] LIKE 'Image Ad' THEN 'Facebook' --NEW
           WHEN [d].[CampaignFormat] IN ('Video Ad', 'Video Paid') AND [d].[AgencyName] LIKE '%Kingstar%' THEN 'Facebook' --NEW
           ELSE [d].[CampaignSource]
       END AS [CampaignSourceDerived]
     , [d].[SourceKey]
     , [d].[Campaigngender]
     , [d].[GenderKey]
     , [d].[CampaignType]
     , [d].[BudgetedCost]
     , [d].[ActualCost]
     , [d].[DNIS]
     , [d].[Referrer]
     , [d].[ReferralFlag]
     , [d].[DWH_LoadDate]
     , [d].[DWH_LastUpdateDate]
     , [d].[IsActive]
     , [d].[SourceSystem]
     , [d].[CampaignFormat]
     , [d].[CampaignDeviceType]
     , [d].[CampaignDNIS]
     , [d].[CampaignTactic]
     , [d].[CampaignPromoDescription]
     , [d].[SourceCode]
     , [d].[TollFreeName]
     , [d].[TollFreeMobileName]
   FROM [dbo].[DimCampaign] AS [d] )
SELECT
    [c].[CampaignKey]
  , [c].[id]
  , [c].[CampaignName]
  , [c].[CampaignDescription]
  , [c].[AgencyKey]
  , [c].[PayMediaType]
  , [c].[AgencyName]
  , CASE WHEN [c].[PayMediaType] = 'Paid Media' THEN [c].[AgencyNameDerived] ELSE 'Other' END AS [AgencyNameDerived]
  , [c].[CampaignStatus]
  , [c].[StatusKey]
  , [c].[StartDate]
  , [c].[EndDate]
  , [c].[CurrencyIsoCode]
  , [c].[CurrencyKey]
  , [c].[PromoCode]
  , [c].[PromotionKey]
  , [c].[CampaignChannel]
  , CASE WHEN [c].[AgencyNameDerived] = 'Launch' AND [c].[CampaignChannelDerived] IN ('Paid Social', 'Display', 'Email') THEN 'Paid Social & Display'
        WHEN [c].[AgencyNameDerived] = 'Pure Digital' AND [c].[CampaignChannelDerived] IN ('Paid Search', 'Display') THEN 'Paid Search & Display'
        WHEN [c].[AgencyNameDerived] = 'In-House' AND [c].[CampaignChannelDerived] IN ('Paid Search', 'Paid Social') THEN 'Multiple'
        WHEN [c].[AgencyNameDerived] = 'In-House' AND [c].[CampaignName] LIKE '%gleam%' THEN 'Multiple'
        ELSE [c].[CampaignChannelDerived]
    END AS [CampaignChannelGroup]
  , [c].[ChannelKey]
  , [c].[CampaignLocation]
  , [c].[CampaignBudget]
  , [c].[CampaignBudgetType]
  , [c].[CampaignLanguage]
  , [c].[LanguageKey]
  , [c].[CampaignMedia]
  , [c].[CampaignMedium]
  , CASE WHEN [c].[AgencyNameDerived] = 'Launch'
          AND [c].[CampaignName] NOT LIKE '%Leads-Ads%'
          AND [c].[CampaignName] NOT LIKE '%Localized%'
          AND [c].[CampaignSource] NOT LIKE 'Youtube%' THEN 'Traditional Ads'
        WHEN [c].[AgencyNameDerived] = 'Launch'
         AND [c].[CampaignName] LIKE '%Leads-Ads%'
         AND [c].[CampaignSource] = 'Facebook'
         AND [c].[CampaignFormat] = 'Image' THEN 'Lead Ads'
        WHEN [c].[CampaignMedium] IN ('Banner', 'Remarketing Display') THEN 'Retargeting'
        WHEN [c].[AgencyNameDerived] = 'A360' AND [c].[CampaignMedium] = 'Image' THEN 'Retargeting'
        WHEN [c].[AgencyNameDerived] LIKE '%Kingstar%' AND [c].[CampaignMedium] = 'Image' THEN 'Traditional Ads'
        WHEN [c].[AgencyNameDerived] = 'Launch'
         AND [c].[CampaignName] LIKE '%Localized%'
         AND [c].[CampaignSource] = 'Facebook-Instagram'
         AND [c].[CampaignFormat] = 'Video' THEN 'Localization Ads'
        WHEN [c].[AgencyNameDerived] = 'Jane Creative' THEN 'Image & Video'
        ELSE [c].[CampaignMedium]
    END AS [CampaignMediumgroup]
  , [c].[CampaignChannelDerived]
  , [c].[MediaKey]
  , [c].[CampaignSource]
  , [c].[CampaignSourceDerived]
  , [c].[SourceKey]
  , [c].[Campaigngender]
  , [c].[GenderKey]
  , [c].[CampaignType]
  , [c].[BudgetedCost]
  , [c].[ActualCost]
  , [c].[DNIS]
  , [c].[Referrer]
  , [c].[ReferralFlag]
  , [c].[DWH_LoadDate]
  , [c].[DWH_LastUpdateDate]
  , [c].[IsActive]
  , [c].[SourceSystem]
  , [c].[CampaignFormat]
  , [c].[CampaignDeviceType]
  , [c].[CampaignDNIS]
  , [c].[CampaignTactic]
  , [c].[CampaignPromoDescription]
  , [c].[SourceCode]
  , [c].[TollFreeName]
  , [c].[TollFreeMobileName]
FROM [c] ;
GO
