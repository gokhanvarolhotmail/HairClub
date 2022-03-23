/* CreateDate: 03/21/2022 07:50:22.057 , ModifyDate: 03/21/2022 07:50:22.057 */
GO
CREATE VIEW [dbo].[vwDimInboundCallData]
AS
-------------------------------------------------------------------------
-- [vwDimInboundCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimInboundCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/14/2020  KMurdoch       Initial Creation
--          09/18/2020	KMurdoch	   Modified to handle new Bright Pattern Data set
-------------------------------------------------------------------------

SELECT	DCD.Call_RecordKey AS 'CallRecordKey'
,		DCD.BPpk_ID AS 'CallRecordSSID'
,		DCD.CenterSSID
,		DCD.Call_Date AS 'CallDate'
,		ISNULL(DCD.Call_Time, '00:00:00') AS 'CallTime'
,		Call_Type_Group AS 'CallTypeGroup'
,		ISNULL(DCD.InboundSourceSSID, 'Unknown') AS 'InboundSourceSSID'
,		ISNULL(DCD.Inbound_Campaign_Name, 'Unknown') AS 'InboundSourceDescription'
,		ISNULL(DS.Media, 'Unknown') AS 'InbCallSource_Media'
,		ISNULL(DS.Level02Location, 'Unknown') AS 'IBSource_Location'
,		ISNULL(DS.Level03Language, 'Unknown') AS 'IBSource_Language'
,		ISNULL(DS.Level04Format, 'Unknown') AS 'IBSource_Format'
,		ISNULL(DS.Level05Creative, 'Unknown') AS 'IBSource_Creative'
,		ISNULL(DS.OwnerType, 'Unknown') AS 'IBSource_OwnerType'
,		LeadSourceSSID
,		DCD.Lead_Campaign_Name AS 'LeadCampaignName'
,		DCD.Agent_Disposition AS 'AgentDisposition'
,		dcd.Lead_Phone AS 'LeadPhone'
,		DCD.SFDC_LeadID AS 'SFDC_LeadID'
,		DCD.SFDC_TaskID AS 'SFDC_TaskID'
,		dcd.Inbound_Phone AS 'InboundPhone'
,		DCD.Is_Viable_Call AS 'IsViableCall'
,		Call_Length AS 'CallLength'
,		DCD.IVR_Time AS 'IVRTime'
,		dcd.Hold_Time AS 'HoldTime'
,		DCD.User_Login_Name AS 'AgentName'
,		dcd.System_Disposition AS 'SystemDisposition'
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimCallDataBP DCD
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
			ON DCD.InboundSourceSSID = DS.SourceSSID
WHERE	Call_Type_Group = 'Inbound' AND dcd.Call_Date >= '09/07/2020'
GO
