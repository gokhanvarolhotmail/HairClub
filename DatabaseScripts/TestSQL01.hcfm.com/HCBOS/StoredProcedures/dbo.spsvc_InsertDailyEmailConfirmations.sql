/* CreateDate: 08/09/2007 14:53:25.033 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
/*

==============================================================================
PROCEDURE:                    spsvc_InsertDailyEmailConfirmations

VERSION:                      v1.0

DESTINATION SERVER:           HCTESTSQL1\SQL2005

DESTINATION DATABASE:   HCM

RELATED APPLICATION:    OnContact

AUTHOR:                       Howard Abelow

IMPLEMENTOR:                 Howard Abelow

DATE IMPLEMENTED:              9/26/2007

LAST REVISION DATE:      9/26/2007

==============================================================================
DESCRIPTION: INserts the log of next day appt confirmations with emails sent to IMS
==============================================================================

==============================================================================
NOTES:  9/26/2007: HAbelow modified to work with new schema - testing/debugging
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spsvc_InsertDailyEmailConfirmations
==============================================================================

*/


CREATE PROCEDURE [dbo].[spsvc_InsertDailyEmailConfirmations]

AS
	INSERT INTO HCM.dbo.[hcmtbl_email_log] (
		[RecordID],
		[Email],
		[ApptDate],
		[ApptTime],
		[CenterName],
		[FirstName],
		[EmailType],
		[Status]

	)
	SELECT
		recordid
	,	email
	,	appt_date
	,	appt_time
	,	center
	,	contact_fname
	,	'ApptNotify'
	,	'SENT'
	FROM
		dbo.EmailConfirmations
GO
