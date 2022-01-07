/****** Object:  View [dbo].[VWFactCallDetail]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactCallDetail]
AS SELECT [FactDateKey]
      ,[FactTimeKey]
      ,[FactDate]
	  ,dateadd(mi,datepart(tz,CONVERT(datetime,FactDate)    AT TIME ZONE 'Eastern Standard Time'),FactDate) CallDateEST
      ,[CallId]
      ,[CallMediaType]
      ,[MediaKey]
      ,[CallPkId]
      ,[CallDate]
      ,[CallIvrTime]
      ,[CallQueueTime]
      ,[CallPendingTime]
      ,[CallTalkTime]
      ,[CallHoldTime]
      ,[CallHeld]
      ,[CallMaxHold]
      ,[CallAcwTime]
      ,[CallDuration]
      ,[ServiceName]
      ,[ServiceKey]
      ,[ScenarioName]
      ,[ScenarioKey]
      ,[LeadKey]
      ,[LeadId]
      ,[TaskId]
      ,[IncommingSourceCode]
      ,[SourceKey]
      ,[CallType]
      ,[CallTypeKey]
      ,[AgentDisposition]
      ,[AgentDispositionKey]
      ,[AgentLogin]
      ,[AgentKey]
      ,[IsViableCall]
      ,[IsProductiveCall]
  FROM [dbo].[FactCallDetail];
GO
