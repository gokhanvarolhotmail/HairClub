/*
Region
Center
Sales Order Date
Quantity
ItemSKU
ItemSerialNumber (if possible)
SalesCodeID
SalesCodeDescriptionShort
SalesCodeDescription
Entered By (CreateUser)
Price
Discount
Tax
Total Price
*/
CREATE VIEW [vw_SalesOrderItems]
AS
SELECT
    [a].[RegionID]
  , [a].[RegionDescription]
  , [b].[CenterID]
  , [b].[CenterDescription]
  , [lscd].[SalesCodeDepartmentID]
  , [lscd].[SalesCodeDepartmentDescription]
  , [sc].[SalesCodeID]
  , [so].[InvoiceNumber]
  , [so].[OrderDate]
  , [sod].[Quantity]
  , [scd].[ItemSKU]
  , [scd].[PackSKU]
  , [scd].[ItemName]
  , [scd].[ItemDescription]
  , [so].[CreateUser]
  , [sod].[Price]
  , [sod].[Discount]
  , [sod].[TotalTaxCalc]
  , [sod].[ExtendedPriceCalc]
  , [sot].[Amount]
FROM [dbo].[lkpRegion] AS [a]
INNER JOIN [dbo].[cfgCenter] AS [b] ON [a].[RegionID] = [b].[RegionID]
INNER JOIN [dbo].[datSalesOrder] AS [so] ON [so].[CenterID] = [b].[CenterID]
INNER JOIN [dbo].[datSalesOrderDetail] AS [sod] ON [sod].[SalesOrderGUID] = [so].[SalesOrderGUID]
INNER JOIN [dbo].[datSalesOrderTender] AS [sot] ON [sod].[SalesOrderGUID] = [sot].[SalesOrderGUID]
INNER JOIN [dbo].[cfgSalesCode] AS [sc] ON [sc].[SalesCodeID] = [sod].[SalesCodeID]
INNER JOIN [dbo].[lkpSalesCodeType] AS [sct] ON [sct].[SalesCodeTypeID] = [sc].[SalesCodeTypeID]
INNER JOIN [dbo].[cfgSalesCodeDistributor] AS [scd] ON [scd].[SalesCodeID] = [sc].[SalesCodeID]
INNER JOIN [dbo].[lkpSalesCodeDepartment] AS [lscd] ON [lscd].[SalesCodeDepartmentID] = [sc].[SalesCodeDepartmentID]
WHERE [so].[OrderDate] > '1/1/2021' AND [lscd].[SalesCodeDepartmentID] = 3065 ;
GO
