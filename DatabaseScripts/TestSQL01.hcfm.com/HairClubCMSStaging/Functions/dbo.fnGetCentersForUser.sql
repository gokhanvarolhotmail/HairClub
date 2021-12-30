/* CreateDate: 01/27/2011 22:24:13.713 , ModifyDate: 02/27/2017 09:49:37.273 */
GO
CREATE FUNCTION [dbo].[fnGetCentersForUser](
    @User varchar(100)
) RETURNS @Centers TABLE (CenterID int, CenterDescription nvarchar(200), CenterTypeID int, IsSurgeryCenter bit)

BEGIN


		--If they have access to ALL Centers
		IF EXISTS (SELECT DISTINCT ep.ActiveDirectoryGroup
					FROM lkpSecurityElement se
						INNER JOIN cfgSecurityGroup sg on se.SecurityElementID = sg.SecurityElementID
						INNER JOIN lkpEmployeePosition ep on sg.EmployeePositionID = ep.EmployeePositionID
						INNER JOIN cfgEmployeePositionJoin epj on ep.EmployeePositionID = epj.EmployeePositionID
						INNER JOIN datEmployee e on epj.EmployeeGUID = e.EmployeeGUID and e.UserLogin = @User
					WHERE se.SecurityElementDescriptionShort = 'ctrAll' AND sg.HasAccessFlag = 1)
		  BEGIN
			INSERT INTO @Centers (CenterID, CenterDescription, CenterTypeID, IsSurgeryCenter)
				SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription', CenterTypeID, CASE WHEN c.EmployeeDoctorGUID IS NULL THEN 0 ELSE 1 END AS IsSurgeryCenter
				FROM cfgCenter c
				WHERE c.IsActiveFlag = 1
		  END
		ELSE
		  BEGIN
			DECLARE @CenterID int
			SELECT TOP 1 @CenterID = CenterID FROM datEmployee WHERE UserLogin = @User

			--If they have access to all Centers in their REGION
			IF EXISTS(SELECT DISTINCT ep.ActiveDirectoryGroup
						FROM lkpSecurityElement se
							INNER JOIN cfgSecurityGroup sg on se.SecurityElementID = sg.SecurityElementID
							INNER JOIN lkpEmployeePosition ep on sg.EmployeePositionID = ep.EmployeePositionID
							INNER JOIN cfgEmployeePositionJoin epj on ep.EmployeePositionID = epj.EmployeePositionID
							INNER JOIN datEmployee e on epj.EmployeeGUID = e.EmployeeGUID and e.UserLogin = @User
						WHERE se.SecurityElementDescriptionShort = 'ctrReg' AND sg.HasAccessFlag = 1)
			  BEGIN
				INSERT INTO @Centers (CenterID, CenterDescription, CenterTypeID, IsSurgeryCenter)
					SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription', CenterTypeID,CASE WHEN c.EmployeeDoctorGUID IS NULL THEN 0 ELSE 1 END AS IsSurgeryCenter
					FROM cfgCenter c
					WHERE RegionID IN (
						SELECT c.RegionID
						FROM cfgCenter c
						WHERE c.IsActiveFlag = 1
							AND RegionID IS NOT NULL
							AND (c.CenterID = @CenterID OR c.ReportingCenterID = @CenterID)
						)
			  END

			--If they have access to all Centers in their DOCTOR REGION
			IF EXISTS(SELECT DISTINCT ep.ActiveDirectoryGroup
						FROM lkpSecurityElement se
							INNER JOIN cfgSecurityGroup sg on se.SecurityElementID = sg.SecurityElementID
							INNER JOIN lkpEmployeePosition ep on sg.EmployeePositionID = ep.EmployeePositionID
							INNER JOIN cfgEmployeePositionJoin epj on ep.EmployeePositionID = epj.EmployeePositionID
							INNER JOIN datEmployee e on epj.EmployeeGUID = e.EmployeeGUID and e.UserLogin = @User
						WHERE se.SecurityElementDescriptionShort = 'ctrDrReg' AND sg.HasAccessFlag = 1)
			  BEGIN
				INSERT INTO @Centers (CenterID, CenterDescription, CenterTypeID, IsSurgeryCenter)
					SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription', CenterTypeID, CASE WHEN c.EmployeeDoctorGUID IS NULL THEN 0 ELSE 1 END AS IsSurgeryCenter
					FROM cfgCenter c
					WHERE DoctorRegionID IN (
						SELECT c.DoctorRegionID
						FROM cfgCenter c
						WHERE c.IsActiveFlag = 1
							AND DoctorRegionID IS NOT NULL
							AND (c.CenterID = @CenterID OR c.ReportingCenterID = @CenterID)
						)
			  END

			--If they only have access to centers assigned to them in AD
			INSERT INTO @Centers (CenterID, CenterDescription, CenterTypeID, IsSurgeryCenter)
				SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription', CenterTypeID, CASE WHEN c.EmployeeDoctorGUID IS NULL THEN 0 ELSE 1 END AS IsSurgeryCenter
				FROM tmpGroupMember gm
					INNER JOIN cfgCenter c ON LEFT(gm.GroupName,3) = CAST(c.ReportingCenterID AS VARCHAR(3)) OR LEFT(gm.GroupName,3) = CAST(c.CenterID AS VARCHAR(3))
				WHERE c.IsActiveFlag = 1 AND gm.UserLogin = @User

		  END

		--Add Center Type Groups
		IF EXISTS(SELECT CenterID FROM @Centers WHERE CenterTypeID = 1 )
			BEGIN
				INSERT INTO @Centers(CenterID, CenterDescription, CenterTypeID)
					VALUES (1,'Corporate Centers', 1)
			END

		IF EXISTS(SELECT CenterID FROM @Centers WHERE CenterTypeID = 2 )
			BEGIN
				INSERT INTO @Centers(CenterID, CenterDescription, CenterTypeID )
					VALUES (2,'Franchise Centers', 2)
			END

		IF EXISTS(SELECT CenterID FROM @Centers WHERE CenterTypeID = 3  )
			BEGIN
				INSERT INTO @Centers(CenterID, CenterDescription, CenterTypeID)
					VALUES (3,'Joint Venture Centers', 3)
			END


RETURN
END
GO
