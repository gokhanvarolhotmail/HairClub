/****** Object:  StoredProcedure [dbo].[sp_MonthlySnapshot_20220223_GVAROL]    Script Date: 3/7/2022 8:42:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_MonthlySnapshot_20220223_GVAROL] AS


insert into FactLeadTracking (LeadKey, LeadId, LeadFirstName, LeadLastname, LeadFullName, LeadBirthday, LeadAddress,
                              IsActive, IsConsultFormComplete, Isvalid, LeadEmail, LeadPhone, LeadMobilePhone,
                              NorwoodScale, LudwigScale, HairLossInFamily, HairLossProductUsed, HairLossSpot,
                              GeographyKey, LeadPostalCode, EthnicityKey, LeadEthnicity, GenderKey, LeadGender,
                              CenterKey, CenterNumber, LanguageKey, LeadLanguage, StatusKey, LeadStatus,
                              LeadCreatedDate, CreatedDateKey, CreatedTimeKey, LeadLastActivityDate,
                              LastActivityDateKey, LastActivityTimekey, DISCStyle, LeadMaritalStatus, LeadConsultReady,
                              ConsultationFormReady, IsDeleted, DoNotCall, DoNotContact, DoNotEmail, DoNotMail,
                              DoNotText, CreateUser, UpdateUser, City, State, MaritalStatusKey, LeadSource, SourceKey,
                              OriginalCommMethodkey, RecentCommMethodKey, CommunicationMethod, IsValidLeadName,
                              IsValidLeadLastName, IsValidLeadFullName, IsValidLeadPhone, IsValidLeadMobilePhone,
                              IsValidLeadEmail, ReviewNeeded, ConvertedContactId, ConvertedAccountId,
                              ConvertedOpportunityId, ConvertedDate, LastModifiedDate, SourceSystem, DWH_CreatedDate,
                              DWH_LastUpdateDate, LeadExternalID, ServiceTerritoryID, OriginalCampaignId,
                              OriginalCampaignKey, AccountID, LeadOccupation, OriginalCampaignSource, GCLID,
                              RealCreatedDate)
select leadkey,
       leadid,
       leadfirstname,
       leadlastname,
       leadfullname,
       leadbirthday,
       leadaddress,
       isactive,
       isconsultformcomplete,
       isvalid,
       leademail,
       leadphone,
       leadmobilephone,
       norwoodscale,
       ludwigscale,
       hairlossinfamily,
       hairlossproductused,
       hairlossspot,
       geographykey,
       leadpostalcode,
       ethnicitykey,
       leadethnicity,
       genderkey,
       leadgender,
       centerkey,
       centernumber,
       languagekey,
       leadlanguage,
       statuskey,
       leadstatus,
       leadcreateddate,
       createddatekey,
       createdtimekey,
       leadlastactivitydate,
       lastactivitydatekey,
       lastactivitytimekey,
       discstyle,
       leadmaritalstatus,
       leadconsultready,
       consultationformready,
       isdeleted,
       donotcall,
       donotcontact,
       donotemail,
       donotmail,
       donottext,
       createuser,
       updateuser,
       city,
       state,
       maritalstatuskey,
       leadsource,
       sourcekey,
       originalcommmethodkey,
       recentcommmethodkey,
       communicationmethod,
       isvalidleadname,
       isvalidleadlastname,
       isvalidleadfullname,
       isvalidleadphone,
       isvalidleadmobilephone,
       isvalidleademail,
       reviewneeded,
       convertedcontactid,
       convertedaccountid,
       convertedopportunityid,
       converteddate,
       lastmodifieddate,
       sourcesystem,
       dwh_createddate,
       dwh_lastupdatedate,
       leadexternalid,
       serviceterritoryid,
       originalcampaignid,
       originalcampaignkey,
       accountid,
       leadoccupation,
       originalcampaignsource,
       gclid,
       realcreateddate
from DimLead
where month(convert(date, dateadd(mi, datepart(tz,
                                               CONVERT(datetime, LeadCreatedDate) AT TIME ZONE
                                               'Eastern Standard Time'), LeadCreatedDate))) =
      month(dateadd(day,  -1, getdate()))
  and year(convert(date, dateadd(mi, datepart(tz,
                                              CONVERT(datetime, LeadCreatedDate) AT TIME ZONE
                                              'Eastern Standard Time'), LeadCreatedDate))) =
      year(dateadd(day,  -1, getdate()))


insert into FactOpportunityTracking (FactDate, FactDatekey, OpportunityId, LeadKey, LeadId, AccountKey, AccountId,
                                     OpportunityName, OpportunityDescription, StatusKey, OpportunityStatus, CampaignKey,
                                     OpportunityCampaign, CloseDate, CloseDateKey, CreatedDate, CreatedUserKey,
                                     CreatedById, LastModifiedDate, UpdateUserKey, LastModifiedById, LossReasonKey,
                                     OpportunityLossReason, IsDeleted, IsClosed, IsWon, OpportunityReferralCode,
                                     OpportunitySourceCode, OpportunitySolutionOffered, ExternalTaskId, BeBackFlag,
                                     CenterKey, CenterNumber, IsOld, Ammount)
select factdate,
       factdatekey,
       opportunityid,
       leadkey,
       leadid,
       accountkey,
       accountid,
       opportunityname,
       opportunitydescription,
       statuskey,
       opportunitystatus,
       campaignkey,
       opportunitycampaign,
       closedate,
       closedatekey,
       createddate,
       createduserkey,
       createdbyid,
       lastmodifieddate,
       updateuserkey,
       lastmodifiedbyid,
       lossreasonkey,
       opportunitylossreason,
       isdeleted,
       isclosed,
       iswon,
       opportunityreferralcode,
       opportunitysourcecode,
       opportunitysolutionoffered,
       externaltaskid,
       bebackflag,
       centerkey,
       centernumber,
       isold,
       ammount
from FactOpportunity
where month(convert(date, dateadd(mi, datepart(tz,
                                               CONVERT(datetime, FactDate) AT TIME ZONE
                                               'Eastern Standard Time'), FactDate))) =
      month(dateadd(day,  -1, getdate()))
  and year(convert(date, dateadd(mi, datepart(tz,
                                              CONVERT(datetime, FactDate) AT TIME ZONE
                                              'Eastern Standard Time'), FactDate))) = year(dateadd(day,  -1, getdate()))


INSERT into FactAppointmentTracking (FactDate, FactTimeKey, FactDateKey, AppointmentDate, AppointmentTimeKey,
                                     AppointmentDateKey, LeadKey, LeadId, AccountKey, AccountId, ContactKey, ContactId,
                                     ParentRecordType, WorkTypeKey, WorkTypeId, AccountAddress, AccountCity,
                                     AccountState, AccountPostalCode, AccountCountry, GeographyKey,
                                     AppointmentDescription, AppointmentStatus, CenterKey, ServiceTerritoryId,
                                     CenterNumber, AppointmentTypeKey, AppointmentType, AppointmentCenterType,
                                     ExternalId, ServiceAppointment, MeetingPlatformKey, MeetingPlatformId,
                                     MeetingPlatform, DWH_LoadDate, DWH_LastUpdateDate, ParentRecordId, AppointmentId,
                                     ExternalTaskId, StatusKey, CancellationReason, BeBackFlag, OldStatus,
                                     AppoinmentStatusCategory, IsDeleted, IsOld, OpportunityId, OpportunityStatus,
                                     OpportunityDate, OpportunityReferralCode, OpportunityReferralCodeExpirationDate,
                                     OpportunityAmount)
select FactDate,
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
       OpportunityAmmount
from FactAppointment
where month(convert(date, dateadd(mi, datepart(tz,
                                               CONVERT(datetime, AppointmentDate) AT TIME ZONE
                                               'Eastern Standard Time'), AppointmentDate))) =
      month(dateadd(day,  -1, getdate()))
  and year(convert(date, dateadd(mi, datepart(tz,
                                              CONVERT(datetime, AppointmentDate) AT TIME ZONE
                                              'Eastern Standard Time'), AppointmentDate))) = year(dateadd(day,  -1, getdate()))
GO
