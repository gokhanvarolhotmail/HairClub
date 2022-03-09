/****** Object:  View [dbo].[VWLead_20220302_GVAROL]    Script Date: 3/9/2022 8:40:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWLead_20220302_GVAROL]
AS WITH [dimLead_CTE]
AS (
   SELECT
       [a].[LeadKey]
     , [a].[LeadCreatedDate] AS [LeadCreatedDateUTC]
     , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) AS [LeadCreatedDateEST]
     , [a].[CreatedDateKey]
     , [a].[LeadId]
     , [a].[LeadFirstName] AS [LeadName]
     , [a].[LeadLastname] AS [LeadLastName]
     , [a].[LeadFullName] AS [LeadFullName]
     , [a].[LeadEmail]
     , [a].[LeadPhone]
     , [a].[LeadMobilePhone]
     , [a].[OriginalCampaignKey]
     , ISNULL([a].[GeographyKey], -1) AS [geographykey]
     , ISNULL([a].[CenterKey], -1) AS [centerkey]
     , [a].[LeadCreatedDate]
     , [a].[LeadFirstName]
     , [a].[LeadLastActivityDate]
     , [a].[IsActive]
     , [a].[Isvalid]
     , [a].[IsDeleted]
     , [a].[IsConsultFormComplete]
     , [a].[LeadStatus]
     , [a].[SourceKey]
     , [a].[OriginalCommMethodkey]
     , [a].[LeadSource]
     , [a].[CreateUser]
     , [a].[LeadExternalID]
     , [a].[LastActivityDateKey]
     , [a].[LeadBirthday]
     , DATEDIFF(YEAR, [a].[LeadBirthday], GETDATE()) AS [Age]
     , [a].[GCLID]
     , [a].[LeadLanguage]
     , [a].[LeadGender]
     , [a].[LeadEthnicity]
     , [a].[NorwoodScale]
     , [a].[LudwigScale]
     , [a].[LeadMaritalStatus]
     , [a].[LeadOccupation]
     , [a].[DoNotContact]
     , [a].[DoNotCall]
     , [a].[DoNotText]
     , [a].[DoNotEmail]
     , [a].[DoNotMail]
     , [a].[OriginalCampaignId]
     , [a].[ConvertedAccountId]
     , [a].[LeadPostalCode]
     , [a].[IsDuplicateByEmail]
     , [a].[IsDuplicateByName]
     , [a].[AccountID]
   FROM [dbo].[DimLead] AS [a]
   WHERE DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) >= CONVERT(
                                                                                                                                               DATE
                                                                                                                                               , DATEADD(
                                                                                                                                                d
                                                                                                                                                , -( DAY(
                                                                                                                                                    GETDATE()
                                                                                                                                                    - 1))
                                                                                                                                                , GETDATE())
                                                                                                                                               , 106)
   UNION ALL
   SELECT
       [a].[LeadKey]
     , [a].[LeadCreatedDate] AS [LeadCreatedDateUTC]
     , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) AS [LeadCreatedDateEST]
     , [a].[CreatedDateKey]
     , [a].[LeadId]
     , [a].[LeadFirstName] AS [LeadName]
     , [a].[LeadLastname] AS [LeadLastName]
     , [a].[LeadFullName] AS [LeadFullName]
     , [a].[LeadEmail]
     , [a].[LeadPhone]
     , [a].[LeadMobilePhone]
     , [a].[OriginalCampaignKey]
     , ISNULL([a].[GeographyKey], -1) AS [geographykey]
     , ISNULL([a].[CenterKey], -1) AS [centerkey]
     , [a].[LeadCreatedDate]
     , [a].[LeadFirstName]
     , [a].[LeadLastActivityDate]
     , [a].[IsActive]
     , [a].[Isvalid]
     , [a].[IsDeleted]
     , [a].[IsConsultFormComplete]
     , [a].[LeadStatus]
     , [a].[SourceKey]
     , [a].[OriginalCommMethodkey]
     , [a].[LeadSource]
     , [a].[CreateUser]
     , [a].[LeadExternalID]
     , [a].[LastActivityDateKey]
     , [a].[LeadBirthday]
     , DATEDIFF(YEAR, [a].[LeadBirthday], GETDATE()) AS [Age]
     , [a].[GCLID]
     , [a].[LeadLanguage]
     , [a].[LeadGender]
     , [a].[LeadEthnicity]
     , [a].[NorwoodScale]
     , [a].[LudwigScale]
     , [a].[LeadMaritalStatus]
     , [a].[LeadOccupation]
     , [a].[DoNotContact]
     , [a].[DoNotCall]
     , [a].[DoNotText]
     , [a].[DoNotEmail]
     , [a].[DoNotMail]
     , [a].[OriginalCampaignId]
     , [a].[ConvertedAccountId]
     , [a].[LeadPostalCode]
     , 0
     , 0
     , [a].[AccountID]
   FROM [dbo].[FactLeadTracking] AS [a]
   WHERE DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) < CONVERT(
                                                                                                                                              DATE
                                                                                                                                              , DATEADD(
                                                                                                                                               d
                                                                                                                                               , -( DAY(
                                                                                                                                                   GETDATE()
                                                                                                                                                   - 1))
                                                                                                                                               , GETDATE())
                                                                                                                                              , 106))
SELECT
    [a].[LeadKey]
  , [a].[LeadCreatedDate] AS [LeadCreatedDateUTC]
  , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [a].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [a].[LeadCreatedDate]) AS [LeadCreatedDateEST]
  , [a].[CreatedDateKey] AS [createdDateKey]
  , [a].[LeadId]
  , [a].[LeadFirstName] AS [LeadName]
  , [a].[LeadLastName] AS [LeadLastName]
  , [a].[LeadFullName] AS [LeadFullName]
  , [a].[LeadEmail]
  , [a].[LeadPhone]
  , [a].[LeadMobilePhone] AS [LeadMobilephone]
  , [a].[LeadBirthday]
  , DATEDIFF(YEAR, [a].[LeadBirthday], GETDATE()) AS [Age]
  , [k].[CenterKey] AS [Centerkey]
  , [k].[CenterID]
  , [k].[CenterPayGroupID]
  , [k].[CenterDescription]
  , [k].[Address1]
  , [k].[Address2]
  , [k].[Address3]
  , [k].[CenterGeographykey]
  , [k].[CenterPostalCode]
  , [k].[CenterPhone1]
  , [k].[CenterPhone2]
  , [k].[CenterPhone3]
  , [k].[Phone1TypeID]
  , [k].[Phone2TypeID]
  , [k].[Phone3TypeID]
  , [k].[IsActiveFlag]
  , [k].[CreateDate]
  , [k].[LastUpdate]
  , [k].[UpdateStamp]
  , [k].[CenterNumber]
  , [k].[CenterOwnershipID]
  , [k].[CenterOwnershipSortOrder]
  , [k].[CenterOwnershipDescription]
  , [k].[CenterOwnershipDescriptionShort]
  , [k].[OwnerLastName]
  , [k].[OwnerFirstName]
  , [k].[CorporateName]
  , [k].[OwnershipAddress1]
  , [k].[CenterTypeID]
  , [k].[CenterTypeSortOrder]
  , [k].[CenterTypeDescription]
  , [k].[CenterTypeDescriptionShort]
  , ISNULL([b].[CampaignKey], -1) AS [OriginalCampaignKey]
  , [b].[CampaignName] AS [OriginalCampaignName]
  , [b].[SourceCode] AS [Originalsourcecode]
  , [b].[CampaignType] AS [OriginalCampaignType]
  , [b].[CampaignMedia] AS [OriginalCampaignMedia]
  , [b].[CampaignSource] AS [OriginalCampaignOrigin]
  , [b].[CampaignLocation] AS [OriginalcampaignLocation]
  , '' AS [OriginalCampaignFormat]
  , [a].[LeadLastActivityDate]
  , [a].[LastActivityDateKey]
  , [e].[Country] AS [LeadCountry]
  , [cg].[Country] AS [CenterCountry]
  , [cg].[DMADescription]
  , [cg].[DMACode]
  , [cg].[DMAMarketRegion]
  , [cg].[GeographyKey] AS [Geographykey]
  , [e].[NameOfCityOrORG] AS [LeadCity]
  , [e].[FullNameOfStateOrTerritory] AS [LeadState]
  , [a].[IsActive] AS [Isactive]
  , [a].[Isvalid]
  , [a].[IsConsultFormComplete]
  , [a].[LeadStatus]
  , [a].[IsDeleted]
  , ISNULL([Ag].[AgencyKey], -1) AS [Agencykey]
  , [Ag].[AgencyName]
  , ISNULL([a].[SourceKey], -1) AS [SourceKey]
  , [sc].[SourceName]
  , ISNULL([a].[OriginalCommMethodkey], -1) AS [OriginalComMethodKey]
  , CASE WHEN LOWER([b].[CampaignName]) LIKE '%leads-ads%' THEN 'Facebook'
        WHEN LOWER([b].[CampaignName]) LIKE '%gleam%' THEN 'Gleam Form'
        WHEN [b].[SourceCode] LIKE 'DGEMAECOMECOM14000%' THEN 'Shopify'
        WHEN LOWER([sc].[SourceName]) IN ('call', 'phone', 'call center') THEN 'Phone Call'
        WHEN LOWER([sc].[SourceName]) IN ('bosref', 'other-bos') THEN 'Bosley API'
        WHEN [b].[SourceCode] LIKE 'DGPDSFACEIMAD14097%' THEN 'Facebook Messenger'
        WHEN LOWER([sc].[SourceName]) IN ('web form')
         AND [b].[SourceCode] NOT LIKE 'DGEMAECOMECOM14000%'
         AND LOWER([b].[CampaignName])NOT LIKE '%leads-ads%'
         AND LOWER([b].[CampaignName])NOT LIKE '%gleam%' THEN 'Appt Form'
        WHEN ( [a].[LeadSource] IS NULL AND LOWER([a].[CreateUser]) = 'bosleyintegration@hairclub.com' ) OR [sc].[SourceName] = 'Bosref' THEN 'Bosley API'
        WHEN LOWER([sc].[SourceName]) IN ('web chat', 'hairbot', 'hairclub app') THEN [sc].[SourceName]
        ELSE 'Other'
    END AS [MarketingSource]
  , [a].[LeadExternalID] AS [LeadExternalId]
  , [a].[GCLID]
  , [a].[LeadLanguage]
  , [a].[LeadGender]
  , [a].[LeadEthnicity]
  , [a].[NorwoodScale]
  , [a].[LudwigScale]
  , [a].[LeadMaritalStatus]
  , [a].[LeadOccupation]
  , [a].[DoNotContact]
  , [a].[DoNotCall]
  , [a].[DoNotText]
  , [a].[DoNotEmail]
  , [a].[DoNotMail]
  , [a].[OriginalCampaignId]
  , [a].[ConvertedAccountId] AS [convertedaccountid]
  , [a].[LeadPostalCode]
  , [a].[LeadSource]
  , [a].[LeadFirstName]
  , [dt].[TimeOfDayKey] AS [TimeOfDayESTKey]
  , [a].[IsDuplicateByEmail] AS [isduplicatebyemail]
  , [a].[IsDuplicateByName] AS [isduplicatebyname]
  , ISNULL([a].[LeadId], [d].[AccountExternalId]) AS [LeadIdExternal]
  , [a].[LeadExternalID] AS [RealExternalId]
FROM [dimLead_CTE] AS [a]
LEFT JOIN [dbo].[DimCampaign] AS [b] ON [a].[OriginalCampaignKey] = [b].[CampaignKey]
--left join dimdate d on a.lead_createddate=d.datekey
LEFT JOIN [dbo].[DimGeography] AS [e] ON [a].[geographykey] = [e].[GeographyKey]
LEFT JOIN [dbo].[DimCenter] AS [k] ON [a].[centerkey] = [k].[CenterKey]
LEFT JOIN [dbo].[DimGeography] AS [cg] ON [k].[CenterGeographykey] = [cg].[GeographyKey]
LEFT JOIN [dbo].[DimAgency] AS [Ag] ON [b].[AgencyKey] = [Ag].[AgencyKey]
LEFT JOIN [dbo].[DimSource] AS [sc] ON [a].[SourceKey] = [sc].[SourceKey]
LEFT JOIN [dbo].[DimTimeOfDay] AS [dt] ON [dt].[Time24] = CONVERT(TIME, [a].[LeadCreatedDateEST])
LEFT JOIN [dbo].[DimAccount] AS [d] ON [a].[AccountID] = [d].[AccountId];
GO
