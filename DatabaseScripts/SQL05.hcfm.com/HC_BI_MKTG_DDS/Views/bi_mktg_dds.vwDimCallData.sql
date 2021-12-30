/* CreateDate: 04/14/2020 13:48:26.047 , ModifyDate: 12/09/2020 14:54:31.200 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimCallData]
AS
-------------------------------------------------------------------------
-- [vwDimCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/14/2020  KMurdoch       Initial Creation
--			09/14/2020  KMurdoch       Modified to use BP
--
-------------------------------------------------------------------------

SELECT [Call_RecordKey]
      ,ISNULL([BPpk_ID],'') AS 'BPpk_ID'
      ,ISNULL([Media_Type],'') AS 'Media_Type'
      ,ISNULL([CenterSSID],'') AS 'CenterSSID'
      ,[Call_Date]
      ,[Call_Time]
      ,ISNULL([Service_Name],'') AS 'Service_Name'
      ,[Call_Type_Group]
      ,ISNULL([InboundSourceSSID],'') AS 'InboundSourceSSID'
      ,ISNULL([Inbound_Campaign_Name],'') AS 'Inbound_Campaign_Name'
      ,ISNULL([LeadSourceSSID], '') AS 'LeadSourceSSID'
      ,ISNULL([Lead_Campaign_Name], '') AS 'Lead_Campaign_Name'
      ,ISNULL([Agent_Disposition], '') AS 'Agent_Disposition'
      ,ISNULL([System_Disposition],'') AS 'System_Disposition'
      ,ISNULL([Lead_Phone],'') AS 'LeadPhone'
      ,ISNULL([Inbound_Phone],'') AS 'Inbound_Phone'
      ,[SFDC_LeadID]
      ,[SFDC_TaskID]
      ,ISNULL([TaskSourceSSID],'') AS 'TaskSourceSSID'
      ,ISNULL([Task_Campaign_Name],'') AS 'Task_Campaign_Name'
      ,ISNULL([User_Login_Name],'') AS 'AgentName'
      ,[Is_Viable_Call]
      ,[Is_Productive_Call]
      ,[Call_Length]
      ,[IVR_Time]
      ,[Queue_Time]
      ,[Pending_Time]
      ,[Talk_Time]
	  ,CASE WHEN Talk_Time = 0 THEN '0s'
			WHEN Talk_Time BETWEEN 1 AND 60 THEN '1s to 60s'
			WHEN Talk_Time BETWEEN 61 AND 120 THEN '1 Min'
			WHEN Talk_Time BETWEEN 121 AND 180 THEN '2 Min'
			WHEN Talk_Time BETWEEN 181 AND 240 THEN '3 Min'
			WHEN Talk_Time BETWEEN 241 AND 300 THEN '4 Min'
			WHEN Talk_Time BETWEEN 301 AND 360 THEN '5 Min'
			WHEN Talk_Time > '360' THEN '6+ Min'
			ELSE 'Unk' END AS 'TalkTimeSegment'
      ,[Hold_Time]
	  , ISNULL(a.team_name,'Unknown') AS 'Team_Name'
	  , dcdbp.User_Login_ID
  FROM [bi_mktg_dds].[DimCallDataBP] dcdbp
  LEFT OUTER JOIN HC_Marketing.dbo.lkpBPAgents a
  ON dcdbp.User_Login_ID = a.login_id
GO
