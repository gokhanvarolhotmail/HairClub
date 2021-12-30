/* CreateDate: 05/12/2010 09:42:04.753 , ModifyDate: 05/13/2010 14:04:22.313 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimTenderType]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimTenderType]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimTenderType]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimTenderType]
		--SELECT [TenderTypeKey], [TenderTypeSSID]
		--FROM [bi_health].[synHC_DDS_DimTenderType] WITH (NOLOCK)
		WHERE [TenderTypeSSID] NOT
		IN (
				SELECT SRC.TenderTypeID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpTenderType] SRC WITH (NOLOCK)
				)
		AND [TenderTypeKey] <> -1


END
GO
