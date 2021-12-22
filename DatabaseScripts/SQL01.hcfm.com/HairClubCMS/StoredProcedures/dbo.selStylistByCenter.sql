/***********************************************************************

PROCEDURE:				selStylistByCenter

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Rachelen Hut

DATE IMPLEMENTED: 		12/12/2013

LAST REVISION DATE: 	12/12/2013

--------------------------------------------------------------------------------------------------------
NOTES:
11/19/2014	RH	Added IsActiveFlag = 1 for Stylists - TrackIt #104881

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selStylistByCenter '255'

***********************************************************************/

CREATE PROCEDURE [dbo].[selStylistByCenter]
	@CenterID nvarchar(MAX)

AS
BEGIN
	SET NOCOUNT ON;



	SELECT e.[EmployeeGUID] AS 'SylistGUID'
		,	[EmployeeInitials] + ' - ' + EmployeeFullNameCalc AS 'Stylist'
		,	1 AS SortOrder
	FROM [dbo].[datEmployee] e
		INNER JOIN [dbo].[cfgEmployeePositionJoin] epj
			ON epj.EmployeeGUID = e.EmployeeGUID
		INNER JOIN [dbo].[lkpEmployeePosition] ep
			ON epj.EmployeePositionID = ep.EmployeePositionID
	WHERE ep.[CanScheduleStylist] = 1
		AND e.CenterID = @CenterID
		AND e.IsActiveFlag = 1
	UNION
	SELECT NULL, 'All', 0
	ORDER BY SortOrder
		,	Stylist

END
