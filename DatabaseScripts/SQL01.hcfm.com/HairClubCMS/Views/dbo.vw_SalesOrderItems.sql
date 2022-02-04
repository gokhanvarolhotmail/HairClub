/* CreateDate: 01/27/2022 12:39:16.137 , ModifyDate: 01/27/2022 12:53:30.457 */
GO
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
CREATE view vw_SalesOrderItems as
select
a.RegionID,
a.RegionDescription,
b.CenterID,
b.CenterDescription,
lscd.SalesCodeDepartmentID,
lscd.SalesCodeDepartmentDescription,
sc.salescodeid,
so.invoicenumber,
so.OrderDate,
sod.quantity,
scd.itemsku,
scd.packsku,
scd.itemname,
scd.itemdescription,
so.createuser,
sod.price,
sod.discount,
sod.totaltaxcalc,
sod.extendedpricecalc,
sot.Amount
from dbo.lkpRegion a join dbo.cfgcenter b on a.regionid = b.regionid
join dbo.datsalesorder so on so.centerid = b.centerid
join dbo.datsalesorderdetail sod on sod.salesorderguid = so.salesorderguid
join dbo.datsalesordertender sot on sod.SalesOrderGUID = sot.SalesOrderGUID
join dbo.cfgsalescode sc on sc.salescodeid = sod.salescodeid
join dbo.lkpsalescodetype sct on sct.salescodetypeid = sc.salescodetypeid
join dbo.cfgsalescodedistributor scd on scd.salescodeid = sc.salescodeid
join dbo.lkpSalesCodeDepartment lscd on lscd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
where so.orderdate > '1/1/2021'and lscd.SalesCodeDepartmentID = 3065
GO
