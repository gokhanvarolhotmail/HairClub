/* CreateDate: 12/11/2012 14:57:18.747 , ModifyDate: 12/11/2012 14:57:18.747 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetConsultationsByDate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetConsultationsByDate

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetConsultationsByDate 201, '9/2/2008'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetConsultationsByDate]
(
	@CenterID int,
	@BeginDate datetime,
	@EndDate datetime,
	@CheckedInFlag bit = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

(
	--SELECT CASE WHEN cca.primary_flag = 'N' THEN coa.cst_center_number ELSE co.cst_center_number END AS territory,
	SELECT co.cst_center_number AS territory,
		CASE WHEN cca.contact_company_id IS NOT NULL THEN co.cst_center_number ELSE NULL END AS alt_center,
		co.company_name_1 as terr_desc, a.due_date AS 'DueDate', a.start_time AS 'Time',
		ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(a.start_time,'') AS 'StartTime', ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(DATEADD(HOUR, 1, a.start_time),'') AS 'EndTime',
		CONVERT(varchar(10), a.completion_date, 101) AS 'CompletionDate',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) As 'Name',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) + ' ' + UPPER(LEFT(LTRIM(RTRIM(ISNULL(c.last_name,''))),1)) As 'NameAbbreviated', pc.promotion_code As 'Promo',
		'(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'Phone',
		dbo.[pCase](ca.city) AS 'City', ca.state_code AS 'State', ca.zip_code AS 'Zip', au.user_code master,
		LTRIM(RTRIM(a.action_code)) AS 'action_code', LTRIM(RTRIM(a.result_code)) AS 'result_code', dbo.[pCase](c.cst_language_code) As 'Language',
		'' AS 'Source', cpl.status_line, cpl.sale_type_code AS 'Type', c.cst_complete_sale, a.activity_id AS 'ID', c.contact_id,
		appt.AppointmentGUID, appt.CheckinTime, appt.CheckoutTime
	FROM HCMSkylineTest..oncd_company co WITH(NOLOCK)
		INNER JOIN HCMSkylineTest..oncd_contact_company cc WITH(NOLOCK) ON cc.company_id = co.company_id AND cc.primary_flag = 'y' AND co.cst_center_number = @CenterID
		INNER JOIN HCMSkylineTest..oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
		INNER JOIN HCMSkylineTest..oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id
		INNER JOIN HCMSkylineTest..oncd_activity a WITH(NOLOCK) ON acon.activity_id = a.activity_id
				AND CAST(CONVERT(varchar(10),a.due_date,101) as datetime) BETWEEN CAST(CONVERT(varchar(10),@BeginDate,101) as datetime)
			    AND CAST(CONVERT(varchar(10),@EndDate,101) as datetime) AND a.action_code IN ('APPOint', 'INHOUSE', 'BEBACK')
				AND (a.result_code IS NULL OR result_code = '') AND (a.completion_date IS NULL)
		LEFT OUTER JOIN HCMSkylineTest..oncd_contact_phone cp WITH(NOLOCK) ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_contact_address ca WITH(NOLOCK) ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_activity_user au WITH(NOLOCK) ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_contact_source cs WITH(NOLOCK) ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..cstd_contact_completion cpl WITH(NOLOCK) ON acon.contact_id = cpl.contact_id AND a.activity_id = cpl.activity_id
		LEFT JOIN HCMSkylineTest..csta_promotion_code pc ON pc.promotion_code = c.cst_promotion_code
		LEFT JOIN HCMSkylineTest..oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id AND cca.company_id <> co.company_id
		LEFT JOIN HCMSkylineTest..oncd_company AS coa ON coa.company_id = cca.company_id
		LEFT JOIN datAppointment appt ON a.activity_id = appt.OnContactActivityID
	WHERE (@CheckedInFlag IS NULL OR @CheckedInFlag = 0) OR (NOT appt.CheckinTime IS NULL AND appt.CheckoutTime IS NULL)
)
UNION
(
	--SELECT CASE WHEN cca.primary_flag = 'N' THEN coa.cst_center_number ELSE co.cst_center_number END AS territory,
	SELECT co.cst_center_number AS territory,
		CASE WHEN cca.contact_company_id IS NOT NULL THEN co.cst_center_number ELSE NULL END AS alt_center,
		co.company_name_1 as terr_desc, a.due_date AS 'DueDate', a.start_time AS 'Time',
		ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(a.start_time,'') AS 'StartTime', ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(DATEADD(HOUR, 1, a.start_time),'') AS 'EndTime',
		CONVERT(varchar(10), a.completion_date, 101) AS 'CompletionDate',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) As 'Name',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) + ' ' + UPPER(LEFT(LTRIM(RTRIM(ISNULL(c.last_name,''))),1)) As 'NameAbbreviated', pc.promotion_code As 'Promo',
		'(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'Phone',
		dbo.[pCase](ca.city) AS 'City', ca.state_code AS 'State', ca.zip_code AS 'Zip', au.user_code master,
		LTRIM(RTRIM(a.action_code)) AS 'action_code', LTRIM(RTRIM(a.result_code)) AS 'result_code', dbo.[pCase](c.cst_language_code) As 'Language',
		'' AS 'Source', cpl.status_line, cpl.sale_type_code AS 'Type', c.cst_complete_sale, a.activity_id AS 'ID', c.contact_id,
		appt.AppointmentGUID, appt.CheckinTime, appt.CheckoutTime
	FROM HCMSkylineTest..oncd_company co WITH(NOLOCK)
		INNER JOIN HCMSkylineTest..oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id AND cc.primary_flag = 'y' AND co.cst_center_number = @CenterID
		INNER JOIN HCMSkylineTest..oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
		INNER JOIN HCMSkylineTest..oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id
		INNER JOIN HCMSkylineTest..oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id AND a.completion_date BETWEEN CONVERT(datetime, CONVERT(varchar(11),@BeginDate)) AND CONVERT(datetime, CONVERT(varchar(11),@EndDate))
				AND a.action_code IN ('APPOint', 'INHOUSE', 'BEBACK') AND a.result_code NOT IN ('CANCEL', 'RESCHEDULE','CTREXCPTN', 'PRANK')
		LEFT JOIN HCMSkylineTest..oncd_contact_phone cp WITH(NOLOCK) ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_contact_address ca WITH(NOLOCK) ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_activity_user au WITH(NOLOCK) ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..oncd_contact_source cs WITH(NOLOCK) ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'
		LEFT JOIN HCMSkylineTest..cstd_contact_completion cpl WITH(NOLOCK) ON acon.contact_id = cpl.contact_id
				AND a.activity_id = cpl.activity_id AND cpl.sale_type_code <> '9'
		LEFT JOIN HCMSkylineTest..csta_promotion_code pc on pc.promotion_code = c.cst_promotion_code
		LEFT JOIN HCMSkylineTest..oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id AND cca.company_id <> co.company_id
		LEFT JOIN HCMSkylineTest..oncd_company AS coa ON coa.company_id = cca.company_id
		LEFT JOIN datAppointment appt ON a.activity_id = appt.OnContactActivityID
	WHERE (@CheckedInFlag IS NULL OR @CheckedInFlag = 0) OR (NOT appt.CheckinTime IS NULL AND appt.CheckoutTime IS NULL)
)
ORDER BY 6,7

END
GO
