/* CreateDate: 05/12/2010 09:55:28.830 , ModifyDate: 05/13/2010 13:52:28.060 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSales]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSales]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSales]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactSales]
		WHERE  SalesOrderKey IN (
				SELECT DW.[SalesOrderKey]
				FROM [bi_health].[synHC_DDS_FactSales] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimSalesOrder] dso WITH (NOLOCK)
				ON dso.SalesOrderKey = DW.[SalesOrderKey]
				WHERE dso.[SalesOrderSSID] NOT
				IN (
						SELECT SRC.SalesOrderGUID
						FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
					)
				)

END
GO
