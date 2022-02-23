/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) 
[LeadKey]
, [LeadId]
, [LeadFirstName]
, [LeadLastname]
, [LeadFullName]
, [LeadBirthday]
, [LeadAddress]
, [IsActive]
, [IsConsultFormComplete]
, [Isvalid]
, [LeadEmail]
, [LeadPhone]
, [LeadMobilePhone]
, [NorwoodScale]
, [LudwigScale]
, [HairLossInFamily]
, [HairLossProductUsed]
, [HairLossSpot]
, [GeographyKey]
, [LeadPostalCode]
, [EthnicityKey]
, [LeadEthnicity]
, [GenderKey]
, [LeadGender]
, [CenterKey]
, [CenterNumber]
, [LanguageKey]
, [LeadLanguage]
, [StatusKey]
, [LeadStatus]
, [LeadCreatedDate]
, [CreatedDateKey]
, [CreatedTimeKey]
, [LeadLastActivityDate]
, [LastActivityDateKey]
, [LastActivityTimekey]
, [DISCStyle]
, [LeadMaritalStatus]
, [LeadConsultReady]
, [ConsultationFormReady]
, [IsDeleted]
, [DoNotCall]
, [DoNotContact]
, [DoNotEmail]
, [DoNotMail]
, [DoNotText]
, [CreateUser]
, [UpdateUser]
, [City]
, [State]
, [MaritalStatusKey]
, [LeadSource]
, [SourceKey]
, [OriginalCommMethodkey]
, [RecentCommMethodKey]
, [CommunicationMethod]
, [IsValidLeadName]
, [IsValidLeadLastName]
, [IsValidLeadFullName]
, [IsValidLeadPhone]
, [IsValidLeadMobilePhone]
, [IsValidLeadEmail]
, [ReviewNeeded]
, [ConvertedContactId]
, [ConvertedAccountId]
, [ConvertedOpportunityId]
, [ConvertedDate]
, [LastModifiedDate]
, [SourceSystem]
, [DWH_CreatedDate]
, [DWH_LastUpdateDate]
, [LeadExternalID]
, [ServiceTerritoryID]
, [OriginalCampaignId]
, [OriginalCampaignKey]
, [AccountID]
, [LeadOccupation]
, [OriginalCampaignSource]
, [GCLID]
, [RealCreatedDate]
  FROM [dbo].[FactLeadTracking]
  WHERE [LeadFirstName] = 'Joe'
  AND [LeadLastname] = 'ROberts'
  
SELECT TOP 100
       [f].[OriginalCampaignId]
     , [f].[OriginalCampaignKey]
     , [f].[OriginalCampaignSource]
     , [d].[CampaignKey]
     , [d].[CampaignId]

SELECT
    [f].[CreatedDateKey]
  , [f].[OriginalCampaignKey]
  , [f].[OriginalCampaignSource]
  , [f].[LeadFirstName]
  , [f].[LeadLastname]
  , [f].[LeadPhone]
  , [f].[LeadMobilePhone]
  , [d].[CampaignKey]
  , [d].[CampaignId]
FROM [dbo].[FactLeadTracking] AS [f]
INNER JOIN [dbo].[DimCampaign] AS [d] ON [d].[SourceCode] = [f].[OriginalCampaignSource]
WHERE ISNULL([f].[OriginalCampaignKey], -2) <> [d].[CampaignKey] AND ( [f].[OriginalCampaignKey] IS NULL OR [f].[OriginalCampaignKey] = -1 )
ORDER BY [f].[CreatedDateKey] DESC
       , [f].[OriginalCampaignSource] ;

	 SELECT [CampaignSource], COUNT(1) AS Cnt FROM [dbo].[DimCampaign]
	 GROUP BY [CampaignSource] HAVING COUNT(1) > 1
	 ORDER BY COUNT(1) DESC
     

	 SELECT * FROM [dbo].[DimCampaign] WHERE sourcecode = 'BRTVNBRRVID00011288DP'

	 SELECT TOP 100 * FROM [ODS].[SF_Campaign] WHERE [SourceCode_L__c] = 'BRTVNBRRVID00011288DP'

	 SELECT * FROM [dbo].[DimCampaign] WHERE campaignid = '7015e000000AdXIAA0'

SELECT *FROM [dbo].[DimLead] d

SELECT
    [f].[CreatedDateKey]
  , [f].[OriginalCampaignKey]
  , [f].[OriginalCampaignSource]
  , [f].[LeadFirstName]
  , [f].[LeadLastname]
  , [f].[LeadPhone]
  , [f].[LeadMobilePhone]
  , [d].[CampaignKey]
  , [d].[CampaignId]
FROM [dbo].[DimLead] AS [f]
INNER JOIN [dbo].[DimCampaign] AS [d] ON [d].[SourceCode] = [f].[OriginalCampaignSource]
WHERE ISNULL([f].[OriginalCampaignKey], -2) <> [d].[CampaignKey] AND ( [f].[OriginalCampaignKey] IS NULL OR [f].[OriginalCampaignKey] = -1 )
ORDER BY [f].[CreatedDateKey] DESC
       , [f].[OriginalCampaignSource] ;

SELECT campaig FROM [dbo].[DimLead]