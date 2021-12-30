/* CreateDate: 07/01/2020 10:45:22.923 , ModifyDate: 09/09/2020 14:39:16.007 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ProcessNobleDimCallData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/8/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ProcessNobleDimCallData
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspSvc_ProcessNobleDimCallData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #DistinctID (
	d_record_id FLOAT
)

CREATE TABLE #DedupedNobleData (
	UniqueID NVARCHAR(255)
,	appl NVARCHAR(255)
,	SourceTask NVARCHAR(255)
,	DNISLead NVARCHAR(255)
,	InbCtr NVARCHAR(255)
,	call_date DATETIME
,	call_time NVARCHAR(255)
,	ani_acode NVARCHAR(255)
,	ani_phone NVARCHAR(255)
,	tsr NVARCHAR(255)
,	ani_country_id FLOAT
,	time_connect FLOAT
,	time_acwork FLOAT
,	status NVARCHAR(255)
,	addi_status NVARCHAR(255)
,	time_holding FLOAT
,	d_record_id NVARCHAR(255)
)

CREATE TABLE #NobleCallStatus (
	CallStatusCode NVARCHAR(15)
,	CallStatus NVARCHAR(50)
,	UsedBy NVARCHAR(50)
)

CREATE TABLE #Noble (
	CallRecordID NVARCHAR(255)
,	OriginalCallRecordID NVARCHAR(255)
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CallDate DATETIME
,	CallTime TIME
,	CallTypeCode NVARCHAR(15)
,	CallType NVARCHAR(50)
,	CallTypeGroup NVARCHAR(15)
,	TollfreeNumberCampaignID NVARCHAR(18)
,	TollFreeNumber NVARCHAR(20)
,	InboundSourceCode NVARCHAR(50)
,	SFDC_LeadID NVARCHAR(18)
,	LeadFirstName NVARCHAR(50)
,	LeadLastName NVARCHAR(80)
,	LeadStatus NVARCHAR(50)
,	LeadCampaignID NVARCHAR(18)
,	LeadSourceCode NVARCHAR(50)
,	SFDC_TaskID NVARCHAR(18)
,	TaskActionCode NVARCHAR(50)
,	TaskResultCode NVARCHAR(50)
,	TaskCampaignID NVARCHAR(18)
,	TaskSourceCode NVARCHAR(50)
,	PhoneNumber NVARCHAR(50)
,	CallLength INT
,	AfterWorkCallLength INT
,	HoldCallLength INT
,	CallStatusCode NVARCHAR(15)
,	CallStatus NVARCHAR(50)
,	UsedBy NVARCHAR(50)
,	AdditionalStatusCode NVARCHAR(15)
,	AdditionalStatus NVARCHAR(50)
,	UserID NVARCHAR(50)
,	UserName NVARCHAR(105)
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


/********************************** Get DISTINCT Ids *************************************/
INSERT	INTO #DistinctID
		SELECT	DISTINCT
				tncd.d_record_id
		FROM	tmpNobleCallData tncd


CREATE NONCLUSTERED INDEX IDX_DistinctID_d_record_id ON #DistinctID ( d_record_id );


UPDATE STATISTICS #DistinctID;


/********************************** Get DeDuped Data *************************************/
INSERT	INTO #DedupedNobleData
		SELECT	CONVERT(VARCHAR, ISNULL(tncd.appl, '')) + CONVERT(VARCHAR, ISNULL(CAST(tncd.InbCtr AS INT), '')) + CONVERT(VARCHAR, ISNULL(tncd.tsr, '')) + CONVERT(VARCHAR, ISNULL(tncd.status, '')) + CONVERT(VARCHAR, ISNULL(tncd.addi_status, '')) + CONVERT(VARCHAR, CAST(tncd.d_record_id AS INT)) AS 'UniqueID'
		,		tncd.appl
		,		tncd.SourceTask
		,		tncd.DNISLead
		,		tncd.InbCtr
		,		tncd.call_date
		,		tncd.call_time
		,		tncd.ani_acode
		,		tncd.ani_phone
		,		tncd.tsr
		,		tncd.ani_country_id
		,		tncd.time_connect
		,		tncd.time_acwork
		,		tncd.status
		,		tncd.addi_status
		,		tncd.time_holding
		,		tncd.d_record_id
		FROM	tmpNobleCallData tncd
				INNER JOIN #DistinctID di
					ON di.d_record_id = tncd.d_record_id
		GROUP BY CONVERT(VARCHAR, ISNULL(tncd.appl, '')) + CONVERT(VARCHAR, ISNULL(CAST(tncd.InbCtr AS INT), '')) + CONVERT(VARCHAR, ISNULL(tncd.tsr, '')) + CONVERT(VARCHAR, ISNULL(tncd.status, '')) + CONVERT(VARCHAR, ISNULL(tncd.addi_status, '')) + CONVERT(VARCHAR, CAST(tncd.d_record_id AS INT))
		,		tncd.appl
		,		tncd.SourceTask
		,		tncd.DNISLead
		,		tncd.InbCtr
		,		tncd.call_date
		,		tncd.call_time
		,		tncd.ani_acode
		,		tncd.ani_phone
		,		tncd.tsr
		,		tncd.ani_country_id
		,		tncd.time_connect
		,		tncd.time_acwork
		,		tncd.status
		,		tncd.addi_status
		,		tncd.time_holding
		,		tncd.d_record_id


CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_DNISLead ON #DedupedNobleData ( DNISLead );
CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_SourceTask ON #DedupedNobleData ( SourceTask );
CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_addi_status ON #DedupedNobleData ( addi_status );
CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_status ON #DedupedNobleData ( status );
CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_tsr ON #DedupedNobleData ( tsr );
CREATE NONCLUSTERED INDEX IDX_DedupedNobleData_appl ON #DedupedNobleData ( appl );


UPDATE STATISTICS #DedupedNobleData;


/********************************** Get Call Status Data *************************************/
INSERT	INTO #NobleCallStatus
		SELECT	ncs.CallStatus AS 'CallStatusCode'
		,		CASE ncs.CallStatus WHEN 'LD' THEN 'Later Date' WHEN 'SP' THEN 'Skip Preview' ELSE ncs.Description END AS 'CallStatus'
		,		CASE WHEN ncs.CallStatus IN ( 'LD', 'SP' ) THEN 'HC' ELSE ncs.UsedBy END AS 'UsedBy'
		FROM	HC_Marketing.dbo.lkpNobleCallStatus ncs
		WHERE	ncs.UsedBy IN ( 'HC', 'System' )
		GROUP BY ncs.CallStatus
		,		CASE ncs.CallStatus WHEN 'LD' THEN 'Later Date' WHEN 'SP' THEN 'Skip Preview' ELSE ncs.Description END
		,		CASE WHEN ncs.CallStatus IN ( 'LD', 'SP' ) THEN 'HC' ELSE ncs.UsedBy END


CREATE NONCLUSTERED INDEX IDX_NobleCallStatus_CallStatusCode ON #NobleCallStatus ( CallStatusCode );


UPDATE STATISTICS #NobleCallStatus;


/********************************** Get Noble Call Data using DeDuped Data *************************************/
INSERT	INTO #Noble
		SELECT	dnd.UniqueID AS 'CallRecordID'
		,		dnd.d_record_id AS 'OriginalCallRecordID'
		,		CAST(dnd.InbCtr AS INT) AS 'CenterNumber'
		,		NULL AS 'CenterName'
		,		dnd.call_date AS 'CallDate'
		,		dnd.call_time AS 'CallTime'
		,		ct.NobleCallTypeDescriptionShort AS 'CallTypeCode'
		,		ct.NobleCallTypeDescription AS 'CallType'
		,		ct.NobleCallTypeGroup AS 'CallTypeGroup'
		,		NULL AS 'TollfreeNumberCampaignID'
		,		CASE WHEN dnd.DNISLead LIKE '%,%' THEN (SELECT fs.SplitValue FROM HC_Marketing.dbo.fnSplitWithId(dnd.DNISLead, ',') fs WHERE fs.Id = 2) ELSE NULL END AS 'TollFreeNumber'
		,		CASE WHEN ct.NobleCallTypeGroup = 'Inbound' THEN ISNULL(dnd.SourceTask, '') ELSE '' END AS 'InboundSourceCode'
		,		ISNULL(l.Id, '') AS 'SFDC_LeadID'
		,		ISNULL(l.FirstName, '') AS 'LeadFirstName'
		,		ISNULL(l.LastName, '') AS 'LeadLastName'
		,		ISNULL(l.Status, '') AS 'LeadStatus'
		,		NULL AS 'LeadCampaignID'
		,		CASE WHEN ct.NobleCallTypeGroup = 'Outbound' THEN ISNULL(l.Source_Code_Legacy__c, '') ELSE '' END AS 'LeadSourceCode'
		,		ISNULL(t.Id, '') AS 'SFDC_TaskID'
		,		ISNULL(t.Action__c, '') AS 'TaskAction'
		,		ISNULL(t.Result__c, '') AS 'TaskResult'
		,		NULL AS 'TaskCampaignID'
		,		CASE WHEN ct.NobleCallTypeGroup = 'Outbound' THEN ISNULL(t.SourceCode__c, '') ELSE '' END AS 'TaskSourceCode'
		,		CAST(dnd.ani_acode AS NVARCHAR(10)) + '' + CAST(dnd.ani_phone AS NVARCHAR(40)) AS 'PhoneNumber'
		,		dnd.time_connect AS 'CallLength'
		,		dnd.time_acwork AS 'AfterWorkCallLength'
		,		dnd.time_holding AS 'HoldCallLength'
		,		ncs.CallStatusCode
		,		ncs.CallStatus
		,		ncs.UsedBy
		,		ISNULL(nas.AddtlStatus, '') AS 'AdditionalStatusCode'
		,		ISNULL(nas.AddtlStatusDescription, '') AS 'AdditionalStatus'
		,		ISNULL(nt.tsrID, '') AS 'UserID'
		,		ISNULL(nt.FullName, '') AS 'UserName'
		FROM	#DedupedNobleData dnd
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = dnd.DNISLead
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Task t
					ON t.Id = dnd.SourceTask
				LEFT OUTER JOIN HC_Marketing.dbo.lkpNobleAddtlStatus nas
					ON nas.AddtlStatus = dnd.addi_status
						AND nas.status = dnd.status
				LEFT OUTER JOIN HC_Marketing.dbo.lkpNobleTSR nt
					ON nt.tsrID = dnd.tsr
				LEFT OUTER JOIN HC_Marketing.dbo.lkpNobleCallType ct
					ON ct.NobleCallTypeDescriptionShort = dnd.appl
				LEFT OUTER JOIN #NobleCallStatus ncs
					ON ncs.CallStatusCode = dnd.status


CREATE NONCLUSTERED INDEX IDX_Noble_CenterNumber ON #Noble ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Noble_SFDC_LeadID ON #Noble ( SFDC_LeadID );
CREATE NONCLUSTERED INDEX IDX_Noble_PhoneNumber ON #Noble ( PhoneNumber );


UPDATE STATISTICS #Noble;


/********************************** Update Center Details *************************************/
UPDATE	n
SET		n.CenterNumber = -2
,		n.CenterName = 'Unknown'
FROM	#Noble n
WHERE	ISNULL(n.CenterNumber, 0) IN ( 0, 1 )


UPDATE	n
SET		n.CenterName = ctr.CenterDescription
FROM	#Noble n
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = n.CenterNumber
WHERE	n.CenterNumber IS NOT NULL
		AND n.CenterNumber <> -2


UPDATE	n
SET		n.CenterNumber = ctr.CenterNumber
,		n.CenterName = ctr.CenterDescription
FROM	#Noble n
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = n.SFDC_LeadID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = l.CenterNumber__c
WHERE	n.CenterNumber = -2
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
					ON n.PhoneNumber = pc.PhoneAbr__c
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
SET		n.CenterNumber = p.CenterNumber
,		n.CenterName = p.CenterDescription
,		n.SFDC_LeadID = p.Lead__c
,		n.LeadFirstName = p.FirstName
,		n.LeadLastName = p.LastName
,		n.LeadStatus = p.Status
,		n.LeadSourceCode = ISNULL(p.Source_Code_Legacy__c, '')
FROM	#Noble n
		INNER JOIN #Phone p
			ON p.PhoneAbr__c = n.PhoneNumber
WHERE	n.CenterNumber = -2


UPDATE	n
SET		n.CenterNumber = p.CenterNumber
,		n.CenterName = p.CenterDescription
,		n.SFDC_LeadID = p.Lead__c
,		n.LeadFirstName = p.FirstName
,		n.LeadLastName = p.LastName
,		n.LeadStatus = p.Status
,		n.LeadSourceCode = ISNULL(p.Source_Code_Legacy__c, '')
FROM	#Noble n
		INNER JOIN #Phone p
			ON p.PhoneAbr__c = n.PhoneNumber
WHERE	ISNULL(n.SFDC_LeadID, '') = ''


/********************************** Get Lead Phone Data *************************************/
TRUNCATE TABLE HC_Marketing.dbo.datSourceCode


INSERT	INTO HC_Marketing.dbo.datSourceCode
		EXEC HC_Marketing.dbo.spSvc_MediaBuyerSourceCodeExport


/********************************** Update Campaign IDs *************************************/
UPDATE	n
SET		n.TollfreeNumberCampaignID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.InboundSourceCode
				AND REPLACE(REPLACE(REPLACE(REPLACE(sc.Number, '(', ''), ')', ''), '-', ''), ' ', '') = n.TollFreeNumber
WHERE	ISNULL(n.InboundSourceCode, '') <> ''


UPDATE	n
SET		n.LeadCampaignID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.LeadSourceCode
WHERE	ISNULL(n.LeadSourceCode, '') <> ''


UPDATE	n
SET		n.TaskCampaignID = sc.SourceCodeID
FROM	#Noble n
		INNER JOIN HC_Marketing.dbo.datSourceCode sc
			ON sc.SourceCode = n.TaskSourceCode
WHERE	ISNULL(n.TaskSourceCode, '') <> ''


/********************************** Insert Data into DimCallData *************************************/
INSERT INTO HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData (
	CallRecordSSID
,	OriginalCallRecordSSID
,	CenterSSID
,	CallDate
,	CallTime
,	CallTypeSSID
,	CallTypeDescription
,	CallTypeGroup
,	InboundCampaignID
,	InboundSourceSSID
,	InboundSourceDescription
,	LeadCampaignID
,	LeadSourceSSID
,	LeadSourceDescription
,	CallStatusSSID
,	CallStatusDescription
,	CallPhoneNo
,	SFDC_LeadID
,	SFDC_TaskID
,	TaskCampaignID
,	TaskSourceSSID
,	TaskSourceDescription
,	UsedBy
,	AdditionalCallStatusSSID
,	AdditionalCallStatusDescription
,	UserSSID
,	UserFullName
,	NobleUserSSID
,	IsViableCall
,	CallLength
,	TollFreeNumber
)
SELECT	n.CallRecordID
,		n.OriginalCallRecordID
,		n.CenterNumber
,		n.CallDate
,		CONVERT(VARCHAR(8), CAST(n.CallTime AS TIME))
,		n.CallTypeCode
,		n.CallType
,		n.CallTypeGroup
,		n.TollfreeNumberCampaignID
,		n.InboundSourceCode
,		ins.SourceName
,		n.LeadCampaignID
,		n.LeadSourceCode
,		ls.SourceName
,		n.CallStatusCode
,		n.CallStatus
,		n.PhoneNumber
,		n.SFDC_LeadID
,		n.SFDC_TaskID
,		n.TaskCampaignID
,		n.TaskSourceCode
,		ts.SourceName
,		n.UsedBy
,		n.AdditionalStatusCode
,		n.AdditionalStatus
,		n.UsedBy
,		n.UserName
,		n.UserID
,		CASE WHEN n.CallTypeGroup = 'Inbound'
				AND n.UserID <> ''
				AND n.CallStatusCode NOT IN ( 'TN', 'WN', 'PR' ) THEN 1
			WHEN n.CallTypeGroup = 'Outbound'
				AND n.UserID <> ''
				AND n.CallStatusCode NOT IN ( 'TN', 'WN', 'PR', 'SP' ) THEN 1
			ELSE 0
		END AS 'IsViableCall'
,		n.CallLength AS 'CallLength'
,		n.TollFreeNumber AS 'TollFreeNumber'
FROM	#Noble n
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			ON c.SFDC_LeadID = n.SFDC_LeadID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ins
			ON ins.SourceSSID = N.InboundSourceCode
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ls
			ON ls.SourceSSID = N.LeadSourceCode
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ts
			ON ts.SourceSSID = N.TaskSourceCode
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimCallData dcd
			ON dcd.CallRecordSSID = n.CallRecordID
WHERE	dcd.CallRecordKey IS NULL

END
GO
