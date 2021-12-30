/* CreateDate: 09/21/2017 16:05:05.480 , ModifyDate: 10/30/2017 12:04:22.423 */
GO
-- =============================================
-- Author:		Daniel Polania
-- Create date: 09/21/2017
-- Description:	Gathers all activites since 2013 to be ingested by Salesforce
-- =============================================
CREATE PROCEDURE [dbo].[oncd_contact_activities_salesforce]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @startdate DATETIME = '20130101',
            @date2016 DATETIME = '20161231 23:59:59';

    --Grab all contact ids and related activity ids with action code of Appoint and a activity type of null since 2013
    SELECT OAC.contact_id,
           OA.activity_id
    INTO #contacts
    FROM HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.activity_id = OA.activity_id
    WHERE OA.action_code = 'APPOINT'
          AND OA.cst_activity_type_code IS NULL
          AND OAC.creation_date >= @startdate
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N';;

    --Grab all activities with result code 'CANCEL', 'RESCHEDULE', 'APPOINT', 'RECOVERY' and action code 'APPOINT', 'BEBACK', 'INHOUSE' since 2013
    SELECT OA.activity_id,
           RTRIM(ISNULL(OA.action_code, '')) AS action_code,
           RTRIM(ISNULL(OA.cst_activity_type_code, '')) AS cst_activity_type_code,
           RTRIM(OA.result_code) AS result_code,
           OA.creation_date,
           OA.due_date,
           OAC.contact_id,
           OA.updated_date,
           OA.start_time,
           RTRIM(OA.created_by_user_code) AS created_by_user_code,
           OA.completion_date,
           OA.completion_time,
           RTRIM(OAU.user_code) AS user_code,
           OA.completed_by_user_code,
           ROW_NUMBER() OVER (PARTITION BY c.contact_id,
                                           OA.completion_date,
                                           OAU.user_code
                              ORDER BY c.contact_id,
                                       OA.completion_date,
                                       OAU.user_code
                             ) AS rn
    INTO #Calls
    FROM HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
        LEFT JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.activity_id = OA.activity_id
        LEFT JOIN HCM.dbo.oncd_activity_user AS OAU WITH (NOLOCK)
            ON OAU.activity_id = OA.activity_id
               AND OAU.primary_flag = 'Y'
        INNER JOIN #contacts AS c WITH (NOLOCK)
            ON c.contact_id = OAC.contact_id
    WHERE OA.result_code IN ( 'CANCEL', 'RESCHEDULE', 'APPOINT', 'RECOVERY' )
          AND OA.action_code NOT IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
          AND OAC.creation_date >= @startdate
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N'
    ORDER BY c.contact_id,
             OA.completion_date,
             OAU.user_code;

    --Grab all activities with action code ( 'APPOINT', 'BEBACK', 'INHOUSE' )
    SELECT OA.activity_id,
           RTRIM(ISNULL(OA.action_code, '')) AS action_code,
           RTRIM(ISNULL(OA.cst_activity_type_code, '')) AS cst_activity_type_code,
           RTRIM(ISNULL(OA.result_code, '')) AS result_code,
           OA.creation_date,
           OA.due_date,
           OAC.contact_id,
           OA.updated_date,
           OA.start_time,
           RTRIM(OA.created_by_user_code) AS created_by_user_code,
           OA.completion_date,
           OA.completion_time,
           OAU.user_code,
           OA.completed_by_user_code,
           ROW_NUMBER() OVER (PARTITION BY c.contact_id,
                                           OA.creation_date,
                                           OAU.user_code
                              ORDER BY c.contact_id,
                                       OA.creation_date,
                                       OAU.user_code,
                                       OA.result_code DESC
                             ) AS rn
    INTO #APPT
    FROM HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
        LEFT JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.activity_id = OA.activity_id
        LEFT JOIN HCM.dbo.oncd_activity_user AS OAU WITH (NOLOCK)
            ON OAU.activity_id = OA.activity_id
               AND OAU.primary_flag = 'Y'
        INNER JOIN #contacts AS c WITH (NOLOCK)
            ON c.contact_id = OAC.contact_id
               AND c.activity_id = OAC.activity_id
    WHERE OA.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N'
    ORDER BY c.contact_id,
             OA.creation_date,
             OAU.user_code,
             OA.result_code DESC;

    --Grab all result codes that can be ignored
    SELECT OA.activity_id
    INTO #IgnoreActivities
    FROM HCM.dbo.oncd_activity AS OA
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.activity_id = OA.activity_id
    WHERE OA.result_code IN ( 'CALLBACK', 'NOANSWER', 'EXPIRED', 'NOCONFIRM', 'INCOMPLETE', 'BUSY', 'NOTRANS',
                              'RECOVERY', 'ABANDON'
                            )
          AND OA.due_date >= @startdate
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N';

    --Grab all activities with result code of WRNGNUM from 2013 to 2016
    SELECT OA.activity_id
    INTO #WRNGNUMActivities
    FROM HCM.dbo.oncd_activity AS OA
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.activity_id = OA.activity_id
    WHERE OA.result_code = 'WRNGNUM'
          AND OA.due_date
          BETWEEN @startdate AND @date2016
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N';

    --Grab All Activites since 2013 exlcuding all those that can be igonored

    SELECT OC.contact_id,
           HSL.cst_sfdc_lead_id,
           OA.activity_id,
           CASE
               WHEN OA.action_code = 'ABANDON' THEN
                   'Abandoned Phonecall'
               WHEN OA.action_code = 'APPOINT' THEN
                   'Appointment'
               WHEN OA.action_code = 'BEBACK' THEN
                   'Be Back'
               WHEN OA.action_code = 'BOSCLIENT' THEN
                   'Bosley Client'
               WHEN OA.action_code = 'BOSLEAD' THEN
                   'Bosley Lead'
               WHEN OA.action_code = 'BOSREFCALL' THEN
                   'Outbound Bosley Referral Call'
               WHEN OA.action_code = 'BROCHCALL' THEN
                   'Outbound Brochure Call'
               WHEN OA.action_code = 'CANCEL' THEN
                   'Cancel'
               WHEN OA.action_code = 'CANCELCALL' THEN
                   'Outbound Cancel Call'
               WHEN OA.action_code = 'CLEANUP09' THEN
                   'Clean Up 09'
               WHEN OA.action_code = 'CONFIRM' THEN
                   'Confirmation Call'
               WHEN OA.action_code = 'EMAIL' THEN
                   'Email'
               WHEN OA.action_code = 'EXOUTCALL' THEN
                   'Exception Call'
               WHEN OA.action_code = 'INCALL' THEN
                   'Inbound Call'
               WHEN OA.created_by_user_code LIKE 'TM8%'
                    AND OA.action_code = 'INCALL' THEN
                   'Web Chat'
               WHEN OA.created_by_user_code LIKE 'TM 600%'
                    AND OA.action_code = 'INCALL' THEN
                   'Web Lead'
               WHEN OA.action_code = 'INHOUSE' THEN
                   'In House'
               WHEN OA.action_code = 'NOSHOWCALL' THEN
                   'No Show Call'
               WHEN OA.action_code = 'RECOVERY' THEN
                   'Recovery'
               WHEN OA.action_code = 'SHNOBUYCAL' THEN
                   'Show No Buy Call'
               WHEN OA.action_code = 'TXTCONFIRM' THEN
                   'Text Message Confirmation'
               WHEN OA.action_code = 'OUTCALL' THEN
                   'Outbound Call'
               WHEN OA.action_code = 'OUTSELECT' THEN
                   'Outbound Select Call'
           END AS action_code,
           CASE
               WHEN OA.action_code = 'ABANDON' THEN
                   'Inbound'
               WHEN OA.action_code = 'BEBACK' THEN
                   'Inbound'
               WHEN OA.action_code = 'BOSCLIENT' THEN
                   'Inbound'
               WHEN OA.action_code = 'BOSLEAD' THEN
                   'Inbound'
               WHEN OA.action_code = 'BOSREFCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'BROCHCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'CANCEL' THEN
                   'Inbound'
               WHEN OA.action_code = 'CANCELCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'CONFIRM' THEN
                   'Outbound'
               WHEN OA.action_code = 'EMAIL' THEN
                   'Outbound'
               WHEN OA.action_code = 'EXOUTCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'INCALL' THEN
                   'Inbound'
               WHEN OA.action_code = 'INHOUSE' THEN
                   'Inbound'
               WHEN OA.action_code = 'NOSHOWCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'OUTCALL' THEN
                   'Outbound'
               WHEN OA.action_code = 'OUTSELECT' THEN
                   'Outbound'
               WHEN OA.action_code = 'RECOVERY' THEN
                   'Inbound'
               WHEN OA.action_code = 'SHNOBUYCAL' THEN
                   'Outbound'
               WHEN OA.action_code = 'TXTCONFIRM' THEN
                   'Outbound'
               ELSE
                   cst_activity_type_code
           END AS cst_activity_type_code,
           CASE
               WHEN OA.result_code = 'ABANDON' THEN
                   'Abandon'
               WHEN OA.result_code = 'APPOINT' THEN
                   'Appointment'
               WHEN OA.result_code = 'BROCHURE' THEN
                   'Brochure'
               WHEN OA.result_code = 'BUSY' THEN
                   'Busy'
               WHEN OA.result_code = 'CALLBACK' THEN
                   'Call Back'
               WHEN OA.result_code = 'CANCEL' THEN
                   'Cancel'
               WHEN OA.result_code = 'COMPLETE' THEN
                   'Complete'
               WHEN OA.result_code = 'CTREXCPTN' THEN
                   'Center Exception'
               WHEN OA.result_code = 'DRCTCNFIRM' THEN
                   'Direct Confirmation'
               WHEN OA.result_code = 'EBREPC' THEN
                   'Ebrepc'
               WHEN OA.result_code = 'EXPIRED' THEN
                   'Expired'
               WHEN OA.result_code = 'GENINQ' THEN
                   'General Inquiry'
               WHEN OA.result_code = 'INDCONFIRM' THEN
                   'Indirect Confirmation'
               WHEN OA.result_code = 'NOANSWER' THEN
                   'No Answer'
               WHEN OA.result_code = 'NOCALL' THEN
                   'Do Not Call'
               WHEN OA.result_code = 'NOCONFIRM' THEN
                   'No Confirmation Made'
               WHEN OA.result_code = 'NOCONTACT' THEN
                   'Do Not Contact'
               WHEN OA.result_code = 'NOSHOW' THEN
                   'No Show'
               WHEN OA.result_code = 'NOTEXT' THEN
                   'Do Not Text'
               WHEN OA.result_code = 'NOTRANS' THEN
                   'No Transportation'
               WHEN OA.result_code = 'PRANK' THEN
                   'Prank'
               WHEN OA.result_code = 'RECOVERY' THEN
                   'Recovery'
               WHEN OA.result_code = 'RESCHEDULE' THEN
                   'Reschedule'
               WHEN OA.result_code = 'SHOWNOSALE' THEN
                   'Show No Sale'
               WHEN OA.result_code = 'SHOWSALE' THEN
                   'Show Sale'
               WHEN RTRIM(OA.result_code) = 'VMCONFIRM' THEN
                   'Voicemail Confirmation'
               WHEN OA.result_code = 'VOICEMAIL' THEN
                   'Voicemail'
               WHEN OA.result_code = 'WEBSVCCLNT' THEN
                   'Web Service Client'
               WHEN OA.result_code = 'WEBSVCLEAD' THEN
                   'Web Service Lead'
               WHEN OA.result_code = 'WRNGNUM' THEN
                   'Wrong Number'
               ELSE
                   ISNULL(OA.result_code, '')
           END AS result_code,
           OA.creation_date,
           OA.due_date,
           OA.completion_date,
           OAC.creation_date AS oac_creation_date,
           OA.completed_by_user_code
    INTO #temp
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.contact_id = OC.contact_id
        INNER JOIN HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
            ON OA.activity_id = OAC.activity_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OAC.contact_id
    WHERE OA.due_date >= @startdate
          AND OA.activity_id NOT IN (
                                        SELECT IA.activity_id FROM #IgnoreActivities AS IA
                                    )
          AND ISNULL(OA.cst_do_not_export, 'N') = 'N';;

    --Remove any activity with result code of WRNGNUM created prior to 2017
    DELETE T
    FROM #temp AS T
        INNER JOIN #WRNGNUMActivities AS WA
            ON T.activity_id = WA.activity_id;

    --Join activity data associated with center data and format data for Salesforce Object
    SELECT T.activity_id,
           T.contact_id,
           T.cst_sfdc_lead_id,
           CASE
               WHEN T.action_code IN ( 'Outbound Bosley Referral Call', 'Outbound Brochure Call',
                                       'Outbound Cancel Call', 'Confirmation Call', 'Exception Call', 'Inbound Call',
                                       'No Show Call', 'Outbound Call', 'Outbound Select Call', 'Show No Buy Call'
                                     ) THEN
                   'Call'
               WHEN T.action_code IN ( 'Abandoned Phonecall', 'Bosley Client', 'Bosley Lead', 'Cancel', 'Clean Up 09',
                                       'Email', 'Recovery', 'Text Message Confirmation'
                                     ) THEN
                   'General'
               WHEN T.action_code IN ( 'Appointment', 'Be Back', 'In House' ) THEN
                   'Event'
               ELSE
                   T.action_code
           END AS [Subject],
           T.action_code,
           T.cst_activity_type_code,
           T.result_code,
           ISNULL(
                     CAST(YEAR(T.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(T.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(T.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, T.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, T.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, T.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           ISNULL(
                     CAST(YEAR(T.due_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(T.due_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(T.due_date) AS NVARCHAR(2)) + 'T' + CAST(DATEPART(HOUR, T.due_date) AS NVARCHAR(2))
                     + ':' + CAST(DATEPART(MINUTE, T.due_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, T.due_date) AS NVARCHAR(2)),
                     ''
                 ) AS due_date,
           OCC.company_id,
           ISNULL(
                     CAST(YEAR(T.completion_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(T.completion_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(T.completion_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, T.completion_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, T.completion_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, T.completion_date) AS NVARCHAR(2)),
                     ''
                 ) AS completion_date,
           ISNULL(T.completed_by_user_code, '') AS UserCode,
           CASE
               WHEN T.completed_by_user_code IS NULL THEN
                   '005f4000000RLPfAAO'
               ELSE
                   ''
           END AS OwnerId,
           CASE
               WHEN T.completed_by_user_code IS NULL THEN
                   'Open'
               ELSE
                   'Completed'
           END AS sf_Status
    FROM #temp AS T
        LEFT JOIN HCM.dbo.oncd_contact_company AS OCC WITH (NOLOCK)
            ON OCC.contact_id = T.contact_id
               AND OCC.primary_flag = 'Y'
    WHERE T.cst_activity_type_code IS NOT NULL
    UNION --Resolve activities with and action of appoint and a result code that is null. format data for salesforce object
    SELECT a.activity_id,
           a.contact_id,
           HSL.cst_sfdc_lead_id,
           CASE
               WHEN RTRIM(a.action_code) = 'APPOINT' THEN
                   'Event'
               WHEN RTRIM(a.action_code) IN ( 'BOSREFCALL', 'BROCHCALL', 'OUTCALL', 'CANCELCALL', 'CONFIRM', 'INCALL',
                                              'NOSHOWCALL', 'SHNOBUYCAL'
                                            ) THEN
                   'Call'
               WHEN RTRIM(a.action_code) IN ( 'CANCEL' ) THEN
                   'General'
           END AS [Subject],
           CASE
               WHEN RTRIM(a.action_code) = 'APPOINT' THEN
                   'Appointment'
               WHEN RTRIM(c.action_code) = 'BOSREFCALL' THEN
                   'Outbound Bosley Referral Call'
               WHEN RTRIM(c.action_code) = 'BROCHCALL' THEN
                   'Outbound  Brochure Call'
               WHEN RTRIM(c.action_code) = 'OUTCALL' THEN
                   'Outbound Call'
               WHEN RTRIM(c.action_code) = 'CANCEL' THEN
                   'Cancel'
               WHEN RTRIM(c.action_code) = 'CANCELCALL' THEN
                   'Cancel Call'
               WHEN RTRIM(c.action_code) = 'CONFIRM' THEN
                   'Confirmation Call'
               WHEN RTRIM(c.action_code) = 'INCALL' THEN
                   'Inbound Call'
               WHEN RTRIM(c.action_code) = 'NOSHOWCALL' THEN
                   'No Show Call'
               WHEN RTRIM(c.action_code) = 'SHNOBUYCAL' THEN
                   'Show No Buy Call'
           END AS action_code,
           CASE
               WHEN c.cst_activity_type_code IS NULL
                    AND c.action_code IS NULL
                    AND c.user_code IS NULL THEN
                   'Inbound'
               WHEN c.action_code = 'BROCHCALL' THEN
                   'Outbound'
               WHEN c.action_code = 'CONFIRM' THEN
                   'Outbound'
               WHEN c.action_code = 'SHNOBUYCAL' THEN
                   'Outbound'
               WHEN c.cst_activity_type_code = 'INBOUND' THEN
                   'Inbound'
               WHEN c.cst_activity_type_code = 'OUTBOUND' THEN
                   'Outbound'
               ELSE
                   c.cst_activity_type_code
           END AS cst_activity_type_code,
           CASE
               WHEN RTRIM(a.result_code) = 'CANCEL' THEN
                   'Cancel'
               WHEN RTRIM(a.result_code) = 'CTREXCPTN' THEN
                   'Center Exception'
               WHEN RTRIM(a.result_code) = 'NOSHOW' THEN
                   'No Show'
               WHEN RTRIM(a.result_code) = 'RESCHEDULE' THEN
                   'Reschedule'
               WHEN RTRIM(a.result_code) = 'SHOWNOSALE' THEN
                   'Show No Sale'
               WHEN RTRIM(a.result_code) = 'SHOWSALE' THEN
                   'Show Sale'
               ELSE
                   a.result_code
           END AS result_code,
           ISNULL(
                     CAST(YEAR(a.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(a.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(a.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, a.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, a.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, a.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           ISNULL(
                     CAST(YEAR(a.due_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(a.due_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(a.due_date) AS NVARCHAR(2)) + 'T' + CAST(DATEPART(HOUR, a.due_date) AS NVARCHAR(2))
                     + ':' + CAST(DATEPART(MINUTE, a.due_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, a.due_date) AS NVARCHAR(2)),
                     ''
                 ) AS due_date,
           OCC.company_id,
           ISNULL(
                     CAST(YEAR(c.completion_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(c.completion_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(c.completion_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, c.completion_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, c.completion_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, c.completion_date) AS NVARCHAR(2)),
                     ''
                 ) AS completion_date,
           ISNULL(c.completed_by_user_code, '') AS UserCode,
           CASE
               WHEN c.completed_by_user_code IS NULL THEN
                   '005f4000000RLPfAAO'
               ELSE
                   ''
           END AS OwnerId,
           CASE
               WHEN c.completed_by_user_code IS NULL THEN
                   'Open'
               ELSE
                   'Completed'
           END AS sf_Status
    FROM #Calls AS c
        RIGHT JOIN #APPT AS a
            ON a.contact_id = c.contact_id
               AND c.completion_date = a.creation_date
               AND c.user_code = a.user_code
               AND c.rn = a.rn
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = c.contact_id
        LEFT JOIN HCM.dbo.oncd_contact_company AS OCC WITH (NOLOCK)
            ON OCC.contact_id = c.contact_id
               AND OCC.primary_flag = 'Y'
    ORDER BY contact_id,
             OCC.company_id;

    DROP TABLE #contacts,
               #Calls,
               #APPT,
               #IgnoreActivities,
               #WRNGNUMActivities,
               #temp;
END;
GO
