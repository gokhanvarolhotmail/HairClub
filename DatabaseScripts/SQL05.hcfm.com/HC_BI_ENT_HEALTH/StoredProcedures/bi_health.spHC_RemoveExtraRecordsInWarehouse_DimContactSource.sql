/* CreateDate: 05/08/2010 09:37:05.660 , ModifyDate: 05/13/2010 13:45:49.750 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactSource]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactSource]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactSource]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimContactSource]
		--SELECT [ContactSourceKey], [ContactSourceSSID]
		--FROM [bi_health].[synHC_DDS_DimContactSource] WITH (NOLOCK)
		WHERE [ContactSourceSSID] NOT
		IN (
				SELECT SRC.[contact_source_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_source] SRC WITH (NOLOCK)
				)
		AND [ContactSourceKey] <> -1


END
GO
