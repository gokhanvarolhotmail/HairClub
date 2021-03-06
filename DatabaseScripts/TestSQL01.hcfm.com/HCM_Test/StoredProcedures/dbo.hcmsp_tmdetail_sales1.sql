/* CreateDate: 10/17/2007 08:55:08.840 , ModifyDate: 05/01/2010 14:48:11.800 */
GO
/*-----------------------------------------------
ALTER  Date: 10/25/01
Modified on: 11/20/01
Created By: Ben Singley

This stored procedure has been modified based on enhancements made to telemarketing business rules on 11/20/01.

Returns name, address, and adi_code for specified lead.

*/-----------------------------------------------


CREATE  PROCEDURE [dbo].[hcmsp_tmdetail_sales1]
( @BegDt datetime, @EndDt datetime, @Terr varchar(4)) AS

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
'(' + substring(cp.area_code,1,3) + ')' + ' ' + substring(cp.phone_number,1,3) + '-' + substring(cp.phone_number,4,4) as phone,
result_code,--added this, removed adi_code
convert(char(11),due_date,1) as date_,
convert(char(5),start_time,108) as time_

FROM oncd_contact c WITH (NOLOCK)
LEFT OUTER JOIN oncd_contact_address ca
	ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
LEFT OUTER JOIN oncd_contact_phone cp
	ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
INNER JOIN oncd_activity_contact ac
	ON ac.contact_id = c.contact_id AND ac.primary_flag = 'Y'
INNER JOIN oncd_activity a
	ON a.activity_id = ac.activity_id
WHERE due_date BETWEEN @begdt AND @enddt AND dbo.ISSALE(result_code)=1
  	 AND CASE WHEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') IS NOT NULL THEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') ELSE (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag <> 'Y') END = @Terr
ORDER BY due_date
GO
