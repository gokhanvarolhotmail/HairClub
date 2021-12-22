/* CreateDate: 08/10/2006 13:53:11.123 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	** spdts_get_scheduled_appointments **
	Finds all appointments scheduled going out
	the number of days passed in
	Created: 	5/3/2006
	Created By: 	Howard Abelow
	Modified By:	MJW 2006-12-20
			Rewrite for ONCV schema
*/
/*

==============================================================================
PROCEDURE:                    spdts_get_scheduled_appointment

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:                  Brian Kellman

DATE IMPLEMENTED:              5/3/2006

LAST REVISION DATE:      8/20/2007

==============================================================================
DESCRIPTION: Finds all appointments scheduled going out the number of days passed in
==============================================================================

==============================================================================
NOTES:      8/13/2007: Modified to run in the BOS database(Post OnContact modification)
	    8/20/2007: MJW (ONcontact) modified for performance improvements
		9/24/2007: HAbelow testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spdts_get_scheduled_appointments 1
==============================================================================

*/

CREATE         PROCEDURE [dbo].[spdts_get_scheduled_appointments]
	 @days int
AS


INSERT  INTO dbo.appointments_scheduled
        SELECT  center,
                apptdate,
                appttime,
                COUNT(*)
        FROM    ( SELECT
                            CAST(CASE WHEN ISNULL(info.alt_center, 0) > 0  THEN info.alt_center ELSE info.territory END  AS int) AS center,
                            CONVERT(varchar(10), a.due_date, 101) AS apptdate,
                            SUBSTRING(CONVERT(varchar(19), a.start_time, 120),
                                      12, 5) AS appttime
                  FROM      HCM.dbo.oncd_activity a WITH (NOLOCK)
                            INNER JOIN HCM.dbo.[oncd_activity_contact] ac WITH (NOLOCK) ON ac.activity_id = a.activity_id
                            INNER JOIN HCM.dbo.[lead_info] info WITH (NOLOCK) ON ac.contact_id = info.contact_id
                  WHERE     ( ( a.due_date BETWEEN DateAdd(day, 0, GETDATE())
                                           AND     DateAdd(day, @days,
                                                           GETDATE()) )
                              OR ( a.due_date BETWEEN DateAdd(day, -1, GETDATE())
                                              AND     DateAdd(day, 0, GETDATE())
                                   AND CONVERT(char(5), a.start_time, 8) > Convert(char(5), GetDate(), 8)
                                 )
                            )
                            AND a.action_code = 'APPOINT'
							AND (a.[result_code] NOT IN ('CANCEL', 'RESCHEDULE', 'CTREXCPTN') OR a.[result_code] IS NULL)
                ) temp
        WHERE   center IS NOT NULL
                AND apptdate IS NOT NULL
                AND appttime IS NOT NULL
        GROUP BY center,
                apptdate,
                appttime
        ORDER BY center,
                apptdate,
                appttime
GO
