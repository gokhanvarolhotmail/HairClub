/* CreateDate: 07/29/2016 10:55:46.527 , ModifyDate: 08/02/2016 11:50:47.647 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_BulkOptIn_Temp]
AS
SELECT  UPPER(OC.first_name) AS 'FirstName'
,		x_OI.phone AS 'PhoneNumber'
,       CONVERT(VARCHAR(11), OA.due_date, 101) + ' ' + CONVERT(VARCHAR(11), OA.start_time, 108) AS 'AppointmentDate'
,       OA.cst_time_zone_code AS 'Timezone'
,       COM.company_name_1 AS 'CenterName'
,       OC.cst_language_code AS 'LanguageCode'
FROM    oncd_activity OA WITH ( NOLOCK )
        INNER JOIN oncd_activity_contact OAC WITH ( NOLOCK )
            ON OAC.activity_id = OA.activity_id
        INNER JOIN oncd_contact OC WITH ( NOLOCK )
            ON OC.contact_id = OAC.contact_id
        INNER JOIN oncd_activity_company AC WITH ( NOLOCK )
            ON AC.activity_id = OA.activity_id
        INNER JOIN oncd_company COM WITH ( NOLOCK )
            ON COM.company_id = AC.company_id
        CROSS APPLY ( SELECT    tml.log_id
                      ,         tml.contact_id
                      ,         tml.phone
                      ,         tml.created_by_user_code
                      ,         tml.appointment_activity_id
                      ,         tml.creation_date
                      ,         tml.[action]
                      FROM      cstd_text_msg_log tml
                      WHERE     tml.[action] = 'OPTIN'
                                AND tml.contact_id = OC.contact_id
                                AND tml.appointment_activity_id = OA.activity_id
                    ) x_OI
WHERE   OA.action_code = 'APPOINT'
        AND OA.due_date >= '8/1/2016'
        AND ( OA.result_code IS NULL
              OR OA.result_code = '' )
GO
