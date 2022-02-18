/* CreateDate: 11/21/2017 17:50:02.580 , ModifyDate: 12/22/2017 14:45:08.960 */
GO
/*====================================================================================================
 Author:		Rachelen Hut
 Create date:	11/21/2017
 Description:	Shows differences for LEADS between the Oncontact tables, SFDC and BI

=======================================================================================================
CHANGE HISTORY:
11/29/2017 - RH - Added 'Client' as ContactStatusDescription when pulling data from DimContact
12/22/2017 - RH - Added contact_status_code NOT IN('Invalid','Test')
=======================================================================================================

EXEC [dbo].[rptHCM_SFDC_AuditDetail_Lead] '11/21/2017','11/21/2017'
=====================================================================================================*/

CREATE PROCEDURE [dbo].[rptHCM_SFDC_AuditDetail_Lead](
	@StartDate DATETIME
,	@EndDate DATETIME)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	SET @EndDate = @EndDate + '23:59.000'

/********** Create temp tables ********************************/

CREATE TABLE #SFDCTotal(
	cst_sfdc_lead_id NVARCHAR(18)
,	contact_id NVARCHAR(10)
,	creation_date DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)


CREATE TABLE #Leads_ONC_Pagelinx(
	cst_sfdc_lead_id NVARCHAR(18)
,	contact_id NVARCHAR(10)
,	creation_date DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)


CREATE TABLE #Leads_SFDC_Pagelinx(
	cst_sfdc_lead_id NVARCHAR(18)
,	contact_id NVARCHAR(10)
,	creation_date DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)


CREATE TABLE #LeadsNOTPagelinx(
	cst_sfdc_lead_id NVARCHAR(18)
,	contact_id NVARCHAR(10)
,	creation_date DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)

CREATE TABLE #BI_Contacts(
	SFDC_LeadID NVARCHAR(18)
,	ContactSSID NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)


CREATE TABLE #Differences(
	ObjectType NVARCHAR(150)
,	SFDC_LeadID NVARCHAR(18)
,	ContactSSID NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(150)
,	contact_status_code NVARCHAR(50)
)

/*************** LEADS ***************************************************/

--Get Leads Added to SFDC - Pagelinx or Center  - SF Pagelinx
INSERT INTO #Leads_SFDC_Pagelinx
SELECT cst_sfdc_lead_id
,	contact_id
,	create_date AS 'creation_date'
,	NULL AS FirstName
,	NULL AS LastName
,	NULL AS Center
,	upsert_status AS 'contact_status_code'
FROM [HC_SF_Bridge].[dbo].[HCM_SFDC_SuccessLog_Lead]
WHERE create_date  BETWEEN @StartDate AND @EndDate
GROUP BY cst_sfdc_lead_id
,	contact_id
,	create_date
,	upsert_status

--Get Leads added to OnContact by Pagelinx or Center - Onc Pagelinx
INSERT INTO #Leads_ONC_Pagelinx
SELECT OC.cst_sfdc_lead_id
,	OC.contact_id
,	OC.creation_date
,	RTRIM(LTRIM(OC.first_name)) AS 'FirstName'
,	RTRIM(LTRIM(OC.last_name)) AS 'LastName'
,	COMP.company_name_1 AS 'Center'
,	OC.contact_status_code
FROM HCM.dbo.oncd_contact AS OC
	INNER JOIN HCM.dbo.oncd_contact_company AS CC WITH (NOLOCK)
        ON OC.contact_id = CC.contact_id
	INNER JOIN HCM.dbo.oncd_company AS COMP WITH (NOLOCK)
        ON COMP.company_id = CC.company_id
WHERE (
            OC.created_by_user_code = 'TM 600'
            OR OC.created_by_user_code LIKE '[1-9]%'
        )
        AND OC.creation_date BETWEEN @StartDate AND @EndDate
		AND OC.contact_status_code NOT IN('Invalid','Test')
GROUP BY OC.cst_sfdc_lead_id
,	OC.contact_id
,	OC.creation_date
,	OC.first_name
,	OC.last_name
,	COMP.company_name_1
,	OC.contact_status_code


--Get Leads from Salesforce, but not from Pagelinx or Center
INSERT INTO #LeadsNOTPagelinx
SELECT  OC.cst_sfdc_lead_id
,	OC.contact_id
,	OC.creation_date
,	RTRIM(LTRIM(OC.first_name)) AS 'FirstName'
,	RTRIM(LTRIM(OC.last_name)) AS 'LastName'
,	COMP.company_name_1 AS 'Center'
,	OC.contact_status_code
FROM HCM.dbo.oncd_contact OC WITH (NOLOCK)
INNER JOIN HCM.dbo.oncd_contact_company AS CC WITH (NOLOCK)
    ON OC.contact_id = CC.contact_id
INNER JOIN HCM.dbo.oncd_company AS COMP WITH (NOLOCK)
    ON COMP.company_id = CC.company_id
WHERE (
            OC.created_by_user_code <> 'TM 600'
			OR OC.created_by_user_code NOT LIKE '[1-9]%'
        )
        AND OC.creation_date BETWEEN @StartDate AND @EndDate
		AND OC.contact_status_code NOT IN('Invalid','Test')
GROUP BY OC.cst_sfdc_lead_id
,	OC.contact_id
,	OC.creation_date
,	OC.first_name
,	OC.last_name
,	COMP.company_name_1
,	OC.contact_status_code


--Combine leads from SFDC Pagelinx and SFDC Not Pagelinx into one table as SFDC Total to compare with BI
INSERT INTO #SFDCTotal
SELECT cst_sfdc_lead_id
,	contact_id
,	creation_date
,	FirstName
,	LastName
,	Center
,	contact_status_code
FROM #Leads_SFDC_Pagelinx
UNION
SELECT cst_sfdc_lead_id
,	contact_id
,	creation_date
,	FirstName
,	LastName
,	Center
,	contact_status_code
FROM #LeadsNOTPagelinx


/******************* Find the BI Contacts *********************************************************************/

INSERT INTO #BI_Contacts
SELECT CON.SFDC_LeadID
,	CON.ContactSSID
,	CON.CreationDate
,	CON.ContactFirstName AS 'FirstName'
,	CON.ContactLastName AS 'LastName'
,	CON.ContactCenter AS 'Center'
,	CON.ContactStatusDescription AS 'contact_status_code'
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] CON
WHERE CON.CreationDate BETWEEN @StartDate AND @EndDate
	AND CON.ContactStatusDescription NOT IN('Invalid','Test')
GROUP BY CON.SFDC_LeadID
,	CON.ContactSSID
,	CON.CreationDate
,	CON.ContactFirstName
,	CON.ContactLastName
,	CON.ContactCenter
,	CON.ContactStatusDescription

/******************* Populate the differences with UNION statements **************************************/

INSERT INTO #Differences
--Find the differences between Onc Pagelinx and SFDC Pagelinx
SELECT 'This cst_sfdc_lead_id from Pagelinx in Salesforce does not exist in OnContact Pagelinx'
,	cst_sfdc_lead_id AS 'SFDC_LeadID'
,	contact_id AS 'ContactSSID'
,	creation_date  AS 'CreationDate'
,	NULL AS FirstName
,	NULL AS LastName
,	NULL AS Center
,	contact_status_code
FROM #Leads_SFDC_Pagelinx
WHERE cst_sfdc_lead_id NOT IN (SELECT cst_sfdc_lead_id FROM #Leads_ONC_Pagelinx)
AND contact_status_code NOT IN('Invalid','Test')
UNION
SELECT 'This cst_sfdc_lead_id from OnContact Pagelinx does not exist in Pagelinx records in Salesforce'
,	cst_sfdc_lead_id AS 'SFDC_LeadID'
,	contact_id AS 'ContactSSID'
,	creation_date  AS 'CreationDate'
,	FirstName
,	LastName
,	Center
,	contact_status_code
FROM #Leads_ONC_Pagelinx
WHERE cst_sfdc_lead_id NOT IN (SELECT cst_sfdc_lead_id FROM #Leads_SFDC_Pagelinx)
AND contact_status_code NOT IN('Invalid','Test')
UNION
--Now, find the differences between SFDC Total and BI and insert the records into the same table
SELECT 'This SFDC_LeadID is in BI but not present in the Salesforce records'
,	SFDC_LeadID
,	ContactSSID
,	CreationDate
,	FirstName
,	LastName
,	Center
,	contact_status_code
FROM #BI_Contacts
WHERE SFDC_LeadID NOT IN (SELECT cst_sfdc_lead_id FROM #SFDCTotal)
AND contact_status_code NOT IN('Invalid','Test')
UNION
SELECT 'This cst_sfdc_lead_id in Salesforce is not present as a SFDC_LeadID in the BI table, DimContact'
,	cst_sfdc_lead_id AS 'SFDC_LeadID'
,	contact_id AS 'ContactSSID'
,	creation_date AS 'CreationDate'
,	FirstName
,	LastName
,	Center
,	contact_status_code
FROM #SFDCTotal
WHERE cst_sfdc_lead_id NOT IN (SELECT SFDC_LeadID FROM #BI_Contacts)
AND FirstName IS NOT NULL
AND LastName IS NOT NULL
AND Center IS NOT NULL
AND contact_status_code NOT IN('Invalid','Test')
GROUP BY cst_sfdc_lead_id
,	contact_id
,	creation_date
,	FirstName
,	LastName
,	Center
,	contact_status_code

/*********** Add Double check to see if the record exists *********************************************/

SELECT *
FROM #Differences
WHERE SFDC_LeadID NOT IN(SELECT SFDC_LeadID FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact])

END;
GO
