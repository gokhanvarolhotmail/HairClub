/* CreateDate: 01/11/2007 17:06:08.410 , ModifyDate: 05/01/2010 14:48:11.917 */
GO
/* TOP ADDED FOR TESTING ONLY!!! REMOVE FOR LIVE DEPLOYENT */
/** ORIGINAL DATE WAS 1/1/1999 **/

CREATE   PROCEDURE [dbo].[hcmsp_LeadMerge] AS
DECLARE @begdt as datetime
DECLARE @enddt as datetime

SELECT @begdt = '6/1/2007' /** ORIGINAL DATE WAS 1/1/1999 **/
SELECT @enddt = getdate()

DROP TABLE cstd_hcmtbl_leads_duplicated
DROP TABLE cstd_hcmtbl_leads_unqualified

SELECT top 15000  /* TOP ADDED FOR TESTING ONLY!!! REMOVE FOR LIVE DEPLOYENT */
	dbo.oncd_contact.contact_id,
	dbo.oncd_contact.first_name,
	dbo.oncd_contact.last_name,
	dbo.oncd_contact.creation_date,
	--dbo.oncd_contact.create_time,
	dbo.oncd_contact.created_by_user_code,
	dbo.oncd_contact_phone.area_code,
	dbo.oncd_contact_phone.phone_number,
	dbo.oncd_contact_address.address_line_1,
	dbo.oncd_contact_address.address_line_2,
	dbo.oncd_contact_address.city,
	dbo.oncd_contact_address.state_code,
	dbo.oncd_contact_address.zip_code,
	dbo.oncd_contact_email.email,
  dbo.oncd_contact.cst_gender_code,
	dbo.oncd_contact.cst_promotion_code,
	dbo.oncd_contact.cst_complete_sale
INTO #leads
FROM dbo.oncd_contact
left outer join oncd_contact_phone
  on oncd_contact.contact_id = oncd_contact_phone.contact_id and
	phone_number NOT IN('0000000','','1111111','9999999') and
	oncd_contact_phone.contact_phone_id = (
	select top 1 cp.contact_phone_id
	from oncd_contact_phone cp, onca_phone_type
	where oncd_contact.contact_id=cp.contact_id and
	((onca_phone_type.device_type='P' or onca_phone_type.device_type='T')
	and onca_phone_type.phone_type_code=cp.phone_type_code)order by primary_flag desc,sort_order asc)
LEFT OUTER JOIN oncd_contact_address
	ON dbo.oncd_contact.contact_id = dbo.oncd_contact_address.contact_id
	and oncd_contact_address.contact_address_id = (
	select top 1 ca.contact_address_id
	from oncd_contact_address ca
	left outer join onca_time_zone on (ca.time_zone_code = onca_time_zone.time_zone_code)
	WHERE  oncd_contact.contact_id = ca.contact_id
	order by primary_flag desc, sort_order asc)
LEFT OUTER JOIN oncd_contact_email
	ON dbo.oncd_contact.contact_id = dbo.oncd_contact_email.contact_id
	and oncd_contact_email.contact_email_id = (
	select top 1 ce.contact_email_id
	from oncd_contact_email ce
	where oncd_contact.contact_id = ce.contact_id
	order by primary_flag desc, sort_order asc)
WHERE oncd_contact.creation_date BETWEEN @begdt AND @enddt

CREATE INDEX IX_TempLeads_contact_id On Tempdb.#leads(contact_id)


SELECT distinct a.contact_id aid, a.first_name afname,a.last_name alname,a.phone_number aphone,a.area_code aarea_code,b.contact_id bid, b.first_name bfname,b.last_name blname,b.phone_number bphone,a.area_code barea_code,b.creation_date bcreation, a.creation_date acreation
INTO #dups
FROM #leads a
INNER JOIN #leads b
ON  a.last_name = b.last_name
AND a.phone_number = b.phone_number
and a.area_code = b.area_code
AND  a.contact_id <> b.contact_id
WHERE b.creation_date>@begdt


CREATE INDEX IX_Tempdups_contact_id On Tempdb.#leads(contact_id)

DELETE #dups
WHERE LEFT(afname,1)<>LEFT(bfname,1)

SELECT DISTINCT aid contact_id, afname first_name, alname last_name, aphone phone,aarea_code area_code,acreation creation_date
INTO #temp
FROM #dups
UNION
SELECT bid,bfname,blname,bphone,barea_code,bcreation
FROM #dups

SELECT a.contact_id, b.contact_id mx_contact_id,d.contact_id min_contact_id, a.last_name,a.phone, a.area_code--,count(*) 'count'
INTO #newid
FROM #temp a,#temp b,#temp d
where  b.contact_id = (select top 1 c.contact_id from #temp c where (c.last_name = b.last_name and b.phone = c.phone and b.area_code = c.area_code )order by creation_date desc)
and a.contact_id <> b.contact_id
and d.contact_id = (select top 1 c.contact_id from #temp c where (c.last_name = b.last_name and b.phone = c.phone and b.area_code = c.area_code )order by creation_date asc)

SELECT distinct b.min_contact_id mynewid,a.contact_id,a.first_name,a.last_name
INTO #newid_1tomany
FROM #temp a
INNER JOIN #newid b
ON  a.last_name = b.last_name
AND a.phone = b.phone
and a.area_code = b.area_code

SELECT distinct b.mx_contact_id mynewid,b.min_contact_id origid,a.contact_id,a.first_name,a.last_name
INTO #newid_1tomany_max
FROM #temp a
INNER JOIN #newid b
ON  a.last_name = b.last_name
AND a.phone = b.phone
and a.area_code = b.area_code

SELECT distinct *
INTO cstd_hcmtbl_leads_duplicated
FROM #newid_1tomany
where mynewid<>contact_id

SELECT *
INTO #deletes_contact_info
FROM #newid_1tomany_max
WHERE mynewid<>contact_id

DELETE oncd_contact_phone
FROM oncd_contact_phone with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_phone.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_phone
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_phone with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_phone.contact_id = #deletes_contact_info.mynewid

DELETE oncd_contact_address
FROM oncd_contact_address with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_address.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_address
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_address with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_address.contact_id = #deletes_contact_info.mynewid

DELETE oncd_contact_list
FROM oncd_contact_list with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_list.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_list
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_list with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_list.contact_id = #deletes_contact_info.mynewid

DELETE oncd_contact_company
FROM oncd_contact_company with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_company.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_company
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_company with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_company.contact_id = #deletes_contact_info.mynewid

DELETE oncd_contact_email
FROM oncd_contact_email with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_email.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_email
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_email with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_email.contact_id = #deletes_contact_info.mynewid

DELETE oncd_contact_interest
FROM oncd_contact_interest with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_interest.contact_id = #deletes_contact_info.contact_id

UPDATE oncd_contact_interest
SET contact_id=#deletes_contact_info.origid
FROM oncd_contact_interest with (NOLOCK)
INNER JOIN #deletes_contact_info with (NOLOCK)
ON oncd_contact_interest.contact_id = #deletes_contact_info.mynewid

UPDATE oncd_activity_contact
SET contact_id = #newid_1tomany.mynewid
FROM oncd_activity_contact with (NOLOCK)
INNER JOIN #newid_1tomany with (NOLOCK)
ON oncd_activity_contact.contact_id = #newid_1tomany.contact_id

DELETE oncd_contact
FROM oncd_contact with (NOLOCK)
INNER JOIN cstd_hcmtbl_leads_duplicated with (NOLOCK)
ON oncd_contact.contact_id = cstd_hcmtbl_leads_duplicated.contact_id

SELECT *
INTO cstd_hcmtbl_leads_unqualified
FROM #leads
WHERE CASE WHEN ((first_name IS NOT NULL AND first_name <>'') or (last_name IS NOT NULL AND last_name <>''))
AND ((email IS NOT NULL AND email<>'') or (phone_number IS NOT NULL AND phone_number<>'') or ((address_line_1 IS NOT NULL AND address_line_1<>'') AND (city IS NOT NULL AND city<>'') AND (state_code IS NOT NULL AND state_code<>'')) OR ((address_line_1 IS NOT NULL AND address_line_1<>'') AND (city IS NOT NULL AND city<>'') AND (zip_code IS NOT NULL AND zip_code<>''))) THEN 1 ELSE 0 END = 0

/* If the cstd_hcmtbl_leads_unqualified table is not created the job fails.
BK: yes, this is a kludge. Added to avoid rewritting the DTS package HCM Lead daily cleanup.  */

IF NOT EXISTS (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'cstd_hcmtbl_leads_unqualified')
BEGIN
	CREATE TABLE cstd_hcmtbl_leads_unqualified
		(
		  contact_id nchar (10) null
		, first_name nchar (50) NULL
		, last_name nchar(50) NULL
		, creation_date   datetime NULL
		--, create_time	varchar(12) NULL
		, created_by_user_code  nchar(20)
		, area_code nchar(10)
		, phone_number nchar(20) NULL
		, address_line_1  nchar(60) NULL
		, address_line_2  nchar(60) NULL
		, city   nchar(60) NULL
		, state_code nchar(20) NULL
		, zip_code nchar(15) NULL
		--, adi_code varchar(8) NULL
		, email_ nvarchar(100) NULL
		--, territory int  NULL
		--, alt_center int NULL
		, cst_gender_code nchar(10)  NULL
		, cst_promotion_code nchar(10) NULL
		, cst_complete_sale int  NULL
		)
END

DELETE oncd_contact
FROM oncd_contact with (NOLOCK)
INNER JOIN cstd_hcmtbl_leads_unqualified
ON oncd_contact.contact_id=cstd_hcmtbl_leads_unqualified.contact_id
GO
