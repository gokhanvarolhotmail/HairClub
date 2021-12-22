CREATE VIEW [dbo].[vwCfgSalesCode]
AS
SELECT     sc.SalesCodeID, sc.SalesCodeSortOrder, sc.SalesCodeDescription, sc.SalesCodeDescriptionShort, sct.SalesCodeTypeDescription,
      scd.SalesCodeDepartmentDescription, v.VendorDescription, sc.Barcode, sc.PriceDefault, sc.GLNumber, sc.ServiceDuration, sc.CanScheduleFlag,
      sc.FactoryOrderFlag, sc.IsRefundableFlag, sc.InventoryFlag, sc.TechnicalProfileFlag, sc.AdjustContractPaidAmountFlag, sc.IsPriceAdjustableFlag,
      sc.IsDiscountableFlag, sc.IsActiveFlag, sc.CreateDate, sc.CreateUser, sc.LastUpdate, sc.LastUpdateUser, sc.UpdateStamp
FROM cfgSalesCode sc
      LEFT JOIN lkpSalesCodeType sct ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
      LEFT JOIN lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
      LEFT JOIN cfgVendor v ON v.VendorID = sc.VendorID
