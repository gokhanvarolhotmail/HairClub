/* CreateDate: 03/17/2022 15:12:16.680 , ModifyDate: 03/17/2022 15:12:16.680 */
GO
CREATE PROCEDURE [SF].[sp_ServiceTerritoryWorkType_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceTerritoryWorkType])
RETURN ;

BEGIN TRY
;MERGE [SF].[ServiceTerritoryWorkType] AS [t]
USING [SFStaging].[ServiceTerritoryWorkType] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[WorkTypeId] = [t].[WorkTypeId]
	, [t].[ServiceTerritoryId] = [t].[ServiceTerritoryId]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[Work_Type_Appointment_Type__c] = [t].[Work_Type_Appointment_Type__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
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
	, [WorkTypeId]
	, [ServiceTerritoryId]
	, [External_Id__c]
	, [Work_Type_Appointment_Type__c]
	)
	VALUES(
	[s].[Id]
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
	, [s].[WorkTypeId]
	, [s].[ServiceTerritoryId]
	, [s].[External_Id__c]
	, [s].[Work_Type_Appointment_Type__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceTerritoryWorkType] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
