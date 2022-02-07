/****** Object:  View [dbo].[VWDimCampaign]    Script Date: 2/7/2022 10:45:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWDimCampaign] AS With Campaign As
(
SELECT  [CampaignKey]
      ,CampaignId id
      ,[CampaignName]
      ,[CampaignDescription]
      ,[AgencyKey]
	  ,Case
	   When AgencyName='Internal Corporate' and CampaignMedia = 'ORGANIC' then 'Paid Media'
	    When AgencyName='Internal Corporate' and CampaignName like '%poker%' then 'Paid Media'
	    When CampaignName like '%gleam%' then 'Paid Media'
	   When AgencyName in ('Havas','Cannella','Intermedia','Pure Digital','Barth-PureDigital','Kingstar','Kingstar Media','LaunchDRTV','Mediapoint','Venator','Advance360','Advanced360','Jane Creative','Valassis','Outfront') then 'Paid Media'
	   else 'Non Paid Media' end PayMediaType
      ,[AgencyName]
	  , Case 
	    When AgencyName='Barth-Zimmerman' then 'Zimmerman'
		When AgencyName in ('Advance360','Advanced360') then 'A360'
		When AgencyName='Internal Corporate' and CampaignMedia = 'ORGANIC' then 'In-House'
		When AgencyName='Internal Corporate' and CampaignName like  '%poker%' then 'In-House'
	    When AgencyName='Barth-PureDigital' then 'Pure Digital'
		When AgencyName='LaunchDRTV' then 'Launch'
		When AgencyName='Kingstar' then 'Kingstar Media'
		WHEN  CampaignName like '%gleam%'  then 'In-House'
	    Else isnull(AgencyName,'Unknown') End AgencyNameDerived
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
	  Case 
	  When AgencyName like '%Barth%' then 'Barth'
	  When AgencyName like '%Jane Creative%' then 'Barth'
	  When AgencyName not like '%Barth%' and AgencyName not like '%Jane Creative%'  and CampaignLocation like '%US%' then 'USA'
	  When AgencyName not like '%Barth%' and AgencyName not like '%Jane Creative%' and CampaignLocation like '%Canada%' then 'CAN'
	  When AgencyName not like '%Barth%' and AgencyName not like '%Jane Creative%' and CampaignLocation like '%Puerto Rico%' then 'USA'
	  else 'Unknown' end CampaignBudget,
	   Case 
	  When AgencyName like '%Barth%' then 'Franchise'
	  When AgencyName not like '%Barth%' and CampaignLocation like '%Local%' then 'Local'
	  When AgencyName not like '%Barth%' and CampaignLocation like '%National%' then 'National'
	  When AgencyName not like '%Barth%' and CampaignLocation like '%Puerto Rico%' then 'Puerto Rico'
	  else 'Unknown' end CampaignBudgetType
      ,[CampaignLanguage]
      ,[LanguageKey]
      ,[CampaignMedia],
	   Case 
	   When AgencyName='Intermedia' and CampaignFormat=':30' then 'OTT'  
	   WHEN CampaignName like '%gleam%' then 'Gleam'
	   When campaignName like '%poker%' then 'Poker'
	   When AgencyName like '%King%' and  CampaignFormat='Video' then 'Traditional Ads'
	   When AgencyName like '%Pure Digital%' and  CampaignFormat='Video' then 'Retargeting'
	   When AgencyName='Internal Corporate' and CampaignMedia = 'ORGANIC' then 'Listings'
	   When AgencyName='Mediapoint' then 'Paid Inquiry'
	   When AgencyName='Venator' then 'Lead Gen'
	   When CampaignFormat='Banner Ad' then 'Banner'
	   When CampaignFormat='Mailer' then 'Direct Mail'
	   When CampaignFormat in ('Non-branded Ppc','Branded Ppc','Text Ad') then 'Cpc'
	   When CampaignFormat in ('Video Ad','Video Paid')  then 'Video'
	   --When CampaignFormat in ('Image','Image Ad') and (CampaignName not like '%gleam%') then 'Image'
	   When (CampaignFormat=':30' and AgencyName!='Intermedia') or (CampaignFormat in (':10',':60',':120')) then 'Short Form'
	   When CampaignFormat in (':180','240','5:00') then 'Mid Form'
	   When CampaignFormat in ('28:30','28:30:00') then 'Long Form'
	   When AgencyName like '%Launch%' and campaignname like '%leads%ads%' then 'Lead Ads'
	   When AgencyName like '%Launch%' and campaignname like '%local%' then 'Localization Ads'
	   When AgencyName like '%Launch%' and campaignname like '%trad%ads%' then 'Traditional Ads'
	   When AgencyName like '%Launch%' and campaignname like '%LiveConsultant%' then 'Lead Ads'
	   When AgencyName like '%Kingstar%' and CampaignFormat like 'Image Ad' then 'Traditional Ads' --NEW
		else isnull(CampaignFormat,'Unknown') end CampaignMedium,
	  CASE
WHEN AgencyName = 'Venator' THEN
'Affiliate'
When AgencyName!='Venator' and CampaignMedia like 'Affiliate%' then 'Other'
WHEN (AgencyName in ('Havas','Cannella','Intermedia','Kingstar','Kingstar Media','Mediapoint') and CampaignMedia = 'TV')
OR
(
AgencyName = 'Intermedia'
AND CampaignMedia = 'Streaming'
) THEN
'Television'
WHEN (AgencyName not in ('Havas','Cannella','Intermedia','Kingstar','Kingstar Media','Mediapoint') and CampaignMedia = 'TV') then 'Other'
WHEN lower(AgencyName) like '%launch%' and Campaignname like '%youtube%' then 'Display'
WHEN agencyname like '%pure%digital%' and CampaignMedia in ('SEM', 'Display') and campaignformat in ('Video Ad', 'Remarekting Display', 'Banner Ad') THEN 'Display'
WHEN  CampaignName like '%gleam%' and Campaignmedia='Paid Social' then 'Paid Social'
WHEN  CampaignName like '%gleam%' and Campaignmedia='Display' then 'Display'
WHEN  CampaignName like '%poker%'  then 'Local Activation'
When agencyname like '%launch%' and  Campaignname not like '%youtube%' then 'Paid Social'
When agencyname in ('KingStar','Kingstar Media','Jane Creative','Internal Corporate','Hans Wiemann') and Campaignmedia='Paid Social' then 'Paid Social'
WHEN agencyname like '%Hans Wiemann%' and CampaignMedia in ('SEM') and campaignformat in ('Branded PPC' , 'Non-Branded PPC', 'Digital Referral' , 'Text Ad') THEN
'Paid Search'
WHEN agencyname like '%pure%digital%' and CampaignMedia in ('SEM') and campaignformat in ('Branded PPC' , 'Non-Branded PPC', 'Digital Referral' , 'Text Ad') THEN
'Paid Search'
WHEN agencyname not like '%Hans Wiemann%' and agencyname not like '%pure%digital%' and CampaignMedia in ('SEM')  THEN
'Other'
WHEN CampaignMedia IN ( 'EVENT', 'REFERRAL', 'WALK-IN', 'WordOfMouth', 'Word-Of-Mouth','Walk In') THEN
'Word-Of-Mouth'
WHEN CampaignMedia = 'ORGANIC' THEN
'Local Search'
WHEN campaignmedia='SEO/Organic' THEN 'Organic Search'
WHEN CampaignMedia in ('Brochure','Collateral','Direct Mail','Flyer','Magazine','Newspaper','Print') then 'Print'
WHEN CampaignMedia in  ('PRESS RELEASE','Earned Social') THEN
'Earned Social'
WHEN CampaignMedia in ('WEBSITE','WEB') THEN
'Direct'
WHEN CampaignMedia IN ( 'SEO/ORGANIC' ) THEN
'Other'
WHEN CampaignMedia IN ('Email', 'SMS/TEXT', 'INBOUND', 'OUTBOUND' ) THEN
'Email'
WHEN CampaignMedia in ('SPONSORSHIP/CHARITY','Out of Home','Sports') THEN
'Local Activation'
WHEN CampaignMedia = 'STREAMING' THEN
'Display'
WHEN CampaignMedia IN ( 'UNKNOWN', 'THIRD PARTY' ) THEN
'Other'
WHEN CampaignMedia IN ('DirectMail', 'Direct Mail') THEN
'Direct Mail'
When CampaignMedia ='Radio' or CampaignFormat in ('Radio', 'Radio Ad', 'Radio Spot :10', 'Radio Spot :30', 'Radio Spot :60') then 'Audio'
When agencyName in ('Havas','Intermedia','Cannella') then 'Television'
When agencyname like '%KingStar%' and CampaignMedia IN ('Television','TV') then 'Television'
ELSE
isnull(CampaignMedia,'Other')
END AS CampaignChannelDerived
      ,[MediaKey]
      ,[CampaignSource]
	  , Case 
	    When Campaignmedia='TV' then 'Linear'
		When AgencyName like '%King%' and CampaignFormat='Video' then 'Facebook'
		When AgencyName like '%Jane Creative%' then 'Facebook'
	    When  AgencyName='Intermedia' and CampaignFormat=':30' then 'Hulu'
		When  AgencyName='Intermedia' and CampaignFormat!=':30' then 'Linear'
		When trim([CampaignSource])='Broad Reach' and (AgencyName!='Intermedia') then 'Linear'
		When AgencyName='Advance360' then 'Multiple'
		When AgencyName='MediaPoint' then 'Multiple'
		When CampaignSource like 'Adroll%' then 'Ad Roll'
		When AgencyName='Internal Corporate' and CampaignMedia = 'ORGANIC' then 'Multiple'
		When AgencyName='Internal Corporate' and Campaignname like '%poker%' then 'Multiple'
		When AgencyName like '%Pure%Digital%' and  trim(CampaignFormat) in ('Non-branded Ppc','Branded Ppc','Text Ad')   then 'Multiple'
		when CampaignName like '%gleam%' then 'Multiple'
		when AgencyName='Venator' then 'Multiple'
		when AgencyName='Valassis' then 'Multiple'
		When CampaignSource='Facebook-instagram' then 'Facebook'
		When AgencyName like '%Pure Digital%' and CampaignFormat='Banner Ad' then 'Ad Roll'
		When AgencyName like '%Pure Digital%' and CampaignFormat='Remarketing Display' then 'Google'
		When AgencyName like '%Pure Digital%' and CampaignFormat='Video Ad' then 'Youtube'
		When AgencyName like '%Launch%' and campaignname like '%leads%ads%' then 'Facebook'
		When AgencyName like '%Launch%' and campaignname like '%local%' then 'Facebook'
		When AgencyName like '%Launch%' and campaignname like '%trad%ads%' then 'Facebook'
		When AgencyName like '%Launch%' and campaignname like '%youtube%' then 'Youtube'
		When AgencyName like '%Launch%' and campaignname like '%Facebook%' then 'Facebook'
		When AgencyName like '%Kingstar%' and CampaignFormat like 'Image Ad' then 'Facebook' --NEW
		When CampaignFormat in ('Video Ad','Video Paid')  and AgencyName like '%Kingstar%' then 'Facebook' --NEW
		else [CampaignSource] end CampaignSourceDerived 
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
  Select [CampaignKey]
      ,[id]
      ,[CampaignName]
      ,[CampaignDescription]
      ,[AgencyKey]
      ,[PayMediaType]
      ,[AgencyName]
      ,Case When PayMediaType='Paid Media' then [AgencyNameDerived]
	    else 'Other' end AgencyNameDerived
      ,[CampaignStatus]
      ,[StatusKey]
      ,[StartDate]
      ,[EndDate]
      ,[CurrencyIsoCode]
      ,[CurrencyKey]
      ,[PromoCode]
      , PromotionKey
      ,[CampaignChannel]
	  ,Case 
	  When AgencyNameDerived='Launch' and CampaignChannelDerived in ('Paid Social','Display','Email') Then 'Paid Social & Display'
	  When AgencyNameDerived='Pure Digital' and CampaignChannelDerived in ('Paid Search','Display') Then 'Paid Search & Display'
	  When AgencyNameDerived='In-House' and CampaignChannelDerived in ('Paid Search','Paid Social') Then 'Multiple'
	  when AgencyNameDerived='In-House' and CampaignName like '%gleam%' Then 'Multiple'
	  else CampaignChannelDerived end CampaignChannelGroup
      ,[ChannelKey]
      ,[CampaignLocation]
      ,[CampaignBudget]
      ,[CampaignBudgetType]
      ,[CampaignLanguage]
      ,[LanguageKey]
      ,[CampaignMedia]
      ,[CampaignMedium]
	  ,Case When AgencyNameDerived='Launch' and [CampaignName] not like '%Leads-Ads%' and CampaignName not like '%Localized%' and campaignsource not like 'Youtube%'  then 'Traditional Ads'
	   When AgencyNameDerived='Launch' and CampaignName like '%Leads-Ads%' and campaignsource='Facebook' and campaignformat='Image' then 'Lead Ads'
	   When  [CampaignMedium] in ('Banner','Remarketing Display') then 'Retargeting'
	   When AgencyNameDerived='A360' and CampaignMedium='Image' then 'Retargeting'
	   When AgencyNameDerived like '%Kingstar%' and CampaignMedium='Image' then 'Traditional Ads'
	   When AgencyNameDerived='Launch' and CampaignName like '%Localized%' and campaignsource='Facebook-Instagram' and campaignformat='Video' then 'Localization Ads'
	   When  AgencyNameDerived='Jane Creative' then 'Image & Video'
	   else CampaignMedium end  CampaignMediumgroup
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
