/* CreateDate: 01/03/2017 10:50:47.407 , ModifyDate: 01/03/2017 10:50:47.407 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSGetPastAppointments

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 12/09/2016

LAST REVISION DATE: 	 12/09/2016

==============================================================================
DESCRIPTION:	Used by cONEct! application to access On Contact data.
==============================================================================
NOTES:
		* 12/09/2016 MVT - Created (Moved from CMS DB)

==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSGetPastAppointments 292, '6/15/2015', '6/17/15'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSGetPastAppointments]
(
	@CenterID int,
	@StartDate datetime,
	@EndDate datetime
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT a.result_code
		, a.completion_date
		, a.activity_id
	FROM oncd_company co WITH(NOLOCK)
		INNER JOIN oncd_contact_company cc WITH(NOLOCK) ON cc.company_id = co.company_id AND cc.primary_flag = 'y' AND co.cst_center_number = CAST(@CenterID AS nchar(10))
		INNER JOIN oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
		INNER JOIN oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id
		INNER JOIN oncd_activity a WITH(NOLOCK) ON acon.activity_id = a.activity_id
	WHERE --CAST(CONVERT(varchar(10),a.due_date,101) as datetime)
		a.due_date BETWEEN @StartDate AND @EndDate
		AND a.action_code IN ('APPOint', 'INHOUSE', 'BEBACK')
END
GO
