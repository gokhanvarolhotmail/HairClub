/* CreateDate: 10/26/2011 16:11:13.597 , ModifyDate: 10/26/2011 16:11:13.597 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckExtraRecordsInWarehouse]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckExtraRecordsInWarehouse]
--
-- EXEC [bi_health].[spHC_CheckExtraRecordsInWarehouse]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  MBurrell       Initial Creation
-----------------------------------------------------------------------

BEGIN

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckExtra'

EXEC  bi_health.[spHC_CheckExtraRecordsInWarehouse_MKTG]

EXEC  bi_health.[spHC_CheckExtraRecordsInWarehouse_CMS]


END
GO
