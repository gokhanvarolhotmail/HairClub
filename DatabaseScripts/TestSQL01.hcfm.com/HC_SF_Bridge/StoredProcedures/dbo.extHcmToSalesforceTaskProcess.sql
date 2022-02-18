/* CreateDate: 11/28/2017 17:21:17.567 , ModifyDate: 11/13/2018 14:45:18.913 */
GO
/***********************************************************************
PROCEDURE:				extHcmToSalesforceTaskProcess
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/27/2017
DESCRIPTION:			11/27/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHcmToSalesforceTaskProcess 0
EXEC extHcmToSalesforceTaskProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extHcmToSalesforceTaskProcess]
(
	@IsManual BIT
)
AS
BEGIN

DECLARE @DistinctActivity AS TABLE (
	ID INT NOT NULL IDENTITY(1, 1)
,	ActivityID NCHAR(10)
,	UNIQUE CLUSTERED ( ActivityID )
)


/********************************** Get Activities *************************************/
INSERT  INTO @DistinctActivity
		SELECT	oa.activity_id
		FROM	HCM.dbo.oncd_activity oa WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity_contact oac WITH ( NOLOCK )
					ON oac.activity_id = oa.activity_id
					AND oac.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_contact oc WITH ( NOLOCK )
					ON oc.contact_id = oac.contact_id
		WHERE	oa.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND oa.result_code NOT IN ( 'VOID' )
				AND oa.creation_date BETWEEN '1/1/2015' AND '12/31/2017 23:59:59'
				AND oa.cst_sfdc_task_id IS NULL
				AND oc.contact_status_code IN ( 'LEAD', 'CLIENT' )


/********************************** Return Activity Details *************************************/
--TRUNCATE TABLE tmpSalesforceTask


--INSERT INTO tmpSalesforceTask
--        ( ActivityID__c
--        ,WhoId
--        ,Lead__c
--        ,Center__c
--        ,CenterID__c
--        ,Action__c
--        ,Result__c
--        ,Subject
--        ,Status
--        ,ActivityType__c
--        ,SourceCode__c
--        ,AppointmentDate__c
--        ,ActivityDate
--        ,StartTime__c
--        ,CompletionDate__c
--        ,EndTime__c
--        ,OwnerId
--        ,ReportCreateDate__c
--        ,OncCreatedDate__c
--        ,OncUpdatedDate__c
--		)
SELECT  oa.activity_id AS 'ActivityID__c'
,		oc.cst_sfdc_lead_id AS 'WhoId'
,		oc.cst_sfdc_lead_id AS 'Lead__c'
,		ISNULL(shc_a.Id, shc.Id) AS 'Center__c'
,		ISNULL(LTRIM(RTRIM(co_a.cst_center_number)), LTRIM(RTRIM(co.cst_center_number))) AS 'CenterID__c'
,       CASE WHEN oa.created_by_user_code LIKE 'TM8%' AND oa.action_code = 'INCALL' THEN 'Web Chat'
			 WHEN oa.created_by_user_code = 'TM 600' AND oa.action_code = 'INCALL' THEN 'Web Form'
			 ELSE ac.SF_ActionCode
		END AS 'Action__c'
,		REPLACE(rc.SF_ResultCode, 'Void', 'Cancel') AS 'Result__c'
,       CASE WHEN ac.SF_ActionCode LIKE '%Call' THEN 'Call'
             WHEN ac.SF_ActionCode IN ( 'Abandoned Phonecall', 'Bosley Client', 'Bosley Lead', 'Cancel', 'Clean Up 09', 'Email', 'Recovery', 'Text Message Confirmation' ) THEN 'General'
             WHEN ac.SF_ActionCode IN ( 'Appointment', 'Be Back', 'In House' ) THEN 'Event'
             ELSE ac.SF_ActionCode
        END AS 'Subject'
,       CASE WHEN ISNULL(oa.completed_by_user_code, '') <> '' OR ISNULL(LTRIM(RTRIM(oa.result_code)), '') <> '' THEN 'Completed'
             ELSE 'Open'
        END AS 'Status'
,       CASE WHEN oa.action_code IN ( 'BROCHCALL', 'CONFIRM', 'SHNOBUYCAL' ) OR oa.cst_activity_type_code = 'OUTBOUND' THEN 'Outbound'
             WHEN oa.cst_activity_type_code = 'INBOUND' THEN 'Inbound'
             ELSE oa.cst_activity_type_code
        END AS 'ActivityType__c'
,       oa.source_code AS 'SourceCode__c'
,		CASE WHEN oa.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' ) THEN CAST(oa.due_date AS DATE)
             ELSE NULL
        END AS 'AppointmentDate__c'
,		CAST(oa.due_date AS DATE) AS 'ActivityDate'
,		CASE WHEN oa.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' ) THEN CAST(CAST(oa.start_time AS TIME) AS VARCHAR(5))
			 ELSE ''
		END AS 'StartTime__c'
,		oa.completion_date + oa.completion_time AS 'CompletionDate__c'
,		'' AS 'EndTime__c'
,		CASE WHEN oa.completed_by_user_code IS NULL THEN '005f4000000RLPfAAO'
             ELSE ISNULL(cbt_u.cst_sfdc_user_id, '005f4000000RLPfAAO')
        END AS 'OwnerId'
,		HairClubCMS.dbo.GetUTCFromLocal(oa.creation_date, -5, 1) AS 'ReportCreateDate__c'
,		HairClubCMS.dbo.GetUTCFromLocal(oa.creation_date, -5, 1) AS 'OncCreatedDate__c'
,		HairClubCMS.dbo.GetUTCFromLocal(oa.updated_date, -5, 1) AS 'OncUpdatedDate__c'
FROM    HCM.dbo.oncd_activity oa WITH ( NOLOCK )
        INNER JOIN @DistinctActivity da
            ON da.ActivityID = oa.activity_id
        INNER JOIN HCM.dbo.oncd_activity_contact oac WITH ( NOLOCK )
            ON oac.activity_id = oa.activity_id
               AND oac.primary_flag = 'Y'
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.ContactID__c = oac.contact_id
        INNER JOIN HCM.dbo.oncd_contact oc WITH ( NOLOCK )
            ON oc.contact_id = l.ContactID__c
		INNER JOIN HCM.dbo.oncd_contact_company occ WITH ( NOLOCK )
			ON occ.contact_id = oc.contact_id
				AND occ.primary_flag = 'Y'
		INNER JOIN HCM.dbo.oncd_company co WITH ( NOLOCK )
			ON co.company_id = occ.company_id
		INNER JOIN HC_SF_Bridge.dbo.SFDC_HCM_Center shc WITH ( NOLOCK )
			ON shc.CenterID__c = co.cst_center_number
        INNER JOIN SFDC_HCM_ActionCode ac
            ON ac.OnContact_ActionCode = oa.action_code
               AND ac.IsActiveFlag = 1
		LEFT OUTER JOIN HCM.dbo.oncd_activity_company aco WITH ( NOLOCK )
			ON aco.activity_id = oa.activity_id
				AND aco.primary_flag = 'Y'
		LEFT OUTER JOIN HCM.dbo.oncd_company co_a WITH ( NOLOCK )
			ON co_a.company_id = aco.company_id
		LEFT OUTER JOIN HC_SF_Bridge.dbo.SFDC_HCM_Center shc_a WITH ( NOLOCK )
			ON shc_a.CenterID__c = co_a.cst_center_number
        LEFT OUTER JOIN SFDC_HCM_ResultCode rc
            ON rc.OnContact_ResultCode = oa.result_code
               AND rc.IsActiveFlag = 1
		LEFT OUTER JOIN SFDC_HCM_User cbt_u
			ON cbt_u.user_code = oa.completed_by_user_code
WHERE	oc.cst_sfdc_lead_id IS NOT NULL
--		AND LEFT(oc.cst_sfdc_lead_id, 3) = '00Q'
ORDER BY oc.cst_sfdc_lead_id
,		oa.due_date
,		oa.start_time

END
GO
