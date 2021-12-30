/* CreateDate: 09/04/2020 10:10:50.453 , ModifyDate: 02/04/2021 13:26:50.347 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ProcessBPDimCallData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Kevin Murdoch
DATE IMPLEMENTED:		9/4/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

	09/23/2020	KMurdoch	Removed spaces from Agent Disposition Name to miminize errors
	09/23/2020  KMurdoch    Removed Line Feeds from Disposition Notes
	09/23/2020  KMurdoch    Revised code to capture correct Lead Phone Number
	10/09/2020  KMurdoch	Added SMS Call Type Group for SMS calls
	01/2//2021  KMurdoch    Fixed the issue where service name is blank and it wasn't deriving a call type correctly
	01/29/2021  KMurdoch    Added join to Task from custom3 in Bright Pattern data, derived source code and task ID
	02/04/2021	KMurdoch    Modified LeadPhone to exclude SMS; also corrected to use Initial phone
	02/04/2021	KMurdoch    Modified InboundPhone to be Initial Inbound phone
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ProcessBPDimCallData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_ProcessBPDimCallData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/


CREATE TABLE #Noble (
	BPpk_ID INT,
	Media_Type NVARCHAR(50),
	CenterSSID NVARCHAR(10),
	CenterName NVARCHAR(50),
	Call_Date DATE,
	Call_Time VARCHAR(8),
	Service_Name VARCHAR(255),
	Caller_Phone_Type NVARCHAR(50),
	Callee_Phone_Type NVARCHAR(50),
	Call_Type_Group NVARCHAR(50),
	InboundSourceSSID NVARCHAR(30),
	Inbound_Campaign_ID NVARCHAR(18),
	Inbound_Campaign_Name NVARCHAR(255),
	LeadSourceSSID NVARCHAR(30),
	Lead_Campaign_ID NVARCHAR(18),
	Lead_Campaign_Name NVARCHAR(255),
	Agent_Disposition NVARCHAR(255),
	Agent_Disposition_Notes NVARCHAR(MAX),
	System_Disposition NVARCHAR(255),
	Lead_Phone NVARCHAR(50),
	Inbound_Phone NVARCHAR(50),
	SFDC_LeadID NVARCHAR(18),
	LeadStatus NVARCHAR(50),
	SFDC_TaskID NVARCHAR(18),
	TaskSourceSSID NVARCHAR(30),
	Task_Campaign_ID NVARCHAR(18),
	User_Login_ID VARCHAR(255),
	User_Login_Name VARCHAR(255),
	Is_Viable_Call INT,
	Is_Productive_Call INT,
	Call_Length INT,
	IVR_Time INT,
	Queue_Time INT,
	Pending_Time INT,
	Talk_Time INT,
	Hold_Time INT
)

CREATE TABLE #Phone (
	RowID INT IDENTITY(1,1)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	Lead__c NVARCHAR(18)
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(80)
,	Status NVARCHAR(50)
,	Source_Code_Legacy__c NVARCHAR(50)
,	PhoneAbr__c NVARCHAR(50)
)


/********************************** Get Bright Pattern Call Data using DeDuped Data *************************************/
INSERT	INTO #Noble

		SELECT BPCD.pkid AS 'BPpk_ID',
			   BPCD.media_type AS 'Media_Type',
			   ISNULL(l.CenterNumber__c, l.CenterID__c) AS 'CenterSSID',
			   NULL AS 'CenterName',
			   HC_Marketing.dbo.fn_GetUTCDateTime(BPCD.start_time, 100) AS 'Call_Date',
			   CONVERT(VARCHAR(8), CAST(HC_Marketing.dbo.fn_GetUTCDateTime(BPCD.start_time, 100) AS TIME)) AS 'Call_Time',
			   BPCD.[service_name] AS 'Service_Name',
			   BPCD.caller_phone_type AS 'Caller_Phone_Type',
			   BPCD.callee_phone_type AS 'Callee_Phone_Type',
			   CASE
                          WHEN bpcd.caller_phone_type = 'Internal'
                               AND bpcd.callee_phone_type = 'External' THEN
                              'Outbound'
                          WHEN bpcd.caller_phone_type = 'External'
                               AND bpcd.callee_phone_type = 'Internal'
                               AND ISNULL(bpcd.service_name, '') NOT LIKE '%sms%' THEN
                              'Inbound'
                          WHEN bpcd.caller_phone_type = 'External'
                               AND bpcd.callee_phone_type = 'Internal'
                               AND ISNULL(bpcd.service_name, '') LIKE '%sms%' THEN
                              'SMS'
						  WHEN (bpcd.caller_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND (bpcd.callee_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND ISNULL(bpcd.service_name, '') LIKE '%Dial Now' THEN
                              'Outbound'
						  WHEN (bpcd.caller_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND (bpcd.callee_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND ISNULL(bpcd.service_name, '') LIKE '%inbound%' THEN
                              'Inbound'
                          WHEN bpcd.caller_phone_type = 'Internal'
                               AND bpcd.callee_phone_type = 'Internal' THEN
                              'Transfer'
                          ELSE
                              'Unknown'
                END AS 'Call_Type_Group',
			   BPCD.custom2 AS 'InboundSourceSSID',
			   NULL AS 'Inbound_Campaign_ID',
			   ins.CampaignName AS 'Inbound_Campaign_Name',
			   l.Source_Code_Legacy__c AS 'LeadSourceSSID',
			   l.OriginalCampaignID__c AS 'Lead_Campaign_ID',
			   ls.CampaignName AS 'Lead_Campaign_Name',
			   BPCD.agent_disposition_name AS 'Agent_Disposition ',
			   REPLACE(REPLACE(REPLACE(BPCD.agent_disposition_notes,CHAR(10),''), CHAR(13),''), CHAR(9),'')  AS 'Agent_Disposition_Notes',
			   BPCD.disposition AS 'System_Disposition',
			   CASE
				   WHEN BPCD.caller_phone_type = 'External' AND BPCD.service_name NOT LIKE '%SMS%' THEN
					   RIGHT(BPCD.initial_from_phone,10)
				   ELSE
					   NULL
			   END AS 'Lead_Phone',
			   CASE
				   WHEN BPCD.caller_phone_type = 'External' THEN
					   RIGHT(BPCD.initial_original_destination_phone,10)
			   END AS 'InboundPhone',
			   BPCD.custom1 AS 'SFDC_LeadID',
			   l.Status AS 'LeadStatus',
			   BPCD.custom3 AS 'SFDC_TaskID', --One of the custom fields
			   t.SourceCode__c AS 'TaskSourceSSID',
			   NULL AS 'Task_Campaign_ID',				--No taskID on SQL Task tables; it is available on task and when migrated to AZURE, sb resolved.
			   CASE
				   WHEN BPCD.caller_phone_type = 'External' THEN
					   BPCD.callee_login_id
				   WHEN BPCD.caller_phone_type = 'Internal' THEN
					   BPCD.caller_login_id
				   ELSE
					   NULL
			   END AS 'User_Login_ID',
			   agent.first_name + ' ' + agent.last_name AS 'User_Login_Name',
			   CASE
				   WHEN REPLACE(BPCD.agent_disposition_name,' ','') IN (
														 'Appointment-ExistingLead',
														 'Appointment-NewLead',
														 'Brochure-NewLead',
														 'GeneralInquiry-NoleadCreated',
														 'GeneralInquiry-NewLead',
														 'Recovery',
														 'Recycle'
													   ) THEN
					   1
				   ELSE
					   0
			   END AS 'Is_Viable_Call',
			   CASE
				   WHEN REPLACE(BPCD.agent_disposition_name,' ','') IN (
														 'Appointment-ExistingLead',
														 'Appointment-NewLead',
														 'Brochure-NewLead',
														 'GeneralInquiry-NoleadCreated',
														 'GeneralInquiry-NewLead',
														 'Recovery',
														 'Recycle'
													   ) THEN
					   1
				   ELSE
					   0
			   END AS 'Is_Productive_Call',
			   BPCD.duration AS 'CallDuration',
			   BPCD.ivr_time AS 'IVR_Time',
			   BPCD.queue_time AS 'Queue_Time',
			   BPCD.pending_time AS 'Pending_Time',
			   BPCD.talk_time AS 'Talk_Time',
			   BPCD.hold_time AS 'Hold_Time'
		FROM HC_Marketing.dbo.datBPCall_detail BPCD
			--LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			--	ON c.SFDC_LeadID = BPCD.custom1
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ins
				ON ins.SourceSSID = BPCD.custom2
			LEFT OUTER JOIN HC_Marketing.dbo.lkpBPAgents agent
				ON CASE
					   WHEN BPCD.caller_phone_type = 'EXTERNAL' THEN
						   BPCD.callee_login_id
					   ELSE
						   BPCD.caller_login_id
				   END = agent.login_id
			LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
				ON BPCD.custom1 = l.Id
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ls
				ON l.Source_Code_Legacy__c = ls.SourceSSID
			LEFT OUTER JOIN HC_BI_SFDC.dbo.Task t
				ON bpcd.custom3 = t.id
		WHERE BPCD.pkID > (SELECT MAX(ISNULL(BPpk_ID,0)) FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP)

CREATE NONCLUSTERED INDEX IDX_Noble_CenterNumber ON #Noble ( CenterSSID );
CREATE NONCLUSTERED INDEX IDX_Noble_SFDC_LeadID ON #Noble ( SFDC_LeadID );
CREATE NONCLUSTERED INDEX IDX_Noble_PhoneNumber ON #Noble ( Lead_Phone );


UPDATE STATISTICS #Noble;

--SELECT * FROM #noble

/********************************** Update Center Details *************************************/
UPDATE	n
SET		n.CenterSSID = -2
,		n.CenterName = 'Unknown'
FROM	#Noble n
WHERE	ISNULL(n.CenterSSID, 0) IN ( 0, 1 )


UPDATE	n
SET		n.CenterName = ctr.CenterDescription
FROM	#Noble n
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = n.CenterSSID
WHERE	n.CenterSSID IS NOT NULL
		AND n.CenterSSID <> -2


UPDATE	n
SET		n.CenterSSID = ctr.CenterNumber
,		n.CenterName = ctr.CenterDescription
FROM	#Noble n
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = n.SFDC_LeadID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = l.CenterNumber__c
WHERE	n.CenterSSID = -2
		AND ISNULL(n.SFDC_LeadID, '') <> ''


/********************************** Get Lead Phone Data *************************************/
INSERT	INTO #Phone
		SELECT	ctr.CenterNumber
		,		ctr.CenterDescription
		,		pc.Lead__c
		,		l.FirstName
		,		l.LastName
		,		l.Status
		,		l.Source_Code_Legacy__c
		,		pc.PhoneAbr__c
		FROM	HC_BI_SFDC.dbo.Phone__c pc
				INNER JOIN #Noble n
					ON RIGHT(n.Lead_Phone,10) = pc.PhoneAbr__c
				INNER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = pc.Lead__c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					ON ctr.CenterNumber = ISNULL(l.CenterID__c, l.CenterNumber__c)
						AND ctr.Active = 'Y'
		WHERE	ISNULL(pc.IsDeleted, 0) = 0
				AND ISNULL(pc.Primary__c, 0) = 1
		GROUP BY ctr.CenterNumber
		,		ctr.CenterDescription
		,		pc.Lead__c
		,		l.FirstName
		,		l.LastName
		,		l.Status
		,		l.Source_Code_Legacy__c
		,		pc.PhoneAbr__c


UPDATE	n
SET		n.CenterSSID = p.CenterNumber
,		n.CenterName = p.CenterDescription
,		n.SFDC_LeadID = p.Lead__c
,		n.LeadStatus = p.Status
,		n.LeadSourceSSID = ISNULL(p.Source_Code_Legacy__c, '')
FROM	#Noble n
		INNER JOIN #Phone p
			ON p.PhoneAbr__c = n.Lead_Phone
WHERE	n.CenterSSID = -2


UPDATE	n
SET		n.CenterSSID = p.CenterNumber
,		n.CenterName = p.CenterDescription
,		n.SFDC_LeadID = p.Lead__c
,		n.LeadStatus = p.Status
,		n.LeadSourceSSID = ISNULL(p.Source_Code_Legacy__c, '')
FROM	#Noble n
		INNER JOIN #Phone p
			ON p.PhoneAbr__c = n.Lead_Phone
WHERE	ISNULL(n.SFDC_LeadID, '') = ''





/********************************** Get Lead Phone Data *************************************/
TRUNCATE TABLE HC_Marketing.dbo.datSourceCode


INSERT	INTO HC_Marketing.dbo.datSourceCode
		EXEC HC_Marketing.dbo.spSvc_MediaBuyerSourceCodeExport


/********************************** Update Campaign IDs *************************************/
UPDATE	n
SET		n.Inbound_Campaign_ID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.InboundSourceSSID
				AND REPLACE(REPLACE(REPLACE(REPLACE(sc.Number, '(', ''), ')', ''), '-', ''), ' ', '') = RIGHT(n.Inbound_Phone,10)
WHERE	ISNULL(n.InboundSourceSSID, '') <> ''

UPDATE	n
SET		n.Lead_Campaign_ID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.LeadSourceSSID
WHERE	ISNULL(n.LeadSourceSSID, '') <> ''


UPDATE	n
SET		n.Task_Campaign_ID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.TaskSourceSSID
WHERE	ISNULL(n.TaskSourceSSID, '') <> ''




--/********************************** Insert Data into DimCallData *************************************/
INSERT INTO HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP (
	BPpk_ID
,	Media_Type
,	CenterSSID
,	Call_Date
,	Call_Time
,	Service_Name
,	Caller_Phone_Type
,	Callee_Phone_Type
,	Call_Type_Group
,	InboundSourceSSID
,	Inbound_Campaign_ID
,	Inbound_Campaign_Name
,	LeadSourceSSID
,	Lead_Campaign_ID
,	Lead_Campaign_Name
,	Agent_Disposition
,	Agent_Disposition_Notes
,	System_Disposition
,	Lead_Phone
,	Inbound_Phone
,	SFDC_LeadID
,	SFDC_TaskID
,	TaskSourceSSID
,	Task_Campaign_ID
,	Task_Campaign_Name
,	User_Login_ID
,	User_Login_Name
,	Is_Viable_Call
,   Is_Productive_Call
,	Call_Length
,	IVR_Time
,	Queue_Time
,	Pending_Time
,	Talk_Time
,	Hold_Time
)
SELECT	n.BPpk_ID
,		n.Media_Type
,		n.CenterSSID
,		n.Call_Date
,		CONVERT(VARCHAR(8), CAST(n.Call_Time AS TIME))
,		n.Service_Name
,		n.Caller_Phone_Type
,		n.Callee_Phone_Type
,		n.Call_Type_Group
,		n.InboundSourceSSID
,		n.Inbound_Campaign_ID
,		n.Inbound_Campaign_Name
,		n.LeadSourceSSID
,		n.Lead_Campaign_ID
,		n.Lead_Campaign_Name
,		n.Agent_Disposition
,		n.Agent_Disposition_Notes
,		n.System_Disposition
,		RIGHT(n.Lead_Phone,10)
,		RIGHT(n.Inbound_Phone,10)
,		n.SFDC_LeadID
,		n.SFDC_TaskID
,		n.TaskSourceSSID
,		n.Task_Campaign_ID
,		ts.CampaignName
,		n.User_Login_ID
,		n.User_Login_Name
,		n.Is_Viable_Call
,		n.Is_Productive_Call
,		n.Call_Length
,		n.IVR_Time
,		n.Queue_Time
,		n.Pending_Time
,		n.Talk_Time
,		n.Hold_Time
--,		c.ContactKey
--,		ins.SourceSSID
--,		ls.SourceSSID
--,		ts.SourceSSID
FROM	#Noble n
		--LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
		--	ON c.SFDC_LeadID = n.SFDC_LeadID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ins
			ON ins.SourceSSID = N.InboundSourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ls
			ON ls.SourceSSID = N.LeadSourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ts
			ON ts.SourceSSID = N.TaskSourceSSID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP dcd
			ON dcd.BPpk_ID = n.BPpk_ID
WHERE	n.BPpk_ID > (SELECT MAX(ISNULL(BPpk_ID,0)) FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP)

END
GO
