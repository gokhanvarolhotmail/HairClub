/* CreateDate: 03/17/2022 15:12:21.810 , ModifyDate: 03/17/2022 15:12:21.810 */
GO
CREATE PROCEDURE [SF].[sp_PromoCode__c_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[PromoCode__c])
RETURN ;

BEGIN TRY
;MERGE [SF].[PromoCode__c] AS [t]
USING [SFStaging].[PromoCode__c] AS [s]
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
	, [t].[Active__c] = [t].[Active__c]
	, [t].[DiscountType__c] = [t].[DiscountType__c]
	, [t].[EndDate__c] = [t].[EndDate__c]
	, [t].[NCCAvailable__c] = [t].[NCCAvailable__c]
	, [t].[PromoCodeDisplay__c] = [t].[PromoCodeDisplay__c]
	, [t].[PromoCodeSort__c] = [t].[PromoCodeSort__c]
	, [t].[StartDate__c] = [t].[StartDate__c]
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
	, [Active__c]
	, [DiscountType__c]
	, [EndDate__c]
	, [NCCAvailable__c]
	, [PromoCodeDisplay__c]
	, [PromoCodeSort__c]
	, [StartDate__c]
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
	, [s].[Active__c]
	, [s].[DiscountType__c]
	, [s].[EndDate__c]
	, [s].[NCCAvailable__c]
	, [s].[PromoCodeDisplay__c]
	, [s].[PromoCodeSort__c]
	, [s].[StartDate__c]
	, [s].[External_Id__c]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[PromoCode__c] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
