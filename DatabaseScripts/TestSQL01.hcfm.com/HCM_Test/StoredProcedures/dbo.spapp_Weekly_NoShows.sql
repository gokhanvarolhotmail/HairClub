/* CreateDate: 12/19/2006 14:46:08.103 , ModifyDate: 03/20/2012 11:35:23.547 */
GO
/*
==============================================================================

PROCEDURE:				spapp_Weekly_NoShows

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Howard Abelow in CMS 2006

IMPLEMENTOR: 			Brian Kellman/ Howard Abelow

DATE IMPLEMENTED: 		 8/13/2007

LAST REVISION DATE: 	 9/28/2007

==============================================================================
DESCRIPTION:	Used to export weekly no shows.
==============================================================================

==============================================================================
NOTES: 	8/13/2007: Modified OnContacts version of spapp_NextDay_NoShows interface.
			9/28/2007 : HAbelow -  modified to reflect table changes
			10/30/2007: fixed bug in alt_center code
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_Weekly_NoShows
==============================================================================
*/

CREATE     PROC [dbo].[spapp_Weekly_NoShows]


AS

	--spapp_Weekly_NoShows
	INSERT INTO dbo.[hcmtbl_Noshows_ToExport] (
			[recordId]
		,	[firstName]
		,	[lastName]
		,	[email]
		,	[center]
		,	[apptDate]
		,	[apptTime]
		,	[gender]
		,	[creative]
		,	[type]
		,	[sendcount]
		,	[centerid]
		,	[langtype]
		)

	SELECT
			ec.[recordid]
		,	ec.[FirstName]
		,	ec.[LastName]
		,	ec.[Email]
		, 	ec.[CenterName] AS center
		,	ec.[ApptDate]
		,	ec.[ApptTime]
		,	ec.[Gender]
		,	'NS2' as creative
		,	'NOSHOW' as type
		,	1 as sendcount
		,	CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END AS centerid
		,	dbo.GETTYPECODE(info.[cst_language_code], info.[cst_gender_code]) as langtype
	FROM dbo.[hcmtbl_email_log] ec
		INNER JOIN [lead_info] info
			ON ec.[recordid] = info.[contact_id]
	WHERE
		DATEPART(WEEK, ec.[ApptDate])  = DATEPART(WEEK, DATEADD(WEEK, -2, GetDate()))
		AND ec.[Category] ='NS1'
		AND ec.status = 'SENT'
		AND NOT EXISTS(
			SELECT 1
			FROM oncd_activity a
				INNER JOIN oncd_activity_contact ac ON ac.activity_id =a.activity_id
					AND ec.[RecordID] = ac.contact_id
			WHERE
				a.due_date > CAST(ec.[ApptDate] as datetime) +'23:59:59'
				AND (a.action_code = 'APPOINT' OR a.result_code IN ('SHOWSALE','SHOWNOSALE','RECOVSALE'))
				)
		AND NOT EXISTS(
			SELECT 1
			FROM dbo.[hcmtbl_email_log] elog
			WHERE elog.recordid = ec.recordid
				AND elog.category = 'NS2'
				)


INSERT INTO dbo.[hcmtbl_Noshows_ToExport] (
			[recordId]
		,	[firstName]
		,	[lastName]
		,	[email]
		,	[center]
		,	[apptDate]
		,	[apptTime]
		,	[gender]
		,	[creative]
		,	[type]
		,	[sendcount]
		,	[centerid]
		,	[langtype]
		)

	SELECT
			ec.[recordid]
		,	ec.[FirstName]
		,	ec.[LastName]
		,	ec.[Email]
		, 	ec.[CenterName] AS center
		,	ec.[ApptDate]
		,	ec.[ApptTime]
		,	ec.[Gender]
		,	'NS2' as creative
		,	'NOSHOW' as type
		,	MAX(ec.sendcount) + 1 as sendcount
		,	CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END AS centerid
		,	dbo.GETTYPECODE(info.[cst_language_code], info.[cst_gender_code]) as langtype
	FROM dbo.[hcmtbl_email_log] ec
		INNER JOIN [lead_info] info
			ON ec.[recordid] = info.[contact_id]

	WHERE ec.[Category] ='NS2'
		AND ec.[status] = 'SENT'
		AND NOT EXISTS(
			SELECT *
			FROM oncd_activity a
				INNER JOIN oncd_activity_contact ac ON ac.activity_id =a.activity_id
					AND ec.[RecordID] = ac.contact_id
			WHERE
				a.due_date > CAST(ec.[ApptDate] as datetime) +'23:59:59'
				AND (a.action_code = 'APPOINT' OR a.result_code IN ('SHOWSALE','SHOWNOSALE','RECOVSALE'))
				)

		GROUP BY
				ec.[recordid]
			,	ec.[FirstName]
			,	ec.[LastName]
			,	ec.[Email]
			, 	ec.[CenterName]
			,	ec.[ApptDate]
			,	ec.[ApptTime]
			,	ec.[Gender]
			,	ec.[EmailType]
			,	info.[alt_center]
			,	info.territory
			,	info.[cst_language_code]
			,	info.[cst_gender_code]
		having MAX(ec.sendcount) < 10
GO
