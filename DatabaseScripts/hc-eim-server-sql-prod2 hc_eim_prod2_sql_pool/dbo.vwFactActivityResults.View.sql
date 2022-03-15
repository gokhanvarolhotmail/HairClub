/****** Object:  View [dbo].[vwFactActivityResults]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFactActivityResults]
AS SELECT
		CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS DATE) as PartitionDate
		,d2.[DateKey] AS ActivityResultDateKey
		,'-1' AS ActivityResultKey
		,dt2.[TimeOfDayKey] AS ActivityResultTimeKey
		,'-1' AS ActivityKey
		,NULL AS ActivityDateKey
		,NULL AS ActivityTimeKey
		,d2.[DateKey] AS ActivityCompletedDateKey
		,dt2.[TimeOfDayKey] AS ActivityCompletedTimeKey
		,d.[DateKey] AS ActivityDueDateKey
		,dt.[TimeOfDayKey] AS ActivityStartTimeKey
		,CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS DATE) AS OriginalAppointmentDateKey
		,d3.[DateKey] AS ActivitySavedDateKey
		,dt3.[TimeOfDayKey] AS ActivitySavedTimeKey
		,dl.leadkey AS ContactKey
		,dl.centerkey AS CenterKey
		,'-1' AS SalesTypeKey
		,dl.sourceKey AS SourceKey
		,'-1' AS ActionCodeKey
		,t.[Result__c] AS ResultCodeKey
		,dg.[GenderKey] AS GenderKey
		,do.[OccupationKey] AS OccupationKey
		,et.[EthnicityKey] AS EthnicityKey
		,m.[MaritalStatusKey] AS MaritalStatusKey
		,'-1' AS HairLossTypeKey
		,'-1' AS AgeRangeKey
		,'-1' AS CompletedByEmployeeKey
		,NULL AS ClientNumber
		,CASE WHEN fl.Appointments > '0' THEN '1'
			ELSE '0'
			END AS Appointments
		,CASE WHEN fl.shows > '0' THEN '1'
			ELSE '0'
			END AS Shows
		,CASE WHEN fl.sales > '0' THEN '1'
			ELSE '0'
			END AS Sales
		,CASE WHEN fl.noshows > '0' THEN '1'
			ELSE '0'
			END AS NoShows
		,CASE WHEN fl.nosales > '0' THEN '1'
			ELSE '0'
			END AS NoSales
		,NULL AS Consultation
		,NULL AS BeBack
		,NULL AS BebackAlt
		,NULL AS BeBackNoShow
		,'0' AS SurgeryOffered
		,'0' AS ReferredToDoctor
		,'0' AS InitialPayment
		,'-1' AS ActivityEmployeeKey
		,NULL AS LeadSourceKey
		,NULL AS PromoCodeKey
		,NULL AS LTValue
		,NULL AS LTValueYr
		,NULL AS Inhouse
		,NULL AS BOSAppt
		,CASE WHEN c.sourcecode = 'BOSREF' THEN c.sourcecode
			ELSE NULL
			END AS BOSRef
		,CASE WHEN c.sourcecode in ('BOSDMREF','BOSBIOEMREF','BOSBIODMREF') THEN c.sourcecode
			ELSE NULL
			END AS BOSOthRef
		,CASE WHEN c.sourcecode in ('CORP REFER','REFERAFRND','STYLEREFER','REGISSTYRFR','NBREFCARD','IPREFCLRERECA12476','IPREFCLRERECA12476DC','IPREFCLRERECA12476DF','IPREFCLRERECA12476DP','IPREFCLRERECA12476MC','IPREFCLRERECA12476MF','IPREFCLRERECA12476MP') THEN c.sourcecode
			ELSE NULL
			END AS HCRef
		,fl.[LeadCreationDateKey] AS LeadCreationDateKey
		,fl.[LeadCreationTimeKey] AS LeadCreationTimeKey
		,NULL AS Accomodation
		,c.SourceCode AS RecentLeadSourceKey
    from [ODS].[SF_Task] t
  left join dbo.dimLead dl on isnull(dl.LeadId,dl.convertedcontactid) = t.[WhoId]
  left join dbo.dimDate d on d.fullDate = CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS DATE)
  left join dbo.DimTimeOfDay dt on dt.[Time24] = CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS TIME)
  left join dbo.dimGender dg on dg.[GenderKey] = dl.[GenderKey]
  left join dbo.dimEthnicity et on et.[EthnicityKey] = dl.[EthnicityKey]
  left join dbo.dimMaritalStatus m on m.[MaritalStatusKey] = dl.[MaritalStatusKey]
  left join dbo.dimCampaign c on dl.originalcampaignId = c.campaignid
  left join dbo.dimPromotion dp on dp.[PromotionId] = c.[PromoCode]
  left join dbo.dimSystemUser su on su.[UserId] = dl.[CreateUser]
  left join dbo.dimSource  sc on dl.sourceKey=sc.sourcekey
  left join dbo.dimOccupation do on dl.LeadOccupation = do.[OccupationName]
  left join dbo.dimDate d2 on d2.fullDate = cast(t.CompletedDateTime as date)
  left join dbo.DimTimeOfDay dt2 on dt2.[Time24] = cast(t.CompletedDateTime as time)
  left join dbo.dimDate d3 on d3.fullDate = CAST(t.[LastModifiedDate] AS DATE)
  left join dbo.DimTimeOfDay dt3 on dt3.[Time24] = CAST(t.[LastModifiedDate] AS time)
  left join [dbo].[VWFactLead] fl on fl.leadid = t.whoid;
GO
