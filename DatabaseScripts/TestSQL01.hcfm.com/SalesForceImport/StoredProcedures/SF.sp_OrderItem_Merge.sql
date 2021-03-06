/* CreateDate: 03/04/2022 08:19:53.697 , ModifyDate: 03/04/2022 08:19:53.697 */
GO
CREATE PROCEDURE [SF].[sp_OrderItem_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[OrderItem])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[OrderItem] AS [t]
USING [SFStaging].[OrderItem] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[Product2Id] = [t].[Product2Id]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[OrderId] = [t].[OrderId]
	, [t].[PricebookEntryId] = [t].[PricebookEntryId]
	, [t].[OriginalOrderItemId] = [t].[OriginalOrderItemId]
	, [t].[AvailableQuantity] = [t].[AvailableQuantity]
	, [t].[Quantity] = [t].[Quantity]
	, [t].[CurrencyIsoCode] = [t].[CurrencyIsoCode]
	, [t].[UnitPrice] = [t].[UnitPrice]
	, [t].[ListPrice] = [t].[ListPrice]
	, [t].[TotalPrice] = [t].[TotalPrice]
	, [t].[ServiceDate] = [t].[ServiceDate]
	, [t].[EndDate] = [t].[EndDate]
	, [t].[Description] = [t].[Description]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[OrderItemNumber] = [t].[OrderItemNumber]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [Product2Id]
	, [IsDeleted]
	, [OrderId]
	, [PricebookEntryId]
	, [OriginalOrderItemId]
	, [AvailableQuantity]
	, [Quantity]
	, [CurrencyIsoCode]
	, [UnitPrice]
	, [ListPrice]
	, [TotalPrice]
	, [ServiceDate]
	, [EndDate]
	, [Description]
	, [CreatedDate]
	, [CreatedById]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [OrderItemNumber]
	)
	VALUES(
	[s].[Id]
	, [s].[Product2Id]
	, [s].[IsDeleted]
	, [s].[OrderId]
	, [s].[PricebookEntryId]
	, [s].[OriginalOrderItemId]
	, [s].[AvailableQuantity]
	, [s].[Quantity]
	, [s].[CurrencyIsoCode]
	, [s].[UnitPrice]
	, [s].[ListPrice]
	, [s].[TotalPrice]
	, [s].[ServiceDate]
	, [s].[EndDate]
	, [s].[Description]
	, [s].[CreatedDate]
	, [s].[CreatedById]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[OrderItemNumber]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[OrderItem] ;

COMMIT ;
GO
