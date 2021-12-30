/* CreateDate: 07/15/2015 13:38:17.780 , ModifyDate: 07/15/2015 13:38:17.780 */
GO
/***********************************************************************
VIEW:					vw_BosleyReferralsByClient
DESTINATION SERVER:		SQL03
DESTINATION DATABASE: 	HCM
IMPLEMENTOR:			DLeiba
------------------------------------------------------------------------
NOTES:

07/15/2015 - DL - Initial Rewrite to SQL03.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_BosleyReferralsByClient
***********************************************************************/
CREATE VIEW vw_BosleyReferralsByClient
AS

SELECT  OC.contact_status_code
,       OC.updated_date
,       OC.creation_date
,       OC.contact_id
,       OC.created_by_user_code
,       A.source_code
,       OC.last_name
,       OC.first_name
,		A.activity_id
,       A.result_code
,       ISNULL(OC.cst_siebel_id, '') AS 'cst_siebel_id'
,       A.sale_type_description AS 'SaleType'
FROM    oncd_contact OC
        INNER JOIN oncd_contact_company OCC
            ON OCC.contact_id = OC.contact_id
               AND OCC.primary_flag = 'Y'
        INNER JOIN oncd_company COM
            ON COM.company_id = OCC.company_id
        CROSS APPLY ( SELECT TOP 1
                                OA.activity_id
					,		CON.contact_id
					,		CS.source_code
                      ,         OA.creation_date
                      ,         OA.action_code
                      ,         OA.result_code
					  ,			CCC.sale_type_description
                      FROM      oncd_activity OA
                                INNER JOIN oncd_activity_contact OAC
                                    ON OAC.activity_id = OA.activity_id
                                INNER JOIN oncd_contact CON
                                    ON CON.contact_id = OAC.contact_id
                                INNER JOIN oncd_contact_source CS
                                    ON CS.contact_id = CON.contact_id
                                       AND CS.primary_flag = 'Y'
                                INNER JOIN cstd_contact_completion CCC
                                    ON CCC.activity_id = OAC.activity_id
                      WHERE     CS.source_code LIKE 'BOSREF%'
                                AND OA.result_code IN ( 'SHOWSALE' )
                                AND OAC.contact_id = OC.contact_id
                      ORDER BY  OA.due_date DESC
                      ,         OA.start_time DESC
                    ) A
WHERE   OC.creation_date BETWEEN '1/1/2013' AND DATEADD(ms,- 3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())+1, 0)))
        AND OC.contact_status_code = 'CLIENT'
GO
