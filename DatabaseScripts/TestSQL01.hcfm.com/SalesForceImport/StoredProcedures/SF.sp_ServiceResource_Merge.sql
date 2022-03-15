/* CreateDate: 03/04/2022 08:19:53.960 , ModifyDate: 03/04/2022 08:19:53.960 */
GO
CREATE PROCEDURE [SF].[sp_ServiceResource_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceResource])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[ServiceResource] AS [t]
USING [SFStaging].[ServiceResource] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OwnerId] = [t].[OwnerId]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[RelatedRecordId] = [t].[RelatedRecordId]
	, [t].[ResourceType] = [t].[ResourceType]
	, [t].[Description] = [t].[Description]
	, [t].[IsActive] = [t].[IsActive]
	, [t].[LocationId] = [t].[LocationId]
	, [t].[AccountId] = [t].[AccountId]
	, [t].[External_Id__c] = [t].[External_Id__c]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OwnerId]
	, [Name]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [RelatedRecordId]
	, [ResourceType]
	, [Description]
	, [IsActive]
	, [LocationId]
	, [AccountId]
	, [External_Id__c]
	)
	VALUES(
	[s].[Id]
	, [s].[OwnerId]
	, [s].[Name]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[RelatedRecordId]
	, [s].[ResourceType]
	, [s].[Description]
	, [s].[IsActive]
	, [s].[LocationId]
	, [s].[AccountId]
	, [s].[External_Id__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceResource] ;

COMMIT ;
GO
