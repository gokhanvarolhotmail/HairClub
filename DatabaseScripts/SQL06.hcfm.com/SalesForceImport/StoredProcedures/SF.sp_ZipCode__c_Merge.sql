/* CreateDate: 03/06/2022 17:23:58.813 , ModifyDate: 03/06/2022 17:23:58.813 */
GO
CREATE PROCEDURE [SF].[sp_ZipCode__c_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ZipCode__c])
RETURN ;

BEGIN TRY
;MERGE [SF].[ZipCode__c] AS [t]
USING [SFStaging].[ZipCode__c] AS [s]
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
	, [t].[LastActivityDate] = [t].[LastActivityDate]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
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
	, [LastActivityDate]
	, [LastViewedDate]
	, [LastReferencedDate]
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
	, [s].[LastActivityDate]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[External_Id__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ZipCode__c] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
