/****** Object:  View [dbo].[VWFactAppointment_Live]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactAppointment_Live] AS with Factapptcte as 
(
select a.AppointmentDate                as         AppointmentDateUTC,
       a.AppointmentDateKey             as         AppointmentDateKeyUTC,       a.AppointmentTimeKey,
       a.LeadKey,       a.LeadId,       a.AccountKey,       a.AppointmentStatus,
       a.AppoinmentStatusCategory,       a.AccountId,
       a.Centerkey,
       a.Centernumber,
       a.AppointmentTypeKey,
       a.bebackflag,
       a.appointmentid,
	   a.externaltaskid,
       isnull(a.isdeleted, 0)         AS         isdeleted,
       case
           when IsOld = 0 then dateadd(mi, datepart(tz,
                                                    CONVERT(datetime, a.AppointmentDate) AT TIME ZONE
                                                    'Eastern Standard Time'), a.AppointmentDate)
           else a.AppointmentDate end AS         AppointmentDate,
            a.IsOld,
	   	  a.AppointmentType,
		  a.OpportunityId,
		  a.OpportunityStatus,
		  a.OpportunityDate	,
		  a.OpportunityAmmount,
          a.ParentRecordType
from factappointment a
where isold=0
),
 assignedcte as
( select  cc.Name ,bb.ServiceAppointmentId,row_number() over(partition by  bb.serviceappointmentid order by serviceappointmentid) as RN
    from  ODS.AssignedResource bb 
    left  join ODS.ServiceResource cc on cc.id = bb.ServiceResourceId
  )
select a.AppointmentDateUTC,
       a.AppointmentDateKeyUTC,
       a.AppointmentTimeKey,
       a.LeadKey,
       a.LeadId,
       a.AccountKey,
       a.AppointmentStatus,
       a.AppoinmentStatusCategory,
       a.AccountId,
       a.Centerkey,
       a.Centernumber,
       a.AppointmentTypeKey,
       b.CenterDescription,
       b.CentertypeDescription,
       isnull(c.leadFullName, d.AccountFullName) Name,
       a.bebackflag,
       a.appointmentid,
	   a.externaltaskid,
       isnull(a.isdeleted, 0)         AS         isdeleted,
       cp.AgencyNameDerived,
       a.AppointmentDate,
       dd.DateKey                     AS         AppointmentDateKey,
          a.IsOld,
		  isnull(a.LeadId,d.AccountExternalId) as LeadIdExternal,
		  a.AppointmentType,
		  a.OpportunityId,
		  a.OpportunityStatus,
		  a.OpportunityDate,
		  a.OpportunityAmmount,
          a.ParentRecordType,
		  bb.Name as Performer
from Factapptcte a
         left join dimcenter b on a.CenterKey = b.CenterKey
         left join dimlead c on a.leadkey = c.leadkey
         left join VWDimCampaign cp on c.originalcampaignkey = cp.campaignkey
         left join dimaccount d on a.accountkey = d.accountkey
         left join dimAppointmentType e on a.AppointmentTypeKey = e.Appointmenttypekey
         left join DimDate dd on convert(date,appointmentdate) =
                                 convert(date, dd.FullDate)
         left  join assignedcte bb on a.AppointmentId = bb.ServiceAppointmentId and bb.RN=1;
GO
