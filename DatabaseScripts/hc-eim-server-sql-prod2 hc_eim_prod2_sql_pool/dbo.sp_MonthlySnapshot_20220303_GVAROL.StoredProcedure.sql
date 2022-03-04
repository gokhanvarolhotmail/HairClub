/****** Object:  StoredProcedure [dbo].[sp_MonthlySnapshot_20220303_GVAROL]    Script Date: 3/4/2022 8:28:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_MonthlySnapshot_20220303_GVAROL] AS
INSERT INTO [dbo].[FactLeadTracking]( [LeadKey]
                                    , [LeadId]
                                    , [LeadFirstName]
                                    , [LeadLastname]
                                    , [LeadFullName]
                                    , [LeadBirthday]
                                    , [LeadAddress]
                                    , [IsActive]
                                    , [IsConsultFormComplete]
                                    , [Isvalid]
                                    , [LeadEmail]
                                    , [LeadPhone]
                                    , [LeadMobilePhone]
                                    , [NorwoodScale]
                                    , [LudwigScale]
                                    , [HairLossInFamily]
                                    , [HairLossProductUsed]
                                    , [HairLossSpot]
                                    , [GeographyKey]
                                    , [LeadPostalCode]
                                    , [EthnicityKey]
                                    , [LeadEthnicity]
                                    , [GenderKey]
                                    , [LeadGender]
                                    , [CenterKey]
                                    , [CenterNumber]
                                    , [LanguageKey]
                                    , [LeadLanguage]
                                    , [StatusKey]
                                    , [LeadStatus]
                                    , [LeadCreatedDate]
                                    , [CreatedDateKey]
                                    , [CreatedTimeKey]
                                    , [LeadLastActivityDate]
                                    , [LastActivityDateKey]
                                    , [LastActivityTimekey]
                                    , [DISCStyle]
                                    , [LeadMaritalStatus]
                                    , [LeadConsultReady]
                                    , [ConsultationFormReady]
                                    , [IsDeleted]
                                    , [DoNotCall]
                                    , [DoNotContact]
                                    , [DoNotEmail]
                                    , [DoNotMail]
                                    , [DoNotText]
                                    , [CreateUser]
                                    , [UpdateUser]
                                    , [City]
                                    , [State]
                                    , [MaritalStatusKey]
                                    , [LeadSource]
                                    , [SourceKey]
                                    , [OriginalCommMethodkey]
                                    , [RecentCommMethodKey]
                                    , [CommunicationMethod]
                                    , [IsValidLeadName]
                                    , [IsValidLeadLastName]
                                    , [IsValidLeadFullName]
                                    , [IsValidLeadPhone]
                                    , [IsValidLeadMobilePhone]
                                    , [IsValidLeadEmail]
                                    , [ReviewNeeded]
                                    , [ConvertedContactId]
                                    , [ConvertedAccountId]
                                    , [ConvertedOpportunityId]
                                    , [ConvertedDate]
                                    , [LastModifiedDate]
                                    , [SourceSystem]
                                    , [DWH_CreatedDate]
                                    , [DWH_LastUpdateDate]
                                    , [LeadExternalID]
                                    , [ServiceTerritoryID]
                                    , [OriginalCampaignId]
                                    , [OriginalCampaignKey]
                                    , [AccountID]
                                    , [LeadOccupation]
                                    , [OriginalCampaignSource]
                                    , [GCLID]
                                    , [RealCreatedDate] )
SELECT
    [LeadKey]
  , [LeadId]
  , [LeadFirstName]
  , [LeadLastname]
  , [LeadFullName]
  , [LeadBirthday]
  , [LeadAddress]
  , [IsActive]
  , [IsConsultFormComplete]
  , [Isvalid]
  , [LeadEmail]
  , [LeadPhone]
  , [LeadMobilePhone]
  , [NorwoodScale]
  , [LudwigScale]
  , [HairLossInFamily]
  , [HairLossProductUsed]
  , [HairLossSpot]
  , [GeographyKey]
  , [LeadPostalCode]
  , [EthnicityKey]
  , [LeadEthnicity]
  , [GenderKey]
  , [LeadGender]
  , [CenterKey]
  , [CenterNumber]
  , [LanguageKey]
  , [LeadLanguage]
  , [StatusKey]
  , [LeadStatus]
  , [LeadCreatedDate]
  , [CreatedDateKey]
  , [CreatedTimeKey]
  , [LeadLastActivityDate]
  , [LastActivityDateKey]
  , [LastActivityTimekey]
  , [DISCStyle]
  , [LeadMaritalStatus]
  , [LeadConsultReady]
  , [ConsultationFormReady]
  , [IsDeleted]
  , [DoNotCall]
  , [DoNotContact]
  , [DoNotEmail]
  , [DoNotMail]
  , [DoNotText]
  , [CreateUser]
  , [UpdateUser]
  , [City]
  , [State]
  , [MaritalStatusKey]
  , [LeadSource]
  , [SourceKey]
  , [OriginalCommMethodkey]
  , [RecentCommMethodKey]
  , [CommunicationMethod]
  , [IsValidLeadName]
  , [IsValidLeadLastName]
  , [IsValidLeadFullName]
  , [IsValidLeadPhone]
  , [IsValidLeadMobilePhone]
  , [IsValidLeadEmail]
  , [ReviewNeeded]
  , [ConvertedContactId]
  , [ConvertedAccountId]
  , [ConvertedOpportunityId]
  , [ConvertedDate]
  , [LastModifiedDate]
  , [SourceSystem]
  , [DWH_CreatedDate]
  , [DWH_LastUpdateDate]
  , [LeadExternalID]
  , [ServiceTerritoryID]
  , [OriginalCampaignId]
  , [OriginalCampaignKey]
  , [AccountID]
  , [LeadOccupation]
  , [OriginalCampaignSource]
  , [GCLID]
  , [RealCreatedDate]
FROM [dbo].[DimLead]
WHERE MONTH(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [LeadCreatedDate]))) = MONTH(
                                                                                                                                                         DATEADD(
                                                                                                                                                         DAY
                                                                                                                                                         , -1
                                                                                                                                                         , GETDATE()))
  AND YEAR(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [LeadCreatedDate]))) = YEAR(
                                                                                                                                                        DATEADD(
                                                                                                                                                        DAY , -1
                                                                                                                                                        , GETDATE())) ;

INSERT INTO [dbo].[FactOpportunityTracking]( [FactDate]
                                           , [FactDatekey]
                                           , [OpportunityId]
                                           , [LeadKey]
                                           , [LeadId]
                                           , [AccountKey]
                                           , [AccountId]
                                           , [OpportunityName]
                                           , [OpportunityDescription]
                                           , [StatusKey]
                                           , [OpportunityStatus]
                                           , [CampaignKey]
                                           , [OpportunityCampaign]
                                           , [CloseDate]
                                           , [CloseDateKey]
                                           , [CreatedDate]
                                           , [CreatedUserKey]
                                           , [CreatedById]
                                           , [LastModifiedDate]
                                           , [UpdateUserKey]
                                           , [LastModifiedById]
                                           , [LossReasonKey]
                                           , [OpportunityLossReason]
                                           , [IsDeleted]
                                           , [IsClosed]
                                           , [IsWon]
                                           , [OpportunityReferralCode]
                                           , [OpportunitySourceCode]
                                           , [OpportunitySolutionOffered]
                                           , [ExternalTaskId]
                                           , [BeBackFlag]
                                           , [CenterKey]
                                           , [CenterNumber]
                                           , [IsOld]
                                           , [Ammount] )
SELECT
    [FactDate]
  , [FactDatekey]
  , [OpportunityId]
  , [LeadKey]
  , [LeadId]
  , [AccountKey]
  , [AccountId]
  , [OpportunityName]
  , [OpportunityDescription]
  , [StatusKey]
  , [OpportunityStatus]
  , [CampaignKey]
  , [OpportunityCampaign]
  , [CloseDate]
  , [CloseDateKey]
  , [CreatedDate]
  , [CreatedUserKey]
  , [CreatedById]
  , [LastModifiedDate]
  , [UpdateUserKey]
  , [LastModifiedById]
  , [LossReasonKey]
  , [OpportunityLossReason]
  , [IsDeleted]
  , [IsClosed]
  , [IsWon]
  , [OpportunityReferralCode]
  , [OpportunitySourceCode]
  , [OpportunitySolutionOffered]
  , [ExternalTaskId]
  , [BeBackFlag]
  , [CenterKey]
  , [CenterNumber]
  , [IsOld]
  , [Ammount]
FROM [dbo].[FactOpportunity]
WHERE MONTH(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [FactDate])AT TIME ZONE 'Eastern Standard Time'), [FactDate]))) = MONTH(
                                                                                                                                           DATEADD(
                                                                                                                                           DAY , -1, GETDATE()))
  AND YEAR(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [FactDate])AT TIME ZONE 'Eastern Standard Time'), [FactDate]))) = YEAR(
                                                                                                                                          DATEADD(
                                                                                                                                          DAY , -1, GETDATE())) ;

INSERT INTO [dbo].[FactAppointmentTracking]( [FactDate]
                                           , [FactTimeKey]
                                           , [FactDateKey]
                                           , [AppointmentDate]
                                           , [AppointmentTimeKey]
                                           , [AppointmentDateKey]
                                           , [LeadKey]
                                           , [LeadId]
                                           , [AccountKey]
                                           , [AccountId]
                                           , [ContactKey]
                                           , [ContactId]
                                           , [ParentRecordType]
                                           , [WorkTypeKey]
                                           , [WorkTypeId]
                                           , [AccountAddress]
                                           , [AccountCity]
                                           , [AccountState]
                                           , [AccountPostalCode]
                                           , [AccountCountry]
                                           , [GeographyKey]
                                           , [AppointmentDescription]
                                           , [AppointmentStatus]
                                           , [CenterKey]
                                           , [ServiceTerritoryId]
                                           , [CenterNumber]
                                           , [AppointmentTypeKey]
                                           , [AppointmentType]
                                           , [AppointmentCenterType]
                                           , [ExternalId]
                                           , [ServiceAppointment]
                                           , [MeetingPlatformKey]
                                           , [MeetingPlatformId]
                                           , [MeetingPlatform]
                                           , [DWH_LoadDate]
                                           , [DWH_LastUpdateDate]
                                           , [ParentRecordId]
                                           , [AppointmentId]
                                           , [ExternalTaskId]
                                           , [StatusKey]
                                           , [CancellationReason]
                                           , [BeBackFlag]
                                           , [OldStatus]
                                           , [AppoinmentStatusCategory]
                                           , [IsDeleted]
                                           , [IsOld]
                                           , [OpportunityId]
                                           , [OpportunityStatus]
                                           , [OpportunityDate]
                                           , [OpportunityReferralCode]
                                           , [OpportunityReferralCodeExpirationDate]
                                           , [OpportunityAmount] )
SELECT
    [FactDate]
  , [FactTimeKey]
  , [FactDateKey]
  , [AppointmentDate]
  , [AppointmentTimeKey]
  , [AppointmentDateKey]
  , [LeadKey]
  , [LeadId]
  , [AccountKey]
  , [AccountId]
  , [ContactKey]
  , [ContactId]
  , [ParentRecordType]
  , [WorkTypeKey]
  , [WorkTypeId]
  , [AccountAddress]
  , [AccountCity]
  , [AccountState]
  , [AccountPostalCode]
  , [AccountCountry]
  , [GeographyKey]
  , [AppointmentDescription]
  , [AppointmentStatus]
  , [CenterKey]
  , [ServiceTerritoryId]
  , [CenterNumber]
  , [AppointmentTypeKey]
  , [AppointmentType]
  , [AppointmentCenterType]
  , [ExternalId]
  , [ServiceAppointment]
  , [MeetingPlatformKey]
  , [MeetingPlatformId]
  , [MeetingPlatform]
  , [DWH_LoadDate]
  , [DWH_LastUpdateDate]
  , [ParentRecordId]
  , [AppointmentId]
  , [ExternalTaskId]
  , [StatusKey]
  , [CancellationReason]
  , [BeBackFlag]
  , [OldStatus]
  , [AppoinmentStatusCategory]
  , [IsDeleted]
  , [IsOld]
  , [OpportunityId]
  , [OpportunityStatus]
  , [OpportunityDate]
  , [OpportunityReferralCode]
  , [OpportunityReferralCodeExpirationDate]
  , [OpportunityAmmount]
FROM [dbo].[FactAppointment]
WHERE MONTH(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [AppointmentDate])AT TIME ZONE 'Eastern Standard Time'), [AppointmentDate]))) = MONTH(
                                                                                                                                                         DATEADD(
                                                                                                                                                         DAY
                                                                                                                                                         , -1
                                                                                                                                                         , GETDATE()))
  AND YEAR(CONVERT(DATE, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [AppointmentDate])AT TIME ZONE 'Eastern Standard Time'), [AppointmentDate]))) = YEAR(
                                                                                                                                                        DATEADD(
                                                                                                                                                        DAY , -1
                                                                                                                                                        , GETDATE())) ;
GO
