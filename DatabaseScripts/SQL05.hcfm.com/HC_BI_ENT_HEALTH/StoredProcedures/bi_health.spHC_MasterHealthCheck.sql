/* CreateDate: 10/26/2011 16:35:34.130 , ModifyDate: 11/28/2012 14:42:02.167 */
GO
CREATE PROCEDURE [bi_health].[spHC_MasterHealthCheck]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_MasterHealthCheck]
--
-- EXEC [bi_health].[spHC_MasterHealthCheck]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			   EKnapp       Initial Creation
--          11/28/2012 EKnapp		commented out spHC_CheckWarehouseCounts. It is not writing to any of the audit tables in this proc- does in SPRPT_AuditStatusHealthCheck.
-----------------------------------------------------------------------

BEGIN
	TRUNCATE TABLE dbo.AuditStatusDetail

	EXEC  bi_health.spHC_CheckAbandonedStageData

	EXEC  bi_health.spHC_CheckExtraRecordsInWarehouse

	EXEC  bi_health.spHC_CheckForMissingRecords

	EXEC  bi_health.spHC_CheckInferredMembers

	EXEC  bi_health.spHC_CheckReferentialIntegrity

	--EXEC  bi_health.spHC_CheckWarehouseCounts

	EXEC  bi_health.spHC_CheckCDCDates

	EXEC  bi_health.spHC_CheckBalanceToSource_MKTG


END
GO
