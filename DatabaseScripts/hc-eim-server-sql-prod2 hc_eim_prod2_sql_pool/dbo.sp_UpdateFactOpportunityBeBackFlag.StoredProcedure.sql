/****** Object:  StoredProcedure [dbo].[sp_UpdateFactOpportunityBeBackFlag]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UpdateFactOpportunityBeBackFlag] AS
begin


    update FactAppointment
    set BeBackFlag = 1
    from FactOpportunity fo
    where fo.LeadId = FactAppointment.LeadId
      and fo.IsWon = 0
      and FactAppointment.AppointmentDate > fo.FactDate
      and abs(datediff(day, FactAppointment.AppointmentDate, fo.FactDate)) <= 365
      and abs(datediff(day, FactAppointment.AppointmentDate, fo.FactDate)) > 0

    select count(*), BeBackFlag
    from FactAppointment
    where convert(date, AppointmentDate) >= '2021-06-15'
    group by BeBackFlag


end
GO
