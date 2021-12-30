/* CreateDate: 05/12/2010 09:58:29.870 , ModifyDate: 05/13/2010 13:54:42.450 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransactionTender]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransactionTender]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransactionTender]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]
		WHERE  SalesOrderTenderKey IN (
				SELECT DW.[SalesOrderTenderKey]
				FROM [bi_health].[synHC_DDS_FactSalesTransactionTender] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimSalesOrderTender] dso WITH (NOLOCK)
				ON dso.SalesOrderTenderKey = DW.[SalesOrderTenderKey]
				WHERE dso.[SalesOrderTenderSSID] NOT
				IN (
						SELECT SRC.SalesOrderTenderGUID
						FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] SRC WITH (NOLOCK)
					)
				)

END
GO
