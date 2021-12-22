/* CreateDate: 12/31/2010 13:21:06.660 , ModifyDate: 02/27/2017 09:49:16.423 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaGetSecurityAccess

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/6/2010

LAST REVISION DATE: 	10/6/2010

--------------------------------------------------------------------------------------------------------
NOTES:  Use this to review security settings on the database
		* 12/01/10 PRM - Created stored proc
		* 07/19/12 MLM - Modified the lkpEmployeePosition Results to return a AD Group List
		* 08/10/12 MLM - Added IsMeasurementsBy, IsConsultant, IsTechnician Flags
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC dbaGetSecurityAccess

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaGetSecurityAccess] AS
  BEGIN


	DECLARE @SecurityElementID int
	DECLARE @SecurityElementDescription nvarchar(100)

	DECLARE @SQL nvarchar(max),
		@SQL_Select nvarchar(max),
		@SQL_Pivot nvarchar(max)

	CREATE TABLE #Security (
		EmployeePositionID int,
		EmployeePositionDescription nvarchar(100),
		SecurityElementID int,
		SecurityElementDescription nvarchar(100),
		HasAccessFlag int
	)

	INSERT INTO #Security (EmployeePositionID, EmployeePositionDescription, SecurityElementID, SecurityElementDescription, HasAccessFlag)
		SELECT ep.EmployeePositionID, ep.EmployeePositionDescription + ' (' + ISNULL(ep.ActiveDirectoryGroup,'n/a') + ')', se.SecurityElementID, CAST(se.SecurityElementID as nvarchar) + '-' + se.SecurityElementDescription, CAST(ISNULL(sg.HasAccessFlag,0) AS int)
		FROM lkpEmployeePosition ep
			INNER JOIN cfgSecurityGroup sg ON sg.EmployeePositionID = ep.EmployeePositionID
			INNER JOIN lkpSecurityElement se ON sg.SecurityElementID = se.SecurityElementID
	ORDER BY ep.EmployeePositionID

	--SELECT * FROM #Security

	DECLARE @SecurityElement_Cursor CURSOR
	SET @SecurityElement_Cursor = CURSOR FAST_FORWARD FOR
		SELECT SecurityElementID, SecurityElementDescription
		FROM #Security
		GROUP BY SecurityElementID, SecurityElementDescription
		ORDER BY SecurityElementID

	OPEN @SecurityElement_Cursor

	SET @SQL_Select = ''
	SET @SQL_Pivot = ''


	FETCH NEXT FROM @SecurityElement_Cursor INTO @SecurityElementID, @SecurityElementDescription

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		IF @SQL_Pivot <> ''
		  BEGIN
			SET @SQL_Select = @SQL_Select + ', '
			SET @SQL_Pivot = @SQL_Pivot + ', '
		  END

		SET @SQL_Select = @SQL_Select + 'MAX([' + @SecurityElementDescription + ']) AS [' + @SecurityElementDescription + ']'
		SET @SQL_Pivot = @SQL_Pivot + '[' + @SecurityElementDescription + ']'

		FETCH NEXT FROM @SecurityElement_Cursor INTO @SecurityElementID,@SecurityElementDescription
	  END

	CLOSE @SecurityElement_Cursor
	DEALLOCATE @SecurityElement_Cursor

	SET @SQL = 'SELECT EmployeePositionID, EmployeePositionDescription, '
				+ @SQL_Select + ' '
				+ 'FROM #Security '
				+ 'PIVOT (MAX(HasAccessFlag) FOR SecurityElementDescription IN (' + @SQL_Pivot + ') ) AS x '
				+ 'GROUP BY EmployeePositionID, EmployeePositionDescription '
				+ 'ORDER BY EmployeePositionID '

	EXECUTE(@SQL)

	DROP TABLE #Security


	Select  ep.EmployeePositionID, ep.EmployeePositionDescriptionShort, ep.EmployeePositionDescription,
			Stuff((
					Select  ',' +  ActiveDirectoryGroup
					From    cfgActiveDirectoryGroup adg
					inner join cfgActiveDirectoryGroupJoin adgj on adgj.ActiveDirectoryGroupID = adg.ActiveDirectoryGroupID
					Where ep.EmployeePositionID = adgj.EmployeePositionID
					For             XML Path('')
			), 1, 1, '') As ActiveDirectoryGroups,
			ep.IsAdministratorFlag, ep.CanScheduleFlag, ep.IsEmployeeOneFlag, ep.IsEmployeeTwoFlag, ep.IsEmployeeThreeFlag,
			ep.IsMeasurementsBy, ep.IsConsultant, ep.IsTechnician,
			ep.IsActiveFlag, ep.CreateDate, ep.CreateUser, ep.LastUpdate, ep.LastUpdateUser, ep.ApplicationTimeoutMinutes, ep.UseDefaultCenterFlag,
			ep.IsSurgeryCenterEmployeeFlag, ep.IsNonSurgeryCenterEmployeeFlag
	from lkpEmployeePosition ep
	GROUP BY ep.EmployeePositionID, ep.EmployeePositionDescriptionShort, ep.EmployeePositionDescription, ep.EmployeePositionDescriptionShort,
			ep.IsAdministratorFlag, ep.CanScheduleFlag, ep.IsEmployeeOneFlag, ep.IsEmployeeTwoFlag, ep.IsEmployeeThreeFlag,
			ep.IsMeasurementsBy, ep.IsConsultant, ep.IsTechnician,
			ep.IsActiveFlag, ep.CreateDate, ep.CreateUser, ep.LastUpdate, ep.LastUpdateUser, ep.ApplicationTimeoutMinutes, ep.UseDefaultCenterFlag,
			ep.IsSurgeryCenterEmployeeFlag, ep.IsNonSurgeryCenterEmployeeFlag
	ORDER BY ep.EmployeePositionID


	SELECT *
	FROM lkpSecurityElement
	ORDER BY SecurityElementID
END
GO
