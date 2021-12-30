/* CreateDate: 10/27/2011 14:34:44.147 , ModifyDate: 12/14/2012 15:17:07.187 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckBalanceToSource_MKTG]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckBalanceToSource_MKTG]
--
-- EXEC [bi_health].[spHC_CheckBalanceToSource_MKTG]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10/26/11  KMurdoch     Initial Creation
-----------------------------------------------------------------------
DECLARE @FromDate datetime, @ToDate datetime
BEGIN

SET @FromDate=GETDATE()-8
--SET @FromDate = '01/01/07'
SET @ToDate = GETDATE()-1

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_LeadsPerDay'

EXEC bi_health.spHC_CheckBal_FactLead_LeadsPerDay   @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_ApptsPerDay'

EXEC  bi_health.spHC_CheckBal_FactActivityResults_ApptsPerDay  @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_BeBacksPerDay'

EXEC  bi_health.spHC_CheckBal_FactActivityResults_BeBacksPerDay  @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_ConsultsPerDay'

EXEC  bi_health.spHC_CheckBal_FactActivityResults_ConsultsPerDay  @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_NoShowsPerDay'

EXEC bi_health.spHC_CheckBal_FactActivityResults_NoShowsPerDay   @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_SalesPerDay'

EXEC bi_health.spHC_CheckBal_FactActivityResults_SalesPerDay   @FromDate, @ToDate

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'Bal_ShowsPerDay'

EXEC bi_health.spHC_CheckBal_FactActivityResults_ShowsPerDay  @FromDate, @ToDate


END
GO
