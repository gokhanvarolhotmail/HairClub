/* CreateDate: 03/06/2022 17:23:58.680 , ModifyDate: 03/06/2022 17:23:58.680 */
GO
CREATE PROCEDURE [SF].[sp_WorkTypeGroup_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[WorkTypeGroup])
RETURN ;

BEGIN TRY
;MERGE [SF].[WorkTypeGroup] AS [t]
USING [SFStaging].[WorkTypeGroup] AS [s]
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
	, [t].[GroupType] = [t].[GroupType]
	, [t].[IsActive] = [t].[IsActive]
	, [t].[AdditionalInformation] = [t].[AdditionalInformation]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[Language__c] = [t].[Language__c]
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
	, [GroupType]
	, [IsActive]
	, [AdditionalInformation]
	, [External_Id__c]
	, [Language__c]
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
	, [s].[GroupType]
	, [s].[IsActive]
	, [s].[AdditionalInformation]
	, [s].[External_Id__c]
	, [s].[Language__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[WorkTypeGroup] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
