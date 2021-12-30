/* CreateDate: 05/08/2010 09:36:14.180 , ModifyDate: 05/13/2010 13:44:52.960 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactPhone]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactPhone]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactPhone]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimContactPhone]
		--SELECT [ContactPhoneKey], [ContactPhoneSSID]
		--FROM [bi_health].[synHC_DDS_DimContactPhone] WITH (NOLOCK)
		WHERE [ContactPhoneSSID] NOT
		IN (
				SELECT SRC.[contact_phone_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_phone] SRC WITH (NOLOCK)
				)
		AND [ContactPhoneKey] <> -1


END
GO
