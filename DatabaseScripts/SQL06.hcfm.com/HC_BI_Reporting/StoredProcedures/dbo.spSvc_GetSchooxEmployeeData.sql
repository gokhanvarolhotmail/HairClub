/***********************************************************************
PROCEDURE:				spSvc_GetSchooxEmployeeData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/12/2018
DESCRIPTION:			2/12/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetSchooxEmployeeData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetSchooxEmployeeData]
AS
BEGIN

SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
DECLARE @Center TABLE (
	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	AreaName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	Timezone NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
)

DECLARE @O365 TABLE (
	FirstName NVARCHAR(255)
,	LastName NVARCHAR(255)
,	UserLogin NVARCHAR(50)
,	UserPrincipalName NVARCHAR(255)
,	ObjectId NVARCHAR(255)
,	Office NVARCHAR(255)
,	Department NVARCHAR(255)
,	CenterNumber NVARCHAR(255)
,	Title NVARCHAR(255)
)


/********************************** Get Center Data *************************************/
INSERT  INTO @Center
		SELECT  ctr.CenterID
		,		ctr.CenterNumber
		,       ctr.CenterDescription AS 'CenterName'
		,       dct.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(lr.RegionID, 1) AS 'RegionID'
		,       ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,		cma.CenterManagementAreaDescription AS 'AreaName'
		,       ctr.Address1
		,       ctr.Address2
		,       ctr.City
		,       ls.StateDescriptionShort AS 'StateCode'
		,       ctr.PostalCode AS 'ZipCode'
		,       lc.CountryDescription AS 'Country'
		,		tz.TimeZoneDescriptionShort AS 'Timezone'
		,       ctr.Phone1 AS 'PhoneNumber'
		FROM    SQL01.HairClubCMS.dbo.cfgCenter ctr
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCenterType dct
					ON dct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpRegion lr
					ON lr.RegionID = ctr.RegionID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpState ls
					ON ls.StateID = ctr.StateID
				INNER JOIN SQL01.HairClubCMS.dbo.lkpCountry lc
					ON lc.CountryID = ctr.CountryID
				LEFT OUTER JOIN SQL01.HairClubCMS.dbo.cfgCenterManagementArea cma
					ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
				LEFT OUTER JOIN SQL01.HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
		WHERE   dct.CenterTypeDescriptionShort IN ( 'C', 'JV', 'F', 'HW' )
				AND ctr.CenterNumber <> 199
				AND ctr.IsActiveFlag = 1


/********************************** Get Office 365 User Data *************************************/
INSERT  INTO @O365
		SELECT	ou.FirstName
		,		ou.LastName
		,		(SELECT SplitValue FROM HC_BI_Reporting.dbo.fnSplit(ou.UserPrincipalName, '@') WHERE Id = 1) AS 'UserLogin'
		,		ou.UserPrincipalName
		,		ou.ObjectId
		,		ou.Office
		,		CASE WHEN ((LEN(ou.Department) = 3 AND ou.Department <> 'NCC') AND CONVERT(INT, ou.Department) < 200) THEN '100' ELSE ou.Department END AS 'Department'
		,		NULL AS 'CenterNumber'
		,		ou.Title
		FROM	tmpO365Users ou
		WHERE	ou.FirstName <> ''
				AND ou.LastName NOT IN ( '', 'Support', 'Test', 'Sales Support', 'Phones', 'Management', 'Square', 'Supervisor', 'solarwindsnmp', 'Subscription', 'Test1'
									, 'Contact', 'ConfirmationEnglish', 'OutboundEnglish', 'Confirmation', 'ConfirmationFrench', 'OutboundSpanish', 'OutboundFrench'
									, 'Translation Services', 'NCC Support', 'Ad Line', 'NCC Attendance Line', 'Head Office', 'English Call', 'Support Desk'
									, 'Spanish Reschedule', 'Spanish Call', 'English Reschedule', 'Reschedule Line', 'Hotline', 'Vancouver', 'Service Account'
									, 'Minoxidil', 'mix', 'West Palm Beach', 'Rye Brook', 'Delray Beach', '297', 'Vancouver', '264', 'Rye Brook', '206'
									, 'Virginia Beach', 'HansWeimann', 'Desk', '244', 'Ottawa', 'Orlando', 'Hans Wiemann', 'Confirmation Spanish 2', 'Desk'
									, 'Technician2', 'Technician3', '1', 'NCC', 'Center Admin', 'MGR', 'MGRTEST', 'con2', 'Technician', 'ACE', 'Service', 'CRM'
									, 'Tablet_CRM'
									)
				AND ou.ObjectId NOT IN ( 'f000704a-f6b9-4095-9a9c-0b880e83a985', '895a878d-1812-4744-aa82-d86a8129f35a', 'debc64a0-71a5-4104-bc88-be0b1c56caf5'
									, '3a74dc0f-c65d-4af5-93cd-e54ceac0351b', 'd72542e3-2bf3-4a10-9870-4457482f6e10', 'd55b6fd3-ab8b-4776-b87a-2c6889ad649a'
									, '2875b1ea-5f0b-48be-b863-d696d24dc23a', '4d197690-a468-43ea-8b97-bbd9967867ea', '99e09eb1-d74e-4749-b5b9-a4cdc86e13fe'
									, '91e45a88-eff3-402d-8c89-35053e7be95f', 'c383a869-49d7-4732-8689-7d2a4dc34b2a', '88100f97-7262-455e-9352-b28dfb052752'
									, '31eefce0-ed8a-4e25-bf96-9d0c797e65b2', '6903b4ee-df02-4350-a863-4e698a74798c', '24ff57db-8ef5-48d2-a4ff-841db9ab7110'
									, '98ea2a7d-84a0-4b22-8404-dc255588e0d7', 'dbc829cb-ff28-449b-b919-73a0fefc8e2f'
									)
				AND ou.Title NOT IN ( 'Vendor', 'Service Account' )


UPDATE	o
SET		o.Office = CASE WHEN o.Office = '' THEN 'Boca Raton' ELSE o.Office END
,		o.Department = CASE WHEN o.Department = '' THEN '100' ELSE o.Department END
FROM	@O365 o


UPDATE	o
SET		o.Department = 'Contact Center'
FROM	@O365 o
WHERE	o.Department = 'NCC'


UPDATE	o
SET		o.Department = 'Information Technology'
FROM	@O365 o
WHERE	o.Department = 'IT'


UPDATE	o
SET		o.Department = CASE WHEN LEN(o.Department) <= 3 THEN 'Corporate' ELSE o.Department END
FROM	@O365 o


UPDATE	o
SET		o.CenterNumber = CASE WHEN LEN(o.Department) = 3 THEN o.Department ELSE '100' END
FROM	@O365 o


SELECT  CONVERT(VARCHAR, ISNULL(ctr.CenterNumber, 100)) + ' - ' + ISNULL(ctr.CenterName, 'Corporate') AS 'CENTER'
,		ISNULL(ctr.Address1, '1499 W. Palmetto Park Road') + ', ' + ISNULL(ctr.Address2, 'Suite 111') + ', ' + ISNULL(ctr.City, 'Boca Raton') + ', ' + ISNULL(ctr.StateCode, 'FL') + ', ' + ISNULL(ctr.ZipCode, '33486') AS 'ADDRESS'
,		ISNULL(ctr.Country, 'United States') AS 'COUNTRY'
,		ISNULL(ctr.AreaName, 'Corporate') AS 'AREA'
,		COALESCE(o.ObjectId, de.EmployeeGUID) AS 'EXTERNALID'
,		de.FirstName AS 'FIRSTNAME'
,       de.LastName AS 'LASTNAME'
,       COALESCE(o.UserLogin, REPLACE(de.UserLogin, ' ', '')) AS 'USERNAME'
,       ( COALESCE(o.UserLogin, REPLACE(de.UserLogin, ' ', '')) + CASE WHEN ctr.CenterNumber = 355 THEN '@hanswiemann.com' ELSE '@hcfm.com' END ) AS 'EMAIL'
,       '' AS 'PASSWORD'
,       ISNULL(eptg.EmployeePositionTrainingGroupDescription, '') AS '(Above)Unit'
,       ep.EmployeePositionDescription AS 'JOBNAME'
FROM    SQL01.HairClubCMS.dbo.datEmployee de
		INNER JOIN SQL01.HairClubCMS.dbo.cfgEmployeePositionJoin epj
			ON epj.EmployeeGUID = de.EmployeeGUID
        INNER JOIN SQL01.HairClubCMS.dbo.lkpEmployeePosition ep
            ON ep.EmployeePositionID = epj.EmployeePositionID
		LEFT OUTER JOIN @Center ctr
			ON CASE WHEN de.CenterID = 1002 THEN 238
				WHEN de.CenterID = 1080 THEN 297
				WHEN de.CenterID = 1001 THEN 355
				ELSE de.CenterID
			END = ctr.CenterNumber
        LEFT JOIN SQL01.HairClubCMS.dbo.datEmployeeCenter ec
            ON ec.EmployeeGUID = de.EmployeeGUID
        LEFT OUTER JOIN SQL01.HairClubCMS.dbo.lkpEmployeePositionTrainingGroup eptg
            ON eptg.EmployeePositionTrainingGroupID = ep.EmployeePositionTrainingGroupID
		LEFT OUTER JOIN @O365 o
			ON o.FirstName = de.FirstName
				AND o.LastName = de.LastName
WHERE	ISNULL(ec.CenterID, 100) LIKE '[123]%'
		AND de.FirstName NOT IN ( '_Test', 'Test', 'IT', 'Franchise', 'Ext', 'Laser', 'Surgery', 'Review', 'PRP', 'NCC', 'ITuser', 'Customer' )
		AND de.LastName IS NOT NULL
        AND de.IsActiveFlag = 1
        AND epj.IsActiveFlag = 1
GROUP BY CONVERT(VARCHAR, ISNULL(ctr.CenterNumber, 100)) + ' - ' + ISNULL(ctr.CenterName, 'Corporate')
,		ISNULL(ctr.Address1, '1499 W. Palmetto Park Road') + ', ' + ISNULL(ctr.Address2, 'Suite 111') + ', ' + ISNULL(ctr.City, 'Boca Raton') + ', ' + ISNULL(ctr.StateCode, 'FL') + ', ' + ISNULL(ctr.ZipCode, '33486')
,		ISNULL(ctr.Country, 'United States')
,		ISNULL(ctr.AreaName, 'Corporate')
,		COALESCE(o.ObjectId, de.EmployeeGUID)
,		de.FirstName
,       de.LastName
,       COALESCE(o.UserLogin, REPLACE(de.UserLogin, ' ', ''))
,		o.UserPrincipalName
,		ctr.CenterNumber
,       ISNULL(eptg.EmployeePositionTrainingGroupDescription, '')
,       ep.EmployeePositionDescription
UNION
SELECT  'BOSLEY' AS 'CENTER'
,		'9100 Wilshire Blvd, 9th Floor, Beverly Hills, CA 90212' AS 'ADDRESS'
,		'United States' AS 'COUNTRY'
,		'Bosley' AS 'AREA'
,		CONVERT(VARCHAR(36), tsbu.EmployeeGUID) AS 'EXTERNALID'
,		tsbu.FirstName AS 'FIRSTNAME'
,       tsbu.LastName AS 'LASTNAME'
,       tsbu.Username AS 'USERNAME'
,       tsbu.Email AS 'EMAIL'
,       tsbu.Password AS 'PASSWORD'
,       tsbu.AboveUnit AS '(Above)Unit'
,		tsbu.JobName AS 'JOBNAME'
FROM    tmpSchooxBosleyUsers tsbu

UNION
SELECT  '100 - Corporate' AS 'CENTER'
,		'1499 W. Palmetto Park Road, Suite 111, Boca Raton, FL, 33486' AS 'ADDRESS'
,		'United States' AS 'COUNTRY'
,		'Corporate' AS 'AREA'
,		'4C11FA45-7F1D-4E37-9D97-CE3B9F3BDAB5' AS 'EXTERNALID'
,		'Julie' AS 'FIRSTNAME'
,       'Doris' AS 'LASTNAME'
,       'JDoris' AS 'USERNAME'
,       'jdoris@hairclub.com' AS 'EMAIL'
,       '' AS 'PASSWORD'
,       'Call Center' AS '(Above)Unit'
,		'NCC Administrative Assistant' AS 'JOBNAME'

END
