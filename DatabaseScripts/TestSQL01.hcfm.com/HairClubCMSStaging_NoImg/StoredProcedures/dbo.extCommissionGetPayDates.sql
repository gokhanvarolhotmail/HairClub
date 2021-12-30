/* CreateDate: 04/08/2015 07:54:29.013 , ModifyDate: 04/08/2015 07:54:29.013 */
GO
/***********************************************************************

PROCEDURE:				extCommissionGetPayDates

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		4/03/2015

LAST REVISION DATE: 	4/03/2015

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used for getting the pay dates for commission management equal to or greater than
		the date passed in.

		* 04/03/2015 SAL - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC extCommissionGetPayDates '04/01/2015'

***********************************************************************/

CREATE PROCEDURE [dbo].extCommissionGetPayDates (@StartDate datetime)

AS
BEGIN
	SET NOCOUNT ON

	SELECT PayDate
	FROM Commission_lkpPayPeriods_TABLE
	WHERE PayDate >= @StartDate
	ORDER BY PayDate

END
GO
