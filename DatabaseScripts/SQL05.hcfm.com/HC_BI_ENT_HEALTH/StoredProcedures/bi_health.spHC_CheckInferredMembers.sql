/* CreateDate: 05/13/2010 16:37:30.470 , ModifyDate: 10/26/2011 16:42:14.820 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckInferredMembers]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckInferredMembers]
--
-- EXEC [bi_health].[spHC_CheckInferredMembers]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN


DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckInferred'

Exec  bi_health.spHC_CheckInferredMembers_CMS

Exec  bi_health.spHC_CheckInferredMembers_ENT

Exec  bi_health.spHC_CheckInferredMembers_MKTG


END
GO
