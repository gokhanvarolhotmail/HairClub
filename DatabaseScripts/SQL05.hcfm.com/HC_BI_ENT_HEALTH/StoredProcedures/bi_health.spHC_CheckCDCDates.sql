/* CreateDate: 10/27/2011 13:51:45.467 , ModifyDate: 10/27/2011 13:51:45.467 */
GO
create PROCEDURE [bi_health].[spHC_CheckCDCDates]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckCDCDates]
--
-- EXEC [bi_health].[spHC_CheckCDCDates]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckCDCDates'

Exec  bi_health.spHC_CheckCDCDates_CMS

Exec  bi_health.spHC_CheckCDCDates_MKT

--Exec  bi_health.spHC_CheckCDCDates_ENT



END
GO
