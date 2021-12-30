/* CreateDate: 10/26/2011 16:03:51.380 , ModifyDate: 10/26/2011 16:22:19.373 */
GO
CREATE PROCEDURE [bi_health].[spHC_CheckAbandonedStageData]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_CheckAbandonedStageData]
--
-- EXEC [bi_health].[spHC_CheckAbandonedStageData]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  MBurrell       Initial Creation
-----------------------------------------------------------------------
DECLARE @FromDate datetime, @ToDate datetime
BEGIN

SET @FromDate=GETDATE()-7
SET @ToDate = GETDATE()-1

DELETE FROM HC_BI_ENT_HEALTH.dbo.AuditStatusDetail WHERE AuditProcessName = 'CheckAbandoned'

EXEC  bi_health.spHC_CheckAbandonedStageData_CMS  @FromDate, @ToDate

EXEC  bi_health.spHC_CheckAbandonedStageData_ENT  @FromDate, @ToDate

EXEC  bi_health.spHC_CheckAbandonedStageData_MKTG  @FromDate, @ToDate



END
GO
