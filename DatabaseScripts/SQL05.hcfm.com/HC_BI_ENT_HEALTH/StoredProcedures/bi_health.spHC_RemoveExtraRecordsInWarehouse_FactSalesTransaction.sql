/* CreateDate: 05/12/2010 09:57:21.263 , ModifyDate: 05/17/2010 13:49:16.143 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransaction]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransaction]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactSalesTransaction]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]
		WHERE  SalesOrderDetailKey IN (
				SELECT DW.[SalesOrderDetailKey]
				FROM [bi_health].[synHC_DDS_FactSalesTransaction] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimSalesOrderDetail] dso WITH (NOLOCK)
				ON dso.SalesOrderDetailKey = DW.[SalesOrderDetailKey]
				WHERE dso.[SalesOrderDetailSSID] NOT
				IN (
						SELECT SRC.SalesOrderDetailGUID
						FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC WITH (NOLOCK)
						LEFT OUTER JOIN [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRCD  WITH (NOLOCK)
							ON SRC.SalesOrderGUID = SRCD.SalesOrderGUID
						WHERE (CAST(SRCD.IsClosedFlag AS INT) = 1 AND  CAST(SRCD.IsVoidedFlag AS INT) = 0)
					)
				)

END
GO
