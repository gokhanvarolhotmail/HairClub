/****** Object:  View [ODS].[SF_Campaign_Missing]    Script Date: 3/4/2022 8:28:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[SF_Campaign_Missing]
AS SELECT *
FROM [ODS].[SF_Campaign] AS [s]
WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[DimCampaign] AS [d] WHERE [d].[CampaignId] = [s].[Id] );
GO
