/* CreateDate: 02/25/2009 08:42:35.497 , ModifyDate: 02/27/2017 09:49:26.027 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptApptServices

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Get Appt. Services data for Appointment report - Select the top 3.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptApptServices '0C4E1BF8-73CA-4800-A2F7-92047CB1DC24'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptApptServices]
	@AppointmentGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

    SELECT Top(3)
		sc.SalesCodeDescription
	FROM datAppointmentDetail ad
		INNER JOIN cfgSalesCode sc ON ad.SalesCodeID = sc.SalesCodeID
	WHERE ad.AppointmentGUID = @AppointmentGUID
	ORDER BY sc.SalesCodeSortOrder ASC

END
GO
