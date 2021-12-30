/* CreateDate: 05/12/2010 10:06:03.530 , ModifyDate: 05/13/2010 13:51:07.023 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactLead]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactLead]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactLead]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactLead]
		WHERE  ContactKey IN (
				SELECT DW.[ContactKey]
				FROM [bi_health].[synHC_DDS_FactLead] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimContact] da WITH (NOLOCK)
				ON da.ContactKey = DW.[ContactKey]
				WHERE da.[ContactSSID] NOT
				IN (
						SELECT SRC.contact_id
						FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact] SRC WITH (NOLOCK)
					)
				)

END
GO
