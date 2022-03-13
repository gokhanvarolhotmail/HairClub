/* CreateDate: 03/06/2022 17:23:57.437 , ModifyDate: 03/06/2022 17:23:57.437 */
GO
CREATE PROCEDURE [SF].[sp_OpportunityLineItem_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[OpportunityLineItem])
RETURN ;

BEGIN TRY
;MERGE [SF].[OpportunityLineItem] AS [t]
USING [SFStaging].[OpportunityLineItem] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[OpportunityId] = [t].[OpportunityId]
	, [t].[SortOrder] = [t].[SortOrder]
	, [t].[PricebookEntryId] = [t].[PricebookEntryId]
	, [t].[Product2Id] = [t].[Product2Id]
	, [t].[ProductCode] = [t].[ProductCode]
	, [t].[Name] = [t].[Name]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[Quantity] = [t].[Quantity]
	, [t].[TotalPrice] = [t].[TotalPrice]
	, [t].[UnitPrice] = [t].[UnitPrice]
	, [t].[ListPrice] = [t].[ListPrice]
	, [t].[ServiceDate] = [t].[ServiceDate]
	, [t].[HasRevenueSchedule] = [t].[HasRevenueSchedule]
	, [t].[HasQuantitySchedule] = [t].[HasQuantitySchedule]
	, [t].[Description] = [t].[Description]
	, [t].[HasSchedule] = [t].[HasSchedule]
	, [t].[CanUseQuantitySchedule] = [t].[CanUseQuantitySchedule]
	, [t].[CanUseRevenueSchedule] = [t].[CanUseRevenueSchedule]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [OpportunityId]
	, [SortOrder]
	, [PricebookEntryId]
	, [Product2Id]
	, [ProductCode]
	, [Name]
	, [CurrencyIsoCode]
	, [Quantity]
	, [TotalPrice]
	, [UnitPrice]
	, [ListPrice]
	, [ServiceDate]
	, [HasRevenueSchedule]
	, [HasQuantitySchedule]
	, [Description]
	, [HasSchedule]
	, [CanUseQuantitySchedule]
	, [CanUseRevenueSchedule]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [IsDeleted]
	, [LastViewedDate]
	, [LastReferencedDate]
	)
	VALUES(
	[s].[Id]
	, [s].[OpportunityId]
	, [s].[SortOrder]
	, [s].[PricebookEntryId]
	, [s].[Product2Id]
	, [s].[ProductCode]
	, [s].[Name]
	, [s].[CurrencyIsoCode]
	, [s].[Quantity]
	, [s].[TotalPrice]
	, [s].[UnitPrice]
	, [s].[ListPrice]
	, [s].[ServiceDate]
	, [s].[HasRevenueSchedule]
	, [s].[HasQuantitySchedule]
	, [s].[Description]
	, [s].[HasSchedule]
	, [s].[CanUseQuantitySchedule]
	, [s].[CanUseRevenueSchedule]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[IsDeleted]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[OpportunityLineItem] ;

END TRY
BEGIN CATCH
	THROW ;
END CATCH
GO
