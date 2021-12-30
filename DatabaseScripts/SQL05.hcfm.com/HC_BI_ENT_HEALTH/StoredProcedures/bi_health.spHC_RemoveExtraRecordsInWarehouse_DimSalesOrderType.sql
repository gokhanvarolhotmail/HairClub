/* CreateDate: 05/12/2010 09:42:40.230 , ModifyDate: 05/13/2010 14:03:36.867 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderType]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderType]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderType]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesOrderType]
		--SELECT [SalesOrderTypeKey], [SalesOrderTypeSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesOrderType] WITH (NOLOCK)
		WHERE [SalesOrderTypeSSID] NOT
		IN (
				SELECT SRC.SalesOrderTypeID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesOrderType] SRC WITH (NOLOCK)
				)
		AND [SalesOrderTypeKey] <> -1


END
GO
