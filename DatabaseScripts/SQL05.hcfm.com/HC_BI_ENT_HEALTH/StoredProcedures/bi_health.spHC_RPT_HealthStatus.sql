/* CreateDate: 01/04/2013 12:35:02.500 , ModifyDate: 01/09/2013 14:34:55.763 */
GO
CREATE PROCEDURE [bi_health].[spHC_RPT_HealthStatus]

AS

-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp       Initial Creation
-----------------------------------------------------------------------

BEGIN


select   [asId]
      ,[AuditProcessName]
      ,[TableName]
      ,[AB_DataPkgKey]
      ,[AB_NumRecordsInTable]
      ,[AB_NumRecordsWithExceptions]
      ,[CT_NumRecordsinSource]
      ,[CT_NumRecordsinReplicatedSource]
      ,[CT_NumRecordsinWarehouse]
      ,[IN_NumOfRecords]
      ,[MI_NumOfRecords]
      ,[EX_NumOfRecords]
      ,[RI_NumOfRecords]
      ,[AuditProcessStatus]+1 as AuditProcessStatus
      ,[SB_NumOfRecords]
      ,[JF_RunDate]
	  ,[Message] = case when AuditProcessStatus=1 then ''
					    else
						 case when AuditProcessName = 'CheckAbandoned' then case when AuditProcessStatus = -1 then 'Rows Abandoned with Exceptions: ' + [bi_health].[fnHC_FormatANumber](AB_NumRecordsWithExceptions)  else 'Rows Abandoned: ' + [bi_health].[fnHC_FormatANumber](AB_NumRecordsInTable) end
						      when AuditProcessName = 'CheckCounts' then 'Rows in Source: ' + [bi_health].[fnHC_FormatANumber](CT_NumRecordsinSource) + '  Replicated: ' + [bi_health].[fnHC_FormatANumber](CT_NumRecordsinReplicatedSource) + '  Warehouse: ' + [bi_health].[fnHC_FormatANumber](CT_NumRecordsinWarehouse)
						      when AuditProcessName = 'CheckExtra' then 'Extra row count: ' + [bi_health].[fnHC_FormatANumber](EX_NumOfRecords)
							  when AuditProcessName = 'CheckInferred' then 'Inferred row count: ' + [bi_health].[fnHC_FormatANumber](IN_NumOfRecords)
							  when AuditProcessName IN ('Bal_ApptsPerDay','Bal_BeBacksPerDay','Bal_ConsultsPerDay','Bal_LeadsPerDay','Bal_NoShowsPerDay','Bal_SalesPerDay','Bal_ShowsPerDay') then 'Days Out of Balance: ' + [bi_health].[fnHC_FormatANumber](SB_NumOfRecords)
							  when AuditProcessName = 'CheckMissing' then 'Missing row count: ' + [bi_health].[fnHC_FormatANumber](MI_NumOfRecords) 						      else ''
						  end
					end
       FROM [HC_BI_ENT_HEALTH].[dbo].[AuditStatus] with (nolock) order by AuditProcessStatus


END
GO
