/* CreateDate: 02/25/2009 08:43:06.097 , ModifyDate: 12/16/2019 08:40:04.590 */
GO
/***********************************************************************

PROCEDURE:                    mtnEmployeePositionJoinImport

DESTINATION SERVER:           SQL01

DESTINATION DATABASE:   HairClubCMS

RELATED APPLICATION:    CMS

AUTHOR:                       Dan Lorenz

IMPLEMENTOR:                  Dan Lorenz

DATE IMPLEMENTED:             4/1/09

LAST REVISION DATE:
                                    4/1/09 - DL: Created script to sync employee position records with AD
                                    5/13/09 - PRM: Updated script to maintain datEmployee records along with the employee positions
                                    7/8/09 - AS: Added check so the proc doesn't run on the dev or staging servers
                                    10/2/09 - PRM: Added last update statement to change the Inactive UserLogin's to
                                                      append _INACTIVE to them as a temporary fix so they don't cause an error in
                                                      the Admin Scheduler
                                    10/12/09 - PRM: Previous fix was concatinating _INACTIVE to userlogins multiple times in final step
                                    12/22/09 - PRM: Added a temporary fix for issue 577/583 to cleanup ClientHomeCenterID's on refund orders
                                    12/22/09 - PRM: Removed temporary fix for issue 577/583 to cleanup ClientHomeCenterID's on refund orders (after new version release)
                                    01/12/10 - PRM: Added logic for non-surgery centers to NOT reset their CenterID based on Reporting Center field / Added flag to lkpEmpPos table
                                    06/02/10 - PRM: Changed logic to default employees to Non-Surgery unless they are specifically a Surgery employee such as doctor's & ma's
                                    10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
                                    12/08/10 - MLM: Changed the Default Center to 100, Added IsNonSurgerCenterEmployeeFlag
                                    12/10/10 – MLM: Fixed Issue with Non-Surgery Employees not getting assigned correctly
									12/20/10 - MLM: Fixed Issue with order of precedence
									12/20/10 - MLM: Fixed Issue with CenterID on the datEmployee getting set incorrectly when a UserLogin has multiple roles.
									01/03/10 - MLM: Changed the INNER JOIN for Surgery Employees to correctly update the Employee Table
									01/03/10 - MLM: Added a IF check to only process IT Employees on the Test Server.
									01/13/10 - PRM: Commented out logic to not import employees on HairClubCMSTest site
									06/28/12 - MLM: Added Logic to populate table datEmployeeCenter
									07/18/12 - MLM: Added Section to populate the cfgActiveDirectoryGroup & cfgActiveDirectoryGroupJoin Tables
									07/27/12 - MLM: Modfied the Proc manage a single Employee at a time
									08/06/12 - MLM: Removed the Proc to populate EmployeeCenters.  Now done in the Cursor.
									08/22/12 - MLM: Fixed Issue with Default Center
									08/22/12 - MLM: Only adding centers to datEmployeeCenter where they below to specified AD Group. (No longer adding centers with reporting center relationship)
									08/28/12 - MLM: Remove the ServerName check.
									10/26/12 - MLM: Added EmployeePayrollID to datEmployee Table and mtnActiveDirectoryImport
									09/10/13 - MLM: Fixed Issue With InActive Employees Not being Added when rehired, ActiveDirectorySID needed to be cleared when employee is set to _INACTIVE.
									10/28/13 - MLM: Added IsActiveFlag to EmployeeCenter so InActive Employees can be viewed in Scheduler.
									11/07/13 - MLM: Fixed Issue With Center 100 not being Active.
									12/09/13 - MLM: Fixed Issue with datEmployeeCenters not being set inactive correctly.
									12/17/13 - MLM: Added IsActiveFlag to cfgEmployeePositionJoin so InActive Employees can be viewed in the Scheduler
									10/15/15 - MVT: HC added 100-Corp AD group and associated all Center 100 employees to that group.  Modified the logic to use
													the standard process to assign Center 100 employees.
									10/16/15 - MVT: Modified to check for the datEmployeeCenter IsActive Flag in queries that update
													datEmployee
									09/13/17 - MVT: Modified to use Center Number instead of Center ID to join employees to Centers (TFS #9584)
									11/07/17 - MVT: Modified to use ADSID and ActiveDirectorySID when joining mtnActiveDirectoryImport to datEmployee instead of
													UserLogin for user_cursor cursor.  Change is made to account for Username changes in AD.  #9878
									10/24/18 - MVT: Modified proc to only update Employee, Employee Position, and Employee Center records if a change is detected.
													Version of this proc prior to this change is attached to the TFS #11465
													Also added Try/Catch Error checking to prevent issue of [dbo].[cfgActiveDirectoryGroupJoin] from getting deleted in a
													scenario where an error occurs running AD Sync.
									03/13/19 - MVT: Modified the Employee Update to also check Employee Payroll ID for NULL when comparing if it changed (TFS #12135).
									12/02/19 - SAL: Modified to add updating/setting of datEmployee.EmployeeTitleID (TFS #13501)

--------------------------------------------------------------------------------------------------------
NOTES:      Updates the employee records with current data from AD
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnEmployeePositionJoinImport

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnEmployeePositionJoinImport]

AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY
      --------------------------------------------------------------------
      -- Clear old data from CMS database
      --------------------------------------------------------------------

      --Clear the temp AD Import Table
      DELETE FROM mtnActiveDirectoryImport

  --    --Clear the IsActiveFlag for employee positions
  --    Update cfgEmployeePositionJoin
		--SET IsActiveFlag = 0
		--	,lastUpdate = GETUTCDATE()
		--	,LastUpdateUser = 'emp-import'
	 -- FROM cfgEmployeePositionJoin

	  -- Load the cfgActiveDirectoryGroup table with all AD Groups
	  exec mtnCreateActiveDirectoryGroup

      --------------------------------------------------------------------
      -- Declare variables
      --------------------------------------------------------------------
      -- used for AD Group Cursor / Employee Position
      DECLARE @EmployeePositionId int
      DECLARE @ActiveDirectoryGroup nvarchar(50)
      DECLARE @UpdateUser nvarchar(25) = 'cmsEmployeeImport'

      -- Insert all AD Users in Groups Associated with CMS and insert them into the temp AD Import table
      DECLARE @Group_Cursor cursor

	 SET @Group_Cursor = CURSOR FAST_FORWARD FOR
	 SELECT adgj.EmployeePositionId, ad.ActiveDirectoryGroup
	 FROM cfgActiveDirectoryGroupJoin adgj
		INNER JOIN cfgActiveDirectoryGroup ad on adgj.ActiveDirectoryGroupID = ad.ActiveDirectoryGroupID
	 WHERE ad.ActiveDirectoryGroup IS NOT NULL


      OPEN @Group_Cursor
      FETCH NEXT FROM @Group_Cursor
      INTO @EmployeePositionId, @ActiveDirectoryGroup

      WHILE @@FETCH_STATUS = 0
        BEGIN

            EXEC selADEmployeesForSync @ActiveDirectoryGroup, @EmployeePositionId


            FETCH NEXT FROM @Group_Cursor
            INTO @EmployeePositionId, @ActiveDirectoryGroup
        END

      CLOSE @Group_Cursor
      DEALLOCATE @Group_Cursor

      --Insert new users from the AD import table
      INSERT INTO datEmployee (EmployeeGUID, UserLogin, ActiveDirectorySID, CenterID, FirstName, LastName, EmployeeInitials, EmployeePayrollID, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
      SELECT NEWID(), ADUserLogin, ADSID, CenterID, ADFirstName, ADLastName, EmployeeInitials, EmployeePayrollID, 0, GETUTCDATE(), @UpdateUser, GETUTCDATE(), @UpdateUser
      FROM (
            SELECT DISTINCT  ADUserLogin, ADSID, CenterID, ADFirstName, ADLastName, EmployeeInitials, EmployeePayrollID
            FROM mtnActiveDirectoryImport
            WHERE NOT ADSID IN (
                  SELECT ActiveDirectorySID
                  FROM datEmployee
                  WHERE ActiveDirectorySID IS NOT NULL
            )
      ) subQuery


      --Insert Missing employee positions
      INSERT INTO cfgEmployeePositionJoin (EmployeeGUID, EmployeePositionID, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
            SELECT DISTINCT e.EmployeeGUID, adi.EmployeePositionID, 1, GETUTCDATE(), @UpdateUser, GETUTCDATE(), @UpdateUser
            FROM mtnActiveDirectoryImport adi
                  INNER JOIN datEmployee e ON adi.ADSID = e.ActiveDirectorySID
				  LEFT OUTER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID AND adi.EmployeePositionID = epj.EmployeePositionID
            WHERE adi.EmployeePositionID IS NOT NULL
				AND epj.EmployeeGUID IS NULL

	    -- Activate only if currently inactive
		Update epj
			SET IsActiveFlag = 1
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		FROM cfgEmployeePositionJoin epj
			inner join datEmployee e on epj.EmployeeGUID = e.EmployeeGUID
			inner join mtnActiveDirectoryImport adi on epj.EmployeePositionID = adi.EmployeePositionID and adi.ADSID = e.ActiveDirectorySID
		WHERE adi.EmployeePositionID IS NOT NULL
			AND epj.IsActiveFlag = 0

		-- Deactivate only if currently active
		Update epj
			SET IsActiveFlag = 0
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		FROM cfgEmployeePositionJoin epj
			inner join datEmployee e on epj.EmployeeGUID = e.EmployeeGUID
			LEFT join mtnActiveDirectoryImport adi on epj.EmployeePositionID = adi.EmployeePositionID and adi.ADSID = e.ActiveDirectorySID
		WHERE adi.EmployeePositionID IS NULL
			AND epj.IsActiveFlag = 1


	    DECLARE @User VARCHAR(100)
	    DECLARE @EmployeeGUID CHAR(36)

		DECLARE user_cursor CURSOR FAST_FORWARD FOR
		SELECT DISTINCT AD.ADUserLogin, e.EmployeeGUID
		FROM mtnActiveDirectoryImport AD
			INNER JOIN datEmployee e on ad.ADSID = e.ActiveDirectorySID


		-- Create Temp Table to track Employee Centers.  This table
		-- is then used to insert/update datEmployeeCenter table
		DECLARE @EmployeeCenters TABLE
		(
		  EmployeeGUID uniqueidentifier,
		  CenterID int
		)

		OPEN user_cursor

		FETCH NEXT FROM user_cursor
		INTO @User, @EmployeeGUID

		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @user = REPLACE(@User, '''','''''''''')

			EXEC mtnCreateEmployeeActiveDirectoryGroupJoin @User, @EmployeeGUID

			INSERT INTO @EmployeeCenters (
				EmployeeGUID,
				CenterID)
			SELECT DISTINCT @EmployeeGUID, c.CenterID
			FROM cfgEmployeeActiveDirectoryGroupJoin gJoin
				INNER JOIN cfgActiveDirectoryGroup adGroup on gJoin.ActiveDirectoryGroupID = adGroup.ActiveDirectoryGroupID
				--INNER JOIN cfgCenter c ON LEFT(adGroup.ActiveDirectoryGroup,3) = CAST(c.CenterNumber AS VARCHAR(3))
				INNER JOIN cfgCenter c ON TRY_CAST(SUBSTRING(adGroup.ActiveDirectoryGroup, 0, CHARINDEX('-', adGroup.ActiveDirectoryGroup)) AS Int) = c.CenterNumber
			WHERE c.IsActiveFlag = 1 AND gJOin.EmployeeGUID = @EmployeeGUID


			FETCH NEXT FROM user_cursor
			INTO @User, @EmployeeGUID
		END
		CLOSE user_cursor;
		DEALLOCATE user_cursor;

		-- Insert/Update Employee Center records.
		INSERT INTO [dbo].[datEmployeeCenter](EmployeeCenterGUID, EmployeeGUID, CenterId, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT NEWID(), e.EmployeeGUID, e.CenterID, 1, GETUTCDATE(), @UpdateUser, GETUTCDATE(), @UpdateUser
		FROM @EmployeeCenters e
			LEFT OUTER JOIN datEmployeeCenter ec on ec.CenterID = e.CenterID AND ec.EmployeeGUID = e.EmployeeGUID
		WHERE ec.EmployeeCenterGUID IS NULL

		-- Activate EmployeeCenter Records
		Update ec
			SET IsActiveFlag = 1
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		from datEmployeeCenter ec
			inner join @EmployeeCenters e ON e.EmployeeGUID = ec.EmployeeGUID AND e.CenterID = ec.CenterID
		WHERE ec.IsActiveFlag = 0

		-- Deactivate EmployeeCenter Records
		Update ec
			SET IsActiveFlag = 0
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		from datEmployeeCenter ec
			left join @EmployeeCenters e ON e.EmployeeGUID = ec.EmployeeGUID AND e.CenterID = ec.CenterID
		WHERE ec.IsActiveFlag = 1 AND e.EmployeeGUID IS NULL



		--Convert Center number from AD to CMS CenterID and set the employee initials
		--    we must convert center numbers and watch out for invalid data
		UPDATE mtnActiveDirectoryImport
		SET CenterID =
			CASE WHEN c.CenterID IS NULL THEN 0
					ELSE c.CenterID
			END,
			EmployeeInitials = LEFT(LTRIM(ISNULL(ADFirstName, '')), 1) + LEFT(LTRIM(ISNULL(ADLastName, '')), 1)
		FROM mtnActiveDirectoryImport adi
			LEFT JOIN cfgCenter c ON TRY_CAST(adi.ADCenter AS int) = c.CenterNumber


		-- if an employee exists in AD without a home center assigned to them, set them to the default center per HC's request
		DECLARE @DefaultCenterID int
		SET @DefaultCenterID = 100

		--Any Centers that aren't valid, but the employee pos UseDefaultCenterFlag is true, reset to the default center
		UPDATE adi
		SET CenterID = @DefaultCenterID
		FROM mtnActiveDirectoryImport adi
			INNER JOIN lkpEmployeePosition ep ON adi.EmployeePositionID = ep.EmployeePositionID
		WHERE NOT CenterID IN (
			SELECT CenterID
			FROM cfgCenter
			WHERE IsActiveFlag = 1
		)
			AND ep.UseDefaultCenterFlag = 1


		-- Create Temp Table to track Active Employees.  This table
		-- is then used to
		DECLARE @ActiveEmployees TABLE
		(
		  EmployeeGUID uniqueidentifier,
		  ADUserLogin nvarchar(50),
		  ADFirstName nvarchar(50),
		  ADLastName nvarchar(50),
		  EmployeeInitials nvarchar(10),
		  EmployeePayrollID nvarchar(20),
		  CenterID int,
		  EmployeeTitleID int
		)

		INSERT INTO @ActiveEmployees
		(
			 EmployeeGUID
			,ADUserLogin
			,ADFirstName
			,ADLastName
			,EmployeeInitials
			,EmployeePayrollID
			,CenterID
			,EmployeeTitleID
		)
		SELECT
			 e.EmployeeGUID
			,imp.ADUserLogin
			,imp.ADFirstName
			,imp.ADLastName
			,imp.EmployeeInitials
			,imp.EmployeePayrollID
			,c.CenterID
			,imp.EmployeeTitleID
		FROM datEmployee  e
				INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
				INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
				LEFT OUTER JOIN cfgCenter c on imp.CenterID = c.CenterID
			WHERE ep.IsNonSurgeryCenterEmployeeFlag = 1
				AND e.EmployeeGUID IN (Select DISTINCT EmployeeGUID
										FROM datEmployeeCenter
										WHERE IsActiveFlag = 1)

		INSERT INTO @ActiveEmployees
		(
			 EmployeeGUID
			,ADUserLogin
			,ADFirstName
			,ADLastName
			,EmployeeInitials
			,EmployeePayrollID
			,CenterID
			,EmployeeTitleID
		)
		SELECT
			 e.EmployeeGUID
			,imp.ADUserLogin
			,imp.ADFirstName
			,imp.ADLastName
			,imp.EmployeeInitials
			,imp.EmployeePayrollID
			,c.CenterID
			,imp.EmployeeTitleID
		FROM datEmployee  e
				INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
				INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
				LEFT OUTER JOIN cfgCenter c on imp.CenterID = c.CenterID
			WHERE ep.IsSurgeryCenterEmployeeFlag = 1
				AND ep.IsNonSurgeryCenterEmployeeFlag = 0
				AND e.EmployeeGUID IN (Select DISTINCT ec.EmployeeGUID
										FROM datEmployeeCenter ec
										INNER JOIN cfgCenter c on ec.CenterID = c.CenterID
										WHERE NOT c.EmployeeDoctorGUID IS NULL
											AND ec.IsActiveFlag = 1)

		INSERT INTO @ActiveEmployees
		(
			 EmployeeGUID
			,ADUserLogin
			,ADFirstName
			,ADLastName
			,EmployeeInitials
			,EmployeePayrollID
			,CenterID
			,EmployeeTitleID
		)
		SELECT
			 e.EmployeeGUID
			,imp.ADUserLogin
			,imp.ADFirstName
			,imp.ADLastName
			,imp.EmployeeInitials
			,imp.EmployeePayrollID
			,@DefaultCenterID
			,imp.EmployeeTitleID
		FROM datEmployee  e
				INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
				INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
				INNER JOIN cfgSecurityGroup sg on ep.EmployeePositionID = sg.EmployeePositionID
				INNER JOIN lkpSecurityElement se on sg.SecurityElementID = se.SecurityElementID
			WHERE se.SecurityElementDescriptionShort  = 'ctrAll'
				AND e.EmployeeGUID NOT IN (Select DISTINCT EmployeeGUID
										FROM datEmployeeCenter
										WHERE IsActiveFlag = 1)


		-- Activate if something changed or currently inactive
		UPDATE e
		SET UserLogin = x_active.ADUserLogin,
			FirstName = x_active.ADFirstName,
			LastName = x_active.ADLastName,
			EmployeeInitials = x_active.EmployeeInitials,
			EmployeePayrollID = x_active.EmployeePayrollID,
			CenterId = x_active.CenterID,
			IsActiveFlag = 1,
			EmployeeTitleID = x_active.EmployeeTitleID,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @UpdateUser
		FROM datEmployee  e
				CROSS APPLY (
					SELECT TOP(1) ae.*
					FROM @ActiveEmployees ae
					WHERE ae.EmployeeGUID = e.EmployeeGUID
				) x_active
			WHERE e.USerLogin <> x_active.ADUserLogin
					OR e.FirstName <> x_active.ADFirstName
					OR e.LastName <> x_active.ADLastName
					OR e.EmployeeInitials <> x_active.EmployeeInitials
					OR (e.EmployeePayrollID IS NULL AND x_active.EmployeePayrollID IS NOT NULL)
					OR (e.EmployeePayrollID IS NOT NULL AND x_active.EmployeePayrollID IS NULL)
					OR (e.EmployeePayrollID IS NOT NULL AND x_active.EmployeePayrollID IS NOT NULL AND e.EmployeePayrollID <> x_active.EmployeePayrollID)
					OR (e.CenterID IS NOT NULL AND x_active.CenterID IS NULL)
					OR (e.CenterID IS NULL AND x_active.CenterID IS NOT NULL)
					OR (e.CenterID IS NOT NULL AND x_active.CenterID IS NOT NULL AND e.CenterID <> x_active.CenterID)
					OR (e.IsActiveFlag IS NULL OR e.IsActiveFlag = 0)
					OR (e.EmployeeTitleID IS NULL AND x_active.EmployeeTitleID IS NOT NULL)
					OR (e.EmployeeTitleID IS NOT NULL AND x_active.EmployeeTitleID IS NULL)
					OR (e.EmployeeTitleID IS NOT NULL AND x_active.EmployeeTitleID IS NOT NULL AND e.EmployeeTitleID <> x_active.EmployeeTitleID)

		-- De-activate if not in the @ActiveEmployee Table.
		UPDATE e
		SET IsActiveFlag = 0,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @UpdateUser
		FROM datEmployee  e
				OUTER APPLY (
					SELECT TOP(1) ae.*
					FROM @ActiveEmployees ae
					WHERE ae.EmployeeGUID = e.EmployeeGUID
				) o_active
			WHERE o_active.EmployeeGUID IS NULL
					AND e.IsActiveFlag = 1


		/*
		---- Activate if something changed or currently inactive
		--UPDATE e
		--SET UserLogin = imp.ADUserLogin,
		--		FirstName = imp.ADFirstName,
		--		LastName = imp.ADLastName,
		--	EmployeeInitials = imp.EmployeeInitials,
		--	EmployeePayrollID = imp.EmployeePayrollID,
		--	CenterId = c.CenterID ,
		--	IsActiveFlag = 1,
		--	LastUpdate = GETUTCDATE(),
		--	LastUpdateUser = 'cmsEmployeeImport'
		--FROM datEmployee  e
		--		INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
		--		INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
		--		LEFT OUTER JOIN cfgCenter c on imp.CenterID = c.CenterID
		--	WHERE ep.IsNonSurgeryCenterEmployeeFlag = 1
		--		AND e.EmployeeGUID IN (Select DISTINCT EmployeeGUID
		--								FROM datEmployeeCenter
		--								WHERE IsActiveFlag = 1)
		--		AND (
		--			e.USerLogin <> imp.ADUserLogin
		--			OR e.FirstName <> imp.ADFirstName
		--			OR e.LastName <> imp.ADLastName
		--			OR e.EmployeeInitials <> imp.EmployeeInitials
		--			OR e.EmployeePayrollID <> imp.EmployeePayrollID
		--			OR (e.CenterID IS NOT NULL AND c.CenterID IS NULL)
		--			OR (e.CenterID IS NULL AND c.CenterID IS NOT NULL)
		--			OR (e.CenterID IS NOT NULL AND c.CenterID IS NOT NULL AND e.CenterID <> c.CenterID)
		--			OR e.IsActiveFlag = 0
		--		)

		--UPDATE e
		--SET UserLogin = imp.ADUserLogin,
		--		FirstName = imp.ADFirstName,
		--		LastName = imp.ADLastName,
		--	EmployeeInitials = imp.EmployeeInitials,
		--	EmployeePayrollID = imp.EmployeePayrollID,
		--	CenterId = c.CenterID ,
		--	IsActiveFlag = 1,
		--	LastUpdate = GETUTCDATE(),
		--	LastUpdateUser = 'cmsEmployeeImport'
		--FROM datEmployee  e
		--		INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
		--		INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
		--		LEFT OUTER JOIN cfgCenter c on imp.CenterID = c.CenterID
		--	WHERE ep.IsSurgeryCenterEmployeeFlag = 1
		--		AND ep.IsNonSurgeryCenterEmployeeFlag = 0
		--		AND e.EmployeeGUID IN (Select DISTINCT ec.EmployeeGUID
		--								FROM datEmployeeCenter ec
		--								INNER JOIN cfgCenter c on ec.CenterID = c.CenterID
		--								WHERE NOT c.EmployeeDoctorGUID IS NULL
		--									AND ec.IsActiveFlag = 1)
		--		AND (
		--			e.USerLogin <> imp.ADUserLogin
		--			OR e.FirstName <> imp.ADFirstName
		--			OR e.LastName <> imp.ADLastName
		--			OR e.EmployeeInitials <> imp.EmployeeInitials
		--			OR e.EmployeePayrollID <> imp.EmployeePayrollID
		--			OR (e.CenterID IS NOT NULL AND c.CenterID IS NULL)
		--			OR (e.CenterID IS NULL AND c.CenterID IS NOT NULL)
		--			OR (e.CenterID IS NOT NULL AND c.CenterID IS NOT NULL AND e.CenterID <> c.CenterID)
		--			OR e.IsActiveFlag = 0
		--		)

		----Activate User(s) that Access to all centers.
		--UPDATE e
		--SET UserLogin = imp.ADUserLogin,
		--		FirstName = imp.ADFirstName,
		--		LastName = imp.ADLastName,
		--	EmployeeInitials = imp.EmployeeInitials,
		--	EmployeePayrollID = imp.EmployeePayrollID,
		--	CenterId = @DefaultCenterID,
		--	IsActiveFlag = 1,
		--	LastUpdate = GETUTCDATE(),
		--	LastUpdateUser = 'cmsEmployeeImport'
		--FROM datEmployee  e
		--		INNER JOIN mtnActiveDirectoryImport imp ON e.ActiveDirectorySID = imp.ADSID
		--		INNER JOIN lkpEmployeePosition ep ON imp.EmployeePositionID = ep.EmployeePositionID
		--		INNER JOIN cfgSecurityGroup sg on ep.EmployeePositionID = sg.EmployeePositionID
		--		INNER JOIN lkpSecurityElement se on sg.SecurityElementID = se.SecurityElementID
		--	WHERE se.SecurityElementDescriptionShort  = 'ctrAll'
		--		AND e.EmployeeGUID NOT IN (Select DISTINCT EmployeeGUID
		--								FROM datEmployeeCenter
		--								WHERE IsActiveFlag = 1)
		--		AND (
		--				e.USerLogin <> imp.ADUserLogin
		--				OR e.FirstName <> imp.ADFirstName
		--				OR e.LastName <> imp.ADLastName
		--				OR e.EmployeeInitials <> imp.EmployeeInitials
		--				OR e.EmployeePayrollID <> imp.EmployeePayrollID
		--				OR e.CenterID IS NULL
		--				OR e.CenterID <> @DefaultCenterID
		--				OR e.IsActiveFlag = 0
		--			)
		*/

		--Update Inactive Employee records that multiple employee records with the same UserLogin (this causes an error in the Admin Scheduler)
		UPDATE datEmployee
		SET UserLogin = UserLogin + '_INACTIVE'
				,ActiveDirectorySID = NULL
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		WHERE IsActiveFlag = 0
			AND UserLogin IN (
					SELECT UserLogin
					FROM datEmployee
					WHERE NOT UserLogin IS NULL
						AND NOT UserLogin LIKE '%_INACTIVE'
					GROUP BY UserLogin
					HAVING COUNT(*) > 1
			)


		--Remove Inactive/Deleted Employees
		Update datEmployeeCenter
			SET IsActiveFlag = 0
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @UpdateUser
		FROM datEmployeeCenter
		WHERE EmployeeGUID NOT IN (SELECT EmployeeGUID FROM datEmployee WHERE IsActiveFlag = 1)
			AND IsActiveFlag = 1

		--Remove EmployeeCenter Records Where they are InActive and there are no Future Appointments in said Center
		--DELETE FROM datEmployeeCenter WHERE EmployeeCenterGUID IN
		--				(SELECT DISTINCT EmployeeCenterGUID
		--				from datEmployeeCenter ec
		--					INNER JOIN datAppointment a on ec.CenterID = a.CenterID
		--								AND a.AppointmentDate > GETUTCDATE()
		--					LEFT OUTER JOIN datAppointmentEmployee ae on ec.EmployeeGUID = ae.EmployeeGUID
		--								AND a.AppointmentGUID = ae.AppointmentGUID
		--				WHERE ec.IsActiveFlag = 0
		--					AND ae.AppointmentEmployeeGUID IS NULL )

      	DELETE FROM cfgEmployeeActiveDirectoryGroupJoin WHERE EmployeeGUID NOT IN (SELECT EmployeeGUID FROM datEmployee WHERE IsActiveFlag = 1)

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO
