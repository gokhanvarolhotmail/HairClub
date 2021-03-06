DECLARE
    @StartDate DATETIME = '20220201'
  , @EndDate   DATETIME = CAST(GETDATE() AS DATE)
  , @CenterID  INT      = 292 ;

SELECT
    [ia].[CenterID]
  , [ia].[InventoryAdjustmentTypeID]
  , [ia].[InventoryAdjustmentDate]
  , [ia].[Note]
  , [ia].[CreateDate]
  , [ia].[CreateUser]
  , [ctr].[RegionID]
  , [ctr].[CenterDescription]
  , [ctr].[CenterTypeID]
  , [iat].[InventoryAdjustmentTypeID]
  , [iat].[InventoryAdjustmentTypeSortOrder]
  , [iat].[InventoryAdjustmentTypeDescription]
  , [iat].[InventoryAdjustmentTypeDescriptionShort]
  , [iat].[IsDistributorAdjustment]
  , [iat].[IsSerializedAdjustmentAllowed]
  , [iat].[IsActive]
  , [iat].[CreateDate]
  , [iad].[InventoryAdjustmentDetailID]
  , [iad].[SalesCodeID]
  , [iat].[IsNegativeAdjustment]
  , [iad].[QuantityAdjustment]
  , CASE WHEN [iat].[IsNegativeAdjustment] = 1 THEN -1 * [iad].[QuantityAdjustment] ELSE [iad].[QuantityAdjustment] END AS [ActualQuantityAdjustment]
  , [iad].[CreateDate]
  , [sc].[SalesCodeID]
  , [sc].[SalesCodeSortOrder]
  , [sc].[SalesCodeDescription]
  , [sc].[SalesCodeDescriptionShort]
  , [sc].[SalesCodeTypeID]
  , [sc].[SalesCodeDepartmentID]
  , [sc].[VendorID]
  , [sc].[CreateDate]
  , [sc].[PackSKU]
  , [e].[FirstName]
  , [e].[LastName]
  , [e].[EmployeeInitials]
FROM [dbo].[datInventoryAdjustment] AS [ia]
INNER JOIN [dbo].[cfgCenter] AS [ctr] ON [ctr].[CenterID] = [ia].[CenterID]
INNER JOIN [dbo].[lkpInventoryAdjustmentType] AS [iat] ON [iat].[InventoryAdjustmentTypeID] = [ia].[InventoryAdjustmentTypeID]
INNER JOIN [dbo].[datInventoryAdjustmentDetail] AS [iad] ON [iad].[InventoryAdjustmentID] = [ia].[InventoryAdjustmentID]
INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [iad].[SalesCodeID]
INNER JOIN [dbo].[datEmployee] AS [e] ON [e].[EmployeeGUID] = [ia].[EmployeeGUID]
WHERE [ia].[InventoryAdjustmentDate] >= @StartDate AND [ia].[InventoryAdjustmentDate] < @EndDate AND [ctr].[CenterID] = @CenterID
OPTION( RECOMPILE ) ;
GO
