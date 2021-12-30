/* CreateDate: 08/21/2018 14:37:47.957 , ModifyDate: 08/21/2018 14:38:13.313 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FacebookAudienceClientEmailExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/21/2018
DESCRIPTION:			8/21/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_FacebookAudienceClientEmailExport
***********************************************************************/
CREATE PROCEDURE spSvc_FacebookAudienceClientEmailExport
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;

CREATE TABLE #Center (
	CenterID INT
,	CompanyID NCHAR(10)
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	Timezone NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	RegionalVicePresident NVARCHAR(102)
)

CREATE TABLE #Client (
	ClientGUID UNIQUEIDENTIFIER
)

/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID )
CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID )


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ISNULL(co.company_id, '') AS 'CompanyID'
		,       ctr.CenterDescription AS 'CenterName'
		,       dct.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(lr.RegionID, 1) AS 'RegionID'
		,       ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,       ctr.Address1
		,       ctr.Address2
		,       ctr.City
		,       ls.StateDescriptionShort AS 'StateCode'
		,       ctr.PostalCode AS 'ZipCode'
		,       lc.CountryDescription AS 'Country'
		,		tz.TimeZoneDescriptionShort AS 'Timezone'
		,       ctr.Phone1 AS 'PhoneNumber'
		,       CASE ctr.CenterID
				  WHEN 201 THEN 'Susan Greenspan'
				  WHEN 205 THEN ''
				  WHEN 212 THEN ''
				  WHEN 213 THEN ''
				  WHEN 228 THEN 'Simon D''Souza'
				  WHEN 229 THEN 'Chris Terkalas'
				  WHEN 250 THEN ''
				  WHEN 239 THEN 'Tarrah-Lee Lawrence'
				  WHEN 255 THEN 'Kadisha Esperanto'
				  WHEN 260 THEN 'Jim Loar'
				  WHEN 283 THEN 'Ashley Zielke'
				  ELSE ISNULL(o_MD.ManagingDirector, '')
				END AS 'ManagingDirector'
		,		ISNULL(co.cst_director_name, '') AS 'RegionalVicePresident'
		FROM    HairClubCMS.dbo.cfgCenter ctr
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
				LEFT OUTER JOIN HCM.dbo.oncd_company co
					ON co.cst_center_number = ctr.CenterNumber
				OUTER APPLY ( SELECT TOP 1
										ec.CenterID
							  ,         e.FirstName + ' ' + e.LastName AS 'ManagingDirector'
							  ,         e.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee e
										LEFT JOIN HairClubCMS.dbo.datEmployeeCenter ec
											ON ec.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.cfgEmployeePositionJoin ep
											ON ep.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.lkpEmployeePosition epl
											ON epl.EmployeePositionID = ep.EmployeePositionID
							  WHERE     e.CenterID = ctr.CenterID
										AND e.CenterID = ec.CenterID
										AND e.FirstName NOT IN ( 'EC', 'Test' )
										AND e.IsActiveFlag = 1
										AND epl.ActiveDirectoryGroup = 'Role_Ops Managing Director'
										AND epl.IsActiveFlag = 1
										AND ec.IsActiveFlag = 1
										AND ep.IsActiveFlag = 1
							  ORDER BY  ec.CenterID
							  ,         e.EmployeePayrollID DESC
							) o_MD
		WHERE   dct.CenterTypeDescriptionShort IN ( 'C', 'JV', 'F' )
				AND ctr.IsActiveFlag = 1


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  DISTINCT
				clt.ClientGUID
		FROM    HairClubCMS.dbo.datClientMembership dcm
				INNER JOIN HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = dcm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
					ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = dcm.ClientGUID
				INNER JOIN #Center c
					ON c.CenterID = clt.CenterID
		WHERE	( cms.ClientMembershipStatusDescription = 'Active' AND dcm.EndDate >= CAST(GETDATE() AS DATE) )
				AND m.MembershipDescriptionShort NOT IN ( 'HCFK', 'RETAIL', 'NONPGM', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT', 'SHOWNOSALE', 'SNSSURGOFF', 'EMPLOYXTR', 'MODELXTR', 'MDLEXTUG', 'MDLEXTUGSL' )


/********************************** Return Client Email Data *************************************/
SELECT  DISTINCT
		ISNULL(clt.EmailAddress, '') AS 'Email'
FROM    HairClubCMS.dbo.datClient clt
		INNER JOIN #Client c
			ON c.ClientGUID = clt.ClientGUID
WHERE	ISNULL(clt.EmailAddress, '') <> '' -- Email Address cannot be empty


END
GO
