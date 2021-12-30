/* CreateDate: 05/12/2010 09:36:35.707 , ModifyDate: 05/13/2010 13:17:04.940 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClient]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClient]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClient]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimClient]
		--SELECT [ClientKey], [ClientSSID]
		--FROM [bi_health].[synHC_DDS_DimClient] WITH (NOLOCK)
		WHERE [ClientSSID] NOT
		IN (
				SELECT SRC.ClientGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datClient] SRC WITH (NOLOCK)
				)
		AND [ClientKey] <> -1


END
GO
