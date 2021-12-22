/* CreateDate: 06/06/2007 11:18:34.880 , ModifyDate: 05/01/2010 14:48:12.080 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------------------------
--3/13/09 Modified by: ONC PSO Fred Remers
--removed view
--implemented 3/17/09 11:47 AM CST
-----------------------------------------------------------------
--sample execution
--EXEC hcmsp_completions_v3 201, '3/06/2009', '3/06/2009'
-----------------------------------------------------------------


CREATE PROCEDURE [dbo].[hcmsp_completions_v2](@center as varchar(3), @begdt as datetime, @enddt as datetime) AS


SELECT
      c.contact_id,
      a.activity_id,

      CASE
           WHEN cca.primary_flag = 'N' THEN coa.cst_center_number
           ELSE co.cst_center_number
	  END AS territory,


      CASE WHEN cca.contact_company_id is not null THEN co.cst_center_number
ELSE NULL END AS alt_center,

	  co.company_name_1 as terr_desc,
      a.due_date,
      a.start_time,
      a.completion_date,
      c.first_name,
      c.last_name,
      cp.phone_number,
      ca.city,
      ca.state_code,
      ca.zip_code,
      au.user_code master,
      a.action_code,
      a.result_code,
      cs.source_code,
      pc.description cst_promotion_code,
      c.cst_language_code,
      cpl.status_line,
      sale_type_code,
      c.cst_complete_sale

FROM oncd_company co WITH(NOLOCK)
inner JOIN oncd_contact_company cc WITH(NOLOCK) on cc.company_id = co.company_id
and cc.primary_flag = 'y'
	AND co.cst_center_number = @center
INNER JOIN oncd_contact c WITH(NOLOCK) on cc.contact_id = c.contact_id
INNER JOIN oncd_activity_contact acon WITH(NOLOCK) on c.contact_id = acon.contact_id

INNER JOIN oncd_activity a WITH(NOLOCK) on acon.activity_id = a.activity_id
	AND a.due_date BETWEEN @begdt AND @enddt
	AND a.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
	AND (a.result_code IS NULL OR a.result_code = '')
	AND a.completion_date is null

LEFT OUTER JOIN oncd_contact_phone cp WITH(NOLOCK)
	  ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_address ca WITH(NOLOCK)
	  ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
LEFT OUTER JOIN oncd_activity_user au WITH(NOLOCK)
      ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_source cs WITH(NOLOCK)
      ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'

LEFT OUTER JOIN cstd_contact_completion cpl WITH(NOLOCK)
	ON acon.contact_id = cpl.contact_id
	AND a.activity_id = cpl.activity_id
	AND cpl.sale_type_code <> '9'

LEFT OUTER JOIN csta_promotion_code pc on pc.promotion_code = c.cst_promotion_code

LEFT OUTER JOIN oncd_contact_company cca WITH(NOLOCK) on cca.contact_id = c.contact_id
	and cca.company_id <> co.company_id
LEFT OUTER JOIN oncd_company AS coa ON coa.company_id = cca.company_id

UNION

SELECT
      c1.contact_id,
      a1.activity_id,

      CASE
           WHEN cca1.contact_company_id is not null THEN coa1.cst_center_number
           ELSE co1.cst_center_number
	  END AS territory,


      CASE WHEN cca1.contact_company_id is not null THEN co1.cst_center_number
ELSE NULL END AS alt_center,

	  co1.company_name_1 as terr_desc,
      a1.due_date,
      a1.start_time,
      a1.completion_date,
      c1.first_name,
      c1.last_name,
      cp1.phone_number,
      ca1.city,
      ca1.state_code,
      ca1.zip_code,
      au1.user_code master,
      a1.action_code,
      a1.result_code,
      cs1.source_code,
      pc1.description cst_promotion_code,
      c1.cst_language_code,
      cpl1.status_line,
      sale_type_code,
      c1.cst_complete_sale


FROM oncd_company co1 WITH(NOLOCK)
inner JOIN oncd_contact_company cc1 WITH(NOLOCK) on cc1.company_id = co1.company_id
and cc1.primary_flag = 'y'
	AND co1.cst_center_number = @center
INNER JOIN oncd_contact c1 WITH(NOLOCK) on cc1.contact_id = c1.contact_id
INNER JOIN oncd_activity_contact acon1 WITH(NOLOCK) on c1.contact_id = acon1.contact_id

INNER JOIN oncd_activity a1 WITH(NOLOCK) on acon1.activity_id = a1.activity_id
	AND a1.due_date BETWEEN @begdt AND @enddt
	AND a1.action_code IN ('APPOINT', 'INHOUSE', 'BEBACK')
	AND a1.result_code NOT IN ('CANCEL', 'RESCHEDULE', 'CTREXCPTN', 'PRANK')
	AND a1.completion_date=convert(datetime,convert(varchar(11),getdate()))

LEFT OUTER JOIN oncd_contact_phone cp1 WITH(NOLOCK)
	  ON cp1.contact_id = c1.contact_id AND cp1.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_address ca1 WITH(NOLOCK)
	  ON ca1.contact_id = c1.contact_id AND ca1.primary_flag = 'Y'
LEFT OUTER JOIN oncd_activity_user au1 WITH(NOLOCK)
      ON au1.activity_id = a1.activity_id AND au1.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_source cs1 WITH(NOLOCK)
      ON cs1.contact_id = c1.contact_id AND cs1.primary_flag = 'Y'

LEFT OUTER JOIN cstd_contact_completion cpl1 WITH(NOLOCK)
	ON acon1.contact_id = cpl1.contact_id
	AND a1.activity_id = cpl1.activity_id

LEFT OUTER JOIN csta_promotion_code pc1 on pc1.promotion_code = c1.cst_promotion_code

LEFT OUTER JOIN oncd_contact_company cca1 WITH(NOLOCK) on cca1.contact_id = c1.contact_id
	and cca1.company_id <> co1.company_id
LEFT OUTER JOIN oncd_company AS coa1 ON coa1.company_id = cca1.company_id

ORDER BY 6,7
GO
