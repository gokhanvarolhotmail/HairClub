/* CreateDate: 12/05/2012 17:19:47.353 , ModifyDate: 12/11/2012 16:37:30.173 */
GO
CREATE PROCEDURE [bi_health].[spHC_RPT_HealthStatusDetail]
   @TheProcess varchar(50),
   @TheTable varchar(50)
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

DECLARE @RC int
SELECT     asdId, stat.AuditProcessName, stat.TableName, IN_FieldKey, IN_FieldSSID, MI_MissingDate, MI_RecordID, MI_CreatedDate, MI_UpdateDate, EX_FieldKey, EX_FieldSSID,
                      RI_DimensionName, RI_FieldName, RI_FieldKey, dtl.AB_DataPkgKey, AB_ProcessDate, dtl.AB_NumRecordsInTable, dtl.AB_NumRecordsWithExceptions, AB_Status,
                      CreateDate, SB_Date, SB_Center, SB_SourceCount, SB_WarehouseCount, SB_SourceMoney, SB_WarehouseMoney, SB_CountDifference, SB_MoneyDifference,
                      CC_MinCDCDate, CC_DataFlowDate,
AuditMessage =
case
   when stat.AuditProcessName='CheckAbandoned' then 'DataPkgKey: ' + Convert(varchar(10), dtl.AB_DataPkgKey) + ' date: ' + Convert(varchar(20), dtl.AB_ProcessDate) +
             '  Rows abandoned: ' + convert(varchar(10), dtl.AB_NumRecordsInTable) + '  Rows in Error:' + convert(varchar(10), dtl.AB_NumRecordsWithExceptions) +
			 case when dtl.AB_NumRecordsWithExceptions>0 then ' Msg: '  + dtl.AB_Status else '' end
   when stat.AuditProcessName='CheckCounts' then 'Number of rows in Source: ' + Convert(varchar(10), stat.CT_NumRecordsInSource) + '  Replicated: ' + convert(varchar(10), stat.CT_NumRecordsInReplicatedSource)  + '  DataWarehouse: ' + convert(varchar(10), stat.CT_NumRecordsInWarehouse)
   when stat.AuditProcessName='CheckInferred' then 'Inferred table key and SourceSystemKey are listed'
   when stat.AuditProcessName='CheckExtra' then 'Extra table key and SourceSystemKey are listed'
   when stat.AuditProcessName='CheckMissing' then 'Missing row CreateDate: ' + Convert(varchar(20), dtl.MI_CreatedDate) + '  UpdateDate: ' + Convert(varchar(20), dtl.MI_UpdateDate) +  '  SourceSystemKey is listed'
   when stat.AuditProcessName='Bal_ShowsPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_NoShowsPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_BeBacksPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_ConsultsPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_SalesPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_LeadsPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='Bal_ApptsPerDay' then case when stat.AuditProcessStatus = 1 then 'In balance.' else 'Number of rows in Source: ' + Convert(varchar(10), dtl.SB_SourceCount) +  '  DataWarehouse: ' + convert(varchar(10), dtl.SB_WarehouseCount) + ' for date ' + convert(varchar(20), dtl.SB_Date) end
   when stat.AuditProcessName='CheckCDCDates' then 'Earliest Available Log date: ' + Convert(varchar(20), dtl.CC_MinCDCDate) + '  DataFlowDate: ' + Convert(varchar(20), dtl.CC_DataFlowDate)
   when stat.AuditProcessName='CheckAgentJobsEnabled' then case when stat.AuditProcessStatus = 1 then 'Job is Enabled.' else 'Job is Disabled!' end
   when stat.AuditProcessName='CheckReferentialIntegrity' then case when stat.AuditProcessStatus = 1 then 'Referential Integrity in tact.' else 'Did not find ' + dtl.RI_FieldName + ' ' + Convert(varchar(12), dtl.RI_FieldKey) + ' in referenced table ' + dtl.RI_DimensionName end
   when stat.AuditProcessName='CheckRecentJobFailures' then case when stat.AuditProcessStatus = 1 then 'No recent failures.' else 'Job failed at ' + Convert(varchar(20), stat.JF_RunDate) end
else '' end,
DWKey =
case
   when stat.AuditProcessName='CheckInferred' then IN_FieldKey
   when stat.AuditProcessName='CheckExtra' then EX_FieldKey
else null end,

SourceSystemKey=
case
   when stat.AuditProcessName='CheckInferred' then IN_FieldSSID
   when stat.AuditProcessName='CheckMissing' then MI_RecordID
   when stat.AuditProcessName='CheckExtra' then EX_FieldSSID

else NULL end


FROM        dbo.AuditStatus  stat
left join        dbo.AuditStatusDetail dtl  ON dtl.AuditProcessName=stat.AuditProcessName AND dtl.TableName=stat.TableName
where
stat.AuditProcessName= @TheProcess AND stat.TableName=@TheTable


END
GO
