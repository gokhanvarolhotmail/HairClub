/***********************************************************************

PROCEDURE:				mtnEmployeePositionAdd

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		10/08/09

LAST REVISION DATE: 	12/22/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Copy an existing Employee Position and associate Security Groups to create a new Position

		* 12/22/09 PRM - Added a call to execute the AD sync process at the end
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnEmployeePositionAdd

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnEmployeePositionAdd]
	@CopyEmployeePositionID int,
	@EmployeePositionID int,
	@EmployeePositionDescription nvarchar(50),
	@EmployeePositionDescriptionShort nvarchar(10),
	@ActiveDirectoryGroup nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS( SELECT 1 FROM lkpEmployeePosition WHERE EmployeePositionID = @EmployeePositionID)
	  BEGIN
		INSERT INTO lkpEmployeePosition ([EmployeePositionID], [EmployeePositionSortOrder], [EmployeePositionDescription], [EmployeePositionDescriptionShort], [ActiveDirectoryGroup], [IsAdministratorFlag], [CanScheduleFlag], [IsEmployeeOneFlag], [IsEmployeeTwoFlag], [IsEmployeeThreeFlag], [IsEmployeeFourFlag], [ApplicationTimeoutMinutes], [UseDefaultCenterFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser])
			SELECT @EmployeePositionID, 1 AS EmployeePositionSortOrder, @EmployeePositionDescription, @EmployeePositionDescriptionShort, @ActiveDirectoryGroup,
				IsAdministratorFlag, CanScheduleFlag, IsEmployeeOneFlag, IsEmployeeTwoFlag, IsEmployeeThreeFlag, IsEmployeeFourFlag,
				ApplicationTimeoutMinutes, UseDefaultCenterFlag,
				1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
			FROM lkpEmployeePosition
			WHERE EmployeePositionID = @CopyEmployeePositionID

		INSERT INTO cfgSecurityGroup ([EmployeePositionID], [SecurityElementID], [HasAccessFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser])
			SELECT @EmployeePositionID, SecurityElementID, HasAccessFlag,
				IsActiveFlag, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
			FROM cfgSecurityGroup
			WHERE EmployeePositionID = @CopyEmployeePositionID

		EXEC mtnEmployeePositionJoinImport
	  END
END
