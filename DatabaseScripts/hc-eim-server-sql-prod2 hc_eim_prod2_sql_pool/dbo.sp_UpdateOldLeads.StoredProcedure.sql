/****** Object:  StoredProcedure [dbo].[sp_UpdateOldLeads]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UpdateOldLeads] AS

begin

/********************************************************* UPDATE LEADS *************************************************************/

    update DimLead
set LeadExternalID = LeadId
where LeadId in (select External_Id__c from ods.SF_Lead)


 update DimLead
 set LeadID = odsl.id
 from ods.SF_Lead odsl
 where DimLead.LeadId = odsl.External_Id__c


/************************************************************ UPDATE APPOINMENTS *******************************************************/

 update FactAppointment
 set AppointmentId = d.id
 from FactAppointment a
 inner join DimLead c on c.LeadExternalID = a.LeadId --316453
 inner join ODS.SF_ServiceAppointment d on d.ParentRecordId = c.LeadId and (a.FactDate=d.CreatedDate)



update FactAppointment
		set FactAppointment.CenterKey = l.CenterKey
	FROM FactAppointment f
	INNER JOIN dbo.DimCenter l
	on f.CenterNumber = l.CenterNumber
where l.IsActiveFlag = '1'


update FactAppointment
		set FactAppointment.LeadKey = l.LeadKey
	FROM FactAppointment f
	INNER JOIN dbo.DimLead l
	on f.LeadId = l.LeadId


update FactAppointment set FactAppointment.ContactKey = FactAppointment.LeadKey


update FactAppointment
		set FactAppointment.OldStatus = FactAppointment.AppointmentStatus

update FactAppointment
		set FactAppointment.AppointmentStatus = 'Canceled',
		    FactAppointment.AppoinmentStatusCategory = 'Canceled'
where OldStatus in (
    'No Confirmation Made',
    'Prank',
    'Expired',
    'Cancel',
    'Canceled',
    'Reschedule'

    )

update FactAppointment
		set FactAppointment.AppointmentStatus = 'Completed',
		    FactAppointment.AppoinmentStatusCategory = 'Completed'
where OldStatus in (
    'Show Sale',
    'Show No Sale',
    'BB Manual Credit',
    'Manual Credit',
    'Completed'
    )

update FactAppointment
		   set FactAppointment.AppoinmentStatusCategory = 'Cannot Complete'
where OldStatus in (
    'No Show'
    )

update FactAppointment
		   set FactAppointment.AppoinmentStatusCategory = 'Canceled'
where OldStatus in (
    'No Transportation'
    )

update FactAppointment
		   set FactAppointment.AppoinmentStatusCategory = 'Scheduled'
where OldStatus in (
    'Scheduled'
    )

/***************************************************** UPDATE OPPORTUNITY **************************************************************/

update FactOpportunity
 set OpportunityId = d.id
 from ODS.SF_Opportunity d
inner join DimLead c on d.AccountId = c.ConvertedAccountId  --316453
inner join TaskProd t on t.WhoId = c.LeadId
where t.action__c in ('Appointment','Be Back','In House','Recovery') and ( t.result__c in ('Show Sale','Show No Sale'))
and FactOpportunity.FactDate= t.ActivityDate and FactOpportunity.LeadId = c.LeadId



update FactOpportunity
		set FactOpportunity.CenterKey = l.CenterKey
	FROM FactOpportunity f
	INNER JOIN dbo.DimCenter l
	on f.CenterNumber = l.CenterNumber
where l.IsActiveFlag = '1'


update FactOpportunity
		set FactOpportunity.LeadKey = l.LeadKey
	FROM FactOpportunity f
	INNER JOIN dbo.DimLead l
	on f.LeadId = l.LeadId

update FactOpportunity
        set FactOpportunity.FactDatekey = dt.DateKey
    FROM FactOpportunity f
    inner join [dbo].[DimDate] dt
            on dt.[FullDate] = cast(f.FactDate as date)


update FactOpportunity
		set FactOpportunity.LeadKey = l.LeadKey
	FROM FactOpportunity f
	INNER JOIN dbo.DimLead l
	on f.LeadId = l.LeadId



end
GO
