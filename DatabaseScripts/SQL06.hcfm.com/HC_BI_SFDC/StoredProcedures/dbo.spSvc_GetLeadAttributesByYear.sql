/***********************************************************************
PROCEDURE:				spSvc_GetLeadAttributesByYear
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/29/2019
DESCRIPTION:			Used to get 2 years of Lead data
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetLeadAttributesByYear
***********************************************************************/
CREATE PROCEDURE spSvc_GetLeadAttributesByYear
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) +1, 0))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Lead (
	Id NVARCHAR(18)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	FirstName NVARCHAR(80)
,	LastName NVARCHAR(80)
,	Status NVARCHAR(50)
,	Age INT
,	AgeRange NVARCHAR(50)
,	Birthday VARCHAR(11)
,	Gender NVARCHAR(50)
,	Language NVARCHAR(50)
,	Ethnicity NVARCHAR(100)
,	MaritalStatus NVARCHAR(100)
,	Occupation NVARCHAR(100)
,	DISC NVARCHAR(50)
,	NorwoodScale NVARCHAR(100)
,	LudwigScale NVARCHAR(100)
,	SolutionOffered NVARCHAR(255)
,	HairLossExperience NVARCHAR(100)
,	HairLossInFamily NVARCHAR(100)
,	HairLossProductUsed NVARCHAR(100)
,	HairLossProductOther NVARCHAR(100)
,	HairLossSpot NVARCHAR(100)
,	SiebelID NVARCHAR(50)
,	GCLID NVARCHAR(100)
,	DoNotContact BIT
,	DoNotCall BIT
,	DoNotEmail BIT
,	DoNotMail BIT
,	DoNotText BIT
,	OriginalCampaignId NVARCHAR(18)
,	RecentCampaignId NVARCHAR(18)
,	DateCreated DATE
,	DayCreated NVARCHAR(50)
,	WeekNumberCreated INT
,	MonthCreated NVARCHAR(50)
,	YearCreated INT
,	CreatedByUserCode NVARCHAR(50)
,	CreatedByFirstName NVARCHAR(80)
,	CreatedByLastName NVARCHAR(80)
,	CreatedByDepartment NVARCHAR(80)
)

CREATE TABLE #LastShow (
	RowID INT
,	WhoId NVARCHAR(18)
,	Gender NVARCHAR(50)
,	Birthday DATETIME
,	Occupation NVARCHAR(100)
,	Ethnicity NVARCHAR(100)
,	MaritalStatus NVARCHAR(100)
,	Norwood NVARCHAR(100)
,	Ludwig NVARCHAR(100)
,	Age INT
,	PriceQuoted DECIMAL(18,2)
,	SolutionOffered NVARCHAR(100)
,	NoSaleReason NVARCHAR(200)
,	DISC NVARCHAR(50)
,	SalesTypeCode NVARCHAR(50)
,	SaleTypeDescription NVARCHAR(50)
)

CREATE TABLE #Campaign (
	Id NVARCHAR(18)
,	CampaignName NVARCHAR(80)
,	CampaignType NVARCHAR(50)
,	Type NVARCHAR(50)
,	CommunicationType NVARCHAR(50)
,	Channel NVARCHAR(50)
,	Language NVARCHAR(50)
,	Media NVARCHAR(50)
,	Format NVARCHAR(50)
,	Location NVARCHAR(50)
,	Source NVARCHAR(50)
,	Goal NVARCHAR(50)
,	PromoCodeName NVARCHAR(50)
,	PromoCodeDisplay NVARCHAR(255)
,	Status NVARCHAR(50)
,	StartDate DATETIME
,	EndDate DATETIME
,	Gender NVARCHAR(50)
,	TollFreeName NVARCHAR(50)
,	DNIS NVARCHAR(50)
,	TollFreeMobileName NVARCHAR(50)
,	DNISMobile NVARCHAR(50)
,	URLDomain NVARCHAR(255)
,	SourceCode NVARCHAR(50)
,	DPNCode NVARCHAR(50)
,	DWFCode NVARCHAR(50)
,	DWCCode NVARCHAR(50)
,	MPNCode NVARCHAR(50)
,	MWFCode NVARCHAR(50)
,	MWCCode NVARCHAR(50)
,	WebCode NVARCHAR(255)
)


-- Get Leads created between specified date range
INSERT	INTO #Lead
		SELECT	l.Id
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		ct.CenterTypeDescription AS 'CenterType'
		,		l.FirstName
		,		l.LastName
		,		l.Status
		,		ISNULL(CONVERT(VARCHAR, l.Age__c), '') AS 'Age'
		,		ISNULL(l.AgeRange__c, '') AS 'AgeRange'
		,		ISNULL(CONVERT(VARCHAR(11), CAST(l.Birthday__c AS DATE), 101), '') AS 'Birthday'
		,		l.Gender__c AS 'Gender'
		,		l.Language__c AS 'Language'
		,		ISNULL(l.Ethnicity__c, '') AS 'Ethnicity'
		,		ISNULL(l.MaritalStatus__c, '') AS 'MaritalStatus'
		,		ISNULL(l.Occupation__c, '') AS 'Occupation'
		,		ISNULL(l.DISC__c, '') AS 'DISC'
		,		ISNULL(l.NorwoodScale__c, '') AS 'Norwood'
		,		ISNULL(l.LudwigScale__c, '') AS 'Ludwig'
		,		ISNULL(l.SolutionOffered__c, '') AS 'SolutionOffered'
		,		ISNULL(l.HairLossExperience__c, '') AS 'HairLossExperience'
		,		ISNULL(l.HairLossFamily__c, '') AS 'HairLossInFamily'
		,		ISNULL(l.HairLossProductUsed__c, '') AS 'HairLossProductUsed'
		,		ISNULL(l.HairLossProductOther__c, '') AS 'HairLossProductOther'
		,		ISNULL(l.HairLossSpot__c, '') AS 'HairLossSpot'
		,		ISNULL(l.SiebelID__c, '') AS 'SiebelID'
		,		ISNULL(l.GCLID__c, '') AS 'GCLID'
		,		l.DoNotContact__c AS 'DoNotContact'
		,		l.DoNotCall
		,		l.DoNotEmail__c AS 'DoNotEmail'
		,		l.DoNotMail__c AS 'DoNotMail'
		,		l.DoNotText__c AS 'DoNotText'
		,		l.OriginalCampaignID__c
		,		l.RecentCampaignID__c
		,		d.FullDate AS 'DateCreated'
		,		d.DayOfWeekName AS 'DayCreated'
		,		d.WeekNumber AS 'WeekNumberCreated'
		,		d.MonthName AS 'MonthCreated'
		,		d.YearNumber AS 'YearCreated'
		,		ISNULL(u.UserCode__c, '') AS 'CreatedByUserCode'
		,		u.FirstName AS 'CreatedByFirstName'
		,		u.LastName AS 'CreatedByLastName'
		,		u.Department AS 'CreatedByDepartment'
		FROM	Lead l
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.FullDate = CAST(l.ReportCreateDate__c AS DATE)
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN [User] u
					ON u.Id = l.CreatedById
		WHERE	d.FullDate BETWEEN @StartDate AND @EndDate
				AND l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient' )
				AND ct.CenterTypeDescription <> 'Surgery'
				AND ISNULL(l.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_Lead_Id ON #Lead ( Id );


UPDATE STATISTICS #Lead;


-- Get Lead Demographic data using the last show
INSERT	INTO #LastShow
		SELECT	ROW_NUMBER() OVER ( PARTITION BY t.WhoId ORDER BY t.ActivityDate DESC ) AS 'RowID'
		,		t.WhoId
		,		t.LeadOncGender__c
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
		FROM	Task t
				INNER JOIN #Lead l
					ON l.Id = t.WhoId
		WHERE	ISNULL(t.Result__c, '') IN ( 'Show Sale', 'Show No Sale' )
				AND ISNULL(t.IsDeleted, 0) = 0


CREATE NONCLUSTERED INDEX IDX_LastShow_RowID ON #LastShow ( RowID );
CREATE NONCLUSTERED INDEX IDX_LastShow_WhoId ON #LastShow ( WhoId );


UPDATE STATISTICS #LastShow;


DELETE FROM #LastShow WHERE RowID <> 1


-- Get Campaign data
INSERT	INTO #Campaign
		SELECT	c.Id
		,		c.Name
		,		ISNULL(c.CampaignType__c, '') AS 'CampaignType__c'
		,		ISNULL(c.Type, '') AS 'Type'
		,		ISNULL(c.CommunicationType__c, '') AS 'CommunicationType__c'
		,		ISNULL(c.Channel__c, '') AS 'Channel__c'
		,		ISNULL(c.Language__c, '') AS 'Language__c'
		,		ISNULL(c.Media__c, '') AS 'Media__c'
		,		ISNULL(c.Format__c, '') AS 'Format__c'
		,		ISNULL(c.Location__c, '') AS 'Location__c'
		,		ISNULL(c.Source__c, '') AS 'Source__c'
		,		ISNULL(c.Goal__c, '') AS 'Goal__c'
		,		ISNULL(c.PromoCodeName__c, '') AS 'PromoCodeName__c'
		,		ISNULL(c.PromoCodeDisplay__c, '') AS 'PromoCodeDisplay__c'
		,		c.Status
		,		c.StartDate
		,		c.EndDate
		,		ISNULL(c.Gender__c, '') AS 'Gender__c'
		,		ISNULL(c.TollFreeName__c, '') AS 'TollFreeName__c'
		,		ISNULL(c.DNIS__c, '') AS 'DNIS__c'
		,		ISNULL(c.TollFreeMobileName__c, '') AS 'TollFreeMobileName__c'
		,		ISNULL(c.DNISMobile__c, '') AS 'DNISMobile__c'
		,		ISNULL(c.URLDomain__c, '') AS 'URLDomain__c'
		,		ISNULL(c.SourceCode_L__c, '') AS 'SourceCode_L__c'
		,		ISNULL(c.DPNCode__c, '') AS 'DPNCode__c'
		,		ISNULL(c.DWFCode__c, '') AS 'DWFCode__c'
		,		ISNULL(c.DWCCode__c, '') AS 'DWCCode__c'
		,		ISNULL(c.MPNCode__c, '') AS 'MPNCode__c'
		,		ISNULL(c.MWFCode__c, '') AS 'MWFCode__c'
		,		ISNULL(c.MWCCode__c, '') AS 'MWCCode__c'
		,		ISNULL(c.WebCode__c, '') AS 'WebCode__c'
		FROM	Campaign c


CREATE NONCLUSTERED INDEX IDX_Campaign_Id ON #Campaign ( Id );


UPDATE STATISTICS #Campaign;


-- Combine and Return Data
SELECT	l.DateCreated
,		l.DayCreated
,		l.WeekNumberCreated
,		l.MonthCreated
,		l.YearCreated
,		l.CreatedByUserCode
,		l.CreatedByFirstName
,		l.CreatedByLastName
,		l.CreatedByDepartment
,		l.Id
,		l.CenterNumber
,		l.CenterDescription
,		l.CenterType
,		l.FirstName
,		l.LastName
,		l.Status
,		l.Age
,		l.AgeRange
,		l.Birthday
,		l.Gender
,		l.Language
,		ISNULL(CASE WHEN ls.Ethnicity IS NULL THEN l.Ethnicity ELSE ls.Ethnicity END, '') AS 'Ethnicity'
,		ISNULL(CASE WHEN ls.MaritalStatus IS NULL THEN l.MaritalStatus ELSE ls.MaritalStatus END, '') AS 'MaritalStatus'
,		ISNULL(CASE WHEN ls.Occupation IS NULL THEN l.Occupation ELSE ls.Occupation END, '') AS 'Occupation'
,		ISNULL(CASE WHEN ls.DISC IS NULL THEN l.DISC ELSE ls.DISC END, '') AS 'DISC'
,		ISNULL(CASE WHEN ls.Norwood IS NULL THEN l.NorwoodScale ELSE ls.Norwood END, '') AS 'Norwood'
,		ISNULL(CASE WHEN ls.Ludwig IS NULL THEN l.LudwigScale ELSE ls.Ludwig END, '') AS 'Ludwig'
,		ISNULL(CASE WHEN ls.SolutionOffered IS NULL THEN l.SolutionOffered ELSE ls.SolutionOffered END, '') AS 'SolutionOffered'
,		ISNULL(ls.PriceQuoted, 0) AS 'PriceQuoted'
,		ISNULL(ls.NoSaleReason, '') AS 'NoSaleReason'
,		ISNULL(ls.SaleTypeDescription, '') AS 'SaleType'
,		l.HairLossExperience
,		l.HairLossInFamily
,		l.HairLossProductUsed
,		l.HairLossProductOther
,		l.HairLossSpot
,		l.SiebelID
,		l.GCLID
,		l.DoNotContact
,		l.DoNotCall
,		l.DoNotEmail
,		l.DoNotMail
,		l.DoNotText
,		oc.CampaignName AS 'OriginalCampaignName'
,		oc.CampaignType AS 'OriginalCampaignType'
,		oc.Type AS 'OriginalType'
,		oc.CommunicationType AS 'OriginalCampaignCommunicationType'
,		oc.Gender AS 'OriginalCampaignGender'
,		oc.Channel AS 'OriginalCampaignChannel'
,		oc.Language AS 'OriginalCampaignLanguage'
,		oc.Media AS 'OriginalCampaignMedia'
,		oc.Format AS 'OriginalCampaignFormat'
,		oc.Location AS 'OriginalCampaignLocation'
,		oc.Source AS 'OriginalCampaignCreative'
,		oc.Goal AS 'OriginalCampaignGoal'
,		oc.PromoCodeName AS 'OriginalCampaignPromoCode'
,		oc.PromoCodeDisplay AS 'OriginalCampaignPromoCodeDescription'
,		oc.Status AS 'OriginalCampaignStatus'
,		oc.StartDate AS 'OriginalCampaignStartDate'
,		oc.EndDate AS 'OriginalCampaignEndDate'
,		oc.TollFreeName AS 'OriginalCampaignTollFreeNumber'
,		oc.DNIS AS 'OriginalCampaignDNIS'
,		oc.TollFreeMobileName AS 'OriginalCampaignTollFreeMobileNumber'
,		oc.DNISMobile AS 'OriginalCampaignDNISMobile'
,		oc.URLDomain AS 'OriginalCampaignURL'
,		oc.SourceCode AS 'OriginalCampaignSourceCode'
,		oc.DPNCode AS 'OriginalCampaignDPNCode'
,		oc.DWFCode AS 'OriginalCampaignDWFCode'
,		oc.DWCCode AS 'OriginalCampaignDWCCode'
,		oc.MPNCode AS 'OriginalCampaignMPNCode'
,		oc.MWFCode AS 'OriginalCampaignMWFCode'
,		oc.MWCCode AS 'OriginalCampaignMWCCode'
,		oc.WebCode AS 'OriginalCampaignWebCode'
,		rc.CampaignName AS 'RecentCampaignName'
,		rc.CampaignType AS 'RecentCampaignType'
,		rc.Type AS 'RecentType'
,		rc.CommunicationType AS 'RecentCampaignCommunicationType'
,		rc.Gender AS 'RecentCampaignGender'
,		rc.Channel AS 'RecentCampaignChannel'
,		rc.Language AS 'RecentCampaignLanguage'
,		rc.Media AS 'RecentCampaignMedia'
,		rc.Format AS 'RecentCampaignFormat'
,		rc.Location AS 'RecentCampaignLocation'
,		rc.Source AS 'RecentCampaignCreative'
,		rc.Goal AS 'RecentCampaignGoal'
,		rc.PromoCodeName AS 'RecentCampaignPromoCode'
,		rc.PromoCodeDisplay AS 'RecentCampaignPromoCodeDescription'
,		rc.Status AS 'RecentCampaignStatus'
,		rc.StartDate AS 'RecentCampaignStartDate'
,		rc.EndDate AS 'RecentCampaignEndDate'
,		rc.TollFreeName AS 'RecentCampaignTollFreeNumber'
,		rc.DNIS AS 'RecentCampaignDNIS'
,		rc.TollFreeMobileName AS 'RecentCampaignTollFreeMobileNumber'
,		rc.DNISMobile AS 'RecentCampaignDNISMobile'
,		rc.URLDomain AS 'RecentCampaignURL'
,		rc.SourceCode AS 'RecentCampaignSourceCode'
,		rc.DPNCode AS 'RecentCampaignDPNCode'
,		rc.DWFCode AS 'RecentCampaignDWFCode'
,		rc.DWCCode AS 'RecentCampaignDWCCode'
,		rc.MPNCode AS 'RecentCampaignMPNCode'
,		rc.MWFCode AS 'RecentCampaignMWFCode'
,		rc.MWCCode AS 'RecentCampaignMWCCode'
,		rc.WebCode AS 'RecentCampaignWebCode'
FROM	#Lead l
		LEFT OUTER JOIN #LastShow ls
			ON ls.WhoId = l.Id
		LEFT OUTER JOIN #Campaign oc
			ON oc.Id = l.OriginalCampaignId
		LEFT OUTER JOIN #Campaign rc
			ON rc.Id = l.RecentCampaignId

END
