/* CreateDate: 05/13/2010 16:38:34.777 , ModifyDate: 10/26/2011 16:08:34.110 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckReferentialIntegrity]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckReferentialIntegrity]
--
-- EXEC [bi_health].[spHC_CheckReferentialIntegrity]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN


DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckReferentialIntegrity'

Exec  bi_health.spHC_CheckReferentialIntegrity_CMS

Exec  bi_health.spHC_CheckReferentialIntegrity_MKTG


END
GO
