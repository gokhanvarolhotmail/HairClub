/* CreateDate: 03/17/2022 15:12:20.920 , ModifyDate: 03/17/2022 15:12:20.920 */
GO
CREATE PROCEDURE [SF].[sp_AssignedResource_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[AssignedResource])
RETURN ;

BEGIN TRY
;MERGE [SF].[AssignedResource] AS [t]
USING [SFStaging].[AssignedResource] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[AssignedResourceNumber] = [t].[AssignedResourceNumber]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[ServiceAppointmentId] = [t].[ServiceAppointmentId]
	, [t].[ServiceResourceId] = [t].[ServiceResourceId]
	, [t].[IsRequiredResource] = [t].[IsRequiredResource]
	, [t].[Role] = [t].[Role]
	, [t].[EventId] = [t].[EventId]
	, [t].[ServiceResourceId__c] = [t].[ServiceResourceId__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [AssignedResourceNumber]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [ServiceAppointmentId]
	, [ServiceResourceId]
	, [IsRequiredResource]
	, [Role]
	, [EventId]
	, [ServiceResourceId__c]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[AssignedResourceNumber]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[ServiceAppointmentId]
	, [s].[ServiceResourceId]
	, [s].[IsRequiredResource]
	, [s].[Role]
	, [s].[EventId]
	, [s].[ServiceResourceId__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[AssignedResource] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
