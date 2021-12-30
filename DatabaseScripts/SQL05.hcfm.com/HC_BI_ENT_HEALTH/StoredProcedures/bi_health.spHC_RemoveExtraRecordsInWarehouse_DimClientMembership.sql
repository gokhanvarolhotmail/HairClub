/* CreateDate: 05/12/2010 09:46:01.790 , ModifyDate: 05/13/2010 13:40:51.857 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClientMembership]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClientMembership]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimClientMembership]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimClientMembership]
		--SELECT [ClientMembershipKey], [ClientMembershipSSID]
		--FROM [bi_health].[synHC_DDS_DimClientMembership]  WITH (NOLOCK)
		WHERE [ClientMembershipSSID] NOT
		IN (
				SELECT SRC.ClientMembershipGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datClientMembership] SRC WITH (NOLOCK)
				)
		AND [ClientMembershipKey] <> -1


END
GO
