-- =============================================
-- Author:		rrojas
-- Create date:
-- Description:	Get Inventory Scan Report
-- =============================================
create procedure spSelRptGetInventoryScanProgress
	-- Add the parameters for the stored procedure here
       @CenterID nvarchar(max),
	   @snapshotDate nvarchar(max),
	   @statusId nvarchar(max)
	   AS
		 BEGIN
				-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with SELECT statements.
					SET NOCOUNT ON;
			    --Insert statements for procedure here
		select 
			RegionDescription,
			cfgCenter.CenterDescription,CfgCenter.CenterId, 
            cfgCenter.CenterNumber ,
			datSerializedInventoryAuditBatch.LastUpdateUser, 
            datSerializedInventoryAuditBatch.LastUpdate,
			snapshotDate,
			bs.InventoryAuditBatchStatusDescription 
			from datSerializedInventoryAuditSnapshot
			join datSerializedInventoryAuditBatch on datSerializedInventoryAuditBatch.SerializedInventoryAuditSnapshotID = datSerializedInventoryAuditSnapshot.SerializedInventoryAuditSnapshotID
			join cfgCenter on cfgCenter.CenterID = datSerializedInventoryAuditBatch.CenterID
			join lkpRegion on lkpRegion.RegionID = cfgCenter.RegionID
			join lkpInventoryAuditBatchStatus bs on datSerializedInventoryAuditBatch.InventoryAuditBatchStatusID=bs.InventoryAuditBatchStatusID
			where cfgCenter.CenterId in (select value from string_split(@centerId, ',')  where rtrim(value) <> '') 
		    and cast(snapshotDate as date)=@snapshotDate  
			and datSerializedInventoryAuditBatch.InventoryAuditBatchStatusID in 
			(select value from string_split(@statusId, ',')  where rtrim(value) <> '') 
			order by SnapshotDate,cfgCenter.CenterId desc
		 end
