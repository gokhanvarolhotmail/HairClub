/***********************************************************************

PROCEDURE:				mtnActivityCloseOnClientSale

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		01/16/2017

LAST REVISION DATE: 	01/16/2017

--------------------------------------------------------------------------------------------------------
NOTES:  Closes a client's activities when they are a SALE

		* 01/16/2017	SAL - Created
		* 02/02/2017	SAL - Updated to include active employee and position for CRS check
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnActivityCloseOnClientSale '734E33F1-10EF-492B-9861-C3BAA1C2F224', 'aptak'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnActivityCloseOnClientSale]
	 @ClientGUID uniqueidentifier
	,@User nvarchar(25)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @ClosedActivityStatusID int
	DECLARE @SALENoBuyFollowUpActivityResultID int

	SELECT @ClosedActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'CLOSED'
	SELECT @SALENoBuyFollowUpActivityResultID = ActivityResultID FROM lkpActivityResult WHERE ActivityResultDescriptionShort = 'FLWUPPSL'

	--
	--Close all activites for client that are not closed, have a sub category of No Buy Follow Up, and are not assigned to a Customer Relation Specialist
	--
	UPDATE a
	SET ActivityStatusID = @ClosedActivityStatusID
		,ActivityResultID = @SALENoBuyFollowUpActivityResultID
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datActivity a
		inner join datClient c on a.ClientGUID = c.ClientGUID
		inner join lkpActivityStatus s on a.ActivityStatusID = s.ActivityStatusID
		inner join lkpActivitySubCategory sc on a.ActivitySubCategoryID = sc.ActivitySubCategoryID
	WHERE a.ClientGUID = @ClientGUID
		and s.ActivityStatusDescriptionShort <> 'CLOSED'
		and sc.ActivitySubCategoryDescriptionShort = 'NOBUYFLWUP'
		and a.AssignedToEmployeeGUID not in (select e.EmployeeGUID
												from datEmployee e
													inner join cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
													inner join lkpEmployeePosition ep on epj.EmployeePositionID = ep.EmployeePositionID
												where ep.EmployeePositionDescriptionShort = 'CRS'
													and e.IsActiveFlag = 1
													and epj.IsActiveFlag = 1)


END
