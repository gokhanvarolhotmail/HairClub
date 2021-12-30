/* CreateDate: 05/12/2010 09:39:18.120 , ModifyDate: 05/13/2010 14:01:59.160 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderDetail]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderDetail]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderDetail]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesOrderDetail]
		--SELECT [SalesOrderDetailKey], [SalesOrderDetailSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] WITH (NOLOCK)
		WHERE [SalesOrderDetailSSID] NOT
		IN (
				SELECT SRC.SalesOrderDetailGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC WITH (NOLOCK)
				)
		AND [SalesOrderDetailKey] <> -1


END
GO
