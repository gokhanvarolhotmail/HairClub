/* CreateDate: 08/09/2007 14:51:14.387 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

==============================================================================
PROCEDURE:                    spsvc_GetCallCenterAppointmentswEmailLast24Hours

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:

DATE IMPLEMENTED:              9/24/2006

LAST REVISION DATE:      9/24/2007

==============================================================================
DESCRIPTION: Gets last 24 hour appts appts with emails
==============================================================================

==============================================================================
NOTES: 	9/24/2007: HAbelow testing/debugging
		03/31/2008: KRM - Changed hcfmdirectory connection string to hcsql2\sql2005
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spsvc_GetCallCenterAppointmentswEmailLast24Hours
==============================================================================

*/

CREATE PROCEDURE [dbo].[spsvc_GetCallCenterAppointmentswEmailLast24Hours]
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
			CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END as territory,
			UPPER(SUBSTRING(RTRIM(info.[first_name]), 1, 1))
			+ LOWER(SUBSTRING(RTRIM(info.[first_name]), 2, 20)) as contact_fname,
			info.[email] AS email_,
			HCM.dbo.GETTYPECODE(info.[cst_language_code], info.[cst_gender_code]) as 'type'
	 FROM   HCM.dbo.oncd_activity a WITH ( NOLOCK )
			INNER JOIN HCM.dbo.oncd_activity_contact ac WITH ( NOLOCK )
				ON ac.activity_id = a.[activity_id]
			INNER JOIN HCM.dbo.[lead_info] info
				ON ac.[contact_id] = info.[contact_id]

	WHERE  dbo.ISAPPT(a.action_code) = 1 AND a.[result_code] NOT IN ( 'CANCEL', 'RESCHEDULE')
				AND a.creation_date >=  CAST(CONVERT(VARCHAR(11), GetDate()) AS datetime)
				AND info.email IS NOT NULL
				AND a.[created_by_user_code] NOT IN ( 'TM 600')
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
