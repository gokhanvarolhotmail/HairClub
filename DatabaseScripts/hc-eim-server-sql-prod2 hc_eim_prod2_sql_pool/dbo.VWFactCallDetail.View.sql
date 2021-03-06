/****** Object:  View [dbo].[VWFactCallDetail]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactCallDetail] AS SELECT cd.[FactDateKey]
      ,cd.[FactTimeKey]
      ,cd.[FactDate]
	  ,dateadd(mi,datepart(tz,CONVERT(datetime,cd.FactDate)    AT TIME ZONE 'Eastern Standard Time'),cd.FactDate) CallDateEST
      ,cd.[CallId]
      ,cd.[CallMediaType]
      ,cd.[MediaKey]
      ,cd.[CallPkId]
      ,cd.[CallDate]
      ,cd.[CallIvrTime]
      ,cd.[CallQueueTime]
      ,cd.[CallPendingTime]
      ,cd.[CallTalkTime]
      ,cd.[CallHoldTime]
      ,cd.[CallHeld]
      ,cd.[CallMaxHold]
      ,cd.[CallAcwTime]
      ,cd.[CallDuration]
      ,cd.[ServiceName]
      ,cd.[ServiceKey]
      ,cd.[ScenarioName]
      ,cd.[ScenarioKey]
      ,cd.[LeadKey]
      ,cd.[LeadId]
      ,cd.[TaskId] as IncommingSourceCode
      ,cd.[IncommingSourceCode] as TaskId
      ,cd.[SourceKey]
      ,cd.[CallType]
      ,cd.[CallTypeKey]
      ,cd.[AgentDisposition]
      ,cd.[AgentDispositionKey]
      ,cd.[AgentLogin]
      ,cd.[AgentKey]
      ,cd.[IsViableCall]
      ,cd.[IsProductiveCall]
      ,bcd.from_phone
      ,right(bcd.initial_original_destination_phone,10) initial_original_destination_phone
      ,vl.CenterNumber
      ,vl.CenterID
      ,vl.OriginalCampaignId
      ,vl.AgencyName
      ,vl.Agencykey
      ,c.CenterOwnershipDescription
  FROM [dbo].[FactCallDetail] cd
  left join VWLead vl on vl.LeadId = cd.LeadId
  left join DimCenter c on c.CenterNumber = vl.CenterNumber
  left join ods.BP_CallDetail bcd on bcd.pkid = cd.CallPkId;
GO
