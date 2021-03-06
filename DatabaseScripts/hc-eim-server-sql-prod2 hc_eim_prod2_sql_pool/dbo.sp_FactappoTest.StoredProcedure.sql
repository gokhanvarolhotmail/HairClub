/****** Object:  StoredProcedure [dbo].[sp_FactappoTest]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_FactappoTest] AS
BEGIN
    truncate table FactAppointmentTest;

    With task as (
        SELECT a.*,
        ROW_NUMBER() OVER(PARTITION BY a.AppointmentId ORDER BY b.LeadCreatedDate DESC)
        AS RowNum
        FROM dbo.FactAppointmentTestDups a
        left join LeadCopyBB b on a.LeadId = b.LeadId
        )
    insert into FactAppointmentTest
    select   FactDate,
                   FactTimeKey,
                   FactDateKey,
                   AppointmentDate,
                   AppointmentTimeKey,
                   AppointmentDateKey,
                   LeadKey,
                   LeadId,
                   AccountKey,
                   AccountId,
                   ContactKey,
                   ContactId,
                   ParentRecordType,
                   WorkTypeKey,
                   WorkTypeId,
                   AccountAddress,
                   AccountCity,
                   AccountState,
                   AccountPostalCode,
                   AccountCountry,
                   GeographyKey,
                   AppointmentDescription,
                   AppointmentStatus,
                   CenterKey,
                   ServiceTerritoryId,
                   CenterNumber,
                   AppointmentTypeKey,
                   AppointmentType,
                   AppointmentCenterType,
                   ExternalId,
                   ServiceAppointment,
                   MeetingPlatformKey,
                   MeetingPlatformId,
                   MeetingPlatform,
                   DWH_LoadDate,
                   DWH_LastUpdateDate,
                   ParentRecordId,
                   AppointmentId,
                   ExternalTaskId,
                   StatusKey,
                   CancellationReason,
                   BeBackFlag,
                   OldStatus,
                   AppoinmentStatusCategory,
                   IsDeleted,
                   IsOld,
                   OpportunityId,
                   OpportunityStatus,
                   OpportunityDate,
                   OpportunityReferralCode,
                   OpportunityReferralCodeExpirationDate,
                   OpportunityAmmount,
                   Performer,
                   performerKey
    from task
    where task.RowNum = 1
end
GO
