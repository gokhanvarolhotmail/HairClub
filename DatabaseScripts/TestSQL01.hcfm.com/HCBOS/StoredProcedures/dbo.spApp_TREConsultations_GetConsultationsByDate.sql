/* CreateDate: 08/28/2008 17:43:00.370 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetConsultationsByDate
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/29/2008
-- Date Implemented:		7/29/2008
-- Date Last Modified:		7/29/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-------------------------------------------------------------------------------------------------
--	3/16/09 Modified by: ONC PSO Fred Remers
--	removed view
--	implemented 3/17/09 10:18 AM
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetConsultationsByDate 201, '9/2/2008'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetConsultationsByDate]
(
	@CenterNumber INT,
	@Date DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT
	CASE
		WHEN cca.primary_flag = 'N' THEN coa.cst_center_number
		ELSE co.cst_center_number
	END AS territory,

	CASE WHEN cca.contact_company_id is not null THEN co.cst_center_number
		ELSE NULL
	END AS alt_center,

	co.company_name_1 as terr_desc,

	a.due_date AS 'DueDate',
	a.start_time AS 'Time',
	CONVERT(VARCHAR(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt',
	CONVERT(VARCHAR(10), a.completion_date, 101) AS 'CompletionDate',
	dbo.pCase(LTRIM(RTRIM(c.last_name))) + ', ' + dbo.pCase(LTRIM(RTRIM(c.first_name))) As 'Name',
	pc.promotion_code As 'Promo',
	'(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'Phone',
	dbo.pCase(ca.city) AS 'City',
	ca.state_code AS 'State',
	ca.zip_code AS 'Zip',
	au.user_code master,
	LTRIM(RTRIM(a.action_code)) AS 'action_code',
	LTRIM(RTRIM(a.result_code)) AS 'result_code',
	dbo.pCase(c.cst_language_code) As 'Language',
	'' AS 'Source',
	cpl.status_line,
	cpl.sale_type_code AS 'Type',----------------------------
	c.cst_complete_sale,
	a.activity_id AS 'ID',
	c.contact_id
FROM [HCM].[dbo].oncd_company co WITH(NOLOCK)
inner JOIN [HCM].[dbo].oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id
and cc.primary_flag = 'y'
	AND co.cst_center_number = @centerNumber
INNER JOIN [HCM].[dbo].oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
INNER JOIN [HCM].[dbo].oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id

INNER JOIN [HCM].[dbo].oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id
	AND a.due_date BETWEEN @Date AND @Date
	AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
	AND (a.result_code IS NULL OR result_code = '')
	AND (a.completion_date IS NULL)
LEFT OUTER JOIN [HCM].[dbo].oncd_contact_phone cp WITH(NOLOCK)
	  ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_contact_address ca WITH(NOLOCK)
	  ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_activity_user au WITH(NOLOCK)
      ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_contact_source cs WITH(NOLOCK)
      ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].cstd_contact_completion cpl WITH(NOLOCK)
      ON acon.contact_id = cpl.contact_id
            AND a.activity_id = cpl.activity_id
LEFT OUTER JOIN [HCM].[dbo].csta_promotion_code pc on pc.promotion_code = c.cst_promotion_code

LEFT OUTER JOIN [HCM].[dbo].oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id
	and cca.company_id <> co.company_id
LEFT OUTER JOIN [HCM].[dbo].oncd_company AS coa ON coa.company_id = cca.company_id

UNION
SELECT
	CASE
		WHEN cca.primary_flag = 'N' THEN coa.cst_center_number
		ELSE co.cst_center_number
	END AS territory,

	CASE WHEN cca.contact_company_id is not null THEN co.cst_center_number
		ELSE NULL
	END AS alt_center,

	co.company_name_1 as terr_desc,

	a.due_date AS 'DueDate',
	a.start_time AS 'Time',
	CONVERT(VARCHAR(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt',
	CONVERT(VARCHAR(10), a.completion_date, 101) AS 'CompletionDate',
	dbo.pCase(LTRIM(RTRIM(c.last_name))) + ', ' + dbo.pCase(LTRIM(RTRIM(c.first_name))) As 'Name',
	pc.promotion_code As 'Promo',
	'(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'Phone',
	dbo.pCase(ca.city) AS 'City',
	ca.state_code AS 'State',
	ca.zip_code AS 'Zip',
	au.user_code master,
	LTRIM(RTRIM(a.action_code)) AS 'action_code',
	LTRIM(RTRIM(a.result_code)) AS 'result_code',
	dbo.pCase(c.cst_language_code) As 'Language',
	'' AS 'Source',
	cpl.status_line,
	cpl.sale_type_code AS 'Type',----------------------------
	c.cst_complete_sale,
	a.activity_id AS 'ID',
	c.contact_id

FROM [HCM].[dbo].oncd_company co WITH(NOLOCK)
inner JOIN [HCM].[dbo].oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id
and cc.primary_flag = 'y'
	AND co.cst_center_number = @centerNumber
INNER JOIN [HCM].[dbo].oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
INNER JOIN [HCM].[dbo].oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id

INNER JOIN [HCM].[dbo].oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id
	AND a.completion_date = CONVERT(DATETIME, CONVERT(VARCHAR(11),@date))
	AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
	AND a.result_code NOT IN ('CANCEL', 'RESCHEDULE','CTREXCPTN', 'PRANK')

LEFT OUTER JOIN [HCM].[dbo].oncd_contact_phone cp WITH(NOLOCK)
	  ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_contact_address ca WITH(NOLOCK)
	  ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_activity_user au WITH(NOLOCK)
      ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
LEFT OUTER JOIN [HCM].[dbo].oncd_contact_source cs WITH(NOLOCK)
      ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'

LEFT OUTER JOIN [HCM].[dbo].cstd_contact_completion cpl WITH(NOLOCK)
	ON acon.contact_id = cpl.contact_id
	AND a.activity_id = cpl.activity_id
	AND cpl.sale_type_code <> '9'

LEFT OUTER JOIN [HCM].[dbo].csta_promotion_code pc on pc.promotion_code = c.cst_promotion_code

LEFT OUTER JOIN [HCM].[dbo].oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id
	and cca.company_id <> co.company_id
LEFT OUTER JOIN [HCM].[dbo].oncd_company AS coa ON coa.company_id = cca.company_id

ORDER BY 6,7

END
GO
