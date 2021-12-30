/* CreateDate: 05/08/2010 09:24:15.327 , ModifyDate: 05/13/2010 13:39:10.330 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivity]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivity]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivity]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimActivity]
		--SELECT [ActivityKey], [ActivitySSID]
		--FROM [bi_health].[synHC_DDS_DimActivity] WITH (NOLOCK)
		WHERE [ActivitySSID] NOT
		IN (
				SELECT SRC.[activity_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
				)
		AND [ActivityKey] <> -1


END
GO
