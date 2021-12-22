/* CreateDate: 10/17/2007 08:55:08.713 , ModifyDate: 05/01/2010 14:48:11.827 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[hcmsp_tmdetail_lead1] (@BegDt datetime, @EndDt datetime, @Terr varchar(4))  AS

--*******************************************************************************************************************************
--created by: Ben Singley
--date: 11 March 2002

--this stored procedure returns a result set based on an existing stored proc. At the bottom of this stored procedure, I have added 3 result sets and a
--summary. Please refer to them for additional information.

--@begdt  - Begin date of range formated in 'm/d/yy'
--@enddt - End date of range formated in 'm/d/yy'
-- @terr  - accepts a valid center number
--*******************************************************************************************************************************

SELECT
	center,
	type,
	a_appt = SUM(a_appt),
	b_appt = SUM(b_appt),
	appt	= SUM(appt),
	a_show	= SUM(a_show),
	b_show	= SUM(b_show),
	show	= SUM(show),
	a_sale	= SUM(a_sale),
	b_sale	= SUM(b_sale),
	sale	= SUM(sale)
INTO #shows
FROM
(
SELECT

'center' = CASE WHEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') IS NOT NULL THEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') ELSE (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag <> 'Y') END,
'type' =	 dbo.ENTRYPOINT(c.created_by_user_code),
'a_appt'  =  CASE WHEN dbo.ISAPPT(action_code)=1 AND czip.adi_flag = 'A' THEN 1 ELSE 0 END,
'b_appt'  =  CASE WHEN dbo.ISAPPT(action_code)=1  AND (czip.adi_flag <> 'A' OR czip.adi_flag IS NULL) THEN 1 ELSE 0 END,
'appt'      =  CASE WHEN dbo.ISAPPT(action_code)=1 THEN 1 ELSE 0 END,
'a_show' =  CASE WHEN dbo.ISSHOW(result_code)=1  AND czip.adi_flag = 'A' THEN 1 ELSE 0 END,
'b_show' =  CASE WHEN dbo.ISSHOW(result_code)=1  AND (czip.adi_flag <> 'A' OR czip.adi_flag  IS NULL) THEN 1 ELSE 0 END,
'show'   =  CASE WHEN dbo.ISSHOW(result_code)=1 THEN 1 ELSE 0 END,
'a_sale'   =  CASE WHEN dbo.ISSALE(result_code)=1  AND czip.adi_flag = 'A' THEN 1 ELSE 0 END,
'b_sale'   =  CASE WHEN dbo.ISSALE(result_code)=1  AND (czip.adi_flag <> 'A' OR czip.adi_flag  IS NULL) THEN 1 ELSE 0 END,
'sale'       = CASE WHEN dbo.ISSALE(result_code)=1 THEN 1 ELSE 0 END
FROM oncd_contact c WITH (NOLOCK)
LEFT OUTER JOIN oncd_contact_address ca
	ON c.contact_id = ca.contact_id
LEFT OUTER JOIN cstd_company_zip_code czip WITH (NOLOCK)
	ON ca.zip_code = czip.zip_from
INNER JOIN oncd_activity_contact ac
	ON ac.contact_id = c.contact_id AND ac.primary_flag = 'Y'
INNER JOIN oncd_activity a WITH (NOLOCK)
	ON a.activity_id = ac.activity_id
WHERE due_date BETWEEN @begdt AND @enddt
  	 AND CASE WHEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') IS NOT NULL THEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') ELSE (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag <> 'Y') END LIKE '[2378]__'
) temp
GROUP BY temp.center, temp.type

SELECT
'center' = CASE WHEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') IS NOT NULL THEN (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag = 'Y') ELSE (SELECT TOP 1 cst_center_number FROM oncd_company co INNER JOIN oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id AND primary_flag <> 'Y') END,
'source' = dbo.ENTRYPOINT(c.created_by_user_code),
c.contact_id recordid,
c.first_name contact_fname,
c.last_name contact_lname,
ca.zip_code zip,
czip.adi_flag adi_code,
c.created_by_user_code create_by,
c.creation_date create_date,
CONVERT(nchar(5),c.creation_date,108) create_time
INTO #leaddetail
FROM oncd_contact c WITH (NOLOCK)
left outer JOIN oncd_contact_address ca WITH (NOLOCK)
	ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
left outer JOIN cstd_company_zip_code czip WITH (NOLOCK)
	ON ca.zip_code = czip.zip_from
WHERE c.creation_date BETWEEN @begdt AND @enddt

SELECT
center,
'type' = source,
'a_lead' = SUM(CASE WHEN adi_code = 'A' THEN 1 ELSE 0 END),
'b_lead' = SUM(CASE WHEN adi_code <> 'A'  OR adi_code IS NULL THEN 1 ELSE 0 END),
'lead' = COUNT(*)
INTO #Leads
FROM #leaddetail
GROUP BY center, source

SELECT
czip.dma_code dma_,
#shows.center,
#shows.type,
MAX(co.company_name_1) terr_desc,
'a_lead' = SUM(a_lead),
'b_lead' = SUM(b_lead),
'lead'     = SUM(lead),

'a_appt' = SUM(a_appt),
'b_appt' = SUM(b_appt),
'appt'     = SUM(appt),

'a_show' = SUM(a_show),
'b_show' = SUM(b_show),
'show'     = SUM(show),

'a_sale' = SUM(a_sale),
'b_sale' = SUM(b_sale),
'sale'     = SUM(sale),

'a_appt/lead' =  dbo.DIVIDE( SUM(a_appt), SUM(a_lead)) * 100,
'b_appt/lead' =  dbo.DIVIDE( SUM(b_appt), SUM(b_lead)) * 100,
'appt/lead'     =  dbo.DIVIDE( SUM(appt), SUM(lead)) * 100,

'a_show/appt' = dbo.DIVIDE( SUM(a_show), SUM(a_appt)) * 100,
'b_show/appt' = dbo.DIVIDE( SUM(b_show), SUM(b_appt)) * 100,
'show/appt'     = dbo.DIVIDE( SUM(show), SUM(appt)) * 100,

'a_sale/show' = dbo.DIVIDE( SUM(a_sale), SUM(a_show)) * 100,
'b_sale/show' = dbo.DIVIDE( SUM(b_sale), SUM(b_show)) * 100,
'sale/show'     = dbo.DIVIDE( SUM(sale), SUM(show)) * 100,

'a_sale/lead' = dbo.DIVIDE( SUM(a_sale), SUM(a_lead)) * 100,
'b_sale/lead' = dbo.DIVIDE( SUM(b_sale), SUM(b_lead)) * 100,
'sale/lead'     = dbo.DIVIDE( SUM(sale), SUM(lead)) * 100
INTO #FINAL
FROM oncd_company co WITH (NOLOCK)
LEFT OUTER JOIN cstd_company_zip_code czip
	ON czip.company_id = co.company_id
full outer JOIN #Shows
	ON co.cst_center_number = #Shows.center
full outer JOIN #Leads
	ON #Shows.center = #Leads.center AND #Shows.Type = #Leads.Type
WHERE co.cst_center_number =@terr
--********************************************************************************************************************
--LIKE CASE WHEN @Flags='corp' THEN '[27]__' ELSE
--                                 CASE WHEN @Flags='fran' THEN '[8]__' ELSE
--                                    CASE WHEN @Flags='all'    THEN '[278]__' ELSE @Flags END END END
--removed from original stored proc. replaced with @terr parameter
--********************************************************************************************************************
GROUP BY czip.dma_code, #Shows.center , #Shows.Type
ORDER BY czip.dma_code, #Shows.center, #shows.type

select
f.center,
f.type,
f.a_lead,
f.b_lead,
f.lead,
l.recordid,
l.contact_fname + ' ' + l.contact_lname As ldname,
l.zip,
l.adi_code,
l.create_by,
l.create_date,
l.create_time
into #finals
from #final f
full outer join #leaddetail l on
	f.center=l.center
where l.center=@Terr

--*****************************************************************************************
--Modified by Ben Singley
--26 February 2002

--The above code is from the tmsummarybydma package. Its logic is required
--in the detail report to match lead count with actual leads.

--The following code matches the summary info with leads.

--SUMMARY:
--create two temporary tables and then full join them to produce a result set.
--report output is in the result set.
--*****************************************************************************************

--*****************************************************************************************
select
    'type' = dbo.ENTRYPOINT(c.created_by_user_code),
    c.contact_id recordid,
    c.last_name contact_lname,
    c.first_name contact_fname,
    ca.address_line_1 address1,
    ca.address_line_2 address2,
    ca.city,
    ca.state_code state,
    ca.zip_code zip,
    RTRIM(cp.area_code) + cp.phone_number phone,
    c.created_by_user_code create_by,
    c.creation_date create_date,
    CONVERT(nchar(5),c.creation_date,108) create_time
into #left
from oncd_contact c WITH (NOLOCK)
full outer join oncd_contact_address ca on
	ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
full outer join oncd_contact_phone cp on
	cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
where c.contact_id in (select recordid from #finals)
order by c.contact_id

--first temporary table
--*****************************************************************************************

--*****************************************************************************************


select
    a.result_code,
    a.due_date date_,
    CONVERT(nchar(5),a.start_time,108) time_,
    ac.contact_id recordid
into #right
from #finals f
FULL OUTER JOIN oncd_activity_contact ac
	ON ac.contact_id = f.recordid AND ac.primary_flag = 'Y'
INNER join oncd_activity a on
	a.activity_id = ac.activity_id
--where act_key=(Select Min(act_key) from gmin_mngr  WHERE f.recordid =m.recordid) and
--	 m.recordid in (select recordid from #finals)

--second temporary table
--*****************************************************************************************

--*****************************************************************************************
Select
    l.recordid,
    contact_lname,
    contact_fname,
    address1,
    address2,
    city,
    state,
    zip,
    '(' + RTRIM(area_code) + ')' + ' ' + substring(phone_number,1,3) + '-' + substring(phone_number,4,4) as phone,
    l.type,
    create_by,
    convert(char(11),create_date,1) as create_date,
    convert(char(5),left(create_time,5),1) as create_time,
    result_code,
    --date_,
    convert(char(11),date_,1) as date_,
    --time_
    convert(char(5),left(time_,5),1) as time_
from #left l
full outer join #right r on
	l.recordid=r.recordid
order by contact_lname,contact_fname
--result set for report
--*****************************************************************************************
GO
