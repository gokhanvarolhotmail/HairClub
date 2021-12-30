/* CreateDate: 11/21/2017 17:47:46.733 , ModifyDate: 12/22/2017 14:13:15.830 */
GO
/*=====================================================================================================
 Author:		Rachelen Hut
 Create date:	11/21/2017
 Description:	Shows differences for TASKS between the Oncontact tables, SFDC and BI
=======================================================================================================
CHANGE HISTORY:
12/22/2017 - RH - Removed comparison of Salesforce to OnContact; Added DOUBLE CHECK code at the end to verify that the records did not exist.
=======================================================================================================

EXEC [dbo].[rptHCM_SFDC_AuditDetail_Task] '11/21/2017','11/21/2017'
======================================================================================================*/

CREATE PROCEDURE [dbo].[rptHCM_SFDC_AuditDetail_Task](
	@StartDate DATETIME
,	@EndDate DATETIME)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	SET @EndDate = @EndDate + '23:59.000'


/**************** Create temp tables ******************************************************/

CREATE TABLE #SFDCLeadTaskAdded(
cst_sfdc_task_id NVARCHAR(18)
,	activity_id NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)


CREATE TABLE #OncActivitiesPagelinx(
cst_sfdc_task_id NVARCHAR(18)
,	activity_id NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)


CREATE TABLE #OncActivitiesNONPagelinx(
cst_sfdc_task_id NVARCHAR(18)
,	activity_id NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)


CREATE TABLE #TotalSFDC(
	SFDC_TaskID NVARCHAR(18)
,	ActivityID NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)


CREATE TABLE #OncontactActivities (
	ActivityID NVARCHAR(18)
,	ActType INT )


CREATE TABLE #BI_Activities(
SFDC_TaskID NVARCHAR(18)
,	ActivitySSID NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)


CREATE TABLE #Differ(
ObjectType NVARCHAR(150)
,	SFDC_TaskID NVARCHAR(18)
,	ActivityID NVARCHAR(10)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Center NVARCHAR(50)
,	ActionCode NVARCHAR(50)
,	ResultCode NVARCHAR(50)
)

/******************* TASKS ************************************************/

--Get Tasks Added to SFDC
INSERT INTO #SFDCLeadTaskAdded
SELECT LT.cst_sfdc_task_id
,	LT.activity_id
,	LT.create_date AS 'CreationDate'
,	NULL AS FirstName
,	NULL AS LastName
,	NULL AS CenterSSID
,	NULL AS 'ActionCode'
,	NULL AS 'ResultCode'
FROM [HC_SF_Bridge].[dbo].[HCM_SFDC_SuccessLog_LeadTask] AS [LT] WITH (NOLOCK)
WHERE LT.create_date BETWEEN @StartDate AND @EndDate
GROUP BY LT.cst_sfdc_task_id
       , LT.activity_id
       , LT.create_date;


-- Get Tasks Created in OnContact by Pagelinx or Center
INSERT INTO #OncActivitiesPagelinx
SELECT OA.cst_sfdc_task_id
,	OA.activity_id
,	OA.creation_date AS 'CreationDate'
,	OC.first_name AS 'FirstName'
,	OC.last_name AS 'LastName'
,	COMP.company_name_1 AS 'Center'
,	OA.action_code AS 'ActionCode'
,	OA.result_code AS 'ResultCode'
FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
    INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
        ON OAC.contact_id = OC.contact_id
    INNER JOIN HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
        ON OA.activity_id = OAC.activity_id
	INNER JOIN HCM.dbo.oncd_activity_company AS AC WITH (NOLOCK)
        ON OA.activity_id = AC.activity_id
	INNER JOIN HCM.dbo.oncd_company AS COMP WITH (NOLOCK)
        ON COMP.company_id = AC.company_id
WHERE (
            OA.created_by_user_code = 'TM 600'
            OR OA.created_by_user_code LIKE '[1-9]%'
        )
        AND OA.creation_date BETWEEN @StartDate AND @EndDate
        AND OA.cst_import_note != 'Activity created by Trigger'
GROUP BY OA.cst_sfdc_task_id
,	OA.activity_id
,	OA.creation_date
,	OC.first_name
,	OC.last_name
,	COMP.company_name_1
,	OA.action_code
,	OA.result_code;


-- Get Tasks NOT Created in OnContact by Pagelinx or Center
INSERT INTO #OncActivitiesNONPagelinx
SELECT OA.cst_sfdc_task_id
,	OA.activity_id
,	OA.creation_date AS 'CreationDate'
,	OC.first_name AS 'FirstName'
,	OC.last_name AS 'LastName'
,	COMP.company_name_1 AS 'Center'
,	OA.action_code AS 'ActionCode'
,	OA.result_code AS 'ResultCode'
FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
    INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
        ON OAC.contact_id = OC.contact_id
    INNER JOIN HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
        ON OA.activity_id = OAC.activity_id
	INNER JOIN HCM.dbo.oncd_activity_company AS AC WITH (NOLOCK)
        ON OA.activity_id = AC.activity_id
	INNER JOIN HCM.dbo.oncd_company AS COMP WITH (NOLOCK)
        ON COMP.company_id = AC.company_id
WHERE (
            OA.created_by_user_code <> 'TM 600'
			and OA.created_by_user_code NOT LIKE '[1-9]%'
        )
        AND OA.creation_date BETWEEN @StartDate AND @EndDate
        AND OA.cst_import_note != 'Activity created by Trigger'
GROUP BY  OA.cst_sfdc_task_id
,	OA.activity_id
,	OA.creation_date
,	OC.first_name
,	OC.last_name
,	COMP.company_name_1
,	OA.action_code
,	OA.result_code;


/********** Create a temp tables for all Activities for the day **************************/

--Find Oncontact activities for that date range --insert them into a table for speed

INSERT INTO #OncontactActivities
SELECT OA.activity_id AS 'ActivityID', 1 AS ActType					--Group by activity_id
	FROM  HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
    INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
        ON OAC.activity_id = OA.activity_id
	WHERE OAC.creation_date BETWEEN @StartDate AND @EndDate
	GROUP BY OA.activity_id
UNION
SELECT OA.cst_sfdc_task_id AS 'ActivityID', 2 AS ActType			--Group by cst_sfdc_task_id
	FROM  HCM.dbo.oncd_activity AS OA WITH (NOLOCK)
    INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
        ON OAC.activity_id = OA.activity_id
	WHERE OAC.creation_date BETWEEN @StartDate AND @EndDate
	GROUP BY OA.cst_sfdc_task_id



/********************* Find BI Activities  *****************************************************************************************/

INSERT INTO #BI_Activities
SELECT DA.SFDC_TaskID
,	DA.ActivitySSID
,	NULL AS CreationDate
,	DC.ContactFirstName AS 'FirstName'
,	DC.ContactLastName AS 'LastName'
,	DA.CenterSSID AS 'Center'
,	DA.ActionCodeDescription AS 'ActionCode'
,	DA.ResultCodeDescription AS 'ResultCode'
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity] DA WITH (NOLOCK)
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC WITH (NOLOCK)
	ON (DC.ContactSSID = DA.ContactSSID OR (DC.ContactSSID IS NULL AND DC.SFDC_LeadID = DA.SFDC_LeadID))
WHERE (DA.ActivitySSID IN (SELECT ActivityID FROM #OncontactActivities  WHERE ActType = 1)  --Group by activity_id
		OR (DA.ActivitySSID IS NULL AND DA.SFDC_TaskID IN (SELECT ActivityID FROM #OncontactActivities WHERE ActType = 2))) --Group by cst_sfdc_task_id
	AND DA.ActionCodeDescription IN ( 'APPOINT' , 'INHOUSE', 'BEBACK' )
				AND (DA.ResultCodeDescription NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN','VOID' ) OR  DA.ResultCodeDescription IS NULL OR  DA.ResultCodeDescription = '' OR DA.ResultCodeDescription IN('SHOWNOSALE','NOSHOW','SHOWSALE'))
GROUP BY DA.SFDC_TaskID
,	DA.ActivitySSID
,	DC.ContactFirstName
,	DC.ContactLastName
,	DA.CenterSSID
,	DA.ActionCodeDescription
,	DA.ResultCodeDescription

/*************** Combine SF Pagelinx and SF Not Pagelinx into a Total set ***************/

INSERT INTO #TotalSFDC
SELECT	cst_sfdc_task_id
      , activity_id
      , CreationDate
      , FirstName
      , LastName
      , Center
      , ActionCode
      , ResultCode
FROM #OncActivitiesPagelinx
WHERE ActionCode IN ( 'APPOINT' , 'INHOUSE', 'BEBACK' )
				AND (ResultCode NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN','VOID' ) OR  ResultCode IS NULL OR  ResultCode = '' OR ResultCode IN('SHOWNOSALE','NOSHOW','SHOWSALE'))
UNION ALL
SELECT cst_sfdc_task_id
      , activity_id
      , CreationDate
      , FirstName
      , LastName
      , Center
      , ActionCode
      , ResultCode
FROM #OncActivitiesNONPagelinx
WHERE ActionCode IN ( 'APPOINT' , 'INHOUSE', 'BEBACK' )
				AND (ResultCode NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN','VOID' ) OR  ResultCode IS NULL OR  ResultCode = '' OR ResultCode IN('SHOWNOSALE','NOSHOW','SHOWSALE'))


/******************* Find Differences ***************************************************/

INSERT INTO #Differ

SELECT 'These Salesforce TaskIDs or ActivityIDs are not in the BI tables'
,	SFDC_TaskID
,	ActivityID
,	CreationDate
,	FirstName
,	LastName
,	Center
,	ActionCode
,	ResultCode
FROM #TotalSFDC
WHERE SFDC_TaskID NOT IN (SELECT SFDC_TaskID FROM #BI_Activities)
UNION ALL
SELECT 'These SFDC_TaskIDs or ActivitySSIDs from BI are not in the Bridge table'
,	SFDC_TaskID
,	ActivitySSID
,	CreationDate
,	FirstName
,	LastName
,	Center
,	ActionCode
,	ResultCode
FROM #BI_Activities
WHERE SFDC_TaskID NOT IN (SELECT SFDC_TaskID FROM #TotalSFDC)

/*********** Add a DOUBLE CHECK at the end to verify that the records do not exist *****************************************/

--It is possible that the ActivityID actually exists in DimActivity with a later date:
SELECT *
FROM #Differ
WHERE ActivityID NOT IN(SELECT ActivitySSID FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity WHERE ActivityDueDate >= @StartDate)

--It is possible that the SFDC_TaskID actually exists in Salesforce (Dom's table):
SELECT *
FROM #Differ
WHERE SFDC_TaskID NOT IN (SELECT cst_sfdc_task_id FROM dbo.SFDC_HCM_LeadTask AS [LT] WITH (NOLOCK))

END;
GO
