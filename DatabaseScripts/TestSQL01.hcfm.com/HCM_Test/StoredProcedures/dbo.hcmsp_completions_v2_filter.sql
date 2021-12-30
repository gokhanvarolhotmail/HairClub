/* CreateDate: 06/06/2007 11:20:07.620 , ModifyDate: 05/01/2010 14:48:12.043 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[hcmsp_completions_v2_filter]    Script Date: 02/27/2007 17:17:43 ******/

CREATE PROCEDURE [dbo].[hcmsp_completions_v2_filter](@contact_id as nchar(10)) AS

declare @act_key nchar(10)
select @act_key = (SELECT TOP 1 oncd_activity.activity_id FROM oncd_activity
	INNER JOIN oncd_activity_contact ON oncd_activity_contact.activity_id = oncd_activity.activity_id
	WHERE action_code in ('APPOINT','INHOUSE','RECOVERY','INCALL','OUTCALL','CONFIRM')
	and contact_id=@contact_id
	ORDER BY oncd_activity.creation_date DESC)

SELECT
c.contact_id,
a.activity_id,

pc.cst_center_number territory,
altc.cst_center_number alt_center,
ct.territory_code,

a.due_date,
a.start_time,

c.first_name,
c.last_name,
cp.phone_number,
ca.city,
ca.state_code,
ca.zip_code,

'master'=au.user_code,--supposed to show sales person code (per A. Scott 3/11/02)
--mngr.master,
a.action_code,
a.result_code,
cs.source_code,
c.cst_promotion_code

FROM oncd_contact c
LEFT OUTER JOIN oncd_contact_company pcc
	ON pcc.contact_id = c.contact_id AND pcc.primary_flag = 'Y'
LEFT OUTER JOIN oncd_company pc
	ON pc.company_id = pcc.company_id
LEFT OUTER JOIN oncd_contact_company acc
	ON acc.contact_company_id = (SELECT TOP 1 contact_company_id FROM oncd_contact_company WHERE contact_id = c.contact_id AND primary_flag <> 'Y' ORDER BY sort_order)
LEFT OUTER JOIN oncd_company altc
	ON altc.company_id = acc.company_id
INNER JOIN oncd_contact_phone cp
	ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
INNER JOIN oncd_activity_contact ac
	ON ac.contact_id = c.contact_id AND ac.primary_flag = 'Y'
INNER JOIN oncd_activity a
	ON a.activity_id = ac.activity_id
INNER JOIN oncd_contact_source cs
	ON cs.contact_id = c.contact_id AND cs.primary_flag = 'Y'
INNER JOIN oncd_contact_address ca
	ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
INNER JOIN oncd_contact_territory ct
	on c.contact_id=ct.contact_id AND ct.primary_flag = 'Y'
LEFT OUTER JOIN oncd_activity_user au
	ON au.activity_id = a.activity_id AND au.primary_flag = 'Y'
WHERE (CASE WHEN altc.cst_center_number >0 OR altc.cst_center_number IS NOT NULL THEN altc.cst_center_number ELSE pc.cst_center_number END  LIKE '[2378]__') AND
	c.contact_id = @contact_id AND
	a.activity_id=@act_key

ORDER BY a.due_date, a.start_time
GO
