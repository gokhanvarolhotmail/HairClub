/* CreateDate: 05/03/2010 12:19:47.323 , ModifyDate: 05/03/2010 12:19:47.323 */
GO
CREATE PROCEDURE [bi_cms_stage].[EmptyAllTables]
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

	DELETE FROM bi_cms_stage.FactSalesTransactionTender
	DELETE FROM bi_cms_stage.FactSalesTransaction
	DELETE FROM bi_cms_stage.FactSales
	DELETE FROM bi_cms_stage.DimTenderType
	DELETE FROM bi_cms_stage.DimSalesOrderType
	DELETE FROM bi_cms_stage.DimSalesOrderTender
	DELETE FROM bi_cms_stage.DimSalesOrderDetail
	DELETE FROM bi_cms_stage.DimSalesOrder
	DELETE FROM bi_cms_stage.DimSalesCodeDivision
	DELETE FROM bi_cms_stage.DimSalesCodeDepartment
	DELETE FROM bi_cms_stage.DimSalesCode
	DELETE FROM bi_cms_stage.DimClientMembership
	DELETE FROM bi_cms_stage.DimMembership
	DELETE FROM bi_cms_stage.DimEmployee
	DELETE FROM bi_cms_stage.DimClient
	DELETE FROM bi_cms_stage.DimAccumulator
	DELETE FROM bi_cms_stage.DimAccumulatorActionType

	UPDATE [bief_stage].[_DataFlow]
	   SET [LSET] = '2009-01-01 12:00:00:000AM'
		  ,[CET] = '2009-01-01 12:00:00:000AM'

END
GO
