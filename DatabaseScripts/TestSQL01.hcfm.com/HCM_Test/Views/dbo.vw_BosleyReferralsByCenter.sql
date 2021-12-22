/* CreateDate: 07/15/2015 13:36:50.733 , ModifyDate: 08/01/2015 10:30:51.230 */
GO
/***********************************************************************
VIEW:					vw_BosleyReferralsByCenter
DESTINATION SERVER:		SQL03
DESTINATION DATABASE: 	HCM
IMPLEMENTOR:			DLeiba
------------------------------------------------------------------------
NOTES:

07/15/2015 - DL - Initial Rewrite to SQL03.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_BosleyReferralsByCenter
***********************************************************************/
CREATE VIEW [dbo].[vw_BosleyReferralsByCenter]
AS

SELECT  ISNULL(OC.cst_siebel_id, '') AS 'SiebelID'
,       OC.contact_id
,       OC.creation_date
,       OCS.source_code
,       OC.last_name
,       OC.first_name
,       COM.cst_center_number
,		COM.company_name_1 AS 'Center'
,       A.action_code AS 'Action'
,       A.result_code AS 'Result'
,		CASE WHEN ISNULL(A.result_code, '') = '' THEN 'Appointment Scheduled for ' + CONVERT(VARCHAR(11), A.due_date, 101) ELSE '' END AS 'Notes'
FROM    oncd_contact OC
        INNER JOIN oncd_contact_source OCS
            ON OCS.contact_id = OC.contact_id
               AND OCS.primary_flag = 'Y'
        INNER JOIN oncd_contact_company OCC
            ON OCC.contact_id = OC.contact_id
               AND OCC.primary_flag = 'Y'
        INNER JOIN oncd_company COM
            ON COM.company_id = OCC.company_id
        OUTER APPLY ( SELECT TOP 1
                                OA.activity_id
                      ,         OA.creation_date
					  ,			OA.due_date
                      ,         OA.action_code
                      ,         OA.result_code
                      FROM      oncd_activity OA
                                INNER JOIN oncd_activity_contact OAC
                                    ON OAC.activity_id = OA.activity_id
                      WHERE     OA.result_code NOT IN ( 'CANCEL', 'RESCHEDULE', 'EXPIRED', 'DRCTCNFIRM', 'CALLBACK', 'COMPLETE' )
                                AND OAC.contact_id = OC.contact_id
                      ORDER BY  OA.due_date DESC
					  ,			OA.start_time DESC
                    ) A
WHERE   OCS.source_code = 'BOSREF'
        --AND OC.creation_date BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms,- 3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())+1, 0)))
GO
