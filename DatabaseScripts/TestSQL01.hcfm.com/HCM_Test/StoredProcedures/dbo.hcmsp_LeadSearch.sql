/* CreateDate: 06/06/2007 11:20:27.760 , ModifyDate: 05/01/2010 14:48:11.887 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[hcmsp_LeadSearch] (@cntr varchar(3), @lastname varchar(30)=Null, @firstname varchar(30)=NULL, @phone varchar(10)=NULL, @city varchar(30)=NULL, @state As varchar(2) = NULL , @zip As varchar(10) = NULL) AS

declare @where_str varchar(2000)
SELECT @where_str = NULL

Select @where_str = "WHERE (terr.territory_code=" + @cntr + " OR altc.cst_center_number = " + @cntr + ")  "
--^
IF @lastname IS NOT NULL
	SELECT @where_str = @where_str + " AND c.last_name Like '%" + @lastname + "%'"

IF @firstname IS NOT NULL
	SELECT @where_str = @where_str + " AND c.first_name Like '%" + @firstname + "%'"

IF @phone IS NOT NULL
	SELECT @where_str = @where_str + " AND (RTRIM(cp.area_code) + RTRIM(cp.phone_number))  = '" + @phone + "'"

IF @city IS NOT NULL
	SELECT @where_str = @where_str + " AND ca.city = '" + @city+ "'"

IF @state IS NOT NULL
	SELECT @where_str = @where_str + " AND ca.state_code = '" + @state+ "'"

IF @zip IS NOT NULL
	SELECT @where_str = @where_str + " AND ca.zip_code = '" + @zip + "'"

EXECUTE (
'SELECT distinct a.activity_id, terr.description, terr.territory_code, altc.cst_center_number, c.first_name, c.last_name, ca.city, ca.state_code, ca.zip_code, RTRIM(cp.area_code) + RTRIM(cp.phone_number) phone, cp.sort_order ' +
'FROM ' +
'oncd_contact c ' +
'INNER JOIN oncd_contact_phone cp ' +
'	 ON cp.contact_id = c.contact_id AND cp.primary_flag = ''Y'' ' +
'LEFT OUTER JOIN oncd_contact_company pcc ' +
'	 ON pcc.contact_id = c.contact_id AND pcc.primary_flag = ''Y'' ' +
'LEFT OUTER JOIN oncd_company pc ' +
'	ON pc.company_id = pcc.company_id ' +
'LEFT OUTER JOIN oncd_contact_company acc ' +
'	ON acc.contact_company_id = (SELECT TOP 1 contact_company_id FROM oncd_contact_company WHERE contact_id = c.contact_id AND primary_flag <> ''Y'' ORDER BY sort_order) ' +
'LEFT OUTER JOIN oncd_company altc ' +
'	ON altc.company_id = acc.company_id ' +
'INNER JOIN oncd_activity_contact ac
	ON ac.contact_id = c.contact_id AND ac.primary_flag = ''Y'' ' +
'INNER JOIN oncd_activity a ' +
'	 ON a.activity_id = ac.activity_id ' +
'INNER JOIN oncd_contact_source cs ' +
'	 ON cs.contact_id = c.contact_id AND cs.primary_flag = ''Y'' ' +
'INNER JOIN oncd_contact_address ca ' +
'	 ON ca.contact_id = c.contact_id AND ca.primary_flag = ''Y'' ' +
'LEFT OUTER JOIN oncd_contact_territory ct ' +
'	 ON c.contact_id = ct.contact_id ' +
'LEFT OUTER JOIN onca_territory terr ' +
'	 ON terr.territory_code = ct.territory_code ' +
@where_str +
' ORDER BY c.last_name, c.first_name'
)
GO
