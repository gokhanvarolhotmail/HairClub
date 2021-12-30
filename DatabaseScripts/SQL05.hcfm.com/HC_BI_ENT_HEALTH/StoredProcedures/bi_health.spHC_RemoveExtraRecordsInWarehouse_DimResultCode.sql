/* CreateDate: 05/08/2010 09:27:53.373 , ModifyDate: 05/13/2010 13:47:27.383 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimResultCode]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimResultCode]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimResultCode]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimResultCode]
		--SELECT [ResultCodeKey], [ResultCodeSSID]
		--FROM [bi_health].[synHC_DDS_DimResultCode] WITH (NOLOCK)
		WHERE [ResultCodeSSID] NOT
		IN (
				SELECT SRC.[result_code]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_result] SRC WITH (NOLOCK)
				)
		AND [ResultCodeKey] <> -1


END
GO
