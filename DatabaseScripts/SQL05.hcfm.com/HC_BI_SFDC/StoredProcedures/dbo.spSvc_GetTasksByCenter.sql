/* CreateDate: 05/11/2020 17:10:50.270 , ModifyDate: 05/11/2020 18:02:45.050 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetTasksByCenter
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/11/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetTasksByCenter 294
EXEC spSvc_GetTasksByCenter 296
***********************************************************************/
CREATE PROCEDURE spSvc_GetTasksByCenter
(
	@CenterNumber INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CenterType INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @CenterType = 2
SET @StartDate = '1/1/2014'
SET @EndDate = '5/10/2020'


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	Area NVARCHAR(100)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(15)
,	Country NVARCHAR(100)
,	Timezone NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 2
	BEGIN
		INSERT INTO #Center
				SELECT	ctr.CenterID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionFullCalc AS 'CenterName'
				,		dct.CenterTypeDescriptionShort AS 'CenterType'
				,		cma.CenterManagementAreaDescription AS 'Area'
				,		ISNULL(lr.RegionID, 1) AS 'RegionID'
				,		ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
				,		ctr.Address1
				,		ctr.Address2
				,		ctr.City
				,		ls.StateDescriptionShort AS 'StateCode'
				,		ctr.PostalCode AS 'ZipCode'
				,		lc.CountryDescription AS 'Country'
				,		tz.TimeZoneDescriptionShort AS 'Timezone'
				,		ctr.Phone1 AS 'PhoneNumber'
				FROM	HairClubCMS.dbo.cfgCenter ctr
						INNER JOIN HairClubCMS.dbo.lkpCenterType dct
							ON dct.CenterTypeID = ctr.CenterTypeID
						INNER JOIN HairClubCMS.dbo.lkpRegion lr
							ON lr.RegionID = ctr.RegionID
						INNER JOIN HairClubCMS.dbo.lkpState ls
							ON ls.StateID = ctr.StateID
						INNER JOIN HairClubCMS.dbo.lkpCountry lc
							ON lc.CountryID = ctr.CountryID
						LEFT OUTER JOIN HairClubCMS.dbo.lkpTimeZone tz
							ON tz.TimeZoneID = ctr.TimeZoneID
						LEFT OUTER JOIN HairClubCMS.dbo.cfgCenterManagementArea cma
							ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
				WHERE	dct.CenterTypeDescriptionShort IN ( 'C' )
						AND ctr.CenterNumber = @CenterNumber
						AND ctr.IsActiveFlag = 1
	END


IF @CenterType = 8
	BEGIN
		INSERT INTO #Center
				SELECT	ctr.CenterID
				,		ctr.CenterNumber
				,		ctr.CenterDescriptionFullCalc AS 'CenterName'
				,		dct.CenterTypeDescriptionShort AS 'CenterType'
				,		cma.CenterManagementAreaDescription AS 'Area'
				,		ISNULL(lr.RegionID, 1) AS 'RegionID'
				,		ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
				,		ctr.Address1
				,		ctr.Address2
				,		ctr.City
				,		ls.StateDescriptionShort AS 'StateCode'
				,		ctr.PostalCode AS 'ZipCode'
				,		lc.CountryDescription AS 'Country'
				,		tz.TimeZoneDescriptionShort AS 'Timezone'
				,		ctr.Phone1 AS 'PhoneNumber'
				FROM	HairClubCMS.dbo.cfgCenter ctr
						INNER JOIN HairClubCMS.dbo.lkpCenterType dct
							ON dct.CenterTypeID = ctr.CenterTypeID
						INNER JOIN HairClubCMS.dbo.lkpRegion lr
							ON lr.RegionID = ctr.RegionID
						INNER JOIN HairClubCMS.dbo.lkpState ls
							ON ls.StateID = ctr.StateID
						INNER JOIN HairClubCMS.dbo.lkpCountry lc
							ON lc.CountryID = ctr.CountryID
						LEFT OUTER JOIN HairClubCMS.dbo.lkpTimeZone tz
							ON tz.TimeZoneID = ctr.TimeZoneID
						LEFT OUTER JOIN HairClubCMS.dbo.cfgCenterManagementArea cma
							ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
				WHERE	dct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
						AND ctr.CenterNumber = @CenterNumber
						AND ctr.IsActiveFlag = 1
	END


CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center (CenterID);
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center (CenterNumber);


UPDATE STATISTICS #Center;


SELECT	c.Area
,		c.CenterNumber
,		c.CenterName AS 'CenterDescription'
,		c.PhoneNumber AS 'CenterPhoneNumber'
,		t.Id AS 'SFDC_TaskID'
,		t.ActivityDate
,		t.StartTime__c AS 'StartTime'
,		ISNULL(t.Action__c, '') AS 'ActionCode'
,		ISNULL(t.Result__c, '') AS 'ResultCode'
,		l.Id AS 'SFDC_LeadID'
,		l.FirstName
,		l.LastName
,		l.Status
,		CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', '')))) > 0  -- Invalid characters
			OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be starting character
			OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be ending character
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%'                 -- Must contain at least one @ and one .
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%..%'                      -- Cannot have two periods in a row
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@%@%'                     -- Cannot have two @ anywhere
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.@%'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.cm'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.or'
			OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
			THEN ''
			ELSE LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(o_E.EMailAddress, ''), ']', ''), '[', '')))
		END AS 'EmailAddress'
,		ISNULL(o_P.PhoneNumber, '') AS 'PhoneNumber'
,		ISNULL(l.Gender__c, 'Not Specified') AS 'Gender'
,		ISNULL(l.Ethnicity__c, '') AS 'Ethnicity'
,		ISNULL(t.Occupation__c, '') AS 'Occupation'
,		ISNULL(t.MaritalStatus__c, '') AS 'MaritalStatus'
,		ISNULL(t.LudwigScale__c, '') AS 'LudwigScale'
,		ISNULL(t.NorwoodScale__c, '') AS 'NorwoodScale'
,		ISNULL(t.DISC__c, '') AS 'DISCStyle'
,		ISNULL(t.SolutionOffered__c, '') AS 'SolutionOffered'
,		ISNULL(t.PriceQuoted__c, 0) AS 'PriceQuoted'
,		ISNULL(t.NoSaleReason__c, '') AS 'NoSaleReason'
,		ISNULL(t.SaleTypeDescription__c, '') AS 'SaleType'
,		l.Source_Code_Legacy__c AS 'LeadSourceCode'
,		s.Media AS 'LeadSourceMedia'
,		s.Channel AS 'LeadSourceChannel'
,		s.Level02Location AS 'LeadSourceLocation'
,		s.Level03Language AS 'LeadSourceLanguage'
,		s.Level04Format AS 'LeadSourceFormat'
,		t.SourceCode__c AS 'TaskSourceCode'
,		ts.Media AS 'TaskSourceMedia'
,		ts.Channel AS 'TaskSourceChannel'
,		ts.Level02Location AS 'TaskSourceLocation'
,		ts.Level03Language AS 'TaskSourceLanguage'
,		ts.Level04Format AS 'TaskSourceFormat'
FROM	HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		INNER JOIN #Center c
			ON c.CenterNumber = ISNULL(l.CenterID__c, l.CenterNumber__c)
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource s
			ON s.SourceSSID = l.Source_Code_Legacy__c
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ts
			ON ts.SourceSSID = t.SourceCode__c
		OUTER APPLY (
			SELECT	TOP 1
					ec.Name AS 'EmailAddress'
			FROM	HC_BI_SFDC.dbo.Email__c ec
			WHERE	ec.Lead__c = l.Id
					AND ec.Primary__c = 1
					AND ISNULL(ec.IsDeleted, 0) = 0
			ORDER BY ec.CreatedDate DESC
		) o_E
		OUTER APPLY (
			SELECT	TOP 1
					pc.PhoneAbr__c AS 'PhoneNumber'
			FROM	HC_BI_SFDC.dbo.Phone__c pc
			WHERE	pc.Lead__c = l.Id
					AND pc.Primary__c = 1
					AND pc.ValidFlag__c = 1
			ORDER BY pc.CreatedDate DESC
		) o_P
WHERE	ISNULL(t.Result__c, '') NOT IN ( 'Void' )
		AND ISNULL(t.IsDeleted, 0) = 0

END
GO
