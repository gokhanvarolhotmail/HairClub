/* CreateDate: 05/12/2010 09:44:56.817 , ModifyDate: 05/13/2010 13:58:44.917 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCode]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCode]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCode]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesCode]
		--SELECT [SalesCodeKey], [SalesCodeSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesCode] WITH (NOLOCK)
		WHERE [SalesCodeSSID] NOT
		IN (
				SELECT SRC.SalesCodeID
				FROM [bi_health].[synHC_SRC_TBL_CMS_cfgSalesCode] SRC WITH (NOLOCK)
				)
		AND [SalesCodeKey] <> -1


END
GO
