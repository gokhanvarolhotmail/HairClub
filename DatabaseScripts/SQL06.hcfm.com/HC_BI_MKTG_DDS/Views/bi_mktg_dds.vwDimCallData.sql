/* CreateDate: 08/19/2020 09:17:03.827 , ModifyDate: 09/17/2020 16:20:00.740 */
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
      ,[Hold_Time]
  FROM [bi_mktg_dds].[DimCallDataBP]
GO
