/* CreateDate: 05/08/2010 09:25:55.483 , ModifyDate: 05/13/2010 13:38:54.610 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActionCode]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActionCode]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActionCode]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimActionCode]
		--SELECT [ActionCodeKey], [ActionCodeSSID]
		--FROM [bi_health].[synHC_DDS_DimActionCode] WITH (NOLOCK)
		WHERE [ActionCodeSSID] NOT
		IN (
				SELECT SRC.action_code
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_action] SRC WITH (NOLOCK)
				)
		AND [ActionCodeKey] <> -1


END
GO
