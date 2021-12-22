/***********************************************************************

PROCEDURE:				selStylist
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	Conect
AUTHOR: 				Rachelen Hut
DATE IMPLEMENTED: 		11/19/2014
LAST REVISION DATE: 	11/19/2014

--------------------------------------------------------------------------------------------------------
NOTES: 	This stored procedure populates the drop-down for the DailyStylistSchedule.rdl

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selStylist '255'

***********************************************************************/

CREATE PROCEDURE [dbo].[selStylist]
	@CenterID nvarchar(MAX)

AS
BEGIN
	SET NOCOUNT ON;


SELECT e.[EmployeeGUID] SylistGUID
        , [EmployeeInitials] + ' - ' + EmployeeFullNameCalc Stylist
        , 3 SortOrder
    FROM [dbo].[datEmployee] e
        INNER JOIN [dbo].[cfgEmployeePositionJoin] epj ON epj.EmployeeGUID = e.EmployeeGUID
        INNER JOIN [dbo].[lkpEmployeePosition] ep on epj.EmployeePositionID = ep.EmployeePositionID
    WHERE ep.[CanScheduleStylist] = 1
        AND e.CenterID = @CenterID
		AND e.IsActiveFlag = 1
     UNION
         SELECT NULL, 'All', 0
     UNION
         SELECT '00000000-0000-0000-0000-000000000000', 'All Grouped - 1 page per Stylist', 1
	UNION
	SELECT '00000000-0000-0000-0000-000000000001', 'All Stylist - Grouped', 2
		 ORDER BY SortOrder,Stylist

END
