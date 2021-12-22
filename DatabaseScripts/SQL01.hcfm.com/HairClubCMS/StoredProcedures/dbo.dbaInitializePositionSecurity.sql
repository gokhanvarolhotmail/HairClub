/***********************************************************************

PROCEDURE:				dbaInitializePositionSecurity

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		9/28/2010

LAST REVISION DATE: 	9/28/2010

--------------------------------------------------------------------------------------------------------
NOTES:  Use this script to grant permissions to stored procedures
		* 09/28/10 PRM - Created a script to drop all cfgSecurityGroup records and re-add them
		* 10/05/10 PRM - Updated script to begin development of v4.2
		* 11/29/10 PRM - Added Production & RTM positions and set their security
		* 12/21/10 PRM - Additional security updates (reports)
		* 01/10/10 PRM - Additional security updates (reports)
		* 01/14/10 PRM - Adjusted Copy permissions - turned back on
		* 01/31/11 MVT - Granted Center Access-All (8) to Medical Supervisors (position 15)
		* 03/11/11 MVT - Granted Access Appointement Management (18)(20) to Administration (IT) (position 7)
		* 03/21/11 MVT - Granted Access to Non Surgery Scheduler (12) to IT (position 7), Modified to
						grant admin access to 'Skyline_Web Development' (37) group
		* 04/07/11 MVT - Granted access to 'Center Access - All'(8) to Regional Technical Managers (position 26)
		* 04/14/11 MVT - Granted access to IT and Skyline to 'Access in Development' (28) security element.
		* 05/25/11 MVT - Modified to exclude access to security element (10) for positions (5,6,13,16,18,20)
		* 06/20/11 MVT - Modified to grant access to security elements (2,8) for position (38) 'Advertising Dept'
		* 04/24/12 MLM - Modified to grant access to security elements (31,32,33,34,35,36,37)
		* 06/13/12 MLM - Removed Security Element 37 - Download Fees, Users who have Security Element 36 have rights to download Fees
		* 06/13/12 MLM - Combined Security Elements 34 & 35 into one general Center Admin EFT Secuity Element accCtrEFT
		* 06/21/12 MLM - Added Employee Positions 39 & 40.
		* 07/18/12 MLM - Added Security Element 37, Admin Support
		* 07/26/12 MLM - Changed Security for System Admin, Only available for positions 7,12, 36, 37, 39, 40
		* 08/01/12 MLM - Added Employee Positions 15 & 23 to Security Element 31 - Accesss CenterAdministration
		* 08/01/12 MLM - Removed Security Element 32 - Access Center Panel - Administration Panel
		* 08/10/12 MLM - Remove EmployeePositions (Ventilator, Assistant Manager, Senior Adminstrator, Joint Venture Medical Assistant Supervisors, Regional Surgery Sales Manager, Stylist - EXT, Franchise Managers, Assistant Regional Directors)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaInitializePositionSecurity

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaInitializePositionSecurity]
AS

BEGIN
	DECLARE @SecurityElementID int


	--Remove all records from table and recreate each time
	DELETE FROM cfgSecurityGroup


	--Access Client Scheduler
	SET @SecurityElementID = 1

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (1,4,5,6,7,8,9,11,12,14,15,16,17,18,19,21,23,26,34,37,39,40)


	--Access Client
	SET @SecurityElementID = 2

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (1,4,5,6,7,8,9,11,12,14,15,16,17,18,19,21,23,26,34,36,37,39,40)


	--Access Sales Order
	SET @SecurityElementID = 3

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (5,6,7,15,16,18,21,23,34,37,40)


	--Access Administration
	SET @SecurityElementID = 4

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,12,36,37,39,40)


	--Access Reports
	SET @SecurityElementID = 5

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,11,12,14,15,16,18,19,21,23,26,27,29,31,32,33,34,36,37,39,40)


	--Access Admin - Inventory Control
	SET @SecurityElementID = 6

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,36,37)

	--Modify Client
	SET @SecurityElementID = 7

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,9,11,14,15,16,17,18,19,21,23,26,34,37,40)


	--Center Access - All
	SET @SecurityElementID = 8

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,11,12,14,15,26,27,36,37,38,39,40)


	--Center Access - Region
	SET @SecurityElementID = 9

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (15,26,31,32,34)


	--Center Access - Doctor Region
	SET @SecurityElementID = 10

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (8,9,15,17,19,21,23,26)


	--Modify Admin Center Scheduler
	SET @SecurityElementID = 11

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (6,7,11,14,15,16,34,37,40)


	--Modify Client NonSurgery Scheduler
	SET @SecurityElementID = 12

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37,40)


	--View Client NonSurgery Scheduler
	SET @SecurityElementID = 13

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	--UPDATE cfgSecurityGroup
	--SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	--WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37)


	--Access Admin - Administration
	SET @SecurityElementID = 14

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37)


	--Access Admin - Accounting
	SET @SecurityElementID = 15

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,12,37,39)


	--Modify Admin Employee Scheduler
	SET @SecurityElementID = 16

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (6,7,11,14,15,16,34,37,40)


	--View Client Surgery Scheduler
	SET @SecurityElementID = 17

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,8,9,11,14,15,16,17,18,19,21,23,34,37,40)


	--Access Appointment Management
	SET @SecurityElementID = 18

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37)


	--Access Hair Order
	SET @SecurityElementID = 19

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,11,12,14,16,18,19,26,27,29,31,32,33,34,36,37,39,40)


	--Manage Sales Consultation
	SET @SecurityElementID = 20

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37)


	--View Client Doctor Scheduler
	SET @SecurityElementID = 21

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,8,9,11,14,15,16,17,18,19,21,23,34,37,40)


	--Modify Client Surgery Scheduler
	SET @SecurityElementID = 22

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (5,6,7,9,11,14,15,16,17,18,21,23,34,37,40)


	--Modify Hair Order
	SET @SecurityElementID = 23

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,16,18,19,26,27,29,31,33,36,37,40)


	--Manage Client Membership
	SET @SecurityElementID = 24

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (5,6,7,14,15,16,21,23,37,40)


	--Access Center Admin - Operations
	SET @SecurityElementID = 25

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (6,7,8,11,14,15,16,18,21,23,34,37)


	--Modify HSO Hold
	SET @SecurityElementID = 26

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,36,37,40)


	--Modify Priority Hair System Order
	SET @SecurityElementID = 27

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,27,36,37,40)


	--Access In Development
	SET @SecurityElementID = 28

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37)

	--Modify Hair System Order - Copy
	SET @SecurityElementID = 30

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (4,5,6,7,16,18,19,26,27,29,31,33,36,37,40)

	/** Live Security Settings **/

	--Access CenterManagement
	SET @SecurityElementID = 31

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (5,6,7,11,15,16,18,21,23,32,34,37)

	--Center Admin - Accounting Panel
	SET @SecurityElementID = 33

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (6,7,11,37)

	--Access Center Admin - EFT
	SET @SecurityElementID = 34

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (6,7,11,37)

	--Access Admin Fee Management
	SET @SecurityElementID = 36

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7,37,39)


	--Access Admin Support
	SET @SecurityElementID = 37

	INSERT INTO cfgSecurityGroup (EmployeePositionID, SecurityElementID, HasAccessFlag, IsActiveFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT EmployeePositionID, @SecurityElementID, 0, 1, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa' FROM lkpEmployeePosition ORDER BY EmployeePositionID

	UPDATE cfgSecurityGroup
	SET HasAccessFlag = 1, LastUpdate = GETUTCDATE(), LastUpdateUser = 'sa'
	WHERE SecurityElementID = @SecurityElementID AND EmployeePositionID IN (7, 40)



END
