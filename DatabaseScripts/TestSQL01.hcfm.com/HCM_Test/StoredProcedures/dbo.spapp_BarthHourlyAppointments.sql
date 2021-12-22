/* CreateDate: 11/28/2006 09:34:51.680 , ModifyDate: 05/01/2010 14:48:11.157 */
GO
/*
==============================================================================

PROCEDURE:				spapp_BarthHourlyAppointments

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Originally FROM CMS 2006

IMPLEMENTOR: 			Brian Kellman/HAbelow

DATE IMPLEMENTED: 		 8/10/2007

LAST REVISION DATE: 	10/3/2007

==============================================================================
DESCRIPTION:	Use to populate a FTP file for the Barth centers appointments
==============================================================================

==============================================================================
NOTES: 	8/10/2007: 	Modified OnContacts version of spapp_BarthHourlyAppointments to match original interface.
					Added Barth center filters.
			10/3/2007 HAbelow: Remodified to use lead_info
			03/31/08 KRM: changed hcfmdirectory connection to be to hcsql2\sql2005
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_BarthHourlyAppointments
==============================================================================
*/

CREATE PROCEDURE [dbo].[spapp_BarthHourlyAppointments] AS

DECLARE @StartDay DATETIME
DECLARE @EndDay DATETIME

DECLARE @BarthId INT

SET NOCOUNT ON

SET @StartDay = CAST(CONVERT(VARCHAR(11), GETDATE(), 121) + '00:00:00' AS DATETIME)
SET @EndDay =  CAST(CONVERT(VARCHAR(11), DATEADD(Day, 10, GETDATE()),121) + '23:59:59' AS DATETIME)
SET @BarthId  = 1

DECLARE @BarthCenters TABLE(
	Center VARCHAR(3)
,	CenterName VARCHAR(50)
	)
INSERT INTO @BarthCenters
	SELECT [Center_Num] , [Center]
		FROM [HCSQL2\SQL2005].HCFMDirectory.dbo.[tblCenter]  tblCenter
		WHERE tblCenter.[OwnerId] = @BarthId
			AND  tblCenter.[Center_Num] > 700--Barth


SELECT
		bc.Center + ' - ' + bc.CenterName  AS 'Center'
,		lead_info.contact_id AS 'RecordID' --'Contact ID'
,		RTRIM (lead_info.last_name) AS 'Last_Name'
,		RTRIM (lead_info.first_name)AS 'First_Name'
,		LEFT(a.due_date,11) AS 'Appt_Date'   --'Due Date'
,		RTRIM (RIGHT(a.start_time,7)) AS 'Appt_Time' --'Start Time'
,		dbo.ENTRYPOINT (lead_info.created_by_user_code) AS 'Source_type'
,		cs.source_code AS 'Source_Name'
,		RTRIM (lead_info.cst_promotion_code) AS 'Promo'
FROM [lead_info] WITH (NOLOCK)
	INNER JOIN oncd_activity_contact ac WITH (NOLOCK)
		ON [lead_info].[contact_id] = ac.[contact_id]
	INNER JOIN oncd_contact_source cs WITH (NOLOCK)
		ON cs.[contact_id] = [lead_info].[contact_id]
	INNER JOIN oncd_activity a WITH (NOLOCK)
		ON ac.[activity_id] = a.[activity_id]
	INNER JOIN @BarthCenters bc
		ON CASE WHEN lead_info.alt_center IS NULL OR LEN(LTRIM(lead_info.alt_center)) = 0 THEN lead_info.territory 	ELSE 	lead_info.alt_center 	END =
			bc.Center
WHERE
	a.due_date BETWEEN @StartDay AND @EndDay
	AND a.action_code = 'APPOINT'
ORDER BY bc.Center
GO
