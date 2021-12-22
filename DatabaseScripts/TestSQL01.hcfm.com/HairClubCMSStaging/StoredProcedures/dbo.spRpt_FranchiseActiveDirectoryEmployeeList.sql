/* CreateDate: 09/04/2014 08:59:40.810 , ModifyDate: 10/04/2017 13:34:04.200 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spRpt_FranchiseActiveDirectoryEmployeeList
-- Procedure Description:	Returns a query resultset from the [Clients] table.
--
-- Created By:				Marlon Burrell
-- Date Created:			06/02/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
===============================================================================================
NOTES: The report has a parameter (NOT the stored procedure)
@ReportType = 1 for "Owner/Center", 2 for "Owner/Role"
===============================================================================================
CHANGE HISTORY:
06/23/2011 - MB - Removed the word "Ops" from role group descriptions per DR
06/28/2011 - MB - Added grouping option for report per DR
02/05/2014 - MB - Removed "Technician" role from results (# 97326)
09/12/2017 - SL - Updated select AS 'CenterName' to return CenterDescriptionFullCalc
10/03/2017 - RH - (#143564) Changed logic to find the CenterDescriptionFullCalc and retain only one employee

SAMPLE EXECUTION:

EXEC spRpt_FranchiseActiveDirectoryEmployeeList
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_FranchiseActiveDirectoryEmployeeList]
AS
BEGIN
SET NOCOUNT ON
SET FMTONLY OFF

DECLARE @RegionCount INT
,	@RegionTotal INT
,	@CenterCount INT
,	@CenterTotal INT
,	@SQL VARCHAR(8000)
,	@CurrentRegion VARCHAR(150)
,	@CurrentCenter VARCHAR(150)
,	@UserCount INT
,	@UserTotal INT
,	@CurrentUser VARCHAR(150)
,	@CurrentUserPath VARCHAR(150)
,	@CurrentUserRole VARCHAR(5000)

SET @RegionCount = 1
SET @CenterCount = 1
SET @UserCount = 1

--Create temp tables
CREATE TABLE #FranchiseRegions (
	RecordID INT IDENTITY(1,1)
,	GroupName VARCHAR(150)
)

CREATE TABLE #FranchiseCenters (
	RecordID INT IDENTITY(1,1)
,	RegionName VARCHAR(150)
,	CenterName VARCHAR(150)
)

CREATE TABLE #FranchiseUsers (
	RecordID INT IDENTITY(1,1)
,	RegionName VARCHAR(150)
,	CenterName VARCHAR(150)
,	UserName VARCHAR(150)
,	UserFullName VARCHAR(150)
,	RoleName VARCHAR(150)
)

--CREATE TABLE #UserCounts (
--	UserName VARCHAR(150)
--,	UserCount INT
--)

CREATE TABLE #ADPath (
	ADPath VARCHAR(200)
)

CREATE TABLE #UserRole (
	UserRole VARCHAR(200)
)

CREATE TABLE #Franchise(
RegionName NVARCHAR(50)
,	CenterName NVARCHAR(50)
,	UserName NVARCHAR(150)
,	UserFullName NVARCHAR(250)
,	RoleName NVARCHAR(250)
,	UserCount INT
)

--Insert Franchise Groups
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Allan')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Barth')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Bucci')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Champagne')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Hogan')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Lachman')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Strepman')
INSERT INTO #FranchiseRegions (GroupName) VALUES ('Region_Vitellio')

--Get count of total regions
SET @RegionTotal = (SELECT MAX(RecordID) FROM #FranchiseRegions)


--Loop through regions to get center groups that belong to each
WHILE @RegionCount <= @RegionTotal
BEGIN
	SET @CurrentRegion = (SELECT GroupName FROM #FranchiseRegions WHERE RecordID = @RegionCount)

	--Build SQL string to get members of given group
	SET @SQL = '
		SELECT ''' + @CurrentRegion + '''
		,	sAMAccountname
		FROM OPENQUERY(ADSI,''
			SELECT sAMAccountname
			FROM ''''LDAP://OU=HAIRCLUB,DC=hcfm,DC=com''''
			WHERE memberOf=''''CN=' + @CurrentRegion + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
		)
		WHERE LEFT(sAMAccountname, 3) LIKE ''[78]%''
	'

	INSERT INTO #FranchiseCenters (RegionName, CenterName)
	EXEC (@SQL)

	SET @RegionCount = @RegionCount + 1
END


--Get total count of center groups to retrive users
SET @CenterTotal = (SELECT MAX(RecordID) FROM #FranchiseCenters)

WHILE @CenterCount <= @CenterTotal
BEGIN
	SET @CurrentRegion = (SELECT RegionName FROM #FranchiseCenters WHERE RecordID = @CenterCount)
	SET @CurrentCenter = (SELECT CenterName FROM #FranchiseCenters WHERE RecordID = @CenterCount)

		--Build SQL string to get members of given group
		SET @SQL = '
			SELECT ''' + @CurrentRegion + '''
			,	''' + @CurrentCenter + '''
			,	sAMAccountname
			,	CN
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				,	CN
				FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
				WHERE memberOf=''''CN=' + @CurrentCenter + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
			)
		'
		INSERT INTO #FranchiseUsers (RegionName, CenterName, UserName, UserFullName)
		EXEC (@SQL)

	SET @CenterCount = @CenterCount + 1
END


--Get total count of users
SET @UserTotal = (SELECT MAX(RecordID) FROM #FranchiseUsers)

WHILE @UserCount <= @UserTotal
BEGIN
	SET @CurrentUser = (SELECT UserName FROM #FranchiseUsers WHERE RecordID = @UserCount)
	SET @CurrentUser = REPLACE(@CurrentUser, '''', '''''''''')
	SET @CurrentUserRole = ''


	--Build SQL string to get AD Path based on user specified
	SET @SQL = '
		SELECT REPLACE(ADSPath,''LDAP://'', '''') ADSPath
		FROM OPENQUERY(ADSI,''
			SELECT sAMAccountname
			,	ADSPath
			FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
			WHERE sAMAccountname=''''' + @CurrentUser + '''''''
		)
	'
	INSERT INTO #ADPath
	EXEC (@SQL)

	SET @CurrentUserPath = (SELECT ADPath FROM #ADPath)


	--Build SQL string to get groups based on AD Path
	SET @SQL = '
		SELECT sAMAccountname AS ''Group''
		FROM OPENQUERY(ADSI,''
			SELECT sAMAccountname
			FROM ''''LDAP://OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
			WHERE member=''''' + REPLACE(@CurrentUserPath, '''', '''''''''') + '''''''
		)
		WHERE sAMAccountname LIKE ''Role%''
	'
	INSERT INTO #UserRole
	EXEC (@SQL)

	SELECT @CurrentUserRole = COALESCE(@CurrentUserRole + ', ' + UserRole, UserRole)
	FROM #UserRole

	SET @CurrentUserRole = CASE WHEN LEN(@CurrentUserRole)>=2 THEN RIGHT(@CurrentUserRole, LEN(@CurrentUserRole)-2) ELSE @CurrentUserRole END

	UPDATE #FranchiseUsers
	SET RoleName = REPLACE(REPLACE(@CurrentUserRole, 'Role_', ''), 'OPS ', '')
	WHERE UserName = @CurrentUser

	DELETE FROM #ADPath
	DELETE FROM #UserRole

	SET @CurrentUserRole = ''
	SET @UserCount = @UserCount + 1
END


INSERT INTO #Franchise
SELECT MIN(tblOwner.RegionDescription) AS 'RegionName'
,	NULL AS 'CenterName'
,	#FranchiseUsers.UserName
,	#FranchiseUsers.UserFullName
,	#FranchiseUsers.RoleName
,	1 AS 'UserCount'
FROM #FranchiseUsers
	INNER JOIN cfgCenter tblcenter
		ON CONVERT(INT, LEFT(#FranchiseUsers.CenterName, 3)) = tblcenter.CenterID
	INNER JOIN lkpRegion tblOwner
		ON tblCenter.RegionID = tblOwner.RegionID
WHERE #FranchiseUsers.UserFullName NOT LIKE 'TEST%'
	AND #FranchiseUsers.RoleName NOT IN ('Technician')
GROUP BY #FranchiseUsers.UserName
,	UserFullName
,	RoleName
ORDER BY MIN(tblOwner.RegionDescription)
,	MIN(CONVERT(VARCHAR, tblcenter.CenterID) + ' - ' + tblcenter.CenterDescription)
,	#FranchiseUsers.UserFullName


/*********** Update table with CenterName ************************************/

UPDATE FR
SET FR.CenterName = FRU.CenterName
FROM #Franchise FR
INNER JOIN #FranchiseUsers FRU
	ON FR.UserName = FRU.UserName
WHERE FR.CenterName IS NULL

/*********** Find CenterDescriptionFullCalc ************************************/

SELECT FR.RegionName
,	FR.CenterName
,	FR.UserName
,	FR.UserFullName
,	FR.RoleName
,	FR.UserCount
,	CTR.CenterDescriptionFullCalc
FROM #Franchise FR
INNER JOIN dbo.cfgCenter CTR
	ON LEFT(FR.CenterName,3) = CTR.CenterID

END
GO
