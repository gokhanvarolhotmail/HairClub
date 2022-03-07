/* CreateDate: 03/06/2022 17:23:58.203 , ModifyDate: 03/06/2022 17:23:58.203 */
GO
CREATE PROCEDURE [SF].[sp_ServiceTerritory_ZipCode__c_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ServiceTerritory_ZipCode__c])
RETURN ;

BEGIN TRY
;MERGE [SF].[ServiceTerritory_ZipCode__c] AS [t]
USING [SFStaging].[ServiceTerritory_ZipCode__c] AS [s]
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
	, [t].[Zip_Code_Center__c] = [t].[Zip_Code_Center__c]
	, [t].[External_Id__c] = [t].[External_Id__c]
	, [t].[Service_Territory__c] = [t].[Service_Territory__c]
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
	, [Zip_Code_Center__c]
	, [External_Id__c]
	, [Service_Territory__c]
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
	, [s].[Zip_Code_Center__c]
	, [s].[External_Id__c]
	, [s].[Service_Territory__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ServiceTerritory_ZipCode__c] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
