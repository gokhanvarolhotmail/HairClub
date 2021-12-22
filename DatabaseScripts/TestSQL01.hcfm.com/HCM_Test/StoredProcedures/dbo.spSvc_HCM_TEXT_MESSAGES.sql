/* CreateDate: 07/28/2016 15:10:30.917 , ModifyDate: 08/02/2016 11:48:30.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_HCM_TEXT_MESSAGES
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/28/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_HCM_TEXT_MESSAGES
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_HCM_TEXT_MESSAGES]
AS
BEGIN

/* Create temp table objects */
DECLARE @OptIn TABLE (
	temp_id INT
,	contact_id NCHAR(10)
,	phone NCHAR(11)
,	created_by_user_code NCHAR(20)
,	appointment_activity_id NCHAR(10)
,   creation_date DATETIME
,   action NCHAR(6)
)


/* OptIn entries with no status are selected */
INSERT	INTO @OptIn
		SELECT  temp_id
		,       contact_id
		,       phone
		,       created_by_user_code
		,       appointment_activity_id
		,       creation_date
		,       action
		FROM    cstd_text_msg_temp WITH ( NOLOCK )
		WHERE   status IS NULL
				AND action = 'OPTIN'


/* Get Activities */
SELECT  UPPER(OC.first_name) AS 'FirstName'
,		OI.phone AS 'PhoneNumber'
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
        INNER JOIN @OptIn OI
            ON OI.contact_id = OC.contact_id
				AND OI.appointment_activity_id = OA.activity_id
WHERE   OA.action_code = 'APPOINT'
        AND ( OA.result_code IS NULL
              OR OA.result_code = '' )
ORDER BY OA.due_date DESC


/* Update Temp Table */
UPDATE  tmt
SET     status = 'TP'
FROM    cstd_text_msg_temp tmt
        INNER JOIN @OptIn OI
            ON OI.contact_id = tmt.contact_id
               AND OI.appointment_activity_id = tmt.appointment_activity_id
WHERE   tmt.status IS NULL
        AND tmt.action = 'OPTIN'

END
GO
