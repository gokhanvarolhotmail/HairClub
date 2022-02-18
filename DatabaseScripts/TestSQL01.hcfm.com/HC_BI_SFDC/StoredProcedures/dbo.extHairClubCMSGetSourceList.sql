/* CreateDate: 07/31/2019 11:23:02.453 , ModifyDate: 04/24/2020 13:15:38.707 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSGetSourceList
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/31/2019
DESCRIPTION:			7/31/2019
------------------------------------------------------------------------
NOTES:

	04/24/2020	KMurdoch	Changed final select to act the same for both HairClub & HW. Inhouse lead creation was not showing any source codes for HW
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSGetSourceList 'HAIRCLUB', 0
EXEC extHairClubCMSGetSourceList 'HAIRCLUB', 1
EXEC extHairClubCMSGetSourceList 'HW', 0
EXEC extHairClubCMSGetSourceList 'HW', 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSGetSourceList]
(
	@BusinessUnitBrandDescriptionShort NVARCHAR(10),
	@IsInHouseLead BIT = 0
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


CREATE TABLE #Campaign (
	SourceCodeID NVARCHAR(18)
,	SourceCode NVARCHAR(50)
,	Creative NVARCHAR(50)
)

CREATE TABLE #SourceCode (
	RowID INT IDENTITY(1, 1)
,	SourceCodeID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	ACEDescription NVARCHAR(255)
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Type NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	Media NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
,	IsInHouse BIT
,	IsHansWiemann BIT
,	IsActive BIT
,	CreatedDate DATETIME
,	LastModifiedDate DATETIME
)

CREATE TABLE #DuplicateSource (
	SourceCode NVARCHAR(50)
)

CREATE TABLE #CleanupSource (
	RowID INT
,	SourceCodeRowID INT
,	SourceCodeID NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	ACEDescription NVARCHAR(255)
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Type NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	Media NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
,	IsInHouse BIT
,	IsHansWiemann BIT
,	IsActive BIT
,	CreatedDate DATETIME
,	LastModifiedDate DATETIME
)

CREATE TABLE #Final (
	SourceCode NVARCHAR(50)
,	ACEDescription NVARCHAR(255)
,	IsInHouse BIT
,	IsHansWiemann BIT
,	Type NVARCHAR(50)
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


INSERT	INTO #SourceCode
		SELECT  c.SourceCodeID
		,		(SELECT Name FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignName'
		,		(SELECT CampaignType__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CampaignType'
		,		(SELECT ACE_Decription__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'ACEDescription'
		,		c.SourceCode
		,		(SELECT DPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DPNCode'
		,		(SELECT DWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWFCode'
		,		(SELECT DWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'DWCCode'
		,		(SELECT MPNCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MPNCode'
		,		(SELECT MWFCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWFCode'
		,		(SELECT MWCCode__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'MWCCode'
		,		(SELECT Channel__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Channel'
		,		(SELECT CASE WHEN Type = 'Hans Wiemann' THEN 'HW' ELSE 'HAIRCLUB' END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Type'
		,		(SELECT Gender__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Gender'
		,		(SELECT Goal__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Goal'
		,		(SELECT Media__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Media'
		,		(SELECT Location__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Location'
		,		(SELECT Language__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Language'
		,		(SELECT Format__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Format'
		,		c.Creative
		,		(SELECT ISNULL(CommunicationType__c, '') FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'CommunicationType'
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN '(' + LEFT(TollFreeMobileName__c, 3) + ') ' + SUBSTRING(TollFreeMobileName__c, 4, 3) + '-' + SUBSTRING(TollFreeMobileName__c, 7, 4) ELSE CASE WHEN c.SourceCode = DPNCode__c THEN '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) ELSE '' END END ELSE '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'Number'
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN DNISMobile__c ELSE CASE WHEN c.SourceCode = DPNCode__c THEN DNIS__c ELSE '' END END ELSE DNIS__c END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'DNIS'
		,		(SELECT PromoCodeName__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCode'
		,		(SELECT PromoCodeDisplay__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'PromoCodeDescription'
		,		(SELECT StartDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'StartDate'
		,		(SELECT EndDate FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'EndDate'
		,		(SELECT Status FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Status'
		,		(SELECT REPLACE(REPLACE(REPLACE(ISNULL(IsInHouseSourceFlag_L__c, '0'), 'NULL', '0'), 'N', '0'), 'Y', '1') FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsInHouse'
		,		(SELECT CASE WHEN ( Type = 'Hans Wiemann' OR IsInHouseSourceFlag_L__c = 'Y' ) THEN 1 ELSE 0 END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsHansWiemann'
		,		(SELECT ISNULL(IsActive, 0) FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'IsActive'
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
		,		sc.ACEDescription
		,		sc.SourceCode
		,		sc.DPNCode
		,		sc.DWFCode
		,		sc.DWCCode
		,		sc.MPNCode
		,		sc.MWFCode
		,		sc.MWCCode
		,		sc.Channel
		,		sc.Type
		,		sc.Gender
		,		sc.Goal
		,		sc.Media
		,		sc.Location
		,		sc.Language
		,		sc.Format
		,		sc.Creative
		,		sc.CommunicationType
		,		sc.Number
		,		sc.DNIS
		,		sc.PromoCode
		,		sc.PromoCodeDescription
		,		sc.StartDate
		,		sc.EndDate
		,		sc.Status
		,		sc.IsInHouse
		,		sc.IsHansWiemann
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


-- Get Final Dataset
INSERT	INTO #Final
		SELECT	sc.SourceCode AS 'ID'
		,		ISNULL(sc.ACEDescription, sc.SourceCode) AS 'Description'
		,		sc.IsInHouse
		,		sc.IsHansWiemann
		,		sc.Type
		FROM	#SourceCode sc
		WHERE	( sc.EndDate >= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))
					AND ISNULL(sc.IsActive, 0) = 1 )
				AND ( ( @IsInHouseLead = 0 AND sc.IsInHouse = 0 )
						OR ( @IsInHouseLead = 1 AND sc.IsInHouse = 1 ) )
				AND sc.SourceCode NOT IN ( '!INVALID', '!TEST SOURCE', '!TEST SOURCE FR', '!TEST SOURCE SP', 'HWTest' )
		ORDER BY sc.SourceCode


-- Return Data
SELECT	f.SourceCode AS 'ID'
,		ISNULL(f.ACEDescription, f.SourceCode) AS 'Description'
FROM	#Final f
--WHERE	f.Type = @BusinessUnitBrandDescriptionShort
WHERE F.TYPE = 'HAIRCLUB'
ORDER BY f.SourceCode

END
GO
