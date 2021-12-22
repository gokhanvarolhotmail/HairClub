/* CreateDate: 05/03/2010 12:17:25.523 , ModifyDate: 09/16/2019 09:33:49.883 */
GO
CREATE PROCEDURE [bi_cms_dds].[EmptyAllTables]
AS

-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

	DELETE FROM bi_cms_dds.FactSalesTransactionTender
	DELETE FROM bi_cms_dds.FactSalesTransaction
	DELETE FROM bi_cms_dds.FactSales
	DELETE FROM bi_cms_dds.DimSalesOrderTender WHERE SalesOrderTenderKey > 0
	DELETE FROM bi_cms_dds.DimSalesOrderDetail WHERE SalesOrderDetailKey > 0
	DELETE FROM bi_cms_dds.DimSalesOrder WHERE SalesOrderKey > 0
	DELETE FROM bi_cms_dds.DimTenderType WHERE TenderTypeKey > 0
	DELETE FROM bi_cms_dds.DimSalesOrderType WHERE SalesOrderTypeKey > 0
	DELETE FROM bi_cms_dds.DimSalesCodeDepartment WHERE SalesCodeDepartmentKey > 0
	DELETE FROM bi_cms_dds.DimSalesCodeDivision WHERE SalesCodeDivisionKey > 0
	DELETE FROM bi_cms_dds.DimSalesCode WHERE SalesCodeKey > 0
	DELETE FROM bi_cms_dds.DimClientMembership WHERE ClientMembershipKey > 0
	DELETE FROM bi_cms_dds.DimMembership WHERE MembershipKey > 0
	DELETE FROM bi_cms_dds.DimEmployee WHERE EmployeeKey > 0
	DELETE FROM bi_cms_dds.DimClient WHERE ClientKey > 0
	DELETE FROM bi_cms_dds.DimAccumulator WHERE AccumulatorKey > 0
	DELETE FROM bi_cms_dds.DimAccumulatorActionType WHERE AccumulatorActionTypeKey > 0


	DBCC CHECKIDENT ("bi_cms_dds.DimAccumulatorActionType", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimAccumulator", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimClient", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimEmployee", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimMembership", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimClientMembership", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesCode", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesCodeDepartment", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesCodeDivision", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesOrder", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesOrderDetail", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesOrderTender", RESEED, 1)
	DBCC CHECKIDENT ("bi_cms_dds.DimSalesOrderType", RESEED, 1)


END
GO
