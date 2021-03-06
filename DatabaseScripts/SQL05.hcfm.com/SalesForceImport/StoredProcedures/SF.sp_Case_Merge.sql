/* CreateDate: 03/17/2022 15:12:21.127 , ModifyDate: 03/17/2022 15:12:21.127 */
GO
CREATE PROCEDURE [SF].[sp_Case_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Case])
RETURN ;

BEGIN TRY
;MERGE [SF].[Case] AS [t]
USING [SFStaging].[Case] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[MasterRecordId] = [t].[MasterRecordId]
	, [t].[CaseNumber] = [t].[CaseNumber]
	, [t].[ContactId] = [t].[ContactId]
	, [t].[AccountId] = [t].[AccountId]
	, [t].[AssetId] = [t].[AssetId]
	, [t].[ProductId] = [t].[ProductId]
	, [t].[EntitlementId] = [t].[EntitlementId]
	, [t].[SourceId] = [t].[SourceId]
	, [t].[BusinessHoursId] = [t].[BusinessHoursId]
	, [t].[ParentId] = [t].[ParentId]
	, [t].[SuppliedName] = [t].[SuppliedName]
	, [t].[SuppliedEmail] = [t].[SuppliedEmail]
	, [t].[SuppliedPhone] = [t].[SuppliedPhone]
	, [t].[SuppliedCompany] = [t].[SuppliedCompany]
	, [t].[Type] = [t].[Type]
	, [t].[RecordTypeId] = [t].[RecordTypeId]
	, [t].[Status] = [t].[Status]
	, [t].[Reason] = [t].[Reason]
	, [t].[Origin] = [t].[Origin]
	, [t].[Language] = [t].[Language]
	, [t].[Subject] = [t].[Subject]
	, [t].[Priority] = [t].[Priority]
	, [t].[Description] = [t].[Description]
	, [t].[IsClosed] = [t].[IsClosed]
	, [t].[ClosedDate] = [t].[ClosedDate]
	, [t].[IsEscalated] = [t].[IsEscalated]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[OwnerId] = [t].[OwnerId]
	, [t].[IsClosedOnCreate] = [t].[IsClosedOnCreate]
	, [t].[SlaStartDate] = [t].[SlaStartDate]
	, [t].[SlaExitDate] = [t].[SlaExitDate]
	, [t].[IsStopped] = [t].[IsStopped]
	, [t].[StopStartDate] = [t].[StopStartDate]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[ContactPhone] = [t].[ContactPhone]
	, [t].[ContactMobile] = [t].[ContactMobile]
	, [t].[ContactEmail] = [t].[ContactEmail]
	, [t].[ContactFax] = [t].[ContactFax]
	, [t].[Comments] = [t].[Comments]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[ServiceContractId] = [t].[ServiceContractId]
	, [t].[MilestoneStatus] = [t].[MilestoneStatus]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[Accommodation__c] = [t].[Accommodation__c]
	, [t].[AssignedTo__c] = [t].[AssignedTo__c]
	, [t].[CallType__c] = [t].[CallType__c]
	, [t].[Campaign__c] = [t].[Campaign__c]
	, [t].[CaseAltPhone__c] = [t].[CaseAltPhone__c]
	, [t].[CaseName__c] = [t].[CaseName__c]
	, [t].[CasePhone__c] = [t].[CasePhone__c]
	, [t].[Case_Source_Chat__c] = [t].[Case_Source_Chat__c]
	, [t].[Category__c] = [t].[Category__c]
	, [t].[CenterEmployee__c] = [t].[CenterEmployee__c]
	, [t].[Center__c] = [t].[Center__c]
	, [t].[Content__c] = [t].[Content__c]
	, [t].[Courteous__c] = [t].[Courteous__c]
	, [t].[DateofAppointment__c] = [t].[DateofAppointment__c]
	, [t].[DateofIncident__c] = [t].[DateofIncident__c]
	, [t].[Didyousignup__c] = [t].[Didyousignup__c]
	, [t].[Estimated_Completion_Date__c] = [t].[Estimated_Completion_Date__c]
	, [t].[FeedbackType__c] = [t].[FeedbackType__c]
	, [t].[LeadEmail__c] = [t].[LeadEmail__c]
	, [t].[LeadId__c] = [t].[LeadId__c]
	, [t].[LeadPhone__c] = [t].[LeadPhone__c]
	, [t].[OptionOffered__c] = [t].[OptionOffered__c]
	, [t].[Points__c] = [t].[Points__c]
	, [t].[PricePlan__c] = [t].[PricePlan__c]
	, [t].[Resolution__c] = [t].[Resolution__c]
	, [t].[SignIn__c] = [t].[SignIn__c]
	, [t].[TimeofIncident__c] = [t].[TimeofIncident__c]
	, [t].[Title__c] = [t].[Title__c]
	, [t].[Wereyouontime__c] = [t].[Wereyouontime__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [MasterRecordId]
	, [CaseNumber]
	, [ContactId]
	, [AccountId]
	, [AssetId]
	, [ProductId]
	, [EntitlementId]
	, [SourceId]
	, [BusinessHoursId]
	, [ParentId]
	, [SuppliedName]
	, [SuppliedEmail]
	, [SuppliedPhone]
	, [SuppliedCompany]
	, [Type]
	, [RecordTypeId]
	, [Status]
	, [Reason]
	, [Origin]
	, [Language]
	, [Subject]
	, [Priority]
	, [Description]
	, [IsClosed]
	, [ClosedDate]
	, [IsEscalated]
	, [CurrencyIsoCode]
	, [OwnerId]
	, [IsClosedOnCreate]
	, [SlaStartDate]
	, [SlaExitDate]
	, [IsStopped]
	, [StopStartDate]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [ContactPhone]
	, [ContactMobile]
	, [ContactEmail]
	, [ContactFax]
	, [Comments]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [ServiceContractId]
	, [MilestoneStatus]
	, [External_Id__c]
	, [Accommodation__c]
	, [AssignedTo__c]
	, [CallType__c]
	, [Campaign__c]
	, [CaseAltPhone__c]
	, [CaseName__c]
	, [CasePhone__c]
	, [Case_Source_Chat__c]
	, [Category__c]
	, [CenterEmployee__c]
	, [Center__c]
	, [Content__c]
	, [Courteous__c]
	, [DateofAppointment__c]
	, [DateofIncident__c]
	, [Didyousignup__c]
	, [Estimated_Completion_Date__c]
	, [FeedbackType__c]
	, [LeadEmail__c]
	, [LeadId__c]
	, [LeadPhone__c]
	, [OptionOffered__c]
	, [Points__c]
	, [PricePlan__c]
	, [Resolution__c]
	, [SignIn__c]
	, [TimeofIncident__c]
	, [Title__c]
	, [Wereyouontime__c]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[MasterRecordId]
	, [s].[CaseNumber]
	, [s].[ContactId]
	, [s].[AccountId]
	, [s].[AssetId]
	, [s].[ProductId]
	, [s].[EntitlementId]
	, [s].[SourceId]
	, [s].[BusinessHoursId]
	, [s].[ParentId]
	, [s].[SuppliedName]
	, [s].[SuppliedEmail]
	, [s].[SuppliedPhone]
	, [s].[SuppliedCompany]
	, [s].[Type]
	, [s].[RecordTypeId]
	, [s].[Status]
	, [s].[Reason]
	, [s].[Origin]
	, [s].[Language]
	, [s].[Subject]
	, [s].[Priority]
	, [s].[Description]
	, [s].[IsClosed]
	, [s].[ClosedDate]
	, [s].[IsEscalated]
	, [s].[CurrencyIsoCode]
	, [s].[OwnerId]
	, [s].[IsClosedOnCreate]
	, [s].[SlaStartDate]
	, [s].[SlaExitDate]
	, [s].[IsStopped]
	, [s].[StopStartDate]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[ContactPhone]
	, [s].[ContactMobile]
	, [s].[ContactEmail]
	, [s].[ContactFax]
	, [s].[Comments]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[ServiceContractId]
	, [s].[MilestoneStatus]
	, [s].[External_Id__c]
	, [s].[Accommodation__c]
	, [s].[AssignedTo__c]
	, [s].[CallType__c]
	, [s].[Campaign__c]
	, [s].[CaseAltPhone__c]
	, [s].[CaseName__c]
	, [s].[CasePhone__c]
	, [s].[Case_Source_Chat__c]
	, [s].[Category__c]
	, [s].[CenterEmployee__c]
	, [s].[Center__c]
	, [s].[Content__c]
	, [s].[Courteous__c]
	, [s].[DateofAppointment__c]
	, [s].[DateofIncident__c]
	, [s].[Didyousignup__c]
	, [s].[Estimated_Completion_Date__c]
	, [s].[FeedbackType__c]
	, [s].[LeadEmail__c]
	, [s].[LeadId__c]
	, [s].[LeadPhone__c]
	, [s].[OptionOffered__c]
	, [s].[Points__c]
	, [s].[PricePlan__c]
	, [s].[Resolution__c]
	, [s].[SignIn__c]
	, [s].[TimeofIncident__c]
	, [s].[Title__c]
	, [s].[Wereyouontime__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Case] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
