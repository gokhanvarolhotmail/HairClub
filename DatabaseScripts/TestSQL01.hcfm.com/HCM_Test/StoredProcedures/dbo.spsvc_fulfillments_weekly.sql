/* CreateDate: 10/17/2007 08:48:13.860 , ModifyDate: 10/10/2016 15:38:52.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SP:	spsvc_fulfillments_weekly
	Desc: 	This procedure is latest implementation of hcmsp_fullfilments.  The changes that were made
		were to remove the creation of male and female tables and just use one common table to be
		consumed by the DTS package for fulfillments. Also a new "type" field was added to handle
		Spanish and Surgical brochures
	Developer: Howard Abelow
	Date: 	03/23/2006
	Modified: 10/2/2007 HAbelow - completedly updated for ONCV
	Updated: 01/04/2008	wbeaton - Added Distinct on select per Kevin
								- Called function in where clause for dbo.ISNOSHOW(a.result_code)=1
								- Changed order of events in where clause to speed up execution
								- Removed ISSHOW
	Considerations: Changing entire select to dirty read for performance reasons.

	Modified:	6/26/2009
	By:			Oncontact PSO Fred Remers
				Added primary phone number
	Modified:	9/23/2015
	By:			Workwise PSO MWegner
				Add RemoveUnicode to editable fields


  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[spsvc_fulfillments_weekly] AS

DECLARE @cname as char(3)
DECLARE @begdt as datetime
DECLARE @enddt as datetime
DECLARE @filename as varchar(25)
DECLARE @runDate AS DATETIME

SET @runDate = GETDATE()

SELECT @cname = 'HCM'
SELECT @begdt =  CAST(convert(varchar(11),dateadd(dd,-7,@runDate)) AS DATETIME)
SELECT @enddt = CAST(convert(varchar(11),@runDate) AS DATETIME)  + ' 23:59:59'
SELECT @filename = @cname + 'Weekly' + CAST(MONTH(@runDate) as varchar(2))+ CAST(DAY(@runDate) as varchar(2)) + CAST(YEAR(@runDate) as varchar(4)) + '.txt'

--SELECT @begdt =  '1/19/09'
--SELECT @enddt = '1/26/09 23:59:59'
--SELECT @filename = 'HCMWeekly1262009.txt'

SET NOCOUNT ON

IF EXISTS(Select name from sysobjects where name='hcmtbl_fulfillments_all')
BEGIN
	TRUNCATE TABLE hcmtbl_fulfillments_all
--	DROP TABLE hcmtbl_fulfillments_all
END

-- Select leads that had appointments and no shows
SELECT DISTINCT
  		info.contact_id
  	,	dbo.RemoveUnicode(info.first_name) AS first_name
  	,	dbo.RemoveUnicode(info.last_name) AS last_name
	,	dbo.RemoveUnicode(info.[address_line_1]) AS address_line_1
	,	dbo.RemoveUnicode(info.[address_line_2]) AS address_line_2
	,	dbo.RemoveUnicode(info.[city]) AS city
	,	info.[state_code]
	,	info.[zip_code]
  	,	info.[creation_date]
  	,	info.created_by_user_code
  	,	info.cst_promotion_code
	,	info.cst_gender_code
	,	info.[cst_language_code]
	,	CASE WHEN info.alt_center IS NULL OR LEN(LTRIM(info.alt_center)) = 0 THEN info.territory ELSE info.alt_center END AS Center
	,	CASE WHEN info.cst_promotion_code LIKE '%595%' THEN 'B' ELSE 'A' END AS Promo2
	,	info.email
	,	RTRIM(cp.area_code) + RTRIM(cp.phone_number) as phone
INTO #leads
FROM [lead_info] info
	INNER JOIN  oncd_activity_contact ac
		ON info.contact_id = ac.contact_id
	INNER JOIN oncd_activity a
		ON ac.activity_id = a.activity_id
	LEFT OUTER JOIN oncd_contact_phone cp on cp.contact_id = info.contact_id
		and cp.primary_flag = 'Y'
WHERE a.[due_date] BETWEEN @begdt AND @enddt
	AND dbo.ISAPPT(a.[action_code])=1
	AND dbo.ISNOSHOW(a.result_code)=1
	AND (info.[first_name] IS NOT NULL OR LEN(LTRIM(RTRIM(info.[first_name]))) > 0)
	AND (info.[last_name] IS NOT NULL OR LEN(LTRIM(RTRIM(info.[last_name]))) > 0)
	AND (info.[zip_code] IS NOT NULL OR LEN(LTRIM(RTRIM(info.[zip_code]))) > 0)
	AND (info.cst_gender_code IS NOT NULL OR LEN(LTRIM(RTRIM(info.cst_gender_code))) > 0)
	AND a.cst_brochure_download = 'N'


CREATE INDEX IX_TempLeads_contact_id On Tempdb.#leads(contact_id)



-- delete pranks
DELETE #leads
FROM #leads
	INNER JOIN oncd_activity_contact ac
		ON #leads.[contact_id] = ac.[contact_id]
	INNER JOIN oncd_activity a
		ON a.activity_id = ac.activity_id
    WHERE
		a.action_code = 'PRANK'
		AND a.creation_date BETWEEN @begdt AND @enddt

-- delete shows
DELETE #leads
FROM #leads
	INNER JOIN oncd_activity_contact ac
		ON #leads.[contact_id] = ac.[contact_id]
	INNER JOIN oncd_activity a
		ON a.activity_id = ac.activity_id
    WHERE
		a.[result_code] LIKE 'SHOW%'
		AND a.[completion_date] BETWEEN @begdt AND @enddt

-- delete sales
DELETE #leads
FROM #leads
	INNER JOIN oncd_activity_contact ac
		ON #leads.[contact_id] = ac.[contact_id]
	INNER JOIN oncd_activity a
		ON a.activity_id = ac.activity_id
    WHERE
		a.[result_code] LIKE '%SALE%'
		AND a.[completion_date] BETWEEN @begdt AND @enddt


CREATE INDEX IX_Temp_leads_state_code On Tempdb.#leads(state_code)

CREATE INDEX IX_Temp_leads_zip_code On Tempdb.#leads(zip_code)


/*ATTEMPT TO DELETE ANY INVALID ADDRESSES*/
DELETE #leads
WHERE SUBSTRING([address_line_1],1,3)=SUBSTRING([address_line_1],4,3)

DELETE #leads
WHERE [state_code]='XX'

DELETE #leads
WHERE [zip_code] NOT IN (select zip_code from onca_zip)

UPDATE #leads
SET
		[city]=onca_zip.city
	,	[state_code]=onca_zip.state_code
FROM #leads
	INNER JOIN onca_zip
		ON #leads.[zip_code]=onca_zip.zip_code


-- populate table
INSERT INTO hcmtbl_fulfillments_all
SELECT
		'recordid' = #leads.contact_id
	,	'center number' = CC.CenterID
	,	'center name' = @cname
	,	'center address 1' = CASE WHEN CC.CenterID LIKE '2%' THEN '1515 S. Federal Hwy' ELSE cc.[address1] END
	,	'center address 2' = CASE WHEN CC.CenterID LIKE '2%' THEN 'Suite 401' ELSE cc.[address2] END
	,	'center city' = CASE WHEN CC.CenterID LIKE '2%' THEN 'Boca Raton' ELSE cc.city END
	,	'center state' = CASE WHEN CC.CenterID LIKE '2%' THEN 'FL' ELSE LS.statedescriptionshort END
	,	'center zip' = CASE WHEN CC.CenterID LIKE '2%' THEN '33432' ELSE cc.postalcode END
	,	'contact fname' = RTRIM(#leads.first_name)
	,	'contact lname' = RTRIM(#leads.last_name)
	,	'contact address 1' = RTRIM(#leads.address_line_1)
	,	'contact address 2' = RTRIM(#leads.address_line_2)
	,	'contact city' = RTRIM(#leads.city)
	,	'contact state' = RTRIM(#leads.state_code)
	,	'contact zip' = RTRIM(#leads.zip_code)
	,	'contact create date' = #leads.creation_date
	,	'promo' = RTRIM(#leads.cst_promotion_code)
	,	'create by' = RTRIM(#leads.created_by_user_code)
	,	'promo2' = #leads.promo2
	,	'cst_gender' = RTRIM(#leads.cst_gender_code)
	-- use this for the different type of brochure
	,	'type' = dbo.GETTYPECODE(#leads.cst_language_code, #leads.cst_gender_code)
	,	'filename' = @filename
	,	'email' = RTRIM(#leads.email)
	,	'phone' = #leads.phone
FROM #leads
	INNER JOIN SQL01.HairClubCMS.dbo.cfgCenter CC
		ON #leads.center = CC.CenterID
	INNER JOIN SQL01.HairClubCMS.dbo.lkpState LS
		on CC.StateID = LS.StateID
GO
