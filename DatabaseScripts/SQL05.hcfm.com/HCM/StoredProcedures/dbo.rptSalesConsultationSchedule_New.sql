/* CreateDate: 07/30/2018 11:12:44.263 , ModifyDate: 07/30/2018 11:12:44.263 */
GO
/*
==============================================================================
PROCEDURE:				[rptSalesConsultationSchedule] (extHairClubCMSGetConsultationsByDate - originally)

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	cONEct!

AUTHOR: 				Mike Tovbin - original

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED: 		 07/13/2018

==============================================================================
DESCRIPTION:	Used by the report Sales Consultation Schedule
==============================================================================
NOTES:
This version has been written to use the synonym [dbo].[HC_BI_SFDC_Lead_TABLE] to find the latest promotion Promo_Code_Legacy__c
==============================================================================
SAMPLE EXECUTION:
EXEC [rptSalesConsultationSchedule_New] 201, '6/15/2018', '6/17/2018', 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptSalesConsultationSchedule_New]
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

SELECT co.cst_center_number AS territory
,	co.company_name_1 as terr_desc
,	a.due_date AS 'DueDate'
,	a.start_time AS 'Time'
,	CAST((ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(CONVERT(VARCHAR(8),a.start_time,108),'')) as DateTime) AS 'StartTime'
,	CAST((ISNULL(CONVERT(varchar(10), a.due_date, 101),'') + ' ' + ISNULL(CONVERT(VARCHAR(8),DATEADD(HOUR, 1, a.start_time),108),'')) AS DateTime) AS 'EndTime'
,	dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) As 'Name'
,	ISNULL(pc.promotion_code, '') As 'Promo'
,	dbo.[pCase](ca.city) AS 'City'
,	ca.state_code AS 'State'
,	ca.zip_code AS 'Zip'
,	dbo.[pCase](c.cst_language_code) As 'Language'
,	c.contact_id
,	a.activity_id
,	LTRIM(RTRIM(ISNULL(c.first_name,''))) as FirstName
,	LTRIM(RTRIM(ISNULL(c.last_name,''))) as LastName
,	src.source_code as LeadSource
,	Lead.Promo_Code_Legacy__c
FROM oncd_company co WITH(NOLOCK)
INNER JOIN oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id AND cc.primary_flag = 'y' AND co.cst_center_number = @CenterID
INNER JOIN oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
INNER JOIN oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id
INNER JOIN oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id
		AND a.due_date BETWEEN @BeginDate AND @EndDate
		AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
		AND ((a.result_code IS NULL OR result_code = '') OR a.result_code NOT IN ('CANCEL', 'RESCHEDULE','CTREXCPTN', 'PRANK', 'MANCRD', 'BBMANCRD','VOID','CNTRCXL'))
LEFT JOIN oncd_contact_address ca WITH(NOLOCK) ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
LEFT JOIN csta_promotion_code pc WITH(NOLOCK) on pc.promotion_code = c.cst_promotion_code
LEFT JOIN oncd_contact_source src WITH(NOLOCK) ON src.contact_id = c.contact_id
LEFT JOIN [dbo].[HC_BI_SFDC_Lead_TABLE] Lead ON Lead.ContactID__c =  c.contact_id
WHERE (@IncludeTodaysAppointments = 1 OR  a.due_date <>  @Today)   -- Exclude todays appointments if flag is not set.
	AND a.due_date BETWEEN @BeginDate AND @EndDate




END
GO
