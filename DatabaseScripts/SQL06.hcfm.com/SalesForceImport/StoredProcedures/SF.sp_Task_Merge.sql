/* CreateDate: 03/06/2022 17:23:58.397 , ModifyDate: 03/06/2022 17:23:58.397 */
GO
CREATE PROCEDURE [SF].[sp_Task_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Task])
RETURN ;

BEGIN TRY
;MERGE [SF].[Task] AS [t]
USING [SFStaging].[Task] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[RecordTypeId] = [t].[RecordTypeId]
	, [t].[WhoId] = [t].[WhoId]
	, [t].[WhatId] = [t].[WhatId]
	, [t].[WhoCount] = [t].[WhoCount]
	, [t].[WhatCount] = [t].[WhatCount]
	, [t].[Subject] = [t].[Subject]
	, [t].[ActivityDate] = [t].[ActivityDate]
	, [t].[Status] = [t].[Status]
	, [t].[Priority] = [t].[Priority]
	, [t].[IsHighPriority] = [t].[IsHighPriority]
	, [t].[OwnerId] = [t].[OwnerId]
	, [t].[Description] = [t].[Description]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[Type] = [t].[Type]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[AccountId] = [t].[AccountId]
	, [t].[IsClosed] = [t].[IsClosed]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsArchived] = [t].[IsArchived]
	, [t].[CallDurationInSeconds] = [t].[CallDurationInSeconds]
	, [t].[CallType] = [t].[CallType]
	, [t].[CallDisposition] = [t].[CallDisposition]
	, [t].[CallObject] = [t].[CallObject]
	, [t].[ReminderDateTime] = [t].[ReminderDateTime]
	, [t].[IsReminderSet] = [t].[IsReminderSet]
	, [t].[RecurrenceActivityId] = [t].[RecurrenceActivityId]
	, [t].[IsRecurrence] = [t].[IsRecurrence]
	, [t].[RecurrenceStartDateOnly] = [t].[RecurrenceStartDateOnly]
	, [t].[RecurrenceEndDateOnly] = [t].[RecurrenceEndDateOnly]
	, [t].[RecurrenceTimeZoneSidKey] = [t].[RecurrenceTimeZoneSidKey]
	, [t].[RecurrenceType] = [t].[RecurrenceType]
	, [t].[RecurrenceInterval] = [t].[RecurrenceInterval]
	, [t].[RecurrenceDayOfWeekMask] = [t].[RecurrenceDayOfWeekMask]
	, [t].[RecurrenceDayOfMonth] = [t].[RecurrenceDayOfMonth]
	, [t].[RecurrenceInstance] = [t].[RecurrenceInstance]
	, [t].[RecurrenceMonthOfYear] = [t].[RecurrenceMonthOfYear]
	, [t].[RecurrenceRegeneratedType] = [t].[RecurrenceRegeneratedType]
	, [t].[TaskSubtype] = [t].[TaskSubtype]
	, [t].[CompletedDateTime] = [t].[CompletedDateTime]
	, [t].[BrightPattern__SPRecordingOrTranscriptURL__c] = [t].[BrightPattern__SPRecordingOrTranscriptURL__c]
	, [t].[Center_Name__c] = [t].[Center_Name__c]
	, [t].[Completed_Date__c] = [t].[Completed_Date__c]
	, [t].[External_ID__c] = [t].[External_ID__c]
	, [t].[Lead__c] = [t].[Lead__c]
	, [t].[Meeting_Platform_Id__c] = [t].[Meeting_Platform_Id__c]
	, [t].[Meeting_Platform__c] = [t].[Meeting_Platform__c]
	, [t].[Person_Account__c] = [t].[Person_Account__c]
	, [t].[Recording_Link__c] = [t].[Recording_Link__c]
	, [t].[Result__c] = [t].[Result__c]
	, [t].[SPRecordingOrTranscriptURL__c] = [t].[SPRecordingOrTranscriptURL__c]
	, [t].[Service_Appointment__c] = [t].[Service_Appointment__c]
	, [t].[Service_Territory_Caller_Id__c] = [t].[Service_Territory_Caller_Id__c]
	, [t].[Agent_Link__c] = [t].[Agent_Link__c]
	, [t].[Guest_Link__c] = [t].[Guest_Link__c]
	, [t].[Opportunity__c] = [t].[Opportunity__c]
	, [t].[Center_Phone__c] = [t].[Center_Phone__c]
	, [t].[DB_Activity_Type__c] = [t].[DB_Activity_Type__c]
	, [t].[CallBackDueDate__c] = [t].[CallBackDueDate__c]
	, [t].[Invite__c] = [t].[Invite__c]
	, [t].[TaskWhoIds] = [t].[TaskWhoIds]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [RecordTypeId]
	, [WhoId]
	, [WhatId]
	, [WhoCount]
	, [WhatCount]
	, [Subject]
	, [ActivityDate]
	, [Status]
	, [Priority]
	, [IsHighPriority]
	, [OwnerId]
	, [Description]
	, [CurrencyIsoCode]
	, [Type]
	, [IsDeleted]
	, [AccountId]
	, [IsClosed]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [IsArchived]
	, [CallDurationInSeconds]
	, [CallType]
	, [CallDisposition]
	, [CallObject]
	, [ReminderDateTime]
	, [IsReminderSet]
	, [RecurrenceActivityId]
	, [IsRecurrence]
	, [RecurrenceStartDateOnly]
	, [RecurrenceEndDateOnly]
	, [RecurrenceTimeZoneSidKey]
	, [RecurrenceType]
	, [RecurrenceInterval]
	, [RecurrenceDayOfWeekMask]
	, [RecurrenceDayOfMonth]
	, [RecurrenceInstance]
	, [RecurrenceMonthOfYear]
	, [RecurrenceRegeneratedType]
	, [TaskSubtype]
	, [CompletedDateTime]
	, [BrightPattern__SPRecordingOrTranscriptURL__c]
	, [Center_Name__c]
	, [Completed_Date__c]
	, [External_ID__c]
	, [Lead__c]
	, [Meeting_Platform_Id__c]
	, [Meeting_Platform__c]
	, [Person_Account__c]
	, [Recording_Link__c]
	, [Result__c]
	, [SPRecordingOrTranscriptURL__c]
	, [Service_Appointment__c]
	, [Service_Territory_Caller_Id__c]
	, [Agent_Link__c]
	, [Guest_Link__c]
	, [Opportunity__c]
	, [Center_Phone__c]
	, [DB_Activity_Type__c]
	, [CallBackDueDate__c]
	, [Invite__c]
	, [TaskWhoIds]
	)
	VALUES(
	[s].[Id]
	, [s].[RecordTypeId]
	, [s].[WhoId]
	, [s].[WhatId]
	, [s].[WhoCount]
	, [s].[WhatCount]
	, [s].[Subject]
	, [s].[ActivityDate]
	, [s].[Status]
	, [s].[Priority]
	, [s].[IsHighPriority]
	, [s].[OwnerId]
	, [s].[Description]
	, [s].[CurrencyIsoCode]
	, [s].[Type]
	, [s].[IsDeleted]
	, [s].[AccountId]
	, [s].[IsClosed]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[IsArchived]
	, [s].[CallDurationInSeconds]
	, [s].[CallType]
	, [s].[CallDisposition]
	, [s].[CallObject]
	, [s].[ReminderDateTime]
	, [s].[IsReminderSet]
	, [s].[RecurrenceActivityId]
	, [s].[IsRecurrence]
	, [s].[RecurrenceStartDateOnly]
	, [s].[RecurrenceEndDateOnly]
	, [s].[RecurrenceTimeZoneSidKey]
	, [s].[RecurrenceType]
	, [s].[RecurrenceInterval]
	, [s].[RecurrenceDayOfWeekMask]
	, [s].[RecurrenceDayOfMonth]
	, [s].[RecurrenceInstance]
	, [s].[RecurrenceMonthOfYear]
	, [s].[RecurrenceRegeneratedType]
	, [s].[TaskSubtype]
	, [s].[CompletedDateTime]
	, [s].[BrightPattern__SPRecordingOrTranscriptURL__c]
	, [s].[Center_Name__c]
	, [s].[Completed_Date__c]
	, [s].[External_ID__c]
	, [s].[Lead__c]
	, [s].[Meeting_Platform_Id__c]
	, [s].[Meeting_Platform__c]
	, [s].[Person_Account__c]
	, [s].[Recording_Link__c]
	, [s].[Result__c]
	, [s].[SPRecordingOrTranscriptURL__c]
	, [s].[Service_Appointment__c]
	, [s].[Service_Territory_Caller_Id__c]
	, [s].[Agent_Link__c]
	, [s].[Guest_Link__c]
	, [s].[Opportunity__c]
	, [s].[Center_Phone__c]
	, [s].[DB_Activity_Type__c]
	, [s].[CallBackDueDate__c]
	, [s].[Invite__c]
	, [s].[TaskWhoIds]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Task] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO