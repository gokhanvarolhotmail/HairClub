/* CreateDate: 12/18/2006 15:52:59.817 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
/*

==============================================================================
PROCEDURE:                    spsvc_GetEmailAppointmentListByDate

VERSION:                      v1.0

DESTINATION SERVER:           HCSQL3\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:

DATE IMPLEMENTED:              9/24/2006

LAST REVISION DATE:      9/24/2007

==============================================================================
DESCRIPTION: Gets next day appts with emails
==============================================================================

==============================================================================
NOTES: 	9/24/2007: HAbelow testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spsvc_GetEmailAppointmentListByDate '9/26/2007'
==============================================================================

*/

CREATE PROCEDURE [dbo].[spsvc_GetEmailAppointmentListByDate]
	@apptdate datetime
AS

DECLARE @Appointments Table (
		recordid varchar(10)
	,	appt_date varchar(20)
	,	appt_time varchar(10)
	,	territory varchar(5)
	,	contact_fname varchar(25)
	,	email_ varchar(50)
	,	[type] char(2)
	)


INSERT INTO @Appointments
	 SELECT info.[contact_id] AS recordid,
			CONVERT(varchar(20), a.due_date, 107) AS 'appt_date',
			LTRIM(RIGHT(RTRIM(CONVERT(varchar(20), CAST(a.start_time AS smalldatetime), 100)),7)) AS 'appt_time',
			CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END  as territory,
			UPPER(SUBSTRING(RTRIM(info.[first_name]), 1, 1))
			+ LOWER(SUBSTRING(RTRIM(info.[first_name]), 2, 20)) as contact_fname,
			info.[email] AS email_,
			HCM.dbo.GETTYPECODE(info.[cst_language_code], info.[cst_gender_code]) as 'type'
	 FROM   HCM.dbo.oncd_activity a WITH ( NOLOCK )
			INNER JOIN HCM.dbo.oncd_activity_contact ac WITH ( NOLOCK )
				ON ac.activity_id = a.[activity_id]
			INNER JOIN HCM.dbo.[lead_info] info
				ON ac.[contact_id] = info.[contact_id]
	WHERE  dbo.ISAPPT(a.action_code) = 1
		AND a.due_date BETWEEN @ApptDate AND @ApptDate + '23:59:59'
		AND info.email IS NOT NULL
		AND LEN(info.email) <> 0

	INSERT INTO BOS.dbo.EmailConfirmations
		SELECT
			appts.recordid
		,	appts.appt_date
		,	appts.appt_time
		,	appts.territory
		,	appts.contact_fname
		,	appts.email_
		,	tblcenter.center
		,	tblcenter.Address1
		,	CASE WHEN LEN(tblcenter.Address2) > 0 OR tblcenter.Address2 IS NOT NULL THEN tblcenter.Address2 ELSE 'Main Entrance' END AS 'Address2'
		,	tblcenter.City
		,	tblcenter.State
		,	tblcenter.Zip
		,	tblcenter.Phone
		,	ISNULL(tblcenter.MapLink, 'Link is unavailable') as Maplink
		,	appts.[type]

		FROM @Appointments appts
			INNER JOIN [HCSQL2\SQL2005].HCFMDirectory.dbo.tblcenter tblcenter
				ON appts.territory = tblcenter.center_num

		ORDER BY appts.territory
		,	appts.appt_date
GO
