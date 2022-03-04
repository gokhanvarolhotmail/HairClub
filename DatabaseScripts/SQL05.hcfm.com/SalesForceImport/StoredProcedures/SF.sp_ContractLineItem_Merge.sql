/* CreateDate: 03/04/2022 08:19:53.217 , ModifyDate: 03/04/2022 08:19:53.217 */
GO
CREATE PROCEDURE [SF].[sp_ContractLineItem_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[ContractLineItem])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[ContractLineItem] AS [t]
USING [SFStaging].[ContractLineItem] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[IsDeleted] = [t].[IsDeleted]
	, [t].[LineItemNumber] = [t].[LineItemNumber]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[LastViewedDate] = [t].[LastViewedDate]
	, [t].[LastReferencedDate] = [t].[LastReferencedDate]
	, [t].[ServiceContractId] = [t].[ServiceContractId]
	, [t].[Product2Id] = [t].[Product2Id]
	, [t].[AssetId] = [t].[AssetId]
	, [t].[StartDate] = [t].[StartDate]
	, [t].[EndDate] = [t].[EndDate]
	, [t].[Description] = [t].[Description]
	, [t].[PricebookEntryId] = [t].[PricebookEntryId]
	, [t].[Quantity] = [t].[Quantity]
	, [t].[UnitPrice] = [t].[UnitPrice]
	, [t].[Discount] = [t].[Discount]
	, [t].[ListPrice] = [t].[ListPrice]
	, [t].[Subtotal] = [t].[Subtotal]
	, [t].[TotalPrice] = [t].[TotalPrice]
	, [t].[Status] = [t].[Status]
	, [t].[ParentContractLineItemId] = [t].[ParentContractLineItemId]
	, [t].[RootContractLineItemId] = [t].[RootContractLineItemId]
	, [t].[LocationId] = [t].[LocationId]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [IsDeleted]
	, [LineItemNumber]
	, [CurrencyIsoCode]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [LastViewedDate]
	, [LastReferencedDate]
	, [ServiceContractId]
	, [Product2Id]
	, [AssetId]
	, [StartDate]
	, [EndDate]
	, [Description]
	, [PricebookEntryId]
	, [Quantity]
	, [UnitPrice]
	, [Discount]
	, [ListPrice]
	, [Subtotal]
	, [TotalPrice]
	, [Status]
	, [ParentContractLineItemId]
	, [RootContractLineItemId]
	, [LocationId]
	)
	VALUES(
	[s].[Id]
	, [s].[IsDeleted]
	, [s].[LineItemNumber]
	, [s].[CurrencyIsoCode]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[LastViewedDate]
	, [s].[LastReferencedDate]
	, [s].[ServiceContractId]
	, [s].[Product2Id]
	, [s].[AssetId]
	, [s].[StartDate]
	, [s].[EndDate]
	, [s].[Description]
	, [s].[PricebookEntryId]
	, [s].[Quantity]
	, [s].[UnitPrice]
	, [s].[Discount]
	, [s].[ListPrice]
	, [s].[Subtotal]
	, [s].[TotalPrice]
	, [s].[Status]
	, [s].[ParentContractLineItemId]
	, [s].[RootContractLineItemId]
	, [s].[LocationId]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[ContractLineItem] ;

COMMIT ;
GO
