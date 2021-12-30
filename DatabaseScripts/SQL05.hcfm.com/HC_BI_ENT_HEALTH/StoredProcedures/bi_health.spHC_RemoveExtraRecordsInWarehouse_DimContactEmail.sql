/* CreateDate: 05/08/2010 09:35:08.010 , ModifyDate: 05/13/2010 13:44:01.660 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactEmail]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactEmail]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactEmail]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimContactEmail]
		--SELECT [ContactEmailKey], [ContactEmailSSID]
		--FROM [bi_health].[synHC_DDS_DimContactEmail] WITH (NOLOCK)
		WHERE [ContactEmailSSID] NOT
		IN (
				SELECT SRC.[contact_email_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_email] SRC WITH (NOLOCK)
				)
		AND [ContactEmailKey] <> -1


END
GO
