/* CreateDate: 05/08/2010 09:21:19.713 , ModifyDate: 05/13/2010 13:39:40.507 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityResult]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityResult]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityResult]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimActivityResult]
		--SELECT [ActivityResultKey], [ActivityResultSSID]
		--FROM [bi_health].[synHC_DDS_DimActivityResult] WITH (NOLOCK)
		WHERE [ActivityResultSSID] NOT
		IN (
				SELECT SRC.[contact_completion_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_contact_completion] SRC WITH (NOLOCK)
				)
		AND [ActivityResultKey] <> -1


END
GO
