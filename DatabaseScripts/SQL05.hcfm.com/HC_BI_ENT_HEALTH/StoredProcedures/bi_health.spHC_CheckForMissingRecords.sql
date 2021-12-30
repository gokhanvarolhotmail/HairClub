/* CreateDate: 05/13/2010 16:41:08.297 , ModifyDate: 10/26/2011 16:03:01.773 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckForMissingRecords]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckForMissingRecords]
--
-- EXEC [bi_health].[spHC_CheckForMissingRecords]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'MissingRecords'

Exec  bi_health.spHC_CheckForMissingRecords_CMS

Exec  bi_health.spHC_CheckForMissingRecords_ENT

Exec  bi_health.spHC_CheckForMissingRecords_MKTG



END
GO
