/* CreateDate: 05/12/2010 09:39:48.753 , ModifyDate: 05/13/2010 14:02:45.467 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderTender]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderTender]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesOrderTender]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesOrderTender]
		--SELECT [SalesOrderTenderKey], [SalesOrderTenderSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesOrderTender] WITH (NOLOCK)
		WHERE [SalesOrderTenderSSID] NOT
		IN (
				SELECT SRC.SalesOrderTenderGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] SRC WITH (NOLOCK)
				)
		AND [SalesOrderTenderKey] <> -1


END
GO
