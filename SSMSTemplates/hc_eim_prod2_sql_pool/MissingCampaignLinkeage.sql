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

GO
RETURN
UPDATE f SET [f].[OriginalCampaignKey] = [d].[CampaignKey], [f].[OriginalCampaignId] = d.[CampaignId]
FROM [dbo].[FactLeadTracking] AS [f]
INNER JOIN [dbo].[DimCampaign] AS [d] ON [d].[SourceCode] = [f].[OriginalCampaignSource]
WHERE ISNULL([f].[OriginalCampaignKey], -2) <> [d].[CampaignKey] AND ( [f].[OriginalCampaignKey] IS NULL OR [f].[OriginalCampaignKey] = -1 )

UPDATE f SET [f].[OriginalCampaignKey] = [d].[CampaignKey], [f].[OriginalCampaignId] = d.[CampaignId]
FROM [dbo].[DimLead] AS [f]
INNER JOIN [dbo].[DimCampaign] AS [d] ON [d].[SourceCode] = [f].[OriginalCampaignSource]
WHERE ISNULL([f].[OriginalCampaignKey], -2) <> [d].[CampaignKey] AND ( [f].[OriginalCampaignKey] IS NULL OR [f].[OriginalCampaignKey] = -1 )