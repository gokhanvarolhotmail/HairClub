/* CreateDate: 08/10/2020 15:15:03.377 , ModifyDate: 08/10/2020 15:15:03.377 */
GO
/***********************************************************************
PROCEDURE:				spRpt_MediaBuyerSourceCodeExportwithOwnerType
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/5/2018
DESCRIPTION:			4/5/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_MediaBuyerSourceCodeExportwithOwnerType
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_MediaBuyerSourceCodeExportwithOwnerType]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


CREATE TABLE #Campaign (
	[SourceCodeID] NVARCHAR(18)
,	[SourceCode] NVARCHAR(50)
,	[Creative] NVARCHAR(50)
)

CREATE TABLE #SourceCode (
	RowID INT IDENTITY(1, 1)
,	[SourceCodeID] NVARCHAR(18)
,	[CampaignName] NVARCHAR(80)
,	[CampaignType] NVARCHAR(50)
,	[SourceCode] NVARCHAR(50)
,	[DPNCode] NVARCHAR(50)
,	[DWFCode] NVARCHAR(50)
,	[DWCCode] NVARCHAR(50)
,	[MPNCode] NVARCHAR(50)
,	[MWFCode] NVARCHAR(50)
,	[MWCCode] NVARCHAR(50)
,	[Channel] NVARCHAR(50)
,	[Origin] NVARCHAR(50)
,	[Type] NVARCHAR(50)
,	[Gender] NVARCHAR(50)
,	[Goal] NVARCHAR(50)
,	[Media] NVARCHAR(50)
,	[Location] NVARCHAR(50)
,	[Language] NVARCHAR(50)
,	[Format] NVARCHAR(50)
,	[Creative] NVARCHAR(50)
,	[Number] NVARCHAR(50)
,	[DNIS] NVARCHAR(50)
,	[OwnerType] NVARCHAR(50)
,	[PromoCode] NVARCHAR(50)
,	[PromoCodeDescription] NVARCHAR(500)
,	[StartDate] DATETIME
,	[EndDate] DATETIME
,	[Status] NVARCHAR(50)
,	[IsActive] BIT
,	[CreatedDate] DATETIME
,	[LastModifiedDate] DATETIME
)

CREATE TABLE #DuplicateSource (
	[SourceCode] NVARCHAR(50)
)

CREATE TABLE #CleanupSource (
	[RowID] INT
,	[SourceCodeRowID] INT
,	[SourceCodeID] NVARCHAR(18)
,	[CampaignName] NVARCHAR(80)
,	[CampaignType] NVARCHAR(50)
,	[SourceCode] NVARCHAR(50)
,	[DPNCode] NVARCHAR(50)
,	[DWFCode] NVARCHAR(50)
,	[DWCCode] NVARCHAR(50)
,	[MPNCode] NVARCHAR(50)
,	[MWFCode] NVARCHAR(50)
,	[MWCCode] NVARCHAR(50)
,	[Channel] NVARCHAR(50)
,	[Origin] NVARCHAR(50)
,	[Type] NVARCHAR(50)
,	[Gender] NVARCHAR(50)
,	[Goal] NVARCHAR(50)
,	[Media] NVARCHAR(50)
,	[Location] NVARCHAR(50)
,	[Language] NVARCHAR(50)
,	[Format] NVARCHAR(50)
,	[Creative] NVARCHAR(50)
,	[Number] NVARCHAR(50)
,	[DNIS] NVARCHAR(50)
,	[OwnerType] NVARCHAR(50)
,	[PromoCode] NVARCHAR(50)
,	[PromoCodeDescription] NVARCHAR(500)
,	[StartDate] DATETIME
,	[EndDate] DATETIME
,	[Status] NVARCHAR(50)
,	[IsActive] BIT
,	[CreatedDate] DATETIME
,	[LastModifiedDate] DATETIME
)


INSERT  INTO #Campaign
        SELECT  c.Id
		,		c.SourceCode_L__c
		,		NULL AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.IsDeleted = 0

        UNION

        SELECT  c.Id
		,		c.DPNCode__c
		,		'Desktop Phone' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	( c.DPNCode__c IS NOT NULL
					AND c.DPNCode__c <> c.SourceCode_L__c )
				AND c.IsDeleted = 0

        UNION

        SELECT  c.Id
		,		c.DWFCode__c
		,		'Desktop Form' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
        WHERE	c.DWFCode__c IS NOT NULL
				AND c.IsDeleted = 0

		UNION

        SELECT  c.Id
		,		c.DWCCode__c
		,		'Desktop Chat' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.DWCCode__c IS NOT NULL
				AND c.IsDeleted = 0

        UNION

        SELECT  c.Id
		,		c.MPNCode__c
		,		'Mobile Phone' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MPNCode__c IS NOT NULL
				AND c.IsDeleted = 0

        UNION

        SELECT  c.Id
		,		c.MWFCode__c
		,		'Mobile Form' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MWFCode__c IS NOT NULL
				AND c.IsDeleted = 0

        UNION

        SELECT  c.Id
		,		c.MWCCode__c
		,		'Mobile Chat' AS 'Creative'
        FROM    HC_BI_SFDC.dbo.Campaign c
		WHERE	c.MWCCode__c IS NOT NULL
				AND c.IsDeleted = 0


DELETE FROM #Campaign WHERE SourceCodeID IN ( '701f4000000U71nAAC', '701f4000000U71mAAC' )


INSERT	INTO #SourceCode
		SELECT  c.SourceCodeID
		,		(SELECT Name FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignName'
		,		(SELECT CampaignType__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignType'
		,		c.SourceCode
		,		(SELECT DPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DPNCode'
		,		(SELECT DWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWFCode'
		,		(SELECT DWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWCCode'
		,		(SELECT MPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MPNCode'
		,		(SELECT MWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWFCode'
		,		(SELECT MWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWCCode'
		,		(SELECT Channel__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Channel'
		,		(SELECT Source__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Origin'
		,		(SELECT Type FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Type'
		,		(SELECT Gender__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Gender'
		,		(SELECT Goal__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Goal'
		,		(SELECT Media__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Media'
		,		(SELECT Location__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Location'
		,		(SELECT Language__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Language'
		,		(SELECT Format__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Format'
		,		c.Creative
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN '(' + LEFT(TollFreeMobileName__c, 3) + ') ' + SUBSTRING(TollFreeMobileName__c, 4, 3) + '-' + SUBSTRING(TollFreeMobileName__c, 7, 4) ELSE CASE WHEN c.SourceCode = DPNCode__c THEN '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) ELSE '' END END ELSE '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'Number'
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN DNISMobile__c ELSE CASE WHEN c.SourceCode = DPNCode__c THEN DNIS__c ELSE '' END END ELSE DNIS__c END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'DNIS'
		,		(SELECT Type FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'OwnerType'
		,		(SELECT PromoCodeName__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCode'
		,		(SELECT PromoCodeDisplay__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCodeDescription'
		,		(SELECT StartDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'StartDate'
		,		(SELECT EndDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'EndDate'
		,		(SELECT Status FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Status'
		,		(SELECT IsActive FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsActive'
		,		(SELECT CreatedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CreatedDate'
		,		(SELECT LastModifiedDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'LastModifiedDate'
		FROM    #Campaign c
		ORDER BY c.SourceCodeID
		,		c.SourceCode


-- Get Duplicate Source Codes
INSERT	INTO #DuplicateSource
		SELECT  sc.SourceCode
		FROM    #SourceCode sc
		GROUP BY sc.SourceCode
		HAVING  COUNT(*) > 1


-- Remove Inactive Duplicate Source Codes
INSERT	INTO #CleanupSource
		SELECT  ROW_NUMBER() OVER ( PARTITION BY sc.SourceCode ORDER BY sc.IsActive DESC, sc.DPNCode DESC, sc.DWFCode DESC, sc.DWCCode DESC, sc.MPNCode DESC, sc.MWFCode DESC, sc.MWCCode DESC, sc.Number DESC, sc.StartDate DESC, sc.EndDate DESC, sc.CreatedDate ASC ) AS 'RowID'
		,		sc.RowID
		,		sc.SourceCodeID
		,		sc.CampaignName
		,		sc.CampaignType
		,		sc.SourceCode
		,		sc.DPNCode
		,		sc.DWFCode
		,		sc.DWCCode
		,		sc.MPNCode
		,		sc.MWFCode
		,		sc.MWCCode
		,		sc.Channel
		,		sc.Origin
		,		sc.Type
		,		sc.Gender
		,		sc.Goal
		,		sc.Media
		,		sc.Location
		,		sc.Language
		,		sc.Format
		,		sc.Creative
		,		sc.Number
		,		sc.DNIS
		,		sc.OwnerType
		,		sc.PromoCode
		,		sc.PromoCodeDescription
		,		sc.StartDate
		,		sc.EndDate
		,		sc.Status
		,		sc.IsActive
		,		sc.CreatedDate
		,		sc.LastModifiedDate
		FROM    #SourceCode sc
				INNER JOIN #DuplicateSource ds
					ON ds.SourceCode = sc.SourceCode
		ORDER BY sc.SourceCode


-- Cleanup Duplicates
DELETE  sc
FROM    #SourceCode sc
        CROSS APPLY ( SELECT    *
                      FROM      #CleanupSource cs
                      WHERE     cs.SourceCodeID = sc.SourceCodeID
                                AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
                                AND cs.Status = 'Merged'
                    ) x_Cs


DELETE  sc
FROM    #SourceCode sc
        CROSS APPLY ( SELECT    *
                      FROM      #CleanupSource cs
                      WHERE     cs.SourceCodeID = sc.SourceCodeID
                                AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
                                AND cs.Status = 'Completed'
                    ) x_Cs


SELECT  sc.SourceCodeID
,       sc.SourceCode
,       sc.CampaignName AS 'SourceName'
,       sc.CampaignName AS 'Description'
,       sc.Number
,       '' AS 'NumberType'
,       sc.Media
,       sc.Location
,       sc.Language
,       sc.Format
,       sc.Creative
,       sc.StartDate
,       sc.EndDate
,       sc.CreatedDate AS 'CreationDate'
,       sc.LastModifiedDate AS 'LastUpdateDate'
,		sc.IsActive
,		sc.Channel
,		sc.Origin
,		sc.PromoCode
,		sc.CampaignType
,		sc.OwnerType
FROM    #SourceCode sc
WHERE SC.OwnerType = 'HAVAS'
ORDER BY MEDIA
END
GO
