/* CreateDate: 08/19/2021 23:17:19.280 , ModifyDate: 08/19/2021 23:17:19.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		rrojas
-- Create date:
-- Description:	Get non serialized inventory Scan Progress
-- =============================================
create procedure selRptGetNonSerializedInventoryScanProgress
	-- Add the parameters for the stored procedure here
		@snapshotDate nvarchar(max),
			@statusId nvarchar(max),
			@centerId nvarchar(max)
			as
			begin
				-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with SELECT statements.
						set nocount on;
                    -- Insert statements for procedure here
		select
			RegionDescription,
			cen.CenterDescription,
			cen.CenterId,
            cen.CenterNumber ,
			nSiaB.LastUpdateUser,
            nSiaB.LastUpdate,
			snapshotDate,
			bs.InventoryAuditBatchStatusDescription
			from datNonSerializedInventoryAuditSnapshot nSiaS
			join datNonSerializedInventoryAuditBatch nSiaB on nSiaB.NonSerializedInventoryAuditSnapshotID = nsias.NonSerializedInventoryAuditSnapshotID
			join cfgCenter cen on cen.CenterID = nSiaB.CenterID
			join lkpRegion  reg on reg.RegionID = cen.RegionID
			join lkpInventoryAuditBatchStatus bs on nSiaB.InventoryAuditBatchStatusID=bs.InventoryAuditBatchStatusID
			where cen.CenterId in (select value from string_split(@centerId, ',')  where rtrim(value) <> '')
		    and cast(snapshotDate as date)=@snapshotDate
			and nSiaB.InventoryAuditBatchStatusID in
			(select value from string_split(@statusId, ',')  where rtrim(value) <> '')
			order by nsias.SnapshotDate,cen.CenterId desc

		    end
GO
