/* CreateDate: 05/08/2010 09:34:04.090 , ModifyDate: 05/13/2010 13:43:06.800 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactAddress]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactAddress]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContactAddress]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimContactAddress]
		--SELECT [ContactAddressKey], [ContactAddressSSID]
		--FROM [bi_health].[synHC_DDS_DimContactAddress] WITH (NOLOCK)
		WHERE [ContactAddressSSID] NOT
		IN (
				SELECT SRC.[contact_address_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_address] SRC WITH (NOLOCK)
				)
		AND [ContactAddressKey] <> -1


END
GO
