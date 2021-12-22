/* CreateDate: 10/17/2007 08:55:08.760 , ModifyDate: 05/01/2010 14:48:11.857 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------
ALTER  Date: 10/25/01
Modified on: 09/11/07
Created By: Ben Singley

This stored procedure has been modified based on changes made to telemarketing business rules on 11/20/01.

Returns name, address, and adi code, for specified
lead.

MJW Modified for ONCV Schema
*/-----------------------------------------------


CREATE   PROCEDURE [dbo].[hcmsp_tmdetail_appts1] ( @BegDt datetime, @EndDt datetime, @Terr int)
AS

SELECT

'Center' = @Terr,

'type' = dbo.ENTRYPOINT(c.created_by_user_code),

c.contact_id recordid,
c.last_name contact_lname,
c.first_name contact_fname,
ca.address_line_1 address1,
ca.address_line_2 address2,
ca.city,
ca.state_code state,
ca.zip_code zip,
'(' + RTRIM(area_code) + ')' + ' ' + substring(cp.phone_number,1,3) + '-' + substring(cp.phone_number,4,4) as phone,
action_code act_code, --added this, removed adi_code
convert(char(11),due_date,1) as date_,
convert(char(5),start_time,108) as time_

FROM oncd_contact c WITH (NOLOCK)
LEFT OUTER JOIN oncd_contact_address ca
	ON c.contact_id = ca.contact_id AND ca.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_phone cp
	ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
INNER JOIN oncd_activity_contact ac
	ON ac.contact_id = c.contact_id AND ac.primary_flag = 'Y'
INNER JOIN oncd_activity a
	ON a.activity_id = ac.activity_id
WHERE a.due_date BETWEEN @BegDt AND @EndDt AND dbo.ISAPPT(a.action_code)=1
	AND CASE WHEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') IS NOT NULL THEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') ELSE (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag <> 'Y') END = @Terr
ORDER BY c.last_name, c.first_name
GO
