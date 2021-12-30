/* CreateDate: 05/12/2010 09:38:36.687 , ModifyDate: 05/13/2010 14:01:13.317 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrder]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrder]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrder]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesOrder]
		--SELECT [SalesOrderKey], [SalesOrderSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesOrder] WITH (NOLOCK)
		WHERE [SalesOrderSSID] NOT
		IN (
				SELECT SRC.SalesOrderGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
				)
		AND [SalesOrderKey] <> -1


END
GO
