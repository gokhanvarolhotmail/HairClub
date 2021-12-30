/* CreateDate: 05/08/2010 09:31:45.017 , ModifyDate: 05/13/2010 17:21:30.007 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContact]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContact]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimContact]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimContact]
		--SELECT [ContactKey], [ContactSSID]
		--FROM [bi_health].[synHC_DDS_DimContact] WITH (NOLOCK)
		WHERE [ContactSSID] NOT
		IN (
				SELECT SRC.[contact_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact] SRC WITH (NOLOCK)
				)
		AND [ContactKey] <> -1


END
GO
