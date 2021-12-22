/***********************************************************************
PROCEDURE:				spDB_PopulateYOYLASSDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/17/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateYOYLASSDashboard
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateYOYLASSDashboard]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Today DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME
,		@CurrentYearStart DATETIME
,		@CurrentYearEnd DATETIME
,		@PreviousYearStart DATETIME
,		@PreviousYearEnd DATETIME
,		@MinDate DATETIME
,		@MaxDate DATETIME


SET @Today = CAST(DATEADD(DAY, 0, CURRENT_TIMESTAMP) AS DATE)
SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Today), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @Today)) +1, 0))
SET @CurrentYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)
SET @CurrentYearEnd = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @Today), 0)))
SET @PreviousYearEnd = DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0))
SET @PreviousYearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, @PreviousYearEnd), 0)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Date (
	DateKey INT
,	FullDate DATETIME
,	YearNumber INT
,	MonthNumber INT
,	MonthName CHAR(10)
,	DayOfMonth INT
,	FirstDateOfMonth DATETIME
)

CREATE TABLE #Center (
	Area VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

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
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	OwnerType NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	BudgetedCost MONEY
,	ActualCost MONEY
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
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
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	Channel NVARCHAR(50)
,	OwnerType NVARCHAR(50)
,	Gender NVARCHAR(50)
,	Goal NVARCHAR(50)
,	BudgetedCost MONEY
,	ActualCost MONEY
,	Media NVARCHAR(50)
,	Origin NVARCHAR(50)
,	Location NVARCHAR(50)
,	Language NVARCHAR(50)
,	Format NVARCHAR(50)
,	Creative NVARCHAR(50)
,	Number NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	PromoCode NVARCHAR(50)
,	PromoCodeDescription NVARCHAR(500)
,	StartDate DATETIME
,	EndDate DATETIME
,	Status NVARCHAR(50)
,	IsActive BIT
,	CreatedDate DATETIME
,	LastModifiedDate DATETIME
)

CREATE TABLE #Lead (
	Period DATETIME
,	CreationDate DATETIME
,	Id NVARCHAR(18)
,	CenterKey INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(80)
,	Age NVARCHAR(50)
,	AgeRange NVARCHAR(50)
,	Birthday DATETIME
,	Gender NVARCHAR(50)
,	Language NVARCHAR(50)
,	Ethnicity NVARCHAR(100)
,	MaritalStatus NVARCHAR(100)
,	Occupation NVARCHAR(100)
,	DISCStyle NVARCHAR(50)
,	NorwoodScale NVARCHAR(100)
,	LudwigScale NVARCHAR(100)
,	SolutionOffered NVARCHAR(100)
,	PriceQuoted DECIMAL(18,2)
,	NoSaleReason NVARCHAR(200)
,	SaleType NVARCHAR(50)
,	BusinessSegmentOfferedOrSold NVARCHAR(50)
,	HairLossExperience NVARCHAR(100)
,	HairLossInFamily NVARCHAR(100)
,	HairLossProductUsed NVARCHAR(100)
,	HairLossProductOther NVARCHAR(150)
,	HairLossSpot NVARCHAR(100)
,	LeadStatus NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	HCReferral INT
)

CREATE TABLE #LeadAddress (
	RowID INT
,	Id NVARCHAR(18)
,	AddressLine1 NVARCHAR(250)
,	AddressLine2 NVARCHAR(250)
,	AddressLine3 NVARCHAR(250)
,	AddressLine4 NVARCHAR(250)
,	City NVARCHAR(50)
,	StateCode NVARCHAR(50)
,	ZipCode NVARCHAR(50)
,	Country NVARCHAR(50)
)

CREATE TABLE #Task (
	Period DATETIME
,	ActivityDate DATETIME
,	Id NVARCHAR(18)
,	WhoId NVARCHAR(18)
,	CenterKey INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	Performer NVARCHAR(102)
,	SourceCode NVARCHAR(50)
,	Accommodation__c NVARCHAR(50)
,	ExcludeFromConsults INT
,	ExcludeFromBeBacks INT
)


/********************************** Get Date data *************************************/
INSERT	INTO #Date
		SELECT	dd.DateKey
		,		dd.FullDate
		,		dd.YearNumber
		,		dd.MonthNumber
		,		dd.MonthName
		,		dd.DayOfMonth
		,		dd.FirstDateOfMonth
		FROM	HC_BI_ENT_DDS.bief_dds.DimDate dd
		WHERE	dd.FullDate BETWEEN @PreviousYearStart AND @Today


CREATE NONCLUSTERED INDEX IDX_Date_DateKey ON #Date ( DateKey );
CREATE NONCLUSTERED INDEX IDX_Date_FullDate ON #Date ( FullDate );
CREATE NONCLUSTERED INDEX IDX_Date_FirstDateOfMonth ON #Date ( FirstDateOfMonth );


UPDATE STATISTICS #Date;


SELECT	@MinDate = MIN(d.FullDate)
,		@MaxDate = MAX(d.FullDate)
FROM	#Date d


/********************************** Get Center data *************************************/
INSERT	INTO #Center
		SELECT	CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionDescription ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'Area'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		CASE WHEN ct.CenterTypeDescription = 'Joint' THEN 'Joint Venture' ELSE ct.CenterTypeDescription END AS 'CenterType'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
				AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.Active = 'Y' )


CREATE NONCLUSTERED INDEX IDX_Center_CenterSSID ON #Center ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );


UPDATE STATISTICS #Center;


/********************************** Get Campaign data *************************************/
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


CREATE NONCLUSTERED INDEX IDX_Campaign_SourceCodeID ON #Campaign ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_Campaign_SourceCode ON #Campaign ( SourceCode );


UPDATE STATISTICS #Campaign;


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
		,		(SELECT Type FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'OwnerType'
		,		(SELECT Gender__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Gender'
		,		(SELECT Goal__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Goal'
		,		(SELECT BudgetedCost FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'BudgetedCost'
		,		(SELECT ActualCost FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'ActualCost'
		,		(SELECT Media__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Media'
		,		(SELECT Source__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Origin'
		,		(SELECT Location__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Location'
		,		(SELECT Language__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Language'
		,		(SELECT Format__c FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID) AS 'Format'
		,		c.Creative
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN '(' + LEFT(TollFreeMobileName__c, 3) + ') ' + SUBSTRING(TollFreeMobileName__c, 4, 3) + '-' + SUBSTRING(TollFreeMobileName__c, 7, 4) ELSE CASE WHEN c.SourceCode = DPNCode__c THEN '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) ELSE '' END END ELSE '(' + LEFT(TollFreeName__c, 3) + ') ' + SUBSTRING(TollFreeName__c, 4, 3) + '-' + SUBSTRING(TollFreeName__c, 7, 4) END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'Number'
		,		ISNULL((SELECT CASE WHEN GenerateCodes__c = 1 THEN CASE WHEN c.SourceCode = MPNCode__c THEN DNISMobile__c ELSE CASE WHEN c.SourceCode = DPNCode__c THEN DNIS__c ELSE '' END END ELSE DNIS__c END FROM HC_BI_SFDC.dbo.Campaign WHERE Id = c.SourceCodeID), '') AS 'DNIS'
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


CREATE NONCLUSTERED INDEX IDX_SourceCode_SourceCodeID ON #SourceCode ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_SourceCode_SourceCode ON #SourceCode ( SourceCode );


UPDATE STATISTICS #SourceCode;


-- Get Duplicate Source Codes
INSERT	INTO #DuplicateSource
		SELECT  sc.SourceCode
		FROM    #SourceCode sc
		GROUP BY sc.SourceCode
		HAVING  COUNT(*) > 1


CREATE NONCLUSTERED INDEX IDX_DuplicateSource_SourceCode ON #DuplicateSource ( SourceCode );


UPDATE STATISTICS #DuplicateSource;


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
		,		sc.OwnerType
		,		sc.Gender
		,		sc.Goal
		,		sc.BudgetedCost
		,		sc.ActualCost
		,		sc.Media
		,		sc.Origin
		,		sc.Location
		,		sc.Language
		,		sc.Format
		,		sc.Creative
		,		sc.Number
		,		sc.DNIS
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


CREATE NONCLUSTERED INDEX IDX_CleanupSource_SourceCodeID ON #CleanupSource ( SourceCodeID );
CREATE NONCLUSTERED INDEX IDX_CleanupSource_SourceCode ON #CleanupSource ( SourceCode );


UPDATE STATISTICS #CleanupSource;


-- Cleanup Duplicates
DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status = 'Merged'
					) x_Cs


DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status = 'Completed'
					) x_Cs



DELETE	sc
FROM	#SourceCode sc
		CROSS APPLY (
						SELECT	*
						FROM	#CleanupSource cs
						WHERE	cs.SourceCodeID = sc.SourceCodeID
								AND cs.SourceCode = sc.SourceCode
								AND cs.RowID <> 1
								AND cs.Status NOT IN ( 'Completed', 'Merged' )
					) x_Cs


/********************************** Get Lead data *************************************/
INSERT	INTO #Lead
		SELECT  d.FirstDateOfMonth
		,		d.FullDate
		,		l.Id
		,		c.CenterKey
		,		ISNULL(l.CenterNumber__c, l.CenterID__c)
		,		c.CenterDescription
		,		c.CenterType
		,		l.FirstName
		,		l.LastName
		,		ISNULL(CONVERT(VARCHAR, l.Age__c), '') AS 'Age'
		,		ISNULL(l.AgeRange__c, '') AS 'AgeRange'
		,		CAST(l.Birthday__c AS DATE) AS 'Birthday'
		,		COALESCE(o_T.LeadOncGender__c, l.Gender__c) AS 'Gender'
		,		l.Language__c AS 'Language'
		,		ISNULL(CASE WHEN o_T.LeadOncEthnicity__c IS NULL THEN l.Ethnicity__c ELSE o_T.LeadOncEthnicity__c END, '') AS 'Ethnicity'
		,		ISNULL(CASE WHEN o_T.MaritalStatus__c IS NULL THEN l.MaritalStatus__c ELSE o_T.MaritalStatus__c END, '') AS 'MaritalStatus'
		,		ISNULL(CASE WHEN o_T.Occupation__c IS NULL THEN l.Occupation__c ELSE o_T.Occupation__c END, '') AS 'Occupation'
		,		ISNULL(CASE WHEN o_T.DISC__c IS NULL THEN l.DISC__c ELSE o_T.DISC__c END, '') AS 'DISC'
		,		ISNULL(CASE WHEN o_T.NorwoodScale__c IS NULL THEN l.NorwoodScale__c ELSE o_T.NorwoodScale__c END, '') AS 'Norwood'
		,		ISNULL(CASE WHEN o_T.LudwigScale__c IS NULL THEN l.LudwigScale__c ELSE o_T.LudwigScale__c END, '') AS 'Ludwig'
		,		ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '') AS 'SolutionOffered'
		,		ISNULL(o_T.PriceQuoted__c, 0) AS 'PriceQuoted'
		,		ISNULL(o_T.NoSaleReason__c, '') AS 'NoSaleReason'
		,		ISNULL(o_T.SaleTypeDescription__c, '') AS 'SaleType'
		,		CASE ISNULL(CASE WHEN o_T.SolutionOffered__c IS NULL THEN l.SolutionOffered__c ELSE o_T.SolutionOffered__c END, '')
					WHEN 'Extreme Therapy' THEN 'Extreme Therapy'
					WHEN 'Hair' THEN 'Xtrands+'
					WHEN 'MDP' THEN 'RestorInk'
					WHEN 'Restorative' THEN 'Surgery'
					WHEN 'RestorInk' THEN 'RestorInk'
					WHEN 'Surgery' THEN 'Surgery'
					WHEN 'Xtrands' THEN 'Xtrands'
					WHEN 'Xtrands+' THEN 'Xtrands+'
					WHEN '' THEN o_T.BusinessSegment
				END AS 'BusinessSegmentOfferedOrSold'
		,		ISNULL(l.HairLossExperience__c, '') AS 'HairLossExperience'
		,		ISNULL(l.HairLossFamily__c, '') AS 'HairLossInFamily'
		,		ISNULL(l.HairLossProductUsed__c, '') AS 'HairLossProductUsed'
		,		ISNULL(l.HairLossProductOther__c, '') AS 'HairLossProductOther'
		,		ISNULL(l.HairLossSpot__c, '') AS 'HairLossSpot'
		,		CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE l.Status END AS 'LeadStatus'
		,		l.Source_Code_Legacy__c
		,		CASE WHEN l.Source_Code_Legacy__c IN ( 'CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'IPREFCLRERECA12476'
													, 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC'
													, 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
													) THEN 1
					ELSE 0
				END AS 'HCReferral'
		FROM    HC_BI_SFDC.dbo.Lead l
				INNER JOIN #Date d
					ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
				OUTER APPLY (
					SELECT	TOP 1
							t.LeadOncGender__c
					,		t.LeadOncBirthday__c
					,		t.Occupation__c
					,		t.LeadOncEthnicity__c
					,		t.MaritalStatus__c
					,		t.NorwoodScale__c
					,		t.LudwigScale__c
					,		t.LeadOncAge__c
					,		t.PriceQuoted__c
					,		t.SolutionOffered__c
					,		t.NoSaleReason__c
					,		t.DISC__c
					,		t.SaleTypeCode__c
					,		t.SaleTypeDescription__c
					,		ISNULL(st.BusinessSegment, 'Unknown') AS 'BusinessSegment'
					FROM	HC_BI_SFDC.dbo.Task t
							LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType st
								ON st.SalesTypeSSID = t.SaleTypeCode__c
					WHERE	t.WhoId = l.Id
							AND ISNULL(t.Result__c, '') IN ( 'Show Sale', 'Show No Sale' )
							AND ISNULL(t.IsDeleted, 0) = 0
					ORDER BY t.ActivityDate DESC
				) o_T -- Last Show
		WHERE   CAST(l.ReportCreateDate__c AS DATE) BETWEEN @MinDate AND @MaxDate
				AND l.Status IN ( 'Lead', 'Client', 'Prospect', 'HWClient', 'HWLead', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
				AND ISNULL(l.IsDeleted, 0) = 0
				AND ISNULL(fil.IsInvalidLead, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Lead_Period ON #Lead ( Period );
CREATE NONCLUSTERED INDEX IDX_Lead_CreationDate ON #Lead ( CreationDate );
CREATE NONCLUSTERED INDEX IDX_Lead_Id ON #Lead ( Id );
CREATE NONCLUSTERED INDEX IDX_Lead_CenterNumber ON #Lead ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Lead_SourceCode ON #Lead ( SourceCode );


UPDATE STATISTICS #Lead;


/********************************** Get Address data *************************************/
INSERT	INTO #LeadAddress
		SELECT	ROW_NUMBER() OVER ( PARTITION BY ac.Lead__c ORDER BY ac.CreatedDate DESC ) AS 'RowID'
		,		ac.Lead__c
		,		ac.Street__c
		,		ac.Street2__c
		,		ac.Street3__c
		,		ac.Street4__c
		,		ac.City__c
		,		ac.State__c
		,		ac.Zip__c
		,		ac.Country__c
		FROM	HC_BI_SFDC.dbo.Address__c ac
				INNER JOIN #Lead l
					ON l.Id = ac.Lead__c
		WHERE	ac.Primary__c = 1
				AND ISNULL(ac.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_LeadAddress_RowID ON #LeadAddress ( RowID );
CREATE NONCLUSTERED INDEX IDX_LeadAddress_Id ON #LeadAddress ( Id );


UPDATE STATISTICS #LeadAddress;


-- Remove Address Duplicates
DELETE la FROM #LeadAddress la WHERE la.RowID <> 1


/********************************** Get Task data *************************************/
INSERT	INTO #Task
		SELECT  d.FirstDateOfMonth
		,		d.FullDate
		,		t.Id
		,		t.WhoId
		,		c.CenterKey
		,		ISNULL(t.CenterNumber__c, t.CenterID__c)
		,		c.CenterDescription
		,		c.CenterType
		,		t.Action__c
		,		t.Result__c
		,		t.Performer__c
		,		t.SourceCode__c
		,		t.Accommodation__c
		,		CASE WHEN t.SourceCode__c IN ( 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSNCREF', '4Q2016LWEXLD'
											, 'REFEROTHER', 'IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP'
											, 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
											) AND t.ActivityDate < '12/1/2020' THEN 1
					ELSE 0
				END AS 'ExcludeFromConsults'
		,		CASE WHEN t.SourceCode__c IN ( 'CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSBIODMREF'
											, '4Q2016LWEXLD', 'REFEROTHER'
											) AND t.ActivityDate < '12/1/2020' THEN 1
					ELSE 0
				END AS 'ExcludeFromBeBacks'
		FROM    HC_BI_SFDC.dbo.Task t
				INNER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				INNER JOIN #Date d
					ON d.FullDate = CAST(t.ActivityDate AS DATE)
				INNER JOIN #Center c
					ON c.CenterNumber = ISNULL(t.CenterNumber__c, t.CenterID__c)
		WHERE   CAST(t.ActivityDate AS DATE) BETWEEN @MinDate AND @MaxDate
				AND LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
				AND LTRIM(RTRIM(ISNULL(t.Result__c, ''))) IN ( '', 'No Show', 'Show No Sale', 'Show Sale' )
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Task_Period ON #Task ( Period );
CREATE NONCLUSTERED INDEX IDX_Task_ActivityDate ON #Task ( ActivityDate );
CREATE NONCLUSTERED INDEX IDX_Task_Id ON #Task ( Id );
CREATE NONCLUSTERED INDEX IDX_Task_WhoId ON #Task ( WhoId );
CREATE NONCLUSTERED INDEX IDX_Task_CenterNumber ON #Task ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Task_Action__c ON #Task ( Action__c );
CREATE NONCLUSTERED INDEX IDX_Task_Result__c ON #Task ( Result__c );
CREATE NONCLUSTERED INDEX IDX_Task_SourceCode ON #Task ( SourceCode );


UPDATE STATISTICS #Task;


/********************************** Insert Data into Dashboard tables *************************************/


----------------------
-- Leads
----------------------
TRUNCATE TABLE dbLead


INSERT	INTO dbLead
		SELECT	l.Period
		,		l.CreationDate
		,		l.Id
		,		l.CenterKey
		,		l.CenterNumber
		,		l.CenterDescription
		,		l.CenterType
		,		l.FirstName
		,		l.LastName
		,		la.AddressLine1
		,		la.AddressLine2
		,		la.AddressLine3
		,		la.AddressLine4
		,		la.City
		,		la.StateCode
		,		la.ZipCode
		,		la.Country
		,		CASE WHEN l.Age = '0' THEN '' ELSE l.Age END AS 'Age'
		,		l.AgeRange
		,		l.Birthday
		,		l.Gender
		,		l.Language
		,		l.Ethnicity
		,		l.MaritalStatus
		,		l.Occupation
		,		l.DISCStyle
		,		l.NorwoodScale
		,		l.LudwigScale
		,		l.SolutionOffered
		,		l.PriceQuoted
		,		l.NoSaleReason
		,		l.SaleType
		,		l.BusinessSegmentOfferedOrSold
		,		l.HairLossExperience
		,		l.HairLossInFamily
		,		l.HairLossProductUsed
		,		l.HairLossProductOther
		,		l.HairLossSpot
		,		l.LeadStatus
		,		sc.CampaignName
		,		sc.CampaignType
		,		l.SourceCode AS 'CampaignSourceCode'
		,		sc.Channel AS 'CampaignChannel'
		,		sc.OwnerType AS 'CampaignOwnerType'
		,		sc.Gender AS 'SourceCodeGender'
		,		sc.Goal AS 'CampaignGoal'
		,		sc.BudgetedCost AS 'CampaignBudgetedCost'
		,		sc.ActualCost AS 'CampaignActualCost'
		,		sc.Media AS 'CampaignMedia'
		,		sc.Origin AS 'CampaignOrigin'
		,		sc.Location AS 'CampaignLocation'
		,		sc.Language AS 'CampaignLanguage'
		,		sc.Format AS 'CampaignFormat'
		,		sc.Creative AS 'CampaignDeviceType'
		,		sc.DNIS AS 'CampaignDNIS'
		,		sc.PromoCodeDescription AS 'CampaignPromoCodeDescription'
		,		l.HCReferral
		FROM	#Lead l
				LEFT OUTER JOIN #LeadAddress la
					ON la.Id = l.Id
				LEFT OUTER JOIN #SourceCode sc
					ON sc.SourceCode = l.SourceCode


----------------------
-- Tasks
----------------------
TRUNCATE TABLE dbTask


INSERT	INTO dbTask
		SELECT	t.Period
		,		t.ActivityDate
		,		t.Id
		,		t.CenterKey
		,		t.CenterNumber
		,		t.CenterDescription
		,		t.CenterType
		,		t.Action__c
		,		t.Result__c
		,		t.Performer
		,		CASE WHEN ISNULL(t.Accommodation__c, 'In Person Consult') LIKE 'Video%' THEN 'Virtual Consult' ELSE ISNULL(t.Accommodation__c, 'In Person Consult') END AS 'ConsultationType'
		,		ISNULL(sc_t.CampaignName, sc_l.CampaignName) AS 'CampaignName'
		,		ISNULL(sc_t.CampaignType, sc_l.CampaignType) AS 'CampaignType'
		,		ISNULL(t.SourceCode, sc_l.SourceCode) AS 'CampaignSourceCode'
		,		ISNULL(sc_t.Channel, sc_l.Channel) AS 'CampaignChannel'
		,		ISNULL(sc_t.OwnerType, sc_l.OwnerType) AS 'CampaignOwnerType'
		,		ISNULL(sc_t.Gender, sc_l.Gender) AS 'SourceCodeGender'
		,		ISNULL(sc_t.Goal, sc_l.Goal) AS 'CampaignGoal'
		,		ISNULL(sc_t.BudgetedCost, sc_l.BudgetedCost) AS 'CampaignBudgetedCost'
		,		ISNULL(sc_t.ActualCost, sc_l.ActualCost) AS 'CampaignActualCost'
		,		ISNULL(sc_t.Media, sc_l.Media) AS 'CampaignMedia'
		,		ISNULL(sc_t.Origin, sc_l.Origin) AS 'CampaignOrigin'
		,		ISNULL(sc_t.Location, sc_l.Location) AS 'CampaignLocation'
		,		ISNULL(sc_t.Language, sc_l.Language) AS 'CampaignLanguage'
		,		ISNULL(sc_t.Format, sc_l.Format) AS 'CampaignFormat'
		,		ISNULL(sc_t.Creative, sc_l.Creative) AS 'CampaignDeviceType'
		,		ISNULL(sc_t.DNIS, sc_l.DNIS) AS 'CampaignDNIS'
		,		ISNULL(sc_t.PromoCodeDescription, sc_l.PromoCodeDescription) AS 'CampaignPromoCodeDescription'
		,		CASE WHEN t.Action__c IN ( 'Appointment', 'In House' )
						AND (
								t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
								OR	t.Result__c IS NULL
								OR	t.Result__c = ''
							) THEN 1
					ELSE 0
				END AS 'Appointment'
		,		CASE WHEN t.Action__c NOT IN ( 'Be Back' )
						AND t.Result__c IN ( 'Show No Sale', 'Show Sale' ) AND ISNULL(t.ExcludeFromConsults, 0) = 0 THEN 1
					ELSE 0
				END AS 'Consultation'
		,		CASE WHEN t.Action__c IN ( 'Be back' )
						AND (
								t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
								OR	t.Result__c IS NULL
								OR	t.Result__c = ''
							)  AND ISNULL(t.ExcludeFromBeBacks, 0) = 0  THEN 1
					ELSE 0
				END AS 'Beback'
		,		CASE WHEN t.Action__c IN ( 'In House' ) THEN 1
					ELSE 0
				END AS 'InHouse'
		,		CASE WHEN t.Result__c IN ( 'Show Sale', 'Show No Sale' ) THEN 1 ELSE 0 END AS 'Show'
		,		CASE WHEN t.Result__c IN ( 'No Show' ) THEN 1 ELSE 0 END AS 'NoShow'
		,		CASE WHEN t.Result__c IN ( 'Show Sale' ) THEN 1 ELSE 0 END AS 'Sale'
		,		CASE WHEN t.Result__c IN ( 'Show No Sale' ) THEN 1 ELSE 0 END AS 'NoSale'
		FROM	#Task t
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = t.WhoId
				LEFT OUTER JOIN #SourceCode sc_t
					ON sc_t.SourceCode = t.SourceCode
				LEFT OUTER JOIN #SourceCode sc_l
					ON sc_l.SourceCode = l.Source_Code_Legacy__c

END
