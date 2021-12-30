/* CreateDate: 09/08/2020 12:06:14.267 , ModifyDate: 09/23/2020 15:14:28.070 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimCallDataBP]
AS
-------------------------------------------------------------------------
-- [vwDimCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimCallDataBP]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/08/2020  KMurdoch       Initial Creation
--
-------------------------------------------------------------------------

SELECT [Call_RecordKey]
      ,[BPpk_ID]
      ,ISNULL([Media_Type], 'VOICE') AS 'Media_Type'
      ,ISNULL([CenterSSID],-2) AS 'CenterSSID'
      ,[Call_Date]
      ,[Call_Time]
      ,[Service_Name]
      ,[Caller_Phone_Type]
      ,[Callee_Phone_Type]
      ,[Call_Type_Group]
      ,[InboundSourceSSID]
      ,[Inbound_Campaign_ID]
      ,[Inbound_Campaign_Name]
      ,[LeadSourceSSID]
      ,[Lead_Campaign_ID]
      ,[Lead_Campaign_Name]
      ,[Agent_Disposition]
      ,[Agent_Disposition_Notes]
      ,[System_Disposition]
      ,[Lead_Phone]
      ,[Inbound_Phone]
      ,[SFDC_LeadID]
      ,[SFDC_TaskID]
      ,[TaskSourceSSID]
      ,[Task_Campaign_ID]
      ,[Task_Campaign_Name]
      ,[User_Login_ID]
      ,[User_Login_Name]
      ,[Is_Viable_Call]
      ,[Is_Productive_Call]
      ,[Call_Length]
      ,[IVR_Time]
      ,[Queue_Time]
      ,[Pending_Time]
      ,[Talk_Time]
      ,[Hold_Time]
      ,[RowTimeStamp]
  FROM [bi_mktg_dds].[DimCallDataBP]
GO
