/* CreateDate: 03/06/2022 17:23:57.217 , ModifyDate: 03/06/2022 17:23:57.217 */
GO
CREATE PROCEDURE [SF].[sp_Event_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[Event])
RETURN ;

BEGIN TRY
;MERGE [SF].[Event] AS [t]
USING [SFStaging].[Event] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[WhoId] = [t].[WhoId]
	, [t].[WhatId] = [t].[WhatId]
	, [t].[WhoCount] = [t].[WhoCount]
	, [t].[WhatCount] = [t].[WhatCount]
	, [t].[Subject] = [t].[Subject]
	, [t].[Location] = [t].[Location]
	, [t].[IsAllDayEvent] = [t].[IsAllDayEvent]
	, [t].[ActivityDateTime] = [t].[ActivityDateTime]
	, [t].[ActivityDate] = [t].[ActivityDate]
	, [t].[DurationInMinutes] = [t].[DurationInMinutes]
	, [t].[StartDateTime] = [t].[StartDateTime]
	, [t].[EndDateTime] = [t].[EndDateTime]
	, [t].[EndDate] = [t].[EndDate]
	, [t].[Description] = [t].[Description]
	, [t].[AccountId] = [t].[AccountId]
	, [t].[OwnerId] = [t].[OwnerId]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[Type] = [t].[Type]
	, [t].[IsPrivate] = [t].[IsPrivate]
	, [t].[ShowAs] = [t].[ShowAs]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[IsChild] = [t].[IsChild]
	, [t].[IsGroupEvent] = [t].[IsGroupEvent]
	, [t].[GroupEventType] = [t].[GroupEventType]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsArchived] = [t].[IsArchived]
	, [t].[RecurrenceActivityId] = [t].[RecurrenceActivityId]
	, [t].[IsRecurrence] = [t].[IsRecurrence]
	, [t].[RecurrenceStartDateTime] = [t].[RecurrenceStartDateTime]
	, [t].[RecurrenceEndDateOnly] = [t].[RecurrenceEndDateOnly]
	, [t].[RecurrenceTimeZoneSidKey] = [t].[RecurrenceTimeZoneSidKey]
	, [t].[RecurrenceType] = [t].[RecurrenceType]
	, [t].[RecurrenceInterval] = [t].[RecurrenceInterval]
	, [t].[RecurrenceDayOfWeekMask] = [t].[RecurrenceDayOfWeekMask]
	, [t].[RecurrenceDayOfMonth] = [t].[RecurrenceDayOfMonth]
	, [t].[RecurrenceInstance] = [t].[RecurrenceInstance]
	, [t].[RecurrenceMonthOfYear] = [t].[RecurrenceMonthOfYear]
	, [t].[ReminderDateTime] = [t].[ReminderDateTime]
	, [t].[IsReminderSet] = [t].[IsReminderSet]
	, [t].[EventSubtype] = [t].[EventSubtype]
	, [t].[IsRecurrence2Exclusion] = [t].[IsRecurrence2Exclusion]
	, [t].[Recurrence2PatternText] = [t].[Recurrence2PatternText]
	, [t].[Recurrence2PatternVersion] = [t].[Recurrence2PatternVersion]
	, [t].[IsRecurrence2] = [t].[IsRecurrence2]
	, [t].[IsRecurrence2Exception] = [t].[IsRecurrence2Exception]
	, [t].[Recurrence2PatternStartDate] = [t].[Recurrence2PatternStartDate]
	, [t].[Recurrence2PatternTimeZone] = [t].[Recurrence2PatternTimeZone]
	, [t].[ServiceAppointmentId] = [t].[ServiceAppointmentId]
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
	, [t].[AcceptedEventInviteeIds] = [t].[AcceptedEventInviteeIds]
	, [t].[DeclinedEventInviteeIds] = [t].[DeclinedEventInviteeIds]
	, [t].[EventWhoIds] = [t].[EventWhoIds]
	, [t].[UndecidedEventInviteeIds] = [t].[UndecidedEventInviteeIds]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [WhoId]
	, [WhatId]
	, [WhoCount]
	, [WhatCount]
	, [Subject]
	, [Location]
	, [IsAllDayEvent]
	, [ActivityDateTime]
	, [ActivityDate]
	, [DurationInMinutes]
	, [StartDateTime]
	, [EndDateTime]
	, [EndDate]
	, [Description]
	, [AccountId]
	, [OwnerId]
	, [CurrencyIsoCode]
	, [Type]
	, [IsPrivate]
	, [ShowAs]
	, [IsDeleted]
	, [IsChild]
	, [IsGroupEvent]
	, [GroupEventType]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [IsArchived]
	, [RecurrenceActivityId]
	, [IsRecurrence]
	, [RecurrenceStartDateTime]
	, [RecurrenceEndDateOnly]
	, [RecurrenceTimeZoneSidKey]
	, [RecurrenceType]
	, [RecurrenceInterval]
	, [RecurrenceDayOfWeekMask]
	, [RecurrenceDayOfMonth]
	, [RecurrenceInstance]
	, [RecurrenceMonthOfYear]
	, [ReminderDateTime]
	, [IsReminderSet]
	, [EventSubtype]
	, [IsRecurrence2Exclusion]
	, [Recurrence2PatternText]
	, [Recurrence2PatternVersion]
	, [IsRecurrence2]
	, [IsRecurrence2Exception]
	, [Recurrence2PatternStartDate]
	, [Recurrence2PatternTimeZone]
	, [ServiceAppointmentId]
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
	, [AcceptedEventInviteeIds]
	, [DeclinedEventInviteeIds]
	, [EventWhoIds]
	, [UndecidedEventInviteeIds]
	)
	VALUES(
	[s].[Id]
	, [s].[WhoId]
	, [s].[WhatId]
	, [s].[WhoCount]
	, [s].[WhatCount]
	, [s].[Subject]
	, [s].[Location]
	, [s].[IsAllDayEvent]
	, [s].[ActivityDateTime]
	, [s].[ActivityDate]
	, [s].[DurationInMinutes]
	, [s].[StartDateTime]
	, [s].[EndDateTime]
	, [s].[EndDate]
	, [s].[Description]
	, [s].[AccountId]
	, [s].[OwnerId]
	, [s].[CurrencyIsoCode]
	, [s].[Type]
	, [s].[IsPrivate]
	, [s].[ShowAs]
	, [s].[IsDeleted]
	, [s].[IsChild]
	, [s].[IsGroupEvent]
	, [s].[GroupEventType]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[IsArchived]
	, [s].[RecurrenceActivityId]
	, [s].[IsRecurrence]
	, [s].[RecurrenceStartDateTime]
	, [s].[RecurrenceEndDateOnly]
	, [s].[RecurrenceTimeZoneSidKey]
	, [s].[RecurrenceType]
	, [s].[RecurrenceInterval]
	, [s].[RecurrenceDayOfWeekMask]
	, [s].[RecurrenceDayOfMonth]
	, [s].[RecurrenceInstance]
	, [s].[RecurrenceMonthOfYear]
	, [s].[ReminderDateTime]
	, [s].[IsReminderSet]
	, [s].[EventSubtype]
	, [s].[IsRecurrence2Exclusion]
	, [s].[Recurrence2PatternText]
	, [s].[Recurrence2PatternVersion]
	, [s].[IsRecurrence2]
	, [s].[IsRecurrence2Exception]
	, [s].[Recurrence2PatternStartDate]
	, [s].[Recurrence2PatternTimeZone]
	, [s].[ServiceAppointmentId]
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
	, [s].[AcceptedEventInviteeIds]
	, [s].[DeclinedEventInviteeIds]
	, [s].[EventWhoIds]
	, [s].[UndecidedEventInviteeIds]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[Event] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO