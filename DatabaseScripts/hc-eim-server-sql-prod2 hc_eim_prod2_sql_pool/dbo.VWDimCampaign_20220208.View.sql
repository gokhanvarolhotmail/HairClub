/****** Object:  View [dbo].[VWDimCampaign_20220208]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWDimCampaign_20220208]
AS WITH Campaign AS
(
SELECT  [CampaignKey]
      ,CampaignId id
      ,[CampaignName]
      ,[CampaignDescription]
      ,[AgencyKey]
	  ,CASE
	   WHEN AgencyName='Internal Corporate' AND CampaignMedia = 'ORGANIC' THEN 'Paid Media'
	    WHEN AgencyName='Internal Corporate' AND CampaignName LIKE '%poker%' THEN 'Paid Media'
	    WHEN CampaignName LIKE '%gleam%' THEN 'Paid Media'
	   WHEN AgencyName IN ('Havas','Cannella','Intermedia','Pure Digital','Barth-PureDigital','Kingstar','Kingstar Media','LaunchDRTV','Mediapoint','Venator','Advance360','Advanced360','Jane Creative','Valassis','Outfront') THEN 'Paid Media'
	   ELSE 'Non Paid Media' END PayMediaType
      ,[AgencyName]
	  , CASE
	    WHEN AgencyName='Barth-Zimmerman' THEN 'Zimmerman'
		WHEN AgencyName IN ('Advance360','Advanced360') THEN 'A360'
		WHEN AgencyName='Internal Corporate' AND CampaignMedia = 'ORGANIC' THEN 'In-House'
		WHEN AgencyName='Internal Corporate' AND CampaignName LIKE  '%poker%' THEN 'In-House'
	    WHEN AgencyName='Barth-PureDigital' THEN 'Pure Digital'
		WHEN AgencyName='LaunchDRTV' THEN 'Launch'
		WHEN AgencyName='Kingstar' THEN 'Kingstar Media'
		WHEN  CampaignName LIKE '%gleam%'  THEN 'In-House'
	    ELSE ISNULL(AgencyName,'Unknown') END AgencyNameDerived
      ,[CampaignStatus]
      ,[StatusKey]
      ,[StartDate]
      ,[EndDate]
      ,[CurrencyIsoCode]
      ,[CurrencyKey]
      ,[PromoCode]
      ,PromotioKey PromotionKey
      ,[CampaignChannel]
      ,[ChannelKey]
      ,[CampaignLocation],
	  CASE
	  WHEN AgencyName LIKE '%Barth%' THEN 'Barth'
	  WHEN AgencyName LIKE '%Jane Creative%' THEN 'Barth'
	  WHEN AgencyName NOT LIKE '%Barth%' AND AgencyName NOT LIKE '%Jane Creative%'  AND CampaignLocation LIKE '%US%' THEN 'USA'
	  WHEN AgencyName NOT LIKE '%Barth%' AND AgencyName NOT LIKE '%Jane Creative%' AND CampaignLocation LIKE '%Canada%' THEN 'CAN'
	  WHEN AgencyName NOT LIKE '%Barth%' AND AgencyName NOT LIKE '%Jane Creative%' AND CampaignLocation LIKE '%Puerto Rico%' THEN 'USA'
	  ELSE 'Unknown' END CampaignBudget,
	   CASE
	  WHEN AgencyName LIKE '%Barth%' THEN 'Franchise'
	  WHEN AgencyName NOT LIKE '%Barth%' AND CampaignLocation LIKE '%Local%' THEN 'Local'
	  WHEN AgencyName NOT LIKE '%Barth%' AND CampaignLocation LIKE '%National%' THEN 'National'
	  WHEN AgencyName NOT LIKE '%Barth%' AND CampaignLocation LIKE '%Puerto Rico%' THEN 'Puerto Rico'
	  ELSE 'Unknown' END CampaignBudgetType
      ,[CampaignLanguage]
      ,[LanguageKey]
      ,[CampaignMedia],
	   CASE
	   WHEN AgencyName='Intermedia' AND CampaignFormat=':30' THEN 'OTT'
	   WHEN CampaignName LIKE '%gleam%' THEN 'Gleam'
	   WHEN campaignName LIKE '%poker%' THEN 'Poker'
	   WHEN AgencyName LIKE '%King%' AND  CampaignFormat='Video' THEN 'Traditional Ads'
	   WHEN AgencyName LIKE '%Pure Digital%' AND  CampaignFormat='Video' THEN 'Retargeting'
	   WHEN AgencyName='Internal Corporate' AND CampaignMedia = 'ORGANIC' THEN 'Listings'
	   WHEN AgencyName='Mediapoint' THEN 'Paid Inquiry'
	   WHEN AgencyName='Venator' THEN 'Lead Gen'
	   WHEN CampaignFormat='Banner Ad' THEN 'Banner'
	   WHEN CampaignFormat='Mailer' THEN 'Direct Mail'
	   WHEN CampaignFormat IN ('Non-branded Ppc','Branded Ppc','Text Ad') THEN 'Cpc'
	   WHEN CampaignFormat IN ('Video Ad','Video Paid')  THEN 'Video'
	   --When CampaignFormat in ('Image','Image Ad') and (CampaignName not like '%gleam%') then 'Image'
	   WHEN (CampaignFormat=':30' AND AgencyName!='Intermedia') OR (CampaignFormat IN (':10',':60',':120')) THEN 'Short Form'
	   WHEN CampaignFormat IN (':180','240','5:00') THEN 'Mid Form'
	   WHEN CampaignFormat IN ('28:30','28:30:00') THEN 'Long Form'
	   WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%leads%ads%' THEN 'Lead Ads'
	   WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%local%' THEN 'Localization Ads'
	   WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%trad%ads%' THEN 'Traditional Ads'
	   WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%LiveConsultant%' THEN 'Lead Ads'
	   WHEN AgencyName LIKE '%Kingstar%' AND CampaignFormat LIKE 'Image Ad' THEN 'Traditional Ads' --NEW
		ELSE ISNULL(CampaignFormat,'Unknown') END CampaignMedium,
	  CASE
WHEN AgencyName = 'Venator' THEN
'Affiliate'
WHEN AgencyName!='Venator' AND CampaignMedia LIKE 'Affiliate%' THEN 'Other'
WHEN (AgencyName IN ('Havas','Cannella','Intermedia','Kingstar','Kingstar Media','Mediapoint') AND CampaignMedia = 'TV')
OR
(
AgencyName = 'Intermedia'
AND CampaignMedia = 'Streaming'
) THEN
'Television'
WHEN (AgencyName NOT IN ('Havas','Cannella','Intermedia','Kingstar','Kingstar Media','Mediapoint') AND CampaignMedia = 'TV') THEN 'Other'
WHEN LOWER(AgencyName) LIKE '%launch%' AND Campaignname LIKE '%youtube%' THEN 'Display'
WHEN agencyname LIKE '%pure%digital%' AND CampaignMedia IN ('SEM', 'Display') AND campaignformat IN ('Video Ad', 'Remarekting Display', 'Banner Ad') THEN 'Display'
WHEN  CampaignName LIKE '%gleam%' AND Campaignmedia='Paid Social' THEN 'Paid Social'
WHEN  CampaignName LIKE '%gleam%' AND Campaignmedia='Display' THEN 'Display'
WHEN  CampaignName LIKE '%poker%'  THEN 'Local Activation'
WHEN agencyname LIKE '%launch%' AND  Campaignname NOT LIKE '%youtube%' THEN 'Paid Social'
WHEN agencyname IN ('KingStar','Kingstar Media','Jane Creative','Internal Corporate','Hans Wiemann') AND Campaignmedia='Paid Social' THEN 'Paid Social'
WHEN agencyname LIKE '%Hans Wiemann%' AND CampaignMedia IN ('SEM') AND campaignformat IN ('Branded PPC' , 'Non-Branded PPC', 'Digital Referral' , 'Text Ad') THEN
'Paid Search'
WHEN agencyname LIKE '%pure%digital%' AND CampaignMedia IN ('SEM') AND campaignformat IN ('Branded PPC' , 'Non-Branded PPC', 'Digital Referral' , 'Text Ad') THEN
'Paid Search'
WHEN agencyname NOT LIKE '%Hans Wiemann%' AND agencyname NOT LIKE '%pure%digital%' AND CampaignMedia IN ('SEM')  THEN
'Other'
WHEN CampaignMedia IN ( 'EVENT', 'REFERRAL', 'WALK-IN', 'WordOfMouth', 'Word-Of-Mouth','Walk In') THEN
'Word-Of-Mouth'
WHEN CampaignMedia = 'ORGANIC' THEN
'Local Search'
WHEN campaignmedia='SEO/Organic' THEN 'Organic Search'
WHEN CampaignMedia IN ('Brochure','Collateral','Direct Mail','Flyer','Magazine','Newspaper','Print') THEN 'Print'
WHEN CampaignMedia IN  ('PRESS RELEASE','Earned Social') THEN
'Earned Social'
WHEN CampaignMedia IN ('WEBSITE','WEB') THEN
'Direct'
WHEN CampaignMedia IN ( 'SEO/ORGANIC' ) THEN
'Other'
WHEN CampaignMedia IN ('Email', 'SMS/TEXT', 'INBOUND', 'OUTBOUND' ) THEN
'Email'
WHEN CampaignMedia IN ('SPONSORSHIP/CHARITY','Out of Home','Sports') THEN
'Local Activation'
WHEN CampaignMedia = 'STREAMING' THEN
'Display'
WHEN CampaignMedia IN ( 'UNKNOWN', 'THIRD PARTY' ) THEN
'Other'
WHEN CampaignMedia IN ('DirectMail', 'Direct Mail') THEN
'Direct Mail'
WHEN CampaignMedia ='Radio' OR CampaignFormat IN ('Radio', 'Radio Ad', 'Radio Spot :10', 'Radio Spot :30', 'Radio Spot :60') THEN 'Audio'
WHEN agencyName IN ('Havas','Intermedia','Cannella') THEN 'Television'
WHEN agencyname LIKE '%KingStar%' AND CampaignMedia IN ('Television','TV') THEN 'Television'
ELSE
ISNULL(CampaignMedia,'Other')
END AS CampaignChannelDerived
      ,[MediaKey]
      ,[CampaignSource]
	  , CASE
	    WHEN Campaignmedia='TV' THEN 'Linear'
		WHEN AgencyName LIKE '%King%' AND CampaignFormat='Video' THEN 'Facebook'
		WHEN AgencyName LIKE '%Jane Creative%' THEN 'Facebook'
	    WHEN  AgencyName='Intermedia' AND CampaignFormat=':30' THEN 'Hulu'
		WHEN  AgencyName='Intermedia' AND CampaignFormat!=':30' THEN 'Linear'
		WHEN trim([CampaignSource])='Broad Reach' AND (AgencyName!='Intermedia') THEN 'Linear'
		WHEN AgencyName='Advance360' THEN 'Multiple'
		WHEN AgencyName='MediaPoint' THEN 'Multiple'
		WHEN CampaignSource LIKE 'Adroll%' THEN 'Ad Roll'
		WHEN AgencyName='Internal Corporate' AND CampaignMedia = 'ORGANIC' THEN 'Multiple'
		WHEN AgencyName='Internal Corporate' AND Campaignname LIKE '%poker%' THEN 'Multiple'
		WHEN AgencyName LIKE '%Pure%Digital%' AND  TRIM(CampaignFormat) IN ('Non-branded Ppc','Branded Ppc','Text Ad')   THEN 'Multiple'
		WHEN CampaignName LIKE '%gleam%' THEN 'Multiple'
		WHEN AgencyName='Venator' THEN 'Multiple'
		WHEN AgencyName='Valassis' THEN 'Multiple'
		WHEN CampaignSource='Facebook-instagram' THEN 'Facebook'
		WHEN AgencyName LIKE '%Pure Digital%' AND CampaignFormat='Banner Ad' THEN 'Ad Roll'
		WHEN AgencyName LIKE '%Pure Digital%' AND CampaignFormat='Remarketing Display' THEN 'Google'
		WHEN AgencyName LIKE '%Pure Digital%' AND CampaignFormat='Video Ad' THEN 'Youtube'
		WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%leads%ads%' THEN 'Facebook'
		WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%local%' THEN 'Facebook'
		WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%trad%ads%' THEN 'Facebook'
		WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%youtube%' THEN 'Youtube'
		WHEN AgencyName LIKE '%Launch%' AND campaignname LIKE '%Facebook%' THEN 'Facebook'
		WHEN AgencyName LIKE '%Kingstar%' AND CampaignFormat LIKE 'Image Ad' THEN 'Facebook' --NEW
		WHEN CampaignFormat IN ('Video Ad','Video Paid')  AND AgencyName LIKE '%Kingstar%' THEN 'Facebook' --NEW
		ELSE [CampaignSource] END CampaignSourceDerived
	  ,[SourceKey]
      ,[Campaigngender]
      ,[GenderKey]
      ,[CampaignType]
      ,[BudgetedCost]
      ,[ActualCost]
      ,[DNIS]
      ,[Referrer]
      ,[ReferralFlag]
      ,[DWH_LoadDate]
      ,[DWH_LastUpdateDate]
      ,[IsActive]
      ,[SourceSystem]
      ,[CampaignFormat]
      ,[CampaignDeviceType]
      ,[CampaignDNIS]
      ,[CampaignTactic]
      ,[CampaignPromoDescription]
      ,[SourceCode]
      ,[TollFreeName]
      ,[TollFreeMobileName]
  FROM [dbo].[DimCampaign]
  )
  SELECT [CampaignKey]
      ,[id]
      ,[CampaignName]
      ,[CampaignDescription]
      ,[AgencyKey]
      ,[PayMediaType]
      ,[AgencyName]
      ,CASE WHEN PayMediaType='Paid Media' THEN [AgencyNameDerived]
	    ELSE 'Other' END AgencyNameDerived
      ,[CampaignStatus]
      ,[StatusKey]
      ,[StartDate]
      ,[EndDate]
      ,[CurrencyIsoCode]
      ,[CurrencyKey]
      ,[PromoCode]
      , PromotionKey
      ,[CampaignChannel]
	  ,CASE
	  WHEN AgencyNameDerived='Launch' AND CampaignChannelDerived IN ('Paid Social','Display','Email') THEN 'Paid Social & Display'
	  WHEN AgencyNameDerived='Pure Digital' AND CampaignChannelDerived IN ('Paid Search','Display') THEN 'Paid Search & Display'
	  WHEN AgencyNameDerived='In-House' AND CampaignChannelDerived IN ('Paid Search','Paid Social') THEN 'Multiple'
	  WHEN AgencyNameDerived='In-House' AND CampaignName LIKE '%gleam%' THEN 'Multiple'
	  ELSE CampaignChannelDerived END CampaignChannelGroup
      ,[ChannelKey]
      ,[CampaignLocation]
      ,[CampaignBudget]
      ,[CampaignBudgetType]
      ,[CampaignLanguage]
      ,[LanguageKey]
      ,[CampaignMedia]
      ,[CampaignMedium]
	  ,CASE WHEN AgencyNameDerived='Launch' AND [CampaignName] NOT LIKE '%Leads-Ads%' AND CampaignName NOT LIKE '%Localized%' AND campaignsource NOT LIKE 'Youtube%'  THEN 'Traditional Ads'
	   WHEN AgencyNameDerived='Launch' AND CampaignName LIKE '%Leads-Ads%' AND campaignsource='Facebook' AND campaignformat='Image' THEN 'Lead Ads'
	   WHEN  [CampaignMedium] IN ('Banner','Remarketing Display') THEN 'Retargeting'
	   WHEN AgencyNameDerived='A360' AND CampaignMedium='Image' THEN 'Retargeting'
	   WHEN AgencyNameDerived LIKE '%Kingstar%' AND CampaignMedium='Image' THEN 'Traditional Ads'
	   WHEN AgencyNameDerived='Launch' AND CampaignName LIKE '%Localized%' AND campaignsource='Facebook-Instagram' AND campaignformat='Video' THEN 'Localization Ads'
	   WHEN  AgencyNameDerived='Jane Creative' THEN 'Image & Video'
	   ELSE CampaignMedium END  CampaignMediumgroup
      ,[CampaignChannelDerived]
      ,[MediaKey]
      ,[CampaignSource]
      ,[CampaignSourceDerived]
      ,[SourceKey]
      ,[Campaigngender]
      ,[GenderKey]
      ,[CampaignType]
      ,[BudgetedCost]
      ,[ActualCost]
      ,[DNIS]
      ,[Referrer]
      ,[ReferralFlag]
      ,[DWH_LoadDate]
      ,[DWH_LastUpdateDate]
      ,[IsActive]
      ,[SourceSystem]
      ,[CampaignFormat]
      ,[CampaignDeviceType]
      ,[CampaignDNIS]
      ,[CampaignTactic]
      ,[CampaignPromoDescription]
      ,[SourceCode]
      ,[TollFreeName]
      ,[TollFreeMobileName]
	  FROM Campaign;
GO
