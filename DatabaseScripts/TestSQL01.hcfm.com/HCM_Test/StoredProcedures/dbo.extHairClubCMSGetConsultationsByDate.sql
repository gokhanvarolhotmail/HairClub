/* CreateDate: 07/29/2014 18:58:53.867 , ModifyDate: 10/27/2017 13:08:16.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSGetConsultationsByDate

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 02/17/2013

LAST REVISION DATE: 	 02/17/2013

==============================================================================
DESCRIPTION:	Used by cONEct! application to access On Contact data.  IF COLUMNS ARE ADDED -
Also add them to SQL01.HairclubCMS.dbo.rptSalesConsultationResults.
==============================================================================
NOTES:
		* 02/17/2013 MVT - Created (Moved from CMS DB)
		* 05/05/2014 DEL - Added ability to select back Gender field (M or F)
		* 06/19/2014 MVT - Added ethnicity code
		* 07/17/2014 KPL - Added BOSScaleCode
		* 07/06/2015 MVT - Added Lead Source
		* 09/23/2016 MVT - Modified proc to return 'U' if gender is neither 'Male' or 'Female'
						   instead of defaulting to 'M'
		* 01/24/2017 MVT - Added Accomodation for the contact
		* 08/01/2017 DSL - Added ISNULL to the promotion_code column output
		* 10 18 2017 RMH - Added a.due_date BETWEEN @BeginDate AND @EndDate at the end for performance (#136597)
		* 10/27/2017 MVT - Modified to exclude appointments resulted to MANCRD and BBMANCRD from being returned (TFS #9772)

==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSGetConsultationsByDate 292, '6/15/2017', '6/17/2017', 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSGetConsultationsByDate]
(
	@CenterID int,
	@BeginDate datetime,
	@EndDate datetime,
	@IncludeTodaysAppointments bit = 1
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Today AS Date = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

	SELECT co.cst_center_number AS territory,
		CASE WHEN cca.contact_company_id IS NOT NULL THEN co.cst_center_number ELSE NULL END AS alt_center,
		co.company_name_1 as terr_desc, a.due_date AS 'DueDate', a.start_time AS 'Time',
		CAST((ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(CONVERT(VARCHAR(8),a.start_time,108),'')) as DateTime) AS 'StartTime', CAST((ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(CONVERT(VARCHAR(8),DATEADD(HOUR, 1, a.start_time),108),'')) AS DateTime) AS 'EndTime',
		CONVERT(varchar(10), a.completion_date, 101) AS 'CompletionDate',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) As 'Name',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) + ' ' + UPPER(LEFT(LTRIM(RTRIM(ISNULL(c.last_name,''))),1)) As 'NameAbbreviated', ISNULL(pc.promotion_code, '') As 'Promo',
		'(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'Phone',
		dbo.[pCase](ca.city) AS 'City', ca.state_code AS 'State', ca.zip_code AS 'Zip', au.user_code master,
		LTRIM(RTRIM(a.action_code)) AS 'action_code', LTRIM(RTRIM(a.result_code)) AS 'result_code', dbo.[pCase](c.cst_language_code) As 'Language',
		'' AS 'Source', cpl.status_line, cpl.sale_type_code AS 'Type', c.cst_complete_sale, a.activity_id AS 'ID', c.contact_id,
		CASE WHEN c.[cst_gender_code] = 'FEMALE' THEN 'F'
			 WHEN c.[cst_gender_code] = 'MALE' THEN 'M' ELSE 'U' End As Gender,
		LTRIM(RTRIM(ISNULL(c.first_name,''))) as FirstName,
		LTRIM(RTRIM(ISNULL(c.last_name,''))) as LastName,
		ad.ethnicity_code,
		CASE WHEN c.[cst_gender_code] = 'FEMALE' THEN ad.ludwig else ad.norwood End As BOSScaleCode,
		src.source_code as LeadSource,
		accm.[description] as Accomomdation
		--appt.AppointmentGUID, appt.CheckinTime, appt.CheckoutTime, e.EmployeeGuid,
		--appt.ClientGuid, appt.ClientMembershipGuid, bs.BusinessSegmentDescription, bs.BusinessSegmentDescriptionShort
	FROM oncd_company co WITH(NOLOCK)
		INNER JOIN oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id AND cc.primary_flag = 'y' AND co.cst_center_number = @CenterID
		INNER JOIN oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
		INNER JOIN oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id
		INNER JOIN oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id
				AND a.due_date BETWEEN @BeginDate AND @EndDate
				AND a.action_code IN ('APPOint', 'INHOUSE', 'BEBACK')
				AND ((a.result_code IS NULL OR result_code = '') OR a.result_code NOT IN ('CANCEL', 'RESCHEDULE','CTREXCPTN', 'PRANK', 'MANCRD', 'BBMANCRD'))
		LEFT JOIN oncd_contact_phone cp WITH(NOLOCK) ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
		LEFT JOIN oncd_contact_address ca WITH(NOLOCK) ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
		LEFT JOIN oncd_activity_user au WITH(NOLOCK) ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
		LEFT JOIN oncd_contact_source cs WITH(NOLOCK) ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'
		LEFT JOIN cstd_contact_completion cpl WITH(NOLOCK) ON acon.contact_id = cpl.contact_id
				AND a.activity_id = cpl.activity_id AND cpl.sale_type_code <> '9'
		LEFT JOIN csta_promotion_code pc WITH(NOLOCK) on pc.promotion_code = c.cst_promotion_code
		LEFT JOIN oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id AND cca.company_id <> co.company_id
		LEFT JOIN oncd_company AS coa WITH(NOLOCK) ON coa.company_id = cca.company_id
		LEFT JOIN cstd_activity_demographic AS ad WITH(NOLOCK) ON ad.activity_id = a.activity_id
		LEFT JOIN oncd_contact_source src WITH(NOLOCK) ON src.contact_id = c.contact_id
		LEFT JOIN csta_contact_accomodation accm ON accm.contact_accomodation_code = c.cst_contact_accomodation_code
		--LEFT JOIN datAppointment appt WITH(NOLOCK) ON a.activity_id = appt.OnContactActivityID
		--LEFT JOIN datClientMembership cm WITH(NOLOCK) ON cm.ClientMembershipGUID = appt.ClientMembershipGUID
		--LEFT JOIN cfgMembership mem WITH(NOLOCK) ON mem.MembershipID = cm.MembershipID
		--LEFT JOIN lkpBusinessSegment bs WITH(NOLOCK) ON bs.BusinessSegmentID = mem.BusinessSegmentID
		--OUTER APPLY
		--	(
		--		SELECT TOP (1) e.*
		--		FROM datAppointmentEmployee e
		--		WHERE e.AppointmentGuid = appt.AppointmentGuid
		--	) e
	WHERE (@IncludeTodaysAppointments = 1 OR  a.due_date <>  @Today)   -- Exclude todays appointments if flag is not set.
	 AND a.due_date BETWEEN @BeginDate AND @EndDate

		--(a.result_code IS NULL OR a.result_code = '' OR a.result_code = 'NOSHOW' OR (a.result_code IS NOT NULL AND appt.AppointmentGUID IS NOT NULL)) AND    -- Only select completed consultations if Appointment in CMS exists
	  --((@CheckedInFlag IS NULL OR @CheckedInFlag = 0) OR (NOT appt.CheckinTime IS NULL AND appt.CheckoutTime IS NULL AND a.result_code is NULL))
	ORDER BY 6,7


END
GO
