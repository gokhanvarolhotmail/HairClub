/* CreateDate: 03/06/2022 17:23:58.630 , ModifyDate: 03/06/2022 17:23:58.630 */
GO
CREATE PROCEDURE [SF].[sp_WorkType_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[WorkType])
RETURN ;

BEGIN TRY
;MERGE [SF].[WorkType] AS [t]
USING [SFStaging].[WorkType] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OwnerId] = [t].[OwnerId]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[Description] = [t].[Description]
	, [t].[EstimatedDuration] = [t].[EstimatedDuration]
	, [t].[DurationType] = [t].[DurationType]
	, [t].[DurationInMinutes] = [t].[DurationInMinutes]
	, [t].[TimeframeStart] = [t].[TimeframeStart]
	, [t].[TimeframeEnd] = [t].[TimeframeEnd]
	, [t].[BlockTimeBeforeAppointment] = [t].[BlockTimeBeforeAppointment]
	, [t].[BlockTimeAfterAppointment] = [t].[BlockTimeAfterAppointment]
	, [t].[DefaultAppointmentType] = [t].[DefaultAppointmentType]
	, [t].[TimeFrameStartUnit] = [t].[TimeFrameStartUnit]
	, [t].[TimeFrameEndUnit] = [t].[TimeFrameEndUnit]
	, [t].[BlockTimeBeforeUnit] = [t].[BlockTimeBeforeUnit]
	, [t].[BlockTimeAfterUnit] = [t].[BlockTimeAfterUnit]
	, [t].[OperatingHoursId] = [t].[OperatingHoursId]
	, [t].[External_Id__c] = [t].[External_Id__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OwnerId]
	, [IsDeleted]
	, [Name]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [Description]
	, [EstimatedDuration]
	, [DurationType]
	, [DurationInMinutes]
	, [TimeframeStart]
	, [TimeframeEnd]
	, [BlockTimeBeforeAppointment]
	, [BlockTimeAfterAppointment]
	, [DefaultAppointmentType]
	, [TimeFrameStartUnit]
	, [TimeFrameEndUnit]
	, [BlockTimeBeforeUnit]
	, [BlockTimeAfterUnit]
	, [OperatingHoursId]
	, [External_Id__c]
	)
	VALUES(
	[s].[Id]
	, [s].[OwnerId]
	, [s].[IsDeleted]
	, [s].[Name]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[Description]
	, [s].[EstimatedDuration]
	, [s].[DurationType]
	, [s].[DurationInMinutes]
	, [s].[TimeframeStart]
	, [s].[TimeframeEnd]
	, [s].[BlockTimeBeforeAppointment]
	, [s].[BlockTimeAfterAppointment]
	, [s].[DefaultAppointmentType]
	, [s].[TimeFrameStartUnit]
	, [s].[TimeFrameEndUnit]
	, [s].[BlockTimeBeforeUnit]
	, [s].[BlockTimeAfterUnit]
	, [s].[OperatingHoursId]
	, [s].[External_Id__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[WorkType] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
