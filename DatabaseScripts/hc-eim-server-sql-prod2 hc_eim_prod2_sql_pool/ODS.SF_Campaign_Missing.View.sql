/****** Object:  View [ODS].[SF_Campaign_Missing]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[SF_Campaign_Missing]
AS SELECT *
FROM [ODS].[SF_Campaign] AS [s]
WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[DimCampaign] AS [d] WHERE [d].[CampaignId] = [s].[Id] );
GO
