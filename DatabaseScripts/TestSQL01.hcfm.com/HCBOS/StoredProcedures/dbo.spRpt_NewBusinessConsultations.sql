/* CreateDate: 09/22/2008 17:37:00.233 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	[spRpt_NewBusinessConsultations]

DESTINATION SERVER:	   HCTESTSQL3

DESTINATION DATABASE: BOS

RELATED APPLICATION:  Gets all schedules consultations for new business clients.

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/11/08

LAST REVISION DATE: 9/11/08

--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:  EXECUTE [spRpt_NewBusinessConsultations] 201, '9/22/2008', '9/22/2008'
--------------------------------------------------------------------------------------------------------

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_NewBusinessConsultations]
	@CenterNumber	int
,	@StartDate		datetime
,	@EndDate		datetime
--,	@ReportType		INT
AS
BEGIN

	DECLARE @terr_desc as varchar(50)

	SELECT  @terr_desc = company_name_1
	FROM    [HCM].[dbo].oncd_company WITH (NOLOCK)
	WHERE   cst_center_number = @CenterNumber

	SELECT  info.territory
	,       info.alt_center
	,       dbo.pcase(@terr_desc) 'terr_desc'
	,       a.due_date AS 'DueDate'
	,       a.start_time AS 'Time'
	,       CONVERT(VARCHAR(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt'
	,       CONVERT(VARCHAR(10), a.completion_date, 101) AS 'CompletionDate'
	,       dbo.pCase(LTRIM(RTRIM(info.last_name))) + ', ' + dbo.pCase(LTRIM(RTRIM(info.first_name))) As 'Name'
	,       '(' + LTRIM(RTRIM(info.area_code)) + ') ' + LEFT(LTRIM(info.phone_number), 3) + '-' + RIGHT(RTRIM(info.phone_number), 4) AS 'Phone'
	,       dbo.pCase(info.city) AS 'City'
	,       info.state_code AS 'State'
	,       info.zip_code AS 'Zip'
	,       au.user_code master
	,       LTRIM(RTRIM(a.action_code)) AS 'action_code'
	,       LTRIM(RTRIM(a.result_code)) AS 'result_code'
	,       dbo.pCase(info.cst_language_code) As 'Language'
	,       dbo.pCase(info.cst_promotion_code) As 'Promo'
	,       dbo.pCase(cs.source_code) AS 'Source'
	,       cpl.status_line
	,       sale_type_code AS 'Type'
	,       info.cst_complete_sale
	,       a.activity_id AS 'ID'
	,       info.contact_id
	,		cad.[Performer]
	FROM    [HCM].[dbo].lead_info info WITH (NOLOCK)
				  INNER JOIN [HCM].[dbo].oncd_activity_contact ac WITH (NOLOCK)
					 ON ac.contact_id = info.contact_id
						  AND ac.primary_flag = 'Y'
				  INNER JOIN [HCM].[dbo].oncd_activity a WITH (NOLOCK)
					 ON a.activity_id = ac.activity_id
						AND a.due_date BETWEEN @StartDate AND @EndDate
						AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
						AND (a.result_code IS NULL
								   OR LEN(RTRIM(LTRIM(result_code))) = 0)
						AND (a.completion_date IS NULL)
				  INNER JOIN [HCM].[dbo].oncd_activity_user au WITH (NOLOCK)
					 ON au.activity_id = a.activity_id
						AND au.primary_flag = 'Y'
				  LEFT OUTER JOIN [HCM].[dbo].oncd_contact_source cs WITH (NOLOCK)
					 ON cs.contact_id = info.contact_id
						AND cs.primary_flag = 'Y'
				  LEFT OUTER JOIN [HCM].[dbo].cstd_contact_completion cpl WITH (NOLOCK)
					 ON ac.contact_id = cpl.contact_id
  						AND a.activity_id = cpl.activity_id
				LEFT OUTER JOIN [HCM].[dbo].[cstd_activity_demographic] cad
					ON a.[activity_id] = cad.[activity_id]
	WHERE   (info.alt_center = @CenterNumber
				   OR ((info.alt_center IS NULL
						   OR info.alt_center = 0
						   OR info.alt_center = '')
						  AND info.territory = @CenterNumber))

	UNION

	SELECT  info.territory
	,       info.alt_center
	,       dbo.pcase(@terr_desc) 'terr_desc'
	,       a.due_date AS 'DueDate'
	,       a.start_time AS 'Time'
	,       CONVERT(VARCHAR(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt'
	,       CONVERT(VARCHAR(10), a.completion_date, 101) AS 'CompletionDate'
	,       dbo.pCase(LTRIM(RTRIM(info.last_name))) + ', ' + dbo.pCase(LTRIM(RTRIM(info.first_name))) As 'Name'
	,       '(' + LTRIM(RTRIM(info.area_code)) + ') ' + LEFT(LTRIM(info.phone_number), 3) + '-' + RIGHT(RTRIM(info.phone_number), 4) AS 'Phone'
	,       dbo.pCase(info.city) AS 'City'
	,       info.state_code AS 'State'
	,       info.zip_code AS 'Zip'
	,       au.user_code master
	,       LTRIM(RTRIM(a.action_code)) AS 'action_code'
	,       LTRIM(RTRIM(a.result_code)) AS 'result_code'
	,       dbo.pCase(info.cst_language_code) As 'Language'
	,       dbo.pCase(info.cst_promotion_code) As 'Promo'
	,       dbo.pCase(cs.source_code) AS 'Source'
	,       cpl.status_line
	,       sale_type_code AS 'Type'
	,       info.cst_complete_sale
	,       a.activity_id AS 'ID'
	,       info.contact_id
	,		cad.[Performer]
	FROM    [HCM].[dbo].lead_info info WITH (NOLOCK)
				  INNER JOIN [HCM].[dbo].oncd_activity_contact ac WITH (NOLOCK)
					 ON info.contact_id = ac.contact_id
						  AND ac.primary_flag = 'Y'
				  INNER JOIN [HCM].[dbo].oncd_activity a WITH (NOLOCK)
					 ON a.activity_id = ac.activity_id
						AND a.completion_date = convert(datetime, convert(varchar(11), getdate()))
				  INNER JOIN [HCM].[dbo].oncd_activity_user au WITH (NOLOCK)
					 ON au.activity_id = a.activity_id
						AND au.primary_flag = 'Y'
				  LEFT OUTER JOIN [HCM].[dbo].oncd_contact_source cs WITH (NOLOCK)
						  ON cs.contact_id = info.contact_id
							   AND cs.primary_flag = 'Y'
				  LEFT OUTER JOIN [HCM].[dbo].cstd_contact_completion cpl WITH (NOLOCK)
						  ON ac.contact_id = cpl.contact_id
							   AND a.activity_id = cpl.activity_id
							   AND cpl.sale_type_code <> '9'
				LEFT OUTER JOIN [HCM].[dbo].[cstd_activity_demographic] cad
					ON a.[activity_id] = cad.[activity_id]
	WHERE   (info.alt_center = @CenterNumber
				   OR ((info.alt_center IS NULL
						   OR info.alt_center = 0
						   OR info.alt_center = '')
						  AND info.territory = @CenterNumber))
				  AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
				  AND a.result_code NOT IN ('CANCEL', 'RESCHEDULE',
															 'CTREXCPTN', 'PRANK')
	ORDER BY 6
	,       7

END
GO
